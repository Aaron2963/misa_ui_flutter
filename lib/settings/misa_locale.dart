import 'package:flutter/material.dart';
import 'package:misa_ui_flutter/controller/dictionary_controller.dart';

class MisaLocale extends ChangeNotifier {
  String langCode = 'enUS';
  Map<String, String> dictionary = {};
  Set<String> missingKeys = {};

  Locale get locale =>
      Locale(langCode.substring(0, 2), langCode.substring(2, 4));

  bool get separatorNeeded {
    Set<String> hasSeparator = {'en'};
    String lang = langCode.substring(0, 2);
    return hasSeparator.contains(lang);
  }

  Future<void> setLangCode(String langCode) async {
    this.langCode = langCode;
    await loadDictionary();
    missingKeys.clear();
    notifyListeners();
    return;
  }

  // TODO: 改為使用 flutter_localizations 管理應用程式中的介面語言，資料欄位名稱等依然由網路下載的字典檔管理

  Future<void> loadDictionary() async {
    DictionaryController controller = DictionaryController(langCode);
    dictionary = await controller.getDictionary();
    return;
  }

  String translate(String key, [String? substring]) {
    String result = dictionary[key] ?? key;
    if (substring != null) {
      result = result.replaceAll('%s', substring);
    }
    if (!dictionary.containsKey(key)) {
      missingKeys.add(key);
    }
    return result;
  }
}
