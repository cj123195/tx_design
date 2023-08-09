import 'dart:ui';

import 'package:flutter/material.dart';

import 'detail.dart';

/// 与 [TxDetailTheme] 一起使用来定义后代 [TxDetailView] 小部件的默认属性值。
///
/// 有关详细信息，请参阅各个 [TxDetailView] 属性。
@immutable
class TxDetailThemeData extends ThemeExtension<TxDetailThemeData> {
  const TxDetailThemeData({
    this.separate,
    this.dense,
    this.padding,
    this.minLabelWidth,
    this.labelStyle,
    this.contentStyle,
  });

  final bool? separate;
  final bool? dense;
  final EdgeInsetsGeometry? padding;
  final double? minLabelWidth;
  final TextStyle? labelStyle;
  final TextStyle? contentStyle;

  @override
  ThemeExtension<TxDetailThemeData> copyWith({
    bool? dense,
    bool? separate,
    EdgeInsetsGeometry? padding,
    double? minLabelWidth,
    TextStyle? labelStyle,
    TextStyle? contentStyle,
  }) {
    return TxDetailThemeData(
      separate: separate ?? this.separate,
      dense: dense ?? this.dense,
      padding: padding ?? this.padding,
      minLabelWidth: minLabelWidth ?? this.minLabelWidth,
      labelStyle: labelStyle ?? this.labelStyle,
      contentStyle: contentStyle ?? this.contentStyle,
    );
  }

  @override
  ThemeExtension<TxDetailThemeData> lerp(
      ThemeExtension<TxDetailThemeData>? other, double t) {
    if (other is! TxDetailThemeData) {
      return this;
    }

    return TxDetailThemeData(
      dense: t < 0.5 ? dense : other.dense,
      separate: t < 0.5 ? separate : other.separate,
      labelStyle: TextStyle.lerp(labelStyle, other.labelStyle, t),
      contentStyle: TextStyle.lerp(contentStyle, other.contentStyle, t),
      padding: EdgeInsetsGeometry.lerp(padding, other.padding, t),
      minLabelWidth: lerpDouble(minLabelWidth, other.minLabelWidth, t),
    );
  }
}

/// 一个继承的小部件，它在此小部件的子树中定义 [TxDetailView] 的颜色和样式参数。
///
/// 此处指定的值用于未指定显式非空值的 [TxDetailView] 属性。
class TxDetailTheme extends InheritedWidget {
  /// 创建一个栅格主题，该主题定义后代 [TxDetailView] 的颜色和样式参数。
  const TxDetailTheme({
    required super.child,
    required this.data,
    super.key,
  });

  final TxDetailThemeData data;

  /// 包含给定上下文的此类的最近实例的 [data] 属性。
  ///
  /// 如果没有祖先，则返回 [ThemeData.extension<TxDetailThemeData>()]。
  /// 如果它也为null，则返回默认[TxDetailThemeData]
  static TxDetailThemeData of(BuildContext context) {
    final TxDetailTheme? txDetailTheme =
        context.dependOnInheritedWidgetOfExactType<TxDetailTheme>();
    return txDetailTheme?.data ??
        Theme.of(context).extension<TxDetailThemeData>() ??
        const TxDetailThemeData();
  }

  @override
  bool updateShouldNotify(TxDetailTheme oldWidget) => data != oldWidget.data;
}
