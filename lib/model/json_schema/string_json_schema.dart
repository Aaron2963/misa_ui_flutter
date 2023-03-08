import 'package:misa_ui_flutter/model/json_schema/json_schema.dart';
import 'package:misa_ui_flutter/settings/misa_locale.dart';

enum SchemaFormat { date, time, datetime, email, uri, json }

class StringJsonSchema extends JsonSchema {
  final String? pattern;
  final int? minLength;
  final int? maxLength;
  final SchemaFormat? format;
  final List<String>? enumValues;
  final List<String>? texts;

  StringJsonSchema({
    required super.key,
    this.pattern,
    this.minLength,
    this.maxLength,
    this.format,
    this.enumValues,
    this.texts,
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
  }) : super(type: SchemaDataType.string);

  factory StringJsonSchema.fromJson(String key, Map<String, dynamic> json) {
    return StringJsonSchema(
      key: key,
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
      enumValues: (json['enum'] as List<dynamic>?)?.cast<String>(),
      texts: (json['texts'] as List<dynamic>?)?.cast<String>(),
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
    if (texts != null && enumValues != null && enumValues!.contains(value)) {
      return locale.translate(texts![enumValues!.indexOf(value)]);
    }
    if (['date', 'datetime'].contains(component)) {
      DateTime dt = DateTime.parse(value);
      if ((dt.year == 1970 || dt.year == 1000) &&
          dt.month == 1 &&
          dt.day == 1) {
        return '';
      }
      if (component == 'date') {
        return value.split(' ')[0];
      }
    }
    return value.toString();
  }

  @override
  String get blankValue {
    if (enumValues != null && enumValues!.isNotEmpty) {
      return enumValues!.first;
    }
    if (format == SchemaFormat.date) {
      return '1000-01-01';
    }
    if (format == SchemaFormat.datetime) {
      return '1000-01-01 00:00:00';
    }
    if (format == SchemaFormat.json) {
      return '[]';
    }
    return '';
  }
}
