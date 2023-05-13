import 'package:flutter/material.dart';
import 'package:misa_ui_flutter/controller/data_controller.dart';
import 'package:misa_ui_flutter/model/json_schema/string_json_schema.dart';
import 'package:misa_ui_flutter/settings/misa_locale.dart';
import 'package:misa_ui_flutter/view/form_component/form_component_controller.dart';
import 'package:provider/provider.dart';

class Select extends StatefulWidget {
  final FormComponentController controller;
  const Select({super.key, required this.controller});

  @override
  State<Select> createState() => _SelectState();
}

class _SelectState extends State<Select> {
  late final FormComponentController _controller;
  Map<String, String> options = {};

  Future _fetchOptions() async {
    final schema = _controller.schema as StringJsonSchema;
    if (!context.mounted || schema.atChain == null || schema.atChain!.isEmpty) {
      return;
    }
    final chain = schema.atChain!.first;
    final dataController = DataController(chain.atTable!, '');
    final payload = await dataController.briefSelect();
    if (context.mounted) {
      setState(() {
        options = Map.fromIterables(
          [
            if (!_controller.required) '',
            ...payload.data.map((e) => e[chain.atId] ?? ''),
          ],
          [
            if (!_controller.required) '',
            ...payload.data.map((e) => e[chain.titleFieldName] ?? ''),
          ],
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    var schema = _controller.schema;
    // enum values
    if (schema is StringJsonSchema && schema.enumValues != null) {
      options = Map.fromIterables(
        [
          if (!_controller.required) '',
          ...schema.enumValues!,
        ],
        [
          if (!_controller.required) '',
          ...(schema.texts ?? schema.enumValues!),
        ],
      );
    }
    // trigger onchange event
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchOptions().then((_) {
        if (_controller.value != null) {
          _controller.onChanged?.call(_controller.value.toString());
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<MisaLocale>();
    String value = _controller.value?.toString() ?? '';
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
    if (options.isEmpty) {
      options = {
        '...': 'loading...'
      };
    }
    if (!options.keys.contains(value)) {
      value = options.keys.first;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          label: label,
          border: const OutlineInputBorder(),
        ),
        onSaved: _controller.onSaved,
        onChanged: _controller.onChanged,
        validator: (value) {
          if (_controller.required && (value == null || value.isEmpty)) {
            return locale.translate('This field is required');
          }
          return null;
        },
        items: options.keys
            .map((v) => DropdownMenuItem(
                  value: v,
                  child: Text(locale.translate(options[v]!)),
                ))
            .toList(),
      ),
    );
  }
}
