import 'package:misa_ui_flutter/model/page_schema.dart';
import 'package:misa_ui_flutter/model/query_filter_item.dart';

class QueryFilter {
  Map<int, QueryFilterItem> conditions = {};
  int _count = 0;

  QueryFilter();

  int add(QueryFilterItem item) {
    conditions[++_count] = item;
    return _count;
  }

  void remove(int id) {
    conditions.remove(id);
  }

  factory QueryFilter.fromJson(
      PageSchema pageSchema, Map<String, List<Map<String, Map>>> json) {
    QueryFilter result = QueryFilter();
    json.forEach((String conjStr, List<Map<String, Map>> items) {
      final conj = QueryFilterConj.values.firstWhere(
          (e) => e.toString().split('.').last == conjStr.toLowerCase());
      for (final Map<String, Map> item in items) {
        final op = QueryFilterOp.values
            .firstWhere((e) => e.toString().split('.').last == item.keys.first);
        final entry = item.values.first;
        result.add(QueryFilterItem(
          schema: pageSchema.properties![entry.keys.first]!,
          operator: QueryFilterItemOperator(conj: conj, op: op),
          value1: entry.values.first is List
              ? entry.values.first[0]
              : entry.values.first,
          value2: op == QueryFilterOp.range ? entry.values.first[1] : null,
        ));
      }
    });
    return result;
  }

  Map<String, List<Map<String, Map>>> toJson() {
    Map<String, List<Map<String, Map>>> result = {};
    for (final item in conditions.values) {
      String conj = item.operator.conj.toUpperCase();
      result.putIfAbsent(conj, () => <Map<String, Map>>[]);
      result[conj]!.add(item.toJson());
    }
    return result;
  }

  Map<String, String> toFlatMap() {
    final Map<String, String> result = {};
    Map<String, List<Map<String, Map>>> json = toJson();
    for (final conj in json.keys) {
      for (int i = 0; i < json[conj]!.length; i++) {
        final item = json[conj]![i];
        for (final op in item.keys) {
          for (final key in item[op]!.keys) {
            final value = item[op]![key];
            if (value is List) {
              for (int j = 0; j < value.length; j++) {
                result['$conj[$i][$op][$key][$j]'] = value[j];
              }
            } else {
              result['$conj[$i][$op][$key]'] = value;
            }
          }
        }
      }
    }
    return result;
  }
}
