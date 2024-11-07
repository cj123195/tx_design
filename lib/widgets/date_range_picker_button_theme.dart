import 'package:flutter/material.dart';

import 'date_range_picker_button.dart';

/// 与 [TxDateRangePickerButtonTheme] 一起使用来定义后代 [TxDateRangePickerButton]
/// 小部件的默认属性值。
///
/// 有关详细信息，请参阅各个 [TxDateRangePickerButton] 属性。
@immutable
class TxDateRangePickerButtonThemeData
    extends ThemeExtension<TxDateRangePickerButtonThemeData> {
  const TxDateRangePickerButtonThemeData({
    this.minimumDate,
    this.maximumDate,
    this.buttonStyle,
    this.format,
  });

  final DateTime? minimumDate;
  final DateTime? maximumDate;
  final ButtonStyle? buttonStyle;
  final String? format;

  @override
  ThemeExtension<TxDateRangePickerButtonThemeData> copyWith({
    DateTime? minimumDate,
    DateTime? maximumDate,
    ButtonStyle? buttonStyle,
    String? format,
  }) {
    return TxDateRangePickerButtonThemeData(
      minimumDate: minimumDate ?? this.minimumDate,
      maximumDate: maximumDate ?? this.maximumDate,
      buttonStyle: buttonStyle ?? this.buttonStyle,
      format: format ?? this.format,
    );
  }

  @override
  ThemeExtension<TxDateRangePickerButtonThemeData> lerp(
      ThemeExtension<TxDateRangePickerButtonThemeData>? other, double t) {
    if (other is! TxDateRangePickerButtonThemeData) {
      return this;
    }

    return t < 0.5 ? this : other;
  }
}

/// 一个继承的小部件，它在此小部件的子树中定义 [TxDateRangePickerButton] 的颜色和样式参数。
///
/// 此处指定的值用于未指定显式非空值的 [TxDateRangePickerButton] 属性。
class TxDateRangePickerButtonTheme extends InheritedWidget {
  /// 创建一个日期区间选择按钮主题，该主题定义后代 [TxDateRangePickerButton] 的颜色和样式参数。
  const TxDateRangePickerButtonTheme({
    required super.child,
    required this.data,
    super.key,
  });

  final TxDateRangePickerButtonThemeData data;

  /// 包含给定上下文的此类的最近实例的 [data] 属性。
  ///
  /// 如果没有祖先，则返回 [ThemeData.extension<TxDateRangePickerButtonThemeData>()]。
  /// 如果它也为null，则返回默认[TxDateRangePickerButtonThemeData]
  static TxDateRangePickerButtonThemeData of(BuildContext context) {
    final TxDateRangePickerButtonTheme? txDateRangePickerButtonTheme = context
        .dependOnInheritedWidgetOfExactType<TxDateRangePickerButtonTheme>();
    return txDateRangePickerButtonTheme?.data ??
        Theme.of(context).extension<TxDateRangePickerButtonThemeData>() ??
        const TxDateRangePickerButtonThemeData();
  }

  @override
  bool updateShouldNotify(TxDateRangePickerButtonTheme oldWidget) =>
      data != oldWidget.data;
}
