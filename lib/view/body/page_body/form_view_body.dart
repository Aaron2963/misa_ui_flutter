import 'package:flutter/material.dart';
import 'package:misa_ui_flutter/model/data_payload.dart';
import 'package:misa_ui_flutter/model/json_schema/json_schema.dart';
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
    Set<String> requiredProps = {};
    if (pageSchema.dependentRequired != null && pageSchema.dependentRequired![mode] != null) {
      requiredProps = pageSchema.dependentRequired![mode]!.map((e) => e.key).toSet();
    } else if (pageSchema.required != null) {
      requiredProps = pageSchema.required!.map((e) => e.key).toSet();
    }
    List<JsonSchema> props = pageSchema.properties!.values
        .where((e) => e.readOnly != true && e.component != 'hidden')
        .toList();
    return Form(
      key: formKey,
      child: FocusScope(
        node: FocusScopeNode(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: props
              .map((e) => FormViewRow(
                    key: Key(e.key),
                    schema: e,
                    value: data?.get(0, e.key),
                    required: requiredProps.contains(e.key),
                    onSaved: (value) {
                      data?.set(0, e.key, value);
                      // TODO: call controller to insert/update data
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }
}

class FormViewRow extends StatelessWidget {
  final JsonSchema schema;
  final bool required;
  final dynamic value;
  final ValueSetter<String?>? onSaved;
  const FormViewRow({
    super.key,
    required this.schema,
    this.required = false,
    this.value,
    this.onSaved,
  });

  Widget _buildComponent() {
    //TODO: build component based on schema.component
    return Editbox(schema: schema, value: value.toString(), onSaved: onSaved, required: required,);
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<MisaLocale>();
    if (schema.type == SchemaDataType.object) {
      //TODO: handle object type
      return Text('Object type not supported yet: ${schema.key}');
    }
    if (schema.type == SchemaDataType.array) {
      //TODO: handle array type
      return Text('Array type not supported yet: ${schema.key}');
    }
    return _buildComponent();
  }
}
