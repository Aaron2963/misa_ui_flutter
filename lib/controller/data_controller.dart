import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:misa_ui_flutter/controller/auth_controller.dart';
import 'package:misa_ui_flutter/controller/mock/short_data.dart';
import 'package:misa_ui_flutter/controller/router_mapping.dart';
import 'package:misa_ui_flutter/controller/settings.dart';
import 'package:misa_ui_flutter/model/data_payload.dart';
import 'package:misa_ui_flutter/model/query_filter.dart';
import 'package:misa_ui_flutter/settings/view_settings.dart';

class DataController {
  final String tableName;
  final String schemaPath;
  final String apiRoot = dotenv.env['DATA_API_ROOT'] as String;
  QueryFilter? filter;

  DataController(this.tableName, this.schemaPath);

  String get resourceName => tableName.toLowerCase().replaceAll(':', '.');

  Future<DataPayload> select(int offset, int limit) async {
    try {
      final Map<String, dynamic> data = {
        '\$schema': schemaPath,
        'offset': offset.toString(),
        'limit': limit.toString(),
      };
      if (filter != null) {
        data.addAll(filter!.toFlatMap());
      }
      final response = await httpClient.post(
        Uri.parse('$apiRoot${RouterMapping.get(tableName, 'select')}'),
        headers: {'Authorization': AuthController.bearerToken},
        body: data,
      );
      if (response.statusCode != 200) {
        throw Exception(
            'Failed to load data: status code ${response.statusCode}');
      }
      final responseBody = utf8.decoder.convert(response.bodyBytes);
      final json = jsonDecode(responseBody);
      // show error message
      if (json.containsKey('_Error') && json['_Error'] == true) {
        final message = json['Message'];
        ViewSettings()
            .snackBarKey
            .currentState
            ?.showSnackBar(SnackBar(content: Text(message)));
        throw Exception(message);
      }
      // return data
      return DataPayload.fromJson(
        json: json,
        offset: offset,
        filter: filter,
      );
    } catch (e) {
      debugPrint('[ERROR] select $tableName');
      debugPrint(e.toString());
    }
    return DataPayload.empty();
  }

  Future<DataPayload> briefSelect() async {
    try {
      final response = await httpClient.post(
        Uri.parse('$apiRoot${RouterMapping.get(tableName, 'select')}'),
        headers: {'Authorization': AuthController.bearerToken},
      );
      if (response.statusCode != 200) {
        throw Exception(
            'Failed to load data: status code ${response.statusCode}');
      }
      final responseBody = utf8.decoder.convert(response.bodyBytes);
      final json = jsonDecode(responseBody);
      // show error message
      if (json.containsKey('_Error') && json['_Error'] == true) {
        final message = json['Message'];
        ViewSettings()
            .snackBarKey
            .currentState
            ?.showSnackBar(SnackBar(content: Text(message)));
        throw Exception(message);
      }
      // return data
      return DataPayload.fromJson(
        json: json,
        offset: 0,
      );
    } catch (e) {
      debugPrint('[ERROR] briefSelect $tableName');
      debugPrint(e.toString());
    }
    return DataPayload.empty();
  }

  Future<DataPayload> create(Map<String, dynamic> data) async {
    final Map<String, dynamic> payload = {'\$schema': schemaPath, ...data};
    try {
      final response = await httpClient.post(
        Uri.parse('$apiRoot${RouterMapping.get(tableName, 'create')}'),
        headers: {'Authorization': AuthController.bearerToken},
        body: payload,
      );
      if (response.statusCode != 200) {
        throw Exception(
            'Failed to load data: status code ${response.statusCode}');
      }
      final responseBody = utf8.decoder.convert(response.bodyBytes);
      final json = jsonDecode(responseBody);
      // show error message
      if (json.containsKey('_Error') && json['_Error'] == true) {
        final message = json['Message'];
        ViewSettings()
            .snackBarKey
            .currentState
            ?.showSnackBar(SnackBar(content: Text(message)));
        throw Exception(message);
      }
      // return data
      return DataPayload.single(json);
    } catch (e) {
      return DataPayload.empty();
    }
  }

  Future<DataPayload> update(Map<String, dynamic> data) {
    return create(data);
  }

  Future<DataPayload> delete(Map<String, dynamic> data) {
    // TODO: implement delete
    return Future.delayed(const Duration(seconds: 1), () {
      return DataPayload.single(mockData['datas'][0]);
    });
  }
}
