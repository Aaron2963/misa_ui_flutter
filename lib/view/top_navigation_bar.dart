import 'package:flutter/material.dart';
import 'package:misa_ui_flutter/settings/view_settings.dart';

final _viewSettings = ViewSettings();

class TopNavigationBar extends AppBar {
  final String titleText;
  final VoidCallback onLogout;

  TopNavigationBar(this.titleText, this.onLogout, {super.key})
      : super(
          title: Text(titleText),
          backgroundColor: _viewSettings.backgroundColor,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: onLogout,
            ),
          ],
        );
}
