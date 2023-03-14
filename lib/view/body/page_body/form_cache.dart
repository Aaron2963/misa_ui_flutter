import 'dart:convert';

import 'package:misa_ui_flutter/model/json_schema/array_json_schema.dart';
import 'package:misa_ui_flutter/model/json_schema/json_schema.dart';
import 'package:misa_ui_flutter/model/json_schema/object_json_schema.dart';

class FormCache {
  // ignore: prefer_final_fields
  Map<String, dynamic> _cache = {};

  FormCache(Map<String, dynamic> data) {
    _cache = data;
    List<Map<String, dynamic>> queue = [_cache];
    while (queue.isNotEmpty) {
      Map<String, dynamic> current = queue.removeAt(0);
      for (String key in current.keys) {
        if (current[key] is Map) {
          queue.add(current[key]);
        } else if (current[key] is List) {
          current[key] = Map.fromIterables(
            List.generate(current[key].length, (i) => i.toString()),
            current[key],
          );
          current[key]['@sequence'] = current[key].keys.toList();
        }
      }
    }
  }

  Map<String, dynamic> get cache => _cache;

  void set(String key, dynamic value, [List parentKeys = const []]) {
    List parents = List.from(parentKeys);
    if (key.length > 2 &&
        key.substring(key.length - 2) == '[]' &&
        parents.isNotEmpty) {
      key = parents.last.toString();
      parents.removeLast();
    }
    Map<String, dynamic> parent = _cache;
    for (var i = 0; i < parents.length; i++) {
      String pk = parents[i].toString();
      if (pk.length > 2 && pk.substring(pk.length - 2) == '[]') {
        continue;
      }
      if (parent[pk] == null) {
        parent[pk] = {};
      }
      parent = parent[pk].cast<String, dynamic>();
    }
    if (value == null) {
      parent.remove(key);
      return;
    }
    parent[key] = value;
  }

  dynamic output(JsonSchema schema, [dynamic data]) {
    data = data ?? jsonDecode(jsonEncode(_cache));
    if (schema.type == SchemaDataType.object) {
      Map<String, dynamic> result = {};
      final sch = schema as ObjectJsonSchema;
      for (JsonSchema prop in sch.properties!.values) {
        result[prop.key] = output(prop, data[prop.key]);
      }
      return result;
    } else if (schema.type == SchemaDataType.array) {
      final sch = schema as ArrayJsonSchema;
      List result = [];
      for (int i = 0; i < data['@sequence'].length; i++) {
        String k = data['@sequence'][i].toString();
        result.add(output(sch.items, data[k]));
      }
      return result;
    }
    return data;
  }

  @override
  String toString() => _cache.toString();
}

class FormSegmentInterAction {
  // ignore: prefer_final_fields
  Map<String, Map<CompareEvent, Set<String>>> _triggers = {};

  void register(String actingKey, Map<String, CompareEvent?> compare) {
    for (String triggerKey in compare.keys) {
      CompareEvent? event = compare[triggerKey];
      if (event == null) continue;
      _triggers.putIfAbsent(triggerKey, () => <CompareEvent, Set<String>>{});
      _triggers[triggerKey]!.putIfAbsent(event, () => <String>{});
      _triggers[triggerKey]![event]!.add(actingKey);
    }
  }

  bool hasTrigger(String triggerKey) {
    return _triggers.containsKey(triggerKey);
  }

  Set<CompareEvent> getEvents(String triggerKey) {
    if (!_triggers.containsKey(triggerKey)) return <CompareEvent>{};
    return _triggers[triggerKey]!.keys.toSet();
  }

  bool hasEvent(String triggerKey, CompareEvent event) {
    if (!_triggers.containsKey(triggerKey)) return false;
    return _triggers[triggerKey]!.containsKey(event);
  }

  Set<String> getActingKeys(String triggerKey, CompareEvent event) {
    if (!_triggers.containsKey(triggerKey)) return <String>{};
    if (!_triggers[triggerKey]!.containsKey(event)) return <String>{};
    return _triggers[triggerKey]![event]!.toSet();
  }

  @override
  String toString() => _triggers.toString();
}
