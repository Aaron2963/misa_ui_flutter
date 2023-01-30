import 'package:flutter/material.dart';
import 'package:misa_ui_flutter/settings/misa_locale.dart';
import 'package:misa_ui_flutter/view/body/body.dart';
import 'package:provider/provider.dart';

class FilterFeature extends StatelessWidget {
  const FilterFeature({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<MisaLocale>();
    return ElevatedButton.icon(
      icon: const Icon(Icons.filter_alt_outlined),
      label: Text(locale.translate('Filter')),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => const _FilterDialog(),
          barrierDismissible: false,
        );
      },
    );
  }
}

class _FilterDialog extends StatelessWidget {
  const _FilterDialog();

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
    final pageSchema = context.watch<BodyStateProvider>().pageSchema!;
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
              '${locale.translate('Filter:')}${locale.translate(pageSchema.title ?? '')}'),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      content: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
          maxWidth: MediaQuery.of(context).size.width * 0.8,
          minWidth: MediaQuery.of(context).size.width * 0.5,
        ),
        child: Text(pageSchema.title ?? ''),
        // TODO: filter panel
      ),
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
    );
  }
}
