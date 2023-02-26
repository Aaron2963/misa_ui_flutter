import 'package:flutter/foundation.dart';

enum ViewMode { root, detail, form }

class AdvancedView {
  final String title;
  final ViewMode viewMode;
  final List<Map<String, dynamic>> data;
  final VoidCallback onDispose;

  AdvancedView({
    required this.title,
    required this.viewMode,
    required this.data,
    required this.onDispose,
  });
}
