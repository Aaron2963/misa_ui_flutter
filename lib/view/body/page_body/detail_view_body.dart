import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:misa_ui_flutter/model/json_schema/array_json_schema.dart';
import 'package:misa_ui_flutter/model/json_schema/json_schema.dart';
import 'package:misa_ui_flutter/model/json_schema/object_json_schema.dart';
import 'package:misa_ui_flutter/model/json_schema/string_json_schema.dart';
import 'package:misa_ui_flutter/settings/misa_locale.dart';
import 'package:misa_ui_flutter/view/body/body.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

const double _titleWidth = 200;
final HtmlUnescape _unescape = HtmlUnescape();

//翻譯文字內容 (enum)
String _getDisplayText(BuildContext context, JsonSchema schema, String value) {
  final locale = context.watch<MisaLocale>();
  try {
    final sch = schema as StringJsonSchema;
    final i = sch.enumValues!.indexOf(value);
    if (i == -1) {
      return value;
    }
    return locale.translate(sch.texts?.elementAt(i) ?? value);
  } catch (e) {
    return value;
  }
}

//開啟網址
void _launchUrl(BuildContext context, String url) {
  try {
    launchUrlString(url);
  } catch (e) {
    final locale = context.read<MisaLocale>();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(locale.translate('Cannot open url'))),
    );
  }
}

class DetailViewBody extends StatefulWidget {
  const DetailViewBody({super.key});

  @override
  State<DetailViewBody> createState() => _DetailViewBodyState();
}

class _DetailViewBodyState extends State<DetailViewBody> {
  @override
  void initState() {
    context
        .read<BodyStateProvider>()
        .setCurrentPage(1, notifyBeforeAwait: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bodyState = context.watch<BodyStateProvider>();
    final pageSchema = bodyState.pageSchema;
    final payload = bodyState.payload;
    if (pageSchema == null || payload == null) {
      return const Center(
        child: Text("No data"),
      );
    }
    final data =
        payload.data.isNotEmpty ? payload.data[0] : <String, dynamic>{};
    List<JsonSchema> props =
        pageSchema.properties!.values.where((e) => e.showInDetail).toList();
    return Column(
      children: List.generate(
        props.length,
        (i) => _DetailViewRow(
          schema: props[i],
          content: data[props[i].key] ?? '',
          hasBackgroundColor: i % 2 == 0,
        ),
      ),
    );
  }
}

class _DetailViewRow extends StatefulWidget {
  final JsonSchema schema;
  final dynamic content;
  final bool hasTitle;
  final double titleWidth;
  final bool hasBackgroundColor;
  const _DetailViewRow({
    required this.schema,
    required this.content,
    this.hasTitle = true,
    this.titleWidth = _titleWidth,
    this.hasBackgroundColor = false,
  });

  @override
  State<_DetailViewRow> createState() => _DetailViewRowState();
}

class _DetailViewRowState extends State<_DetailViewRow> {
  //翻譯文字內容 (enum)
  String getDisplayText(BuildContext context, JsonSchema schema, String value) {
    final locale = context.watch<MisaLocale>();
    try {
      final sch = schema as StringJsonSchema;
      final i = sch.enumValues!.indexOf(value);
      if (i == -1) {
        return value;
      }
      return locale.translate(sch.texts?.elementAt(i) ?? value);
    } catch (e) {
      return value;
    }
  }

  //渲染內容
  Widget buildContent(BuildContext context) {
    final locale = context.watch<MisaLocale>();

    //當資料為陣列時
    if (widget.schema.type == SchemaDataType.array) {
      final arraySchema = widget.schema as ArrayJsonSchema;
      //當陣列的元素為字串/數字/布林值時
      if (arraySchema.items.type == SchemaDataType.string ||
          arraySchema.items.type == SchemaDataType.integer ||
          arraySchema.items.type == SchemaDataType.boolean) {
        return Text(
          widget.content
              .map((e) => getDisplayText(context, arraySchema.items, e))
              .join('; '),
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: Colors.black87),
        );
      }
      //當陣列為包含一個圖片欄位的物件陣列時
      if (arraySchema.items.type == SchemaDataType.object) {
        final obj = arraySchema.items as ObjectJsonSchema;
        final imageUrl =
            obj.properties!.values.where((sch) => sch.component == 'image');
        if (imageUrl.length == 1) {
          return Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.start,
            runAlignment: WrapAlignment.start,
            children: List<Widget>.generate(
                widget.content.length,
                (i) => _ImageCard(
                      schema: obj,
                      content: widget.content[i],
                    )),
          );
        }
      }

      return Column(
        children: List.generate(
          widget.content.length,
          (i) => _DetailViewRow(
            schema: arraySchema.items,
            content: widget.content[i],
            hasTitle: false,
          ),
        ),
      );
    }

    //當資料為物件時
    if (widget.schema.type == SchemaDataType.object) {
      final objectSchema = widget.schema as ObjectJsonSchema;
      if (objectSchema.render != null && objectSchema.render!.isNotEmpty) {
        //當有render時
        return Text(
          objectSchema.render!.map((e) => locale.translate(e)).join(''),
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: Colors.black87),
        );
      } else {
        //當沒有render時
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            objectSchema.properties!.length,
            (i) => _DetailViewRow(
              schema: objectSchema.properties!.values.elementAt(i),
              content:
                  widget.content[objectSchema.properties!.keys.elementAt(i)],
              titleWidth: 100,
              hasBackgroundColor: i % 2 == 0,
            ),
          ),
        );
      }
    }

    //當資料為HTML時
    if (widget.schema.component == 'richtext') {
      return Html(data: _unescape.convert(widget.content));
    }

    //當資料為圖片時
    if (widget.schema.component == 'image') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FadeInImage.assetNetwork(
            height: 100.0,
            width: 100.0,
            alignment: Alignment.centerLeft,
            placeholder: 'asset/images/image_placeholder.png',
            image: widget.content,
            fit: BoxFit.contain,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.blue,
              padding: const EdgeInsets.all(16),
              backgroundColor: Colors.white,
              shape: const CircleBorder(),
            ),
            child: const Icon(Icons.open_in_new),
            onPressed: () => _launchUrl(context, widget.content),
          ),
        ],
      );
    }

    //當資料為檔案時
    if (widget.schema.component == 'file') {
      return Row(
        children: [
          Text(
            widget.content,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: Colors.black87),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.blue,
              padding: const EdgeInsets.all(16),
              backgroundColor: Colors.white,
              shape: const CircleBorder(),
            ),
            onPressed: () => _launchUrl(context, widget.content),
            child: const Icon(Icons.download_rounded),
          ),
        ],
      );
    }

    //當資料為字串/數字/布林時
    if (widget.schema.type == SchemaDataType.string ||
        widget.schema.type == SchemaDataType.integer ||
        widget.schema.type == SchemaDataType.boolean) {
      return Text(
        getDisplayText(context, widget.schema, widget.content),
        style: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(color: Colors.black87),
      );
    }

    //當不符合以上條件時
    return const SizedBox();
  }

  BoxDecoration buildBoxDecoration() {
    return BoxDecoration(
      color: widget.hasBackgroundColor
          ? const Color.fromRGBO(200, 200, 200, 0.1)
          : Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<MisaLocale>();
    Widget child = buildContent(context);
    if (widget.hasTitle) {
      child = Row(
        children: [
          SizedBox(
            width: widget.titleWidth,
            child: Text(
              locale.translate(widget.schema.title ?? widget.schema.key),
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(child: child),
        ],
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: buildBoxDecoration(),
      child: child,
    );
  }
}

// 顯示圖片的卡片
class _ImageCard extends StatelessWidget {
  final ObjectJsonSchema schema;
  final Map content;
  const _ImageCard({
    required this.schema,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<MisaLocale>();
    final imageSchemas =
        schema.properties!.values.where((sch) => sch.component == 'image');
    final imageUrl = content[imageSchemas.first.key] ?? '';
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Container(
        width: 200,
        padding: const EdgeInsets.only(bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                    color: Colors.grey,
                  ),
                  child: FadeInImage.assetNetwork(
                    height: 200.0,
                    alignment: Alignment.centerLeft,
                    placeholder: 'asset/images/image_placeholder.png',
                    image: imageUrl,
                    fit: BoxFit.fitHeight,
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 8,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.blue,
                      padding: const EdgeInsets.all(16),
                      backgroundColor: Colors.white,
                      shape: const CircleBorder(),
                    ),
                    onPressed: () => _launchUrl(context, imageUrl),
                    child: const Icon(Icons.open_in_new),
                  ),
                ),
              ],
            ),
            ...schema.properties!.values
                .where((e) => e.key != imageSchemas.first.key && e.showInDetail)
                .map((e) {
              return Padding(
                padding:
                    const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${locale.translate(e.title ?? e.key)}:',
                        style: Theme.of(context).textTheme.bodySmall),
                    Text(
                      _getDisplayText(context, e, content[e.key] ?? ''),
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Colors.black87),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
