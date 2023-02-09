
enum QueryFilterConj { all, not, any }

enum QueryFilterOp { equal, contain, range }

class QueryFilter {
  Map<QueryFilterConj, Map<QueryFilterOp, List>> conditions = {
    QueryFilterConj.all: {
      QueryFilterOp.equal: [],
      QueryFilterOp.contain: [],
      QueryFilterOp.range: [],
    },
    QueryFilterConj.any: {
      QueryFilterOp.equal: [],
      QueryFilterOp.contain: [],
      QueryFilterOp.range: [],
    },
    QueryFilterConj.not: {
      QueryFilterOp.equal: [],
      QueryFilterOp.contain: [],
      QueryFilterOp.range: [],
    },
  };

  QueryFilter();

  factory QueryFilter.fromJson(Map<String, dynamic> json) {
    QueryFilter filter = QueryFilter();
    for (String conj in json.keys) {
      QueryFilterConj conjEnum = QueryFilterConj.values.firstWhere(
          (element) => element.toString().split('.').last == conj.toLowerCase());
      for (String op in json[conj].keys) {
        QueryFilterOp opEnum = QueryFilterOp.values.firstWhere(
            (element) => element.toString().split('.').last == op.toLowerCase());
        for (Map<String, dynamic> condition in json[conj][op]) {
          String property = condition.keys.first;
          dynamic value = condition.values.first;
          filter.add(property: property, value: value, op: opEnum, conj: conjEnum);
        }
      }
    }
    return filter;
  }

  void add({
    required String property,
    required dynamic value,
    QueryFilterOp op = QueryFilterOp.equal,
    QueryFilterConj conj = QueryFilterConj.all,
  }) {
    if (op == QueryFilterOp.contain && value is! List) {
      value = [value];
    }
    if (op == QueryFilterOp.range && (value is! List || value.length != 2)) {
      throw Exception('Range value must be a list of 2 elements');
    }
    conditions[conj]![op]!.add({property: value});
  }

  Map<String, List> toMap() {
    Map<String, List> result = {
      'All': [],
      'Any': [],
      'Not': [],
    };
    for (QueryFilterConj conj in conditions.keys) {
      String conjStr = conj.toString().split('.').last;
      conjStr = conjStr[0].toUpperCase() + conjStr.substring(1);
      for (QueryFilterOp op in conditions[conj]!.keys) {
        String opStr = op.toString().split('.').last;
        for (Map<String, dynamic> condition in conditions[conj]![op]!) {
          String property = condition.keys.first;
          dynamic value = condition.values.first;
          if (op == QueryFilterOp.equal) {
            result[conjStr]!.add({opStr:{property: value}});
          } else if (op == QueryFilterOp.contain) {
            result[conjStr]!.add({opStr:{property: value}});
          } else if (op == QueryFilterOp.range) {
            result[conjStr]!.add({opStr:{property: value}});
          }
        }
      }
    }

    return result;
  }
}
