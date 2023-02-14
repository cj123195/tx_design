import 'package:flutter/material.dart';

import 'loading.dart';
import 'shimmer.dart' show ShimmerDirection;

/// 与 [TxLoadingTheme] 一起使用来定义后代 [TxLoading] 小部件的默认属性值。
///
/// 有关详细信息，请参阅各个 [TxLoading] 属性。
@immutable
class TxLoadingThemeData extends ThemeExtension<TxLoadingThemeData> {
  const TxLoadingThemeData({
    this.child,
    this.textStyle,
    this.iconTheme,
    this.period,
    this.direction,
    this.gradient,
  });

  TxLoadingThemeData.formColors({
    required Color baseColor,
    required Color highlightColor,
    this.child,
    this.textStyle,
    this.iconTheme,
    this.period,
    this.direction,
  }) : gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.centerRight,
      colors: <Color>[
        baseColor,
        baseColor,
        highlightColor,
        baseColor,
        baseColor
      ],
      stops: const <double>[
        0.0,
        0.35,
        0.5,
        0.65,
        1.0
      ]);

  final Widget? child;
  final TextStyle? textStyle;
  final IconThemeData? iconTheme;
  final Duration? period;
  final ShimmerDirection? direction;
  final Gradient? gradient;

  @override
  ThemeExtension<TxLoadingThemeData> copyWith({
    Widget? child,
    TextStyle? textStyle,
    IconThemeData? iconTheme,
    Color? baseColor,
    Color? highlightColor,
    Duration? period,
    ShimmerDirection? direction,
    Gradient? gradient,
  }) {
    return TxLoadingThemeData(
      child: child,
      textStyle: textStyle,
      iconTheme: iconTheme,
      period: period,
      direction: direction,
      gradient: gradient,
    );
  }

  @override
  ThemeExtension<TxLoadingThemeData> lerp(
      ThemeExtension<TxLoadingThemeData>? other, double t) {
    if (other is! TxLoadingThemeData) {
      return this;
    }

    return TxLoadingThemeData(
      child: t < 0.5 ? child : other.child,
      textStyle: TextStyle.lerp(textStyle, other.textStyle, t),
      iconTheme: IconThemeData.lerp(iconTheme, other.iconTheme, t),
      period: t < 0.5 ? period: other.period,
      direction: t < 0.5 ? direction : other.direction,
      gradient: Gradient.lerp(gradient, other.gradient, t),
    );
  }
}

/// 一个继承的小部件，它在此小部件的子树中定义 [TxLoading] 的颜色和样式参数。
///
/// 此处指定的值用于未指定显式非空值的 [TxLoading] 属性。
class TxLoadingTheme extends InheritedWidget {
  /// 创建一个加载主题，该主题定义后代 [TxLoading] 的颜色和样式参数。
  const TxLoadingTheme({
    required super.child,
    required this.data,
    super.key,
  });

  final TxLoadingThemeData data;

  /// 包含给定上下文的此类的最近实例的 [data] 属性。
  ///
  /// 如果没有祖先，则返回 [ThemeData.extension<TxLoadingThemeData>()]。
  /// 如果它也为null，则返回默认[TxLoadingThemeData]
  static TxLoadingThemeData of(BuildContext context) {
    final TxLoadingTheme? txLoadingTheme =
        context.dependOnInheritedWidgetOfExactType<TxLoadingTheme>();
    return txLoadingTheme?.data ??
        Theme.of(context).extension<TxLoadingThemeData>() ??
        const TxLoadingThemeData();
  }

  @override
  bool updateShouldNotify(TxLoadingTheme oldWidget) => data != oldWidget.data;
}
