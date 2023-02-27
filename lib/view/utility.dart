import 'package:flutter/material.dart';
import 'package:misa_ui_flutter/settings/misa_locale.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

//開啟網址
void launchUrl(BuildContext context, String url) {
  try {
    launchUrlString(url);
  } catch (e) {
    final locale = context.read<MisaLocale>();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(locale.translate('Cannot open url'))),
    );
  }
}