import 'package:flutter/material.dart';

import 'cell.dart';
import 'cell_theme.dart';
import 'data_grid_theme.dart';

/// 数据展示栅格组件
class TxDataGrid extends StatelessWidget {
  /// 创建描述数据表的小组件。
  ///
  /// [rows] 参数必须是与表一样多的 [TxDataRow] 对象的列表。可以有零行，但行参数不能为空。
  const TxDataGrid({
    required this.rows,
    super.key,
    this.decoration,
    this.padding,
    this.spacing,
  });

  /// 创建由[data]参数派生出的描述数据表的小组件。
  ///
  /// [data] 参数不能为空。
  TxDataGrid.fromMap(
    Map<String, dynamic> data, {
    super.key,
    int columnNum = 1,
    this.padding,
    this.decoration,
    this.spacing,
    Map<int, Widget>? slots,
    bool? dense,
    VisualDensity? visualDensity,
    double? minLabelWidth,
    double? minLeadingWidth,
    double? horizontalGap,
    TextStyle? contentTextStyle,
    TextStyle? labelTextStyle,
    TextAlign? contentTextAlign,
    EdgeInsetsGeometry? rowPadding,
    Decoration? rowDecoration,
    double? columnSpacing,
    int? contentMaxLines,
  })  : assert(columnNum > 0),
        rows = columnNum == 1
            ? TxCell.fromMap(
                data,
                padding: rowPadding,
                slots: slots,
                dense: dense,
                visualDensity: visualDensity,
                minLeadingWidth: minLeadingWidth,
                minLabelWidth: minLabelWidth,
                horizontalGap: horizontalGap,
                labelTextStyle: labelTextStyle,
                contentTextStyle: contentTextStyle,
                contentTextAlign: contentTextAlign,
                contentMaxLines: contentMaxLines,
              )
            : TxDataRow.fromMap(
                data,
                spacing: columnSpacing,
                decoration: rowDecoration,
                padding: rowPadding,
                slots: slots,
                dense: dense,
                visualDensity: visualDensity,
                minLeadingWidth: minLeadingWidth,
                minLabelWidth: minLabelWidth,
                horizontalGap: horizontalGap,
                labelTextStyle: labelTextStyle,
                contentTextStyle: contentTextStyle,
                contentTextAlign: contentTextAlign,
                contentMaxLines: contentMaxLines,
              );

  /// 栅格的背景和边框装饰
  ///
  /// 如果为 null，则使用 [TxDataGridThemeData.decoration]。默认情况下没有装饰。
  final Decoration? decoration;

  /// 内边距
  ///
  /// 如果为 null，则使用 [TxDataGridThemeData.padding]。此值默认为
  /// [kMinInteractiveDimension] 以符合Material Design规范。
  final EdgeInsetsGeometry? padding;

  /// 每个数据列的内容之间的水平边距。
  ///
  /// 如果为 null，则使用 [TxDataGridThemeData.runSpacing]。此值默认为 12.0。
  final double? spacing;

  /// 要在每行中显示的数据（不包括包含列标题的行）。
  ///
  /// 必须为非null，但可以为空。
  final List<Widget> rows;

  @override
  Widget build(BuildContext context) {
    final TxDataGridThemeData gridTheme = TxDataGridTheme.of(context);
    const TxDataGridThemeData defaults = _DefaultDataGridTheme();

    final double effectiveSpacing =
        spacing ?? gridTheme.runSpacing ?? defaults.runSpacing!;
    final EdgeInsetsGeometry? effectivePadding =
        padding ?? gridTheme.padding ?? defaults.padding;
    final Decoration? effectiveDecoration =
        decoration ?? gridTheme.decoration ?? defaults.decoration;

    final List<Widget> children = [
      for (int i = 0; i < rows.length; i++) ...[
        rows[i],
        if (i != rows.length - 1) SizedBox(height: effectiveSpacing),
      ]
    ];

    return Container(
      decoration: effectiveDecoration,
      padding: effectivePadding,
      child: TxCellTheme(
        data: TxCellTheme.of(context).copyWith(
          dense: gridTheme.dense,
          visualDensity: gridTheme.visualDensity,
          minLabelWidth: gridTheme.minLabelWidth,
          labelTextStyle: gridTheme.labelTextStyle,
          contentTextStyle: gridTheme.contentTextStyle,
          contentTextAlign: gridTheme.contentTextAlign,
          minVerticalPadding: 0,
          padding: EdgeInsets.zero,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      ),
    );
  }
}

/// [TxDataGrid]的行配置和单元格数据
///
/// 必须为要在表中显示的每一行提供一个行配置。[TxDataGrid] 对象的列表作为“rows”参数传递给
/// [TxDataGrid.new] 构造函数。
///
/// 表的这一行的数据在 [TxDataRow] 对象的 [cells] 属性中提供。
class TxDataRow extends StatelessWidget {
  /// 为 [TxDataGrid] 的行创建配置。
  ///
  /// [cells] 参数不得为空。
  const TxDataRow({
    required this.cells,
    this.decoration,
    this.spacing,
    this.padding,
    super.key,
  });

  /// 通过指定 [data] 数据生成 [TxDataRow] 列表
  ///
  /// [columnNum] 用来控制列数， 如列数为1，请优先考虑使用 [TxCell.fromMap]。
  static List<Widget> fromMap(
    Map<String, dynamic> data, {
    final int columnNum = 2,
    Map<int, Widget>? slots,
    bool? dense,
    VisualDensity? visualDensity,
    double? minLabelWidth,
    double? minLeadingWidth,
    double? horizontalGap,
    TextStyle? contentTextStyle,
    TextStyle? labelTextStyle,
    TextAlign? contentTextAlign,
    EdgeInsetsGeometry? padding,
    Decoration? decoration,
    double? spacing,
    int? contentMaxLines,
  }) {
    final List<Widget> cells = TxCell.fromMap(
      data,
      slots: slots,
      dense: dense,
      visualDensity: visualDensity,
      minLeadingWidth: minLeadingWidth,
      minLabelWidth: minLabelWidth,
      minVerticalPadding: 0,
      horizontalGap: horizontalGap,
      labelTextStyle: labelTextStyle,
      contentTextStyle: contentTextStyle,
      contentTextAlign: contentTextAlign,
      padding: EdgeInsets.zero,
      contentMaxLines: contentMaxLines,
    );

    final int last = cells.length;

    return [
      for (int i = 0; i < cells.length; i += columnNum)
        TxDataRow(
          cells: cells
              .sublist(i, i + columnNum > last ? last : i + columnNum)
              .map((e) => Expanded(child: e))
              .toList(),
          decoration: decoration,
          padding: padding,
          spacing: spacing,
        ),
    ];
  }

  /// 此行的数据。
  final List<Widget> cells;

  /// 数据行的背景和边框装饰
  ///
  /// 如果为 null，则使用 [TxDataGridThemeData.decoration]。默认情况下没有装饰。
  final Decoration? decoration;

  /// [cells] 之间的间距
  final double? spacing;

  /// 内边距
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final TxDataGridThemeData gridTheme = TxDataGridTheme.of(context);
    const TxDataGridThemeData defaults = _DefaultDataGridTheme();

    final Decoration? effectiveDecoration =
        decoration ?? gridTheme.rowDecoration ?? defaults.decoration;
    final EdgeInsetsGeometry? effectivePadding =
        padding ?? gridTheme.padding ?? defaults.padding;
    final double effectiveSpacing =
        spacing ?? gridTheme.spacing ?? defaults.spacing!;

    return Container(
      padding: effectivePadding,
      decoration: effectiveDecoration,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          for (int i = 0; i < cells.length; i++) ...[
            cells[i],
            if (i != cells.length - 1) SizedBox(width: effectiveSpacing)
          ],
        ],
      ),
    );
  }
}

class _DefaultDataGridTheme extends TxDataGridThemeData {
  const _DefaultDataGridTheme() : super(spacing: 8.0, runSpacing: 6);
}
