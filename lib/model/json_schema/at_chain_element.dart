import 'package:misa_ui_flutter/model/json_schema/json_schema.dart';
import 'package:misa_ui_flutter/model/json_schema/object_json_schema.dart';
import 'package:misa_ui_flutter/model/json_schema/string_json_schema.dart';

class AtChainElement extends ObjectJsonSchema {
  final String titleFieldName;
  AtChainElement({
    required this.titleFieldName,
    required String atTable,
    required String atId,
    String key = 'atChain',
  }) : super(
          key: key,
          atId: atId,
          atTable: atTable,
          properties: {
            atId: StringJsonSchema(key: atId, atColumn: atId),
            titleFieldName: StringJsonSchema(
              key: titleFieldName,
              purpose: {SchemaPurpose.caption},
            ),
          },
        );

  factory AtChainElement.fromJson(Map<String, dynamic> json) {
    String title = '';
    for (String k in json['properties'].keys) {
      if (k == json['@id']) continue;
      title = k;
      break;
    }
    return AtChainElement(
      titleFieldName: title,
      atTable: json['@table'],
      atId: json['@id'],
    );
  }
}
