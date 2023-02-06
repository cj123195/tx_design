import 'dart:ui';

import 'package:flutter/material.dart';

import 'cell.dart';

/// 与 [TxCellTheme] 一起使用来定义后代 [TxCell] 小部件的默认属性值。
///
/// 有关详细信息，请参阅各个 [TxCell] 属性。
@immutable
class TxCellThemeData extends ThemeExtension<TxCellThemeData> {
  const TxCellThemeData({
    this.dense,
    this.iconColor,
    this.textColor,
    this.padding,
    this.horizontalGap,
    this.minLeadingWidth,
    this.minLabelWidth,
    this.visualDensity,
    this.labelStyle,
    this.contentStyle,
    this.crossAxisAlignment,
  });

  final bool? dense;
  final Color? iconColor;
  final Color? textColor;
  final EdgeInsetsGeometry? padding;
  final double? horizontalGap;
  final double? minLeadingWidth;
  final double? minLabelWidth;
  final VisualDensity? visualDensity;
  final TextStyle? labelStyle;
  final TextStyle? contentStyle;
  final CrossAxisAlignment? crossAxisAlignment;

  @override
  ThemeExtension<TxCellThemeData> copyWith({
    bool? dense,
    Color? iconColor,
    Color? textColor,
    EdgeInsetsGeometry? padding,
    double? horizontalGap,
    double? minLeadingWidth,
    double? minLabelWidth,
    VisualDensity? visualDensity,
    TextStyle? labelStyle,
    TextStyle? contentStyle,
    CrossAxisAlignment? crossAxisAlignment,
    bool? alignContentWithLabel,
  }) {
    return TxCellThemeData(
      dense: dense ?? this.dense,
      iconColor: iconColor ?? this.iconColor,
      textColor: textColor ?? this.textColor,
      padding: padding ?? this.padding,
      horizontalGap: horizontalGap ?? this.horizontalGap,
      minLeadingWidth: minLeadingWidth ?? this.minLeadingWidth,
      minLabelWidth: minLabelWidth ?? this.minLabelWidth,
      visualDensity: visualDensity ?? this.visualDensity,
      labelStyle: labelStyle ?? this.labelStyle,
      contentStyle: contentStyle ?? this.contentStyle,
      crossAxisAlignment: crossAxisAlignment ?? this.crossAxisAlignment,
    );
  }

  @override
  ThemeExtension<TxCellThemeData> lerp(
      ThemeExtension<TxCellThemeData>? other, double t) {
    if (other is! TxCellThemeData) {
      return this;
    }

    return TxCellThemeData(
      dense: t < 0.5 ? dense : other.dense,
      labelStyle: TextStyle.lerp(labelStyle, other.labelStyle, t),
      contentStyle: TextStyle.lerp(contentStyle, other.contentStyle, t),
      iconColor: Color.lerp(iconColor, other.iconColor, t),
      textColor: Color.lerp(textColor, other.textColor, t),
      padding: EdgeInsetsGeometry.lerp(padding, other.padding, t),
      horizontalGap: lerpDouble(horizontalGap, other.horizontalGap, t),
      minLeadingWidth: lerpDouble(minLeadingWidth, other.minLeadingWidth, t),
      minLabelWidth: lerpDouble(minLabelWidth, other.minLabelWidth, t),
      visualDensity: t < 0.5 ? visualDensity : other.visualDensity,
      crossAxisAlignment:
          t < 0.5 ? crossAxisAlignment : other.crossAxisAlignment,
    );
  }
}

/// 一个继承的小部件，它在此小部件的子树中定义 [TxCell] 的颜色和样式参数。
///
/// 此处指定的值用于未指定显式非空值的 [TxCell] 属性。
class TxCellTheme extends InheritedWidget {
  /// 创建一个栅格主题，该主题定义后代 [TxCell] 的颜色和样式参数。
  const TxCellTheme({
    required super.child,
    required this.data,
    super.key,
  });

  final TxCellThemeData data;

  /// 包含给定上下文的此类的最近实例的 [data] 属性。
  ///
  /// 如果没有祖先，则返回 [ThemeData.extension<TxCellThemeData>()]。
  /// 如果它也为null，则返回默认[TxCellThemeData]
  static TxCellThemeData of(BuildContext context) {
    final TxCellTheme? txCellTheme =
        context.dependOnInheritedWidgetOfExactType<TxCellTheme>();
    return txCellTheme?.data ??
        Theme.of(context).extension<TxCellThemeData>() ??
        const TxCellThemeData();
  }

  @override
  bool updateShouldNotify(TxCellTheme oldWidget) => data != oldWidget.data;
}
