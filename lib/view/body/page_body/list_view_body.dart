import 'dart:math';

import 'package:flutter/material.dart';
import 'package:misa_ui_flutter/model/data_payload.dart';
import 'package:misa_ui_flutter/model/json_schema/json_schema.dart';
import 'package:misa_ui_flutter/model/page_schema.dart';
import 'package:misa_ui_flutter/settings/misa_locale.dart';
import 'package:misa_ui_flutter/settings/view_settings.dart';
import 'package:misa_ui_flutter/view/body/advanced_view.dart';
import 'package:misa_ui_flutter/view/body/body.dart';
import 'package:provider/provider.dart';

const _cellWidth = 100.0;
const _operationColumnWidth = 80.0;
const _columnSpacing = 12.0;

class ListViewBody extends StatefulWidget {
  const ListViewBody({super.key});

  @override
  State<ListViewBody> createState() => _ListViewBodyState();
}

class _ListViewBodyState extends State<ListViewBody> {
  final int limit = 10;
  int currentPage = 0;
  Set<String> selected = {};
  int? sortColumnIndex;

  void changePage(BuildContext context, int page, {bool isInit = false}) {
    if (page == currentPage) return;
    currentPage = page;
    context
        .read<BodyStateProvider>()
        .setCurrentPage(page, notifyBeforeAwait: !isInit);
  }

  DataColumn _buildColumn({
    required dynamic title,
    required JsonSchema schema,
    required int columnIndex,
    String? tooltip,
  }) {
    return DataColumn(
      numeric:
          schema.type == SchemaDataType.integer || schema.component == 'number',
      tooltip: tooltip,
      label: Row(
        children: [
          Text(title.toString()),
          if (sortColumnIndex != null && sortColumnIndex == columnIndex)
            const Icon(Icons.arrow_drop_down, size: 18),
        ],
      ),
      onSort: (col, asc) => setState(() => sortColumnIndex = col),
    );
  }

  DataCell _buildCell(dynamic value, {VoidCallback? onTap}) {
    return DataCell(
      SizedBox(
        width: _cellWidth,
        child: Tooltip(
          message: value.toString(),
          child: Text(
            value.toString(),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      onTap: onTap,
    );
  }

  @override
  void initState() {
    changePage(context, 1, isInit: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final tableWidthLimit = MediaQuery.of(context).size.width -
        ViewSettings().sideBarWidth -
        _operationColumnWidth -
        30 - // checkbox column
        32; //main frame padding
    final MisaLocale locale = context.watch<MisaLocale>();
    final DataPayload? payload = context.watch<BodyStateProvider>().payload;
    final PageSchema? pageSchema =
        context.watch<BodyStateProvider>().pageSchema;
    // 無資料時顯示
    if (payload == null || pageSchema == null) {
      return const Center(child: Text("No data"));
    }
    // 排序資料
    final List<Map<String, dynamic>> data = payload.data;
    if (sortColumnIndex != null) {
      data.sort((b, a) {
        final JsonSchema schema = pageSchema.headers![sortColumnIndex!];
        final dynamic aValue = a[schema.key];
        final dynamic bValue = b[schema.key];
        if (aValue is int && bValue is int) {
          return aValue.compareTo(bValue);
        }
        if (aValue is String && bValue is String) {
          return aValue.compareTo(bValue);
        }
        return 0;
      });
    }
    // 計算表格寬度
    int headersLength = min(pageSchema.headers!.length,
        (tableWidthLimit / (_cellWidth + _columnSpacing * 2)).floor());
    List<JsonSchema> headers = List.generate(
      headersLength,
      (index) => pageSchema.headers![index],
    );

    return DataTable(
      showCheckboxColumn: true,
      columnSpacing: _columnSpacing,
      columns: [
        for (int i = 0; i < headers.length; i++)
          _buildColumn(
            title: locale.translate(headers[i].title ?? headers[i].key),
            schema: headers[i],
            columnIndex: i,
            tooltip: locale.translate(
              'Sort By %s',
              locale.translate(headers[i].title ?? headers[i].key),
            ),
          ),
        const DataColumn(
            label: Text(
              '操作',
              style: TextStyle(color: Colors.black54),
            ),
            numeric: true,
            onSort: null),
      ],
      rows: List<DataRow>.generate(data.length, (int i) {
        final Map<String, dynamic> d = data[i];
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
          cells: [
            ...headers.map((JsonSchema e) {
              return _buildCell(e.display(locale, d[e.key] ?? ''));
            }).toList(),
            DataCell(
              SizedBox(
                width: _operationColumnWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.info_outline, size: 18.0),
                      tooltip: locale.translate('Detail'),
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        context
                            .read<BodyStateProvider>()
                            .setAdvancedView(AdvancedView(
                              title: locale.translate('Detail'),
                              viewMode: ViewMode.detail,
                              data: [d],
                              onDispose: () {},
                            ));
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 18.0),
                      tooltip: locale.translate('Edit'),
                      padding: EdgeInsets.zero,
                      onPressed: () =>
                          print("edit data: ${d[pageSchema.atId]}"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
