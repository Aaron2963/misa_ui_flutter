import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:misa_ui_flutter/controller/settings.dart';
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
    final response = await httpClient.get(Uri.parse(dotenv.env['SCHEMA_ROOT_URL']! + uri));
    final responseBody = utf8.decoder.convert(response.bodyBytes);
    storage[uri] = PageSchema.fromJson(jsonDecode(responseBody), uri);
    return true;
  }

  PageSchema? getSchemaByUri(String uri) {
    return storage[uri];
  }
}
