import 'dart:math';

import 'package:misa_ui_flutter/model/json_schema/json_schema.dart';
import 'package:misa_ui_flutter/settings/misa_locale.dart';

class IntegerJsonSchema extends JsonSchema {
  final int? minimum;
  final int? maximum;

  IntegerJsonSchema({
    required super.key,
    this.minimum,
    this.maximum,
    super.dollarId,
    super.dollarRef,
    super.dollarSchema,
    super.atId,
    super.atTable,
    super.atColumn,
    super.atChain,
    super.description,
    super.title,
    super.renderFunction,
    super.purpose,
    super.component,
    super.compare,
    super.event,
    super.formOnly,
    super.readOnly,
    super.disabled,
    super.value,
  }) : super(type: SchemaDataType.integer);

  factory IntegerJsonSchema.fromJson(String key, Map<String, dynamic> json) {
    return IntegerJsonSchema(
      key: key,
      minimum: json['minimum'] as int?,
      maximum: json['maximum'] as int?,
      dollarId: json['\$id'] as String?,
      dollarRef: json['\$ref'] as String?,
      atId: json['@id'] as String?,
      atTable: json['@table'] as String?,
      atColumn: json['@column'] as String?,
      atChain: JsonSchema.toAtChainList(
          json['@chain'] as List<Map<String, dynamic>>?),
      description: json['description'] as String?,
      title: json['title'] as String?,
      renderFunction: json['renderFunction'] as String?,
      purpose: JsonSchema.toPurposeSet(json['purpose'] as List<String>?),
      component: json['component'] as String?,
      event: json['event'] as String?,
      formOnly: json['formOnly'] == true,
      readOnly: json['readOnly'] == true,
      disabled: json['disabled'] == true,
      value: json['value'],
      compare: json['compare'] != null
          ? Map<String, CompareEvent?>.fromIterables(
              json['compare'].keys,
              json['compare'].values.map((e) {
                if (e == 'index') return CompareEvent.key;
                if (CompareEvent.values.asNameMap().containsKey(e)) {
                  return CompareEvent.values.asNameMap()[e];
                }
                return null;
              }).cast<CompareEvent?>(),
            )
          : null,
    );
  }

  @override
  String display(MisaLocale locale, dynamic value) {
    value = int.tryParse(value.toString()) ?? '';
    return value;
  }

  @override
  int get blankValue => max(0, minimum ?? 0);

  @override
  String? validate(dynamic value) {
    if (value == null) return null;
    int? v = int.tryParse(value.toString());
    if (v == null) {
      return 'Value is not an integer.';
    }
    if (minimum != null && v < minimum!) {
      return 'Value is less than minimum.';
    }
    if (maximum != null && v > maximum!) {
      return 'Value is greater than maximum.';
    }
    return null;
  }
}
