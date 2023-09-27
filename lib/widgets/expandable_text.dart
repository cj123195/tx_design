import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../localizations.dart';
import 'expandable_text_theme.dart';

/// 一组具有单一样式的可展开文本。
///
/// [expanded]用来初始化是否展开。
/// [collapsedLines]用来设置折叠时的文字行数
///
/// 参考[Text]
class TxExpandableText extends StatefulWidget {
  /// 创建可展开文本小部件。
  ///
  /// 如果[style]参数为空，则文本将使用最接近的封闭[DefaultTextStyle]中的样式。
  ///
  /// [data]参数不能为空。
  const TxExpandableText(
    this.data, {
    super.key,
    this.collapsedLines,
    this.style,
    this.toggleButtonTextStyle,
    this.expanded,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.textScaleFactor,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
  });

  /// 要显示的文本。
  final String data;

  /// 是否展开
  ///
  /// 默认值为false
  final bool? expanded;

  /// 如果非空，则此文本使用的样式。
  ///
  /// 如果样式的“inherit”属性为真，该样式将与最接近的外围[DefaultTextStyle]合并。
  /// 否则，该样式将替换最接近的外围[DefaultTextStyle]。
  final TextStyle? style;

  /// 如果值为 null，则使用[TxExpandableTextThemeData.toggleButtonTextStyle]，
  /// 如果它也为null，则使用[style]并修改文字颜色为[ColorScheme.primary]，
  /// 如果它也为null，则使用[DefaultTextStyle]并修改文字颜色为[ColorScheme.primary]。
  final TextStyle? toggleButtonTextStyle;

  /// {@macro flutter.paintings.textPainter.strutStyle}
  final StrutStyle? strutStyle;

  /// 文本应该如何水平对齐。
  final TextAlign? textAlign;

  /// 文本的方向性。
  ///
  /// 这决定了如何解释 [textAlign] 值，如 [TextAlign.start] 和 [TextAlign.end]。
  ///
  /// 这也用于消除如何呈现双向文本的歧义。 例如，如果 [data] 是一个英语短语，后跟一个希伯来语
  /// 短语，在 [TextDirection.ltr] 上下文中，英语短语将在左侧，希伯来语短语在其右侧，
  /// 而在 [TextDirection.rtl] 上下文中 上下文中，英语短语将在右侧，希伯来语短语将在其左侧。
  ///
  /// 默认为环境[Directionality]，如果有的话。
  final TextDirection? textDirection;

  /// 当相同的 Unicode 字符可以根据区域设置以不同方式呈现时，用于选择字体。
  ///
  /// 很少需要设置此属性。 默认情况下，它的值是从带有“Localizations.localeOf(context)”的
  /// 封闭应用程序继承的。
  final Locale? locale;

  /// 文本是否应该在软换行符处中断。
  ///
  /// 如果为 false，文本中的字形将被定位为好像有无限的水平空间。
  final bool? softWrap;

  /// 每个逻辑像素的字体像素数。
  ///
  /// 例如，如果文本比例因子为 1.5，则文本将比指定的字体大小大 50%。
  ///
  /// 作为 textScaleFactor 提供给构造函数的值。 如果为 null，将使用从环境 [MediaQuery]
  /// 获得的 [MediaQueryData.textScaleFactor]，如果范围内没有 [MediaQuery]，则为 1.0。
  final double? textScaleFactor;

  /// 文本折叠后的行数
  ///
  /// 如果值为 null，则使用[TxExpandableTextThemeData.collapsedLines]，如果它也为null,
  /// 则默认值为2
  final int? collapsedLines;

  /// {@template flutter.widgets.Text.semanticsLabel}
  /// 此文本的替代语义标签。
  ///
  /// 如果存在，此小部件的语义将包含此值而不是实际文本。 这将覆盖直接应用于 [TextSpan] 的
  /// 任何语义标签。
  ///
  /// 这对于用全文值替换缩写或速记很有用：
  ///
  /// ```dart
  /// Text(r'$$', semanticsLabel: 'Double dollars')
  /// ```
  /// {@endtemplate}
  final String? semanticsLabel;

  /// {@macro flutter.paintings.textPainter.textWidthBasis}
  final TextWidthBasis? textWidthBasis;

  /// {@macro dart.ui.textHeightBehavior}
  final ui.TextHeightBehavior? textHeightBehavior;

  /// 绘制选区时使用的颜色。
  final Color? selectionColor;

  @override
  State<TxExpandableText> createState() => _TxExpandableTextState();
}

class _TxExpandableTextState extends State<TxExpandableText> {
  static const String _ellipsizeText = '...';
  late bool _expanded;

  @override
  void initState() {
    _expanded = widget.expanded ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);
    final TxExpandableTextThemeData expandableTextTheme =
        TxExpandableTextTheme.of(context);
    TextStyle? effectiveTextStyle = widget.style;
    if (widget.style == null || widget.style!.inherit) {
      effectiveTextStyle = defaultTextStyle.style.merge(widget.style);
    }
    if (MediaQuery.boldTextOf(context)) {
      effectiveTextStyle = effectiveTextStyle!
          .merge(const TextStyle(fontWeight: FontWeight.bold));
    }
    final TextStyle? buttonStyle = (widget.toggleButtonTextStyle ??
            expandableTextTheme.toggleButtonTextStyle ??
            effectiveTextStyle)
        ?.copyWith(color: Theme.of(context).colorScheme.primary);

    final TextAlign textAlign =
        widget.textAlign ?? defaultTextStyle.textAlign ?? TextAlign.start;
    // 如果为 null，RichText 使用 Localizations.localeOf 获取默认值
    final bool softWrap = widget.softWrap ?? defaultTextStyle.softWrap;
    final double textScaleFactor =
        widget.textScaleFactor ?? MediaQuery.textScaleFactorOf(context);
    final TextWidthBasis textWidthBasis =
        widget.textWidthBasis ?? defaultTextStyle.textWidthBasis;
    final TextHeightBehavior? textHeightBehavior = widget.textHeightBehavior ??
        defaultTextStyle.textHeightBehavior ??
        DefaultTextHeightBehavior.maybeOf(context);
    final Color? selectionColor = widget.selectionColor ??
        DefaultSelectionStyle.of(context).selectionColor;

    TextSpan textSpan = TextSpan(text: widget.data, style: effectiveTextStyle);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        assert(constraints.hasBoundedWidth);

        final int collapsedLines =
            widget.collapsedLines ?? expandableTextTheme.collapsedLines ?? 2;
        int? maxLines;

        /// 文字尺寸
        final TextPainter textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
          maxLines: collapsedLines,
          strutStyle: widget.strutStyle,
          textHeightBehavior: textHeightBehavior,
          textAlign: textAlign,
          locale: widget.locale,
          textScaleFactor: textScaleFactor,
          textWidthBasis: textWidthBasis,
        )..layout(
            minWidth: 0,
            maxWidth: constraints.maxWidth,
          );
        final Size textSize = textPainter.size;

        if (textPainter.didExceedMaxLines) {
          final TxLocalizations localizations = TxLocalizations.of(context);

          if (_expanded) {
            final WidgetSpan collapsedSpan = WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: InkWell(
                onTap: () => setState(() => _expanded = false),
                child: Text(
                  localizations.collapsedButtonLabel,
                  style: buttonStyle,
                ),
              ),
            );
            textSpan = TextSpan(children: [textSpan, collapsedSpan]);
          } else {
            maxLines = collapsedLines;

            /// 收起/展开按钮
            final WidgetSpan expandedBtn = WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: InkWell(
                onTap: () => setState(() => _expanded = true),
                child: Text(localizations.moreButtonLabel, style: buttonStyle),
              ),
            );

            // 省略号
            final TextSpan ellipsizeText = TextSpan(
              text: _ellipsizeText,
              style: effectiveTextStyle,
            );

            /// 按钮尺寸
            textPainter.text = TextSpan(
              text: ' ${localizations.moreButtonLabel} ',
              style: buttonStyle,
            );
            textPainter.layout(
              minWidth: 0,
              maxWidth: constraints.maxWidth,
            );
            final Size btnSize = textPainter.size;

            /// 省略号尺寸
            textPainter.text = ellipsizeText;
            textPainter.layout(
              minWidth: 0,
              maxWidth: constraints.maxWidth,
            );
            final Size ellipsizeSize = textPainter.size;

            textPainter.text = TextSpan(
                text: '${widget.data} ${localizations.moreButtonLabel}');
            textPainter.layout(
              minWidth: 0,
              maxWidth: constraints.maxWidth,
            );

            /// 计算标题最大位置
            final TextPosition pos = textPainter.getPositionForOffset(Offset(
              textSize.width - btnSize.width - ellipsizeSize.width,
              textSize.height,
            ));
            final int? endIndex = textPainter.getOffsetBefore(pos.offset);
            textSpan = TextSpan(
              text: widget.data.substring(0, endIndex),
              children: [ellipsizeText, expandedBtn],
              style: effectiveTextStyle,
            );
          }
        }

        final SelectionRegistrar? registrar =
            SelectionContainer.maybeOf(context);
        Widget result = RichText(
          textAlign: textAlign,
          textDirection: widget.textDirection,
          // 如果为空，RichText 使用 Directionality.of 获取默认值。
          locale: widget.locale,
          // 如果为 null，RichText 使用 Localizations.localeOf 获取默认值
          softWrap: softWrap,
          overflow: TextOverflow.visible,
          maxLines: maxLines,
          textScaleFactor: textScaleFactor,
          strutStyle: widget.strutStyle,
          textWidthBasis: textWidthBasis,
          textHeightBehavior: textHeightBehavior,
          selectionRegistrar: registrar,
          selectionColor: selectionColor,
          text: textSpan,
        );
        if (registrar != null) {
          result = MouseRegion(
            cursor: SystemMouseCursors.text,
            child: result,
          );
        }
        if (widget.semanticsLabel != null) {
          result = Semantics(
            textDirection: widget.textDirection,
            label: widget.semanticsLabel,
            child: ExcludeSemantics(
              child: result,
            ),
          );
        }
        return result;
      },
    );
  }
}
