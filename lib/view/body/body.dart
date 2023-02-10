import 'package:flutter/material.dart';
import 'package:misa_ui_flutter/controller/data_controller.dart';
import 'package:misa_ui_flutter/model/data_payload.dart';
import 'package:misa_ui_flutter/model/page_schema.dart';
import 'package:misa_ui_flutter/model/menu_item.dart';
import 'package:misa_ui_flutter/model/query_filter.dart';
import 'package:misa_ui_flutter/settings/misa_locale.dart';
import 'package:misa_ui_flutter/view/body/feature_bar/feature_bar.dart';
import 'package:misa_ui_flutter/view/body/page_body/page_body.dart';
import 'package:provider/provider.dart';

class Body extends StatefulWidget {
  final PageSchema? pageSchema;
  final ViewMenuItem? viewMenuItem;
  const Body({
    super.key,
    required this.pageSchema,
    required this.viewMenuItem,
  });

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    if (widget.pageSchema == null || widget.viewMenuItem == null) {
      return const Center(
        child: Text("No schema or view type"),
      );
    }
    final MisaLocale locale = context.watch<MisaLocale>();
    String title = locale.translate(
        context.watch<BodyStateProvider>().viewMenuItem?.title ?? '');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const Divider(),
        const FeatureBar(),
        const Expanded(child: PageBody()),
        const FeatureBar.bottom(),
      ],
    );
  }
}

class BodyStateProvider extends ChangeNotifier {
  String title = '';
  PageSchema? pageSchema;
  ViewMenuItem? viewMenuItem;
  int currentPage = 1;
  int limit = 5;
  int? totalPage;
  DataPayload? payload;
  DataController? _dataController;

  void changeViewMenu({PageSchema? pageSchema, ViewMenuItem? viewMenuItem}) {
    this.pageSchema = pageSchema;
    this.viewMenuItem = viewMenuItem;
    if (pageSchema != null && pageSchema.atTable.isNotEmpty) {
      _dataController = DataController(pageSchema.atTable);
    } else {
      _dataController = null;
    }
    notifyListeners();
  }

  void setQueryFilter(QueryFilter? filter) {
    if (_dataController != null) {
      _dataController!.filter = filter;
    }
    notifyListeners();
  }

  Future<void> setCurrentPage(int page) async {
    if (totalPage != null && page > totalPage!) return;
    currentPage = page;
    if (_dataController != null) {
      currentPage = page;
      notifyListeners();
      payload = await _dataController!.select((page - 1) * limit, limit);
      totalPage = (payload!.total / limit).ceil();
      notifyListeners();
    } else {
      notifyListeners();
    }
    return;
  }
}
