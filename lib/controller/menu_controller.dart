import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:misa_ui_flutter/controller/auth_controller.dart';
import 'package:misa_ui_flutter/controller/router_mapping.dart';
import 'package:misa_ui_flutter/controller/schema_controller.dart';
import 'package:misa_ui_flutter/model/menu_item.dart';
import 'package:http/http.dart' as http;

final SchemaController _schemaController = SchemaController();

class MenuController {
  final Uri apiUrl = Uri.parse(dotenv.env['MENU_API_URL'] as String);
  final Uri routerUrl = Uri.parse(dotenv.env['ROUTER_API_URL'] as String);

  Future<List<MisaMenuItem>> get() async {
    Map<String, dynamic> menu = await fetch();
    await fetchRouters();

    // handle menu
    await _schemaController.setStorageFromMenu(menu);
    List<MisaMenuItem> result = [];
    for (String k in menu.keys) {
      if (menu[k].containsKey('items')) {
        result.add(FolderMenuItem.fromJson(menu[k], title: k));
      }
      // if item has 'views' key, push to result as ViewMenuItem
      if (menu[k].containsKey('views')) {
        result.add(ViewMenuItem.fromJson(menu[k], title: k));
      }
      // if item has 'href' key, push to result as HyperlinkMenuItem
      if (menu[k].containsKey('href')) {
        result.add(HyperlinkMenuItem.fromJson(menu[k], title: k));
      }
    }
    return result;
  }

  Future<Map<String, dynamic>> fetch() async {
    final response = await http
        .get(apiUrl, headers: {'Authorization': AuthController.bearerToken});
    if (response.statusCode == 200) {
      final responseBody = utf8.decoder.convert(response.bodyBytes);
      return Map<String, dynamic>.from(jsonDecode(responseBody));
    } else {
      throw Exception('Failed to load menu');
    }
  }

  Future fetchRouters() async {
    final response = await http.get(routerUrl);
    if (response.statusCode == 200) {
      final responseBody = utf8.decoder.convert(response.bodyBytes);
      final json = Map<String, dynamic>.from(jsonDecode(responseBody));
      for (String k in json.keys) {
        for (String v in json[k].keys) {
          RouterMapping.add(k, v, json[k][v]);
        }
      }
    } else {
      throw Exception('Failed to load menu');
    }
    return;
  }
}
