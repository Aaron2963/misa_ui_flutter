import 'package:flutter/material.dart';
import 'package:misa_ui_flutter/model/data_payload.dart';
import 'package:misa_ui_flutter/model/json_schema/array_json_schema.dart';
import 'package:misa_ui_flutter/model/json_schema/json_schema.dart';
import 'package:misa_ui_flutter/model/json_schema/object_json_schema.dart';
import 'package:misa_ui_flutter/settings/misa_locale.dart';
import 'package:misa_ui_flutter/view/body/body.dart';
import 'package:misa_ui_flutter/view/form_component/editbox.dart';
import 'package:provider/provider.dart';

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
    if (viewMenuItem == null || pageSchema == null || formKey == null) {
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
          mode: mode,
        ),
      ),
    );
  }
}

class _FormViewSegment extends StatelessWidget {
  final DataPayload? payload;
  final ObjectJsonSchema schema;
  final String mode;
  final bool required;
  const _FormViewSegment({
    required this.payload,
    required this.schema,
    this.mode = 'edit',
    this.required = false,
  });

  @override
  Widget build(BuildContext context) {
    Set<String> requiredProps = {};
    if (required) {
      if (schema.dependentRequired != null &&
          schema.dependentRequired![mode] != null) {
        requiredProps =
            schema.dependentRequired![mode]!.map((e) => e.key).toSet();
      } else if (schema.required != null) {
        requiredProps = schema.required!.map((e) => e.key).toSet();
      }
    }
    final data = payload ?? DataPayload.single({});
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: schema.formLayout
          .map((row) => Row(
                mainAxisSize: MainAxisSize.max,
                children: row.keys
                    .map((JsonSchema sch) => Expanded(
                          flex: row[sch] ?? 1,
                          child: _FormViewRow(
                            key: Key(sch.key),
                            schema: sch,
                            value: data.get(0, sch.key),
                            required: requiredProps.contains(sch.key),
                            onSaved: (value) {
                              data.set(0, sch.key, value);
                            },
                          ),
                        ))
                    .toList(),
              ))
          .toList(),
    );
  }
}

class _FormViewRow extends StatefulWidget {
  final JsonSchema schema;
  final bool required;
  final dynamic value;
  final ValueSetter<String?>? onSaved;
  const _FormViewRow({
    super.key,
    required this.schema,
    this.required = false,
    this.value,
    this.onSaved,
  });

  @override
  State<_FormViewRow> createState() => _FormViewRowState();
}

class _FormViewRowState extends State<_FormViewRow> {
  Widget _buildComponent() {
    //TODO: build component based on schema.component
    return Editbox(
      schema: widget.schema,
      value: widget.value,
      onSaved: widget.onSaved,
      required: widget.required,
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<MisaLocale>();
    if (widget.schema.type == SchemaDataType.object) {
      // TODO: on save
      return _FormViewSubSegmentFrame(
        title: locale.translate(widget.schema.title ?? widget.schema.key),
        child: _FormViewSegment(
          schema: widget.schema as ObjectJsonSchema,
          payload: DataPayload.single(widget.value),
          required: widget.required,
        ),
      );
    }
    if (widget.schema.type == SchemaDataType.array) {
      final arraySchema = widget.schema as ArrayJsonSchema;
      final valueList = widget.value as List;
      return _FormViewSubSegmentFrame(
          title: locale.translate(widget.schema.title ?? widget.schema.key),
          onAdd: () {
            valueList.add(arraySchema.items.blankValue);
            setState(() {});
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < valueList.length; i++)
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, right: 12.0),
                      child: _FormViewRow(
                        schema: arraySchema.items,
                        value: valueList[i],
                        required: widget.required,
                        onSaved: (value) {
                          //TODO: on save
                        },
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(0),
                          shape: const CircleBorder(),
                          backgroundColor: Colors.red,
                        ),
                        child: const Icon(Icons.close),
                        onPressed: () {
                          valueList.removeAt(i);
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
            ],
          ));
    }
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: _buildComponent(),
    );
  }
}

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
