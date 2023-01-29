import 'package:misa_ui_flutter/model/json_schema/json_schema.dart';

class ObjectJsonSchema extends JsonSchema {
  final Map<String, JsonSchema>? properties;
  final Set<JsonSchema>? required;
  final Map<String, Set<JsonSchema>>? dependentRequired;
  final List<String>? render;
  final List? layout;

  ObjectJsonSchema({
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
    super.event,
    super.formOnly,
    super.readOnly,
    super.disabled,
    super.value,
  }) : super(type: SchemaDataType.object);

  factory ObjectJsonSchema.fromJson(Map<String, dynamic> json) {
    Map<String, JsonSchema> properties = {};
    Set<JsonSchema> required = {};
    Map<String, Set<JsonSchema>> dependentRequired = {};
    for (var key in json['properties'].keys) {
      properties[key.toString()] = JsonSchema.fromJson(json['properties'][key]);
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
          dependentRequiredSet.add(properties[dependentRequiredKey.toString()]!);
        }
        dependentRequired[key.toString()] = dependentRequiredSet;
      }
    }

    return ObjectJsonSchema(
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
