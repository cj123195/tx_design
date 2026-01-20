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
    this.rowDecoration,
    this.rowPadding,
    this.spacing,
    this.runSpacing,
    this.cellTheme,
  });

  final Decoration? decoration;
  final EdgeInsetsGeometry? padding;
  final Decoration? rowDecoration;
  final EdgeInsetsGeometry? rowPadding;
  final double? spacing;
  final double? runSpacing;
  final TxCellThemeData? cellTheme;

  @override
  ThemeExtension<TxDataGridThemeData> copyWith({
    Decoration? decoration,
    EdgeInsetsGeometry? padding,
    Decoration? rowDecoration,
    EdgeInsetsGeometry? rowPadding,
    double? spacing,
    double? runSpacing,
    TxCellThemeData? cellTheme,
  }) {
    return TxDataGridThemeData(
      decoration: decoration ?? this.decoration,
      padding: padding ?? this.padding,
      rowDecoration: rowDecoration ?? this.rowDecoration,
      rowPadding: rowPadding ?? this.rowPadding,
      spacing: spacing ?? this.spacing,
      runSpacing: runSpacing ?? this.runSpacing,
      cellTheme: cellTheme ?? this.cellTheme,
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

    TxCellThemeData? effectiveCellTheme;
    if (cellTheme == null) {
      effectiveCellTheme = other.cellTheme;
    } else if (other.cellTheme == null) {
      effectiveCellTheme = cellTheme;
    } else {
      effectiveCellTheme = cellTheme!.lerp(other.cellTheme, t);
    }

    return TxDataGridThemeData(
      decoration: Decoration.lerp(decoration, other.decoration, t),
      padding: EdgeInsetsGeometry.lerp(padding, other.padding, t),
      rowDecoration: Decoration.lerp(rowDecoration, other.rowDecoration, t),
      rowPadding: EdgeInsetsGeometry.lerp(rowPadding, other.rowPadding, t),
      cellTheme: effectiveCellTheme,
      spacing: lerpDouble(spacing, other.spacing, t),
      runSpacing: lerpDouble(runSpacing, other.runSpacing, t),
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
