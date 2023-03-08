import 'package:flutter/material.dart';
import 'package:misa_ui_flutter/view/body/page_body/form_cache.dart';

enum ViewMode { root, detail, form }

class AdvancedView {
  final String title;
  final ViewMode viewMode;
  final List<Map<String, dynamic>> data;
  final VoidCallback? onDispose;
  final GlobalKey<FormState>? formKey;
  final FormCache? formCache;

  AdvancedView({
    required this.title,
    required this.viewMode,
    required this.data,
    this.onDispose,
    this.formKey,
    this.formCache,
  });
}
