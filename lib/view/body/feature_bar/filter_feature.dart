import 'package:flutter/material.dart';
import 'package:misa_ui_flutter/settings/misa_locale.dart';
import 'package:misa_ui_flutter/view/body/body.dart';
import 'package:misa_ui_flutter/view/body/rich_dialog.dart';
import 'package:provider/provider.dart';

class FilterFeature extends StatelessWidget {
  const FilterFeature({super.key});

  void _onReset(BuildContext context) {
    // TODO: reset filter
    Navigator.of(context).pop();
  }

  void _onFilter(BuildContext context) {
    // TODO: submit filter
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<MisaLocale>();
    final viewMenuItem = context.watch<BodyStateProvider>().viewMenuItem!;
    return RichDialog(
      title: '${locale.translate('Filter:')}${locale.translate(viewMenuItem.title)}',
      actions: [
        TextButton(
          onPressed: () => _onReset(context),
          child: Text(locale.translate('Reset')),
        ),
        TextButton(
          onPressed: () => _onFilter(context),
          child: Text(locale.translate('Filter')),
        ),
      ],
      content: Text(viewMenuItem.title), // TODO: filter panel
    );
  }
}
