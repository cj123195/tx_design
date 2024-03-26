import 'dart:ui';

import 'package:flutter/material.dart';

import 'panel.dart';

/// 与 [TxPanelTheme] 一起使用来定义后代 [TxPanel] 小部件的默认属性值。
///
/// 有关详细信息，请参阅各个 [TxPanel] 属性。
@immutable
class TxPanelThemeData extends ThemeExtension<TxPanelThemeData> {
  const TxPanelThemeData({
    this.dense,
    this.shape,
    this.selectedColor,
    this.iconColor,
    this.textColor,
    this.padding,
    this.margin,
    this.panelColor,
    this.selectedPanelColor,
    this.horizontalTitleGap,
    this.verticalGap,
    this.minLeadingWidth,
    this.enableFeedback,
    this.mouseCursor,
    this.visualDensity,
    this.contentTextStyle,
    this.titleTextStyle,
    this.subtitleTextStyle,
    this.leadingAndTrailingTextStyle,
    this.titleAlignment,
    this.focusColor,
    this.splashColor,
    this.hoverColor,
    this.highlightColor,
  });

  /// 覆盖 [TxPanel.dense] 的默认值。
  final bool? dense;

  /// 覆盖 [TxPanel.shape] 的默认值。
  final ShapeBorder? shape;

  /// 覆盖 [TxPanel.selectedColor] 的默认值。
  final Color? selectedColor;

  /// 覆盖 [TxPanel.iconColor] 的默认值。
  final Color? iconColor;

  /// 覆盖 [TxPanel.textColor] 的默认值。
  final Color? textColor;

  /// 覆盖 [TxPanel.padding] 的默认值。
  final EdgeInsetsGeometry? padding;

  /// 覆盖 [TxPanel.margin] 的默认值。
  final EdgeInsetsGeometry? margin;

  /// 覆盖 [TxPanel.panelColor] 的默认值。
  final Color? panelColor;

  /// 覆盖 [TxPanel.selectedPanelColor] 的默认值。
  final Color? selectedPanelColor;

  /// 覆盖 [TxPanel.horizontalTitleGap] 的默认值。
  final double? horizontalTitleGap;

  /// 覆盖 [TxPanel.verticalGap] 的默认值。
  final double? verticalGap;

  /// 覆盖 [TxPanel.minLeadingWidth] 的默认值。
  final double? minLeadingWidth;

  /// 覆盖 [TxPanel.enableFeedback] 的默认值。
  final bool? enableFeedback;

  /// 覆盖 [TxPanel.mouseCursor] 的默认值。
  final MaterialStateProperty<MouseCursor?>? mouseCursor;

  /// 覆盖 [TxPanel.visualDensity] 的默认值。
  final VisualDensity? visualDensity;

  /// 重写 [TxPanel.titleTextStyle] 的默认值。
  final TextStyle? titleTextStyle;

  /// 重写 [TxPanel.subtitleTextStyle] 的默认值。
  final TextStyle? subtitleTextStyle;

  /// 覆盖 [TxPanel.contentTextStyle] 的默认值。
  final TextStyle? contentTextStyle;

  /// 覆盖 [TxPanel.leadingAndTrailingTextStyle] 的默认值。
  final TextStyle? leadingAndTrailingTextStyle;

  /// 如果指定，则覆盖 [TxPanel.titleAlignment] 的默认值。
  final ListTileTitleAlignment? titleAlignment;

  /// 覆盖 [TxPanel.focusColor] 的默认值。
  final Color? focusColor;

  /// 覆盖 [TxPanel.splashColor] 的默认值。
  final Color? splashColor;

  /// 覆盖 [TxPanel.hoverColor] 的默认值。
  final Color? hoverColor;

  /// 覆盖 [TxPanel.highlightColor] 的默认值。
  final Color? highlightColor;

  @override
  ThemeExtension<TxPanelThemeData> copyWith({
    bool? dense,
    ShapeBorder? shape,
    Color? selectedColor,
    Color? iconColor,
    Color? textColor,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? panelColor,
    Color? selectedPanelColor,
    double? horizontalTitleGap,
    double? minLeadingWidth,
    double? verticalGap,
    bool? enableFeedback,
    MaterialStateProperty<MouseCursor?>? mouseCursor,
    VisualDensity? visualDensity,
    TextStyle? titleTextStyle,
    TextStyle? subtitleTextStyle,
    TextStyle? leadingAndTrailingTextStyle,
    TextStyle? contentTextStyle,
    ListTileTitleAlignment? titleAlignment,
    Color? focusColor,
    Color? splashColor,
    Color? hoverColor,
    Color? highlightColor,
  }) {
    return TxPanelThemeData(
      dense: dense ?? this.dense,
      shape: shape ?? this.shape,
      selectedColor: selectedColor ?? this.selectedColor,
      iconColor: iconColor ?? this.iconColor,
      textColor: textColor ?? this.textColor,
      padding: padding ?? this.padding,
      margin: margin ?? this.margin,
      panelColor: panelColor ?? this.panelColor,
      selectedPanelColor: selectedPanelColor ?? this.selectedPanelColor,
      horizontalTitleGap: horizontalTitleGap ?? this.horizontalTitleGap,
      verticalGap: verticalGap ?? this.verticalGap,
      minLeadingWidth: minLeadingWidth ?? this.minLeadingWidth,
      enableFeedback: enableFeedback ?? this.enableFeedback,
      mouseCursor: mouseCursor ?? this.mouseCursor,
      visualDensity: visualDensity ?? this.visualDensity,
      titleTextStyle: titleTextStyle ?? this.titleTextStyle,
      subtitleTextStyle: subtitleTextStyle ?? this.subtitleTextStyle,
      leadingAndTrailingTextStyle:
          leadingAndTrailingTextStyle ?? this.leadingAndTrailingTextStyle,
      contentTextStyle: contentTextStyle ?? this.contentTextStyle,
      titleAlignment: titleAlignment ?? this.titleAlignment,
      focusColor: focusColor ?? this.focusColor,
      splashColor: splashColor ?? this.splashColor,
      hoverColor: hoverColor ?? this.hoverColor,
      highlightColor: highlightColor ?? this.highlightColor,
    );
  }

  @override
  ThemeExtension<TxPanelThemeData> lerp(
      ThemeExtension<TxPanelThemeData>? other, double t) {
    if (other is! TxPanelThemeData) {
      return this;
    }

    return TxPanelThemeData(
      dense: t < 0.5 ? dense : other.dense,
      shape: ShapeBorder.lerp(shape, other.shape, t),
      selectedColor: Color.lerp(selectedColor, other.selectedColor, t),
      iconColor: Color.lerp(iconColor, other.iconColor, t),
      textColor: Color.lerp(textColor, other.textColor, t),
      padding: EdgeInsetsGeometry.lerp(padding, other.padding, t),
      margin: EdgeInsetsGeometry.lerp(padding, other.padding, t),
      panelColor: Color.lerp(panelColor, other.panelColor, t),
      selectedPanelColor:
          Color.lerp(selectedPanelColor, other.selectedPanelColor, t),
      horizontalTitleGap:
          lerpDouble(horizontalTitleGap, other.horizontalTitleGap, t),
      verticalGap: lerpDouble(verticalGap, other.verticalGap, t),
      minLeadingWidth: lerpDouble(minLeadingWidth, other.minLeadingWidth, t),
      enableFeedback: t < 0.5 ? enableFeedback : other.enableFeedback,
      mouseCursor: t < 0.5 ? mouseCursor : other.mouseCursor,
      visualDensity: t < 0.5 ? visualDensity : other.visualDensity,
      contentTextStyle:
          TextStyle.lerp(contentTextStyle, other.contentTextStyle, t),
      titleTextStyle: TextStyle.lerp(titleTextStyle, other.titleTextStyle, t),
      subtitleTextStyle:
          TextStyle.lerp(subtitleTextStyle, other.subtitleTextStyle, t),
      leadingAndTrailingTextStyle: TextStyle.lerp(
          leadingAndTrailingTextStyle, other.leadingAndTrailingTextStyle, t),
      titleAlignment: t < 0.5 ? titleAlignment : other.titleAlignment,
      focusColor: Color.lerp(focusColor, other.focusColor, t),
      splashColor: Color.lerp(splashColor, other.splashColor, t),
      hoverColor: Color.lerp(hoverColor, other.hoverColor, t),
      highlightColor: Color.lerp(highlightColor, other.highlightColor, t),
    );
  }
}

/// 一个继承的小部件，它在此小部件的子树中定义 [TxPanel] 的颜色和样式参数。
///
/// 此处指定的值用于未指定显式非空值的 [TxPanel] 属性。
class TxPanelTheme extends InheritedWidget {
  /// 创建一个面板主题，该主题定义后代 [TxPanel] 的颜色和样式参数。
  const TxPanelTheme({
    required super.child,
    required this.data,
    super.key,
  });

  final TxPanelThemeData data;

  /// 包含给定上下文的此类的最近实例的 [data] 属性。
  ///
  /// 如果没有祖先，则返回 [ThemeData.extension<TxPanelThemeData>()]。
  /// 如果它也为null，则返回默认[TxPanelThemeData]
  static TxPanelThemeData of(BuildContext context) {
    final TxPanelTheme? txPanelTheme =
        context.dependOnInheritedWidgetOfExactType<TxPanelTheme>();
    return txPanelTheme?.data ??
        Theme.of(context).extension<TxPanelThemeData>() ??
        const TxPanelThemeData();
  }

  @override
  bool updateShouldNotify(TxPanelTheme oldWidget) => data != oldWidget.data;
}
