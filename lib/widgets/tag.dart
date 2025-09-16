import 'package:flutter/material.dart';

import 'tag_theme.dart';

/// 类型
enum _TagStyle {
  filled,
  outlined,
  tonal,
}

/// 用于展示少量信息的标签小组件。
class TxTag extends StatelessWidget {
  /// 创建一个没有边框且背景填充的标签。
  ///
  /// [label] 不能为 null。
  const TxTag({
    required this.label,
    super.key,
    this.backgroundColor,
    this.foregroundColor,
    this.textStyle,
    this.padding,
    this.shape,
    this.margin,
  }) : _style = _TagStyle.filled;

  /// 创建一个没有背景填充但有边框的标签。
  ///
  /// [label] 不能为 null。
  const TxTag.outlined({
    required this.label,
    super.key,
    Color? color,
    this.textStyle,
    this.padding,
    OutlinedBorder? this.shape,
    this.margin,
  })
      : _style = _TagStyle.outlined,
        foregroundColor = color,
        backgroundColor = null;

  /// 创建一个背景填充且有边框的标签。
  ///
  /// [label] 不能为 null。
  const TxTag.tonal({
    required this.label,
    super.key,
    this.backgroundColor,
    this.foregroundColor,
    this.textStyle,
    this.padding,
    OutlinedBorder? this.shape,
    this.margin,
  }) : _style = _TagStyle.tonal;

  /// 徽章的填充颜色。
  ///
  /// 默认为 [TxTagThemeData.backgroundColor]，如果该值为 null，则默认为
  /// [ColorScheme.primary]。
  final Color? backgroundColor;

  /// 徽章的 [label] 文本的颜色。
  ///
  /// 此颜色将覆盖标签的 [textStyle] 的颜色。
  ///
  /// 默认为 [TxTagThemeData.foregroundColor]，如果该值为 null，则默认为
  /// [ColorScheme.onError]。
  final Color? foregroundColor;

  /// 标签的 [DefaultTextStyle]。
  ///
  /// 文本样式的颜色被 [foregroundColor] 覆盖。
  ///
  /// 仅当 [label] 为非 null 时才使用此值。
  ///
  /// 默认为 [TxTagThemeData.textStyle]，如果该值为 null，则默认为 [TextTheme.labelSmall]。
  final TextStyle? textStyle;

  /// 添加到徽章标签的填充。
  ///
  /// 默认为 [TxTagThemeData.padding]，如果该值为 null，则左右各为 4 像素。
  final EdgeInsetsGeometry? padding;

  /// 徽章的内容，通常是包含 1 到 4 个字符的 [Text] 小组件。
  final Widget label;

  /// 徽章的形状
  ///
  /// 默认为圆角为 4.0 的[RoundedRectangleBorder]。
  final ShapeBorder? shape;

  /// 标签样式
  final _TagStyle _style;

  /// 组件与其他组件之前的距离
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme
        .of(context)
        .colorScheme;

    final TxTagThemeData tagTheme = TxTagTheme.of(context);
    final _TagDefaultsM3 defaults = _TagDefaultsM3(context);

    final Color effectiveForegroundColor = foregroundColor ??
        (_style == _TagStyle.filled
            ? tagTheme.foregroundColor ?? colorScheme.onPrimary
            : tagTheme.backgroundColor ?? colorScheme.primary);

    ShapeBorder effectiveShape = shape ?? tagTheme.shape ?? defaults.shape!;
    if (_style != _TagStyle.filled && effectiveShape is OutlinedBorder) {
      final BorderSide side =
      effectiveShape.side.copyWith(color: effectiveForegroundColor);
      effectiveShape = effectiveShape.copyWith(side: side);
    }

    final Color? effectiveBackgroundColor = backgroundColor ??
        (_style == _TagStyle.filled
            ? tagTheme.backgroundColor ?? colorScheme.primary
            : _style == _TagStyle.outlined
            ? null
            : (tagTheme.backgroundColor ?? colorScheme.primary)
            .withValues(alpha: 0.1));

    return DefaultTextStyle(
      style: (textStyle ?? tagTheme.textStyle ?? defaults.textStyle!).copyWith(
        color: effectiveForegroundColor,
      ),
      child: Container(
        margin: margin,
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: effectiveBackgroundColor,
          shape: effectiveShape,
        ),
        padding: padding ?? tagTheme.padding ?? defaults.padding!,
        // alignment: Alignment.center,
        child: label,
      ),
    );
  }
}

class _TagDefaultsM3 extends TxTagThemeData {
  _TagDefaultsM3(this.context)
      : super(
    padding: const EdgeInsets.fromLTRB(6, 1, 6, 2),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
    ),
  );

  final BuildContext context;
  late final ThemeData _theme = Theme.of(context);
  late final ColorScheme _colors = _theme.colorScheme;

  @override
  Color? get backgroundColor => _colors.primary;

  @override
  Color? get foregroundColor => _colors.onPrimary;

  @override
  TextStyle? get textStyle => _theme.textTheme.labelSmall;
}

/// 内嵌在文本中的标签小组件
class TxTagSpan extends WidgetSpan {
  /// 创建一个内部填充且没有边框的内嵌在文本中的标签组件
  ///
  /// [text] 文本不能为 null。
  TxTagSpan({
    required String text,
    super.alignment = PlaceholderAlignment.middle,
    super.style,
    super.baseline,
    Color? backgroundColor,
    Color? foregroundColor,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin = const EdgeInsets.only(left: 4.0),
    ShapeBorder? shape,
  }) : super(
    child: TxTag(
      label: Text(text),
      textStyle: style,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      padding: padding,
      margin: margin,
      shape: shape,
    ),
  );

  /// 创建一个内部无填充且有边框的内嵌在文本中的标签组件
  ///
  /// [text] 文本不能为 null。
  TxTagSpan.outlined({
    required String text,
    super.alignment = PlaceholderAlignment.middle,
    super.style,
    super.baseline,
    Color? color,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin = const EdgeInsets.only(left: 4.0),
    OutlinedBorder? shape,
  }) : super(
    child: TxTag.outlined(
      label: Text(text),
      textStyle: style,
      color: color,
      padding: padding,
      margin: margin,
      shape: shape,
    ),
  );

  /// 创建一个内部填充且有边框的内嵌在文本中的标签组件
  ///
  /// [text] 文本不能为 null。
  TxTagSpan.tonal({
    required String text,
    super.alignment = PlaceholderAlignment.middle,
    super.style,
    super.baseline,
    Color? backgroundColor,
    Color? foregroundColor,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin = const EdgeInsets.only(left: 4.0),
    OutlinedBorder? shape,
  }) : super(
    child: TxTag.tonal(
      label: Text(text),
      textStyle: style,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      padding: padding,
      margin: margin,
      shape: shape,
    ),
  );
}
