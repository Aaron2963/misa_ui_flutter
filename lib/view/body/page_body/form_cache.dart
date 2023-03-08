import 'package:misa_ui_flutter/model/json_schema/array_json_schema.dart';
import 'package:misa_ui_flutter/model/json_schema/json_schema.dart';
import 'package:misa_ui_flutter/model/json_schema/object_json_schema.dart';

class FormCache {
  // ignore: prefer_final_fields
  Map<String, dynamic> _cache = {};

  FormCache(Map<String, dynamic> data) {
    _cache = data;
    for (var key in _cache.keys) {
      if (_cache[key] is List) {
        _cache[key] = Map.fromIterables(
          List.generate(_cache[key].length, (i) => i.toString()),
          _cache[key],
        );
      }
    }
  }

  Map<String, dynamic> get cache => _cache;

  void set(String key, dynamic value, [List parentKeys = const []]) {
    Map<String, dynamic> parent = _cache;
    for (var i = 0; i < parentKeys.length; i++) {
      String pk = parentKeys[i].toString();
      if (parent[pk] == null) {
        parent[pk] = {};
      }
      parent = parent[pk].cast<String, dynamic>();
    }
    parent[key] = value;
  }

  dynamic output(JsonSchema schema, [dynamic data]) {
    data = data ?? _cache;
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
      for (String k in data.keys) {
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

  @override
  String toString() => _triggers.toString();
}
