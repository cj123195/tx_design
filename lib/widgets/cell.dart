import 'package:flutter/material.dart';

import 'cell_theme.dart';
import 'expandable_text.dart';

/// 一个用于展示数据及其描述的组件。
///
/// 主要用于展示label：value形式的数据
/// 纯展示组件，如需更多功能请使用[ListTile]
class TxCell extends StatelessWidget {
  const TxCell({
    super.key,
    this.label,
    this.labelText,
    this.labelStyle,
    this.leading,
    this.iconColor,
    this.content,
    this.contentText,
    this.contentStyle,
    this.padding,
    this.crossAxisAlignment,
    this.minLabelWidth,
    this.dense,
    this.visualDensity,
    this.textColor,
    this.horizontalGap,
    this.minLeadingWidth,
  }) : assert(label != null || labelText != null);

  /// 在标题前显示的小部件。
  ///
  /// 通常是 [Icon] 或 [CircleAvatar] 小部件。
  final Widget? leading;

  /// 描述展示内容的可选小部件。
  ///
  /// 这可以用于，例如，将多个 [TextStyle] 添加到一个标签，否则将使用 [labelText] 指定，
  /// 它只需要一个 [TextStyle]。
  ///
  /// 只能指定 [label] 和 [labelText] 之一。
  final Widget? label;

  /// 描述展示内容的可选文本。
  ///
  /// 如果需要更详细的标签，请考虑改用 [label]。
  /// 只能指定 [label] 和 [labelText] 之一。
  final String? labelText;

  /// [label]或[labelText]的文字样式
  ///
  /// 如果为null，则使用[TxCellThemeData.labelStyle]；如果它也为null，则使用
  /// [TextTheme.labelLarge]。
  final TextStyle? labelStyle;

  /// 展示的主体内容小部件
  ///
  /// 只能指定 [content] 和 [contentText] 之一。
  final Widget? content;

  /// 展示的主体内容文字
  ///
  /// 如果需要更详细的内容，请考虑改用 [content]。
  /// 只能指定 [content] 和 [contentText] 之一。
  final String? contentText;

  /// [content]或[contentText]的文字样式
  ///
  /// 如果为null，则使用[TxCellThemeData.contentStyle]；如果它也为null，则使用
  /// [TextTheme.bodyMedium]。
  final TextStyle? contentStyle;

  /// 此cell是否是垂直密集列表的一部分。
  ///
  /// 如果此属性为空，则其值基于 [TxCellThemeData.dense]。
  ///
  /// 密集cell默认为较小的高度及较小的字体。
  final bool? dense;

  /// 定义cell的紧凑程度。
  final VisualDensity? visualDensity;

  /// 定义 [leading]图标的默认颜色。
  ///
  /// 如果此属性为空，则使用 [TxCellThemeData.iconColor]。
  final Color? iconColor;

  /// 定义 [label] 和 [content] 的默认颜色。
  ///
  /// 如果此属性为空，则使用 [TxCellThemeData.textColor]。
  final Color? textColor;

  /// cell的内部填充。
  ///
  /// 如果为空，则使用[TxCellThemeData.padding]，如果它也为空，则使用
  /// “EdgeInsets.symmetric(horizontal: 12.0)”。
  final EdgeInsetsGeometry? padding;

  /// [label]和[leading]/[content]小部件之间的水平间隙。
  ///
  /// 如果为 null，则使用 [TxCellThemeData.horizontalGap] 的值。 如果它也为 null，
  /// 则使用默认值 12.0。
  final double? horizontalGap;

  /// 分配给 [leading] 小部件的最小宽度。
  ///
  /// 如果为 null，则使用 [TxCellThemeData.minLeadingWidth] 的值。
  /// 如果它也为 null，则使用默认值 32.0。
  final double? minLeadingWidth;

  /// 分配给 [label] 小部件的最小宽度。
  ///
  /// 如果为 null，则使用 [TxCellThemeData.minLabelWidth] 的值。
  /// 如果它也为 null，则使用默认值 84.0。
  final double? minLabelWidth;

  /// 交叉轴的对其方式
  ///
  /// 如果为 null，则使用 [TxCellThemeData.crossAxisAlignment] 的值。
  /// 如果它也为 null，则使用默认值[CrossAxisAlignment.start]。
  final CrossAxisAlignment? crossAxisAlignment;

  Color _iconColor(ThemeData theme, TxCellThemeData cellTheme) {
    return iconColor ?? cellTheme.iconColor ?? theme.colorScheme.primary;
  }

  Color? _textColor(
      ThemeData theme, TxCellThemeData cellTheme, Color? defaultColor) {
    return textColor ?? cellTheme.textColor ?? defaultColor;
  }

  bool _isDenseLayout(ThemeData theme, TxCellThemeData cellTheme) {
    return dense ?? cellTheme.dense ?? false;
  }

  TextStyle _labelTextStyle(ThemeData theme, TxCellThemeData cellTheme) {
    final TextStyle textStyle =
        labelStyle ?? cellTheme.labelStyle ?? theme.textTheme.labelLarge!;
    final Color? color = _textColor(theme, cellTheme, textStyle.color);
    return _isDenseLayout(theme, cellTheme)
        ? textStyle.copyWith(fontSize: 13.0, color: color)
        : textStyle.copyWith(color: color);
  }

  TextStyle _contentTextStyle(ThemeData theme, TxCellThemeData cellTheme) {
    final TextStyle textStyle =
        contentStyle ?? cellTheme.contentStyle ?? theme.textTheme.bodyMedium!;
    final Color? color = _textColor(theme, cellTheme, textStyle.color);
    return _isDenseLayout(theme, cellTheme)
        ? textStyle.copyWith(color: color, fontSize: 13.0)
        : textStyle.copyWith(color: color);
  }

  TextStyle _leadingTextStyle(ThemeData theme, TxCellThemeData cellTheme) {
    final TextStyle textStyle = theme.textTheme.bodyMedium!;
    final Color? color = _textColor(theme, cellTheme, textStyle.color);
    return textStyle.copyWith(color: color);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TxCellThemeData cellTheme = TxCellTheme.of(context);
    final bool dense = _isDenseLayout(theme, cellTheme);
    final IconThemeData iconThemeData = IconThemeData(
      color: _iconColor(theme, cellTheme),
      size: dense ? 18.0 : 20.0,
    );

    Widget? leadingIcon;
    if (leading != null) {
      leadingIcon = DefaultTextStyle(
        style: _leadingTextStyle(theme, cellTheme),
        child: leading!,
      );

      if (minLeadingWidth != null) {
        leadingIcon = ConstrainedBox(
          constraints: BoxConstraints(minWidth: minLeadingWidth!),
          child: Center(child: leadingIcon),
        );
      } else {
        final double defaultGap = dense ? 12.0 : 8.0;
        final double effectiveHorizontalGap =
            horizontalGap ?? cellTheme.horizontalGap ?? defaultGap;
        leadingIcon = Padding(
          padding: EdgeInsets.only(right: effectiveHorizontalGap),
          child: leadingIcon,
        );
      }
    }

    final TextStyle labelStyle = _labelTextStyle(theme, cellTheme);
    Widget labelText = DefaultTextStyle(
      style: labelStyle,
      child: label ?? Text('${this.labelText!}：'),
    );
    if (minLabelWidth != null) {
      labelText = ConstrainedBox(
        constraints: BoxConstraints(minWidth: minLabelWidth!),
        child: labelText,
      );
    }

    Widget? contentText;
    TextStyle? contentStyle;
    if (content != null || this.contentText != null) {
      contentStyle = _contentTextStyle(theme, cellTheme);
      contentText = DefaultTextStyle(
        style: contentStyle,
        child: content ?? TxExpandableText(this.contentText!),
      );
    }

    final CrossAxisAlignment alignment = crossAxisAlignment ??
        (contentText != null
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center);

    final EdgeInsets defaultPadding =
        EdgeInsets.symmetric(horizontal: dense ? 12.0 : 8.0);
    final TextDirection textDirection = Directionality.of(context);
    final EdgeInsets resolvedPadding = padding?.resolve(textDirection) ??
        cellTheme.padding?.resolve(textDirection) ??
        defaultPadding;

    return SafeArea(
      top: false,
      bottom: false,
      minimum: resolvedPadding,
      child: IconTheme.merge(
        data: iconThemeData,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: alignment,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (leadingIcon != null) leadingIcon,
            labelText,
            if (contentText != null) Expanded(child: contentText)
          ],
        ),
      ),
    );
  }
}
