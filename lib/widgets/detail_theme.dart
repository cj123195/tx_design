import 'dart:ui';

import 'package:flutter/material.dart';

import 'detail.dart';

/// 与 [TxDetailTheme] 一起使用来定义后代 [TxDetailView] 小部件的默认属性值。
///
/// 有关详细信息，请参阅各个 [TxDetailView] 属性。
@immutable
class TxDetailThemeData extends ThemeExtension<TxDetailThemeData> {
  const TxDetailThemeData({
    this.separator,
    this.dense,
    this.padding,
    this.minLabelWidth,
    this.decoration,
    this.contentTextStyle,
    this.labelTextStyle,
    this.contentTextAlign,
    this.visualDensity,
  });

  final Widget? separator;
  final Decoration? decoration;
  final EdgeInsetsGeometry? padding;
  final TextStyle? contentTextStyle;
  final TextStyle? labelTextStyle;
  final double? minLabelWidth;
  final TextAlign? contentTextAlign;
  final bool? dense;
  final VisualDensity? visualDensity;

  @override
  ThemeExtension<TxDetailThemeData> copyWith({
    Decoration? decoration,
    EdgeInsetsGeometry? padding,
    Widget? separator,
    TextStyle? contentTextStyle,
    TextStyle? labelTextStyle,
    double? minLabelWidth,
    bool? dense,
    VisualDensity? visualDensity,
    TextAlign? contentTextAlign,
  }) {
    return TxDetailThemeData(
      separator: separator ?? this.separator,
      decoration: decoration ?? this.decoration,
      padding: padding ?? this.padding,
      contentTextStyle: contentTextStyle ?? this.contentTextStyle,
      labelTextStyle: labelTextStyle ?? this.labelTextStyle,
      minLabelWidth: minLabelWidth ?? this.minLabelWidth,
      dense: dense ?? this.dense,
      visualDensity: visualDensity ?? this.visualDensity,
      contentTextAlign: contentTextAlign ?? this.contentTextAlign,
    );
  }

  @override
  ThemeExtension<TxDetailThemeData> lerp(
      ThemeExtension<TxDetailThemeData>? other, double t) {
    if (other is! TxDetailThemeData) {
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

    return TxDetailThemeData(
      decoration: Decoration.lerp(decoration, other.decoration, t),
      padding: EdgeInsetsGeometry.lerp(padding, other.padding, t),
      contentTextStyle:
          TextStyle.lerp(contentTextStyle, other.contentTextStyle, t),
      labelTextStyle: TextStyle.lerp(labelTextStyle, other.labelTextStyle, t),
      dense: t < 0.5 ? dense : other.dense,
      separator: t < 0.5 ? separator : other.separator,
      minLabelWidth: lerpDouble(minLabelWidth, minLabelWidth, t),
      visualDensity: effectiveVisualDensity,
      contentTextAlign: t < 0.5 ? contentTextAlign : other.contentTextAlign,
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
