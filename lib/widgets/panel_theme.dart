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
    this.style,
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
    this.leadingControlAffinity,
  });

  final bool? dense;
  final ShapeBorder? shape;
  final PanelStyle? style;
  final Color? selectedColor;
  final Color? iconColor;
  final Color? textColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? panelColor;
  final Color? selectedPanelColor;
  final double? horizontalTitleGap;
  final double? verticalGap;
  final double? minLeadingWidth;
  final bool? enableFeedback;
  final MaterialStateProperty<MouseCursor?>? mouseCursor;
  final VisualDensity? visualDensity;
  final LeadingControlAffinity? leadingControlAffinity;

  @override
  ThemeExtension<TxPanelThemeData> copyWith({
    bool? dense,
    ShapeBorder? shape,
    PanelStyle? style,
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
    LeadingControlAffinity? leadingControlAffinity,
  }) {
    return TxPanelThemeData(
      dense: dense ?? this.dense,
      shape: shape ?? this.shape,
      style: style ?? this.style,
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
      leadingControlAffinity:
          leadingControlAffinity ?? this.leadingControlAffinity,
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
      style: t < 0.5 ? style : other.style,
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
      leadingControlAffinity:
          t < 0.5 ? leadingControlAffinity : other.leadingControlAffinity,
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
