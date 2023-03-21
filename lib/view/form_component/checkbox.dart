import 'package:flutter/material.dart';
import 'package:misa_ui_flutter/model/json_schema/boolean_json_schema.dart';
import 'package:misa_ui_flutter/model/json_schema/string_json_schema.dart';
import 'package:misa_ui_flutter/settings/misa_locale.dart';
import 'package:misa_ui_flutter/view/form_component/form_component_controller.dart';
import 'package:provider/provider.dart';

class Checkbox extends StatefulWidget {
  final FormComponentController controller;
  final bool isOneWay;
  const Checkbox({super.key, required this.controller, this.isOneWay = false});

  @override
  State<Checkbox> createState() => _CheckboxState();
}

class _CheckboxState extends State<Checkbox> {
  bool currentValue = false;
  late final bool originalValue;
  late final FormComponentController _controller;
  String? _label;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    if (_controller.schema is BooleanJsonSchema) {
      _label = (_controller.schema as BooleanJsonSchema).text;
    }
    if (_controller.schema is StringJsonSchema) {
      _label = (_controller.schema as StringJsonSchema).text;
    }
    _label = _label ?? _controller.schema.title ?? _controller.schema.key;
    originalValue =
        _controller.value != null ? _controller.value == true : currentValue;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_controller.value != null) {
        setState(() {
          currentValue = _controller.value == true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<MisaLocale>();
    final disabled = widget.isOneWay && originalValue;
    return InkWell(
      onTap: disabled
          ? null
          : () {
              setState(() {
                currentValue = !currentValue;
              });
              _controller.onChanged?.call(currentValue);
            },
      child: FormField<bool>(
        builder: (context) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                !currentValue
                    ? const Icon(Icons.check_box_outline_blank,
                        color: Colors.blue)
                    : Icon(
                        Icons.check_box,
                        color: disabled ? Colors.grey : Colors.blue,
                      ),
                const SizedBox(width: 8),
                Text(locale.translate(_label ?? '')),
              ],
            ),
          );
        },
        validator: (value) => null,
        onSaved: (newValue) => _controller.onSaved?.call(currentValue),
      ),
    );
  }
}
