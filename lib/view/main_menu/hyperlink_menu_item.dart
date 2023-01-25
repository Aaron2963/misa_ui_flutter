import 'package:flutter/material.dart';
import 'package:misa_ui_flutter/model/menu_item.dart' as model;
import 'package:misa_ui_flutter/settings/misa_locale.dart';
import 'package:misa_ui_flutter/view/main_menu/main_menu.dart';
import 'package:provider/provider.dart';

class HyperlinkMenuItem extends StatefulWidget {
  final model.HyperlinkMenuItem menuItem;
  const HyperlinkMenuItem({super.key, required this.menuItem});

  @override
  State<HyperlinkMenuItem> createState() => _HyperlinkMenuItemState();
}

class _HyperlinkMenuItemState extends State<HyperlinkMenuItem> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.menuItem;
    final Key? activeKey = context.watch<MainMenuStateProvider>().activeKey;
    bool isActive = activeKey != null && activeKey == widget.key;
    return InkWell(
      onTap: () => setState(() =>
          context.read<MainMenuStateProvider>().setActiveKey(widget.key, item)),
      onHover: (value) => setState(() => isHovered = value),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                item.icon != null
                    ? Icon(
                        item.icon,
                        color: Colors.white,
                      )
                    : const SizedBox(width: 24),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    context.watch<MisaLocale>().translate(item.title),
                    style: TextStyle(
                      fontWeight: isHovered || isActive
                          ? FontWeight.bold
                          : FontWeight.normal,
                      decoration: isActive
                          ? TextDecoration.underline
                          : TextDecoration.none,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
