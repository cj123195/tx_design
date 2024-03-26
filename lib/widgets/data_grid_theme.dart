import 'dart:ui';

import 'package:flutter/material.dart';

import 'data_grid.dart';

/// 与 [TxDataGridTheme] 一起使用来定义后代 [TxDataGrid] 小部件的默认属性值。
///
/// 有关详细信息，请参阅各个 [TxDataGrid] 属性。
@immutable
class TxDataGridThemeData extends ThemeExtension<TxDataGridThemeData> {
  const TxDataGridThemeData({
    this.decoration,
    this.padding,
    this.dataRowDecoration,
    this.dataRowPadding,
    this.dataTextStyle,
    this.dataLabelTextStyle,
    this.dataLabelTextColor,
    this.rowSpacing,
    this.columnSpacing,
    this.minLabelWidth,
    this.dataMaxLines,
    this.contentTextAlign,
  });

  final Decoration? decoration;
  final EdgeInsetsGeometry? padding;
  final Decoration? dataRowDecoration;
  final EdgeInsetsGeometry? dataRowPadding;
  final TextStyle? dataTextStyle;
  final TextStyle? dataLabelTextStyle;
  final Color? dataLabelTextColor;
  final double? rowSpacing;
  final double? columnSpacing;
  final double? minLabelWidth;
  final int? dataMaxLines;
  final TextAlign? contentTextAlign;

  @override
  ThemeExtension<TxDataGridThemeData> copyWith({
    Decoration? decoration,
    EdgeInsetsGeometry? padding,
    Decoration? dataRowDecoration,
    EdgeInsetsGeometry? dataRowPadding,
    TextStyle? dataTextStyle,
    TextStyle? dataLabelTextStyle,
    Color? dataLabelTextColor,
    double? rowSpacing,
    double? columnSpacing,
    double? minLabelWidth,
    int? dataMaxLines,
    TextAlign? contentTextAlign,
  }) {
    return TxDataGridThemeData(
      decoration: decoration ?? this.decoration,
      padding: padding ?? this.padding,
      dataRowDecoration: dataRowDecoration ?? this.dataRowDecoration,
      dataRowPadding: dataRowPadding ?? this.dataRowPadding,
      dataTextStyle: dataTextStyle ?? this.dataTextStyle,
      dataLabelTextStyle: dataLabelTextStyle ?? this.dataLabelTextStyle,
      dataLabelTextColor: dataLabelTextColor ?? this.dataLabelTextColor,
      rowSpacing: rowSpacing ?? this.rowSpacing,
      columnSpacing: columnSpacing ?? this.columnSpacing,
      minLabelWidth: minLabelWidth ?? this.minLabelWidth,
      dataMaxLines: dataMaxLines ?? this.dataMaxLines,
      contentTextAlign: contentTextAlign ?? this.contentTextAlign,
    );
  }

  @override
  ThemeExtension<TxDataGridThemeData> lerp(
    ThemeExtension<TxDataGridThemeData>? other,
    double t,
  ) {
    if (other is! TxDataGridThemeData) {
      return this;
    }

    return TxDataGridThemeData(
      decoration: Decoration.lerp(decoration, other.decoration, t),
      padding: EdgeInsetsGeometry.lerp(padding, other.padding, t),
      dataRowDecoration:
          Decoration.lerp(dataRowDecoration, other.dataRowDecoration, t),
      dataRowPadding:
          EdgeInsetsGeometry.lerp(dataRowPadding, other.dataRowPadding, t),
      dataTextStyle: TextStyle.lerp(dataTextStyle, other.dataTextStyle, t),
      dataLabelTextStyle:
          TextStyle.lerp(dataLabelTextStyle, other.dataLabelTextStyle, t),
      dataLabelTextColor:
          Color.lerp(dataLabelTextColor, other.dataLabelTextColor, t),
      rowSpacing: lerpDouble(rowSpacing, other.rowSpacing, t),
      columnSpacing: lerpDouble(columnSpacing, other.columnSpacing, t),
      minLabelWidth: lerpDouble(minLabelWidth, minLabelWidth, t),
      dataMaxLines: t < 0.5 ? dataMaxLines : other.dataMaxLines,
      contentTextAlign: t < 0.5 ? contentTextAlign : other.contentTextAlign,
    );
  }
}

/// 一个继承的小部件，它在此小部件的子树中定义 [TxDataGrid] 的颜色和样式参数。
///
/// 此处指定的值用于未指定显式非空值的 [TxDataGrid] 属性。
class TxDataGridTheme extends InheritedWidget {
  /// 创建一个操作按钮栏主题，该主题定义后代 [TxDataGrid] 的颜色和样式参数。
  const TxDataGridTheme({
    required this.data,
    required super.child,
    super.key,
  });

  final TxDataGridThemeData data;

  /// 包含给定上下文的此类的最近实例的 [data] 属性。
  ///
  /// 如果没有祖先，则返回 [ThemeData.extension<TxDataGridThemeData>()]。
  /// 如果它也为null，则返回默认[TxDataGridThemeData]
  static TxDataGridThemeData of(BuildContext context) {
    final TxDataGridTheme? txDataGridTheme =
        context.dependOnInheritedWidgetOfExactType<TxDataGridTheme>();
    return txDataGridTheme?.data ??
        Theme.of(context).extension<TxDataGridThemeData>() ??
        const TxDataGridThemeData();
  }

  @override
  bool updateShouldNotify(TxDataGridTheme oldWidget) => data != oldWidget.data;
}
