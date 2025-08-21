import 'dart:ui';

import 'package:flutter/material.dart';

/// 定义后代小部件的默认间距。
///
/// 后代小部件使用 `SpacingTheme.of(context)` 获取当前的 [SpacingThemeData] 对象。
/// [SpacingThemeData] 的实例可以使用 [SpacingThemeData.copyWith] 进行自定义。
///
/// 新增属性时需同时更新[SpacingThemeData]默认构造方法、[copyWith]方法、[lerp]方法
@Deprecated('下一个版本将被删除')
@immutable
class SpacingThemeData extends ThemeExtension<SpacingThemeData> {
  @Deprecated('下一个版本将被删除')
  const SpacingThemeData({
    this.mini = 4.0,
    this.small = 8.0,
    this.medium = 12.0,
    this.large = 16.0,
    this.largest = 24.0,
  });

  final double mini;
  final double small;
  final double medium;
  final double large;
  final double largest;

  EdgeInsets get verticalMini => EdgeInsets.symmetric(vertical: mini);

  EdgeInsets get horizontalMini => EdgeInsets.symmetric(horizontal: mini);

  EdgeInsets get verticalSmall => EdgeInsets.symmetric(vertical: small);

  EdgeInsets get horizontalSmall => EdgeInsets.symmetric(horizontal: small);

  EdgeInsets get verticalMedium => EdgeInsets.symmetric(vertical: medium);

  EdgeInsets get horizontalMedium => EdgeInsets.symmetric(horizontal: medium);

  EdgeInsets get verticalLarge => EdgeInsets.symmetric(vertical: large);

  EdgeInsets get horizontalLarge => EdgeInsets.symmetric(horizontal: large);

  EdgeInsets get verticalLargest => EdgeInsets.symmetric(vertical: largest);

  EdgeInsets get horizontalLargest => EdgeInsets.symmetric(horizontal: largest);

  EdgeInsets get edgeInsetsMini => EdgeInsets.all(mini);

  EdgeInsets get edgeInsetsSmall => EdgeInsets.all(small);

  EdgeInsets get edgeInsetsLarge => EdgeInsets.all(large);

  EdgeInsets get edgeInsetsMedium => EdgeInsets.all(medium);

  EdgeInsets get edgeInsetsLargest => EdgeInsets.all(largest);

  @override
  ThemeExtension<SpacingThemeData> copyWith({
    double? mini,
    double? small,
    double? medium,
    double? large,
    double? largest,
  }) {
    return SpacingThemeData(
      mini: mini ?? this.mini,
      small: small ?? this.small,
      medium: medium ?? this.medium,
      large: large ?? this.large,
      largest: largest ?? this.largest,
    );
  }

  @override
  ThemeExtension<SpacingThemeData> lerp(
      ThemeExtension<SpacingThemeData>? other, double t) {
    if (other is! SpacingThemeData) {
      return this;
    }

    return SpacingThemeData(
      mini: lerpDouble(mini, other.mini, t)!,
      small: lerpDouble(small, other.small, t)!,
      medium: lerpDouble(small, other.medium, t)!,
      large: lerpDouble(small, other.large, t)!,
      largest: lerpDouble(largest, other.largest, t)!,
    );
  }
}

/// 将间距主题应用于后代小部件。
///
/// 后代小部件使用 [SpacingTheme.of] 获取当前主题的 [SpacingThemeData] 对象。
/// 当小部件使用 [SpacingTheme.of] 时，如果主题稍后更改，它会自动重建。
///
/// 可以使用 [ThemeData.extension<SpacingThemeData>()] 将间距主题指定为整个 Material
/// 主题的一部分。
@Deprecated('下一个版本将被删除')
class SpacingTheme extends InheritedWidget {
  /// 构造一个配置所有后代小部件间距的主题。
  @Deprecated('下一个版本将被删除')
  const SpacingTheme({
    required this.data,
    required super.child,
    super.key,
  });

  /// 用于所有后代小部件的间距。
  final SpacingThemeData data;

  /// 从最近的 [SpacingTheme] 祖先返回配置 [data]。
  ///
  /// 如果没有祖先，则返回 [ThemeData.extension<SpacingThemeData>()]；
  /// 如果它也为null，则返回默认[SpacingThemeData]
  static SpacingThemeData of(BuildContext context) {
    final SpacingTheme? radioTheme =
        context.dependOnInheritedWidgetOfExactType<SpacingTheme>();
    return radioTheme?.data ??
        Theme.of(context).extension<SpacingThemeData>() ??
        const SpacingThemeData();
  }

  @override
  bool updateShouldNotify(SpacingTheme oldWidget) => data != oldWidget.data;
}
