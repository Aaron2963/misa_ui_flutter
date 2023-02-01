import 'package:flutter/material.dart';
import 'package:misa_ui_flutter/model/page_schema.dart';
import 'package:misa_ui_flutter/model/menu_item.dart';
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
      ],
    );
  }
}

class BodyStateProvider extends ChangeNotifier {
  String title = '';
  PageSchema? pageSchema;
  ViewMenuItem? viewMenuItem;
  int currentPage = 1;
  int totalPage = 1;

  void set({PageSchema? pageSchema, ViewMenuItem? viewMenuItem}) {
    this.pageSchema = pageSchema;
    this.viewMenuItem = viewMenuItem;
    notifyListeners();
  }
  
  void setCurrentPage(int page, {int total = 1}) {
    currentPage = page;
    totalPage = total;
    notifyListeners();
  }
}
