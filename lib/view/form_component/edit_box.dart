import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:misa_ui_flutter/settings/misa_locale.dart';
import 'package:misa_ui_flutter/view/form_component/form_component_controller.dart';
import 'package:provider/provider.dart';

class EditBox extends StatefulWidget {
  final FormComponentController controller;
  final bool obscureText;
  final bool isNumber;
  const EditBox({
    super.key,
    required this.controller,
    this.obscureText = false,
    this.isNumber = false,
  });

  @override
  State<EditBox> createState() => _EditBoxState();
}

class _EditBoxState extends State<EditBox> {
  late final FormComponentController _controller;
  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_controller.value != null) {
        _controller.onChanged?.call(_controller.value.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<MisaLocale>();
    String title =
        locale.translate(_controller.schema.title ?? _controller.schema.key);
    Widget label = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title),
        if (_controller.required)
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
        initialValue: _controller.value?.toString(),
        obscureText: widget.obscureText,
        inputFormatters: [
          if (widget.isNumber) FilteringTextInputFormatter.allow(RegExp('[.0-9]')),
        ],
        onSaved: _controller.onSaved,
        onChanged: _controller.onChanged,
        validator: (value) {
          if (_controller.required && (value == null || value.isEmpty)) {
            return locale.translate('This field is required');
          }
          return null;
        },
      ),
    );
  }
}
