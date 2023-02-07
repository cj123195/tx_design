import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'toast.dart';

/// 定义后代 [Toast] 小部件的默认属性值。
///
/// 后代小部件使用 `ToastTheme.of(context)` 获取当前的 [ToastThemeData] 对象。
/// [ToastThemeData] 的实例可以使用 [ToastThemeData.copyWith] 进行自定义。
///
/// 默认情况下，所有 [ToastThemeData] 属性均为“null”。 如果为 null，[Toast] 将使用
/// 来自 [ThemeData] 的值（如果它们存在），否则它将根据整体 [Theme] 的 colorScheme
/// 提供自己的默认值。 有关详细信息，请参阅各个 [Toast] 属性。
@immutable
class ToastThemeData extends ThemeExtension<ToastThemeData>
    with Diagnosticable {
  /// 创建可用于 [ThemeData.extension<ToastThemeData>()] 的主题。
  const ToastThemeData({
    this.textStyle,
    this.backgroundColor,
    this.foregroundColor,
    this.padding,
    this.borderRadius,
    this.visualDensity,
    this.textAlign,
    this.maskColor,
    this.verticalGap,
    this.indicatorSize,
    this.indicatorWidth,
    this.indicator,
    this.successIcon,
    this.errorIcon,
    this.informationIcon,
    this.position,
    this.animationDuration,
    this.displayDuration,
    this.dismissOnTap,
    this.isInteractive,
    this.animationBuilder,
  });

  /// 文本样式。
  final TextStyle? textStyle;

  /// 文本应该如何水平对齐。
  final TextAlign? textAlign;

  /// [Toast]的背景填充颜色。
  final Color? backgroundColor;

  /// [Toast]的 [Text] 和 [Icon] 小部件后代的颜色。
  ///
  /// 这种颜色通常用来代替 [textStyle] 的颜色。
  final Color? foregroundColor;

  /// 遮罩颜色
  final Color? maskColor;

  /// [Toast]的边界和它的孩子之间的填充。
  final EdgeInsetsGeometry? padding;

  /// 圆角大小。
  final BorderRadius? borderRadius;

  /// 定义[Toast]布局的紧凑程度。
  ///
  /// 有关详细信息，请参阅 [ThemeData.visualDensity]。
  final VisualDensity? visualDensity;

  /// 纵向间距。
  final double? verticalGap;

  /// 指示器大小。
  final double? indicatorSize;

  /// 指示器宽度。
  final double? indicatorWidth;

  /// Loading状态指示器。
  final Widget? indicator;

  /// 成功图标。
  final Widget? successIcon;

  /// 错误图标。
  final Widget? errorIcon;

  /// 信息图标。
  final Widget? informationIcon;

  /// [Toast]在屏幕中的位置。
  final ToastPosition? position;

  /// [Toast]动画时间。
  final Duration? animationDuration;

  /// [Toast]持续时间。
  ///
  /// loading与progress此属性无效。
  final Duration? displayDuration;

  /// 是否允许点击关闭。
  final bool? dismissOnTap;

  /// 是否允许点击关闭
  final bool? isInteractive;

  /// 动画构建器。
  final ToastAnimationBuilder? animationBuilder;

  /// 创建此对象的副本，但将给定字段替换为新值。
  @override
  ToastThemeData copyWith({
    TextStyle? textStyle,
    TextAlign? textAlign,
    Color? backgroundColor,
    Color? foregroundColor,
    Color? maskColor,
    EdgeInsetsGeometry? padding,
    BorderRadius? borderRadius,
    VisualDensity? visualDensity,
    ToastAnimation? animation,
    double? verticalGap,
    double? indicatorSize,
    double? indicatorWidth,
    Widget? indicator,
    Widget? successIcon,
    Widget? errorIcon,
    Widget? informationIcon,
    ToastPosition? position,
    Duration? animationDuration,
    Duration? displayDuration,
    bool? dismissOnTap,
    bool? isInteractive,
    ToastAnimationBuilder? animationBuilder,
  }) {
    return ToastThemeData(
      textStyle: textStyle ?? this.textStyle,
      textAlign: textAlign ?? this.textAlign,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      maskColor: maskColor ?? this.maskColor,
      padding: padding ?? this.padding,
      borderRadius: borderRadius ?? this.borderRadius,
      visualDensity: visualDensity ?? this.visualDensity,
      verticalGap: verticalGap ?? this.verticalGap,
      indicatorSize: indicatorSize ?? this.indicatorSize,
      indicatorWidth: indicatorWidth ?? this.indicatorWidth,
      indicator: indicator ?? this.indicator,
      successIcon: successIcon ?? this.successIcon,
      errorIcon: errorIcon ?? this.errorIcon,
      informationIcon: informationIcon ?? this.informationIcon,
      position: position ?? this.position,
      animationDuration: animationDuration ?? this.animationDuration,
      displayDuration: displayDuration ?? this.displayDuration,
      dismissOnTap: dismissOnTap ?? this.dismissOnTap,
      isInteractive: isInteractive ?? this.isInteractive,
      animationBuilder: animationBuilder ?? this.animationBuilder,
    );
  }

  @override
  int get hashCode => Object.hash(
        textStyle,
        textAlign,
        backgroundColor,
        foregroundColor,
        maskColor,
        padding,
        borderRadius,
        visualDensity,
        verticalGap,
        indicatorSize,
        indicatorWidth,
        indicator,
        successIcon,
        errorIcon,
        informationIcon,
        position,
        animationDuration,
        displayDuration,
        dismissOnTap,
        isInteractive,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is ToastThemeData &&
        other.textStyle == textStyle &&
        other.textAlign == textAlign &&
        other.backgroundColor == backgroundColor &&
        other.foregroundColor == foregroundColor &&
        other.maskColor == maskColor &&
        other.padding == padding &&
        other.borderRadius == borderRadius &&
        other.visualDensity == visualDensity &&
        other.verticalGap == verticalGap &&
        other.indicatorSize == indicatorSize &&
        other.indicatorWidth == indicatorWidth &&
        other.indicator == indicator &&
        other.successIcon == successIcon &&
        other.errorIcon == errorIcon &&
        other.informationIcon == informationIcon &&
        other.position == position &&
        other.animationDuration == animationDuration &&
        other.displayDuration == displayDuration &&
        other.dismissOnTap == dismissOnTap &&
        other.isInteractive == isInteractive;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TextStyle>('textStyle', textStyle,
        defaultValue: null));
    properties.add(DiagnosticsProperty<TextAlign>('textAlign', textAlign,
        defaultValue: null));
    properties.add(DiagnosticsProperty<Color>('background', backgroundColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<Color>('foreground', foregroundColor,
        defaultValue: null));
    properties.add(
        DiagnosticsProperty<Color>('maskColor', maskColor, defaultValue: null));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('padding', padding,
        defaultValue: null));
    properties.add(DiagnosticsProperty<BorderRadius>(
        'borderRadius', borderRadius,
        defaultValue: null));
    properties
        .add(DoubleProperty('verticalGap', verticalGap, defaultValue: null));
    properties.add(
        DoubleProperty('indicatorSize', indicatorSize, defaultValue: null));
    properties.add(
        DoubleProperty('indicatorWidth', indicatorWidth, defaultValue: null));
    properties.add(DiagnosticsProperty<Widget>('indicator', indicator,
        defaultValue: null));
    properties.add(DiagnosticsProperty<Widget>('successIcon', successIcon,
        defaultValue: null));
    properties.add(DiagnosticsProperty<Widget>('errorIcon', errorIcon,
        defaultValue: null));
    properties.add(DiagnosticsProperty<Widget>(
        'informationIcon', informationIcon,
        defaultValue: null));
    properties.add(DiagnosticsProperty<ToastPosition>('position', position,
        defaultValue: null));
    properties.add(DiagnosticsProperty<Duration>(
        'animationDuration', animationDuration,
        defaultValue: null));
    properties.add(DiagnosticsProperty<Duration>(
        'displayDuration', displayDuration,
        defaultValue: null));
    properties.add(DiagnosticsProperty<bool>('dismissOnTap', dismissOnTap,
        defaultValue: null));
    properties.add(DiagnosticsProperty<bool>('isInteractive', isInteractive,
        defaultValue: null));
    properties.add(DiagnosticsProperty<ToastAnimationBuilder>(
        'animationBuilder', animationBuilder,
        defaultValue: null));
  }

  @override
  ThemeExtension<ToastThemeData> lerp(
      ThemeExtension<ToastThemeData>? other, double t) {
    if (other is! ToastThemeData) {
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

    return ToastThemeData(
      textStyle: TextStyle.lerp(textStyle, other.textStyle, t),
      textAlign: _lerp<TextAlign>(textAlign, other.textAlign, t),
      foregroundColor: Color.lerp(foregroundColor, other.foregroundColor, t),
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      maskColor: Color.lerp(maskColor, other.maskColor, t),
      padding: EdgeInsetsGeometry.lerp(padding, other.padding, t),
      borderRadius: BorderRadius.lerp(borderRadius, other.borderRadius, t),
      visualDensity: density,
      verticalGap: lerpDouble(verticalGap, other.verticalGap, t),
      indicatorSize: lerpDouble(indicatorSize, other.indicatorSize, t),
      indicatorWidth: lerpDouble(indicatorWidth, other.indicatorWidth, t),
      indicator: _lerp<Widget>(indicator, other.indicator, t),
      successIcon: _lerp<Widget>(successIcon, other.successIcon, t),
      errorIcon: _lerp<Widget>(errorIcon, other.errorIcon, t),
      informationIcon: _lerp<Widget>(informationIcon, other.informationIcon, t),
      position: _lerp<ToastPosition>(position, other.position, t),
      animationDuration:
          _lerp<Duration>(animationDuration, other.animationDuration, t),
      displayDuration:
          _lerp<Duration>(displayDuration, other.displayDuration, t),
      dismissOnTap: _lerp<bool>(dismissOnTap, other.dismissOnTap, t),
      isInteractive: _lerp<bool>(isInteractive, other.isInteractive, t),
      animationBuilder: _lerp<ToastAnimationBuilder>(
          animationBuilder, other.animationBuilder, t),
    );
  }

  T? _lerp<T>(T? a, T? b, t) {
    if (a == null) {
      return b;
    } else if (b == null) {
      return a;
    } else {
      return t < 0.5 ? a : b;
    }
  }
}

/// 将单选框主题应用于后代 [Toast] 小部件。
///
/// 后代小部件使用 [ToastTheme.of] 获取当前主题的 [ToastTheme] 对象。
/// 当小部件使用 [ToastTheme.of] 时，如果主题稍后更改，它会自动重建。
///
/// 可以使用 [ThemeData.extension<ToastTheme>()!] 将单选框主题指定为整个 Material
/// 主题的一部分。
class ToastTheme extends InheritedWidget {
  /// 构造一个配置所有后代 [Toast] 小部件的Toast主题。
  const ToastTheme({
    required this.data,
    required super.child,
    super.key,
  });

  /// 用于所有后代 [Toast] 小部件的属性。
  final ToastThemeData data;

  /// 从最近的 [ToastTheme] 祖先返回配置 [data]。
  ///
  /// 如果没有祖先，则返回 [ThemeData.extension<ToastThemeData>()]；
  /// 如果它也为null，则返回默认[ToastThemeData]
  static ToastThemeData of(BuildContext context) {
    final ToastTheme? radioTheme =
        context.dependOnInheritedWidgetOfExactType<ToastTheme>();
    return radioTheme?.data ??
        Theme.of(context).extension<ToastThemeData>() ??
        const ToastThemeData();
  }

  @override
  bool updateShouldNotify(ToastTheme oldWidget) => data != oldWidget.data;
}
