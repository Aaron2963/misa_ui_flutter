import 'package:flutter/material.dart';
import 'package:misa_ui_flutter/model/data_payload.dart';
import 'package:misa_ui_flutter/model/json_schema/json_schema.dart';
import 'package:misa_ui_flutter/model/page_schema.dart';
import 'package:misa_ui_flutter/settings/misa_locale.dart';
import 'package:misa_ui_flutter/view/body/body.dart';
import 'package:provider/provider.dart';

class ListViewBody extends StatefulWidget {
  const ListViewBody({super.key});

  @override
  State<ListViewBody> createState() => _ListViewBodyState();
}

class _ListViewBodyState extends State<ListViewBody> {
  final int limit = 10;
  int currentPage = 0;

  void changePage(BuildContext context, int page) {
    if (page == currentPage) return;
    currentPage = page;
    context.read<BodyStateProvider>().setCurrentPage(page);
  }

  DataColumn _buildColumn(dynamic title) {
    return DataColumn(
      label: Expanded(child: Text(title.toString())),
    );
  }

  DataCell _buildCell(dynamic value) {
    return DataCell(Text(value.toString()));
  }

  @override
  void initState() {
    changePage(context, 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final MisaLocale locale = context.watch<MisaLocale>();
    final DataPayload? payload = context.watch<BodyStateProvider>().payload;
    final PageSchema? pageSchema =
        context.watch<BodyStateProvider>().pageSchema;
    if (payload == null || pageSchema == null) {
      return const Center(child: Text("No data"));
    }
    return DataTable(
      columns: pageSchema.headers!
          .map((JsonSchema e) =>
              _buildColumn(locale.translate(e.title ?? e.key)))
          .toList(),
      rows: payload.data.map((Map<String, dynamic> d) {
        return DataRow(
          cells: pageSchema.headers!.map((JsonSchema e) {
            // TODO: renderor, eg. component:select should render as element of texts
            return _buildCell(d[e.key] ?? '');
          }).toList(),
        );
      }).toList(),
    );
  }
}
