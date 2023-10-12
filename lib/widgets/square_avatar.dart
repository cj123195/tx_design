import 'package:flutter/material.dart';

/// 展示图标或用户名称的方形框。
///
/// 参数说明请参考[CircleAvatar]
class TxSquareAvatar extends StatelessWidget {
  const TxSquareAvatar({
    super.key,
    this.child,
    this.backgroundColor,
    this.backgroundImage,
    this.foregroundImage,
    this.onBackgroundImageError,
    this.onForegroundImageError,
    this.foregroundColor,
    this.radius,
    this.minRadius,
    this.maxRadius,
    this.borderRadius,
  })  : assert(radius == null || (minRadius == null && maxRadius == null)),
        assert(backgroundImage != null || onBackgroundImageError == null),
        assert(foregroundImage != null || onForegroundImageError == null);

  /// 树中此小部件下方的小组件
  ///
  /// 通常是 [Text] 小部件。如果[TxSquareAvatar]要有图像，请使用[backgroundImage]。
  final Widget? child;

  /// 用于填充圆圈的颜色。更改背景颜色将导致头像动画化为新颜色。
  ///
  /// 如果未指定 [backgroundColor] 且 [ThemeData.useMaterial3] 为真，则将使用
  /// [ColorScheme.primaryContainer]，否则主题的 [ThemeData.primaryColorLight] 用
  /// 于深色前景色，[ThemeData.primaryColorDark] 用于浅前景色。
  final Color? backgroundColor;

  /// 圆圈中文本的默认文本颜色。
  ///
  /// 如果未指定 [backgroundColor]，则默认为主要文本主题颜色。
  ///
  /// 如果未指定 [foregroundColor] 并且 [ThemeData.useMaterial3] 为 true，则将使用
  /// [ColorScheme.onPrimaryContainer]，否则主题的 [ThemeData.primaryColorLight]
  /// 用于深色背景色，[ThemeData.primaryColorDark] 用于浅色背景色。
  final Color? foregroundColor;

  /// 圆圈的背景图像。更改背景图像将导致头像动画化为新图像。
  ///
  /// 通常用作 [foregroundImage] 的回退图像。
  ///
  /// 如果 [TxSquareAvatar] 要使用用户的首字母缩写，请改用 [child]。
  final ImageProvider? backgroundImage;

  /// 圆的前景图像。
  ///
  /// 通常用作个人资料图像。对于回退，请使用 [backgroundImage].
  final ImageProvider? foregroundImage;

  /// 加载 [backgroundImage] 时发出的错误的可选错误回调。
  final ImageErrorListener? onBackgroundImageError;

  /// 加载 [前台图像] 时发出的错误的可选错误回调。
  final ImageErrorListener? onForegroundImageError;

  /// 头像的大小，以半径（直径的一半）表示。
  ///
  /// 如果指定了 [radius]，则既不能指定 [minRadius] 也不能指定 [maxRadius]。指定
  /// [radius] 等效于指定 [minRadius] 和 [maxRadius]，两者的值均为 [radius]。
  ///
  /// 如果未指定 [minRadius] 和 [maxRadius]，则默认为 20 个逻辑像素。这是与
  /// [ListTile.leading] 一起使用的适当大小。
  ///
  /// 对 [radius] 的更改是动画的（包括从显式 [radius] 更改为 [minRadius]/[maxRadius]
  /// 对，反之亦然）。
  final double? radius;

  /// 头像的最小大小，以半径（直径的一半）表示
  ///
  /// 如果指定了 [minRadius]，则不得同时指定 [radius]。
  ///
  /// 默认值为零。
  ///
  /// 约束更改是动画的，但不会因环境本身更改而导致的大小更改。例如，当 [TxSquareAvatar] 处于
  /// 不受约束的环境中时，将 [minRadius] 从 10 更改为 20 将导致头像从 20 像素直径动画化到
  /// 40 像素直径。但是，如果 [minRadius] 为 40，并且 [TxSquareAvatar] 有一个父级
  /// [SizedBox]，其大小会立即从 20 像素更改为 40 像素，则大小将立即捕捉到 40 像素。
  final double? minRadius;

  /// 头像的最大大小，以半径（直径的一半）表示。
  ///
  /// 如果指定了 [maxRadius]，则不得同时指定 [radius]。
  ///
  /// 默认为 [double.infinity]。
  ///
  /// 约束更改是动画的，但不会因环境本身更改而导致的大小更改。例如，当 [TxSquareAvatar] 处于
  /// 不受约束的环境中时，将 [maxRadius] 从 10 更改为 20 将导致头像从 20 像素直径动画化为
  /// 40 像素直径。但是，如果 [maxRadius] 为 40，并且 [TxSquareAvatar] 有一个父级
  /// [SizedBox]，其大小会立即从 20 像素更改为 40 像素，则大小将立即捕捉到 40 像素。
  final double? maxRadius;

  /// 圆角大小
  ///
  /// M3默认值为12.0, M2默认值为4.0
  final BorderRadiusGeometry? borderRadius;

  // 如果未指定任何内容，则为默认半径。
  static const double defaultRadius = 20.0;

  // 如果仅指定最大值，则为默认值最小值。
  static const double _defaultMinRadius = 0.0;

  // 如果仅指定最小值，则为默认值最大值。
  static const double _defaultMaxRadius = double.infinity;

  double get _minDiameter {
    if (radius == null && minRadius == null && maxRadius == null) {
      return defaultRadius * 2.0;
    }
    return 2.0 * (radius ?? minRadius ?? _defaultMinRadius);
  }

  double get _maxDiameter {
    if (radius == null && minRadius == null && maxRadius == null) {
      return defaultRadius * 2.0;
    }
    return 2.0 * (radius ?? maxRadius ?? _defaultMaxRadius);
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMediaQuery(context));
    final ThemeData theme = Theme.of(context);
    final BorderRadiusGeometry effectiveBorderRadius = borderRadius ??
        (theme.useMaterial3
            ? BorderRadius.circular(12.0)
            : BorderRadius.circular(4.0));
    final Color? effectiveForegroundColor = foregroundColor ??
        (theme.useMaterial3 ? theme.colorScheme.onPrimaryContainer : null);
    final TextStyle effectiveTextStyle = theme.useMaterial3
        ? theme.textTheme.titleMedium!
        : theme.primaryTextTheme.titleMedium!;
    TextStyle textStyle =
        effectiveTextStyle.copyWith(color: effectiveForegroundColor);
    Color? effectiveBackgroundColor = backgroundColor ??
        (theme.useMaterial3 ? theme.colorScheme.primaryContainer : null);
    if (effectiveBackgroundColor == null) {
      switch (ThemeData.estimateBrightnessForColor(textStyle.color!)) {
        case Brightness.dark:
          effectiveBackgroundColor = theme.primaryColorLight;
          break;
        case Brightness.light:
          effectiveBackgroundColor = theme.primaryColorDark;
          break;
      }
    } else if (effectiveForegroundColor == null) {
      switch (ThemeData.estimateBrightnessForColor(backgroundColor!)) {
        case Brightness.dark:
          textStyle = textStyle.copyWith(color: theme.primaryColorLight);
          break;
        case Brightness.light:
          textStyle = textStyle.copyWith(color: theme.primaryColorDark);
          break;
      }
    }
    final double minDiameter = _minDiameter;
    final double maxDiameter = _maxDiameter;
    return AnimatedContainer(
      constraints: BoxConstraints(
        minHeight: minDiameter,
        minWidth: minDiameter,
        maxWidth: maxDiameter,
        maxHeight: maxDiameter,
      ),
      duration: kThemeChangeDuration,
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        image: backgroundImage != null
            ? DecorationImage(
                image: backgroundImage!,
                onError: onBackgroundImageError,
                fit: BoxFit.cover,
              )
            : null,
        borderRadius: effectiveBorderRadius,
      ),
      foregroundDecoration: foregroundImage != null
          ? BoxDecoration(
              image: DecorationImage(
                image: foregroundImage!,
                onError: onForegroundImageError,
                fit: BoxFit.cover,
              ),
              borderRadius: effectiveBorderRadius,
            )
          : null,
      child: child == null
          ? null
          : Center(
              child: MediaQuery(
                // 需要忽略此处的环境文本比例因子，以便在文本比例因子较大时文本不会转义头像。
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: IconTheme(
                  data: theme.iconTheme.copyWith(color: textStyle.color),
                  child: DefaultTextStyle(
                    style: textStyle,
                    child: child!,
                  ),
                ),
              ),
            ),
    );
  }
}
