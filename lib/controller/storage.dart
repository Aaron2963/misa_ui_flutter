import 'package:localstorage/localstorage.dart';

final storage = Storage();

class Storage {
  final String storageName = 'misa_ui_flutter';
  late final LocalStorage _stoage;

  Storage() {
    _stoage = LocalStorage(storageName);
  }

  Future<bool> ready() {
    return _stoage.ready;
  }

  dynamic getItem(String key) {
    return _stoage.getItem(key);
  }

  Future<void> setItem(String key, dynamic value) {
    return _stoage.setItem(key, value);
  }

  Future<void> deleteItem(String key) {
    return _stoage.deleteItem(key);
  }

  Future<void> clear() {
    return _stoage.clear();
  }
}
