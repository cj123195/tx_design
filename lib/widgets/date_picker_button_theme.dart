import 'package:flutter/material.dart';

import 'date_picker_button.dart';

/// 与 [TxDatePickerButtonTheme] 一起使用来定义后代 [TxDatePickerButton] 小部件的默认属性值。
///
/// 有关详细信息，请参阅各个 [TxDatePickerButton] 属性。
@immutable
class TxDatePickerButtonThemeData
    extends ThemeExtension<TxDatePickerButtonThemeData> {
  const TxDatePickerButtonThemeData({
    this.firstDate,
    this.lastDate,
    this.showWeekDay,
    this.buttonStyle,
    this.format,
  });

  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool? showWeekDay;
  final ButtonStyle? buttonStyle;
  final String? format;

  @override
  ThemeExtension<TxDatePickerButtonThemeData> copyWith({
    DateTime? firstDate,
    DateTime? lastDate,
    bool? showWeekDay,
    ButtonStyle? buttonStyle,
    String? format,
  }) {
    return TxDatePickerButtonThemeData(
      firstDate: firstDate ?? this.firstDate,
      lastDate: lastDate ?? this.lastDate,
      showWeekDay: showWeekDay ?? this.showWeekDay,
      buttonStyle: buttonStyle ?? this.buttonStyle,
      format: format ?? this.format,
    );
  }

  @override
  ThemeExtension<TxDatePickerButtonThemeData> lerp(
      ThemeExtension<TxDatePickerButtonThemeData>? other, double t) {
    if (other is! TxDatePickerButtonThemeData) {
      return this;
    }

    return t < 0.5 ? this : other;
  }
}

/// 一个继承的小部件，它在此小部件的子树中定义 [TxDatePickerButton] 的颜色和样式参数。
///
/// 此处指定的值用于未指定显式非空值的 [TxDatePickerButton] 属性。
class TxDatePickerButtonTheme extends InheritedWidget {
  /// 创建一个日期选择按钮主题，该主题定义后代 [TxDatePickerButton] 的颜色和样式参数。
  const TxDatePickerButtonTheme({
    required super.child,
    required this.data,
    super.key,
  });

  final TxDatePickerButtonThemeData data;

  /// 包含给定上下文的此类的最近实例的 [data] 属性。
  ///
  /// 如果没有祖先，则返回 [ThemeData.extension<TxDatePickerButtonThemeData>()]。
  /// 如果它也为null，则返回默认[TxDatePickerButtonThemeData]
  static TxDatePickerButtonThemeData of(BuildContext context) {
    final TxDatePickerButtonTheme? txDatePickerButtonTheme =
        context.dependOnInheritedWidgetOfExactType<TxDatePickerButtonTheme>();
    return txDatePickerButtonTheme?.data ??
        Theme.of(context).extension<TxDatePickerButtonThemeData>() ??
        const TxDatePickerButtonThemeData();
  }

  @override
  bool updateShouldNotify(TxDatePickerButtonTheme oldWidget) =>
      data != oldWidget.data;
}
