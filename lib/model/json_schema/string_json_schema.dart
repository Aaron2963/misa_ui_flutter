import 'package:misa_ui_flutter/model/json_schema/json_schema.dart';

enum SchemaFormat { date, time, datetime, email, uri, json }

class StringJsonSchema extends JsonSchema {
  final String? pattern;
  final int? minLength;
  final int? maxLength;
  final SchemaFormat? format;

  StringJsonSchema({
    this.pattern,
    this.minLength,
    this.maxLength,
    this.format,
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
    super.event,
    super.formOnly,
    super.readOnly,
    super.disabled,
    super.value,
  }) : super(type: SchemaDataType.string);

  factory StringJsonSchema.fromJson(Map<String, dynamic> json) {
    return StringJsonSchema(
      pattern: json['pattern'] as String?,
      minLength: json['minLength'] as int?,
      maxLength: json['maxLength'] as int?,
      dollarId: json['\$id'] as String?,
      dollarRef: json['\$ref'] as String?,
      atId: json['@id'] as String?,
      atTable: json['@table'] as String?,
      atColumn: json['@column'] as String?,
      atChain: JsonSchema.toAtChainList(
          json['@chain'] as List<Map<String, dynamic>>?),
      format: SchemaFormat.values.asNameMap()[json['format'] ?? ''],
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
    );
  }
}
