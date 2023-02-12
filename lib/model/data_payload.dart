import 'dart:convert';

import 'package:misa_ui_flutter/model/query_filter.dart';

class DataPayload {
  final int total;
  final int offset;
  final int page;
  final String? redirectUrl;
  final QueryFilter? filter;
  final String _dataJson;

  List<Map<String, dynamic>> get data {
    List dataList = jsonDecode(_dataJson) as List;
    return dataList.map((e) => e as Map<String, dynamic>).toList();
  }

  DataPayload({
    required this.total,
    required this.offset,
    required this.page,
    required List<Map<String, dynamic>> data,
    this.redirectUrl,
    this.filter,
  }) : _dataJson = jsonEncode(data);

  factory DataPayload.fromJson({
    required Map<String, dynamic> json,
    int offset = 0,
    QueryFilter? filter,
  }) {
    return DataPayload(
      offset: offset,
      total: int.parse(json['total'].toString()),
      page: int.parse(json['page'].toString()),
      redirectUrl: json['redirectUrl'],
      data: json['datas'] ?? <Map<String, dynamic>>[],
      filter: filter,
    );
  }

  factory DataPayload.single(Map<String, dynamic> json) {
    return DataPayload(
      offset: 0,
      total: 1,
      page: 1,
      data: [json],
    );
  }
}
