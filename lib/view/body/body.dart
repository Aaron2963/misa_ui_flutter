import 'package:flutter/material.dart';
import 'package:misa_ui_flutter/model/page_schema.dart';
import 'package:misa_ui_flutter/model/menu_item.dart';
import 'package:misa_ui_flutter/settings/misa_locale.dart';
import 'package:misa_ui_flutter/view/body/list_view_body.dart';
import 'package:provider/provider.dart';

class Body extends StatefulWidget {
  final PageSchema? pageSchema;
  final ViewType? viewType;
  const Body({super.key, required this.pageSchema, required this.viewType});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    if (widget.pageSchema == null || widget.viewType == null) {
      return const Center(
        child: Text("No schema or view type"),
      );
    }
    final MisaLocale locale = context.watch<MisaLocale>();
    String title = locale.translate(context.watch<BodyStateProvider>().title);
    return Column(
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const Divider(),
        Expanded(child: ListViewBody(pageSchema: widget.pageSchema!)),
      ],
    );
  }
}

class BodyStateProvider extends ChangeNotifier {
  String title = '';
  PageSchema? pageSchema;
  ViewType? viewType;

  void set({String? title, PageSchema? pageSchema, ViewType? viewType}) {
    this.title = title ?? '';
    this.pageSchema = pageSchema;
    this.viewType = viewType;
    notifyListeners();
  }
}
