import 'package:flutter/material.dart';
import 'package:misa_ui_flutter/model/menu_item.dart' as model;
import 'package:misa_ui_flutter/settings/misa_locale.dart';
import 'package:provider/provider.dart';

class ViewMenuItem extends StatefulWidget {
  final model.ViewMenuItem menuItem;
  const ViewMenuItem({super.key, required this.menuItem});

  @override
  State<ViewMenuItem> createState() => _ViewMenuItemState();
}

class _ViewMenuItemState extends State<ViewMenuItem> {
  bool isHovered = false;
  bool isActive = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.menuItem;
    return InkWell(
      onTap: () => setState(() => isActive = !isActive),
      onHover: (value) => setState(() => isHovered = value),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                item.icon != null ? Icon(
                  item.icon,
                  color: Colors.white,
                ) : const SizedBox(width: 24),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    context.watch<MisaLocale>().translate(item.title),
                    style: TextStyle(
                      fontWeight: isHovered || isActive ? FontWeight.bold : FontWeight.normal,
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
