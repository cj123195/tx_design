import 'package:flutter/material.dart';

double _lerpDouble(double a, double b, double t) {
  return a + (b - a) * t;
}

/// 定义后代小部件的默认elevation
///
/// elevation是两个表面之间沿 z 轴的相对距离。
///
/// 后代小部件使用 `SpacingTheme.of(context)` 获取当前的 [ElevationThemeData] 对象。
/// [ElevationThemeData] 的实例可以使用 [ElevationThemeData.copyWith] 进行自定义。
///
/// 新增属性时需同时更新[ElevationThemeData]默认构造方法、[copyWith]方法、[lerp]方法
///
/// 配置参考https://m3.material.io/styles/elevation/overview
class ElevationThemeData extends ThemeExtension<ElevationThemeData> {
  const ElevationThemeData({
    this.level0 = 0.0,
    this.level1 = 1.0,
    this.level2 = 3.0,
    this.level3 = 6.0,
    this.level4 = 8.0,
    this.level5 = 12.0,
  });

  final double level0;
  final double level1;
  final double level2;
  final double level3;
  final double level4;
  final double level5;

  @override
  ThemeExtension<ElevationThemeData> copyWith({
    double? level0,
    double? level1,
    double? level2,
    double? level3,
    double? level4,
    double? level5,
  }) {
    return ElevationThemeData(
      level0: level0 ?? this.level0,
      level1: level1 ?? this.level1,
      level2: level2 ?? this.level2,
      level3: level3 ?? this.level3,
      level4: level4 ?? this.level4,
      level5: level5 ?? this.level5,
    );
  }

  @override
  ThemeExtension<ElevationThemeData> lerp(
      ThemeExtension<ElevationThemeData>? other, double t) {
    if (other is! ElevationThemeData) {
      return this;
    }

    return ElevationThemeData(
      level0: _lerpDouble(level0, other.level0, t),
      level1: _lerpDouble(level1, other.level1, t),
      level2: _lerpDouble(level2, other.level2, t),
      level3: _lerpDouble(level3, other.level3, t),
      level4: _lerpDouble(level4, other.level4, t),
      level5: _lerpDouble(level5, other.level5, t),
    );
  }
}

/// 将elevation主题应用于后代小部件。
///
/// 后代小部件使用 [ElevationTheme.of] 获取当前主题的 [ElevationThemeData] 对象。
/// 当小部件使用 [ElevationTheme.of] 时，如果主题稍后更改，它会自动重建。
///
/// 可以使用 [ThemeData.extension<ElevationThemeData>()] 将elevation主题指定为整个 Material
/// 主题的一部分。
class ElevationTheme extends InheritedWidget {
  /// 构造一个配置所有后代小部件elevation的主题。
  const ElevationTheme({
    required this.data,
    required super.child,
    super.key,
  });

  /// 用于所有后代小部件的elevation。
  final ElevationThemeData data;

  /// 从最近的 [ElevationTheme] 祖先返回配置 [data]。
  ///
  /// 如果没有祖先，则返回 [ThemeData.extension<ElevationThemeData>()]；
  /// 如果它也为null，则返回默认[ElevationThemeData]
  static ElevationThemeData of(BuildContext context) {
    final ElevationTheme? radioTheme =
        context.dependOnInheritedWidgetOfExactType<ElevationTheme>();
    return radioTheme?.data ??
        Theme.of(context).extension<ElevationThemeData>() ??
        const ElevationThemeData();
  }

  @override
  bool updateShouldNotify(ElevationTheme oldWidget) => data != oldWidget.data;
}
