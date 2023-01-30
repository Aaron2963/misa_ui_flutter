import 'package:flutter/material.dart';
import 'package:misa_ui_flutter/model/menu_item.dart';
import 'package:misa_ui_flutter/model/page_schema.dart';
import 'package:misa_ui_flutter/view/body/feature_bar/feature_bar.dart';
import 'package:provider/provider.dart';

class ListViewBody extends StatefulWidget {
  final PageSchema pageSchema;
  final ViewMenuItem viewMenuItem;
  const ListViewBody({super.key, required this.pageSchema, required this.viewMenuItem});

  @override
  State<ListViewBody> createState() => _ListViewBodyState();
}

class _ListViewBodyState extends State<ListViewBody> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ListViewBodyStateProvider(),
      child: Column(
        children: [
          FeatureBar(
              pageSchema: widget.pageSchema, viewMenuItem: widget.viewMenuItem),
          const Expanded(
              child: Padding(
            padding: EdgeInsets.all(16.0),
            child: _ListViewTable(),
          )),
        ],
      ),
    );
  }
}

class _ListViewTable extends StatefulWidget {
  const _ListViewTable();

  @override
  State<_ListViewTable> createState() => _ListViewTableState();
}

class _ListViewTableState extends State<_ListViewTable> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class ListViewBodyStateProvider extends ChangeNotifier {
  int currentPage = 1;
  int totalPage = 1;
  void setCurrentPage(int page, {int total = 1}) {
    currentPage = page;
    totalPage = total;
    notifyListeners();
  }
}
