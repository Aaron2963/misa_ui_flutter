import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:misa_ui_flutter/controller/settings.dart';

class DictionaryController {
  final String langCode;

  DictionaryController(this.langCode);

  Future<Map<String, String>> getDictionary() async {
    final response = await httpClient
        .get(Uri.parse('${dotenv.env['LANG_API_ROOT']}$langCode.lang'));
    if (response.statusCode != 200) {
      throw Exception(
          'Failed to load dictionary: status code ${response.statusCode}');
    }
    final responseBody = utf8.decoder.convert(response.bodyBytes);
    return Map<String, String>.from(jsonDecode(responseBody));
  }
}
