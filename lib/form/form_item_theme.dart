import 'dart:ui';

import 'package:flutter/material.dart';

import 'form_item_container.dart';

/// 与 [FormItemTheme] 一起使用来定义后代 [FormItemContainer] 小部件的默认属性值。
///
/// 有关详细信息，请参阅各个 [FormItemContainer] 属性。
@Deprecated('This feature was deprecated after v0.3.0.')
@immutable
class FormItemThemeData extends ThemeExtension<FormItemThemeData> {
  @Deprecated('This feature was deprecated after v0.3.0.')
  const FormItemThemeData({
    this.backgroundColor,
    this.labelStyle,
    this.starStyle,
    this.padding,
    this.direction,
    this.inputDecorationTheme,
    this.horizontalGap,
    this.minLabelWidth,
  });

  final Color? backgroundColor;
  final TextStyle? labelStyle;
  final TextStyle? starStyle;
  final EdgeInsetsGeometry? padding;
  final Axis? direction;
  final InputDecorationTheme? inputDecorationTheme;
  final double? horizontalGap;
  final double? minLabelWidth;

  @override
  ThemeExtension<FormItemThemeData> copyWith({
    Color? backgroundColor,
    TextStyle? labelStyle,
    TextStyle? starStyle,
    EdgeInsetsGeometry? padding,
    Axis? direction,
    InputDecorationTheme? inputDecorationTheme,
    double? horizontalGap,
    double? minLabelWidth,
  }) {
    return FormItemThemeData(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      labelStyle: labelStyle ?? this.labelStyle,
      starStyle: starStyle ?? this.starStyle,
      padding: padding ?? this.padding,
      direction: direction ?? this.direction,
      inputDecorationTheme: inputDecorationTheme ?? this.inputDecorationTheme,
      horizontalGap: horizontalGap ?? this.horizontalGap,
      minLabelWidth: minLabelWidth ?? this.minLabelWidth,
    );
  }

  @override
  ThemeExtension<FormItemThemeData> lerp(
      ThemeExtension<FormItemThemeData>? other, double t) {
    if (other is! FormItemThemeData) {
      return this;
    }

    return FormItemThemeData(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      labelStyle: TextStyle.lerp(labelStyle, other.labelStyle, t),
      starStyle: TextStyle.lerp(starStyle, other.starStyle, t),
      padding: EdgeInsetsGeometry.lerp(padding, other.padding, t),
      direction: t < 0.5 ? direction : other.direction,
      inputDecorationTheme:
          t < 0.5 ? inputDecorationTheme : other.inputDecorationTheme,
      horizontalGap: lerpDouble(horizontalGap, other.horizontalGap, t),
      minLabelWidth: lerpDouble(minLabelWidth, other.minLabelWidth, t),
    );
  }
}

/// 一个继承的小部件，它在此小部件的子树中定义 [FormItemContainer] 的颜色和样式参数。
///
/// 此处指定的值用于未指定显式非空值的 [FormItemContainer] 属性。
@Deprecated('This feature was deprecated after v0.3.0.')
class FormItemTheme extends InheritedWidget {
  /// 创建一个日期选择按钮主题，该主题定义后代 [FormItemContainer] 的颜色和样式参数。
  @Deprecated('This feature was deprecated after v0.3.0.')
  const FormItemTheme({
    required super.child,
    required this.data,
    super.key,
  });

  final FormItemThemeData data;

  /// 包含给定上下文的此类的最近实例的 [data] 属性。
  ///
  /// 如果没有祖先，则返回 [ThemeData.extension<FormItemThemeData>()]。
  /// 如果它也为null，则返回默认[FormItemThemeData]
  @Deprecated('This feature was deprecated after v0.3.0.')
  static FormItemThemeData of(BuildContext context) {
    final FormItemTheme? txDatePickerButtonTheme =
        context.dependOnInheritedWidgetOfExactType<FormItemTheme>();
    return txDatePickerButtonTheme?.data ??
        Theme.of(context).extension<FormItemThemeData>() ??
        const FormItemThemeData();
  }

  @override
  bool updateShouldNotify(FormItemTheme oldWidget) => data != oldWidget.data;
}
