class RouterMapping {
  static final Map<String, Map<String, String>> _routers = {};

  static void add(String tableName, String action, String resource) {
    _routers.putIfAbsent(tableName, () => <String, String>{});
    _routers[tableName]![action] = resource;
  }

  static String? get(String tableName, String action) {
    if (_routers.containsKey(tableName)) {
      return _routers[tableName]![action];
    }
    return null;
  }
}
