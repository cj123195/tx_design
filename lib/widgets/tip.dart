import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'tip_theme.dart';

/// 提示类型
enum TipType {
  /// 小贴士
  tip(Colors.amber, Icons.tips_and_updates),

  /// 警告
  warning(Colors.deepOrange, Icons.warning),

  /// 危险
  danger(Colors.red, Icons.dangerous),

  /// 信息
  info(Colors.blue, Icons.info),

  /// 提示
  notice(Colors.orange, Icons.notifications);

  const TipType(this.color, this.icon);

  /// 该类型所颜色
  ///
  /// 主要用于背景颜色和图标颜色
  final MaterialColor color;

  /// 该类型所对应的图标
  final IconData icon;
}

/// 一个Material风格的用于提示信息的小组件
class TxTip extends StatelessWidget {
  /// 创建一个提示小组件
  ///
  /// [data]不能为null
  const TxTip(
    this.data, {
    super.key,
    this.icon,
    this.margin,
    this.padding,
    this.backgroundColor,
    this.foregroundColor,
    this.textStyle,
    this.borderRadius,
    this.visualDensity,
    this.onClose,
  }) : textSpan = null;

  /// 使用[textSpan]创建一个提示
  ///
  /// [textSpan]不能为null
  const TxTip.rich(
    this.textSpan, {
    super.key,
    this.icon,
    this.margin,
    this.padding,
    this.backgroundColor,
    this.foregroundColor,
    this.textStyle,
    this.borderRadius,
    this.visualDensity,
    this.onClose,
  }) : data = null;

  /// 根据类型创建一个提示小组件
  ///
  /// [data]与[type]不能为null
  TxTip.type(
      {required TipType type,
      required this.data,
      super.key,
      this.margin,
      this.padding,
      this.textStyle,
      this.borderRadius,
      this.visualDensity,
      this.onClose})
      : backgroundColor = type.color.shade100,
        foregroundColor = type.color,
        icon = Icon(type.icon),
        textSpan = null;

  /// 要显示的文本。
  ///
  /// 如果提供了一个[textSpan]，这将是空的。
  final String? data;

  /// 要显示为[InlineSpan]的文本。
  ///
  /// 如果提供[data]，则此值将为空。
  final InlineSpan? textSpan;

  /// 树中此小部件下方的小部件。
  final Widget? icon;

  /// 在[data]后绘制的颜色
  ///
  /// 如果为null，则使用[TxTipThemeData.backgroundColor]，如果它也为空，
  /// 则使用[ColorScheme.primaryContainer]。
  final Color? backgroundColor;

  /// 提示的 [Text] 和 [Icon] 小部件后代的颜色。
  ///
  /// 这种颜色通常用来代替 [textStyle] 的颜色。
  ///
  /// 如果为null，则使用[TxTipThemeData.foregroundColor]，如果它也为空，
  /// 则使用[ColorScheme.primary]。
  final Color? foregroundColor;

  /// 后代[Text]小部件的样式。
  ///
  /// [textStyle]的颜色通常不直接使用，使用[foregroundColor]代替。
  /// 如果为null，则使用[TxTipThemeData.textStyle]，如果它也为空，
  /// 则使用[TextTheme.bodySmall]。
  final TextStyle? textStyle;

  /// 如果非空，此框的角由此 [BorderRadius] 圆化。
  ///
  /// 如果为null，则使用[TxTipThemeData.borderRadius]，如果它也为空，
  /// 则值为BorderRadius.circular(8.0)。
  final BorderRadius? borderRadius;

  /// 提示周围的空白空间
  final EdgeInsetsGeometry? margin;

  /// 内部空白空间。[data]被放置在这个填充中。
  ///
  /// 如果为null，则使用[TxTipThemeData.padding]，如果它也为空，
  /// 则使用EdgeInsets.all(12.0)。
  final EdgeInsetsGeometry? padding;

  /// 定义提示布局的紧凑程度。
  ///
  /// 有关详细信息，请参阅 [ThemeData.visualDensity]。
  final VisualDensity? visualDensity;

  /// 当用户点击关闭按钮时调用。
  ///
  /// 如果值为null，则不显示关闭按钮
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TxTipThemeData tipTheme = TxTipTheme.of(context);

    final Color background = backgroundColor ??
        tipTheme.backgroundColor ??
        theme.colorScheme.primaryContainer;
    final Color foreground = foregroundColor ??
        tipTheme.foregroundColor ??
        theme.colorScheme.primary;
    final BorderRadius effectiveRadius = borderRadius ??
        tipTheme.borderRadius ??
        const BorderRadius.all(Radius.circular(8.0));
    final VisualDensity effectiveDensity =
        visualDensity ?? tipTheme.visualDensity ?? theme.visualDensity;
    final TextStyle effectiveTextStyle =
        textStyle ?? tipTheme.textStyle ?? theme.textTheme.bodySmall!;
    final EdgeInsetsGeometry effectivePadding =
        this.padding ?? tipTheme.padding ?? const EdgeInsets.all(12.0);
    final EdgeInsetsGeometry margin = this.margin ?? const EdgeInsets.all(8.0);

    final double dy = effectiveDensity.baseSizeAdjustment.dy;
    final double dx = math.max(0, effectiveDensity.baseSizeAdjustment.dx);
    final EdgeInsetsGeometry padding = effectivePadding
        .add(EdgeInsets.fromLTRB(dx, dy, dx, dy))
        .clamp(EdgeInsets.zero, EdgeInsetsGeometry.infinity);

    InlineSpan text = TextSpan(
      text: data,
      children: textSpan == null ? null : [textSpan!],
      style: effectiveTextStyle.copyWith(color: foreground),
    );
    if (icon != null) {
      text = TextSpan(children: [
        WidgetSpan(
          child: Padding(
            padding: EdgeInsets.only(right: 4.0 + effectiveDensity.horizontal),
            child: icon!,
          ),
        ),
        text,
      ]);
    }

    Widget result = Container(
      width: double.infinity,
      margin: margin,
      decoration:
          BoxDecoration(color: background, borderRadius: effectiveRadius),
      padding: padding,
      child: RichText(text: text),
    );
    if (onClose != null) {
      result = Stack(
        children: [
          result,
          Positioned(
            top: padding.vertical / 4,
            right: padding.horizontal / 4,
            child: IconButton(
              onPressed: onClose,
              icon: const Icon(Icons.close),
              padding: EdgeInsets.zero,
              color: foreground,
              style: const ButtonStyle(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),
        ],
      );
    }

    return IconTheme(
      data: IconThemeData(color: foreground, size: 16),
      child: result,
    );
  }
}
