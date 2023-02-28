import 'package:flutter/material.dart';
import 'package:misa_ui_flutter/model/data_payload.dart';
import 'package:misa_ui_flutter/model/menu_item.dart';
import 'package:misa_ui_flutter/view/body/advanced_view.dart';
import 'package:misa_ui_flutter/view/body/body.dart';
import 'package:misa_ui_flutter/view/body/page_body/detail_view_body.dart';
import 'package:misa_ui_flutter/view/body/page_body/form_view_body.dart';
import 'package:misa_ui_flutter/view/body/page_body/list_view_body.dart';
import 'package:provider/provider.dart';

class PageBody extends StatelessWidget {
  const PageBody({super.key});

  @override
  Widget build(BuildContext context) {
    final viewMenuItem = context.watch<BodyStateProvider>().viewMenuItem;
    final advancedView = context.watch<BodyStateProvider>().advancedView;
    if (viewMenuItem == null) {
      return const Center(
        child: Text("No schema or view type"),
      );
    }
    if (advancedView != null && advancedView.viewMode == ViewMode.form) {
      return SingleChildScrollView(
        child: FormViewBody(
          key: Key('formView-${viewMenuItem.title}'),
          payload: DataPayload.single(advancedView.data.first),
        ),
      );
    }
    if (viewMenuItem.viewType == ViewType.list) {
      if (advancedView == null || advancedView.viewMode == ViewMode.root) {
        return SingleChildScrollView(
          child: ListViewBody(key: Key('listView-${viewMenuItem.title}')),
        );
      }
      if (advancedView.viewMode == ViewMode.detail) {
        return SingleChildScrollView(
          child: DetailViewBody(
            key: Key('detailView-${viewMenuItem.title}'),
            payload: DataPayload.single(advancedView.data.first),
          ),
        );
      }
    }
    if (viewMenuItem.viewType == ViewType.detail) {
      return SingleChildScrollView(
        child: DetailViewBody(key: Key('detailView-${viewMenuItem.title}')),
      );
    }
    return Text(
        'Current View Type: ${viewMenuItem.viewType.toString().split('.').last}; Current View Mode: ${advancedView?.viewMode.toString().split('.').last}');
  }
}
