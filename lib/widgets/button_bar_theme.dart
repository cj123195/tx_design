import 'dart:ui';

import 'package:flutter/material.dart';

import 'button_bar.dart';

/// 与 [TxButtonBarTheme] 一起使用来定义后代 [TxButtonBar] 小部件的默认属性值。
///
/// 有关详细信息，请参阅各个 [TxButtonBar] 属性。
@immutable
class TxButtonBarThemeData extends ThemeExtension<TxButtonBarThemeData> {
  const TxButtonBarThemeData({
    this.mainButtonStyle,
    this.secondaryButtonStyle,
    this.buttonPadding,
    this.buttonTextTheme,
    this.buttonHeight,
    this.buttonMinWidth,
    this.layoutBehavior,
    this.buttonAlignedDropdown,
  });

  final ButtonStyle? mainButtonStyle;
  final ButtonStyle? secondaryButtonStyle;
  final EdgeInsetsGeometry? buttonPadding;
  final ButtonTextTheme? buttonTextTheme;
  final double? buttonHeight;
  final double? buttonMinWidth;
  final ButtonBarLayoutBehavior? layoutBehavior;
  final bool? buttonAlignedDropdown;

  @override
  ThemeExtension<TxButtonBarThemeData> copyWith({
    ButtonStyle? mainButtonStyle,
    ButtonStyle? secondaryButtonStyle,
    EdgeInsetsGeometry? buttonPadding,
    ButtonTextTheme? buttonTextTheme,
    double? buttonHeight,
    double? buttonMinWidth,
    ButtonBarLayoutBehavior? layoutBehavior,
    bool? buttonAlignedDropdown,
  }) {
    return TxButtonBarThemeData(
      mainButtonStyle: mainButtonStyle,
      secondaryButtonStyle: secondaryButtonStyle,
      buttonPadding: buttonPadding,
      buttonTextTheme: buttonTextTheme,
      buttonHeight: buttonHeight,
      buttonMinWidth: buttonMinWidth,
      layoutBehavior: layoutBehavior,
      buttonAlignedDropdown: buttonAlignedDropdown,
    );
  }

  @override
  ThemeExtension<TxButtonBarThemeData> lerp(
      ThemeExtension<TxButtonBarThemeData>? other, double t) {
    if (other is! TxButtonBarThemeData) {
      return this;
    }

    return TxButtonBarThemeData(
      mainButtonStyle:
          ButtonStyle.lerp(mainButtonStyle, other.mainButtonStyle, t),
      secondaryButtonStyle:
          ButtonStyle.lerp(secondaryButtonStyle, other.secondaryButtonStyle, t),
      buttonPadding:
          EdgeInsetsGeometry.lerp(buttonPadding, other.buttonPadding, t),
      buttonTextTheme: t < 0.5 ? buttonTextTheme : other.buttonTextTheme,
      buttonHeight: lerpDouble(buttonHeight, other.buttonHeight, t),
      buttonMinWidth: lerpDouble(buttonMinWidth, other.buttonMinWidth, t),
      layoutBehavior: t < 0.5 ? layoutBehavior : other.layoutBehavior,
      buttonAlignedDropdown:
          t < 0.5 ? buttonAlignedDropdown : other.buttonAlignedDropdown,
    );
  }
}

/// 一个继承的小部件，它在此小部件的子树中定义 [TxButtonBar] 的颜色和样式参数。
///
/// 此处指定的值用于未指定显式非空值的 [TxButtonBar] 属性。
class TxButtonBarTheme extends InheritedWidget {
  /// 创建一个操作按钮栏主题，该主题定义后代 [TxButtonBar] 的颜色和样式参数。
  const TxButtonBarTheme({
    required super.child,
    required this.data,
    super.key,
  });

  final TxButtonBarThemeData data;

  /// 包含给定上下文的此类的最近实例的 [data] 属性。
  ///
  /// 如果没有祖先，则返回 [ThemeData.extension<TxButtonBarThemeData>()]。
  /// 如果它也为null，则返回默认[TxButtonBarThemeData]
  static TxButtonBarThemeData of(BuildContext context) {
    final TxButtonBarTheme? txButtonBarTheme =
        context.dependOnInheritedWidgetOfExactType<TxButtonBarTheme>();
    return txButtonBarTheme?.data ??
        Theme.of(context).extension<TxButtonBarThemeData>() ??
        const TxButtonBarThemeData();
  }

  @override
  bool updateShouldNotify(TxButtonBarTheme oldWidget) => data != oldWidget.data;
}
