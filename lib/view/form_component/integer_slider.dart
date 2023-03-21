import 'package:flutter/material.dart';
import 'package:misa_ui_flutter/model/json_schema/integer_json_schema.dart';
import 'package:misa_ui_flutter/settings/misa_locale.dart';
import 'package:misa_ui_flutter/view/form_component/form_component_controller.dart';
import 'package:provider/provider.dart';

class IntegerSlider extends StatefulWidget {
  final FormComponentController controller;
  IntegerSlider({
    super.key,
    required this.controller,
  }) {
    assert(controller.schema is IntegerJsonSchema);
  }

  @override
  State<IntegerSlider> createState() => _IntegerSliderState();
}

class _IntegerSliderState extends State<IntegerSlider> {
  late final FormComponentController _controller;
  late final IntegerJsonSchema schema;
  late final double max;
  late final double min;
  late final int divisions;
  double value = 0;
  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_controller.value != null) {
        _controller.onChanged?.call(_controller.value.toString());
      }
    });
    schema = _controller.schema as IntegerJsonSchema;
    min = schema.minimum != null
        ? double.tryParse(schema.minimum.toString()) ?? 0
        : 0;
    max = schema.maximum != null
        ? double.tryParse(schema.maximum.toString()) ?? min
        : min;
    divisions = schema.step != null ? (max - min) ~/ schema.step! : 5;
    value = _controller.value as double? ??
        double.tryParse(schema.value.toString()) ??
        min;
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
          const Text('*',
              style: TextStyle(color: Colors.red, fontSize: 20)),
      ],
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: label,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Slider(
                  value: value,
                  min: min,
                  max: max,
                  divisions: divisions,
                  onChanged: (v) {
                    setState(() {
                      value = v;
                      _controller.onChanged?.call(v);
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(value.toInt().toString(), style: const TextStyle(fontSize: 20)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
