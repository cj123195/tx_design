import 'package:flutter/material.dart';

import 'cell.dart';
import 'cell_theme.dart';
import 'detail_theme.dart';

/// 详情页，用于展示详情数据
class TxDetailView extends StatelessWidget {
  const TxDetailView({
    required this.children,
    super.key,
    this.decoration,
    this.padding,
    this.separator,
    this.cellTheme,
  });

  /// 创建由[data]参数派生出的描述数据表的小组件。
  ///
  /// [data] 参数不能为空。
  TxDetailView.fromMap(
    Map<String, dynamic> data, {
    super.key,
    final int columnNum = 2,
    this.padding,
    this.decoration,
    this.separator,
    this.cellTheme,
    Map<int, Widget>? slots,
    bool? dense,
    VisualDensity? visualDensity,
    double? minLabelWidth,
    double? minLeadingWidth,
    double? horizontalGap,
    TextStyle? contentTextStyle,
    TextStyle? labelTextStyle,
    TextAlign? contentTextAlign,
  }) : children = TxCell.fromMap(
          data,
          padding: EdgeInsets.zero,
          minVerticalPadding: 0,
          slots: slots,
          dense: dense,
          visualDensity: visualDensity,
          minLeadingWidth: minLeadingWidth,
          minLabelWidth: minLabelWidth,
          horizontalGap: horizontalGap,
          labelTextStyle: labelTextStyle,
          contentTextStyle: contentTextStyle,
          contentTextAlign: contentTextAlign,
          contentMaxLines: null,
        );

  /// 栅格的背景和边框装饰
  ///
  /// 如果为 null，则使用 [TxDetailThemeData.decoration]。默认情况下没有装饰。
  final Decoration? decoration;

  /// 内边距
  ///
  /// 如果为 null，则使用 [TxDetailThemeData.padding]。此值默认为
  /// [kMinInteractiveDimension] 以符合Material Design规范。
  final EdgeInsetsGeometry? padding;

  /// 垂直分隔组件。
  ///
  /// 如果为 null，则使用 [TxDetailThemeData.separator]。此值默认为 12.0。
  final Widget? separator;

  /// 要在每行中显示的数据（不包括包含列标题的行）。
  ///
  /// 必须为非null，但可以为空。
  final List<Widget> children;

  /// [TxCell] 的主题样式
  final TxCellThemeData? cellTheme;

  @override
  Widget build(BuildContext context) {
    final TxDetailThemeData detailTheme = TxDetailTheme.of(context);
    final TxDetailThemeData defaults = _DetailThemeMaterial3(context);

    final EdgeInsetsGeometry? effectivePadding =
        padding ?? detailTheme.padding ?? defaults.padding;
    final Decoration? effectiveDecoration =
        decoration ?? detailTheme.decoration ?? defaults.decoration;
    final TxCellThemeData effectiveCellTheme =
        cellTheme ?? detailTheme.cellTheme ?? defaults.cellTheme!;

    final dense = effectiveCellTheme.dense ?? defaults.cellTheme!.dense!;
    final visualDensity =
        effectiveCellTheme.visualDensity ?? defaults.cellTheme!.visualDensity!;
    final Widget effectiveSeparator = separator ??
        detailTheme.separator ??
        defaults.separator ??
        SizedBox(height: (dense ? 6 : 8) + visualDensity.vertical);

    final List<Widget> effectiveChildren = [
      for (int i = 0; i < children.length; i++) ...[
        children[i],
        if (i != children.length - 1) effectiveSeparator,
      ]
    ];

    return Container(
      decoration: effectiveDecoration,
      padding: effectivePadding,
      child: TxCellTheme(
        data: effectiveCellTheme,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: effectiveChildren,
        ),
      ),
    );
  }
}

class _DetailThemeMaterial3 extends TxDetailThemeData {
  const _DetailThemeMaterial3(this.context);

  final BuildContext context;

  ColorScheme get colors => Theme.of(context).colorScheme;

  TextTheme get textTheme => Theme.of(context).textTheme;

  @override
  TxCellThemeData? get cellTheme => TxCellThemeData(
        dense: false,
        contentTextAlign: TextAlign.left,
        padding: EdgeInsets.zero,
        minVerticalPadding: 4.0,
        minLeadingWidth: 24.0,
        minLabelWidth: 84,
        labelTextStyle: textTheme.labelLarge!.copyWith(
          color: colors.onSurfaceVariant,
          fontWeight: FontWeight.w500,
        ),
        contentTextStyle:
            textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500),
        visualDensity: Theme.of(context).visualDensity,
      );
}
