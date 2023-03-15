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
    final List<Map<String, dynamic>> dataRows = [];
    if (json['datas'] is List) {
      for (final row in json['datas']) {
        dataRows.add(Map<String, dynamic>.from(row));
      }
    }
    return DataPayload(
      offset: offset,
      total: int.parse(json['total'].toString()),
      page: int.parse(json['page'].toString()),
      redirectUrl: json['redirectUrl'],
      data: dataRows,
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

  factory DataPayload.empty() {
    return DataPayload(
      offset: 0,
      total: 0,
      page: 1,
      data: [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'offset': offset,
      'page': page,
      'redirectUrl': redirectUrl,
      'filter': filter?.toJson(),
      'datas': data,
    };
  }

  void set(int index, String key, dynamic value) {
    if (data.length <= index) return;
    data[index][key] = value;
  }

  dynamic get(int index, String key) {
    if (data.length <= index) return null;
    return data[index][key];
  }
}
