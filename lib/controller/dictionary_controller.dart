import 'package:misa_ui_flutter/controller/mock/dictionary.dart';

class DictionaryController {
  final String langCode;
  DictionaryController(this.langCode);
  Future<Map<String, String>> getDictionary() async {
    Map<String, String> result = {};
    // TODO: get dictionary from server
    result = mockDictionary;
    return result;
  }
}
