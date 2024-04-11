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
    this.minLabelWidth,
    this.contentTextAlign,
    this.rowDecoration,
    this.rowPadding,
    this.contentTextStyle,
    this.labelTextStyle,
    this.spacing,
    this.runSpacing,
    this.dense,
    this.visualDensity,
  });

  final Decoration? decoration;
  final EdgeInsetsGeometry? padding;
  final Decoration? rowDecoration;
  final EdgeInsetsGeometry? rowPadding;
  final TextStyle? contentTextStyle;
  final TextStyle? labelTextStyle;
  final double? spacing;
  final double? runSpacing;
  final double? minLabelWidth;
  final TextAlign? contentTextAlign;
  final bool? dense;
  final VisualDensity? visualDensity;

  @override
  ThemeExtension<TxDataGridThemeData> copyWith({
    Decoration? decoration,
    EdgeInsetsGeometry? padding,
    Decoration? rowDecoration,
    EdgeInsetsGeometry? rowPadding,
    TextStyle? contentTextStyle,
    TextStyle? labelTextStyle,
    double? spacing,
    double? runSpacing,
    double? minLabelWidth,
    bool? dense,
    VisualDensity? visualDensity,
    TextAlign? contentTextAlign,
  }) {
    return TxDataGridThemeData(
      decoration: decoration ?? this.decoration,
      padding: padding ?? this.padding,
      rowDecoration: rowDecoration ?? this.rowDecoration,
      rowPadding: rowPadding ?? this.rowPadding,
      contentTextStyle: contentTextStyle ?? this.contentTextStyle,
      labelTextStyle: labelTextStyle ?? this.labelTextStyle,
      spacing: spacing ?? this.spacing,
      runSpacing: runSpacing ?? this.runSpacing,
      minLabelWidth: minLabelWidth ?? this.minLabelWidth,
      dense: dense ?? this.dense,
      visualDensity: visualDensity ?? this.visualDensity,
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

    VisualDensity? effectiveVisualDensity;
    if (visualDensity == null) {
      effectiveVisualDensity = other.visualDensity;
    } else if (other.visualDensity == null) {
      effectiveVisualDensity = visualDensity;
    } else {
      effectiveVisualDensity =
          VisualDensity.lerp(visualDensity!, other.visualDensity!, t);
    }

    return TxDataGridThemeData(
      decoration: Decoration.lerp(decoration, other.decoration, t),
      padding: EdgeInsetsGeometry.lerp(padding, other.padding, t),
      rowDecoration: Decoration.lerp(rowDecoration, other.rowDecoration, t),
      rowPadding: EdgeInsetsGeometry.lerp(rowPadding, other.rowPadding, t),
      contentTextStyle:
          TextStyle.lerp(contentTextStyle, other.contentTextStyle, t),
      labelTextStyle: TextStyle.lerp(labelTextStyle, other.labelTextStyle, t),
      dense: t < 0.5 ? dense : other.dense,
      spacing: lerpDouble(spacing, other.spacing, t),
      runSpacing: lerpDouble(runSpacing, other.runSpacing, t),
      minLabelWidth: lerpDouble(minLabelWidth, minLabelWidth, t),
      visualDensity: effectiveVisualDensity,
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
