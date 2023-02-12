import 'package:flutter/material.dart';
import 'package:misa_ui_flutter/model/menu_item.dart';
import 'package:misa_ui_flutter/view/body/body.dart';
import 'package:misa_ui_flutter/view/body/page_body/list_view_body.dart';
import 'package:provider/provider.dart';

class PageBody extends StatelessWidget {
  const PageBody({super.key});

  @override
  Widget build(BuildContext context) {
    final viewMenuItem = context.watch<BodyStateProvider>().viewMenuItem;
    if (viewMenuItem == null) {
      return const Center(
        child: Text("No schema or view type"),
      );
    }
    if (viewMenuItem.viewType == ViewType.list) {
      return SingleChildScrollView(
        child: ListViewBody(key: Key('listView-${viewMenuItem.title}')),
      );
    }
    return Text(
        'Current View Type: ${viewMenuItem.viewType.toString().split('.').last}');
  }
}
