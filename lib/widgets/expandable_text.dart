import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../localizations.dart';
import 'expandable_text_theme.dart';

enum TxTextOverflow {
  clip,
  ellipsis,
}

/// 在文本超出指定行数之后，会显示 展开/收起 按钮的文本展示组件
///
/// 用例1: 常规使用
/// TxExpandableText(
///   '一大段文字...',
///   collapsedLines: 2,
///   textStyle: TextStyle(color: Colors.blue),
/// )
///
/// 用例2：特性化使用-比如 一段文字结尾显示的是 编辑，而点击编辑按钮之后要做一些事, 且显示样式不变
/// TxExpandableText(
///   '一大段文字...',
///   collapsedLines: 2, // 这两个长度也要设置一致
///   textStyle: TextStyle(color: Colors.blue),
///   collapseButtonLabel: '编辑',
///   expandable: false,  // 设置为不可展开
///   onToggle: onToggle, // 执行按钮操作事件
/// )
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
    this.maxLines,
    this.style,
    this.collapseButtonLabel,
    this.expandButtonLabel,
    this.collapseIcon,
    this.expandIcon,
    this.toggleButtonForegroundColor,
    this.toggleButtonTextStyle,
    this.expanded,
    this.expandable = true,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.textScaler,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
    this.onToggle,
    this.overflow,
  });

  /// 要显示的文本。
  final String data;

  /// 是否展开
  ///
  /// 默认值为false
  final bool? expanded;

  ///  是否可展开
  ///
  /// 值为 true 时，文字可展开，否则不可展开
  ///
  /// 当用户需要点击尾部按钮执行其他操作，如跳转到详情页时，将此值设置为 false，并传递
  /// [onToggle] 事件执行用户自定义操作。
  ///
  /// 默认值为 true
  final bool expandable;

  /// 如果非空，则此文本使用的样式。
  ///
  /// 如果样式的“inherit”属性为真，该样式将与最接近的外围[DefaultTextStyle]合并。
  /// 否则，该样式将替换最接近的外围[DefaultTextStyle]。
  final TextStyle? style;

  /// 展开/折叠按钮的文字样式
  ///
  /// 如果值为 null，则使用[TxExpandableTextThemeData.toggleButtonTextStyle]，
  /// 如果它也为null，则使用[style]并修改文字颜色为[ColorScheme.primary]，
  /// 如果它也为null，则使用[DefaultTextStyle]并修改文字颜色为[toggleButtonForegroundColor]。
  final TextStyle? toggleButtonTextStyle;

  /// 展开/折叠按钮的文字颜色
  ///
  /// 如果值为 null，则使用 [TxExpandableTextThemeData.toggleButtonForegroundColor]，
  /// 如果它也为null，则使用 [ColorScheme.primary]，
  final Color? toggleButtonForegroundColor;

  /// 参考 [Text.strutStyle]
  final StrutStyle? strutStyle;

  /// 参考 [Text.textAlign]
  final TextAlign? textAlign;

  /// 参考 [Text.textDirection]
  final TextDirection? textDirection;

  /// 参考 [Text.locale]
  final Locale? locale;

  /// 参考 [Text.softWrap]
  final bool? softWrap;

  /// 参考 [Text.textScaler]
  /// 获得的 [MediaQueryData.textScaler]，如果范围内没有 [MediaQuery]，则为 1.0。
  final TextScaler? textScaler;

  /// 文本折叠后的行数
  ///
  /// 如果值为 null，则使用[TxExpandableTextThemeData.collapsedLines]，如果它也为null,
  /// 则默认值为2
  final int? collapsedLines;

  /// 文本展开后的最大显示行数
  ///
  /// 如果值为 null，默认值为 null，此时将展示全部文字。
  final int? maxLines;

  /// 折叠按钮文字
  ///
  /// 如果值为 null，则使用[TxLocalizations.collapsedButtonLabel]
  final String? collapseButtonLabel;

  /// 展开按钮文字
  ///
  /// 如果值为 null，则使用 [TxLocalizations.moreButtonLabel]
  final String? expandButtonLabel;

  /// 折叠按钮
  ///
  /// 如果值为 null，则使用 [TextSpan] 并设置 text 为 [collapseButtonLabel]
  final Widget? collapseIcon;

  /// 展开按钮
  ///
  /// 如果值为 null，则使用 [TextSpan] 并设置 text 为 [expandButtonLabel]
  final Widget? expandIcon;

  /// 参考 [Text.semanticsLabel]
  final String? semanticsLabel;

  /// 参考 [Text.textWidthBasis]
  final TextWidthBasis? textWidthBasis;

  /// 参考 [Text.textHeightBehavior]
  final ui.TextHeightBehavior? textHeightBehavior;

  /// 参考 [Text.selectionColor]
  final Color? selectionColor;

  /// 文字溢出时处理方式
  ///
  /// 值为 null 时，则使用[TxExpandableTextThemeData.overflow]，
  /// 如果这也为 null，默认值为 [TxTextOverflow.ellipsis]
  final TxTextOverflow? overflow;

  /// 展开/折叠切换回调
  ///
  /// 参数为展开状态，true 表示展开，false 表示折叠
  final ValueChanged<bool>? onToggle;

  @override
  State<TxExpandableText> createState() => _TxExpandableTextState();
}

class _TxExpandableTextState extends State<TxExpandableText> {
  static const String _ellipsizeText = '\u2026';
  late bool _expanded;

  // 切换状态
  void _onToggle() {
    if (widget.onToggle != null) {
      widget.onToggle!(!_expanded);
    }
    if (widget.expandable) {
      setState(() {
        _expanded = !_expanded;
      });
    }
  }

  // 文字样式
  TextStyle _textStyle(DefaultTextStyle defaults) {
    TextStyle textStyle;
    if (widget.style == null || widget.style!.inherit) {
      textStyle = defaults.style.merge(widget.style);
    } else {
      textStyle = widget.style!;
    }
    if (MediaQuery.boldTextOf(context)) {
      textStyle = textStyle.merge(const TextStyle(fontWeight: FontWeight.bold));
    }
    return textStyle;
  }

  // 切换按钮
  InlineSpan _toggleButton(
    TextStyle style,
    Color color,
    String label,
    Widget? child,
  ) {
    if (child != null) {
      return WidgetSpan(
        child: DefaultTextStyle(
          style: style.copyWith(color: color),
          child: IconTheme(
            data: IconThemeData(color: color),
            child: GestureDetector(
              onTap: _onToggle,
              child: child,
            ),
          ),
        ),
      );
    }

    return TextSpan(
      text: label,
      style: style.copyWith(color: color),
      recognizer: TapGestureRecognizer()..onTap = _onToggle,
      // recognizer:
    );
  }

  @override
  void initState() {
    _expanded = widget.expanded ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);
    final TxExpandableTextThemeData theme = TxExpandableTextTheme.of(context);
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    final TextStyle textStyle = _textStyle(defaultTextStyle);

    final TextAlign textAlign =
        widget.textAlign ?? defaultTextStyle.textAlign ?? TextAlign.start;
    // 如果为 null，RichText 使用 Localizations.localeOf 获取默认值
    final bool softWrap = widget.softWrap ?? defaultTextStyle.softWrap;
    final TextScaler textScaler =
        widget.textScaler ?? MediaQuery.textScalerOf(context);
    final TextWidthBasis textWidthBasis =
        widget.textWidthBasis ?? defaultTextStyle.textWidthBasis;
    final TextHeightBehavior? textHeightBehavior = widget.textHeightBehavior ??
        defaultTextStyle.textHeightBehavior ??
        DefaultTextHeightBehavior.maybeOf(context);
    final Color? selectionColor = widget.selectionColor ??
        DefaultSelectionStyle.of(context).selectionColor;
    final TextDirection textDirection =
        widget.textDirection ?? Directionality.of(context);
    final Locale locale = widget.locale ?? Localizations.localeOf(context);

    TextSpan textSpan = TextSpan(text: widget.data, style: textStyle);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        assert(constraints.hasBoundedWidth);

        /// 文字尺寸
        final int collapsedLines =
            widget.collapsedLines ?? theme.collapsedLines ?? 2;
        final TextPainter painter = TextPainter(
          text: TextSpan(text: widget.data),
          maxLines: collapsedLines,
          textDirection: textDirection,
          strutStyle: widget.strutStyle,
          textHeightBehavior: textHeightBehavior,
          textAlign: textAlign,
          locale: locale,
          textScaler: textScaler,
          textWidthBasis: textWidthBasis,
        )..layout(maxWidth: constraints.maxWidth);
        final Size textSize = painter.size;

        if (painter.didExceedMaxLines) {
          final TxLocalizations localizations = TxLocalizations.of(context);
          final TextStyle buttonTextStyle = widget.toggleButtonTextStyle ??
              theme.toggleButtonTextStyle ??
              textStyle;
          final Color buttonColor = widget.toggleButtonForegroundColor ??
              theme.toggleButtonForegroundColor ??
              colorScheme.primary;

          InlineSpan button;
          bool needClipData = true; // 是否需要截取文字
          if (_expanded) {
            button = _toggleButton(
              buttonTextStyle,
              buttonColor,
              widget.collapseButtonLabel ?? localizations.collapsedButtonLabel,
              widget.collapseIcon,
            );
            // 计算文字 + 按钮的总行数是否超过maxLines，如果溢出，则需要截取文字
            textSpan = TextSpan(children: [textSpan, button]);
            painter
              ..text = textSpan
              ..maxLines = widget.maxLines
              ..layout(maxWidth: constraints.maxWidth);
            needClipData = painter.didExceedMaxLines;
          } else {
            button = _toggleButton(
              buttonTextStyle,
              buttonColor,
              widget.expandButtonLabel ?? localizations.moreButtonLabel,
              widget.expandIcon,
            );
          }

          if (needClipData) {
            painter
              ..text = button
              ..layout(maxWidth: constraints.maxWidth);
            final Size btnSize = painter.size;

            Size ellipsizeSize = Size.zero;
            final TxTextOverflow overflow =
                widget.overflow ?? theme.overflow ?? TxTextOverflow.ellipsis;
            TextSpan? ellipsizeText;
            if (overflow == TxTextOverflow.ellipsis) {
              ellipsizeText = TextSpan(text: _ellipsizeText, style: textStyle);
              painter
                ..text = ellipsizeText
                ..layout(maxWidth: constraints.maxWidth);
              ellipsizeSize = painter.size;
            }

            painter
              ..text = TextSpan(
                text: widget.data,
                children: [if (ellipsizeText != null) ellipsizeText, button],
                style: textStyle,
              )
              ..layout(maxWidth: constraints.maxWidth);

            final TextPosition pos = painter.getPositionForOffset(Offset(
              textSize.width - btnSize.width - ellipsizeSize.width,
              textSize.height,
            ));
            final int? endIndex = painter.getOffsetBefore(pos.offset);
            textSpan = TextSpan(
              text: widget.data.substring(0, endIndex),
              children: [if (ellipsizeText != null) ellipsizeText, button],
              style: textStyle,
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
          maxLines: _expanded ? widget.maxLines : collapsedLines,
          textScaler: textScaler,
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

///  TODO 富文本组件
///
/// 与 [RichText] 不同的是，当设置了 [maxLines] 并且文字的长度大于 [maxLines]，此时仅会
/// 隐藏 [text] 文本的内容。
// class TxRichText extends StatelessWidget {
//   const TxRichText({
//     required this.text,
//     required this.fixedSpans,
//     this.style,
//     this.alwaysShowFixedSpans = true,
//     super.key,
//     this.textAlign,
//     this.textDirection,
//     this.softWrap,
//     this.overflow,
//     this.textScaler,
//     this.maxLines = 2,
//     this.locale,
//     this.strutStyle,
//     this.textWidthBasis,
//     this.textHeightBehavior,
//     this.selectionRegistrar,
//     this.selectionColor,
//   });
//
//   /// 要在此小组件中显示的文本。
//   final String text;
//
//   /// 如果非空，则此文本使用的样式。
//   ///
//   /// 如果样式的“inherit”属性为真，该样式将与最接近的外围[DefaultTextStyle]合并。
//   /// 否则，该样式将替换最接近的外围[DefaultTextStyle]。
//   final TextStyle? style;
//
//   /// 固定在尾部的 span
//   final List<InlineSpan> fixedSpans;
//
//   /// 是否一直显示固定组件
//   ///
//   /// 值为 false 且[maxLines] 不为 null 时，当 [text] 行数没有超过 [maxLines] 时，
//   /// 不显示 [fixedSpans]。
//   final bool alwaysShowFixedSpans;
//
//   /// 参考 [RichText.textAlign]
//   final TextAlign? textAlign;
//
//   /// 参考 [RichText.textDirection]
//   final TextDirection? textDirection;
//
//   /// 参考 [RichText.softWrap]
//   final bool? softWrap;
//
//   /// 参考 [RichText.overflow]
//   final TxTextOverflow? overflow;
//
//   /// 参考 [RichText.textScaler]
//   final TextScaler? textScaler;
//
//   /// 参考 [RichText.maxLines]
//   final int? maxLines;
//
//   /// 参考 [RichText.locale]
//   final Locale? locale;
//
//   /// 参考 [RichText.strutStyle]
//   final StrutStyle? strutStyle;
//
//   /// 参考 [RichText.textWidthBasis]
//   final TextWidthBasis? textWidthBasis;
//
//   /// 参考 [RichText.textHeightBehavior]
//   final ui.TextHeightBehavior? textHeightBehavior;
//
//   /// 参考 [RichText.selectionRegistrar]
//   final SelectionRegistrar? selectionRegistrar;
//
//   /// 参考 [RichText.selectionColor]
//   final Color? selectionColor;
//
//   static const String _ellipsize = '\u2026';
//
//   // 文字样式
//   TextStyle _textStyle(BuildContext context, DefaultTextStyle defaults) {
//     TextStyle textStyle;
//     if (style == null || style!.inherit) {
//       textStyle = defaults.style.merge(style);
//     } else {
//       textStyle = style!;
//     }
//     if (MediaQuery.boldTextOf(context)) {
//       textStyle = textStyle.merge(
//       const TextStyle(fontWeight: FontWeight.bold),
//       );
//     }
//     return textStyle;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);
//
//     final TextStyle style = _textStyle(context, defaultTextStyle);
//
//     final TextAlign textAlign =
//         this.textAlign ?? defaultTextStyle.textAlign ?? TextAlign.start;
//     // 如果为 null，RichText 使用 Localizations.localeOf 获取默认值
//     final bool softWrap = this.softWrap ?? defaultTextStyle.softWrap;
//     final TextScaler textScaler =
//         this.textScaler ?? MediaQuery.textScalerOf(context);
//     final TextWidthBasis textWidthBasis =
//         this.textWidthBasis ?? defaultTextStyle.textWidthBasis;
//     final TextHeightBehavior? textHeightBehavior = this.textHeightBehavior ??
//         defaultTextStyle.textHeightBehavior ??
//         DefaultTextHeightBehavior.maybeOf(context);
//     final Color? selectionColor =
//         this.selectionColor ??
//         DefaultSelectionStyle.of(context).selectionColor;
//     final TextDirection textDirection =
//         this.textDirection ?? Directionality.of(context);
//     final Locale locale = this.locale ?? Localizations.localeOf(context);
//
//     return LayoutBuilder(
//       builder: (BuildContext context, BoxConstraints constraints) {
//         assert(constraints.hasBoundedWidth);
//
//         TextSpan textSpan = TextSpan(text: text, style: style);
//
//         final TextPainter painter = TextPainter(
//           text: textSpan,
//           maxLines: maxLines,
//           textDirection: textDirection,
//           strutStyle: strutStyle,
//           textHeightBehavior: textHeightBehavior,
//           textAlign: textAlign,
//           locale: locale,
//           textScaler: textScaler,
//           textWidthBasis: textWidthBasis,
//         )..layout(maxWidth: constraints.maxWidth);
//         final Size textSize = painter.size;
//
//         if (alwaysShowFixedSpans ||
//             (painter..layout(maxWidth: constraints.maxWidth))
//                 .didExceedMaxLines) {
//           textSpan = TextSpan(children: [textSpan, ...fixedSpans]);
//           painter
//             ..text = textSpan
//             ..layout(maxWidth: constraints.maxWidth);
//         }
//
//         if (painter.didExceedMaxLines) {
//           final List<InlineSpan> spans = fixedSpans;
//
//           double fixedWidth = 0;
//           for (InlineSpan span in fixedSpans) {
//             painter
//               ..text = span
//               ..layout(maxWidth: constraints.maxWidth);
//             fixedWidth += painter.size.width;
//           }
//
//           if (overflow == TxTextOverflow.ellipsis) {
//             final TextSpan span = TextSpan(text: _ellipsize, style: style);
//             painter
//               ..text = span
//               ..layout(maxWidth: constraints.maxWidth);
//             fixedWidth += painter.size.width;
//             spans.insert(0, span);
//           }
//
//           painter
//             ..text = textSpan
//             ..layout(maxWidth: constraints.maxWidth);
//           final TextPosition pos = painter.getPositionForOffset(Offset(
//             textSize.width - fixedWidth,
//             textSize.height,
//           ));
//           final int? endIndex = painter.getOffsetBefore(pos.offset);
//           textSpan = TextSpan(
//             children: [
//               TextSpan(text: text.substring(0, endIndex), style: style),
//               ...spans,
//             ],
//           );
//         }
//
//         final SelectionRegistrar? registrar =
//             SelectionContainer.maybeOf(context);
//         Widget result = RichText(
//           textAlign: textAlign,
//           textDirection: textDirection,
//           // 如果为空，RichText 使用 Directionality.of 获取默认值。
//           locale: locale,
//           // 如果为 null，RichText 使用 Localizations.localeOf 获取默认值
//           softWrap: softWrap,
//           overflow: TextOverflow.visible,
//           maxLines: maxLines,
//           textScaler: textScaler,
//           strutStyle: strutStyle,
//           textWidthBasis: textWidthBasis,
//           textHeightBehavior: textHeightBehavior,
//           selectionRegistrar: registrar,
//           selectionColor: selectionColor,
//           text: textSpan,
//         );
//         if (registrar != null) {
//           result = MouseRegion(
//             cursor: SystemMouseCursors.text,
//             child: result,
//           );
//         }
//         return result;
//       },
//     );
//   }
// }
