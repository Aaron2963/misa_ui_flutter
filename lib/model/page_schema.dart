import 'package:misa_ui_flutter/model/json_schema/json_schema.dart';
import 'package:misa_ui_flutter/model/json_schema/object_json_schema.dart';

class PageSchema extends ObjectJsonSchema {
  final List<JsonSchema>? headers;
  final List<JsonSchema>? options;
  final List<JsonSchema>? order;
  final List<JsonSchema>? filter;

  PageSchema({
    required super.properties,
    this.headers,
    this.options,
    this.order,
    this.filter,
    super.required,
    super.dependentRequired,
    super.render,
    super.layout,
    super.dollarId,
    super.dollarRef,
    super.dollarSchema = 'http://json-schema.org/draft-06/schema#',
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
  });

  factory PageSchema.fromJson(Map<String, dynamic> json) {
    Map<String, JsonSchema> properties = {};
    Set<JsonSchema> required = {};
    Map<String, Set<JsonSchema>> dependentRequired = {};
    List<JsonSchema> headers = [];
    List<JsonSchema> options = [];
    List<JsonSchema> order = [];
    List<JsonSchema> filter = [];
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
          dependentRequiredSet
              .add(properties[dependentRequiredKey.toString()]!);
        }
        dependentRequired[key.toString()] = dependentRequiredSet;
      }
    }
    if (json['headers'] != null) {
      for (var key in json['headers']) {
        headers.add(properties[key.toString()]!);
      }
    }
    if (json['options'] != null) {
      for (var key in json['options']) {
        options.add(properties[key.toString()]!);
      }
    }
    if (json['order'] != null) {
      for (var key in json['order']) {
        order.add(properties[key.toString()]!);
      }
    }
    if (json['filter'] != null) {
      for (var key in json['filter']) {
        filter.add(properties[key.toString()]!);
      }
    }

    return PageSchema(
      properties: properties,
      required: required,
      dependentRequired: dependentRequired,
      headers: headers,
      options: options,
      order: order,
      filter: filter,
      render: json['render'] != null
          ? (json['render'] as List).map((e) => e.toString()).toList()
          : null,
      layout: json['layout'],
      dollarId: json['\$id'],
      dollarRef: json['\$ref'],
      atId: json['@id'],
      atTable: json['@table'],
      description: json['description'],
      title: json['title'],
    );
  }

  factory PageSchema.blank() {
    return PageSchema(
      properties: {},
      required: {},
      dependentRequired: {},
      headers: [],
      options: [],
      order: [],
      filter: [],
    );
  }
}
