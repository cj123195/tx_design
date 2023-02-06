import 'package:flutter/material.dart';

/// 分割线展示时机
enum DividerDisplayTime { always, opened, closed, never }

/// [TxExpansionTile.trailing] 展示方式
enum TrailingLayoutMode {
  append, // 跟随
  replaced, // 替换
}

const Duration _kExpand = Duration(milliseconds: 200);

/// 带有扩展箭头图标的单行 [ListTile]，可展开或折叠以显示或隐藏 [children]。
///
/// [dividerDisplayTime] 用来定义分割线的显示时机
/// [trailingLayoutMode] 用来定义传入的[trailing]与默认箭头的展示方式
/// [tileShape] 用来定义[ListTile]的形状
///
/// 参考[ExpansionTile]
class TxExpansionTile extends StatefulWidget {
  const TxExpansionTile({
    required this.title,
    super.key,
    this.leading,
    this.subtitle,
    this.onExpansionChanged,
    this.children = const <Widget>[],
    this.trailing,
    this.initiallyExpanded = false,
    this.maintainState = false,
    this.tilePadding,
    this.expandedCrossAxisAlignment,
    this.expandedAlignment,
    this.childrenPadding,
    this.backgroundColor,
    this.collapsedBackgroundColor,
    this.textColor,
    this.collapsedTextColor,
    this.iconColor,
    this.collapsedIconColor,
    this.dividerDisplayTime = DividerDisplayTime.never,
    this.dividerColor,
    this.visualDensity,
    this.borderRadius,
    this.tileShape,
    this.trailingLayoutMode,
  }) : assert(
          expandedCrossAxisAlignment != CrossAxisAlignment.baseline,
          'CrossAxisAlignment.baseline 不受支持，因为展开的子项'
          '在列中对齐，而不是在行中。尝试使用另一个常量。',
        );

  /// 分割线显示的时机
  final DividerDisplayTime dividerDisplayTime;

  /// 分割线颜色
  final Color? dividerColor;

  /// 在标题之前显示的小部件。
  ///
  /// 通常是 [CircleAvatar] 小部件。
  final Widget? leading;

  /// 列表项的主要内容。
  ///
  /// 通常是 [Text] 小部件。
  final Widget title;

  /// 标题下方显示的附加内容。
  ///
  /// 通常是 [Text] 小部件。
  final Widget? subtitle;

  /// 当磁贴展开或折叠时调用。
  ///
  /// 当 tile 开始扩展时，这个函数被调用，值为 true。
  /// 当瓦片开始折叠时，这个函数被调用，值为 false。
  final ValueChanged<bool>? onExpansionChanged;

  /// 磁贴展开时显示的小部件。
  ///
  /// 通常是 [ListTile] 小部件。
  final List<Widget> children;

  /// 展开时在子列表后面显示的颜色。
  final Color? backgroundColor;

  /// 不为 null 时，定义子列表折叠时 tile 的背景颜色。
  final Color? collapsedBackgroundColor;

  /// 要显示的小部件，而不是旋转箭头图标。
  final Widget? trailing;

  /// 指定列表图块最初是展开（true）还是折叠（false，默认值）。
  final bool initiallyExpanded;

  /// 指定在 tile 展开和折叠时是否保持子项的状态。
  ///
  /// 如果为真，则在瓦片折叠时，孩子们会留在树上。
  /// 如果为 false（默认值），则在瓦片折叠时从树中删除子级，并在展开时重新创建
  final bool maintainState;

  /// 指定 [ListTile] 的填充。
  ///
  /// 类似于 [ListTile.contentPadding]，此属性定义了 [leading]、[title]、[subtitle]
  /// 和 [trailing] 小部件的插入。它不会插入扩展的 [children] 小部件。
  ///
  /// 当值为 null 时，图块的填充为 `EdgeInsets.symmetric(horizontal: 16.0)`。
  final EdgeInsetsGeometry? tilePadding;

  /// 指定 [children] 的对齐方式，它们在 tile 展开时排列成一列。
  ///
  /// 扩展磁贴的内部使用 [Column] 小部件用于 [children]，并使用 [Align] 小部件来对齐列。
  /// `expandedAlignment` 参数直接传递到 [Align] 中。
  ///
  /// 修改此属性控制展开磁贴内列的对齐方式，而不是列内 [children] 小部件的对齐方式。
  /// 要在 [children] 中对齐每个子项，请参阅 [expandedCrossAxisAlignment]。
  ///
  /// 列的宽度是 [children] 中最宽的子部件的宽度。
  ///
  /// 当值为 null 时，`expandedAlignment` 的值为 [Alignment.center]。
  final Alignment? expandedAlignment;

  /// 指定磁贴展开时 [children] 中每个子项的对齐方式。
  ///
  /// 展开图块的内部使用 [子] 的 [Column] 小部件，并且 `crossAxisAlignment` 参数直接传递到 [Column]。
  ///
  /// 修改此属性可控制其 [Column] 内每个子项的交叉轴对齐方式。请注意，容纳 [children] 的
  /// [Column] 的宽度将与 [children] 中最宽的子部件相同。 [Column]的宽度不一定等于展开的tile的宽度。
  ///
  /// 要沿展开的图块对齐 [Column]，请改用 [expandedAlignment] 属性。
  ///
  /// 当值为 null 时，`expandedCrossAxisAlignment` 的值为 [CrossAxisAlignment.center]。
  final CrossAxisAlignment? expandedCrossAxisAlignment;

  /// 指定 [children] 的填充。
  ///
  /// 当值为 null 时，`childrenPadding` 的值为 [EdgeInsets.zero]。
  final EdgeInsetsGeometry? childrenPadding;

  /// 展开子列表时磁贴的 [尾随] 展开图标的图标颜色。
  ///
  /// 用于覆盖 [ListTileTheme.iconColor]。
  final Color? iconColor;

  /// 子列表折叠时磁贴的 [尾随] 展开图标的图标颜色。
  ///
  /// 用于覆盖 [ListTileTheme.iconColor]。
  final Color? collapsedIconColor;

  /// 展开子列表时磁贴标题的颜色。
  ///
  /// 用于覆盖 [ListTileTheme.textColor]。
  final Color? textColor;

  /// 子列表折叠时磁贴标题的颜色。
  ///
  /// 用于覆盖 [ListTileTheme.textColor]。
  final Color? collapsedTextColor;

  /// 定义列表图块布局的紧凑程度。
  ///
  /// 用于覆盖 [ListTile.visualDensity]。
  final VisualDensity? visualDensity;

  /// 圆角
  final BorderRadiusGeometry? borderRadius;

  /// Tile形状
  final ShapeBorder? tileShape;

  /// [trailing] 展示方式
  final TrailingLayoutMode? trailingLayoutMode;

  @override
  State<TxExpansionTile> createState() => _TxExpansionTileState();
}

class _TxExpansionTileState extends State<TxExpansionTile>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeOutTween =
      CurveTween(curve: Curves.easeOut);
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);
  static final Animatable<double> _halfTween =
      Tween<double>(begin: 0.0, end: 0.5);

  final ColorTween _borderColorTween = ColorTween();
  final ColorTween _headerColorTween = ColorTween();
  final ColorTween _iconColorTween = ColorTween();
  final ColorTween _backgroundColorTween = ColorTween();

  late AnimationController _controller;
  late Animation<double> _iconTurns;
  late Animation<double> _heightFactor;
  late Animation<Color?> _borderColor;
  late Animation<Color?> _headerColor;
  late Animation<Color?> _iconColor;
  late Animation<Color?> _backgroundColor;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _kExpand, vsync: this);
    _heightFactor = _controller.drive(_easeInTween);
    _iconTurns = _controller.drive(_halfTween.chain(_easeInTween));
    _borderColor = _controller.drive(_borderColorTween.chain(_easeOutTween));
    _headerColor = _controller.drive(_headerColorTween.chain(_easeInTween));
    _iconColor = _controller.drive(_iconColorTween.chain(_easeInTween));
    _backgroundColor =
        _controller.drive(_backgroundColorTween.chain(_easeOutTween));

    _isExpanded = PageStorage.of(context).readState(context) as bool? ??
        widget.initiallyExpanded;
    if (_isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse().then<void>((void value) {
          if (!mounted) {
            return;
          }
          setState(() {
            // Rebuild without widget.children.
          });
        });
      }
      PageStorage.of(context).writeState(context, _isExpanded);
    });
    widget.onExpansionChanged?.call(_isExpanded);
  }

  void setupDividerColorTween() {
    final ThemeData theme = Theme.of(context);

    Color beginColor = widget.dividerColor ?? theme.dividerColor;
    Color endColor = beginColor;

    switch (widget.dividerDisplayTime) {
      case DividerDisplayTime.always:
        break;
      case DividerDisplayTime.opened:
        beginColor = Colors.transparent;
        break;
      case DividerDisplayTime.closed:
        endColor = Colors.transparent;
        break;
      case DividerDisplayTime.never:
        beginColor = Colors.transparent;
        endColor = Colors.transparent;
        break;
      default:
    }
    _borderColorTween
      ..begin = beginColor
      ..end = endColor;
  }

  Widget _buildChildren(BuildContext context, Widget? child) {
    final Border? border = _borderColor.value == Colors.transparent
        ? null
        : Border(
            top: BorderSide(color: _borderColor.value!),
            bottom: BorderSide(color: _borderColor.value!),
          );

    Widget? subtitle;
    if (widget.subtitle != null) {
      subtitle = AnimatedDefaultTextStyle(
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: _isExpanded
                ? Theme.of(context).colorScheme.secondary
                : Theme.of(context).textTheme.bodySmall?.color),
        duration: _kExpand,
        child: widget.subtitle!,
      );
    }

    Widget trailing;
    if (widget.trailing != null) {
      if (widget.trailingLayoutMode == TrailingLayoutMode.append) {
        trailing = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            widget.trailing!,
            RotationTransition(
              turns: _iconTurns,
              child: const Icon(Icons.expand_more),
            ),
          ],
        );
      } else {
        trailing = widget.trailing!;
      }
    } else {
      trailing = RotationTransition(
        turns: _iconTurns,
        child: const Icon(Icons.expand_more),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: _backgroundColor.value ?? Colors.transparent,
        borderRadius: widget.borderRadius,
        border: border,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTileTheme.merge(
            iconColor: _iconColor.value,
            textColor: _headerColor.value,
            child: ListTile(
              onTap: _handleTap,
              contentPadding: widget.tilePadding,
              leading: widget.leading,
              title: widget.title,
              subtitle: subtitle,
              visualDensity: widget.visualDensity,
              shape: widget.tileShape,
              trailing: trailing,
            ),
          ),
          ClipRect(
            child: Align(
              alignment: widget.expandedAlignment ?? Alignment.center,
              heightFactor: _heightFactor.value,
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    setupDividerColorTween();
    _headerColorTween
      ..begin = widget.collapsedTextColor ?? theme.textTheme.titleMedium!.color
      ..end = widget.textColor ?? colorScheme.secondary;
    _iconColorTween
      ..begin = widget.collapsedIconColor ?? theme.unselectedWidgetColor
      ..end = widget.iconColor ?? colorScheme.secondary;
    _backgroundColorTween
      ..begin = widget.collapsedBackgroundColor
      ..end = widget.backgroundColor;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final bool closed = !_isExpanded && _controller.isDismissed;
    final bool shouldRemoveChildren = closed && !widget.maintainState;

    final Widget result = Offstage(
      offstage: closed,
      child: TickerMode(
        enabled: !closed,
        child: Padding(
          padding: widget.childrenPadding ?? EdgeInsets.zero,
          child: Column(
            crossAxisAlignment:
                widget.expandedCrossAxisAlignment ?? CrossAxisAlignment.center,
            children: widget.children,
          ),
        ),
      ),
    );

    return AnimatedBuilder(
      animation: _controller.view,
      builder: _buildChildren,
      child: shouldRemoveChildren ? null : result,
    );
  }
}
