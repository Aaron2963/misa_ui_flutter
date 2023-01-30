import 'package:flutter/material.dart';
import 'package:misa_ui_flutter/model/menu_item.dart';
import 'package:misa_ui_flutter/model/page_schema.dart';
import 'package:misa_ui_flutter/view/body/feature_bar/filter_feature.dart';
import 'package:misa_ui_flutter/view/body/feature_bar/pagination.dart';
import 'package:misa_ui_flutter/view/body/list_view_body.dart';
import 'package:provider/provider.dart';

class FeatureBar extends StatelessWidget {
  final PageSchema pageSchema;
  final ViewMenuItem viewMenuItem;
  const FeatureBar({
    super.key,
    required this.pageSchema,
    required this.viewMenuItem,
  });

  @override
  Widget build(BuildContext context) {
    final int currentPage =
        context.watch<ListViewBodyStateProvider>().currentPage;
    final int totalPage = context.watch<ListViewBodyStateProvider>().totalPage;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _LeftButtons(viewMenuItem: viewMenuItem, pageSchema: pageSchema),
        PaginationBar(current: currentPage, total: totalPage),
      ],
    );
  }
}

class _LeftButtons extends StatelessWidget {
  final ViewMenuItem viewMenuItem;
  final PageSchema pageSchema;
  const _LeftButtons({required this.viewMenuItem, required this.pageSchema});

  Widget? _buildButton(BuildContext context, ViewFeature feature) {
    switch (feature) {
      case ViewFeature.filter:
        return const FilterFeature();
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> buttons = [];
    for (ViewFeature feature in viewMenuItem.features) {
      Widget? button = _buildButton(context, feature);
      if (button != null) {
        buttons.add(button);
      }
    }
    return Row(
      children: buttons,
    );
  }
}
