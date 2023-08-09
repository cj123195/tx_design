import 'package:flutter/material.dart';

import '../localizations.dart';
import 'detail_theme.dart';
import 'dialog.dart';

/// 详情页，用于展示详情数据
class TxDetailView extends StatelessWidget {
  const TxDetailView({
    required this.detailItems,
    super.key,
    this.separate,
    this.labelStyle,
    this.contentStyle,
    this.dense,
    this.minLabelWidth,
    this.padding,
  });

  factory TxDetailView.fromMap({
    required Map<String, dynamic> source,
    Map<int, DetailTile>? slots,
    bool separate = true,
    TextStyle? labelStyle,
    TextStyle? contentStyle,
    bool? dense,
    double? minLabelWidth,
    EdgeInsetsGeometry? padding,
  }) {
    final List<DetailTile> tiles = source.keys.map((key) {
      return DetailTile.fromText(labelText: key, contentValue: source[key]);
    }).toList();
    slots?.forEach((key, value) {
      if (key >= tiles.length) {
        tiles.add(value);
      } else if (key < 0) {
        tiles.insert(0, value);
      } else {
        tiles.insert(key, value);
      }
    });

    return TxDetailView(
      detailItems: tiles,
      separate: separate,
      labelStyle: labelStyle,
      contentStyle: contentStyle,
      dense: dense,
      minLabelWidth: minLabelWidth,
      padding: padding,
    );
  }

  /// 详情项
  final List<DetailTile> detailItems;

  /// 是否分隔
  final bool? separate;

  /// [DetailTile.label]文字样式
  final TextStyle? labelStyle;

  /// [DetailTile.content]文字样式
  final TextStyle? contentStyle;

  /// 是否紧凑
  final bool? dense;

  /// [DetailTile.label]最小宽度
  final double? minLabelWidth;

  /// 内边距
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final TxDetailThemeData detailTheme = TxDetailTheme.of(context);

    final TextStyle effectiveLabelStyle =
        labelStyle ?? detailTheme.labelStyle ?? textTheme.labelLarge!;
    final TextStyle effectiveContentStyle =
        contentStyle ?? detailTheme.contentStyle ?? textTheme.bodyMedium!;

    final double effectiveMinLabelWidth =
        minLabelWidth ?? detailTheme.minLabelWidth ?? 80.0;

    Iterable<Widget> tiles = detailItems.map((item) {
      final Widget label = DefaultTextStyle(
        style: effectiveLabelStyle,
        child: item.label,
      );
      final Widget? content = item.content == null
          ? null
          : DefaultTextStyle(
              style: effectiveContentStyle,
              child: item.content!,
            );

      return ListTile(
        leading: label,
        minLeadingWidth: effectiveMinLabelWidth,
        title: content,
        dense: dense ?? detailTheme.dense,
        contentPadding: padding ?? detailTheme.padding,
      );
    });

    final bool effectiveSeparate = separate ?? detailTheme.separate ?? true;
    if (effectiveSeparate) {
      tiles = ListTile.divideTiles(tiles: tiles, context: context);
    }
    return SingleChildScrollView(child: Column(children: tiles.toList()));
  }
}

/// 详情Tile
class DetailTile {
  const DetailTile({
    required this.label,
    this.content,
  });

  DetailTile.fromText({
    required String labelText,
    required dynamic contentValue,
  })  : label = Text('$labelText:'),
        content = contentValue == null ? null : Text('${contentValue ?? '-'}');

  final Widget label;
  final Widget? content;
}

/// 状态详情Tile
class StateDetailTile extends DetailTile {
  StateDetailTile({
    required this.statusColor,
    required super.label,
    super.content,
  });

  StateDetailTile.fromText({
    required super.labelText,
    required this.statusColor,
    required super.contentValue,
  }) : super.fromText();

  final Color statusColor;
}

/// 显示详情Dialog
Future<void> showDetailDialog({
  required BuildContext context,
  required List<DetailTile> detailItems,
  bool separate = false,
  TextStyle? labelStyle,
  TextStyle? contentStyle,
  bool dense = true,
  double? minLabelWidth,
  String? titleText,
  Widget? title,
}) async {
  return showDefaultDialog(
    context,
    titleText: titleText ?? TxLocalizations.of(context).detailDialogTitle,
    title: title,
    showCancelButton: false,
    confirmText: MaterialLocalizations.of(context).closeButtonLabel,
    content: TxDetailView(
      detailItems: detailItems,
      separate: separate,
      labelStyle: labelStyle,
      contentStyle: contentStyle,
      dense: dense,
      minLabelWidth: minLabelWidth,
      padding: EdgeInsets.zero,
    ),
  );
}

/// 通过DetailMap显示详情Dialog
Future<void> showDetailDialogBySource({
  required BuildContext context,
  required Map<String, dynamic> source,
  Map<int, DetailTile>? slots,
  bool separate = true,
  TextStyle? labelStyle,
  TextStyle? contentStyle,
  bool dense = true,
  double? minLabelWidth = 80.0,
  String? titleText,
  Widget? title,
}) async {
  return showDefaultDialog(
    context,
    titleText: titleText ?? TxLocalizations.of(context).detailDialogTitle,
    title: title,
    showConfirmButton: false,
    cancelText: MaterialLocalizations.of(context).closeButtonLabel,
    content: TxDetailView.fromMap(
      source: source,
      slots: slots,
      separate: separate,
      labelStyle: labelStyle,
      contentStyle: contentStyle,
      dense: dense,
      minLabelWidth: minLabelWidth,
      padding: EdgeInsets.zero,
    ),
  );
}
