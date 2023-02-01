import 'package:flutter/material.dart';
import 'package:misa_ui_flutter/model/menu_item.dart';
import 'package:misa_ui_flutter/settings/misa_locale.dart';
import 'package:misa_ui_flutter/view/body/body.dart';
import 'package:misa_ui_flutter/view/body/rich_dialog.dart';
import 'package:provider/provider.dart';

class InsertFeature extends StatelessWidget {
  const InsertFeature({super.key});

  void _onSave(BuildContext context) {
    // TODO: submit
    Navigator.of(context).pop();
  }

  void _onSaveAsNew(BuildContext context) {
    // TODO: submit
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<MisaLocale>();
    final viewMenuItem = context.watch<BodyStateProvider>().viewMenuItem!;
    List<Widget> actions = [
      TextButton(
        onPressed: () => _onSave(context),
        child: Text(locale.translate('Save')),
      ),
    ];
    if (viewMenuItem.features.contains(ViewFeature.saveAsNew)) {
      actions.insert(
        0,
        TextButton(
          onPressed: () => _onSaveAsNew(context),
          child: Text(locale.translate('Save as New')),
        ),
      );
    }
    return RichDialog(
      title:
          '${locale.translate('Insert')}${locale.translate(viewMenuItem.title)}',
      viewType: ViewType.form,
      content: Text(viewMenuItem.title), // TODO: form view
    );
  }
}
