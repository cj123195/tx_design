import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'tip.dart';

/// 定义后代 [TxTip] 小部件的默认属性值。
///
/// 后代小部件使用 `TxTipTheme.of(context)` 获取当前的 [TxTipThemeData] 对象。
/// [TxTipThemeData] 的实例可以使用 [TxTipThemeData.copyWith] 进行自定义。
///
/// 默认情况下，所有 [TxTipThemeData] 属性均为“null”。 如果为 null，[TxTip] 将使用
/// 来自 [ThemeData] 的值（如果它们存在），否则它将根据整体 [Theme] 的 colorScheme
/// 提供自己的默认值。 有关详细信息，请参阅各个 [TxTip] 属性。
@immutable
class TxTipThemeData extends ThemeExtension<TxTipThemeData>
    with Diagnosticable {
  /// 创建可用于 [ThemeData.extension<TxTipThemeData>()] 的主题。
  const TxTipThemeData({
    this.textStyle,
    this.backgroundColor,
    this.foregroundColor,
    this.padding,
    this.borderRadius,
    this.visualDensity,
  });

  final TextStyle? textStyle;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final VisualDensity? visualDensity;

  /// 创建此对象的副本，但将给定字段替换为新值。
  @override
  TxTipThemeData copyWith({
    TextStyle? textStyle,
    Color? backgroundColor,
    Color? foregroundColor,
    EdgeInsetsGeometry? padding,
    BorderRadius? borderRadius,
    VisualDensity? visualDensity,
  }) {
    return TxTipThemeData(
      textStyle: textStyle ?? this.textStyle,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      padding: padding ?? this.padding,
      borderRadius: borderRadius ?? this.borderRadius,
      visualDensity: visualDensity ?? this.visualDensity,
    );
  }

  @override
  int get hashCode => Object.hash(
        textStyle,
        backgroundColor,
        foregroundColor,
        padding,
        borderRadius,
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
    return other is TxTipThemeData &&
        other.textStyle == textStyle &&
        other.backgroundColor == backgroundColor &&
        other.foregroundColor == foregroundColor &&
        other.padding == padding &&
        other.borderRadius == borderRadius &&
        other.visualDensity == visualDensity;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TextStyle>('textStyle', textStyle,
        defaultValue: null));
    properties.add(DiagnosticsProperty<Color>('background', backgroundColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<Color>('foreground', foregroundColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('padding', padding,
        defaultValue: null));
    properties.add(DiagnosticsProperty<BorderRadius>(
        'borderRadius', borderRadius,
        defaultValue: null));
    properties.add(DiagnosticsProperty<VisualDensity>(
        'visualDensity', visualDensity,
        defaultValue: null));
  }

  @override
  ThemeExtension<TxTipThemeData> lerp(
      ThemeExtension<TxTipThemeData>? other, double t) {
    if (other is! TxTipThemeData) {
      return this;
    }

    VisualDensity? density;
    if (visualDensity == null) {
      density = other.visualDensity;
    } else if (other.visualDensity == null) {
      density = visualDensity;
    } else {
      density = VisualDensity.lerp(visualDensity!, other.visualDensity!, t);
    }

    return TxTipThemeData(
      textStyle: TextStyle.lerp(textStyle, other.textStyle, t),
      foregroundColor: Color.lerp(foregroundColor, other.foregroundColor, t),
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      padding: EdgeInsetsGeometry.lerp(padding, other.padding, t),
      borderRadius: BorderRadius.lerp(borderRadius, other.borderRadius, t),
      visualDensity: density,
    );
  }
}

/// 将单选框主题应用于后代 [TxTip] 小部件。
///
/// 后代小部件使用 [TxTipTheme.of] 获取当前主题的 [TxTipTheme] 对象。
/// 当小部件使用 [TxTipTheme.of] 时，如果主题稍后更改，它会自动重建。
///
/// 可以使用 [ThemeData.extension<TxTipTheme>()!] 将单选框主题指定为整个 Material
/// 主题的一部分。
class TxTipTheme extends InheritedWidget {
  /// 构造一个配置所有后代 [TxTip] 小部件的提示主题。
  const TxTipTheme({
    required this.data,
    required super.child,
    super.key,
  });

  /// 用于所有后代 [TxTip] 小部件的属性。
  final TxTipThemeData data;

  /// 从最近的 [TxTipTheme] 祖先返回配置 [data]。
  ///
  /// 如果没有祖先，则返回 [ThemeData.extension<TxTipThemeData>()]；
  /// 如果它也为null，则返回默认[TxTipThemeData]
  static TxTipThemeData of(BuildContext context) {
    final TxTipTheme? radioTheme =
        context.dependOnInheritedWidgetOfExactType<TxTipTheme>();
    return radioTheme?.data ??
        Theme.of(context).extension<TxTipThemeData>() ??
        const TxTipThemeData();
  }

  @override
  bool updateShouldNotify(TxTipTheme oldWidget) => data != oldWidget.data;
}
