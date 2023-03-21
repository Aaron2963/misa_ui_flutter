import 'package:misa_ui_flutter/model/json_schema/json_schema.dart';
import 'package:misa_ui_flutter/settings/misa_locale.dart';

class ObjectJsonSchema extends JsonSchema {
  final Map<String, JsonSchema>? properties;
  final Set<JsonSchema>? required;
  final Map<String, Set<JsonSchema>>? dependentRequired;
  final List<String>? render;
  final List? layout;

  ObjectJsonSchema({
    required super.key,
    required this.properties,
    this.required,
    this.dependentRequired,
    this.render,
    this.layout,
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
  }) : super(type: SchemaDataType.object);

  factory ObjectJsonSchema.fromJson(String key, Map<String, dynamic> json) {
    Map<String, JsonSchema> properties = {};
    Set<JsonSchema> required = {};
    Map<String, Set<JsonSchema>> dependentRequired = {};
    for (var k in json['properties'].keys) {
      properties[k.toString()] = JsonSchema.fromJson(k, json['properties'][k]);
    }
    if (json['required'] != null) {
      for (var key in json['required']) {
        required.add(properties[key.toString()]!);
      }
    }
    if (json['dependentRequired'] != null) {
      for (var key in json['dependentRequired'].keys) {
        Set<JsonSchema> dependentRequiredSet = {};
        for (var dependentRequiredKey in json['dependentRequired'][key]) {
          dependentRequiredSet
              .add(properties[dependentRequiredKey.toString()]!);
        }
        dependentRequired[key.toString()] = dependentRequiredSet;
      }
    }

    return ObjectJsonSchema(
      key: key,
      properties: properties,
      required: required,
      dependentRequired: dependentRequired,
      render: json['render'] as List<String>?,
      layout: json['layout'],
      dollarId: json['\$id'] as String?,
      dollarRef: json['\$ref'] as String?,
      dollarSchema: json['\$schema'] as String?,
      atId: json['@id'] as String?,
      atTable: json['@table'] as String?,
      atColumn: json['@column'] as String?,
      atChain: JsonSchema.toAtChainList(
          json['@chain'] as List<Map<String, dynamic>>?),
      description: json['description'] as String?,
      title: json['title'] as String?,
      renderFunction: json['renderFunction'] as String?,
      purpose: JsonSchema.toPurposeSet(json['purpose'] as List?),
      component: json['component'] as String?,
      event: json['event'] as String?,
      formOnly: json['formOnly'] == true,
      readOnly: json['readOnly'] == true || json['readonly'] == true,
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
    if (render != null) {
      String rs = '';
      for (var k in render!) {
        if (properties != null && properties!.containsKey(k)) {
          rs += properties![k]!.display(locale, value[k]);
        } else {
          rs += locale.translate(value[k].toString());
        }
      }
      return rs;
    }
    return '';
  }

  @override
  Map<String, dynamic> get blankValue {
    Map<String, dynamic> result = {};
    if (properties == null) return result;
    for (var k in properties!.keys) {
      result[k] = properties![k]!.blankValue;
    }
    return result;
  }

  List<Map<JsonSchema, int>> get formLayout {
    List<Map<JsonSchema, int>> result = [];
    if (layout != null) {
      for (int i = 0; i < layout!.length; i++) {
        if (layout![i] is String) {
          if (properties!.containsKey(layout![i])) {
            result.add({
              properties![layout![i]]!: 1,
            });
          }
        } else if (layout![i] is Map) {
          Map<JsonSchema, int> row = {};
          for (var k in layout![i].keys) {
            if (properties!.containsKey(k) && layout![i][k] is int) {
              row[properties![k]!] = layout![i][k];
            }
          }
          result.add(row);
        } else if (layout![i] is List) {
          Map<JsonSchema, int> row = {};
          for (var k in layout![i]) {
            if (properties!.containsKey(k)) {
              row[properties![k]!] = 1;
            }
          }
          result.add(row);
        }
      }
      return result;
    }
    //while no layout, every property will occupy 1 row
    for (var e in properties!.values) {
      if (e.readOnly != true && e.component != 'hidden') {
        result.add({e: 1});
      }
    }
    return result;
  }
}
