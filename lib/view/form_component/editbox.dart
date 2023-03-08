import 'package:flutter/material.dart';
import 'package:misa_ui_flutter/model/json_schema/json_schema.dart';
import 'package:misa_ui_flutter/settings/misa_locale.dart';
import 'package:provider/provider.dart';

class Editbox extends StatefulWidget {
  final JsonSchema schema;
  final dynamic value;
  final ValueSetter<String?>? onSaved;
  final bool required;
  const Editbox({
    super.key,
    required this.schema,
    this.required = false,
    this.value,
    this.onSaved,
  });

  @override
  State<Editbox> createState() => _EditboxState();
}

class _EditboxState extends State<Editbox> {
  @override
  Widget build(BuildContext context) {
    final locale = context.watch<MisaLocale>();
    String title = locale.translate(widget.schema.title ?? widget.schema.key);
    Widget label = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title),
        if (widget.required)
          const Text('*', style: TextStyle(color: Colors.red, fontSize: 20)),
      ],
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: TextFormField(
        decoration: InputDecoration(
          label: label,
          border: const OutlineInputBorder(),
        ),
        textInputAction: TextInputAction.next,
        initialValue: widget.value?.toString(),
        onSaved: widget.onSaved,
        validator: (value) {
          if (widget.required && (value == null || value.isEmpty)) {
            return locale.translate('This field is required');
          }
          return null;
        },
      ),
    );
  }
}
