import 'package:flutter/material.dart';
import 'package:misa_ui_flutter/model/json_schema/json_schema.dart';

class FormComponentController {
  final JsonSchema schema;
  final dynamic value;
  final ValueSetter? onSaved;
  final ValueChanged? onChanged;
  final String? Function(dynamic)? onValidate;
  final bool required;

  const FormComponentController({
    required this.schema,
    this.required = false,
    this.value,
    this.onSaved,
    this.onChanged,
    this.onValidate,
  });

  String? validate(dynamic value) {
    if (required && (value == null || value.isEmpty)) {
      return 'This field is required';
    }
    String? schemaValidation = schema.validate(value);
    if (schemaValidation != null) {
      return schemaValidation;
    }
    return onValidate?.call(value);
  }
}
