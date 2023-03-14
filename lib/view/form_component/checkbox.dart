import 'package:flutter/material.dart';
import 'package:misa_ui_flutter/model/json_schema/boolean_json_schema.dart';
import 'package:misa_ui_flutter/settings/misa_locale.dart';
import 'package:misa_ui_flutter/view/form_component/form_component_controller.dart';
import 'package:provider/provider.dart';

// class Checkbox extends FormField<bool> {
//   final FormComponentController controller;

//   Checkbox({
//     super.key,
//     required this.controller,
//   }) : super(
//           initialValue: controller.value == true,
//           builder: (field) => _CheckBoxViewWidget(controller: controller),
//           validator: (value) => null,
//           onSaved: controller.onSaved,
//         );
// }

// class _CheckBoxViewWidget extends StatefulWidget {
//   final FormComponentController controller;
//   const _CheckBoxViewWidget({required this.controller});

//   @override
//   State<_CheckBoxViewWidget> createState() => _CheckBoxViewWidgetState();
// }

// class _CheckBoxViewWidgetState extends State<_CheckBoxViewWidget> {
//   bool currentValue = false;
//   late final FormComponentController _controller;
//   late final String _label;

//   @override
//   void initState() {
//     super.initState();
//     _controller = widget.controller;
//     _label = (_controller.schema as BooleanJsonSchema).text ??
//         _controller.schema.title ??
//         _controller.schema.key;
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (_controller.value != null) {
//         setState(() {
//           currentValue = _controller.value == true;
//         });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final locale = context.watch<MisaLocale>();
//     return InkWell(
//       onTap: () {
//         setState(() {
//           currentValue = !currentValue;
//         });
//         _controller.onChanged?.call(currentValue);
//       },
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           currentValue
//               ? const Icon(Icons.check_box, color: Colors.blue)
//               : const Icon(Icons.check_box_outline_blank, color: Colors.blue),
//           const SizedBox(width: 8),
//           Text(locale.translate(_label)),
//         ],
//       ),
//     );
//   }
// }

class Checkbox extends StatefulWidget {
  final FormComponentController controller;
  const Checkbox({super.key, required this.controller});

  @override
  State<Checkbox> createState() => _CheckboxState();
}

class _CheckboxState extends State<Checkbox> {
  bool currentValue = false;
  late final FormComponentController _controller;
  late final String _label;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _label = (_controller.schema as BooleanJsonSchema).text ??
        _controller.schema.title ??
        _controller.schema.key;
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
    return InkWell(
      onTap: () {
        setState(() {
          currentValue = !currentValue;
        });
        _controller.onChanged?.call(currentValue);
      },
      child: FormField<bool>(
        builder: (context) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              currentValue
                  ? const Icon(Icons.check_box, color: Colors.blue)
                  : const Icon(Icons.check_box_outline_blank,
                      color: Colors.blue),
              const SizedBox(width: 8),
              Text(locale.translate(_label)),
            ],
          );
        },
        validator: (value) => null,
        onSaved: (newValue) => _controller.onSaved?.call(currentValue),
      ),
    );
  }
}
