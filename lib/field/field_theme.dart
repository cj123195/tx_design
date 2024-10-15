import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'field.dart';

/// 与 [TxFieldTheme] 一起使用来定义后代 [TxField] 小部件的默认属性值。
///
/// 有关详细信息，请参阅各个 [TxField] 属性。
@immutable
class TxFieldThemeData extends ThemeExtension<TxFieldThemeData> {
  const TxFieldThemeData({this.inputDecorationTheme});

  /// 覆盖 [TxField.decoration] 的默认值。
  final InputDecorationTheme? inputDecorationTheme;

  @override
  ThemeExtension<TxFieldThemeData> copyWith({
    InputDecorationTheme? inputDecorationTheme,
  }) {
    return TxFieldThemeData(
      inputDecorationTheme: inputDecorationTheme ?? this.inputDecorationTheme,
    );
  }

  @override
  ThemeExtension<TxFieldThemeData> lerp(
    ThemeExtension<TxFieldThemeData>? other,
    double t,
  ) {
    if (other is! TxFieldThemeData) {
      return this;
    }

    final InputDecorationTheme? a = inputDecorationTheme;
    final InputDecorationTheme? b = other.inputDecorationTheme;

    if (a == null) {
      return TxFieldThemeData(inputDecorationTheme: b);
    }

    if (b == null) {
      return TxFieldThemeData(inputDecorationTheme: a);
    }

    final Duration? hintFadeDuration = a.hintFadeDuration == null
        ? b.hintFadeDuration
        : b.hintFadeDuration == null
            ? a.hintFadeDuration
            : lerpDuration(a.hintFadeDuration!, b.hintFadeDuration!, t);

    return TxFieldThemeData(
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle.lerp(a.labelStyle, b.labelStyle, t),
        floatingLabelStyle:
            TextStyle.lerp(a.floatingLabelStyle, b.floatingLabelStyle, t),
        helperStyle: TextStyle.lerp(a.helperStyle, b.helperStyle, t),
        helperMaxLines: t < 0.5 ? a.helperMaxLines : b.helperMaxLines,
        hintStyle: TextStyle.lerp(a.hintStyle, b.hintStyle, t),
        hintFadeDuration: hintFadeDuration,
        errorStyle: TextStyle.lerp(a.errorStyle, b.errorStyle, t),
        errorMaxLines: t < 0.5 ? a.errorMaxLines : b.errorMaxLines,
        floatingLabelBehavior:
            t < 0.5 ? a.floatingLabelBehavior : b.floatingLabelBehavior,
        floatingLabelAlignment:
            t < 0.5 ? a.floatingLabelAlignment : b.floatingLabelAlignment,
        isDense: t < 0.5 ? a.isDense : b.isDense,
        contentPadding:
            EdgeInsetsGeometry.lerp(a.contentPadding, b.contentPadding, t),
        isCollapsed: t < 0.5 ? a.isCollapsed : b.isCollapsed,
        iconColor: Color.lerp(a.iconColor, b.iconColor, t),
        prefixStyle: TextStyle.lerp(a.prefixStyle, b.prefixStyle, t),
        prefixIconColor: Color.lerp(a.prefixIconColor, b.prefixIconColor, t),
        suffixStyle: TextStyle.lerp(a.suffixStyle, b.suffixStyle, t),
        suffixIconColor: Color.lerp(a.suffixIconColor, b.suffixIconColor, t),
        counterStyle: TextStyle.lerp(a.counterStyle, b.counterStyle, t),
        filled: t < 0.5 ? a.filled : b.filled,
        fillColor: Color.lerp(a.fillColor, b.fillColor, t),
        activeIndicatorBorder: _lerpBorderSide(
          a.activeIndicatorBorder,
          b.activeIndicatorBorder,
          t,
        ),
        outlineBorder: _lerpBorderSide(a.outlineBorder, b.outlineBorder, t),
        focusColor: Color.lerp(a.focusColor, b.focusColor, t),
        hoverColor: Color.lerp(a.hoverColor, b.hoverColor, t),
        errorBorder: t < 0.5 ? a.errorBorder : b.errorBorder,
        focusedBorder: t < 0.5 ? a.focusedBorder : b.focusedBorder,
        focusedErrorBorder:
            t < 0.5 ? a.focusedErrorBorder : b.focusedErrorBorder,
        disabledBorder: t < 0.5 ? a.disabledBorder : b.disabledBorder,
        enabledBorder: t < 0.5 ? a.enabledBorder : b.enabledBorder,
        border: t < 0.5 ? a.border : b.border,
        alignLabelWithHint:
            t < 0.5 ? a.alignLabelWithHint : b.alignLabelWithHint,
        constraints: BoxConstraints.lerp(a.constraints, b.constraints, t),
      ),
    );
  }

  BorderSide? _lerpBorderSide(BorderSide? a, BorderSide? b, double t) {
    return a == null
        ? b
        : b == null
            ? a
            : BorderSide.lerp(a, b, t);
  }

  @override
  int get hashCode => inputDecorationTheme.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is TxFieldThemeData &&
        other.inputDecorationTheme == inputDecorationTheme;
  }
}

/// 一个继承的小部件，它在此小部件的子树中定义 [TxField] 的颜色和样式参数。
///
/// 此处指定的值用于未指定显式非空值的 [TxField] 属性。
class TxFieldTheme extends InheritedWidget {
  /// 创建一个日期选择按钮主题，该主题定义后代 [TxField] 的颜色和样式参数。
  const TxFieldTheme({
    required super.child,
    required this.data,
    super.key,
  });

  final TxFieldThemeData data;

  /// 包含给定上下文的此类的最近实例的 [data] 属性。
  ///
  /// 如果没有祖先，则返回 [ThemeData.extension<TxFieldThemeData>()]。
  /// 如果它也为null，则返回默认[TxFieldThemeData]
  static TxFieldThemeData of(BuildContext context) {
    final TxFieldTheme? txDatePickerButtonTheme =
        context.dependOnInheritedWidgetOfExactType<TxFieldTheme>();
    return txDatePickerButtonTheme?.data ??
        Theme.of(context).extension<TxFieldThemeData>() ??
        const TxFieldThemeData();
  }

  @override
  bool updateShouldNotify(TxFieldTheme oldWidget) => data != oldWidget.data;
}
