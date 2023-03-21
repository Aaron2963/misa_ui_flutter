import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:misa_ui_flutter/controller/settings.dart';
import 'package:misa_ui_flutter/controller/storage.dart';

class AuthController {
  static String token = '';
  static String get bearerToken => 'Bearer $token';

  Future<String?> login(
    String loginName,
    String password, [
    String customerAlias = '',
  ]) async {
    try {
      final response = await httpClient.post(
        Uri.parse(dotenv.env['LOGIN_API_URL']!),
        body: <String, dynamic>{
          'LoginName': loginName,
          'PWD': password,
          'CustomerAlias': customerAlias,
        },
      );
      if (response.statusCode == 200) {
        final responseBody = utf8.decoder.convert(response.bodyBytes);
        final data = jsonDecode(responseBody);
        if (data.containsKey('ACSToken')) {
          token = data['ACSToken'];
          await cacheToken();
          return null;
        }
      }
    } catch (e) {
      debugPrint('[AuthController.login] error');
      debugPrint(e.toString());
    }
    return 'log-in-notification-fail';
  }

  Future<bool> checkLogin() async {
    if (token.isEmpty) {
      token = await storage.getItem('token') ?? '';
    }
    if (token.isEmpty) {
      return false;
    }
    final response = await httpClient.post(
      Uri.parse(dotenv.env['CHECK_LOGIN_API_URL']!),
      headers: {'Authorization': bearerToken},
    );
    if (response.statusCode == 200) {
      final responseBody = utf8.decoder.convert(response.bodyBytes);
      return responseBody.contains('"ACSToken":');
    }
    await clearToken();
    return false;
  }

  Future logout() async {
    await clearToken();
    return;
  }

  Future cacheToken() async {
    await storage.setItem('token', token);
    return;
  }

  Future clearToken() async {
    token = '';
    await storage.deleteItem('token');
    return;
  }
}
