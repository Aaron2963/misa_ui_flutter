import 'package:flutter/material.dart';
import 'package:misa_ui_flutter/model/data_payload.dart';
import 'package:misa_ui_flutter/model/json_schema/array_json_schema.dart';
import 'package:misa_ui_flutter/model/json_schema/json_schema.dart';
import 'package:misa_ui_flutter/model/json_schema/object_json_schema.dart';
import 'package:misa_ui_flutter/settings/misa_locale.dart';
import 'package:misa_ui_flutter/view/body/body.dart';
import 'package:misa_ui_flutter/view/body/page_body/form_cache.dart';
import 'package:misa_ui_flutter/view/form_component/form_component.dart' as misa;
import 'package:misa_ui_flutter/view/form_component/form_component_controller.dart';
import 'package:provider/provider.dart';

// 表單主頁面
class FormViewBody extends StatelessWidget {
  final DataPayload? payload;
  final String mode;
  const FormViewBody({super.key, this.payload, this.mode = 'edit'});

  @override
  Widget build(BuildContext context) {
    final bodyState = context.watch<BodyStateProvider>();
    final viewMenuItem = bodyState.viewMenuItem;
    final pageSchema = bodyState.pageSchema;
    final formKey = bodyState.advancedView?.formKey;
    final data = payload ?? bodyState.payload;
    final formCache = bodyState.advancedView?.formCache;
    if (viewMenuItem == null ||
        pageSchema == null ||
        formKey == null ||
        formCache == null) {
      return const Center(
        child: Text("No schema or view type"),
      );
    }
    return Form(
      key: formKey,
      child: FocusScope(
        node: FocusScopeNode(),
        child: _FormViewSegment(
          payload: data,
          schema: pageSchema,
          formCache: formCache,
          mode: mode,
          required: true,
        ),
      ),
    );
  }
}

// 表單區塊
class _FormViewSegment extends StatefulWidget {
  final DataPayload? payload;
  final ObjectJsonSchema schema;
  final String mode;
  final bool required;
  final FormCache formCache;
  final List parentKeys;
  const _FormViewSegment({
    required this.payload,
    required this.schema,
    required this.formCache,
    this.mode = 'edit',
    this.required = false,
    this.parentKeys = const [],
  });

  @override
  State<_FormViewSegment> createState() => _FormViewSegmentState();
}

class _FormViewSegmentState extends State<_FormViewSegment> {
  // hidden props set
  Set<String> hiddenKeys = {};
  FormSegmentInterAction triggers = FormSegmentInterAction();

  @override
  void initState() {
    super.initState();
    // register handle compare event
    for (JsonSchema sch in widget.schema.properties!.values) {
      if (sch.compare != null) {
        triggers.register(sch.key, sch.compare!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // required props
    Set<String> requiredProps = {};
    if (widget.required) {
      if (widget.schema.dependentRequired != null &&
          widget.schema.dependentRequired![widget.mode] != null) {
        requiredProps = widget.schema.dependentRequired![widget.mode]!
            .map((e) => e.key)
            .toSet();
      } else if (widget.schema.required != null) {
        requiredProps = widget.schema.required!.map((e) => e.key).toSet();
      }
    }
    final data = widget.payload ?? DataPayload.single({});
    // column children
    List<Widget> children = [];
    for (Map<JsonSchema, int> row in widget.schema.formLayout) {
      List<Widget> rowChildren = [];
      for (JsonSchema sch in row.keys) {
        if (hiddenKeys.contains(sch.key)) continue;
        Widget child = Expanded(
          flex: row[sch] ?? 1,
          child: _FormViewRow(
            key: Key(sch.key),
            schema: sch,
            formCache: widget.formCache,
            value: data.get(0, sch.key),
            required: requiredProps.contains(sch.key),
            parentKeys: widget.parentKeys,
            onChanged: (value) {
              if (!triggers.hasTrigger(sch.key)) return;
              //handle compare show/hide
              final showKeys =
                  triggers.getActingKeys(sch.key, CompareEvent.show);
              final hideKeys =
                  triggers.getActingKeys(sch.key, CompareEvent.hide);
              if (value == false ||
                  value == null ||
                  (value is String && value.isEmpty)) {
                hiddenKeys.addAll(showKeys);
                hiddenKeys.removeAll(hideKeys);
              } else {
                hiddenKeys.removeAll(showKeys);
                hiddenKeys.addAll(hideKeys);
              }
              setState(() {});
            },
          ),
        );
        rowChildren.add(child);
      }
      children.add(Row(
        mainAxisSize: MainAxisSize.max,
        children: rowChildren,
      ));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}

// 表單欄位
class _FormViewRow extends StatefulWidget {
  final JsonSchema schema;
  final bool required;
  final dynamic value;
  final ValueChanged? onChanged;
  final FormCache formCache;
  final List parentKeys;
  const _FormViewRow({
    super.key,
    required this.schema,
    required this.formCache,
    this.required = false,
    this.value,
    this.onChanged,
    this.parentKeys = const [],
  });

  @override
  State<_FormViewRow> createState() => _FormViewRowState();
}

class _FormViewRowState extends State<_FormViewRow> {
  Widget _buildComponent() {
    final FormComponentController controller = FormComponentController(
      schema: widget.schema,
      value: widget.value,
      onChanged: widget.onChanged,
      required: widget.required,
      onValidate: (v) => null,
      onSaved: (v) =>
          widget.formCache.set(widget.schema.key, v, widget.parentKeys),
    );
    //TODO: build component based on schema.component
    if (widget.schema.component == 'password') {
      return misa.EditBox(controller: controller, obscureText: true);
    }
    if (widget.schema.component == 'number') {
      return misa.EditBox(controller: controller, isNumber: true);
    }
    if (widget.schema.component == 'select') {
      return misa.Select(controller: controller);
    }
    // searchSelect
    // slider
    if (widget.schema.component == 'checkbox') {
      return misa.Checkbox(controller: controller);
    }
    // switch
    // oneWayCheckbox
    // datetime
    // month
    // week
    // date
    // time
    // textarea
    // radioTextarea
    // richtext
    // image
    // file
    return misa.EditBox(controller: controller);
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<MisaLocale>();
    // type: object
    if (widget.schema.type == SchemaDataType.object) {
      return _FormViewSubSegmentFrame(
        title: locale.translate(widget.schema.title ?? widget.schema.key),
        child: _FormViewSegment(
          schema: widget.schema as ObjectJsonSchema,
          formCache: widget.formCache,
          payload: DataPayload.single(widget.value),
          required: widget.required,
          parentKeys: [...widget.parentKeys, widget.schema.key],
        ),
      );
    }
    // type: array
    if (widget.schema.type == SchemaDataType.array) {
      final arraySchema = widget.schema as ArrayJsonSchema;
      final valueList = widget.value as Map<String, dynamic>;
      final arraySequence = widget.value['@sequence'];
      int valueListLength = valueList.length;
      return _FormViewSubSegmentFrame(
          title: locale.translate(widget.schema.title ?? widget.schema.key),
          onAdd: () {
            String k = (valueListLength++).toString();
            while (valueList.containsKey(k)) {
              k = (valueListLength++).toString();
            }
            valueList[k] = arraySchema.items.blankValue;
            setState(() {});
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (String i in arraySequence)
                _FormViewArrayItemFrame(
                  key: Key(
                      '${widget.parentKeys.join('.')}.${widget.schema.key}.$i-${valueList[i]}'),
                  index: int.parse(i),
                  schema: arraySchema.items,
                  formCache: widget.formCache,
                  value: valueList[i],
                  required: widget.required,
                  parentKeys: [...widget.parentKeys, widget.schema.key],
                  isFirst: i == arraySequence.first,
                  isLast: i == arraySequence.last,
                  onSequeceChanged: (toPrev) {
                    int index = arraySequence.indexOf(i);
                    if (toPrev) {
                      if (index == 0) return;
                      arraySequence[index] = arraySequence[index - 1];
                      arraySequence[index - 1] = i;
                    } else {
                      if (index == arraySequence.length - 1) return;
                      arraySequence[index] = arraySequence[index + 1];
                      arraySequence[index + 1] = i;
                    }
                    widget.formCache.set('@sequence', arraySequence,
                        [...widget.parentKeys, widget.schema.key]);
                    setState(() {});
                  },
                  onRemove: () => setState(() {
                    valueList[i] = null;
                    arraySequence.remove(i);
                    widget.formCache.set(
                        i, null, [...widget.parentKeys, widget.schema.key]);
                  }),
                ),
            ],
          ));
    }
    // type: string, boolean, integer
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: _buildComponent(),
    );
  }
}

// 表單子區塊外框
class _FormViewSubSegmentFrame extends StatefulWidget {
  final String title;
  final Widget child;
  final VoidCallback? onAdd;
  const _FormViewSubSegmentFrame({
    required this.title,
    required this.child,
    this.onAdd,
  });

  @override
  State<_FormViewSubSegmentFrame> createState() =>
      _FormViewSubSegmentFrameState();
}

class _FormViewSubSegmentFrameState extends State<_FormViewSubSegmentFrame> {
  bool actived = false;
  @override
  Widget build(BuildContext context) {
    final locale = context.watch<MisaLocale>();
    return MouseRegion(
      onEnter: (event) => setState(() => actived = true),
      onExit: (event) => setState(() => actived = false),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 0.0, 8.0),
        margin: const EdgeInsets.only(right: 16.0, bottom: 16.0, top: 8.0),
        decoration: BoxDecoration(
          color: const Color(0xFFFAFAFA),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: actived ? 4.0 : 2.0,
              spreadRadius: 0.0,
              offset: const Offset(-1.0, 0.0),
            )
          ],
          border: Border(
            left: BorderSide(
              width: 3.0,
              color: actived ? Colors.blue : Colors.grey,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.title.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  locale.translate(widget.title),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
              ),
            widget.child,
            if (widget.onAdd != null)
              Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(
                  vertical: 4.0,
                  horizontal: 16.0,
                ),
                child: ElevatedButton(
                    onPressed: widget.onAdd,
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(12),
                        shape: const CircleBorder(),
                        backgroundColor: Colors.green),
                    child: const Icon(
                      Icons.add,
                      size: 36.0,
                    )),
              ),
          ],
        ),
      ),
    );
  }
}

// 表單陣列子項目外框：包含刪除按鈕
class _FormViewArrayItemFrame extends StatelessWidget {
  final int index;
  final JsonSchema schema;
  final dynamic value;
  final FormCache formCache;
  final List parentKeys;
  final bool required;
  final bool isFirst;
  final bool isLast;
  final ValueSetter<bool> onSequeceChanged;
  final VoidCallback onRemove;
  const _FormViewArrayItemFrame({
    super.key,
    required this.index,
    required this.schema,
    required this.value,
    required this.formCache,
    required this.parentKeys,
    required this.required,
    required this.onSequeceChanged,
    required this.onRemove,
    this.isFirst = false,
    this.isLast = false,
  });

  ButtonStyle _getButtonStyle([MaterialColor color = Colors.blue]) {
    return ElevatedButton.styleFrom(
      padding: const EdgeInsets.all(0),
      shape: const CircleBorder(),
      backgroundColor: color.shade400,
      minimumSize: const Size(42, 36),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (value == null) {
      return const SizedBox();
    }
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0, right: 12.0),
          child: _FormViewRow(
            schema: schema,
            formCache: formCache,
            value: value,
            required: required,
            parentKeys: [...parentKeys, index.toString()],
          ),
        ),
        Positioned(
          right: 16,
          top: 8,
          child: Row(
            children: [
              if (!isFirst)
                ElevatedButton(
                  style: _getButtonStyle(),
                  onPressed: () => onSequeceChanged(true),
                  child: const Icon(Icons.arrow_upward),
                ),
              if (!isLast)
                ElevatedButton(
                  style: _getButtonStyle(),
                  onPressed: () => onSequeceChanged(false),
                  child: const Icon(Icons.arrow_downward),
                ),
              ElevatedButton(
                style: _getButtonStyle(Colors.red),
                onPressed: onRemove,
                child: const Icon(Icons.close),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
