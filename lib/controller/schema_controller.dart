import 'package:misa_ui_flutter/controller/mock/schema.dart';
import 'package:misa_ui_flutter/model/page_schema.dart';

class SchemaController {
  Map<String, PageSchema> storage = {};

  // singleton
  static final SchemaController _instance = SchemaController._internal();
  factory SchemaController() => _instance;
  SchemaController._internal();

  Future<bool> setStorageFromMenu(Map<String, dynamic> menu) async {
    List queue = menu.values.toList();
    while (queue.isNotEmpty) {
      var item = queue.removeAt(0);
      if (item.containsKey('items')) {
        queue.addAll(item['items'].values);
      }
      if (item.containsKey('views')) {
        for (var view in item['views']) {
          await setStorage(view['schema']['\$ref']);
        }
      }
    }
    return true;
  }

  Future<bool> setStorage(String uri) async {
    // TODO: get schema from server
    storage[uri] = PageSchema.fromJson(mockSchema);
    print('schema set: $uri : ${storage[uri]?.title ?? ''}');
    return true;
  }

  PageSchema? getSchemaByUri(String uri) {
    print('getSchemaByUri: $uri : ${storage[uri]?.title ?? ''}');
    return storage[uri];
  }
}
