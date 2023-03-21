import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:misa_ui_flutter/controller/data_controller.dart';
import 'package:misa_ui_flutter/model/json_schema/string_json_schema.dart';
import 'package:misa_ui_flutter/settings/misa_locale.dart';
import 'package:misa_ui_flutter/view/form_component/form_component_controller.dart';
import 'package:provider/provider.dart';

class SearchSelect extends StatefulWidget {
  final FormComponentController controller;
  const SearchSelect({super.key, required this.controller});

  @override
  State<SearchSelect> createState() => _SearchSelectState();
}

class _SearchSelectState extends State<SearchSelect> {
  late final FormComponentController _controller;
  _DropdownSearchItem? _selectedItem;
  List<_DropdownSearchItem> options = [];

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
        options = [];
        if (!_controller.required) {
          options.add(const _DropdownSearchItem(''));
        }
        for (var i = 0; i < payload.data.length; i++) {
          options.add(_DropdownSearchItem(
            payload.data[i][chain.atId] ?? '',
            text: payload.data[i][chain.titleFieldName] ?? '',
          ));
        }
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
      if (!_controller.required) {
        options.add(const _DropdownSearchItem(''));
      }
      for (int i = 0; i < schema.enumValues!.length; i++) {
        options.add(_DropdownSearchItem(
          schema.enumValues![i],
          text: schema.texts?[i],
        ));
      }
    }
    // trigger onchange event
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchOptions().then((_) {
        if (_controller.value != null) {
          _controller.onChanged?.call(_controller.value.toString());
          for (var element in options) {
            if (element.value == _controller.value) {
              setState(() => _selectedItem = element);
              break;
            }
          }
        }
      });
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
      child: FormField<String>(
        onSaved: (v) => _controller.onSaved?.call(_selectedItem?.value),
        validator: (v) {
          final value = _selectedItem?.value;
          if (_controller.required && (value == null || value.isEmpty)) {
            return locale.translate('This field is required');
          }
          return null;
        },
        builder: (field) {
          return DropdownSearch<_DropdownSearchItem>(
            items: options,
            itemAsString: (item) => item.label,
            filterFn: (item, filter) => item.itemFilterBy(filter),
            compareFn: (item1, item2) => item1.isEqual(item2),
            selectedItem: _selectedItem,
            popupProps: PopupProps.menu(
              showSearchBox: true,
              searchDelay: const Duration(milliseconds: 500),
              searchFieldProps: TextFieldProps(
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: locale.translate('Search'),
                ),
              ),
              containerBuilder: (context, popupWidget) => Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: popupWidget,
              ),
              emptyBuilder: (context, filter) => Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.warning, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(locale.translate('No data')),
                  ],
                ),
              ),
            ),
            onChanged: (_DropdownSearchItem? item) {
              _selectedItem = item;
              if (item != null) {
                _controller.onChanged?.call(item.value);
              }
            },
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                label: label,
                border: const OutlineInputBorder(),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DropdownSearchItem {
  final String value;
  final String? text;
  const _DropdownSearchItem(this.value, {this.text});

  String get label => text ?? value;

  bool itemFilterBy(String filter) =>
      label.toLowerCase().contains(filter.toLowerCase());

  bool isEqual(_DropdownSearchItem item) => item.value == value;

  @override
  String toString() => label;
}
