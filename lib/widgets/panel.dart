import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'panel_theme.dart';

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
    this.splashColor,
    this.hoverColor,
    this.focusNode,
    this.autofocus = false,
    this.selectedPanelColor,
    this.onFocusChange,
    this.enableFeedback,
    this.minLeadingWidth,
    this.titleTextStyle,
    this.subtitleTextStyle,
    this.contentTextStyle,
    this.leadingAndTrailingTextStyle,
    this.titleAlignment,
    this.highlightColor,
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
  /// 如果此属性为空，则使用[ColorScheme.onSurface]。
  final Color? textColor;

  /// TxPanel 的 [title] 的文本样式。
  ///
  /// 如果此属性为 null，则使用 [TxPanelThemeData.titleTextStyle]。如果这也为 null
  /// 且 [ThemeData.useMaterial3] 为 true，则将使用 [TextTheme.bodyLarge] 和
  /// [ColorScheme.onSurface]。否则，如果 ListTile 样式为 [ListTileStyle.list]，
  /// 则将使用 [TextTheme.titleMedium]，如果 ListTile 样式为 [ListTileStyle.drawer]，
  /// 则将使用 [TextTheme.bodyLarge]。
  final TextStyle? titleTextStyle;

  /// TxPanel 的 [subtitle] 的文本样式。
  ///
  /// 如果此属性为 null，则使用 [TxPanelThemeData.subtitleTextStyle]。如果这也是 null
  /// 并且 [ThemeData.useMaterial3] 为 true，则将使用带有 [ColorScheme.onSurfaceVariant]
  /// 的 [TextTheme.bodyMedium]，否则将使用带有 [TextTheme.bodySmall] 颜色的
  /// [TextTheme.bodyMedium]。
  final TextStyle? subtitleTextStyle;

  /// TxPanel 的 [content] 的文本样式。
  ///
  /// 如果此属性为 null，则使用 [TxPanelThemeData.contentTextStyle]。如果这也是 null
  /// 将使用带有 [TextTheme.bodyMedium]。
  final TextStyle? contentTextStyle;

  /// TxPanel 的 [leading] 和 [trailing] 的文本样式。
  ///
  /// 如果此属性为 null，则使用 [TxPanelThemeData.leadingAndTrailingTextStyle]。
  /// 如果这也是 null 并且 [ThemeData.useMaterial3] 为 true，则将使用 [TextTheme.labelSmall]
  /// 和 [ColorScheme.onSurfaceVariant]，否则将使用 [TextTheme.bodyMedium]。
  final TextStyle? leadingAndTrailingTextStyle;

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

  /// {@macro flutter.material.inkwell.onFocusChange}
  final ValueChanged<bool>? onFocusChange;

  /// 鼠标指针进入或悬停小部件时的光标。
  ///
  /// 如果 [mouseCursor] 是 [MaterialStateProperty<MouseCursor>]，
  /// [MaterialStateProperty.resolve] 用于以下 [MaterialState]：
  ///
  ///  * [MaterialState.selected].
  ///  * [MaterialState.disabled].
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

  /// 面板的 [Material] 的飞溅颜色。
  final Color? splashColor;

  /// 当指针悬停在面板上时，面板 [Material] 的颜色。
  final Color? hoverColor;

  /// 按下时面板的高亮颜色。
  final Color? highlightColor;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  /// {@macro flutter.widgets.Focus.autofocus}
  final bool autofocus;

  /// 当 [selected] 为 false 时，定义 `Panel` 的背景颜色。
  ///
  /// 当值为 null 时，[panelColor] 设置为 [CardTheme.color]如果它不为空，
  /// 如果它为空则为[ColorScheme.surface]。
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

  /// 分配给 [leading] 小部件的最小宽度。
  ///
  /// 如果为 null，则使用 [TxPanelThemeData.minLeadingWidth] 的值。
  /// 如果这也是 null，则使用默认值 40。
  final double? minLeadingWidth;

  /// 面板的外边距
  ///
  /// 面板外部与其他小部件间隔的区域。
  ///
  /// 默认值为 “EdgeInsets.symmetric(horizontal: 4.0)”。
  final EdgeInsetsGeometry? margin;

  /// 定义 [TxPanel.leading] 和 [TxPanel.trailing] 相对于 [TxPanel] 的标题
  /// （[TxPanel.title] 和 [TxPanel.subtitle]）的垂直对齐方式。
  ///
  /// 如果此属性为 null，则使用 [ListTileThemeData.titleAlignment]。如果这也为 null，
  /// 则使用 [ListTileTitleAlignment.threeLine]。
  final ListTileTitleAlignment? titleAlignment;

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

  bool _isDenseLayout(
    ThemeData theme,
    TxPanelThemeData panelTheme,
  ) {
    return dense ?? panelTheme.dense ?? theme.listTileTheme.dense ?? false;
  }

  Color? _backgroundColor(
    ThemeData theme,
    TxPanelThemeData panelTheme,
    TxPanelThemeData defaults,
  ) {
    final Color? color = selected
        ? selectedPanelColor ??
            panelTheme.selectedPanelColor ??
            theme.listTileTheme.selectedTileColor
        : panelColor ?? panelTheme.panelColor ?? theme.listTileTheme.tileColor;
    return color ?? defaults.panelColor!;
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    final ThemeData theme = Theme.of(context);
    final TxPanelThemeData panelTheme = TxPanelTheme.of(context);
    final ListTileThemeData tileTheme = theme.listTileTheme;
    final TxPanelThemeData defaults = _PanelDefaultsM3(context);
    final Set<MaterialState> states = <MaterialState>{
      if (!enabled) MaterialState.disabled,
      if (selected) MaterialState.selected,
    };

    Color? resolveColor(
        Color? explicitColor, Color? selectedColor, Color? enabledColor,
        [Color? disabledColor]) {
      return _IndividualOverrides(
        explicitColor: explicitColor,
        selectedColor: selectedColor,
        enabledColor: enabledColor,
        disabledColor: disabledColor,
      ).resolve(states);
    }

    final Color? effectiveIconColor =
        resolveColor(iconColor, selectedColor, iconColor) ??
            resolveColor(panelTheme.iconColor, panelTheme.selectedColor,
                panelTheme.iconColor) ??
            resolveColor(tileTheme.iconColor, tileTheme.selectedColor,
                tileTheme.iconColor) ??
            resolveColor(defaults.iconColor, defaults.selectedColor,
                defaults.iconColor, theme.disabledColor);
    final Color? effectiveColor =
        resolveColor(textColor, selectedColor, textColor) ??
            resolveColor(panelTheme.textColor, panelTheme.selectedColor,
                panelTheme.textColor) ??
            resolveColor(tileTheme.textColor, tileTheme.selectedColor,
                tileTheme.textColor) ??
            resolveColor(defaults.textColor, defaults.selectedColor,
                defaults.textColor, theme.disabledColor);

    final IconThemeData iconThemeData =
        IconThemeData(color: effectiveIconColor);
    final IconButtonThemeData iconButtonThemeData = IconButtonThemeData(
      style: IconButton.styleFrom(foregroundColor: effectiveIconColor),
    );

    TextStyle? leadingAndTrailingStyle;
    if (leading != null || trailing != null || this.footer != null) {
      leadingAndTrailingStyle = leadingAndTrailingTextStyle ??
          panelTheme.leadingAndTrailingTextStyle ??
          tileTheme.leadingAndTrailingTextStyle ??
          defaults.leadingAndTrailingTextStyle!;
      final Color? leadingAndTrailingTextColor = effectiveColor;
      leadingAndTrailingStyle =
          leadingAndTrailingStyle.copyWith(color: leadingAndTrailingTextColor);
    }

    Widget? leadingIcon;
    if (leading != null) {
      leadingIcon = AnimatedDefaultTextStyle(
        style: leadingAndTrailingStyle!,
        duration: kThemeChangeDuration,
        child: leading!,
      );
    }

    TextStyle titleStyle = titleTextStyle ??
        panelTheme.titleTextStyle ??
        tileTheme.titleTextStyle ??
        defaults.titleTextStyle!;
    final Color? titleColor = effectiveColor;
    titleStyle = titleStyle.copyWith(
      color: titleColor,
      fontSize: _isDenseLayout(theme, panelTheme)
          ? theme.textTheme.bodySmall!.fontSize
          : null,
    );
    final Widget titleText = AnimatedDefaultTextStyle(
      style: titleStyle,
      duration: kThemeChangeDuration,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      child: title ?? const SizedBox(),
    );

    Widget? subtitleText;
    TextStyle? subtitleStyle;
    if (subtitle != null) {
      subtitleStyle = subtitleTextStyle ??
          panelTheme.subtitleTextStyle ??
          tileTheme.subtitleTextStyle ??
          defaults.subtitleTextStyle!;
      final Color? subtitleColor = effectiveColor;
      subtitleStyle = subtitleStyle.copyWith(
        color: subtitleColor,
        fontSize: _isDenseLayout(theme, panelTheme)
            ? theme.textTheme.labelSmall!.fontSize
            : null,
      );
      subtitleText = AnimatedDefaultTextStyle(
        style: subtitleStyle,
        duration: kThemeChangeDuration,
        child: subtitle!,
      );
    }

    Widget? trailingIcon;
    if (trailing != null) {
      trailingIcon = TextButtonTheme(
        data: TextButtonThemeData(
          style: TextButton.styleFrom(
            textStyle: theme.textTheme.labelMedium,
            visualDensity: VisualDensity.compact,
          ),
        ),
        child: AnimatedDefaultTextStyle(
          style: leadingAndTrailingStyle!,
          duration: kThemeChangeDuration,
          child: trailing!,
        ),
      );
    }

    Widget? content;
    TextStyle? contentStyle;
    if (this.content != null) {
      contentStyle = contentTextStyle ??
          panelTheme.contentTextStyle ??
          defaults.contentTextStyle!;
      content = AnimatedDefaultTextStyle(
        style: contentStyle,
        duration: kThemeChangeDuration,
        child: this.content!,
      );
    }

    Widget? footer;
    if (this.footer != null) {
      footer = AnimatedDefaultTextStyle(
        style: leadingAndTrailingStyle!,
        duration: kThemeChangeDuration,
        child: this.footer!,
      );
    }

    final TextDirection textDirection = Directionality.of(context);
    final EdgeInsets resolvedContentPadding = padding?.resolve(textDirection) ??
        panelTheme.padding?.resolve(textDirection) ??
        defaults.padding!.resolve(textDirection);

    final Set<MaterialState> mouseStates = <MaterialState>{
      if (!enabled || (onTap == null && onLongPress == null))
        MaterialState.disabled,
    };
    final MouseCursor effectiveMouseCursor =
        MaterialStateProperty.resolveAs<MouseCursor?>(
                mouseCursor, mouseStates) ??
            panelTheme.mouseCursor?.resolve(mouseStates) ??
            tileTheme.mouseCursor?.resolve(mouseStates) ??
            MaterialStateMouseCursor.clickable.resolve(mouseStates);

    final ListTileTitleAlignment effectiveTitleAlignment = titleAlignment ??
        panelTheme.titleAlignment ??
        tileTheme.titleAlignment ??
        (theme.useMaterial3
            ? ListTileTitleAlignment.threeLine
            : ListTileTitleAlignment.titleHeight);

    final EdgeInsetsGeometry margin =
        this.margin ?? panelTheme.margin ?? defaults.margin!;
    final ShapeBorder shape = this.shape ??
        panelTheme.shape ??
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0));

    return Padding(
      padding: margin,
      child: InkWell(
        customBorder: shape,
        onTap: enabled ? onTap : null,
        onLongPress: enabled ? onLongPress : null,
        onFocusChange: onFocusChange,
        mouseCursor: effectiveMouseCursor,
        canRequestFocus: enabled,
        focusNode: focusNode,
        focusColor: focusColor ?? panelTheme.focusColor,
        hoverColor: hoverColor ?? panelTheme.hoverColor,
        splashColor: splashColor ?? panelTheme.splashColor,
        highlightColor: highlightColor ?? panelTheme.highlightColor,
        autofocus: autofocus,
        enableFeedback: enableFeedback ??
            panelTheme.enableFeedback ??
            tileTheme.enableFeedback ??
            true,
        child: Semantics(
          selected: selected,
          enabled: enabled,
          child: Ink(
            decoration: ShapeDecoration(
              shape: shape,
              color: _backgroundColor(theme, panelTheme, defaults),
            ),
            child: SafeArea(
              top: false,
              bottom: false,
              minimum: resolvedContentPadding,
              child: IconTheme.merge(
                data: iconThemeData,
                child: IconButtonTheme(
                  data: iconButtonThemeData,
                  child: _Panel(
                    leading: leadingIcon,
                    title: titleText,
                    subtitle: subtitleText,
                    content: content,
                    footer: footer,
                    trailing: trailingIcon,
                    horizontalTitleGap: horizontalTitleGap ??
                        panelTheme.horizontalTitleGap ??
                        tileTheme.horizontalTitleGap ??
                        defaults.horizontalTitleGap!,
                    minLeadingWidth: minLeadingWidth ??
                        panelTheme.minLeadingWidth ??
                        defaults.minLeadingWidth!,
                    titleAlignment: effectiveTitleAlignment,
                    isDense: _isDenseLayout(theme, panelTheme),
                    visualDensity: visualDensity ??
                        panelTheme.visualDensity ??
                        theme.visualDensity,
                    verticalGap: verticalGap ??
                        panelTheme.verticalGap ??
                        defaults.verticalGap!,
                    textDirection: textDirection,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _IndividualOverrides extends MaterialStateProperty<Color?> {
  _IndividualOverrides({
    this.explicitColor,
    this.enabledColor,
    this.selectedColor,
    this.disabledColor,
  });

  final Color? explicitColor;
  final Color? enabledColor;
  final Color? selectedColor;
  final Color? disabledColor;

  @override
  Color? resolve(Set<MaterialState> states) {
    if (explicitColor is MaterialStateColor) {
      return MaterialStateProperty.resolveAs<Color?>(explicitColor, states);
    }
    if (states.contains(MaterialState.disabled)) {
      return disabledColor;
    }
    if (states.contains(MaterialState.selected)) {
      return selectedColor;
    }
    return enabledColor;
  }
}

enum _PanelSlot {
  leading,
  trailing,
  content,
  title,
  subtitle,
  footer,
}

class _Panel
    extends SlottedMultiChildRenderObjectWidget<_PanelSlot, RenderBox> {
  const _Panel({
    required this.title,
    required this.isDense,
    required this.visualDensity,
    required this.horizontalTitleGap,
    required this.minLeadingWidth,
    required this.verticalGap,
    required this.textDirection,
    required this.titleAlignment,
    this.leading,
    this.subtitle,
    this.trailing,
    this.content,
    this.footer,
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
  final TextDirection textDirection;
  final ListTileTitleAlignment titleAlignment;

  @override
  void updateRenderObject(BuildContext context, _RenderPanel renderObject) {
    renderObject
      ..verticalGap = verticalGap
      ..isDense = isDense
      ..visualDensity = visualDensity
      ..textDirection = textDirection
      ..horizontalTitleGap = horizontalTitleGap
      ..minLeadingWidth = minLeadingWidth
      ..titleAlignment = titleAlignment;
  }

  @override
  _RenderPanel createRenderObject(BuildContext context) {
    return _RenderPanel(
      isDense: isDense,
      visualDensity: visualDensity,
      textDirection: textDirection,
      horizontalTitleGap: horizontalTitleGap,
      minLeadingWidth: minLeadingWidth,
      titleAlignment: titleAlignment,
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
    with SlottedContainerRenderObjectMixin<_PanelSlot, RenderBox> {
  _RenderPanel({
    required bool isDense,
    required VisualDensity visualDensity,
    required double horizontalTitleGap,
    required double minLeadingWidth,
    required double verticalGap,
    required TextDirection textDirection,
    required ListTileTitleAlignment titleAlignment,
  })  : _isDense = isDense,
        _visualDensity = visualDensity,
        _horizontalTitleGap = horizontalTitleGap,
        _minLeadingWidth = minLeadingWidth,
        _verticalGap = verticalGap,
        _textDirection = textDirection,
        _titleAlignment = titleAlignment;

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

  TextDirection get textDirection => _textDirection;
  TextDirection _textDirection;

  set textDirection(TextDirection value) {
    if (_textDirection == value) {
      return;
    }
    _textDirection = value;
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

  ListTileTitleAlignment get titleAlignment => _titleAlignment;
  ListTileTitleAlignment _titleAlignment;

  set titleAlignment(ListTileTitleAlignment value) {
    if (_titleAlignment == value) {
      return;
    }
    _titleAlignment = value;
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
    final double minHeaderWidth = leadingWidth +
        math.max(minTitleWidth, minSubtitleWidth) +
        _maxWidth(trailing, height);

    return math.max(math.max(minHeaderWidth, minContentWidth), minFooterWidth);
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
    final double maxHeaderWidth = leadingWidth +
        math.max(maxTitleWidth, maxSubtitleWidth) +
        _maxWidth(trailing, height);

    return math.max(math.max(maxHeaderWidth, maxContentWidth), maxFooterWidth);
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

    final BoxConstraints footerAndContentConstraints =
        looseConstraints.tighten(width: tileWidth);
    final Size contentSize = _layoutBox(content, footerAndContentConstraints);
    final Size footerSize = _layoutBox(footer, footerAndContentConstraints);

    double headerHeight = titleSize.height;
    const double titleY = 0;
    double? subtitleY;
    if (hasSubtitle) {
      headerHeight = headerHeight + subtitleSize.height + gap / 2.0;
      subtitleY = titleSize.height + gap / 2.0;
    }

    final double leadingY;
    final double trailingY;
    switch (titleAlignment) {
      case ListTileTitleAlignment.threeLine:
        {
          leadingY = (headerHeight - leadingSize.height) / 2.0;
          trailingY = (headerHeight - trailingSize.height) / 2.0;
          break;
        }
      case ListTileTitleAlignment.titleHeight:
        {
          if (headerHeight > 72.0) {
            leadingY = 16.0;
            trailingY = 16.0;
          } else {
            leadingY =
                math.min((headerHeight - leadingSize.height) / 2.0, 16.0);
            trailingY = (headerHeight - trailingSize.height) / 2.0;
          }
          break;
        }
      case ListTileTitleAlignment.top:
        {
          leadingY = 0;
          trailingY = 0;
          break;
        }
      case ListTileTitleAlignment.center:
        {
          leadingY = (headerHeight - leadingSize.height) / 2.0;
          trailingY = (headerHeight - trailingSize.height) / 2.0;
          break;
        }
      case ListTileTitleAlignment.bottom:
        {
          leadingY = headerHeight - leadingSize.height - _verticalGap;
          trailingY = headerHeight - trailingSize.height - _verticalGap;
          break;
        }
    }

    switch (textDirection) {
      case TextDirection.rtl:
        {
          if (hasLeading) {
            _positionBox(
                leading!, Offset(tileWidth - leadingSize.width, leadingY));
          }
          _positionBox(title!, Offset(adjustedTrailingWidth, titleY));
          if (hasSubtitle) {
            _positionBox(subtitle!, Offset(adjustedTrailingWidth, subtitleY!));
          }
          if (hasTrailing) {
            _positionBox(trailing!, Offset(0.0, trailingY));
          }
          break;
        }
      case TextDirection.ltr:
        {
          if (hasLeading) {
            _positionBox(leading!, Offset(0.0, leadingY));
          }
          _positionBox(title!, Offset(titleStart, titleY));
          if (hasSubtitle) {
            _positionBox(subtitle!, Offset(titleStart, subtitleY!));
          }
          if (hasTrailing) {
            _positionBox(
                trailing!, Offset(tileWidth - trailingSize.width, trailingY));
          }
          break;
        }
    }

    double panelHeight = headerHeight;
    if (hasContent) {
      final double contentY = headerHeight + gap;
      panelHeight = contentY + contentSize.height;
      _positionBox(content!, Offset(0, contentY));
    }

    if (hasFooter) {
      final double footerY = panelHeight + gap;
      panelHeight = footerY + footerSize.height;
      _positionBox(footer!, Offset(0, footerY));
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

class _PanelDefaultsM3 extends TxPanelThemeData {
  _PanelDefaultsM3(this.context)
      : super(
          padding: const EdgeInsets.all(12.0),
          minLeadingWidth: 24,
          shape: const RoundedRectangleBorder(),
          margin: const EdgeInsets.all(0.0),
          horizontalTitleGap: 16.0,
          verticalGap: 12.0,
        );

  final BuildContext context;
  late final ThemeData _theme = Theme.of(context);
  late final ColorScheme _colors = _theme.colorScheme;
  late final TextTheme _textTheme = _theme.textTheme;

  @override
  Color? get panelColor => Colors.transparent;

  @override
  TextStyle? get titleTextStyle =>
      _textTheme.bodyLarge!.copyWith(color: _colors.onSurface);

  @override
  TextStyle? get subtitleTextStyle =>
      _textTheme.bodyMedium!.copyWith(color: _colors.onSurfaceVariant);

  @override
  TextStyle? get leadingAndTrailingTextStyle =>
      _textTheme.labelSmall!.copyWith(color: _colors.onSurfaceVariant);

  @override
  TextStyle? get contentTextStyle => _textTheme.bodyMedium;

  @override
  Color? get selectedColor => _colors.primary;

  @override
  Color? get iconColor => _colors.onSurfaceVariant;
}
