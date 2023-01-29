import 'package:flutter/material.dart';
import 'package:misa_ui_flutter/controller/schema_controller.dart';
import 'package:misa_ui_flutter/model/page_schema.dart';
import 'package:misa_ui_flutter/settings/string_extension.dart';

// enum of MenuItemType: folder, view, hyperlink
enum MenuItemType { folder, view, hyperlink }

// enum of hyperlink target: _blank, _self, _parent, _top
enum HyperlinkTarget { blank, self, parent, top, iframe }

enum ViewType { list, detail, form, album, queryList }

final SchemaController _schemaController = SchemaController();

enum ViewFeature {
  filter,
  pagination,
  detailModal,
  formModal,
  more,
  selectAll,
  save,
  reset,
  insert,
  edit,
  delete,
  saveAsNew,
  quickAct,
  export,
  import,
  chart,
  print,
  download,
}

abstract class MisaMenuItem {
  final String title;
  final IconData? icon;
  final MenuItemType type;

  MisaMenuItem({required this.title, required this.type, this.icon});
}

class FolderMenuItem extends MisaMenuItem {
  List<MisaMenuItem> children;

  FolderMenuItem({
    required super.title,
    super.icon,
    this.children = const [],
  }) : super(type: MenuItemType.folder);

  factory FolderMenuItem.fromJson(Map<String, dynamic> map,
      {String title = ''}) {
    List<MisaMenuItem> children = [];
    IconData icon = IconData(
      int.tryParse(map['icon']) ?? 0xe2a3,
      fontFamily: 'MaterialIcons',
    );
    for (String k in map['items'].keys) {
      if (map['items'][k].containsKey('items')) {
        children.add(FolderMenuItem.fromJson(map['items'][k], title: k));
        continue;
      }
      // if item has 'views' key, push to result as ViewMenuItem
      if (map['items'][k].containsKey('views')) {
        children.add(ViewMenuItem.fromJson(map['items'][k], title: k));
        continue;
      }
      // if item has 'href' key, push to result as HyperlinkMenuItem
      if (map['items'][k].containsKey('href')) {
        children.add(HyperlinkMenuItem.fromJson(map['items'][k], title: k));
        continue;
      }
    }
    return FolderMenuItem(title: title, children: children, icon: icon);
  }

  void add(MisaMenuItem item) {
    children.add(item);
  }

  void remove(int index) {
    children.removeAt(index);
  }
}

class ViewMenuItem extends MisaMenuItem {
  final String url;
  final PageSchema pageSchema;
  final ViewType viewType;
  List<ViewFeature> features = [];

  ViewMenuItem({
    required super.title,
    required this.pageSchema,
    required this.url,
    required this.viewType,
    super.icon,
    this.features = const [],
  }) : super(type: MenuItemType.view);

  factory ViewMenuItem.fromJson(Map<String, dynamic> map, {String title = ''}) {
    List<ViewFeature> features = [];
    map = map['views'][0];
    String viewType = map['type'][0].toLowerCase() + map['type'].substring(1);
    for (String feature in map['component']) {
      features.add(ViewFeature.values.byName(feature.toLowerCamelCase()));
    }
    PageSchema schema =
        _schemaController.getSchemaByUri(map['schema']['\$ref']) ?? PageSchema.blank();
    return ViewMenuItem(
      title: title,
      url: title,
      pageSchema: schema,
      viewType: ViewType.values.byName(viewType),
      features: features,
    );
  }
}

class HyperlinkMenuItem extends MisaMenuItem {
  final String url;
  final String href;
  final HyperlinkTarget target;

  HyperlinkMenuItem({
    required super.title,
    required this.url,
    required this.href,
    super.icon,
    this.target = HyperlinkTarget.blank,
  }) : super(type: MenuItemType.hyperlink);

  factory HyperlinkMenuItem.fromJson(Map<String, dynamic> map,
      {String title = ''}) {
    return HyperlinkMenuItem(
      title: title,
      url: title,
      href: map['href'],
      target: HyperlinkTarget.values.byName(map['target'].replaceAll('_', '')),
    );
  }
}
