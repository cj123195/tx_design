import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'expansion_panel.dart';

/// 与 [TxExpansionPanelTheme] 一起用于定义后代 [TxExpansionPanel] 小组件的默认属性值。
///
/// 后代小组件使用“TxExpansionPanelTheme.of（context）”获取当前 [TxExpansionPanelThemeData]
/// 对象。可以使用 [TxExpansionPanelThemeData.copyWith] 自定义 [TxExpansionPanelThemeData]
/// 的实例。
///
/// [TxExpansionPanelThemeData] 通常使用 [ThemeData.extensions] 指定为整体
/// [Theme] 的一部分。
///
/// 默认情况下，所有 [TxExpansionPanelThemeData] 属性都为“null”。当主题属性为 null 时，
/// [TxExpansionPanel] 将根据整体 [Theme] 的 textTheme 和 colorScheme 提供自己的默认值。
/// 有关详细信息，请参阅各个 [TxExpansionPanel] 属性。
@immutable
class TxExpansionPanelThemeData
    extends ThemeExtension<TxExpansionPanelThemeData> with Diagnosticable {
  /// 创建一个 [TxExpansionPanelThemeData]。
  const TxExpansionPanelThemeData({
    this.backgroundColor,
    this.collapsedBackgroundColor,
    this.panelPadding,
    this.expandedAlignment,
    this.childrenPadding,
    this.iconColor,
    this.collapsedIconColor,
    this.textColor,
    this.collapsedTextColor,
    this.shape,
    this.collapsedShape,
    this.clipBehavior,
    this.expansionAnimationStyle,
    this.controlAffinity,
    this.childrenDecoration,
  });

  /// 覆盖 [TxExpansionPanel.backgroundColor] 的默认值。
  final Color? backgroundColor;

  /// 覆盖 [TxExpansionPanel.collapsedBackgroundColor] 的默认值。
  final Color? collapsedBackgroundColor;

  /// 覆盖 [TxExpansionPanel.panelPadding] 的默认值。
  final EdgeInsetsGeometry? panelPadding;

  /// 覆盖 [TxExpansionPanel.expandedAlignment] 的默认值。
  final AlignmentGeometry? expandedAlignment;

  /// 覆盖 [TxExpansionPanel.childrenPadding] 的默认值。
  final EdgeInsetsGeometry? childrenPadding;

  /// 覆盖 [TxExpansionPanel.iconColor] 的默认值。
  final Color? iconColor;

  /// 覆盖 [TxExpansionPanel.collapsedIconColor] 的默认值。
  final Color? collapsedIconColor;

  /// 重写 [TxExpansionPanel.textColor] 的默认值。
  final Color? textColor;

  /// 覆盖 [TxExpansionPanel.collapsedTextColor] 的默认值。
  final Color? collapsedTextColor;

  /// 重写 [TxExpansionPanel.shape] 的默认值。
  final ShapeBorder? shape;

  /// 覆盖 [TxExpansionPanel.collapsedShape] 的默认值。
  final ShapeBorder? collapsedShape;

  /// 覆盖 [TxExpansionPanel.clipBehavior] 的默认值。
  final Clip? clipBehavior;

  /// 覆盖 [TxExpansionPanel.expansionAnimationStyle] 的默认值。
  final AnimationStyle? expansionAnimationStyle;

  /// 覆盖 [TxExpansionPanel.controlAffinity] 的默认值。
  final ExpansionPanelControlAffinity? controlAffinity;

  /// 覆盖 [TxExpansionPanel.childrenDecoration] 的默认值。
  final Decoration? childrenDecoration;

  /// 创建此对象的副本，并将给定字段替换为新值。
  @override
  TxExpansionPanelThemeData copyWith({
    Color? backgroundColor,
    Color? collapsedBackgroundColor,
    EdgeInsetsGeometry? panelPadding,
    AlignmentGeometry? expandedAlignment,
    EdgeInsetsGeometry? childrenPadding,
    Color? iconColor,
    Color? collapsedIconColor,
    Color? textColor,
    Color? collapsedTextColor,
    ShapeBorder? shape,
    ShapeBorder? collapsedShape,
    Clip? clipBehavior,
    AnimationStyle? expansionAnimationStyle,
    ExpansionPanelControlAffinity? controlAffinity,
    Decoration? childrenDecoration,
  }) {
    return TxExpansionPanelThemeData(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      collapsedBackgroundColor:
          collapsedBackgroundColor ?? this.collapsedBackgroundColor,
      panelPadding: panelPadding ?? this.panelPadding,
      expandedAlignment: expandedAlignment ?? this.expandedAlignment,
      childrenPadding: childrenPadding ?? this.childrenPadding,
      iconColor: iconColor ?? this.iconColor,
      collapsedIconColor: collapsedIconColor ?? this.collapsedIconColor,
      textColor: textColor ?? this.textColor,
      collapsedTextColor: collapsedTextColor ?? this.collapsedTextColor,
      shape: shape ?? this.shape,
      collapsedShape: collapsedShape ?? this.collapsedShape,
      clipBehavior: clipBehavior ?? this.clipBehavior,
      expansionAnimationStyle:
          expansionAnimationStyle ?? this.expansionAnimationStyle,
      childrenDecoration: childrenDecoration,
      controlAffinity: controlAffinity,
    );
  }

  @override
  int get hashCode {
    return Object.hash(
      backgroundColor,
      collapsedBackgroundColor,
      panelPadding,
      expandedAlignment,
      childrenPadding,
      iconColor,
      collapsedIconColor,
      textColor,
      collapsedTextColor,
      shape,
      collapsedShape,
      clipBehavior,
      expansionAnimationStyle,
      controlAffinity,
      childrenDecoration,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is TxExpansionPanelThemeData &&
        other.backgroundColor == backgroundColor &&
        other.collapsedBackgroundColor == collapsedBackgroundColor &&
        other.panelPadding == panelPadding &&
        other.expandedAlignment == expandedAlignment &&
        other.childrenPadding == childrenPadding &&
        other.iconColor == iconColor &&
        other.collapsedIconColor == collapsedIconColor &&
        other.textColor == textColor &&
        other.collapsedTextColor == collapsedTextColor &&
        other.shape == shape &&
        other.collapsedShape == collapsedShape &&
        other.clipBehavior == clipBehavior &&
        other.expansionAnimationStyle == expansionAnimationStyle &&
        other.controlAffinity == controlAffinity &&
        other.childrenDecoration == childrenDecoration;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        ColorProperty('backgroundColor', backgroundColor, defaultValue: null));
    properties.add(ColorProperty(
        'collapsedBackgroundColor', collapsedBackgroundColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>(
        'panelPadding', panelPadding,
        defaultValue: null));
    properties.add(DiagnosticsProperty<AlignmentGeometry>(
        'expandedAlignment', expandedAlignment,
        defaultValue: null));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>(
        'childrenPadding', childrenPadding,
        defaultValue: null));
    properties.add(ColorProperty('iconColor', iconColor, defaultValue: null));
    properties.add(ColorProperty('collapsedIconColor', collapsedIconColor,
        defaultValue: null));
    properties.add(ColorProperty('textColor', textColor, defaultValue: null));
    properties.add(ColorProperty('collapsedTextColor', collapsedTextColor,
        defaultValue: null));
    properties.add(
        DiagnosticsProperty<ShapeBorder>('shape', shape, defaultValue: null));
    properties.add(DiagnosticsProperty<ShapeBorder>(
        'collapsedShape', collapsedShape,
        defaultValue: null));
    properties.add(DiagnosticsProperty<Clip>('clipBehavior', clipBehavior,
        defaultValue: null));
    properties.add(DiagnosticsProperty<AnimationStyle>(
        'expansionAnimationStyle', expansionAnimationStyle,
        defaultValue: null));
    properties.add(DiagnosticsProperty<ExpansionPanelControlAffinity>(
        'controlAffinity', controlAffinity,
        defaultValue: null));
    properties.add(DiagnosticsProperty<Decoration>(
        'childrenDecoration', childrenDecoration,
        defaultValue: null));
  }

  @override
  ThemeExtension<TxExpansionPanelThemeData> lerp(
      covariant ThemeExtension<TxExpansionPanelThemeData>? other, double t) {
    if (other is! TxExpansionPanelThemeData) {
      return this;
    }

    return TxExpansionPanelThemeData(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      collapsedBackgroundColor: Color.lerp(
          collapsedBackgroundColor, other.collapsedBackgroundColor, t),
      panelPadding:
          EdgeInsetsGeometry.lerp(panelPadding, other.panelPadding, t),
      expandedAlignment:
          AlignmentGeometry.lerp(expandedAlignment, other.expandedAlignment, t),
      childrenPadding:
          EdgeInsetsGeometry.lerp(childrenPadding, other.childrenPadding, t),
      iconColor: Color.lerp(iconColor, other.iconColor, t),
      collapsedIconColor:
          Color.lerp(collapsedIconColor, other.collapsedIconColor, t),
      textColor: Color.lerp(textColor, other.textColor, t),
      collapsedTextColor:
          Color.lerp(collapsedTextColor, other.collapsedTextColor, t),
      shape: ShapeBorder.lerp(shape, other.shape, t),
      collapsedShape: ShapeBorder.lerp(collapsedShape, other.collapsedShape, t),
      clipBehavior: t < 0.5 ? clipBehavior : other.clipBehavior,
      expansionAnimationStyle:
          t < 0.5 ? expansionAnimationStyle : other.expansionAnimationStyle,
      controlAffinity: t < 0.5 ? controlAffinity : other.controlAffinity,
      childrenDecoration:
          Decoration.lerp(childrenDecoration, other.childrenDecoration, t),
    );
  }
}

/// 重写其 [TxExpansionPanel] 后代的默认 [TxExpansionPanelTheme]。
class TxExpansionPanelTheme extends InheritedTheme {
  /// 将给定的主题 [data] 应用于 [child]。
  const TxExpansionPanelTheme({
    required this.data,
    required super.child,
    super.key,
  });

  /// 指定后代 [TxExpansionPanel] 小组件的颜色、对齐方式和文本样式值。
  final TxExpansionPanelThemeData data;

  /// 包含给定上下文的此类的最接近实例。
  ///
  /// 如果没有封闭的 [TxExpansionPanelTheme] 小部件，则使用 [ThemeData.expansionTileTheme]。
  ///
  /// 典型用法如下：
  ///
  /// ```dart
  /// TxExpansionPanelThemeData theme = TxExpansionPanelTheme.of(context);
  /// ```
  static TxExpansionPanelThemeData of(BuildContext context) {
    final TxExpansionPanelTheme? inheritedTheme =
        context.dependOnInheritedWidgetOfExactType<TxExpansionPanelTheme>();
    return inheritedTheme?.data ??
        Theme.of(context).extension<TxExpansionPanelThemeData>() ??
        const TxExpansionPanelThemeData();
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return TxExpansionPanelTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(TxExpansionPanelTheme oldWidget) =>
      data != oldWidget.data;
}
