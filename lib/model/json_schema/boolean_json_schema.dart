import 'package:misa_ui_flutter/model/json_schema/json_schema.dart';
import 'package:misa_ui_flutter/settings/misa_locale.dart';

class BooleanJsonSchema extends JsonSchema {
  BooleanJsonSchema({
    required super.key,
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
  }) : super(type: SchemaDataType.boolean);

  factory BooleanJsonSchema.fromJson(String key, Map<String, dynamic> json) {
    return BooleanJsonSchema(
      key: key,
      dollarId: json['\$id'],
      dollarRef: json['\$ref'],
      atId: json['@id'],
      atTable: json['@table'],
      atColumn: json['@column'],
      description: json['description'],
      title: json['title'],
      renderFunction: json['renderFunction'],
      purpose: JsonSchema.toPurposeSet(json['purpose'] as List<String>?),
      component: json['component'],
      event: json['event'],
      formOnly: json['formOnly'] == true,
      readOnly: json['readOnly'] == true,
      disabled: json['disabled'] == true,
      value: json['value'] == true,
      compare: Map<String, CompareEvent?>.fromIterables(
        json['compare'].keys,
        json['compare'].values.map((e) {
          if (e == 'index') return CompareEvent.key;
          if (CompareEvent.values.asNameMap().containsKey(e)) {
            return CompareEvent.values.asNameMap()[e];
          }
          return null;
        }).toList(),
      ),
    );
  }

  @override
  String display(MisaLocale locale, dynamic value) {
    String trueText = '${key}_true';
    String falseText = '${key}_false';
    if (locale.translate(trueText) != trueText) {
      return value == true
          ? locale.translate(trueText)
          : locale.translate(falseText);
    }
    return value == true ? 'YES' : 'NO';
  }

  @override
  bool get blankValue => false;
}
