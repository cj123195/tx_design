import 'dart:ui';

import 'package:flutter/material.dart';

import 'action_bar.dart';

/// 与 [TxActionBarTheme] 一起使用来定义后代 [TxActionBar] 小部件的默认属性值。
///
/// 有关详细信息，请参阅各个 [TxActionBar] 属性。
@immutable
class TxActionBarThemeData extends ThemeExtension<TxActionBarThemeData> {
  const TxActionBarThemeData({
    this.buttonStyle,
    this.iconButtonStyle,
    this.iconTheme,
    this.leadingTextStyle,
    this.actionGap,
    this.minLeadingWidth,
    this.leadingGap,
  });

  final ButtonStyle? buttonStyle;
  final ButtonStyle? iconButtonStyle;
  final IconThemeData? iconTheme;
  final TextStyle? leadingTextStyle;
  final double? actionGap;
  final double? minLeadingWidth;
  final double? leadingGap;

  @override
  ThemeExtension<TxActionBarThemeData> copyWith({
    ButtonStyle? buttonStyle,
    ButtonStyle? iconButtonStyle,
    IconThemeData? iconTheme,
    TextStyle? leadingTextStyle,
    double? actionGap,
    double? minLeadingWidth,
    double? leadingGap,
  }) {
    return TxActionBarThemeData(
      buttonStyle: buttonStyle,
      iconButtonStyle: iconButtonStyle,
      iconTheme: iconTheme,
      leadingTextStyle: leadingTextStyle,
      actionGap: actionGap,
      minLeadingWidth: minLeadingWidth,
      leadingGap: leadingGap,
    );
  }

  @override
  ThemeExtension<TxActionBarThemeData> lerp(
      ThemeExtension<TxActionBarThemeData>? other, double t) {
    if (other is! TxActionBarThemeData) {
      return this;
    }

    return TxActionBarThemeData(
      buttonStyle: ButtonStyle.lerp(buttonStyle, other.buttonStyle, t),
      iconButtonStyle:
          ButtonStyle.lerp(iconButtonStyle, other.iconButtonStyle, t),
      iconTheme: IconThemeData.lerp(iconTheme, other.iconTheme, t),
      leadingTextStyle:
          TextStyle.lerp(leadingTextStyle, other.leadingTextStyle, t),
      actionGap: lerpDouble(actionGap, other.actionGap, t),
      minLeadingWidth: lerpDouble(minLeadingWidth, other.minLeadingWidth, t),
      leadingGap: lerpDouble(leadingGap, leadingGap, t),
    );
  }
}

/// 一个继承的小部件，它在此小部件的子树中定义 [TxActionBar] 的颜色和样式参数。
///
/// 此处指定的值用于未指定显式非空值的 [TxActionBar] 属性。
class TxActionBarTheme extends InheritedWidget {
  /// 创建一个操作按钮栏主题，该主题定义后代 [TxActionBar] 的颜色和样式参数。
  const TxActionBarTheme({
    required this.data,
    required super.child,
    super.key,
  });

  final TxActionBarThemeData data;

  /// 包含给定上下文的此类的最近实例的 [data] 属性。
  ///
  /// 如果没有祖先，则返回 [ThemeData.extension<TxActionBarThemeData>()]。
  /// 如果它也为null，则返回默认[TxActionBarThemeData]
  static TxActionBarThemeData of(BuildContext context) {
    final TxActionBarTheme? txActionBarTheme =
        context.dependOnInheritedWidgetOfExactType<TxActionBarTheme>();
    return txActionBarTheme?.data ??
        Theme.of(context).extension<TxActionBarThemeData>() ??
        const TxActionBarThemeData();
  }

  @override
  bool updateShouldNotify(TxActionBarTheme oldWidget) => data != oldWidget.data;
}
