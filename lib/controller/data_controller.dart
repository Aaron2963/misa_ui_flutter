import 'package:misa_ui_flutter/controller/mock/data.dart';
import 'package:misa_ui_flutter/model/data_payload.dart';
import 'package:misa_ui_flutter/model/query_filter.dart';

class DataController {
  final String tableName;
  QueryFilter? filter;

  DataController(this.tableName);

  String get resourceName => tableName.toLowerCase().replaceAll(':', '.');

  Future<DataPayload> select(int offset, int limit) {
    return Future.delayed(const Duration(seconds: 1), () {
      return DataPayload.fromJson(
        json: mockData,
        offset: offset,
        filter: filter,
      );
    });
  }

  Future<DataPayload> create(Map<String, dynamic> data) {
    return Future.delayed(const Duration(seconds: 1), () {
      return DataPayload.single(mockData['datas'][0]);
    });
  }

  Future<DataPayload> update(Map<String, dynamic> data) {
    return Future.delayed(const Duration(seconds: 1), () {
      return DataPayload.single(mockData['datas'][0]);
    });
  }

  Future<DataPayload> delete(Map<String, dynamic> data) {
    return Future.delayed(const Duration(seconds: 1), () {
      return DataPayload.single(mockData['datas'][0]);
    });
  }
}
