import 'dart:ui';

import 'package:flutter/material.dart';

/// 定义后代小部件的默认圆角
///
/// 后代小部件使用 `SpacingTheme.of(context)` 获取当前的 [RadiusThemeData] 对象。
/// [RadiusThemeData] 的实例可以使用 [RadiusThemeData.copyWith] 进行自定义。
///
/// 新增属性时需同时更新[RadiusThemeData]默认构造方法、[copyWith]方法、[lerp]方法
///
/// 配置参考https://m3.material.io/styles/shape/shape-scale-tokens
class RadiusThemeData extends ThemeExtension<RadiusThemeData> {

  const RadiusThemeData({
    this.mini = 4.0,
    this.small = 8.0,
    this.medium = 12.0,
    this.large = 16.0,
    this.largest = 28.0,
  });
  final double mini;
  final double small;
  final double medium;
  final double large;
  final double largest;

  BorderRadius get miniRadius => BorderRadius.circular(mini);

  BorderRadius get smallRadius => BorderRadius.circular(small);

  BorderRadius get mediumRadius => BorderRadius.circular(medium);

  BorderRadius get largeRadius => BorderRadius.circular(large);

  BorderRadius get largestRadius => BorderRadius.circular(largest);

  @override
  ThemeExtension<RadiusThemeData> copyWith({
    double? mini,
    double? small,
    double? medium,
    double? large,
    double? largest,
  }) {
    return RadiusThemeData(
      mini: mini ?? this.mini,
      small: small ?? this.small,
      medium: medium ?? this.medium,
      large: large ?? this.large,
      largest: largest ?? this.largest,
    );
  }

  @override
  ThemeExtension<RadiusThemeData> lerp(
      ThemeExtension<RadiusThemeData>? other, double t) {
    if (other is! RadiusThemeData) {
      return this;
    }

    return RadiusThemeData(
        mini: lerpDouble(mini, other.mini, t)!,
        small: lerpDouble(small, other.small, t)!,
        medium: lerpDouble(small, other.medium, t)!,
        large: lerpDouble(small, other.large, t)!,
        largest: lerpDouble(largest, other.largest, t)!);
  }
}

/// 将圆角主题应用于后代小部件。
///
/// 后代小部件使用 [RadiusTheme.of] 获取当前主题的 [RadiusThemeData] 对象。
/// 当小部件使用 [RadiusTheme.of] 时，如果主题稍后更改，它会自动重建。
///
/// 可以使用 [ThemeData.extension<RadiusThemeData>()] 将圆角主题指定为整个 Material
/// 主题的一部分。
class RadiusTheme extends InheritedWidget {
  /// 构造一个配置所有后代小部件圆角的主题。
  const RadiusTheme({
    required this.data,
    required super.child,
    super.key,
  });

  /// 用于所有后代小部件的圆角。
  final RadiusThemeData data;

  /// 从最近的 [RadiusTheme] 祖先返回配置 [data]。
  ///
  /// 如果没有祖先，则返回 [ThemeData.extension<RadiusThemeData>()]；
  /// 如果它也为null，则返回默认[RadiusThemeData]
  static RadiusThemeData of(BuildContext context) {
    final RadiusTheme? radioTheme =
    context.dependOnInheritedWidgetOfExactType<RadiusTheme>();
    return radioTheme?.data ??
        Theme.of(context).extension<RadiusThemeData>() ??
        const RadiusThemeData();
  }

  @override
  bool updateShouldNotify(RadiusTheme oldWidget) => data != oldWidget.data;
}
