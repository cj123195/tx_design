import 'package:flutter/material.dart';

import 'data_grid_theme.dart';

const double _columnSpacing = 8.0;
const int _dataMaxLines = 2;

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
    this.dataRowDecoration,
    this.rowSpacing,
    this.columnSpacing,
    this.dataTextStyle,
    this.dataRowPadding,
    this.crossAxisAlignment,
  });

  /// 创建由[data]参数派生出的描述数据表的小组件。
  ///
  /// [data] 参数不能为空。
  TxDataGrid.fromData({
    required Map<String, dynamic> data,
    Map<int, TxDataCell>? slots,
    int columnNumber = 1,
    TextStyle? dataLabelTextStyle,
    double? minLabelWidth,
    Color? labelTextColor,
    int? dataMaxLines,
    TextAlign? contentTextAlign,
    super.key,
    this.decoration,
    this.padding,
    this.dataRowDecoration,
    this.rowSpacing,
    this.columnSpacing,
    this.dataTextStyle,
    this.dataRowPadding,
    this.crossAxisAlignment,
  }) : rows = _getRowsByDataSource(
          data,
          slots,
          columnNumber,
          dataTextStyle,
          dataLabelTextStyle,
          minLabelWidth,
          labelTextColor,
          dataMaxLines,
          dataRowDecoration,
          contentTextAlign,
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

  /// 数据行的背景和边框装饰
  ///
  /// 如果为 null，则使用 [TxDataGridThemeData.decoration]。默认情况下没有装饰。
  final Decoration? dataRowDecoration;

  /// 每行的边距
  ///
  /// 如果为 null，则使用 [TxDataGridThemeData.dataRowPadding]。。
  final EdgeInsetsGeometry? dataRowPadding;

  /// 数据的文本样式。
  ///
  /// 如果为 null，则使用 [TxDataGridThemeData.dataTextStyle]。默认情况下，文本样式为
  /// [TextTheme.labelLarge]。
  final TextStyle? dataTextStyle;

  /// 每个数据行之间的垂直间距
  ///
  /// 如果为 null，则使用 [TxDataGridThemeData.rowSpacing]。此值默认为 8.0。
  final double? rowSpacing;

  /// 每个数据列的内容之间的水平边距。
  ///
  /// 如果为 null，则使用 [TxDataGridThemeData.columnSpacing]。此值默认为 12.0。
  final double? columnSpacing;

  /// 要在每行中显示的数据（不包括包含列标题的行）。
  ///
  /// 必须为非null，但可以为空。
  final List<TxDataRow> rows;

  /// 交叉轴对其方式
  final CrossAxisAlignment? crossAxisAlignment;

  static const double defaultRowSpacing = 8.0;

  static List<TxDataRow> _getRowsByDataSource(
    Map<String, dynamic> data,
    Map<int, TxDataCell>? slots,
    int columnNumber,
    TextStyle? dataTextStyle,
    TextStyle? dataLabelTextStyle,
    double? minLabelWidth,
    Color? labelTextColor,
    int? dataMaxLines,
    Decoration? dataRowDecoration,
    TextAlign? contentTextAlign,
  ) {
    final List<TxDataCell> cells = List.generate(
      data.length,
      (index) {
        final String key = data.keys.toList()[index];
        return TxDataCell.rich(
          labelText: key,
          contentText: '${data[key] ?? ''}',
          labelTextStyle: dataLabelTextStyle,
          contentTextStyle: dataTextStyle,
          minLabelWidth: minLabelWidth,
          dataMaxLines: dataMaxLines,
          contentTextAlign: contentTextAlign,
        );
      },
    );
    if (slots?.isNotEmpty == true) {
      for (int i = 0; i < slots!.length; i++) {
        final int index = slots.keys.toList()[i];
        assert(
          index >= 0 && index <= cells.length,
          '插入位置需大于等于0且小于cell的长度',
        );
        cells.insert(index, slots[index]!);
      }
    }

    return [
      for (int i = 0; i < cells.length; i += columnNumber)
        TxDataRow(
          cells: cells.sublist(
            i,
            cells.length - i > columnNumber ? i + columnNumber : null,
          ),
          decoration: dataRowDecoration,
        )
    ];
  }

  @override
  Widget build(BuildContext context) {
    final TxDataGridThemeData dataGridTheme = TxDataGridTheme.of(context);

    final Decoration? effectiveDataRowDecoration =
        dataRowDecoration ?? dataGridTheme.dataRowDecoration;
    final double effectiveRowSpacing =
        rowSpacing ?? dataGridTheme.rowSpacing ?? TxDataGrid.defaultRowSpacing;
    final double effectiveColumnSpacing =
        columnSpacing ?? dataGridTheme.columnSpacing ?? _columnSpacing;
    final EdgeInsetsGeometry? effectiveDataRowPadding =
        dataRowPadding ?? dataGridTheme.dataRowPadding;

    final List<Widget> effectiveRows = List.generate(rows.length, (index) {
      final int cellsLength = rows[index].cells.length;

      final List<Widget> cells = [
        for (int i = 0; i < cellsLength; i++) ...[
          Expanded(child: rows[index].cells[i].child),
          if (i != cellsLength - 1) SizedBox(width: effectiveColumnSpacing)
        ]
      ];

      return Container(
        padding: effectiveDataRowPadding,
        decoration: effectiveDataRowDecoration,
        margin: index == rows.length - 1
            ? null
            : EdgeInsets.only(bottom: effectiveRowSpacing),
        child: Row(
          crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: cells,
        ),
      );
    });

    final Widget grid = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: effectiveRows,
    );

    return Container(
      decoration: decoration ?? dataGridTheme.decoration,
      padding: padding ?? dataGridTheme.padding,
      child: grid,
    );
  }
}

/// [TxDataGrid]的行配置和单元格数据
///
/// 必须为要在表中显示的每一行提供一个行配置。[TxDataGrid] 对象的列表作为“rows”参数传递给
/// [TxDataGrid.new] 构造函数。
///
/// 表的这一行的数据在 [TxDataRow] 对象的 [cells] 属性中提供。
@immutable
class TxDataRow {
  /// 为 [TxDataGrid] 的行创建配置。
  ///
  /// [cells] 参数不得为空。
  const TxDataRow({required this.cells, this.decoration});

  static List<Widget> fromDatasource({
    required Map<String, dynamic> data,
    Map<int, Widget>? slots,
    int columnNumber = 1,
    TextStyle? dataTextStyle,
    TextStyle? dataLabelTextStyle,
    double? minLabelWidth,
    Color? labelTextColor,
    int? dataMaxLines,
    Decoration? dataRowDecoration,
    TextAlign? contentTextAlign,
    EdgeInsetsGeometry? padding = const EdgeInsets.symmetric(vertical: 4.0),
  }) {
    final List<Widget> cells = List.generate(
      data.length,
      (index) {
        final String key = data.keys.toList()[index];
        return Expanded(
            child: TxRichDataCell(
          labelText: key,
          contentText: '${data[key] ?? ''}',
          labelTextStyle: dataLabelTextStyle,
          contentTextStyle: dataTextStyle,
          minLabelWidth: minLabelWidth,
          dataMaxLines: dataMaxLines,
          contentTextAlign: contentTextAlign,
        ));
      },
    );
    if (slots?.isNotEmpty == true) {
      for (int i = 0; i < slots!.length; i++) {
        final int index = slots.keys.toList()[i];
        assert(
          index >= 0 && index <= cells.length,
          '插入位置需大于等于0且小于cell的长度',
        );
        cells.insert(index, slots[index]!);
      }
    }

    return [
      for (int i = 0; i < cells.length; i += columnNumber)
        Container(
          padding: padding,
          decoration: dataRowDecoration,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: cells.sublist(i, i + columnNumber),
          ),
        ),
    ];
  }

  /// 此行的数据。
  final List<TxDataCell> cells;

  /// 数据行的背景和边框装饰
  ///
  /// 如果为 null，则使用 [TxDataGridThemeData.decoration]。默认情况下没有装饰。
  final Decoration? decoration;
}

/// [TxDataRow] 的单元格的数据。
///
/// 必须在新的 [TxDataRow] 构造函数的“cells”参数中为 [TxDataGrid] 中的每个 [DataRow]
/// 提供一个 [TxDataCell] 对象列表。
@immutable
class TxDataCell {
  /// 创建一个对象以保存 [TxDataGrid] 中单元格的数据。
  ///
  /// 第一个参数是要为单元格显示的小部件，通常是 [Text] 或 [DropdownButton] 小部件;
  /// 这将成为 [子] 属性，并且不得为 null。
  ///
  /// 如果单元格没有数据，则应改为提供带有占位符文本的 [Text] 小部件，然后将 [placeholder]
  /// 参数设置为 true。
  const TxDataCell(
    this.child, {
    this.placeholder = false,
    this.onTap,
  });

  /// 创建一个对象以保存 [TxDataGrid] 中单元格的数据。
  ///
  /// 第一个参数是要为单元格显示的小部件，通常是 [Text] 或 [DropdownButton] 小部件;
  /// 这将成为 [子] 属性，并且不得为 null。
  ///
  /// 如果单元格没有数据，则应改为提供带有占位符文本的 [Text] 小部件，然后将 [placeholder]
  /// 参数设置为 true。
  TxDataCell.rich({
    Widget? label,
    Widget? content,
    String? labelText,
    dynamic contentText,
    double? minLabelWidth,
    this.onTap,
    Color? labelTextColor,
    TextStyle? labelTextStyle,
    TextStyle? contentTextStyle,
    TextAlign? contentTextAlign,
    bool? numeric,
    int? dataMaxLines,
    CrossAxisAlignment? alignment,
  })  : placeholder = false,
        child = TxRichDataCell(
          label: label,
          labelText: labelText,
          content: content,
          contentText: contentText,
          labelTextStyle: labelTextStyle,
          contentTextStyle: contentTextStyle,
          minLabelWidth: minLabelWidth,
          labelTextColor: labelTextColor,
          numeric: numeric,
          dataMaxLines: dataMaxLines,
          alignment: alignment,
          contentTextAlign: contentTextAlign,
        );

  /// 没有内容且宽度和高度为零的单元格。
  static const TxDataCell empty = TxDataCell(SizedBox.shrink());

  /// 单元格的数据。
  ///
  /// 如果单元格没有数据，则应改为提供带有占位符文本的 [Text] 小部件，并将 [placeholder]
  /// 设置为 true
  final Widget child;

  /// [child] 是否实际上是占位符。
  ///
  /// 如果为 true，则单元格的默认文本样式将更改为适合占位符文本。
  final bool placeholder;

  /// 如果点击单元格，则调用。
  final GestureTapCallback? onTap;
}

class TxRichDataCell extends StatelessWidget {
  const TxRichDataCell({
    super.key,
    this.label,
    this.labelText,
    this.content,
    this.contentText,
    this.minLabelWidth,
    this.labelTextStyle,
    this.contentTextStyle,
    this.labelTextColor,
    bool? numeric,
    this.dataMaxLines,
    this.alignment,
    this.contentTextAlign,
  })  : assert(label != null || labelText != null),
        numeric =
            numeric ?? ((content == null && contentText is num) ? true : false);

  final Widget? label;
  final String? labelText;
  final Widget? content;
  final dynamic contentText;
  final double? minLabelWidth;
  final Color? labelTextColor;
  final TextStyle? labelTextStyle;
  final TextStyle? contentTextStyle;
  final bool numeric;
  final int? dataMaxLines;
  final CrossAxisAlignment? alignment;
  final TextAlign? contentTextAlign;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TxDataGridThemeData dataGridTheme = TxDataGridTheme.of(context);

    final Color? effectiveLabelColor =
        labelTextColor ?? dataGridTheme.dataLabelTextColor;
    final TextStyle effectiveLabelStyle = labelTextStyle ??
        dataGridTheme.dataLabelTextStyle ??
        theme.textTheme.labelLarge!.copyWith(color: theme.colorScheme.outline);
    final TextStyle effectiveContentStyle = contentTextStyle ??
        dataGridTheme.dataTextStyle ??
        theme.textTheme.bodyMedium!;
    final CrossAxisAlignment effectiveAlignment = alignment ??
        (numeric ? CrossAxisAlignment.center : CrossAxisAlignment.start);
    final TextAlign? effectiveContentTextAlign =
        contentTextAlign ?? dataGridTheme.contentTextAlign;

    Widget effectiveLabel = DefaultTextStyle(
      style: effectiveLabelStyle.copyWith(color: effectiveLabelColor),
      child: label ?? Text('${labelText!}：'),
    );
    if (minLabelWidth != null) {
      effectiveLabel = ConstrainedBox(
        constraints: BoxConstraints(minWidth: minLabelWidth!),
        child: effectiveLabel,
      );
    }

    final Widget effectiveContent = DefaultTextStyle(
      style: effectiveContentStyle,
      maxLines: dataMaxLines ?? dataGridTheme.dataMaxLines ?? _dataMaxLines,
      overflow: TextOverflow.ellipsis,
      textAlign: effectiveContentTextAlign,
      child: content ?? Text('${contentText ?? ''}'),
    );

    return Row(
      crossAxisAlignment: effectiveAlignment,
      children: [
        effectiveLabel,
        Expanded(child: effectiveContent),
      ],
    );
  }
}
