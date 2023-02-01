import 'package:flutter/material.dart';
import 'package:misa_ui_flutter/model/menu_item.dart';

class RichDialog extends StatelessWidget {
  final Widget content;
  final String? title;
  final List<Widget> actions;
  final ViewType? viewType;
  const RichDialog({
    super.key,
    required this.content,
    this.title,
    this.actions = const [],
    this.viewType,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title ?? ''),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      content: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
          maxWidth: MediaQuery.of(context).size.width * 0.8,
          minWidth: MediaQuery.of(context).size.width * 0.5,
        ),
        child: SingleChildScrollView(child: content),
      ),
      actions: actions,
    );
  }
}
