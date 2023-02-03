import 'package:flutter/material.dart';

/// 在一组文本中高亮显示查询文字的小部件。
///
/// 详细属性请参考[Text]
class TxMatchingText extends StatelessWidget {
  const TxMatchingText(
    this.text, {
    super.key,
    this.query,
    this.style,
    this.matchedStyle,
    this.matchedColor,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
  });

  /// 显示的文字
  final String text;

  /// 查询的文字
  final String? query;

  /// 文字样式
  ///
  /// 如果为null，则使用"DefaultTextStyle.of(context)"
  final TextStyle? style;

  /// 匹配文字样式
  ///
  /// 如果为null，则使用"DefaultTextStyle.of(context)"并修改颜色为[matchedColor]
  final TextStyle? matchedStyle;

  /// 匹配文字颜色
  ///
  /// 如果为null，则使用[ColorScheme.primary]
  final Color? matchedColor;

  /// {@macro flutter.paintings.textPainter.strutStyle}
  final StrutStyle? strutStyle;

  /// 文本应该如何水平对齐。
  final TextAlign? textAlign;

  /// 文本的方向。
  ///
  /// 这决定了 [textAlign] 如何像 [TextAlign.start] 和 [TextAlign.end] 被解释。
  ///
  /// 这也用于消除如何呈现双向文本的歧义。
  /// 例如，如果 [text] 是一个英语短语后跟一个希伯来语短语，在 [TextDirection.ltr]
  /// 上下文中，英文短语将位于左侧和它右边的希伯来语短语，而在 [TextDirection.rtl] 中
  /// context，英文短语在右边，希伯来语短语在右边它的左边。
  ///
  /// 默认为环境[Directionality]，如果有的话。
  final TextDirection? textDirection;

  /// 用于在相同的 Unicode 字符可以选择时选择字体根据语言环境呈现不同。
  ///
  /// 很少需要设置这个属性。 默认情况下它的值
  /// 继承自带有 `Localizations.localeOf(context)` 的封闭应用程序。
  final Locale? locale;

  /// 文本是否应该在软换行处中断。
  ///
  /// 如果为 false，文本中的字形将被定位为好像有无限的水平空间。
  final bool? softWrap;

  /// 应该如何处理视觉溢出。
  ///
  /// 如果为空 [TextStyle.overflow] 将被使用，否则值为将使用最近的 [DefaultTextStyle]
  /// 祖先。
  final TextOverflow? overflow;

  /// 每个逻辑像素的字体像素数。
  ///
  /// 例如，如果文本比例因子为 1.5，则文本将大于指定的字体大小50%。
  ///
  /// 给构造函数的值作为 textScaleFactor。 如果为空，将
  /// 使用从环境获得的 [MediaQueryData.textScaleFactor]
  /// [MediaQuery]，如果范围内没有 [MediaQuery]，则为 1.0。
  final double? textScaleFactor;

  /// 文本跨越的可选最大行数，必要时换行。如果文本超过给定的行数，将根据给定的行数截断
  /// 到 [overflow]。
  ///
  /// 如果这是 1，文本将不会换行。 否则，文本将在盒子的边缘换行。
  ///
  /// 如果这是 null，但有一个环境 [DefaultTextStyle] 指定其
  /// [DefaultTextStyle.maxLines] 的明确数字，然后是[DefaultTextStyle] 值优先。
  /// 您可以使用 [RichText]小部件直接完全覆盖 [DefaultTextStyle]。
  final int? maxLines;

  /// {@template flutter.widgets.Text.semanticsLabel}
  /// 此文本的替代语义标签。
  ///
  /// 如果存在，这个小部件的语义将包含这个值实际文本。 这将覆盖任何应用的语义标签
  /// 直接到 [TextSpan]s。
  ///
  /// 这对于用全称替换缩写或速记文本值很有用：
  ///
  /// ```dart
  /// Text(r'$$', semanticsLabel: 'Double dollars')
  /// ```
  /// {@endtemplate}
  final String? semanticsLabel;

  /// {@macro flutter.paintings.textPainter.textWidthBasis}
  final TextWidthBasis? textWidthBasis;

  List<TextSpan> _generateTextSpan(String text, TextStyle style) {
    final Match? match = RegExp(query!).firstMatch(text);

    if(match == null) {
      return [TextSpan(text: text)];
    }

    final List<TextSpan> result = [];
    if(match.start != 0) {
      result.add(TextSpan(text: text.substring(0, match.start)));
    }
    result.add(TextSpan(text: query!, style: style));
    if(match.end != text.length - 1) {
      result.addAll(_generateTextSpan(text.substring(match.end), style));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);

    if (query?.isNotEmpty != true || !text.contains(query!)) {
      return Text(
        text,
        style: style ?? defaultTextStyle.style,
        strutStyle: strutStyle,
        textAlign: textAlign,
        textDirection: textDirection,
        locale: locale,
        softWrap: softWrap,
        overflow: overflow,
        textScaleFactor: textScaleFactor,
        maxLines: maxLines,
        semanticsLabel: semanticsLabel,
        textWidthBasis: textWidthBasis,
      );
    }

    final TextStyle matchedStyle =
    (this.matchedStyle ?? style ?? defaultTextStyle.style).copyWith(
      color: matchedColor ?? Theme.of(context).colorScheme.primary,
    );

    final List<TextSpan> texts = _generateTextSpan(text, matchedStyle);

    return RichText(
      text: TextSpan(
        style: style ?? defaultTextStyle.style,
        children: texts,
      ),
      textAlign: textAlign ?? defaultTextStyle.textAlign ?? TextAlign.start,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap ?? defaultTextStyle.softWrap,
      overflow: overflow ?? defaultTextStyle.overflow,
      textScaleFactor: textScaleFactor ?? MediaQuery.textScaleFactorOf(context),
      maxLines: maxLines ?? defaultTextStyle.maxLines,
      strutStyle: strutStyle,
      textWidthBasis: textWidthBasis ?? defaultTextStyle.textWidthBasis,
      textHeightBehavior: defaultTextStyle.textHeightBehavior ??
          DefaultTextHeightBehavior.maybeOf(context),
    );
  }
}
