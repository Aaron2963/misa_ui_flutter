import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as m show Switch;
import 'package:misa_ui_flutter/model/json_schema/boolean_json_schema.dart';
import 'package:misa_ui_flutter/settings/misa_locale.dart';
import 'package:misa_ui_flutter/view/form_component/form_component_controller.dart';
import 'package:provider/provider.dart';

class Switch extends StatefulWidget {
  final FormComponentController controller;
  const Switch({super.key, required this.controller});

  @override
  State<Switch> createState() => _SwitchState();
}

class _SwitchState extends State<Switch> {
  bool currentValue = false;
  late final FormComponentController _controller;
  late final BooleanJsonSchema _schema;
  late final String _label;
  late final String _labelFalse;
  late final String _labelTrue;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _schema = _controller.schema as BooleanJsonSchema;
    _label = _schema.text ?? _schema.title ?? _schema.key;
    _labelFalse = '${_label}_False';
    _labelTrue = '${_label}_True';
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
    print('currentValue: $currentValue');
    return InkWell(
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0),
      ),
      onTap: () {
        setState(() {
          currentValue = !currentValue;
        });
        _controller.onChanged?.call(currentValue);
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(locale.translate(_schema.title ?? _schema.key)),
            const SizedBox(height: 8.0),
            FormField<bool>(
              builder: (context) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(locale.translate(_labelFalse)),
                    m.Switch(
                      value: currentValue,
                      onChanged: (value) {
                        setState(() {
                          currentValue = value;
                        });
                        _controller.onChanged?.call(currentValue);
                      },
                    ),
                    Text(locale.translate(_labelTrue)),
                  ],
                );
              },
              validator: (value) => null,
              onSaved: (newValue) => _controller.onSaved?.call(currentValue),
            ),
          ],
        ),
      ),
    );
  }
}
