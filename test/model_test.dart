import 'package:misa_ui_flutter/model/query_filter.dart';

void main() {
  QueryFilter filter = QueryFilter();
  filter.add(property: 'name', value: 'John', op: QueryFilterOp.contain);
  filter.add(property: 'age', value: 20, op: QueryFilterOp.equal);
  filter.add(property: 'gender', value: 'male', op: QueryFilterOp.equal);
  filter.add(property: 'age', value: [20, 30], op: QueryFilterOp.range);
  print(filter.toMap());
}
