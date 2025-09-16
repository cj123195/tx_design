import 'package:flutter/material.dart';

import 'tag.dart';

/// 与 [TxTagTheme] 一起使用来定义后代 [TxTag] 小部件的默认属性值。
///
/// 有关详细信息，请参阅各个 [TxTag] 属性。
class TxTagThemeData extends ThemeExtension<TxTagThemeData> {
  const TxTagThemeData({
    this.shape,
    this.backgroundColor,
    this.foregroundColor,
    this.textStyle,
    this.padding,
  });

  /// 覆盖 [TxTag.shape] 的默认值。
  final ShapeBorder? shape;

  /// 覆盖 [TxTag.backgroundColor] 的默认值。
  final Color? backgroundColor;

  /// 覆盖 [TxTag.foregroundColor] 的默认值。
  final Color? foregroundColor;

  /// 覆盖 [TxTag.textStyle] 的默认值。
  final TextStyle? textStyle;

  /// 覆盖 [TxTag.padding] 的默认值。
  final EdgeInsetsGeometry? padding;

  @override
  ThemeExtension<TxTagThemeData> copyWith({
    ShapeBorder? shape,
    Color? backgroundColor,
    Color? foregroundColor,
    TextStyle? textStyle,
    EdgeInsetsGeometry? padding,
  }) {
    return TxTagThemeData(
      shape: shape ?? this.shape,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      textStyle: textStyle,
      padding: padding,
    );
  }

  @override
  ThemeExtension<TxTagThemeData> lerp(
    covariant ThemeExtension<TxTagThemeData>? other,
    double t,
  ) {
    if (other is! TxTagThemeData) {
      return this;
    }

    return TxTagThemeData(
      shape: ShapeBorder.lerp(shape, other.shape, t),
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      foregroundColor: Color.lerp(foregroundColor, other.foregroundColor, t),
      textStyle: TextStyle.lerp(textStyle, other.textStyle, t),
      padding: EdgeInsetsGeometry.lerp(padding, other.padding, t),
    );
  }
}

/// 一个继承的小部件，它在此小部件的子树中定义 [TxTag] 的颜色和样式参数。
///
/// 此处指定的值用于未指定显式非空值的 [TxTag] 属性。
class TxTagTheme extends InheritedWidget {
  /// 创建一个操作按钮栏主题，该主题定义后代 [TxTag] 的颜色和样式参数。
  const TxTagTheme({
    required super.child,
    required this.data,
    super.key,
  });

  final TxTagThemeData data;

  /// 包含给定上下文的此类的最近实例的 [data] 属性。
  ///
  /// 如果没有祖先，则返回 [ThemeData.extension<TxTagThemeData>()]。
  /// 如果它也为null，则返回默认[TxTagThemeData]
  static TxTagThemeData of(BuildContext context) {
    final TxTagTheme? badgeTheme =
        context.dependOnInheritedWidgetOfExactType<TxTagTheme>();
    return badgeTheme?.data ??
        Theme.of(context).extension<TxTagThemeData>() ??
        const TxTagThemeData();
  }

  @override
  bool updateShouldNotify(TxTagTheme oldWidget) => data != oldWidget.data;
}
