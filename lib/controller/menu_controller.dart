import 'package:misa_ui_flutter/controller/mock/menu.dart';
import 'package:misa_ui_flutter/controller/schema_controller.dart';
import 'package:misa_ui_flutter/model/menu_item.dart';

final SchemaController _schemaController = SchemaController();

class MenuController {
  Future<List<MisaMenuItem>> get() async {
    //TODO: get menu from server
    Map<String, dynamic> menu = mockMenu; // demo
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
}
