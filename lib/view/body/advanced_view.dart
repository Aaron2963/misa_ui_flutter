import 'package:flutter/material.dart';

enum ViewMode { root, detail, form }

class AdvancedView {
  final String title;
  final ViewMode viewMode;
  final List<Map<String, dynamic>> data;
  final VoidCallback? onDispose;
  final GlobalKey<FormState>? formKey;

  AdvancedView({
    required this.title,
    required this.viewMode,
    required this.data,
    this.onDispose,
    this.formKey,
  });
}
