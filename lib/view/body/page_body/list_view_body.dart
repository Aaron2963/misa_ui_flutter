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
  Set<String> selected = {};

  void changePage(BuildContext context, int page) {
    if (page == currentPage) return;
    currentPage = page;
    context.read<BodyStateProvider>().setCurrentPage(page);
  }

  DataColumn _buildColumn(dynamic title, JsonSchema schema) {
    return DataColumn(
      numeric:
          schema.type == SchemaDataType.integer || schema.component == 'number',
      label: Expanded(
        child: Text(title.toString()),
      ),
    );
  }

  DataCell _buildCell(dynamic value, VoidCallback onTap) {
    return DataCell(
      Text(value.toString()),
      onTap: onTap,
    );
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
    return SizedBox(
      width: double.infinity,
      child: DataTable(
        showCheckboxColumn: true,
        columns: pageSchema.headers!
            .map((JsonSchema e) =>
                _buildColumn(locale.translate(e.title ?? e.key), e))
            .toList(),
        rows: List<DataRow>.generate(payload.data.length, (int i) {
          final Map<String, dynamic> d = payload.data[i];
          return DataRow(
            color: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.selected)) {
                  return Theme.of(context).colorScheme.primary.withOpacity(0.08);
                }
                if (i.isEven) {
                  return Colors.grey.withOpacity(0.2);
                }
                return null;
              },
            ),
            selected: selected.contains(d[pageSchema.atId]),
            onSelectChanged: (value) => setState(() {
              if (value == true) {
                selected.add(d[pageSchema.atId]);
              } else {
                selected.remove(d[pageSchema.atId]);
              }
            }),
            cells: pageSchema.headers!.map((JsonSchema e) {
              return _buildCell(
                e.display(locale, d[e.key] ?? ''),
                () {
                  //TODO: open detail
                  print('open detail: ${d[pageSchema.atId]}');
                },
              );
            }).toList(),
          );
        }),
      ),
    );
  }
}
