import 'dart:ui';

import 'package:flutter/material.dart';

import 'tile.dart';

/// 与 [TxTileTheme] 一起使用来定义后代 [TxTile] 小部件的默认属性值。
///
/// 有关详细信息，请参阅各个 [TxTile] 属性。
@immutable
class TxTileThemeData extends ThemeExtension<TxTileThemeData> {
  const TxTileThemeData({
    this.labelStyle,
    this.labelTextAlign,
    this.labelOverflow,
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
    this.colon,
    this.focusColor,
  });

  /// 覆盖 [TxTile.tileColor] 的默认值。
  final Color? tileColor;

  /// 覆盖 [TxTile.labelStyle] 的默认值。
  final TextStyle? labelStyle;

  /// 覆盖 [TxTile.labelTextAlign] 的默认值。
  final TextAlign? labelTextAlign;

  /// 覆盖 [TxTile.labelOverflow] 的默认值。
  final TextOverflow? labelOverflow;

  /// 覆盖 [TxTile.padding] 的默认值。
  final EdgeInsetsGeometry? padding;

  /// 覆盖 [TxTile.layoutDirection] 的默认值。
  final Axis? layoutDirection;

  /// 覆盖 [TxTile.horizontalGap] 的默认值。
  final double? horizontalGap;

  /// 覆盖 [TxTile.dense] 的默认值。
  final bool? dense;

  /// 覆盖 [TxTile.shape] 的默认值。
  final ShapeBorder? shape;

  /// 覆盖 [TxTile.iconColor] 的默认值。
  final Color? iconColor;

  /// 覆盖 [TxTile.textColor] 的默认值。
  final Color? textColor;

  /// 覆盖 [TxTile.leadingAndTrailingTextStyle] 的默认值。
  final TextStyle? leadingAndTrailingTextStyle;

  /// 覆盖 [TxTile.minLeadingWidth] 的默认值。
  final double? minLeadingWidth;

  /// 覆盖 [TxTile.minVerticalPadding] 的默认值。
  final double? minVerticalPadding;

  /// 覆盖 [TxTile.visualDensity] 的默认值。
  final VisualDensity? visualDensity;

  /// 覆盖 [TxTile.minLabelWidth] 的默认值。
  final double? minLabelWidth;

  /// 覆盖 [TxTile.colon] 的默认值。
  final bool? colon;

  /// 覆盖 [TxTile.focusColor] 的默认值。
  final Color? focusColor;

  @override
  ThemeExtension<TxTileThemeData> copyWith({
    Color? tileColor,
    TextStyle? labelStyle,
    TextAlign? labelTextAlign,
    TextOverflow? labelOverflow,
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
    bool? colon,
    Color? focusColor,
  }) {
    return TxTileThemeData(
      tileColor: tileColor ?? this.tileColor,
      labelStyle: labelStyle ?? this.labelStyle,
      labelTextAlign: labelTextAlign ?? this.labelTextAlign,
      labelOverflow: labelOverflow ?? this.labelOverflow,
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
      minVerticalPadding: minVerticalPadding ?? this.minVerticalPadding,
      visualDensity: visualDensity ?? this.visualDensity,
      minLabelWidth: minLabelWidth ?? this.minLabelWidth,
      colon: colon ?? this.colon,
      focusColor: focusColor ?? this.focusColor,
    );
  }

  @override
  ThemeExtension<TxTileThemeData> lerp(
    ThemeExtension<TxTileThemeData>? other,
    double t,
  ) {
    if (other is! TxTileThemeData) {
      return this;
    }

    return TxTileThemeData(
      tileColor: Color.lerp(tileColor, other.tileColor, t),
      labelStyle: TextStyle.lerp(labelStyle, other.labelStyle, t),
      labelTextAlign: t < 0.5 ? labelTextAlign : other.labelTextAlign,
      labelOverflow: t < 0.5 ? labelOverflow : other.labelOverflow,
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
      colon: t < 0.5 ? colon : other.colon,
      focusColor: Color.lerp(focusColor, other.focusColor, t),
    );
  }

  @override
  int get hashCode => Object.hash(
        dense,
        shape,
        tileColor,
        labelStyle,
        labelTextAlign,
        labelOverflow,
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
        colon,
        focusColor,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is TxTileThemeData &&
        other.dense == dense &&
        other.shape == shape &&
        other.tileColor == tileColor &&
        other.labelStyle == labelStyle &&
        other.labelTextAlign == labelTextAlign &&
        other.labelOverflow == labelOverflow &&
        other.iconColor == iconColor &&
        other.padding == padding &&
        other.layoutDirection == layoutDirection &&
        other.leadingAndTrailingTextStyle == leadingAndTrailingTextStyle &&
        other.textColor == textColor &&
        other.horizontalGap == horizontalGap &&
        other.minLeadingWidth == minLeadingWidth &&
        other.minLabelWidth == minLabelWidth &&
        other.minVerticalPadding == minVerticalPadding &&
        other.visualDensity == visualDensity &&
        other.colon == colon &&
        other.focusColor == focusColor;
  }
}

/// 一个继承的小部件，它在此小部件的子树中定义 [TxTile] 的颜色和样式参数。
///
/// 此处指定的值用于未指定显式非空值的 [TxTile] 属性。
class TxTileTheme extends InheritedWidget {
  /// 创建一个日期选择按钮主题，该主题定义后代 [TxTile] 的颜色和样式参数。
  const TxTileTheme({
    required this.data,
    required super.child,
    super.key,
  });

  final TxTileThemeData data;

  /// 包含给定上下文的此类的最近实例的 [data] 属性。
  ///
  /// 如果没有祖先，则返回 [ThemeData.extension<TxTileThemeData>()]。
  /// 如果它也为null，则返回默认[TxTileThemeData]
  static TxTileThemeData of(BuildContext context) {
    final TxTileTheme? txDatePickerButtonTheme =
        context.dependOnInheritedWidgetOfExactType<TxTileTheme>();
    return txDatePickerButtonTheme?.data ??
        Theme.of(context).extension<TxTileThemeData>() ??
        const TxTileThemeData();
  }

  @override
  bool updateShouldNotify(TxTileTheme oldWidget) => data != oldWidget.data;
}
