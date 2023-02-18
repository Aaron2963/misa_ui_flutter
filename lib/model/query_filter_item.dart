import 'package:misa_ui_flutter/model/json_schema/json_schema.dart';

enum QueryFilterConj { all, not, any }

enum QueryFilterOp { equal, contain, range }

final Set<String> dateComponents = {
  "datetime",
  "date",
  "week",
  "month",
  "time"
};

class QueryFilterItem {
  JsonSchema schema;
  QueryFilterItemOperator operator;
  String value1;
  String? value2;

  QueryFilterItem({
    required this.schema,
    required this.operator,
    required this.value1,
    this.value2,
  }) {
    if (operator.op == QueryFilterOp.range && value2 == null) {
      throw ArgumentError('value2 must not be null when op is range');
    }
  }

  factory QueryFilterItem.fromSchema({required JsonSchema schema}) {
    QueryFilterItemOperator operator;
    if ((schema.type == SchemaDataType.integer ||
            schema.component == 'number') ||
        dateComponents.contains(schema.component)) {
      operator = QueryFilterItemOperator(
          conj: QueryFilterConj.all, op: QueryFilterOp.equal);
    } else {
      operator = QueryFilterItemOperator(
          conj: QueryFilterConj.all, op: QueryFilterOp.contain);
    }
    return QueryFilterItem(
      schema: schema,
      operator: operator,
      value1: '',
    );
  }

  Set<QueryFilterItemOperator> get operators {
    if ((schema.type == SchemaDataType.integer ||
            schema.component == 'number') ||
        dateComponents.contains(schema.component)) {
      return {
        QueryFilterItemOperator(
            conj: QueryFilterConj.all, op: QueryFilterOp.equal),
        QueryFilterItemOperator(
            conj: QueryFilterConj.not, op: QueryFilterOp.equal),
        QueryFilterItemOperator(
            conj: QueryFilterConj.all, op: QueryFilterOp.range),
        QueryFilterItemOperator(
            conj: QueryFilterConj.not, op: QueryFilterOp.range),
      };
    }
    return {
      QueryFilterItemOperator(
          conj: QueryFilterConj.all, op: QueryFilterOp.contain),
      QueryFilterItemOperator(
          conj: QueryFilterConj.not, op: QueryFilterOp.contain),
      QueryFilterItemOperator(
          conj: QueryFilterConj.all, op: QueryFilterOp.equal),
      QueryFilterItemOperator(
          conj: QueryFilterConj.not, op: QueryFilterOp.equal),
    };
  }

  Map<String, Map> toJson() {
    dynamic value;
    switch (operator.op) {
      case QueryFilterOp.equal:
        value = value1;
        break;
      case QueryFilterOp.contain:
        value = [value1];
        break;
      case QueryFilterOp.range:
        value = [value1, value2];
        break;
    }
    return {
      operator.op.toString().split('.').last: {
        schema.key: value,
      }
    };
  }
}

class QueryFilterItemOperator {
  QueryFilterConj conj;
  QueryFilterOp op;

  QueryFilterItemOperator({
    required this.conj,
    required this.op,
  });

  factory QueryFilterItemOperator.fromString(String str) {
    List<String> parts = str.split(' ');
    QueryFilterConj conj = QueryFilterConj.values.firstWhere(
        (element) => element.toString().split('.').last == parts[0]);
    QueryFilterOp op = QueryFilterOp.values.firstWhere(
        (element) => element.toString().split('.').last == parts[1]);
    return QueryFilterItemOperator(conj: conj, op: op);
  }

  @override
  String toString() {
    return '${conj.toString().split('.').last} ${op.toString().split('.').last}';
  }

  @override
  // ignore: hash_and_equals
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is QueryFilterItemOperator &&
        other.conj == conj &&
        other.op == op;
  }
}

extension QueryFilterConjExtension on QueryFilterConj {
  String toUpperCase() {
    String result = toString().split('.').last;
    return result[0].toUpperCase() + result.substring(1);
  }
}