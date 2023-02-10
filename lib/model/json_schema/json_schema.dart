import 'package:misa_ui_flutter/model/json_schema/array_json_schema.dart';
import 'package:misa_ui_flutter/model/json_schema/at_chain_element.dart';
import 'package:misa_ui_flutter/model/json_schema/boolean_json_schema.dart';
import 'package:misa_ui_flutter/model/json_schema/integer_json_schema.dart';
import 'package:misa_ui_flutter/model/json_schema/object_json_schema.dart';
import 'package:misa_ui_flutter/model/json_schema/string_json_schema.dart';
import 'package:misa_ui_flutter/settings/misa_locale.dart';

enum SchemaDataType { string, integer, boolean, object, array }

enum SchemaPurpose { header, option, caption, quickact, timeline }

class JsonSchema {
  final String key;
  final SchemaDataType type;
  final String? dollarId;
  final String? dollarRef;
  final String? dollarSchema;
  final String? atId;
  final String? atTable;
  final String? atColumn;
  final List<AtChainElement>? atChain;
  final String? description;
  final String? title;
  final String? renderFunction;
  final Set<SchemaPurpose>? purpose;
  final String? component;
  final String? event;
  final bool formOnly;
  final bool readOnly;
  final bool disabled;
  final dynamic value;

  JsonSchema({
    required this.key,
    required this.type,
    this.dollarId,
    this.dollarRef,
    this.dollarSchema,
    this.atId,
    this.atTable,
    this.atColumn,
    this.atChain,
    this.description,
    this.title,
    this.renderFunction,
    this.purpose,
    this.component,
    this.event,
    this.formOnly = false,
    this.readOnly = false,
    this.disabled = false,
    this.value,
  });

  factory JsonSchema.fromJson(String key, Map<String, dynamic> json) {
    final type = json['type'] as String;
    switch (type) {
      case 'string':
        return StringJsonSchema.fromJson(key, json);
      case 'integer':
        return IntegerJsonSchema.fromJson(key, json);
      case 'boolean':
        return BooleanJsonSchema.fromJson(key, json);
      case 'object':
        return ObjectJsonSchema.fromJson(key, json);
      case 'array':
        return ArrayJsonSchema.fromJson(key, json);
      default:
        throw Exception('Unknown type: $type');
    }
  }

  String display(MisaLocale locale, dynamic value) {
    throw UnimplementedError();
  }

  static Set<SchemaPurpose>? toPurposeSet(List<String>? list) {
    if (list == null) {
      return null;
    }
    final set = <SchemaPurpose>{};
    for (final item in list) {
      SchemaPurpose? purpose = SchemaPurpose.values.asNameMap()[item];
      if (purpose != null) {
        set.add(purpose);
      }
    }
    return set;
  }

  static List<AtChainElement>? toAtChainList(List<Map<String, dynamic>>? list) {
    if (list == null) {
      return null;
    }
    return list.map((e) => AtChainElement.fromJson(e)).toList();
  }
}
