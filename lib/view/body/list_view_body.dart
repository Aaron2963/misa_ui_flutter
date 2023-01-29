import 'package:flutter/material.dart';
import 'package:misa_ui_flutter/model/page_schema.dart';

class ListViewBody extends StatefulWidget {
  final PageSchema pageSchema;
  const ListViewBody({super.key, required this.pageSchema});

  @override
  State<ListViewBody> createState() => _ListViewBodyState();
}

class _ListViewBodyState extends State<ListViewBody> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        PaginationBar(current: 2566, total: 1000660),
      ],
    );
  }
}

class PaginationBar extends StatelessWidget {
  final int current;
  final int total;

  const PaginationBar({super.key, required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
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
    return Container(
      child: Row(
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
          numbers.first != total.toString()
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
    double width = Theme.of(context).textTheme.bodyMedium!.fontSize! * 3;
    return InkWell(
      onTap: value == null ? null : () {},
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
          Positioned.fill(child: Center(child: child)),
        ],
      ),
    );
  }
}
