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

  Map<String, dynamic> output(ObjectJsonSchema schema) {
    Map<String, dynamic> output = {};
    // TODO: implement output
    return output;
  }

  @override
  String toString() => _cache.toString();
}
