import 'package:flutter/material.dart';
import 'package:misa_ui_flutter/model/menu_item.dart';
import 'package:misa_ui_flutter/model/page_schema.dart';
import 'package:misa_ui_flutter/model/query_filter.dart';
import 'package:misa_ui_flutter/settings/misa_locale.dart';
import 'package:misa_ui_flutter/view/body/advanced_view.dart';
import 'package:misa_ui_flutter/view/body/body.dart';
import 'package:misa_ui_flutter/view/body/feature_bar/filter_feature.dart';
import 'package:misa_ui_flutter/view/body/feature_bar/insert_feature.dart';
import 'package:misa_ui_flutter/view/body/feature_bar/pagination.dart';
import 'package:provider/provider.dart';

enum _FeatureBarPosition { left, right, center }

const Map<ViewType, Set<ViewFeature>> legalFeaturesByViewType = {
  ViewType.list: {
    ViewFeature.insert,
    ViewFeature.delete,
    ViewFeature.filter,
    ViewFeature.export,
    ViewFeature.import,
    ViewFeature.chart,
    ViewFeature.print,
    ViewFeature.download,
    ViewFeature.pagination,
  },
  ViewType.form: {
    ViewFeature.save,
    ViewFeature.saveAsNew,
    ViewFeature.reset,
    ViewFeature.more,
  },
  ViewType.queryList: {
    ViewFeature.insert,
    ViewFeature.delete,
    ViewFeature.filter,
    ViewFeature.export,
    ViewFeature.import,
    ViewFeature.chart,
    ViewFeature.print,
    ViewFeature.download,
    ViewFeature.pagination,
  },
  ViewType.detail: {
    ViewFeature.edit,
    ViewFeature.more,
    ViewFeature.print,
    ViewFeature.download,
  },
  ViewType.album: {
    ViewFeature.insert,
    ViewFeature.delete,
    ViewFeature.filter,
    ViewFeature.export,
    ViewFeature.import,
    ViewFeature.selectAll,
    ViewFeature.print,
    ViewFeature.download,
    ViewFeature.pagination,
  },
};

const Map<_FeatureBarPosition, List<ViewFeature>> _featurePositionMapping = {
  _FeatureBarPosition.right: [ViewFeature.quickAct],
  _FeatureBarPosition.center: [ViewFeature.pagination],
  _FeatureBarPosition.left: [
    ViewFeature.insert,
    ViewFeature.edit,
    ViewFeature.save,
    ViewFeature.saveAsNew,
    ViewFeature.delete,
    ViewFeature.filter,
    ViewFeature.reset,
    ViewFeature.more,
    ViewFeature.selectAll,
    ViewFeature.export,
    ViewFeature.import,
    ViewFeature.chart,
    ViewFeature.print,
    ViewFeature.download,
  ],
};

class FeatureBar extends StatelessWidget {
  final ViewType? viewType;
  final List<ViewFeature>? features;
  final bool alignEnd;
  final bool isBottom;

  const FeatureBar({
    super.key,
    this.viewType,
    this.features,
    this.alignEnd = false,
  }) : isBottom = false;

  const FeatureBar.bottom({
    super.key,
    this.viewType,
    this.features,
  })  : isBottom = true,
        alignEnd = false;

  @override
  Widget build(BuildContext context) {
    final TextDirection direction =
        alignEnd ? TextDirection.rtl : TextDirection.ltr;
    final viewMenuItem = context.watch<BodyStateProvider>().viewMenuItem;
    final locale = context.watch<MisaLocale>();
    final advancedView = context.watch<BodyStateProvider>().advancedView;
    if (viewMenuItem == null) return const SizedBox();
    ViewType nowViewType = viewType ?? viewMenuItem.viewType;
    List<ViewFeature> nowFeatures = features ?? viewMenuItem.features;
    List<Widget> actions = [];
    // advencedView: detail 時，顯示固定的功能按鈕
    if (advancedView != null && advancedView.viewMode == ViewMode.detail) {
      if (isBottom) return const SizedBox();
      return const _AdvancedDetailFeatureBar();
    }
    // advencedView: form 時，顯示固定的功能按鈕
    if (advancedView != null && advancedView.viewMode == ViewMode.form) {
      if (isBottom) return const SizedBox();
      return const _AdvancedFormFeatureBar();
    }
    // 依據 viewType 及 features 決定要顯示哪些功能按鈕
    for (var position in [
      _FeatureBarPosition.left,
      _FeatureBarPosition.center,
      _FeatureBarPosition.right
    ]) {
      if (!isBottom && position == _FeatureBarPosition.center) continue;
      if (isBottom && position != _FeatureBarPosition.center) {
        actions.add(const SizedBox());
        continue;
      }
      actions.add(_Actions(
        viewType: nowViewType,
        position: position,
        features: nowFeatures,
        direction: direction,
      ));
    }
    // 篩選條件文字摘要
    if (nowFeatures.contains(ViewFeature.filter) && !isBottom) {
      final filterBrief = context
          .watch<BodyStateProvider>()
          .getQueryFilterBrief()
          .map((str) => locale.translate(str))
          .join(locale.separatorNeeded ? ' ' : '');
      if (filterBrief.isNotEmpty) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              textDirection: direction,
              children: actions,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 32),
              child: Tooltip(
                message: '${locale.translate('Search')}: $filterBrief',
                child: Text(
                  '${locale.translate('Search')}: $filterBrief',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
          ],
        );
      }
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      textDirection: direction,
      children: actions,
    );
  }
}

class _Actions extends StatelessWidget {
  final ViewType viewType;
  final _FeatureBarPosition position;
  final List<ViewFeature> features;
  final TextDirection direction;
  const _Actions({
    required this.viewType,
    required this.position,
    required this.features,
    required this.direction,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> actions = [];
    for (ViewFeature feature in _featurePositionMapping[position]!) {
      if (!features.contains(feature) ||
          !legalFeaturesByViewType[viewType]!.contains(feature)) continue;
      actions.add(_FeatureBarAction(feature: feature));
    }
    return Wrap(
      spacing: 8,
      textDirection: direction,
      children: actions,
    );
  }
}

class _FeatureBarAction extends StatelessWidget {
  final ViewFeature feature;
  const _FeatureBarAction({required this.feature});

  final Map<ViewFeature, IconData> featureToIconData = const {
    ViewFeature.insert: Icons.add,
    ViewFeature.edit: Icons.edit,
    ViewFeature.delete: Icons.delete,
    ViewFeature.filter: Icons.filter_alt,
    ViewFeature.saveAsNew: Icons.save_as,
    ViewFeature.save: Icons.save,
  };

  String featureToString(ViewFeature feature) {
    String str = feature.toString().split('.').last;
    return str.substring(0, 1).toUpperCase() + str.substring(1);
  }

  Color featureToColor(ViewFeature feature) {
    switch (feature) {
      case ViewFeature.delete:
        return Colors.red;
      case ViewFeature.filter:
      case ViewFeature.save:
      case ViewFeature.saveAsNew:
        return Colors.blue;
      default:
        return Colors.orange;
    }
  }

  Widget? _buildFeature(BuildContext context, ViewFeature feature) {
    BodyStateProvider bodyState = context.watch<BodyStateProvider>();
    switch (feature) {
      case ViewFeature.insert:
        return const InsertFeature();
      case ViewFeature.filter:
        final pageSchema = bodyState.pageSchema ?? PageSchema.blank('');
        final QueryFilter filter = bodyState.payload?.filter != null
            ? QueryFilter.fromJson(
                pageSchema, bodyState.payload!.filter!.toJson())
            : QueryFilter();
        return FilterFeature(
          bodyStateProvider: bodyState,
          title: bodyState.viewMenuItem?.title ?? '',
          pageSchema: pageSchema,
          filter: filter,
        );
      case ViewFeature.pagination:
        return const PaginationBar();
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<MisaLocale>();

    if (feature == ViewFeature.pagination || feature == ViewFeature.quickAct) {
      return _buildFeature(context, feature) ?? const SizedBox();
    }

    final icon = featureToIconData[feature];
    final title = locale.translate(featureToString(feature));
    final style = ElevatedButton.styleFrom(
      backgroundColor: featureToColor(feature),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
    onPressed() {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return _buildFeature(context, feature) ?? const SizedBox();
        },
      );
    }

    if (icon == null) {
      return ElevatedButton(
        style: style,
        onPressed: onPressed,
        child: Text(title),
      );
    }

    return ElevatedButton.icon(
      icon: Icon(icon),
      label: Text(title),
      style: style,
      onPressed: onPressed,
    );
  }
}

class _AdvancedDetailFeatureBar extends StatelessWidget {
  const _AdvancedDetailFeatureBar();

  List<Widget> buildActions(BuildContext context) {
    final viewMenuItem = context.watch<BodyStateProvider>().viewMenuItem;
    final locale = context.watch<MisaLocale>();
    // 基本功能包含返回
    List<Widget> actions = [
      ElevatedButton.icon(
        icon: const Icon(Icons.arrow_back),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: () {
          context.read<BodyStateProvider>().advancedView?.onDispose?.call();
          context.read<BodyStateProvider>().setAdvancedView(null);
        },
        label: Text(locale.translate('Back')),
      ),
    ];
    // 依據 ViewMenuItem 的設定，加入其他功能
    if (viewMenuItem == null) return actions;
    if (viewMenuItem.features.contains(ViewFeature.edit)) {
      actions.add(const _FeatureBarAction(feature: ViewFeature.edit));
    }
    if (viewMenuItem.features.contains(ViewFeature.print)) {
      actions.add(const _FeatureBarAction(feature: ViewFeature.print));
    }
    if (viewMenuItem.features.contains(ViewFeature.download)) {
      actions.add(const _FeatureBarAction(feature: ViewFeature.download));
    }
    return actions;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: buildActions(context),
    );
  }
}

class _AdvancedFormFeatureBar extends StatelessWidget {
  const _AdvancedFormFeatureBar();

  List<Widget> buildActions(BuildContext context) {
    final viewMenuItem = context.watch<BodyStateProvider>().viewMenuItem;
    final locale = context.watch<MisaLocale>();
    // 基本功能包含取消
    List<Widget> actions = [
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: () {
          context.read<BodyStateProvider>().advancedView?.onDispose?.call();
          context.read<BodyStateProvider>().setAdvancedView(null);
        },
        child: Text(locale.translate('Cancel')),
      ),
    ];
    // 依據 ViewMenuItem 的設定，加入其他功能
    if (viewMenuItem == null) return actions;
    if (viewMenuItem.features.contains(ViewFeature.saveAsNew)) {
      actions.add(const _FeatureBarAction(feature: ViewFeature.saveAsNew));
    }
    //基本功能包含儲存
    actions.add(ElevatedButton.icon(
      icon: const Icon(Icons.save),
      label: Text(locale.translate('Save')),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: () {
        final formState = context
            .read<BodyStateProvider>()
            .advancedView
            ?.formKey
            ?.currentState;
        if (formState == null) return;
        if (!formState.validate()) return;
        formState.save();
        // TODO: call controller to insert/update data
        print(context.read<BodyStateProvider>().advancedView?.formCache?.output(
                context.read<BodyStateProvider>().pageSchema ??
                    PageSchema.blank('')) ??
            'no form cache');
        context.read<BodyStateProvider>().advancedView?.onDispose?.call();
        context.read<BodyStateProvider>().setAdvancedView(null);
      },
    ));
    actions.add(ElevatedButton.icon(
      icon: const Icon(Icons.print),
      label: Text(locale.translate('Print FormCache')),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: () {
        final formState = context
            .read<BodyStateProvider>()
            .advancedView
            ?.formKey
            ?.currentState;
        if (formState == null) return;
        if (!formState.validate()) return;
        // TODO: call controller to insert/update data
        print(context.read<BodyStateProvider>().advancedView?.formCache ??
            'no form cache');
      },
    ));
    return actions;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: buildActions(context),
    );
  }
}
