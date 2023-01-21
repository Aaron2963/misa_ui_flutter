import 'package:flutter/foundation.dart';
import 'package:misa_ui_flutter/controller/dictionary_controller.dart';

class MisaLocale extends ChangeNotifier {
  String langCode = 'enUS';
  Map<String, String> dictionary = {};
  Set<String> missingKeys = {};

  Future<void> setLangCode(String langCode) async {
    this.langCode = langCode;
    await loadDictionary();
    missingKeys.clear();
    notifyListeners();
    return;
  }

  Future<void> loadDictionary() async {
    DictionaryController controller = DictionaryController(langCode);
    dictionary = await controller.getDictionary();
    return;
  }

  String translate(String key) {
    if (!dictionary.containsKey(key)) {
      missingKeys.add(key);
    }
    return dictionary[key] ?? key;
  }
}
