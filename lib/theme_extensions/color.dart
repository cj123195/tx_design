import 'package:flutter/material.dart';

int _lerpInt(int a, int b, double t) {
  return (a + (b - a) * t).toInt();
}

extension MaterialAccentColorExtension on MaterialAccentColor {
  List<Color> get lightGradient => [shade400, this];

  List<Color> get darkGradient => [this, shade700];

  MaterialAccentColor lerp(MaterialAccentColor? other, double t) {
    if (other is! MaterialAccentColor) {
      return this;
    }
    return MaterialAccentColor(_lerpInt(value, other.value, t), <int, Color>{
      100: Color.lerp(this[100] ?? this, other[100] ?? other, t)!,
      200: Color.lerp(this[200] ?? this, other[200] ?? other, t)!,
      400: Color.lerp(this[400] ?? this, other[400] ?? other, t)!,
      700: Color.lerp(this[700] ?? this, other[700] ?? other, t)!,
    });
  }
}

/// 定义后代小部件的默认颜色
///
/// 后代小部件使用 `SpacingTheme.of(context)` 获取当前的 [ColorThemeData] 对象。
/// [ColorThemeData] 的实例可以使用 [ColorThemeData.copyWith] 进行自定义。
///
/// 新增属性时需同时更新[ColorThemeData]默认构造方法、[ColorThemeData.dark]工厂构造方法、
/// [ColorThemeData.light]工厂构造方法、[copyWith]方法、[lerp]方法
@immutable
class ColorThemeData extends ThemeExtension<ColorThemeData> {
  const ColorThemeData({
    required this.auxiliaries,
    this.red = const MaterialAccentColor(0xFFFB2649, {
      100: Color(0xFFFFEBEA),
      200: Color(0xFFEF9A9A),
      400: Color(0xFFFF395E),
      700: Color(0xFFE91A3C),
    }),
    this.orange = const MaterialAccentColor(0xFFFF8D00, {
      100: Color(0xFFFFFAF5),
      200: Color(0xFFFFCC80),
      400: Color(0xFFFDA61D),
      700: Color(0xFFEC8A11),
    }),
    this.green = const MaterialAccentColor(0xFF07B98D, {
      100: Color(0xFFE6FAF5),
      200: Color(0xFFA5D6A7),
      400: Color(0xFF1FD6A9),
      700: Color(0xFF10A782),
    }),
    this.blue = const MaterialAccentColor(0xFF145AEE, {
      100: Color(0xFFE8F0FF),
      200: Color(0xFF90CAF9),
      400: Color(0xFF3777FF),
      700: Color(0xFF044CE4),
    }),
    this.lightBlue = const MaterialAccentColor(0xFF007EFF, {
      100: Color(0xFFEAF4FF),
      200: Color(0xFF90CAF9),
      400: Color(0xFF219EFF),
      700: Color(0xFF0475E9),
    }),
    this.grey = const MaterialAccentColor(0xFF9E9E9E, {
      100: Color(0xFFF5F5F5),
      200: Color(0xFFEEEEEE),
      400: Color(0xFFBDBDBD),
      700: Color(0xFF616161),
    }),
    List<MaterialAccentColor>? secondaries,
  })  : assert(secondaries == null || secondaries.length > 0),
        _secondaries = secondaries,
        assert(auxiliaries.length > 0);

  factory ColorThemeData.dark() {
    const List<MaterialAccentColor> auxiliaries = [
      MaterialAccentColor(0xFFfc97af, {}),
      MaterialAccentColor(0xFF87f7cf, {}),
      MaterialAccentColor(0xFFf7f494, {}),
      MaterialAccentColor(0xFF72ccff, {}),
      MaterialAccentColor(0xFFf7c5a0, {}),
      MaterialAccentColor(0xFFd4a4eb, {}),
      MaterialAccentColor(0xFFd2f5a6, {}),
      MaterialAccentColor(0xFF76f2f2, {}),
    ];
    return ColorThemeData(auxiliaries: auxiliaries);
  }

  factory ColorThemeData.light() {
    const List<MaterialAccentColor> auxiliaries = [
      MaterialAccentColor(0xFF2ec7c9, {}),
      MaterialAccentColor(0xFFb6a2de, {}),
      MaterialAccentColor(0xFF5ab1ef, {}),
      MaterialAccentColor(0xFFffb980, {}),
      MaterialAccentColor(0xFFd87a80, {}),
      MaterialAccentColor(0xFF8d98b3, {}),
      MaterialAccentColor(0xFFe5cf0d, {}),
      MaterialAccentColor(0xFF97b552, {}),
      MaterialAccentColor(0xFF95706d, {}),
      MaterialAccentColor(0xFFdc69aa, {}),
      MaterialAccentColor(0xFF07a2a4, {}),
      MaterialAccentColor(0xFF9a7fd1, {}),
      MaterialAccentColor(0xFF588dd5, {}),
      MaterialAccentColor(0xFFf5994e, {}),
      MaterialAccentColor(0xFFc05050, {}),
      MaterialAccentColor(0xFF59678c, {}),
    ];

    return ColorThemeData(auxiliaries: auxiliaries);
  }

  final MaterialAccentColor red;
  final MaterialAccentColor orange;
  final MaterialAccentColor green;
  final MaterialAccentColor blue;
  final MaterialAccentColor lightBlue;
  final MaterialAccentColor grey;

  /// 图表辅助色
  final List<MaterialAccentColor> auxiliaries;

  ///  渐变辅助色
  ///
  /// 一般用于渐变，但也可以用作基础颜色
  final List<MaterialAccentColor>? _secondaries;

  List<MaterialAccentColor> get secondaries =>
      _secondaries ?? [red, orange, green, blue];

  @override
  ThemeExtension<ColorThemeData> copyWith({
    MaterialAccentColor? red,
    MaterialAccentColor? orange,
    MaterialAccentColor? green,
    MaterialAccentColor? blue,
    MaterialAccentColor? lightBlue,
    MaterialAccentColor? grey,
    List<MaterialAccentColor>? auxiliaries,
    List<MaterialAccentColor>? secondaries,
  }) {
    return ColorThemeData(
      auxiliaries: auxiliaries ?? this.auxiliaries,
      red: red ?? this.red,
      orange: orange ?? this.orange,
      green: green ?? this.green,
      blue: blue ?? this.blue,
      lightBlue: lightBlue ?? this.lightBlue,
      grey: grey ?? this.grey,
      secondaries: secondaries ?? this.secondaries,
    );
  }

  @override
  ThemeExtension<ColorThemeData> lerp(
      ThemeExtension<ColorThemeData>? other, double t) {
    if (other is! ColorThemeData) {
      return this;
    }

    return ColorThemeData(
      red: red.lerp(other.red, t),
      orange: red.lerp(other.red, t),
      green: red.lerp(other.red, t),
      blue: blue.lerp(other.blue, t),
      lightBlue: lightBlue.lerp(other.lightBlue, t),
      grey: grey.lerp(other.grey, t),
      auxiliaries: [...other.auxiliaries, ...auxiliaries],
      secondaries: [...other.secondaries, ...secondaries],
    );
  }
}

/// 将颜色主题应用于后代小部件。
///
/// 后代小部件使用 [ColorTheme.of] 获取当前主题的 [ColorThemeData] 对象。
/// 当小部件使用 [ColorTheme.of] 时，如果主题稍后更改，它会自动重建。
///
/// 可以使用 [ThemeData.extension<ColorThemeData>()] 将颜色主题指定为整个 Material
/// 主题的一部分。
class ColorTheme extends InheritedWidget {
  /// 构造一个配置所有后代小部件颜色的主题。
  const ColorTheme({
    required this.data,
    required super.child,
    super.key,
  });

  /// 用于所有后代小部件的颜色。
  final ColorThemeData data;

  /// 从最近的 [ColorTheme] 祖先返回配置 [data]。
  ///
  /// 如果没有祖先，则返回 [ThemeData.extension<ColorThemeData>()]；
  /// 如果它也为null，则返回默认[ColorThemeData]
  static ColorThemeData of(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorTheme? radioTheme =
        context.dependOnInheritedWidgetOfExactType<ColorTheme>();
    return radioTheme?.data ??
        theme.extension<ColorThemeData>() ??
        (theme.colorScheme.brightness == Brightness.light
            ? ColorThemeData.light()
            : ColorThemeData.dark());
  }

  @override
  bool updateShouldNotify(ColorTheme oldWidget) => data != oldWidget.data;
}
