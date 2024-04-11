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
    this.padding,
    this.gap,
    this.minLeadingWidth,
    this.minLabelWidth,
    this.visualDensity,
    this.labelTextStyle,
    this.contentTextStyle,
    this.leadingTextStyle,
    this.minVerticalPadding,
    this.contentTextAlign,
  });

  final bool? dense;
  final Color? iconColor;
  final EdgeInsetsGeometry? padding;
  final double? gap;
  final double? minLeadingWidth;
  final double? minLabelWidth;
  final VisualDensity? visualDensity;
  final TextStyle? labelTextStyle;
  final TextStyle? contentTextStyle;
  final TextStyle? leadingTextStyle;
  final double? minVerticalPadding;
  final TextAlign? contentTextAlign;

  @override
  TxCellThemeData copyWith({
    bool? dense,
    Color? iconColor,
    EdgeInsetsGeometry? padding,
    double? gap,
    double? minLeadingWidth,
    double? minLabelWidth,
    VisualDensity? visualDensity,
    TextStyle? labelTextStyle,
    TextStyle? contentTextStyle,
    double? minVerticalPadding,
    TextStyle? leadingTextStyle,
    TextAlign? contentTextAlign,
    int? contentMaxLines,
  }) {
    return TxCellThemeData(
      dense: dense ?? this.dense,
      iconColor: iconColor ?? this.iconColor,
      minVerticalPadding: minVerticalPadding ?? this.minVerticalPadding,
      padding: padding ?? this.padding,
      gap: gap ?? this.gap,
      minLeadingWidth: minLeadingWidth ?? this.minLeadingWidth,
      minLabelWidth: minLabelWidth ?? this.minLabelWidth,
      visualDensity: visualDensity ?? this.visualDensity,
      labelTextStyle: labelTextStyle ?? this.labelTextStyle,
      contentTextStyle: contentTextStyle ?? this.contentTextStyle,
      contentTextAlign: contentTextAlign ?? this.contentTextAlign,
      leadingTextStyle: leadingTextStyle ?? this.leadingTextStyle,
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
      labelTextStyle: TextStyle.lerp(labelTextStyle, other.labelTextStyle, t),
      contentTextStyle:
          TextStyle.lerp(contentTextStyle, other.contentTextStyle, t),
      iconColor: Color.lerp(iconColor, other.iconColor, t),
      contentTextAlign: t < 0.5 ? contentTextAlign : other.contentTextAlign,
      padding: EdgeInsetsGeometry.lerp(padding, other.padding, t),
      gap: lerpDouble(gap, other.gap, t),
      minLeadingWidth: lerpDouble(minLeadingWidth, other.minLeadingWidth, t),
      minLabelWidth: lerpDouble(minLabelWidth, other.minLabelWidth, t),
      visualDensity: t < 0.5 ? visualDensity : other.visualDensity,
      minVerticalPadding:
          lerpDouble(minVerticalPadding, other.minVerticalPadding, t),
      leadingTextStyle:
          TextStyle.lerp(leadingTextStyle, other.leadingTextStyle, t),
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
