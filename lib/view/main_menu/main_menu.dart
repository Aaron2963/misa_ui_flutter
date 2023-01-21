import 'package:flutter/material.dart';
import 'package:misa_ui_flutter/controller/menu_controller.dart';
import 'package:misa_ui_flutter/model/menu_item.dart' as model;
import 'package:misa_ui_flutter/settings/view_settings.dart';
import 'package:misa_ui_flutter/view/main_menu/folder_menu_item.dart';

final _controller = MenuController();

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  final ViewSettings _viewSettings = ViewSettings();
  List<model.MisaMenuItem> _items = [];

  @override
  void initState() {
    _controller.get().then((value) => setState(() => _items = value));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _viewSettings.backgroundColor,
      child: ListView(
        children: _items
            .map((e) => FolderMenuItem(menuItem: e as model.FolderMenuItem))
            .toList()
            .cast<Widget>(),
      ),
    );
  }
}