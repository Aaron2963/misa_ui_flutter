import 'package:flutter/material.dart';
import 'package:misa_ui_flutter/model/data_payload.dart';
import 'package:misa_ui_flutter/settings/misa_locale.dart';
import 'package:misa_ui_flutter/view/body/body.dart';
import 'package:provider/provider.dart';

class PaginationBar extends StatelessWidget {
  const PaginationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final MisaLocale locale = context.watch<MisaLocale>();
    final DataPayload? payload = context.watch<BodyStateProvider>().payload;
    final int current = context.watch<BodyStateProvider>().currentPage;
    final int total = context.watch<BodyStateProvider>().totalPage ?? 1;
    List<String> numbers = [];
    int mod = -2;
    while (numbers.length < 5) {
      if (current + mod < 1) {
        mod++;
        continue;
      }
      if (current + mod > total) {
        break;
      }
      numbers.add((current + mod).toString());
      mod++;
    }
    return Column(
      children: [
        if (numbers.isNotEmpty)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const _PaginationBarCell(
                isActive: false,
                isFirst: true,
                value: 'prev',
                child: Icon(Icons.keyboard_double_arrow_left),
              ),
              numbers.first != '1'
                  ? const _PaginationBarCell(
                      isActive: false,
                      value: null,
                      child: Icon(Icons.more_horiz, color: Colors.black26),
                    )
                  : const SizedBox(),
              ...numbers.map((number) => _PaginationBarCell(
                    value: number,
                    isActive: number == current.toString(),
                    child: Text(number),
                  )),
              numbers.last != total.toString()
                  ? const _PaginationBarCell(
                      value: null,
                      isActive: false,
                      child: Icon(Icons.more_horiz, color: Colors.black26),
                    )
                  : const SizedBox(),
              const _PaginationBarCell(
                isActive: false,
                isLast: true,
                value: 'next',
                child: Icon(Icons.keyboard_double_arrow_right),
              ),
            ],
          ),
        Text(locale.translate(
            'Total %s records', payload?.total.toString() ?? '--')),
      ],
    );
  }
}

class _PaginationBarCell extends StatelessWidget {
  final Widget child;
  final bool isActive;
  final dynamic value;
  final bool isFirst;
  final bool isLast;

  const _PaginationBarCell({
    required this.child,
    required this.isActive,
    required this.value,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final bodyState = context.watch<BodyStateProvider>();
    double width = Theme.of(context).textTheme.bodyMedium!.fontSize! * 2.5;
    Widget display = child;
    VoidCallback? onTap = () {
      final int? v = int.tryParse(value);
      if (v == null) return;
      bodyState.setCurrentPage(v);
    };
    if (isActive ||
        value == null ||
        (isFirst && value == 'prev') ||
        (isLast && value == 'next')) {
      onTap = null;
    }
    if (value == 'prev') {
      if (bodyState.currentPage > 1) {
        onTap = () => bodyState.setCurrentPage(bodyState.currentPage - 1);
      }
      display = Icon(
        Icons.keyboard_arrow_left,
        color: onTap == null ? Colors.black12 : Colors.black,
      );
    }
    if (value == 'next') {
      if (bodyState.currentPage < (bodyState.totalPage ?? 1)) {
        onTap = () => bodyState.setCurrentPage(bodyState.currentPage + 1);
      }
      display = Icon(
        Icons.keyboard_arrow_right,
        color: onTap == null ? Colors.black12 : Colors.black,
      );
    }
    return InkWell(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: width,
            height: width,
            decoration: BoxDecoration(
              color: isActive ? Colors.black12 : Colors.transparent,
              border: Border.all(color: Colors.black12),
              borderRadius: BorderRadius.only(
                topLeft: isFirst ? const Radius.circular(6.0) : Radius.zero,
                bottomLeft: isFirst ? const Radius.circular(6.0) : Radius.zero,
                topRight: isLast ? const Radius.circular(6.0) : Radius.zero,
                bottomRight: isLast ? const Radius.circular(6.0) : Radius.zero,
              ),
            ),
          ),
          Positioned.fill(child: Center(child: display)),
        ],
      ),
    );
  }
}
