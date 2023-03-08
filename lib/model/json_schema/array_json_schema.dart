import 'package:misa_ui_flutter/model/json_schema/json_schema.dart';
import 'package:misa_ui_flutter/settings/misa_locale.dart';

class ArrayJsonSchema extends JsonSchema {
  final JsonSchema items;
  final int? minLength;
  final int? maxLength;

  ArrayJsonSchema({
    required super.key,
    required this.items,
    this.minLength,
    this.maxLength,
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
  }) : super(type: SchemaDataType.array);

  factory ArrayJsonSchema.fromJson(String key, Map<String, dynamic> json) {
    return ArrayJsonSchema(
      key: key,
      items: JsonSchema.fromJson('$key[]', json['items']),
      minLength: json['minLength'] as int?,
      maxLength: json['maxLength'] as int?,
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
    if (value is! List) return '';
    if (items.type == SchemaDataType.string ||
        items.type == SchemaDataType.integer) {
      return value.join(', ');
    }
    return '';
  }

  @override
  List get blankValue => [];
}
