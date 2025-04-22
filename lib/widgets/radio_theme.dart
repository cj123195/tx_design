import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'radio.dart';

/// 定义后代 [TxRadio] 小部件的默认属性值。
///
/// 后代小部件使用 `TxRadioTheme.of(context)` 获取当前的 [TxRadioThemeData] 对象。
/// [TxRadioThemeData] 的实例可以使用 [TxRadioThemeData.copyWith] 进行自定义。
///
/// 默认情况下，所有 [TxRadioThemeData] 属性均为“null”。 如果为 null，[TxRadio] 将使用
/// 来自 [ThemeData] 的值（如果它们存在），否则它将根据整体 [Theme] 的 colorScheme
/// 提供自己的默认值。 有关详细信息，请参阅各个 [TxRadio] 属性。
@immutable
class TxRadioThemeData extends ThemeExtension<TxRadioThemeData>
    with Diagnosticable {
  /// 创建可用于 [ThemeData.extension<TxRadioThemeData>()] 的主题。
  const TxRadioThemeData({
    this.mouseCursor,
    this.fillColor,
    this.overlayColor,
    this.splashRadius,
    this.materialTapTargetSize,
    this.visualDensity,
    this.shape,
    this.side,
  });

  /// {@macro flutter.material.checkbox.mouseCursor}
  ///
  /// 如果指定，则覆盖 [TxRadio.mouseCursor] 的默认值。
  final WidgetStateProperty<MouseCursor?>? mouseCursor;

  /// {@macro flutter.material.checkbox.fillColor}
  ///
  /// 如果指定，则覆盖 [TxRadio.fillColor] 的默认值。
  final WidgetStateProperty<Color?>? fillColor;

  /// {@macro flutter.material.checkbox.overlayColor}
  ///
  /// 如果指定，则覆盖 [TxRadio.overlayColor] 的默认值。
  final WidgetStateProperty<Color?>? overlayColor;

  /// {@macro flutter.material.checkbox.splashRadius}
  ///
  /// 如果指定，将覆盖 [TxRadio.splashRadius] 的默认值。
  final double? splashRadius;

  /// {@macro flutter.material.checkbox.materialTapTargetSize}
  ///
  /// 如果指定，将覆盖 [TxRadio.materialTapTargetSize] 的默认值。
  final MaterialTapTargetSize? materialTapTargetSize;

  /// {@macro flutter.material.checkbox.visualDensity}
  ///
  /// 如果指定，则覆盖 [TxRadio.visualDensity] 的默认值。
  final VisualDensity? visualDensity;

  /// {@macro flutter.material.checkbox.shape}
  ///
  /// 如果指定，则覆盖 [TxRadio.shape] 的默认值。
  final OutlinedBorder? shape;

  /// {@macro flutter.material.checkbox.side}
  ///
  /// 如果指定，则覆盖 [TxRadio.side] 的默认值。
  final BorderSide? side;

  /// 创建此对象的副本，但将给定字段替换为新值。
  @override
  TxRadioThemeData copyWith({
    WidgetStateProperty<MouseCursor?>? mouseCursor,
    WidgetStateProperty<Color?>? fillColor,
    WidgetStateProperty<Color?>? checkColor,
    WidgetStateProperty<Color?>? overlayColor,
    double? splashRadius,
    MaterialTapTargetSize? materialTapTargetSize,
    VisualDensity? visualDensity,
    OutlinedBorder? shape,
    BorderSide? side,
  }) {
    return TxRadioThemeData(
      mouseCursor: mouseCursor ?? this.mouseCursor,
      fillColor: fillColor ?? this.fillColor,
      overlayColor: overlayColor ?? this.overlayColor,
      splashRadius: splashRadius ?? this.splashRadius,
      materialTapTargetSize:
          materialTapTargetSize ?? this.materialTapTargetSize,
      visualDensity: visualDensity ?? this.visualDensity,
      shape: shape ?? this.shape,
      side: side ?? this.side,
    );
  }

  @override
  int get hashCode => Object.hash(
        mouseCursor,
        fillColor,
        overlayColor,
        splashRadius,
        materialTapTargetSize,
        visualDensity,
        shape,
        side,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is TxRadioThemeData &&
        other.mouseCursor == mouseCursor &&
        other.fillColor == fillColor &&
        other.overlayColor == overlayColor &&
        other.splashRadius == splashRadius &&
        other.materialTapTargetSize == materialTapTargetSize &&
        other.visualDensity == visualDensity &&
        other.shape == shape &&
        other.side == side;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<WidgetStateProperty<MouseCursor?>>(
        'mouseCursor', mouseCursor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<WidgetStateProperty<Color?>>(
        'fillColor', fillColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<WidgetStateProperty<Color?>>(
        'overlayColor', overlayColor,
        defaultValue: null));
    properties
        .add(DoubleProperty('splashRadius', splashRadius, defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialTapTargetSize>(
        'materialTapTargetSize', materialTapTargetSize,
        defaultValue: null));
    properties.add(DiagnosticsProperty<VisualDensity>(
        'visualDensity', visualDensity,
        defaultValue: null));
    properties.add(DiagnosticsProperty<OutlinedBorder>('shape', shape,
        defaultValue: null));
    properties
        .add(DiagnosticsProperty<BorderSide>('side', side, defaultValue: null));
  }

  // 特殊情况，因为 BorderSide.lerp() 不支持空参数
  static BorderSide? _lerpSides(BorderSide? a, BorderSide? b, double t) {
    if (a == null && b == null) {
      return null;
    }
    return BorderSide.lerp(a!, b!, t);
  }

  @override
  ThemeExtension<TxRadioThemeData> lerp(
      ThemeExtension<TxRadioThemeData>? other, double t) {
    if (other is! TxRadioThemeData) {
      return this;
    }

    return TxRadioThemeData(
      mouseCursor: t < 0.5 ? mouseCursor : other.mouseCursor,
      fillColor: WidgetStateProperty.lerp<Color?>(
          fillColor, other.fillColor, t, Color.lerp),
      overlayColor: WidgetStateProperty.lerp<Color?>(
          overlayColor, other.overlayColor, t, Color.lerp),
      splashRadius: lerpDouble(splashRadius, other.splashRadius, t),
      materialTapTargetSize:
          t < 0.5 ? materialTapTargetSize : other.materialTapTargetSize,
      visualDensity: t < 0.5 ? visualDensity : other.visualDensity,
      shape: ShapeBorder.lerp(shape, other.shape, t) as OutlinedBorder?,
      side: _lerpSides(side, other.side, t),
    );
  }
}

/// 将单选框主题应用于后代 [TxRadio] 小部件。
///
/// 后代小部件使用 [TxRadioTheme.of] 获取当前主题的 [TxRadioTheme] 对象。
/// 当小部件使用 [TxRadioTheme.of] 时，如果主题稍后更改，它会自动重建。
///
/// 可以使用 [ThemeData.extension<TxRadioTheme>()!] 将单选框主题指定为整个 Material
/// 主题的一部分。
class TxRadioTheme extends InheritedWidget {
  /// 构造一个配置所有后代 [TxRadio] 小部件的单选按钮主题。
  const TxRadioTheme({
    required this.data,
    required super.child,
    super.key,
  });

  /// 用于所有后代 [TxRadio] 小部件的属性。
  final TxRadioThemeData data;

  /// 从最近的 [TxRadioTheme] 祖先返回配置 [data]。
  ///
  /// 如果没有祖先，则返回 [ThemeData.extension<TxRadioThemeData>()]；
  /// 如果它也为null，则返回默认[TxRadioThemeData]
  static TxRadioThemeData of(BuildContext context) {
    final TxRadioTheme? radioTheme =
        context.dependOnInheritedWidgetOfExactType<TxRadioTheme>();
    return radioTheme?.data ??
        Theme.of(context).extension<TxRadioThemeData>() ??
        const TxRadioThemeData();
  }

  @override
  bool updateShouldNotify(TxRadioTheme oldWidget) => data != oldWidget.data;
}
