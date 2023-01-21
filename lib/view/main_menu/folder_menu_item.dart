import 'package:flutter/material.dart';
import 'package:misa_ui_flutter/model/menu_item.dart' as model;
import 'package:misa_ui_flutter/settings/misa_locale.dart';
import 'package:misa_ui_flutter/view/main_menu/hyperlink_menu_item.dart';
import 'package:misa_ui_flutter/view/main_menu/view_menu_item.dart';
import 'package:provider/provider.dart';

class FolderMenuItem extends StatefulWidget {
  final model.FolderMenuItem menuItem;
  const FolderMenuItem({super.key, required this.menuItem});

  @override
  State<FolderMenuItem> createState() => _FolderMenuItemState();
}

class _FolderMenuItemState extends State<FolderMenuItem> {
  bool isHovered = false;
  bool isFold = true;

  Widget buildChild(model.MisaMenuItem item) {
    if (item is model.ViewMenuItem) {
      return ViewMenuItem(menuItem: item);
    } else if (item is model.HyperlinkMenuItem) {
      return HyperlinkMenuItem(menuItem: item);
    } else if (item is model.FolderMenuItem) {
      return FolderMenuItem(menuItem: item);
    } else {
      return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.menuItem;
    Color bg = isFold ? Colors.transparent : Colors.white12;
    return InkWell(
      onTap: () => setState(() => isFold = !isFold),
      onHover: (value) => setState(() => isHovered = value),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            color: bg,
            child: Row(
              children: [
                Icon(
                  item.icon,
                  color: Colors.white,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    context.watch<MisaLocale>().translate(item.title),
                    style: TextStyle(
                      fontWeight:
                          isHovered ? FontWeight.bold : FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: bg,
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              children:
                  isFold ? <Widget>[] : item.children.map(buildChild).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
