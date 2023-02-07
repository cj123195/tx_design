import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'signature.dart';

/// 定义后代 [TxSignature] 小部件的默认属性值。
///
/// 后代小部件使用 `TxSignatureTheme.of(context)` 获取当前的 [TxSignatureThemeData] 对象。
/// [TxSignatureThemeData] 的实例可以使用 [TxSignatureThemeData.copyWith] 进行自定义。
///
/// 默认情况下，所有 [TxSignatureThemeData] 属性均为“null”。 如果为 null，[TxSignature] 将使用
/// 来自 [ThemeData] 的值（如果它们存在），否则它将根据整体 [Theme] 的 colorScheme
/// 提供自己的默认值。 有关详细信息，请参阅各个 [TxSignature] 属性。
@immutable
class TxSignatureThemeData extends ThemeExtension<TxSignatureThemeData>
    with Diagnosticable {
  /// 创建可用于 [ThemeData.extension<TxSignatureThemeData>()] 的主题。
  const TxSignatureThemeData({
    this.height,
    this.width,
    this.penColor,
    this.exportPenColor,
    this.strokeWidth,
    this.backgroundColor,
    this.exportBackgroundColor,
    this.iconTheme,
  });

  /// 如果指定，则覆盖[TxSignature.height]的默认值。
  final double? height;

  /// 如果指定，则覆盖[TxSignature.width]的默认值。
  final double? width;

  /// 如果指定，则覆盖[TxSignature.penColor]的默认值。
  final Color? penColor;

  /// 如果指定，则覆盖[TxSignature.exportPenColor]的默认值。
  final Color? exportPenColor;

  /// 如果指定，则覆盖[TxSignature.strokeWidth]的默认值。
  final double? strokeWidth;

  /// 如果指定，则覆盖[TxSignature.backgroundColor]的默认值。
  final Color? backgroundColor;

  /// 如果指定，则覆盖[TxSignature.exportBackgroundColor]的默认值。
  final Color? exportBackgroundColor;

  /// 如果指定，则覆盖[TxSignature.iconTheme]的默认值。
  final IconThemeData? iconTheme;

  /// 创建此对象的副本，但将给定字段替换为新值。
  @override
  TxSignatureThemeData copyWith({
    double? height,
    double? width,
    Color? penColor,
    Color? exportPenColor,
    Color? backgroundColor,
    Color? exportBackgroundColor,
    double? strokeWidth,
    IconThemeData? iconTheme,
  }) {
    return TxSignatureThemeData(
      height: height ?? this.height,
      width: width ?? this.width,
      penColor: penColor ?? this.penColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      exportPenColor: exportPenColor ?? this.exportPenColor,
      exportBackgroundColor:
          exportBackgroundColor ?? this.exportBackgroundColor,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      iconTheme: iconTheme ?? this.iconTheme,
    );
  }

  @override
  int get hashCode => Object.hash(
        height,
        width,
        penColor,
        backgroundColor,
        exportPenColor,
        exportBackgroundColor,
        strokeWidth,
        iconTheme,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is TxSignatureThemeData &&
        other.height == height &&
        other.width == width &&
        other.penColor == penColor &&
        other.backgroundColor == backgroundColor &&
        other.exportPenColor == exportPenColor &&
        other.exportBackgroundColor == exportBackgroundColor &&
        other.strokeWidth == strokeWidth &&
        other.iconTheme == iconTheme;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('height', height));
    properties.add(DoubleProperty('width', width));
    properties.add(
        DiagnosticsProperty<Color>('penColor', penColor, defaultValue: null));
    properties.add(DiagnosticsProperty<Color>(
        'backgroundColor', backgroundColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<Color>('exportPenColor', exportPenColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<Color>(
        'exportBackgroundColor', exportBackgroundColor,
        defaultValue: null));
    properties.add(DoubleProperty('strokeWidth', strokeWidth));
    properties.add(DiagnosticsProperty<IconThemeData>('iconTheme', iconTheme,
        defaultValue: null));
  }

  @override
  ThemeExtension<TxSignatureThemeData> lerp(
      ThemeExtension<TxSignatureThemeData>? other, double t) {
    if (other is! TxSignatureThemeData) {
      return this;
    }

    return TxSignatureThemeData(
      height: lerpDouble(height, other.height, t),
      width: lerpDouble(width, other.width, t),
      penColor: Color.lerp(penColor, other.penColor, t),
      exportPenColor: Color.lerp(exportPenColor, other.exportPenColor, t),
      exportBackgroundColor:
          Color.lerp(exportBackgroundColor, other.exportBackgroundColor, t),
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      strokeWidth: lerpDouble(strokeWidth, other.strokeWidth, t),
      iconTheme: IconThemeData.lerp(iconTheme, other.iconTheme, t),
    );
  }
}

/// 将单选框主题应用于后代 [TxSignature] 小部件。
///
/// 后代小部件使用 [TxSignatureTheme.of] 获取当前主题的 [TxSignatureTheme] 对象。
/// 当小部件使用 [TxSignatureTheme.of] 时，如果主题稍后更改，它会自动重建。
///
/// 可以使用 [ThemeData.extension<TxSignatureTheme>()!] 将单选框主题指定为整个 Material
/// 主题的一部分。
class TxSignatureTheme extends InheritedWidget {
  /// 构造一个配置所有后代 [TxSignature] 小部件的画板主题。
  const TxSignatureTheme({
    required this.data,
    required super.child,
    super.key,
  });

  /// 用于所有后代 [TxSignature] 小部件的属性。
  final TxSignatureThemeData data;

  /// 从最近的 [TxSignatureTheme] 祖先返回配置 [data]。
  ///
  /// 如果没有祖先，则返回 [ThemeData.extension<TxSignatureThemeData>()]；
  /// 如果它也为null，则返回默认[TxSignatureThemeData]
  static TxSignatureThemeData of(BuildContext context) {
    final TxSignatureTheme? radioTheme =
        context.dependOnInheritedWidgetOfExactType<TxSignatureTheme>();
    return radioTheme?.data ??
        Theme.of(context).extension<TxSignatureThemeData>() ??
        const TxSignatureThemeData();
  }

  @override
  bool updateShouldNotify(TxSignatureTheme oldWidget) => data != oldWidget.data;
}
