import 'package:flutter/material.dart';
import 'package:misa_ui_flutter/settings/view_settings.dart';

final _viewSettings = ViewSettings();

class TopNavigationBar extends AppBar {
  final String titleText;
  TopNavigationBar(this.titleText, {super.key})
      : super(
          title: Text(titleText),
          backgroundColor: _viewSettings.backgroundColor,
          elevation: 0,
        );
}
