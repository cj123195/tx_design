import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'status_indicator.dart';

/// 定义后代 [TxStatusIndicator] 小部件的默认属性值。
///
/// 后代小部件使用 `TxStatusIndicatorTheme.of(context)` 获取当前的
/// [TxStatusIndicatorThemeData] 对象。
/// [TxStatusIndicatorThemeData] 的实例可以使用 [TxStatusIndicatorThemeData.copyWith]
/// 进行自定义。
///
/// 默认情况下，所有 [TxStatusIndicatorThemeData] 属性均为“null”。 如果为 null，
/// [TxStatusIndicator] 将使用来自 [ThemeData] 的值（如果它们存在），否则它将根据整体
/// [Theme] 的 colorScheme 提供自己的默认值。 有关详细信息，请参阅各个 [TxStatusIndicator] 属性。
@immutable
class TxStatusIndicatorThemeData
    extends ThemeExtension<TxStatusIndicatorThemeData> with Diagnosticable {
  /// 创建可用于 [ThemeData.extension<TxStatusIndicatorThemeData>()] 的主题。
  const TxStatusIndicatorThemeData({
    this.indicatorColor,
    this.indicatorSize,
    this.labelColor,
    this.labelStyle,
  });

  final Color? indicatorColor;
  final double? indicatorSize;
  final Color? labelColor;
  final TextStyle? labelStyle;

  /// 创建此对象的副本，但将给定字段替换为新值。
  @override
  TxStatusIndicatorThemeData copyWith({
    Color? indicatorColor,
    double? indicatorSize,
    Color? labelColor,
    TextStyle? labelStyle,
  }) {
    return TxStatusIndicatorThemeData(
      indicatorColor: indicatorColor ?? this.indicatorColor,
      indicatorSize: indicatorSize ?? this.indicatorSize,
      labelColor: labelColor ?? this.labelColor,
      labelStyle: labelStyle ?? this.labelStyle,
    );
  }

  @override
  int get hashCode => Object.hash(
        indicatorColor,
        indicatorSize,
        labelColor,
        labelStyle,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is TxStatusIndicatorThemeData &&
        other.indicatorColor == indicatorColor &&
        other.indicatorSize == indicatorSize &&
        other.labelColor == labelColor &&
        other.labelStyle == labelStyle;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('indicatorSize', indicatorSize));
    properties.add(DiagnosticsProperty<Color>('indicatorColor', indicatorColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<Color>('labelColor', labelColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<TextStyle>('labelStyle', labelStyle,
        defaultValue: null));
  }

  @override
  ThemeExtension<TxStatusIndicatorThemeData> lerp(
      ThemeExtension<TxStatusIndicatorThemeData>? other, double t) {
    if (other is! TxStatusIndicatorThemeData) {
      return this;
    }

    return TxStatusIndicatorThemeData(
      indicatorSize: lerpDouble(indicatorSize, other.indicatorSize, t),
      indicatorColor: Color.lerp(indicatorColor, other.indicatorColor, t),
      labelColor: Color.lerp(labelColor, other.labelColor, t),
      labelStyle: TextStyle.lerp(labelStyle, other.labelStyle, t),
    );
  }
}

/// 将单选框主题应用于后代 [TxStatusIndicator] 小部件。
///
/// 后代小部件使用 [TxStatusIndicatorTheme.of] 获取当前主题的 [TxStatusIndicatorTheme] 对象。
/// 当小部件使用 [TxStatusIndicatorTheme.of] 时，如果主题稍后更改，它会自动重建。
class TxStatusIndicatorTheme extends InheritedWidget {
  /// 构造一个配置所有后代 [TxStatusIndicator] 小部件的画板主题。
  const TxStatusIndicatorTheme({
    required this.data,
    required super.child,
    super.key,
  });

  /// 用于所有后代 [TxStatusIndicator] 小部件的属性。
  final TxStatusIndicatorThemeData data;

  /// 从最近的 [TxStatusIndicatorTheme] 祖先返回配置 [data]。
  ///
  /// 如果没有祖先，则返回 [ThemeData.extension<TxStatusIndicatorThemeData>()]；
  /// 如果它也为null，则返回默认[TxStatusIndicatorThemeData]
  static TxStatusIndicatorThemeData of(BuildContext context) {
    final TxStatusIndicatorTheme? radioTheme =
        context.dependOnInheritedWidgetOfExactType<TxStatusIndicatorTheme>();
    return radioTheme?.data ??
        Theme.of(context).extension<TxStatusIndicatorThemeData>() ??
        const TxStatusIndicatorThemeData();
  }

  @override
  bool updateShouldNotify(TxStatusIndicatorTheme oldWidget) =>
      data != oldWidget.data;
}
