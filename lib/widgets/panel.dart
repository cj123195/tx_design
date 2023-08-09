import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'panel_theme.dart';

/// 面板样式
enum PanelStyle {
  /// 列表样式
  list,

  /// 卡片样式
  card,
}

/// [TxPanel.leading]在面板布局中所要放置的位置
enum LeadingControlAffinity {
  /// [TxPanel.leading]会被放置到[TxPanel.title]之前
  /// 此时[TxPanel.footer]与[TxPanel.content]将会与[TxPanel.leading]对齐
  header,

  /// [TxPanel.leading]会被放置整个面板的最前边
  /// 此时[TxPanel.footer]与[TxPanel.content]将会与[TxPanel.title]对其
  panel,
}

/// 通用面板组件
class TxPanel extends StatelessWidget {
  const TxPanel({
    required this.title,
    super.key,
    this.leading,
    this.subtitle,
    this.trailing,
    this.footer,
    this.content,
    this.onTap,
    this.padding,
    this.margin,
    this.dense = false,
    this.panelColor,
    this.leadingControlAffinity,
    this.verticalGap,
    this.horizontalTitleGap,
    this.enabled = true,
    this.selected = false,
    this.visualDensity,
    this.shape,
    this.selectedColor,
    this.iconColor,
    this.textColor,
    this.onLongPress,
    this.mouseCursor,
    this.focusColor,
    this.hoverColor,
    this.focusNode,
    this.autofocus = false,
    this.selectedPanelColor,
    this.enableFeedback,
    this.minLeadingWidth,
    this.style,
  });

  /// 在标题前显示的小部件。
  ///
  /// 通常是 [Icon] 或 [CircleAvatar] 小部件。
  final Widget? leading;

  /// 面板的标题
  ///
  /// 通常是 [Text] 小部件。
  ///
  /// 这不应该换行。 要强制执行单行限制，请使用
  /// [Text.maxLines]。
  final Widget? title;

  /// 标题下方显示的附加内容。
  ///
  /// 通常是 [Text] 小部件。
  ///
  /// 副标题的默认 [TextStyle] 取决于 [TextTheme.bodyMedium] 除了[TextStyle.color].
  /// [TextStyle.color] 取决于 [enabled] 和 [selected]的值。
  ///
  /// 当 [enabled]为false时, 文字颜色设置为 [ThemeData.disabledColor].
  ///
  /// 当[selected]为false时，文字颜色设置[TextTheme.bodySmall] 的颜色。
  final Widget? subtitle;

  /// 在标题后显示的小部件。
  ///
  /// 通常是 [Icon] 小部件。
  final Widget? trailing;

  /// 展示在面板最底部的小部件。
  ///
  /// 通常为一组操作按钮
  final Widget? footer;

  /// 展示在[title]与[footer]之间的小部件
  ///
  /// 通常为一组信息展示
  final Widget? content;

  /// 面板是否是垂直密集列表的一部分。
  ///
  /// 默认值为false。
  ///
  /// 紧凑面板默认会有较小的字体和较小的间距
  final bool? dense;

  /// 定义面板布局的紧凑程度
  ///
  /// {@macro flutter.material.themedata.visualDensity}
  ///
  /// 参考:
  ///
  ///  * [ThemeData.visualDensity]，指定[Theme]中的所有小部件的[visualDensity] 。
  final VisualDensity? visualDensity;

  /// 定义面板[InkResponse.customBorder] and [Ink.decoration]的形状
  ///
  /// 如果此属性为空，则将使用矩形 [RoundedRectangleBorder]。。
  final ShapeBorder? shape;

  /// 定义选择面板时用于图标和文本的颜色。
  ///
  /// 如果此属性为空，则使用[ColorScheme.primary]。
  final Color? selectedColor;

  /// 定义[leading]和[trailing]图标的默认颜色。
  ///
  /// 如果此属性为空，则使用[TxPanelThemeData.iconColor]。
  final Color? iconColor;

  /// 定义[title]和[subtitle]的默认颜色。
  ///
  /// 如果此属性为空，则使用[ColorScheme.primary]。
  final Color? textColor;

  /// 面板的内边距
  ///
  /// 插入一个 [TxPanel] 的内部：它的 [leading]、[title]、[subtitle]、[trailing]、
  /// [content] 和 [footer] 小部件。
  ///
  /// 如果为空，则使用“EdgeInsets.symmetric(horizontal: 12.0)”。
  final EdgeInsetsGeometry? padding;

  /// 此面板是否是交互式的。
  ///
  /// 如果为 false，则面板的样式为来自当前 [Theme]的disabledColor 并且 [onTap] 和
  /// [onLongPress] 回调是无效。
  final bool enabled;

  /// 当用户点击面板时调用
  ///
  /// 如果 [enabled] 为 false，则无效。
  final GestureTapCallback? onTap;

  /// 当用户长按此面板时调用
  ///
  /// 如果 [enabled] 为 false，则无效。
  final GestureLongPressCallback? onLongPress;

  /// 鼠标指针进入或悬停小部件时的光标。
  ///
  /// 如果 [mouseCursor] 是 [MaterialStateProperty<MouseCursor>]，
  /// [MaterialStateProperty.resolve] 用于以下 [MaterialState]：
  ///
  ///  * [MaterialState.selected].
  ///  * [MaterialState.disabled].
  /// {@endtemplate}
  ///
  /// 如果为 null，则使用 [MaterialStateMouseCursor.clickable]。
  ///
  /// 参考:
  ///
  /// * [MaterialStateMouseCursor]，可用于创建[MouseCursor]
  /// 这也是一个 [MaterialStateProperty<MouseCursor>]。
  final MouseCursor? mouseCursor;

  /// 如果此图块也已 [enabled]，则图标和文本将以相同的颜色呈现。
  ///
  /// 默认情况下，所选颜色是[ColorScheme.primary]。
  final bool selected;

  /// 面板 的 [Material] 具有输入焦点时的颜色。
  final Color? focusColor;

  /// 当指针悬停在面板上时，面板 [Material] 的颜色。
  final Color? hoverColor;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  /// {@macro flutter.widgets.Focus.autofocus}
  final bool autofocus;

  /// 当 [selected] 为 false 时，定义 `Panel` 的背景颜色。
  ///
  /// 当值为 null 时，[panelColor] 设置为 [CardTheme.color]如果它不为空，
  /// 如果它为空则为[ColorScheme.background]。
  final Color? panelColor;

  /// 定义当 [selected] 为true时面板的背景颜色
  ///
  /// 当值为 null 时，`selectedBackground` 设置为[ColorScheme.primaryContainer]。
  final Color? selectedPanelColor;

  /// 检测到的手势是否应提供声音和/或触觉反馈。
  ///
  /// 例如，在 Android 上点击会产生咔嗒声和启用反馈后，长按会产生短暂的振动。
  ///
  /// 当为null时，默认值为true。
  /// {@endtemplate}
  ///
  /// 参考:
  ///
  /// * [Feedback] 用于为某些操作提供特定于平台的反馈。
  final bool? enableFeedback;

  /// [title]和[leading]/[trailing]小部件之间的水平间隙。
  ///
  /// 如果为 null，则使用 [ListTileTheme.horizontalTitleGap] 的值。 如果
  /// 这也是 null，则使用默认值 16。
  final double? horizontalTitleGap;

  /// [content]、[title]、[subtitle]、[footer]小部件之间的垂直间隙。
  ///
  /// [title]与[subtitle]之间的间隙为[verticalGap]一半
  ///
  /// 默认值为12.0
  final double? verticalGap;

  /// 分配给 [ListTile.leading] 小部件的最小宽度。
  ///
  /// 如果为 null，则使用 [ListTileTheme.minLeadingWidth] 的值。
  /// 如果这也是 null，则使用默认值 40。
  final double? minLeadingWidth;

  /// 面板的外边距
  ///
  /// 面板外部与其他小部件间隔的区域。
  ///
  /// 该属性为空时，该值取决于[style]，
  /// [PanelStyle.list] 使用“EdgeInsets.symmetric(horizontal: 4.0)”。
  /// [PanelStyle.card] 使用“EdgeInsets.symmetric(horizontal: 12.0)”。
  final EdgeInsetsGeometry? margin;

  /// [leading]布局方式。
  ///
  /// [LeadingControlAffinity.header]：展示在[title]之前，此时[content]与[footer]
  /// 将会与[leading]对齐。
  /// [LeadingControlAffinity.panel]： 展示在[TxPanel]最左侧，此时[content]与[footer]
  /// 将会与[title]对齐。
  final LeadingControlAffinity? leadingControlAffinity;

  /// 面板样式
  ///
  /// [PanelStyle.list] 列表样式，该样式会有更小的[margin]。
  /// [PanelStyle.card] 卡片样式，该样式会表现的更像[Card]。
  final PanelStyle? style;

  static Iterable<Widget> dividePanels(Iterable<Widget> tiles,
      {double width = 4.0}) {
    tiles = tiles.toList();

    if (tiles.isEmpty || tiles.length == 1) {
      return tiles;
    }

    Widget wrapTile(Widget tile) {
      return DecoratedBox(
        position: DecorationPosition.foreground,
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.transparent, width: 4.0),
          ),
        ),
        child: tile,
      );
    }

    return <Widget>[
      ...tiles.take(tiles.length - 1).map(wrapTile),
      tiles.last,
    ];
  }

  Color? _iconColor(ThemeData theme, TxPanelThemeData panelTheme) {
    if (!enabled) {
      return theme.disabledColor;
    }

    if (selected) {
      return selectedColor ??
          panelTheme.selectedColor ??
          theme.listTileTheme.selectedColor ??
          theme.colorScheme.primary;
    }

    final Color? color =
        iconColor ?? panelTheme.iconColor ?? theme.listTileTheme.iconColor;
    if (color != null) {
      return color;
    }

    switch (theme.brightness) {
      case Brightness.light:
        // 为了向后兼容，默认为unselected
        // tiles 是 Colors.black45 而不是 colorScheme.onSurface.withAlpha(0x73)。
        return Colors.black45;
      case Brightness.dark:
        return null; // null - use current icon theme color
    }
  }

  Color? _textColor(
      ThemeData theme, TxPanelThemeData panelTheme, Color? defaultColor) {
    if (!enabled) {
      return theme.disabledColor;
    }

    if (selected) {
      return selectedColor ??
          panelTheme.selectedColor ??
          theme.listTileTheme.selectedColor ??
          theme.colorScheme.primary;
    }

    return textColor ??
        panelTheme.textColor ??
        theme.listTileTheme.textColor ??
        defaultColor;
  }

  bool _isDenseLayout(ThemeData theme, TxPanelThemeData panelTheme) {
    return dense ?? panelTheme.dense ?? theme.listTileTheme.dense ?? false;
  }

  TextStyle _titleTextStyle(ThemeData theme, TxPanelThemeData panelTheme) {
    final TextStyle textStyle;
    switch (style ?? PanelStyle.list) {
      case PanelStyle.card:
        textStyle = theme.textTheme.titleLarge!;
        break;
      case PanelStyle.list:
        textStyle = theme.textTheme.titleMedium!;
        break;
    }
    final Color? color = _textColor(theme, panelTheme, textStyle.color);
    return _isDenseLayout(theme, panelTheme)
        ? textStyle.copyWith(fontSize: 13.0, color: color)
        : textStyle.copyWith(color: color);
  }

  TextStyle _subtitleTextStyle(ThemeData theme, TxPanelThemeData panelTheme) {
    final Color? color = _textColor(
      theme,
      panelTheme,
      theme.textTheme.bodySmall!.color,
    );
    return _isDenseLayout(theme, panelTheme)
        ? theme.textTheme.bodyMedium!.copyWith(color: color, fontSize: 12.0)
        : theme.textTheme.bodyMedium!.copyWith(color: color);
  }

  TextStyle _contentTextStyle(ThemeData theme, TxPanelThemeData panelTheme) {
    final Color? color = _textColor(
      theme,
      panelTheme,
      theme.textTheme.bodySmall!.color,
    );
    return _isDenseLayout(theme, panelTheme)
        ? theme.textTheme.bodyMedium!.copyWith(color: color, fontSize: 12.0)
        : theme.textTheme.bodyMedium!.copyWith(color: color);
  }

  TextStyle _trailingAndLeadingTextStyle(
      ThemeData theme, TxPanelThemeData panelTheme) {
    final TextStyle textStyle = theme.textTheme.bodyMedium!;
    final Color? color = _textColor(theme, panelTheme, textStyle.color);
    return textStyle.copyWith(color: color);
  }

  Color? _backgroundColor(ThemeData theme, TxPanelThemeData panelTheme) {
    return selected
        ? selectedPanelColor ??
            panelTheme.selectedPanelColor ??
            theme.listTileTheme.selectedTileColor
        : panelColor ?? panelTheme.panelColor ?? theme.listTileTheme.tileColor;
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    final ThemeData theme = Theme.of(context);
    final TxPanelThemeData panelTheme = TxPanelTheme.of(context);
    final IconThemeData iconThemeData =
        IconThemeData(color: _iconColor(theme, panelTheme));

    TextStyle? leadingAndTrailingTextStyle;
    if (leading != null || trailing != null || this.footer != null) {
      leadingAndTrailingTextStyle =
          _trailingAndLeadingTextStyle(theme, panelTheme);
    }

    Widget? leadingIcon;
    if (leading != null) {
      leadingIcon = AnimatedDefaultTextStyle(
        style: leadingAndTrailingTextStyle!,
        duration: kThemeChangeDuration,
        child: leading!,
      );
    }

    final TextStyle titleStyle = _titleTextStyle(theme, panelTheme);
    final Widget titleText = AnimatedDefaultTextStyle(
      style: titleStyle,
      duration: kThemeChangeDuration,
      child: title ?? const SizedBox(),
    );

    Widget? subtitleText;
    TextStyle? subtitleStyle;
    if (subtitle != null) {
      subtitleStyle = _subtitleTextStyle(theme, panelTheme);
      subtitleText = AnimatedDefaultTextStyle(
        style: subtitleStyle,
        duration: kThemeChangeDuration,
        child: subtitle!,
      );
    }

    Widget? trailingIcon;
    if (trailing != null) {
      trailingIcon = AnimatedDefaultTextStyle(
        style: leadingAndTrailingTextStyle!,
        duration: kThemeChangeDuration,
        child: trailing!,
      );
    }

    Widget? content;
    TextStyle? contentStyle;
    if (this.content != null) {
      contentStyle = _contentTextStyle(theme, panelTheme);
      content = AnimatedDefaultTextStyle(
        style: contentStyle,
        duration: kThemeChangeDuration,
        child: this.content!,
      );
    }

    Widget? footer;
    if (this.footer != null) {
      footer = AnimatedDefaultTextStyle(
        style: leadingAndTrailingTextStyle!,
        duration: kThemeChangeDuration,
        child: this.footer!,
      );
    }

    const EdgeInsets defaultContentPadding = EdgeInsets.all(12.0);
    final TextDirection textDirection = Directionality.of(context);
    final EdgeInsets resolvedContentPadding = padding?.resolve(textDirection) ??
        panelTheme.padding?.resolve(textDirection) ??
        defaultContentPadding;

    final Set<MaterialState> states = <MaterialState>{
      if (!enabled || (onTap == null && onLongPress == null))
        MaterialState.disabled,
      if (selected) MaterialState.selected,
    };

    final MouseCursor effectiveMouseCursor =
        MaterialStateProperty.resolveAs<MouseCursor?>(mouseCursor, states) ??
            panelTheme.mouseCursor?.resolve(states) ??
            MaterialStateMouseCursor.clickable.resolve(states);

    final EdgeInsetsGeometry margin = this.margin ??
        panelTheme.margin ??
        (style == PanelStyle.card
            ? const EdgeInsets.all(12.0)
            : const EdgeInsets.all(4.0));
    final ShapeBorder shape = this.shape ??
        panelTheme.shape ??
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0));
    return Padding(
      padding: margin,
      child: InkWell(
        customBorder: shape,
        onTap: enabled ? onTap : null,
        onLongPress: enabled ? onLongPress : null,
        mouseCursor: effectiveMouseCursor,
        canRequestFocus: enabled,
        focusNode: focusNode,
        focusColor: focusColor,
        hoverColor: hoverColor,
        autofocus: autofocus,
        enableFeedback: enableFeedback ?? panelTheme.enableFeedback ?? true,
        child: Semantics(
          selected: selected,
          enabled: enabled,
          child: Ink(
            decoration: ShapeDecoration(
              shape: shape,
              color: _backgroundColor(theme, panelTheme),
            ),
            child: SafeArea(
              top: false,
              bottom: false,
              minimum: resolvedContentPadding,
              child: IconTheme.merge(
                data: iconThemeData,
                child: _Panel(
                  leading: leadingIcon,
                  title: titleText,
                  subtitle: subtitleText,
                  content: content,
                  footer: footer,
                  trailing: trailingIcon,
                  leadingControlAffinity:
                      leadingControlAffinity ?? LeadingControlAffinity.header,
                  isDense: _isDenseLayout(theme, panelTheme),
                  visualDensity: visualDensity ??
                      panelTheme.visualDensity ??
                      theme.visualDensity,
                  horizontalTitleGap:
                      horizontalTitleGap ?? panelTheme.horizontalTitleGap ?? 16,
                  minLeadingWidth:
                      minLeadingWidth ?? panelTheme.minLeadingWidth ?? 40,
                  verticalGap: verticalGap ?? 8.0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

// @override
// Widget build(BuildContext context) {
//    ListTile()
//
//   final ThemeData theme = Theme.of(context);
//
//   final double iconSize = dense ? 14.0 : 18.0;
//   final IconThemeData iconTheme = theme.iconTheme
//       .copyWith(color: theme.colorScheme.primary, size: iconSize);
//   final TextTheme textTheme = theme.textTheme;
//
//   final double smallSpace = dense ? 6.0 : 8.0;
//   final double largeSpace = dense ? 12.0 : 16.0;
//   final Widget smallHSpace = SizedBox(width: smallSpace);
//   final Widget smallVSpace = SizedBox(height: smallSpace);
//   final Widget largeHSpace = SizedBox(width: largeSpace);
//   final Widget largeVSpace = SizedBox(height: largeSpace);
//
//   Widget header = this.header;
//   if (header == null) {
//     final TextStyle headerStyle =
//         dense ? textTheme.titleSmall! : textTheme.titleMedium!;
//     final TextStyle subtitleStyle =
//         dense ? textTheme.overline! : textTheme.caption!;
//     header = DefaultTextStyle(style: headerStyle, child: title!);
//
//     if (subtitle != null) {
//       header = Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           header,
//           DefaultTextStyle(style: subtitleStyle, child: subtitle!)
//         ],
//       );
//     }
//
//     if (titleLeading != null || trailing != null) {
//       header = Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           if (titleLeading != null) ...[
//             IconTheme(data: iconTheme, child: titleLeading!),
//             smallHSpace
//           ],
//           Expanded(child: header),
//           if (trailing != null) ...[
//             largeHSpace,
//             DefaultTextStyle(style: subtitleStyle, child: trailing!)
//           ]
//         ],
//       );
//     }
//
//     if (leading != null) {
//       header = IntrinsicHeight(
//         child: Row(
//           children: [
//             IconTheme(data: iconTheme, child: leading!),
//             largeHSpace,
//             Expanded(child: header),
//           ],
//         ),
//       );
//     }
//   }
//
//   Widget? footer = this.footer;
//   if (footer == null && actions != null) {
//     footer = Row(
//       mainAxisAlignment: MainAxisAlignment.end,
//       children: actions!,
//     );
//   }
//
//   Widget result = header;
//   if (footer != null || content != null) {
//     result = Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         result,
//         smallVSpace,
//         if (content != null) ...[
//           smallVSpace,
//           DefaultTextStyle(style: theme.textTheme.caption!, child: content!)
//         ],
//         if (footer != null) ...[largeVSpace, footer],
//       ],
//     );
//   }
//
//   final EdgeInsetsGeometry padding =
//       this.padding ?? (EdgeInsets.all(dense ? 12.0 : 16.0));
//   result = Padding(padding: padding, child: result);
//
//   if (onTap != null) {
//     result = InkWell(
//       onTap: onTap,
//       customBorder: theme.cardTheme.shape,
//       child: result,
//     );
//   }
//
//   final EdgeInsetsGeometry margin =
//       this.margin ?? (EdgeInsets.all(dense ? 8.0 : 16.0));
//   return TxCard(
//     margin: margin,
//     color: background,
//     child: result,
//   );
// }
}

enum _PanelSlot {
  leading,
  trailing,
  content,
  title,
  subtitle,
  footer,
}

class _Panel extends RenderObjectWidget
    with SlottedMultiChildRenderObjectWidgetMixin<_PanelSlot> {
  const _Panel({
    required this.title,
    required this.isDense,
    required this.visualDensity,
    required this.horizontalTitleGap,
    required this.minLeadingWidth,
    required this.verticalGap,
    this.leading,
    this.subtitle,
    this.trailing,
    this.content,
    this.footer,
    this.leadingControlAffinity = LeadingControlAffinity.header,
  });

  final Widget? leading;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;
  final Widget? content;
  final Widget? footer;
  final bool isDense;
  final VisualDensity visualDensity;
  final double horizontalTitleGap;
  final double verticalGap;
  final double minLeadingWidth;
  final LeadingControlAffinity leadingControlAffinity;

  @override
  void updateRenderObject(BuildContext context, _RenderPanel renderObject) {
    renderObject
      ..isDense = isDense
      ..visualDensity = visualDensity
      ..horizontalTitleGap = horizontalTitleGap
      ..minLeadingWidth = minLeadingWidth
      ..leadControlAffinity = leadingControlAffinity
      ..verticalGap = verticalGap;
  }

  @override
  _RenderPanel createRenderObject(BuildContext context) {
    return _RenderPanel(
      dense: isDense,
      visualDensity: visualDensity,
      horizontalTitleGap: horizontalTitleGap,
      minLeadingWidth: minLeadingWidth,
      leadingControlAffinity: leadingControlAffinity,
      verticalGap: verticalGap,
    );
  }

  @override
  Widget? childForSlot(_PanelSlot slot) {
    switch (slot) {
      case _PanelSlot.leading:
        return leading;
      case _PanelSlot.trailing:
        return trailing;
      case _PanelSlot.content:
        return content;
      case _PanelSlot.title:
        return title;
      case _PanelSlot.subtitle:
        return subtitle;
      case _PanelSlot.footer:
        return footer;
    }
  }

  @override
  Iterable<_PanelSlot> get slots => _PanelSlot.values;
}

class _RenderPanel extends RenderBox
    with SlottedContainerRenderObjectMixin<_PanelSlot> {
  _RenderPanel({
    required bool dense,
    required VisualDensity visualDensity,
    required double horizontalTitleGap,
    required double minLeadingWidth,
    required LeadingControlAffinity leadingControlAffinity,
    required double verticalGap,
  })  : _isDense = dense,
        _visualDensity = visualDensity,
        _horizontalTitleGap = horizontalTitleGap,
        _minLeadingWidth = minLeadingWidth,
        _leadControlAffinity = leadingControlAffinity,
        _verticalGap = verticalGap;

  RenderBox? get leading => childForSlot(_PanelSlot.leading);

  RenderBox? get title => childForSlot(_PanelSlot.title);

  RenderBox? get subtitle => childForSlot(_PanelSlot.subtitle);

  RenderBox? get trailing => childForSlot(_PanelSlot.trailing);

  RenderBox? get content => childForSlot(_PanelSlot.content);

  RenderBox? get footer => childForSlot(_PanelSlot.footer);

  @override
  Iterable<RenderBox> get children {
    return <RenderBox>[
      if (leading != null) leading!,
      if (title != null) title!,
      if (subtitle != null) subtitle!,
      if (trailing != null) trailing!,
      if (content != null) content!,
      if (footer != null) footer!,
    ];
  }

  LeadingControlAffinity get leadControlAffinity {
    if (content == null && footer == null) {
      return LeadingControlAffinity.header;
    }
    return _leadControlAffinity;
  }

  LeadingControlAffinity _leadControlAffinity;

  set leadControlAffinity(LeadingControlAffinity value) {
    if (_leadControlAffinity == value) {
      return;
    }
    _leadControlAffinity = value;
    markNeedsLayout();
  }

  bool get isDense => _isDense;
  bool _isDense;

  set isDense(bool value) {
    if (_isDense == value) {
      return;
    }
    _isDense = value;
    markNeedsLayout();
  }

  VisualDensity get visualDensity => _visualDensity;
  VisualDensity _visualDensity;

  set visualDensity(VisualDensity value) {
    if (_visualDensity == value) {
      return;
    }
    _visualDensity = value;
    markNeedsLayout();
  }

  double get horizontalTitleGap => _horizontalTitleGap;
  double _horizontalTitleGap;

  double get _effectiveHorizontalTitleGap =>
      _horizontalTitleGap + visualDensity.horizontal * 2.0;

  set horizontalTitleGap(double value) {
    if (_horizontalTitleGap == value) {
      return;
    }
    _horizontalTitleGap = value;
    markNeedsLayout();
  }

  double get verticalGap => _verticalGap;
  double _verticalGap;

  double get _effectiveVerticalGap =>
      _verticalGap + visualDensity.vertical * 2.0;

  set verticalGap(double value) {
    if (_verticalGap == value) {
      return;
    }
    _verticalGap = value;
    markNeedsLayout();
  }

  double get minLeadingWidth => _minLeadingWidth;
  double _minLeadingWidth;

  set minLeadingWidth(double value) {
    if (_minLeadingWidth == value) {
      return;
    }
    _minLeadingWidth = value;
    markNeedsLayout();
  }

  @override
  bool get sizedByParent => false;

  static double _minWidth(RenderBox? box, double height) {
    return box == null ? 0.0 : box.getMinIntrinsicWidth(height);
  }

  static double _maxWidth(RenderBox? box, double height) {
    return box == null ? 0.0 : box.getMaxIntrinsicWidth(height);
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    final double minTitleWidth = _minWidth(title, height);
    final double minSubtitleWidth = _minWidth(subtitle, height);
    final double minContentWidth = _minWidth(content, height);
    final double minFooterWidth = _minWidth(footer, height);
    final double leadingWidth = leading != null
        ? math.max(leading!.getMinIntrinsicWidth(height), _minLeadingWidth) +
            _effectiveHorizontalTitleGap
        : 0.0;
    double headerWidth =
        math.max(minTitleWidth, minSubtitleWidth) + _maxWidth(trailing, height);
    if (_leadControlAffinity == LeadingControlAffinity.header) {
      headerWidth += leadingWidth;
    }
    final double width =
        math.max(math.max(headerWidth, minContentWidth), minFooterWidth);
    return _leadControlAffinity == LeadingControlAffinity.panel
        ? width + leadingWidth
        : width;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    final double maxTitleWidth = _maxWidth(title, height);
    final double maxSubtitleWidth = _maxWidth(subtitle, height);
    final double maxContentWidth = _maxWidth(content, height);
    final double maxFooterWidth = _maxWidth(footer, height);
    final double leadingWidth = leading != null
        ? math.max(leading!.getMaxIntrinsicWidth(height), _minLeadingWidth) +
            _effectiveHorizontalTitleGap
        : 0.0;
    double headerWidth =
        math.max(maxTitleWidth, maxSubtitleWidth) + _maxWidth(trailing, height);
    if (_leadControlAffinity == LeadingControlAffinity.header) {
      headerWidth += leadingWidth;
    }
    final double width =
        math.max(math.max(headerWidth, maxContentWidth), maxFooterWidth);
    return _leadControlAffinity == LeadingControlAffinity.panel
        ? width + leadingWidth
        : width;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    final double gap = _effectiveVerticalGap;
    double height = title!.getMinIntrinsicHeight(width);
    if (subtitle != null) {
      height = height + gap / 2 + subtitle!.getMinIntrinsicHeight(width);
    }
    if (content != null) {
      height = height + gap + content!.getMinIntrinsicHeight(width);
    }
    if (footer != null) {
      height = height + gap + footer!.getMinIntrinsicHeight(width);
    }

    return height;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return computeMinIntrinsicHeight(width);
  }

  @override
  double computeDistanceToActualBaseline(TextBaseline baseline) {
    assert(title != null);
    final BoxParentData parentData = title!.parentData! as BoxParentData;
    return parentData.offset.dy + title!.getDistanceToActualBaseline(baseline)!;
  }

  static Size _layoutBox(RenderBox? box, BoxConstraints constraints) {
    if (box == null) {
      return Size.zero;
    }
    box.layout(constraints, parentUsesSize: true);
    return box.size;
  }

  static void _positionBox(RenderBox box, Offset offset) {
    final BoxParentData parentData = box.parentData! as BoxParentData;
    parentData.offset = offset;
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    assert(debugCannotComputeDryLayout(
      reason:
          'Layout requires baseline metrics, which are only available after a '
          'full layout.',
    ));
    return Size.zero;
  }

  @override
  void performLayout() {
    final BoxConstraints constraints = this.constraints;
    final bool hasLeading = leading != null;
    final bool hasSubtitle = subtitle != null;
    final bool hasTrailing = trailing != null;
    final bool hasContent = content != null;
    final bool hasFooter = footer != null;
    final Offset densityAdjustment = visualDensity.baseSizeAdjustment;
    final double gap = _effectiveVerticalGap;

    final BoxConstraints maxIconHeightConstraint = BoxConstraints(
      maxHeight: (isDense ? 48.0 : 56.0) + densityAdjustment.dy,
    );
    final BoxConstraints looseConstraints = constraints.loosen();
    final BoxConstraints iconConstraints =
        looseConstraints.enforce(maxIconHeightConstraint);

    final double tileWidth = looseConstraints.maxWidth;
    final Size leadingSize = _layoutBox(leading, iconConstraints);
    final Size trailingSize = _layoutBox(trailing, iconConstraints);
    assert(
      tileWidth != leadingSize.width || tileWidth == 0.0,
      'Leading widget consumes entire tile width. Please use a sized widget, '
      'or consider replacing ListTile with a custom widget '
      '(see https://api.flutter.dev/flutter/material/ListTile-class.html#material.ListTile.4)',
    );
    assert(
      tileWidth != trailingSize.width || tileWidth == 0.0,
      'Trailing widget consumes entire tile width. Please use a sized widget, '
      'or consider replacing ListTile with a custom widget '
      '(see https://api.flutter.dev/flutter/material/ListTile-class.html#material.ListTile.4)',
    );

    final double titleStart = hasLeading
        ? math.max(_minLeadingWidth, leadingSize.width) +
            _effectiveHorizontalTitleGap
        : 0.0;
    final double adjustedTrailingWidth = hasTrailing
        ? math.max(trailingSize.width + _effectiveHorizontalTitleGap, 32.0)
        : 0.0;
    final BoxConstraints textConstraints = looseConstraints.tighten(
      width: tileWidth - titleStart - adjustedTrailingWidth,
    );
    final Size titleSize = _layoutBox(title, textConstraints);
    final Size subtitleSize = _layoutBox(subtitle, textConstraints);

    final double contentAndFooterStart =
        leadControlAffinity == LeadingControlAffinity.panel ? titleStart : 0.0;
    final BoxConstraints footerAndContentConstraints = looseConstraints.tighten(
      width: tileWidth - contentAndFooterStart,
    );
    final Size contentSize = _layoutBox(content, footerAndContentConstraints);
    final Size footerSize = _layoutBox(footer, footerAndContentConstraints);

    double headerHeight = titleSize.height;
    const double titleY = 0;
    _positionBox(title!, Offset(titleStart, titleY));

    if (hasSubtitle) {
      headerHeight = headerHeight + subtitleSize.height + gap / 2.0;
      final double subtitleY = titleSize.height + gap / 2.0;
      _positionBox(subtitle!, Offset(titleStart, subtitleY));
    }

    final double leadingY;
    final double trailingY;
    if (headerHeight > 72.0) {
      leadingY = 16.0;
      trailingY = 16.0;
    } else {
      trailingY = (headerHeight - trailingSize.height) / 2.0;
      if (leadControlAffinity == LeadingControlAffinity.panel) {
        leadingY = 16.0;
      } else {
        leadingY = math.min((headerHeight - leadingSize.height) / 2.0, 16.0);
      }
    }
    if (hasLeading) {
      _positionBox(leading!, Offset(0.0, leadingY));
    }
    if (hasTrailing) {
      _positionBox(
        trailing!,
        Offset(tileWidth - trailingSize.width, trailingY),
      );
    }

    double panelHeight = headerHeight;
    if (hasContent) {
      final double contentY = headerHeight + gap;
      panelHeight = contentY + contentSize.height;
      _positionBox(content!, Offset(contentAndFooterStart, contentY));
    }

    if (hasFooter) {
      final double footerY = panelHeight + gap;
      panelHeight = footerY + footerSize.height;
      _positionBox(footer!, Offset(contentAndFooterStart, footerY));
    }

    size = constraints.constrain(Size(tileWidth, panelHeight));
    assert(size.width == constraints.constrainWidth(tileWidth));
    assert(size.height == constraints.constrainHeight(panelHeight));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    void doPaint(RenderBox? child) {
      if (child != null) {
        final BoxParentData parentData = child.parentData! as BoxParentData;
        context.paintChild(child, parentData.offset + offset);
      }
    }

    doPaint(leading);
    doPaint(title);
    doPaint(subtitle);
    doPaint(trailing);
    doPaint(content);
    doPaint(footer);
  }

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    for (final RenderBox child in children) {
      final BoxParentData parentData = child.parentData! as BoxParentData;
      final bool isHit = result.addWithPaintOffset(
        offset: parentData.offset,
        position: position,
        hitTest: (BoxHitTestResult result, Offset transformed) {
          assert(transformed == position - parentData.offset);
          return child.hitTest(result, position: transformed);
        },
      );
      if (isHit) {
        return true;
      }
    }
    return false;
  }
}
