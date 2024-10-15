import 'dart:ui';

import 'package:flutter/material.dart';

import 'field_tile.dart';

/// 与 [TxFieldTileTheme] 一起使用来定义后代 [TxFieldTile] 小部件的默认属性值。
///
/// 有关详细信息，请参阅各个 [TxFieldTile] 属性。
@immutable
class TxFieldTileThemeData extends ThemeExtension<TxFieldTileThemeData> {
  const TxFieldTileThemeData({
    this.labelStyle,
    this.padding,
    this.horizontalGap,
    this.tileColor,
    this.layoutDirection,
    this.dense,
    this.shape,
    this.iconColor,
    this.textColor,
    this.leadingAndTrailingTextStyle,
    this.minLeadingWidth,
    this.visualDensity,
    this.minLabelWidth,
    this.minVerticalPadding,
  });

  /// 覆盖 [TxFieldTile.tileColor] 的默认值。
  final Color? tileColor;

  /// 覆盖 [TxFieldTile.labelStyle] 的默认值。
  final TextStyle? labelStyle;

  /// 覆盖 [TxFieldTile.padding] 的默认值。
  final EdgeInsetsGeometry? padding;

  /// 覆盖 [TxFieldTile.layoutDirection] 的默认值。
  final Axis? layoutDirection;

  /// 覆盖 [TxFieldTile.horizontalGap] 的默认值。
  final double? horizontalGap;

  /// 覆盖 [TxFieldTile.dense] 的默认值。
  final bool? dense;

  /// 覆盖 [TxFieldTile.shape] 的默认值。
  final ShapeBorder? shape;

  /// 覆盖 [TxFieldTile.iconColor] 的默认值。
  final Color? iconColor;

  /// 覆盖 [TxFieldTile.textColor] 的默认值。
  final Color? textColor;

  /// 覆盖 [TxFieldTile.leadingAndTrailingTextStyle] 的默认值。
  final TextStyle? leadingAndTrailingTextStyle;

  /// 覆盖 [TxFieldTile.minLeadingWidth] 的默认值。
  final double? minLeadingWidth;

  /// 覆盖 [TxFieldTile.visualDensity] 的默认值。
  final VisualDensity? visualDensity;

  /// 覆盖 [TxFieldTile.minLabelWidth] 的默认值。
  final double? minLabelWidth;

  /// 覆盖 [TxFieldTile.minVerticalPadding] 的默认值。
  final double? minVerticalPadding;

  @override
  ThemeExtension<TxFieldTileThemeData> copyWith({
    Color? tileColor,
    TextStyle? labelStyle,
    EdgeInsetsGeometry? padding,
    Axis? layoutDirection,
    double? horizontalGap,
    bool? dense,
    ShapeBorder? shape,
    Color? iconColor,
    Color? textColor,
    TextStyle? leadingAndTrailingTextStyle,
    double? minLeadingWidth,
    double? minLabelWidth,
    double? minVerticalPadding,
    VisualDensity? visualDensity,
  }) {
    return TxFieldTileThemeData(
      tileColor: tileColor ?? this.tileColor,
      labelStyle: labelStyle ?? this.labelStyle,
      padding: padding ?? this.padding,
      layoutDirection: layoutDirection ?? this.layoutDirection,
      horizontalGap: horizontalGap ?? this.horizontalGap,
      dense: dense ?? this.dense,
      shape: shape ?? this.shape,
      iconColor: iconColor ?? this.iconColor,
      textColor: textColor ?? this.textColor,
      leadingAndTrailingTextStyle:
          leadingAndTrailingTextStyle ?? this.leadingAndTrailingTextStyle,
      minLeadingWidth: minLeadingWidth ?? this.minLeadingWidth,
      visualDensity: visualDensity ?? this.visualDensity,
      minLabelWidth: minLabelWidth ?? this.minLabelWidth,
      minVerticalPadding: minVerticalPadding ?? this.minVerticalPadding,
    );
  }

  @override
  ThemeExtension<TxFieldTileThemeData> lerp(
    ThemeExtension<TxFieldTileThemeData>? other,
    double t,
  ) {
    if (other is! TxFieldTileThemeData) {
      return this;
    }

    return TxFieldTileThemeData(
      tileColor: Color.lerp(tileColor, other.tileColor, t),
      labelStyle: TextStyle.lerp(labelStyle, other.labelStyle, t),
      padding: EdgeInsetsGeometry.lerp(padding, other.padding, t),
      layoutDirection: t < 0.5 ? layoutDirection : other.layoutDirection,
      horizontalGap: lerpDouble(horizontalGap, other.horizontalGap, t),
      dense: t < 0.5 ? dense : other.dense,
      shape: ShapeBorder.lerp(shape, other.shape, t),
      iconColor: Color.lerp(iconColor, other.iconColor, t),
      textColor: Color.lerp(textColor, other.textColor, t),
      leadingAndTrailingTextStyle: TextStyle.lerp(
        leadingAndTrailingTextStyle,
        other.leadingAndTrailingTextStyle,
        t,
      ),
      minLeadingWidth: lerpDouble(minLeadingWidth, other.minLeadingWidth, t),
      minLabelWidth: lerpDouble(minLabelWidth, other.minLabelWidth, t),
      minVerticalPadding:
          lerpDouble(minVerticalPadding, other.minVerticalPadding, t),
      visualDensity: t < 0.5 ? visualDensity : other.visualDensity,
    );
  }

  @override
  int get hashCode => Object.hash(
        dense,
        shape,
        tileColor,
        labelStyle,
        iconColor,
        textColor,
        padding,
        layoutDirection,
        leadingAndTrailingTextStyle,
        horizontalGap,
        minLeadingWidth,
        minLabelWidth,
        minVerticalPadding,
        visualDensity,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is TxFieldTileThemeData &&
        other.dense == dense &&
        other.shape == shape &&
        other.tileColor == tileColor &&
        other.labelStyle == labelStyle &&
        other.iconColor == iconColor &&
        other.padding == padding &&
        other.layoutDirection == layoutDirection &&
        other.leadingAndTrailingTextStyle == leadingAndTrailingTextStyle &&
        other.textColor == textColor &&
        other.horizontalGap == horizontalGap &&
        other.minLeadingWidth == minLeadingWidth &&
        other.minLabelWidth == minLabelWidth &&
        other.minVerticalPadding == minVerticalPadding &&
        other.visualDensity == visualDensity;
  }
}

/// 一个继承的小部件，它在此小部件的子树中定义 [TxFieldTile] 的颜色和样式参数。
///
/// 此处指定的值用于未指定显式非空值的 [TxFieldTile] 属性。
class TxFieldTileTheme extends InheritedWidget {
  /// 创建一个日期选择按钮主题，该主题定义后代 [TxFieldTile] 的颜色和样式参数。
  const TxFieldTileTheme({
    required super.child,
    required this.data,
    super.key,
  });

  final TxFieldTileThemeData data;

  /// 包含给定上下文的此类的最近实例的 [data] 属性。
  ///
  /// 如果没有祖先，则返回 [ThemeData.extension<TxFieldTileThemeData>()]。
  /// 如果它也为null，则返回默认[TxFieldTileThemeData]
  static TxFieldTileThemeData of(BuildContext context) {
    final TxFieldTileTheme? txDatePickerButtonTheme =
        context.dependOnInheritedWidgetOfExactType<TxFieldTileTheme>();
    return txDatePickerButtonTheme?.data ??
        Theme.of(context).extension<TxFieldTileThemeData>() ??
        const TxFieldTileThemeData();
  }

  @override
  bool updateShouldNotify(TxFieldTileTheme oldWidget) => data != oldWidget.data;
}
