import 'package:flutter/material.dart';
import 'package:misa_ui_flutter/model/json_schema/json_schema.dart';
import 'package:misa_ui_flutter/model/page_schema.dart';
import 'package:misa_ui_flutter/model/query_filter.dart';
import 'package:misa_ui_flutter/model/query_filter_item.dart';
import 'package:misa_ui_flutter/settings/misa_locale.dart';
import 'package:misa_ui_flutter/view/body/body.dart';
import 'package:misa_ui_flutter/view/body/rich_dialog.dart';
import 'package:provider/provider.dart';

class FilterFeature extends StatefulWidget {
  final PageSchema pageSchema;
  final String title;
  final QueryFilter filter;
  const FilterFeature({
    super.key,
    required this.pageSchema,
    required this.title,
    required this.filter,
  });

  @override
  State<FilterFeature> createState() => _FilterFeatureState();
}

class _FilterFeatureState extends State<FilterFeature> {
  void _onReset() {
    setState(() {
      widget.filter.conditions.clear();
    });
  }

  void _onFilter(BuildContext context) {
    context.read<BodyStateProvider>().setQueryFilter(widget.filter);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<MisaLocale>();
    return RichDialog(
      title: '${locale.translate('Filter:')}${widget.title}',
      actions: [
        TextButton(
          onPressed: () => _onReset(),
          child: Text(locale.translate('Reset')),
        ),
        TextButton(
          onPressed: () => _onFilter(context),
          child: Text(locale.translate('Filter')),
        ),
      ],
      content: _FilterPanel(
        key: Key('filter-panel-${widget.title}'),
        pageSchema: widget.pageSchema,
        filter: widget.filter,
      ),
    );
  }
}

// 篩選面板
class _FilterPanel extends StatefulWidget {
  final PageSchema pageSchema;
  final QueryFilter filter;
  const _FilterPanel({
    super.key,
    required this.pageSchema,
    required this.filter,
  });

  @override
  State<_FilterPanel> createState() => _FilterPanelState();
}

class _FilterPanelState extends State<_FilterPanel> {
  void addCondition() {
    setState(() {
      widget.filter.add(QueryFilterItem.fromSchema(
          schema: widget.pageSchema.visibleFilter!.first));
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.filter.conditions.isEmpty) {
        addCondition();
      }
    });
    return Column(
      children: [
        ...widget.filter.conditions.keys.map((i) => Row(
              children: [
                Expanded(
                  child: _FilterCondition(
                    key: Key('filter-condition-$i'),
                    filter: widget.filter,
                    filterItemIndex: i,
                    pageSchema: widget.pageSchema,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.black45,
                  ),
                  onPressed: () {
                    setState(() {
                      widget.filter.remove(i);
                    });
                  },
                )
              ],
            )),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(16),
              backgroundColor: Colors.orange,
            ),
            onPressed: addCondition,
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}

// 篩選條件
class _FilterCondition extends StatefulWidget {
  final QueryFilter filter;
  final int filterItemIndex;
  final PageSchema pageSchema;
  const _FilterCondition({
    super.key,
    required this.filterItemIndex,
    required this.pageSchema,
    required this.filter,
  });

  @override
  State<_FilterCondition> createState() => _FilterConditionState();
}

class _FilterConditionState extends State<_FilterCondition> {
  late QueryFilterItem filterItem;
  late final List<List> fieldOptions;

  @override
  void initState() {
    super.initState();
    filterItem = widget.filter.conditions[widget.filterItemIndex]!;
    fieldOptions = widget.pageSchema.visibleFilter!
        .map((e) => [e, e.title ?? e.key])
        .toList(growable: false);
    filterItem = widget.filter.conditions[widget.filterItemIndex]!;
  }

  @override
  Widget build(BuildContext context) {
    MisaLocale locale = context.watch<MisaLocale>();
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: DropdownButtonFormField<JsonSchema>(
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 8),
              ),
              items: fieldOptions.map((e) {
                return DropdownMenuItem<JsonSchema>(
                  value: e[0],
                  child: Text(locale.translate(e[1])),
                );
              }).toList(growable: false),
              value: filterItem.schema,
              onChanged: (value) {
                if (value == null || !mounted) return;
                setState(() {
                  filterItem.schema = value;
                  if (!filterItem.operators.contains(filterItem.operator)) {
                    filterItem.operator = filterItem.operators.first;
                  }
                });
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 1,
            child: DropdownButtonFormField<QueryFilterItemOperator>(
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 8),
              ),
              items: filterItem.operators
                  .map((e) => DropdownMenuItem<QueryFilterItemOperator>(
                        value: e,
                        child: Text(locale.translate(e.toString())),
                      ))
                  .toList(growable: false),
              value: filterItem.operator,
              onChanged: (value) {
                if (value == null || !mounted) return;
                setState(() {
                  filterItem.operator = value;
                });
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 4,
            child: _FilterConditionContent(
              filterItem: filterItem,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterConditionContent extends StatefulWidget {
  final QueryFilterItem filterItem;
  const _FilterConditionContent({
    required this.filterItem,
  });

  @override
  State<_FilterConditionContent> createState() =>
      _FilterConditionContentState();
}

class _FilterConditionContentState extends State<_FilterConditionContent> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  Widget buildField([int index = 1]) {
    String initialValue =
        (index == 1 ? widget.filterItem.value1 : widget.filterItem.value2) ?? '';
    TextEditingController controller = index == 1 ? _controller1 : _controller2;
    controller.text = initialValue;
    //值的型別是布林值
    if (widget.filterItem.schema.type == SchemaDataType.boolean) {
      return DropdownButtonFormField<bool>(
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 8),
        ),
        items: const [
          DropdownMenuItem<bool>(
            value: true,
            child: Text('是'),
          ),
          DropdownMenuItem<bool>(
            value: false,
            child: Text('否'),
          ),
        ],
        value: widget.filterItem.value1 == 'true',
        onChanged: (value) {
          setState(() {
            widget.filterItem.value1 = value.toString();
          });
        },
      );
    }
    //值的格式是日期
    if (dateComponents.contains(widget.filterItem.schema.component)) {
      final locale = context.watch<MisaLocale>();
      return TextFormField(
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 8),
        ),
        controller: controller,
        onTap: () async {
          final DateTime? picked = await showDatePicker(
            context: context,
            initialDate:
                DateTime.tryParse(initialValue) ?? DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2200),
            helpText: locale.translate(widget.filterItem.schema.title ?? widget.filterItem.schema.key),
          );
          if (picked != null) {
            setState(() {
              String pickedStr = picked.toString().substring(0, 10);
              if (index == 1) {
                widget.filterItem.value1 = pickedStr;
                _controller1.text = pickedStr;
              } else {
                widget.filterItem.value2 = pickedStr;
                _controller2.text = pickedStr;
              }
            });
          }
        },
      );
    }
    return TextFormField(
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 8),
      ),
      controller: controller,
      onChanged: (value) {
        setState(() {
          if (index == 1) {
            widget.filterItem.value1 = value;
          } else {
            widget.filterItem.value2 = value;
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.filterItem.operator.op != QueryFilterOp.range) {
      return buildField();
    }
    return Row(
      children: [
        Expanded(child: buildField(1)),
        const SizedBox(width: 8),
        Expanded(child: buildField(2)),
      ],
    );
  }
}
