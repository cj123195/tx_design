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

  @override
  Widget build(BuildContext context) {
    final TxDetailThemeData detailTheme = TxDetailTheme.of(context);

    final Widget effectiveSeparator =
        separator ?? detailTheme.separator ?? const SizedBox(height: 8.0);
    final EdgeInsetsGeometry? effectivePadding = padding ?? detailTheme.padding;
    final Decoration? effectiveDecoration =
        decoration ?? detailTheme.decoration;

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
        data: TxCellTheme.of(context).copyWith(
          dense: detailTheme.dense,
          visualDensity: detailTheme.visualDensity,
          minLabelWidth: detailTheme.minLabelWidth,
          labelTextStyle: detailTheme.labelTextStyle,
          contentTextStyle: detailTheme.contentTextStyle,
          contentTextAlign: detailTheme.contentTextAlign,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: effectiveChildren,
        ),
      ),
    );
  }
}
