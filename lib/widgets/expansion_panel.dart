import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'expansion_panel_theme.dart';
import 'panel.dart';
import 'panel_theme.dart';

const Duration _kExpand = Duration(milliseconds: 200);

enum ExpansionPanelControlAffinity {
  leading,
  trailing,
  footer,
}

/// 启用对单个 [TxExpansionPanel] 的 expanded/collapsed 状态的控制。
///
/// 以编程方式展开或折叠 [TxExpansionPanel] 可能很有用，例如，根据系统事件重新配置现有展开图块。
/// 为此，请使用有状态小组件拥有的 [TxExpansionPanelController] 创建 [TxExpansionPanel]，或
/// 使用 [TxExpansionPanelController.of] 查找磁贴自动创建的 [TxExpansionPanelController]。
///
/// 控制器的 [expand] 和 [collapse] 方法会导致 [TxExpansionPanel] 重新生成，因此不能从生成
/// 方法调用它们。
class TxExpansionPanelController {
  /// 创建要与 [TxExpansionPanel.controller] 一起使用的控制器。
  TxExpansionPanelController();

  _ExpansionTileState? _state;

  /// 使用此控制器构建的 [TxExpansionPanel] 是否处于展开状态。
  ///
  /// 此属性不考虑动画。即使扩展动画未完成，它也会报告“true”。
  ///
  /// 另请参阅：
  ///
  ///  * [expand]，这将展开 [TxExpansionPanel]。
  ///  * [collapse]，这将折叠 [TxExpansionPanel]。
  ///  * [TxExpansionPanel.controller] 创建带有控制器的 TxExpansionPanel。
  bool get isExpanded {
    assert(_state != null);
    return _state!._isExpanded;
  }

  /// 展开使用此控制器构建的 [TxExpansionPanel];
  ///
  /// 通常，当用户点击标题时，panel 会自动展开。由于外部更改，以编程方式触发扩展有时很有用。
  ///
  /// 如果 panel 已处于展开状态（请参阅 [isExpanded]），则调用此方法不起作用。
  ///
  /// 调用此方法可能会导致 [TxExpansionPanel] 重新生成，因此可能无法从生成方法调用它。
  ///
  /// 调用该方法将触发 [TxExpansionPanel.onExpansionChanged] 回调。
  ///
  /// 另请参阅：
  ///
  ///  * [expand]，这将展开 [TxExpansionPanel]。
  ///  * [isExpanded] 检查 panel 是否展开。
  ///  * [TxExpansionPanel.controller] 创建带有控制器的 TxExpansionPanel。
  void expand() {
    assert(_state != null);
    if (!isExpanded) {
      _state!._toggleExpansion();
    }
  }

  /// 折叠使用此控制器生成的 [TxExpansionPanel]。
  ///
  /// 通常，当用户点击标题时，磁贴会自动折叠。由于某些外部更改，有时以编程方式触发折叠可能很有用。
  ///
  /// 如果磁贴已处于折叠状态（请参阅 [isExpanded]），则调用此方法不起作用。
  ///
  /// 调用此方法可能会导致 [TxExpansionPanel] 重新生成，因此可能无法从生成方法调用它。
  ///
  /// 调用该方法将触发 [TxExpansionPanel.onExpansionChanged] 回调。
  ///
  /// 另请参阅：
  ///
  ///  * [expand]，这将展开 [TxExpansionPanel]。
  ///  * [isExpanded] 检查 panel 是否展开。
  ///  * [TxExpansionPanel.controller] 创建带有控制器的 TxExpansionPanel。
  void collapse() {
    assert(_state != null);
    if (isExpanded) {
      _state!._toggleExpansion();
    }
  }

  /// 查找包含给定上下文的最接近的 [TxExpansionPanel] 实例的 [TxExpansionPanelController]。
  ///
  /// 如果没有 [TxExpansionPanel] 包含给定的上下文，则调用此方法将导致在调试模式下断言，并在
  /// 发布模式下引发异常。
  ///
  /// 若要返回 null，如果没有 [TxExpansionPanel]，请改用 [maybeOf]。
  ///
  /// {@tool dartpad}
  /// [TxExpansionPanelController.of] 函数的典型用法是从 [TxExpansionPanel] 的后代的“
  /// build”方法中调用它。
  ///
  /// 当 [TxExpansionPanel] 实际上是在与引用控制器的回调相同的“build”函数中创建的，则
  /// “build”函数的“context”参数不能用于查找 [TxExpansionPanelController]（因为它位于小
  /// 部件树中返回的小部件的“上方”）。在这种情况下，您可以添加一个 [Builder] 小部件，它提供
  /// 了一个新范围，其中包含位于 [TxExpansionPanel] 下的 [BuildContext]：
  ///
  /// ** 请参阅 examples/api/lib/material/expansion_tile/expansion_tile.1.dart 中的代码 **
  /// {@end-tool}
  ///
  /// 更有效的解决方案是将构建函数拆分为多个小部件。这引入了一个新的上下文，您可以从中获取
  /// [TxExpansionPanelController]。使用这种方法，您将拥有一个外部小组件，用于创建由新内部
  /// 小组件的实例填充的 [TxExpansionPanel]，然后在这些内部小组件中使用
  /// [TxExpansionPanelController.of]。
  static TxExpansionPanelController of(BuildContext context) {
    final _ExpansionTileState? result =
        context.findAncestorStateOfType<_ExpansionTileState>();
    if (result != null) {
      return result._tileController;
    }
    throw FlutterError.fromParts(<DiagnosticsNode>[
      ErrorSummary(
        'TxExpansionPanelController.of() 使用不包含 TxExpansionPanel 的上下文调用。',
      ),
      ErrorDescription(
        '从传递给 TxExpansionPanelController.of() 的上下文开始，找不到 TxExpansionPanel 祖先。'
        '当提供的上下文与其构建函数实际创建所查找的 TxExpansionPanel 小部件的上下文来自同一 '
        'StatefulWidget 时，通常会发生这种情况。',
      ),
      ErrorHint(
        '有几种方法可以避免此问题。最简单的方法是使用 Builder 来获取位于 TxExpansionPanel '
        '下的上下文。有关此示例，请参阅 TxExpansionPanelController.of() 的文档：\n'
        '  https://api.flutter.dev/flutter/material/TxExpansionPanel/of.html',
      ),
      ErrorHint(
        '更有效的解决方案是将构建函数拆分为多个小部件。这将引入一个新的上下文，您可以从中获取 '
        'TxExpansionPanel。在此解决方案中，您将有一个外部小部件，用于创建由新的内部小部件的'
        '实例填充的 TxExpansionPanel，然后在这些内部小部件中，您将使用 '
        'TxExpansionPanelController.of()。\n '
        '另一种解决方案是将 GlobalKey 分配给 TxExpansionPanel，然后使用 key.currentState '
        '属性获取 TxExpansionPanel，而不是使用 TxExpansionPanelController.of（） 函数。',
      ),
      context.describeElement('使用的上下文是'),
    ]);
  }

  /// 从此类的最接近的实例中查找 [TxExpansionPanel]，该实例包含给定上下文并返回其
  /// [TxExpansionPanelController]。
  ///
  /// 如果没有 [TxExpansionPanel] 包含给定的上下文，则返回 null。若要改为引发异常，请使用
  /// [of] 而不是此函数。
  ///
  /// 另请参阅：
  ///
  ///  * [of]，一个与此函数类似的函数，如果没有 [TxExpansionPanel] 包含给定的上下文，则抛出
  ///    该函数。在其文档中还包括一些示例代码。
  static TxExpansionPanelController? maybeOf(BuildContext context) {
    return context
        .findAncestorStateOfType<_ExpansionTileState>()
        ?._tileController;
  }
}

/// 带有展开箭头图标的单行 [TxPanel]，用于展开或折叠 panel 以显示或隐藏 [children]。
///
/// 此小部件通常与 [ListView] 一起使用，以创建“展开折叠”列表条目。当与 [ListView] 等滚动
/// 小部件一起使用时，必须将唯一的 [PageStorageKey] 指定为 [key]，以使 [TxExpansionPanel]
/// 能够在滚动到视图中和从视图中滚动时保存和恢复其展开状态。
///
/// 此类重写其 [TxPanel] 的 [TxPanelThemeData.iconColor] 和
/// [TxPanelThemeData.textColor] 主题属性。当磁贴展开和折叠时，这些颜色在值之间以动画形
/// 式显示：在 [iconColor]、[collapsedIconColor] 之间以及 [textColor] 和
/// [collapsedTextColor] 之间。
class TxExpansionPanel extends StatefulWidget {
  /// 创建一个带有展开箭头图标的单行 [TxPanel]，该图标可展开或折叠磁贴以显示或隐藏 [children]。
  /// [initiallyExpanded] 属性必须为非 null。
  const TxExpansionPanel({
    required this.title,
    super.key,
    this.leading,
    this.subtitle,
    this.footer,
    this.collapsedChildren,
    this.onExpansionChanged,
    this.children = const <Widget>[],
    this.trailing,
    this.initiallyExpanded = false,
    this.maintainState = false,
    this.panelPadding,
    this.expandedCrossAxisAlignment,
    this.expandedAlignment,
    this.collapsedPadding,
    this.backgroundColor,
    this.collapsedBackgroundColor,
    this.textColor,
    this.collapsedTextColor,
    this.iconColor,
    this.collapsedIconColor,
    this.shape,
    this.collapsedShape,
    this.clipBehavior,
    this.controller,
    this.showControlText = true,
    this.collapseLabel,
    this.expandLabel,
    this.childrenPadding,
    this.controlAffinity,
    this.childrenDecoration,
    this.dense,
    this.visualDensity,
    this.enableFeedback,
    this.enabled = true,
    this.expansionAnimationStyle,
  }) : assert(
          expandedCrossAxisAlignment != CrossAxisAlignment.baseline,
          'CrossAxisAlignment.baseline is not supported since the expanded '
          'children are aligned in a column, not a row. Try to use another '
          'constant.',
        );

  /// 参考[TxPanel.leading]
  final Widget? leading;

  /// 参考[TxPanel.title]
  final Widget title;

  /// 参考[TxPanel.subtitle]
  final Widget? subtitle;

  /// 参考[TxPanel.footer]
  final Widget? footer;

  /// 在 panel 展开或折叠时调用。
  ///
  /// 当 panel 开始展开时，将使用值 true 调用此函数。
  /// 当 panel 开始折叠时，将使用值 false 调用此函数。
  final ValueChanged<bool>? onExpansionChanged;

  /// panel 折叠时显示的小组件。
  final List<Widget>? collapsedChildren;

  /// panel 展开时显示的小组件。
  ///
  /// 通常为 [TxPanel] 小部件。
  final List<Widget> children;

  /// 展开时要显示在子列表后面的颜色。
  ///
  /// 如果此属性为 null，则使用 [ExpansionTileThemeData.backgroundColor]。如果这也为
  /// null，则使用 Colors.transparent。
  ///
  /// 另请参阅：
  ///
  /// * [ExpansionTileTheme.of]，返回最接近的 [ExpansionTileTheme] 的
  /// [ExpansionTileThemeData]。
  final Color? backgroundColor;

  /// 如果不为 null，则定义子列表折叠时 panel 的背景色。
  ///
  /// 如果此属性为 null，则使用 [ExpansionTileThemeData.collapsedBackgroundColor]。
  /// 如果这也为 null，则使用 Colors.transparent。
  ///
  /// 另请参阅：
  ///
  /// * [ExpansionTileTheme.of]，返回最接近的 [ExpansionTileTheme] 的
  /// [ExpansionTileThemeData]。
  final Color? collapsedBackgroundColor;

  /// 参考[TxPanel.trailing]
  final Widget? trailing;

  /// 指定 panel 最初是展开 （true） 还是折叠 （false，默认值）。
  final bool initiallyExpanded;

  /// 指定在 panel 展开和折叠时是否保持子项的状态。
  ///
  /// 如果为 true，则当 panel 折叠时，孩子们被留在树中。如果为 false（默认值），则当 panel
  /// 折叠并在展开时重新创建时，子项将从树中删除。
  final bool maintainState;

  /// 指定 [TxPanel] 的填充。
  ///
  /// 与 [TxPanel.padding] 类似，此属性定义 [leading]、[title]、[subtitle]
  /// 和 [trailing] 小部件的插图。它不会插入展开的 [children] 小部件。
  ///
  /// 如果此属性为 null，则使用 [ExpansionTileThemeData.tilePadding]。如果这也为 null，
  /// 则 panel 的填充为 'EdgeInsets.symmetric(horizontal： 16.0)'。
  ///
  /// 另请参阅：
  ///
  /// * [ExpansionTileTheme.of]，返回最接近的 [ExpansionTileTheme] 的
  /// [ExpansionTileThemeData]。
  final EdgeInsetsGeometry? collapsedPadding;

  /// 指定当 panel 展开时排列在列中的子项 [children] 的对齐方式。
  ///
  /// 展开 panel 的内部使用 [Column] 小部件作为 [children]，并使用 [Align] 小部件来
  /// 对齐列。[expandedAlignment] 参数直接传递到 [Align] 中。
  ///
  /// 修改此属性可控制展开 panel 中列的对齐方式，而不是列中 [children] 小组件的对齐方式。
  /// 若要对齐 [children] 中的每个子项，请参阅 [expandedCrossAxisAlignment]。
  ///
  /// 列的宽度是 [children] 中最宽的子小部件的宽度。
  ///
  /// 如果此属性为 null，则使用 [ExpansionTileThemeData.expandedAlignment]。如果这也
  /// 为 null，则 [expandedAlignment] 的值为 [Alignment.center]。
  ///
  /// 另请参阅：
  ///
  /// * [ExpansionTileTheme.of]，返回最接近的 [ExpansionTileTheme] 的
  /// [ExpansionTileThemeData]。
  final Alignment? expandedAlignment;

  /// 指定展开 panel 时 [children] 中每个子项的对齐方式。
  ///
  /// 展开图块的内部使用 [子项] 的 [Column] 小部件，并且“crossAxisAlignment”参数直接传
  /// 递到 [Column] 中。
  ///
  /// 修改此属性可控制其 [Column] 中每个子项的交叉轴对齐方式。容纳 [children] 的 [Column]
  /// 的宽度将与 [children] 中最宽的子构件相同。[列] 的宽度可能不等于展开磁贴的宽度。
  ///
  /// 若要使 [Column] 沿展开的 panel 对齐，请改用 [expandedAlignment] 属性。
  ///
  /// 当该值为 null 时，[expandedCrossAxisAlignment] 的值为
  /// [CrossAxisAlignment.center]。
  final CrossAxisAlignment? expandedCrossAxisAlignment;

  /// 指定 [TxExpansionPanel] 的填充。。
  final EdgeInsetsGeometry? panelPadding;

  /// 指定 [children] 的填充。
  ///
  /// 如果此属性为 null，则使用 [ExpansionTileThemeData.childrenPadding]。如果这也为
  /// null，则 [panelPadding] 的值为 [EdgeInsets.zero]。
  ///
  /// 另请参阅：
  ///
  /// * [ExpansionTileTheme.of]，返回最接近的 [ExpansionTileTheme] 的
  ///   [ExpansionTileThemeData]。
  final EdgeInsetsGeometry? childrenPadding;

  /// 展开子列表时磁贴的展开箭头图标的图标颜色。
  ///
  /// 用于重写 [TxPanelThemeData.iconColor]。
  ///
  /// 如果此属性为 null，则使用 [ExpansionTileThemeData.iconColor]。如果这也为 null，
  /// 则使用 [ColorScheme.primary] 的值。
  ///
  /// 另请参阅：
  ///
  /// * [ExpansionTileTheme.of]，它返回最接近的 [ExpansionTileTheme] 的
  ///   [ExpansionTileThemeData]。
  final Color? iconColor;

  /// 子列表折叠时 panel 的展开箭头图标的图标颜色。
  ///
  /// 用于重写 [TxPanelThemeData.iconColor]。
  ///
  /// 如果此属性为 null，则使用 [ExpansionTileThemeData.collapsedIconColor]。如果这
  /// 也为 null 且 [ThemeData.useMaterial3] 为 true，则使用 [ColorScheme.onSurface]。
  /// 否则，默认为 [ThemeData.unselectedWidgetColor] 颜色。
  ///
  /// 另请参阅：
  ///
  /// * [ExpansionTileTheme.of]，返回最接近的 [ExpansionTileTheme] 的
  ///   [ExpansionTileThemeData]。
  final Color? collapsedIconColor;

  /// 展开子列表时 panel 标题的颜色。
  ///
  /// 用于重写 [TxPanelThemeData.textColor]。
  ///
  /// 如果此属性为 null，则使用 [ExpansionTileThemeData.textColor]。如果这也为 null，
  /// 则 [ThemeData.useMaterial3] 为 true，则 [TextTheme.bodyLarge] 的颜色将用于
  /// [title] 和 [subtitle]。否则，默认为 [ColorScheme.primary] 颜色。
  ///
  /// 另请参阅：
  ///
  /// * [ExpansionTileTheme.of]，返回最接近的 [ExpansionTileTheme] 的
  ///   [ExpansionTileThemeData]。
  final Color? textColor;

  /// 子列表折叠时磁贴标题的颜色。
  ///
  /// 用于重写 [TxPanelThemeData.textColor]。
  ///
  /// 如果此属性为 null，则使用 [ExpansionTileThemeData.collapsedTextColor]。如果这也
  /// 为 null 且 [ThemeData.useMaterial3] 为 true，则 [TextTheme.bodyLarge] 的颜色
  /// 将用于 [title] 和 [subtitle]。否则，默认为 [TextTheme.titleMedium] 的颜色。
  ///
  /// 另请参阅：
  ///
  /// * [ExpansionTileTheme.of]，它返回最接近的 [ExpansionTileTheme] 的
  ///   [ExpansionTileThemeData]。
  final Color? collapsedTextColor;

  /// 展开子列表时 panel 的边框形状。
  ///
  /// 如果此属性为 null，则使用 [ExpansionTileThemeData.shape]。如果这也为 null，
  /// 则使用垂直边默认为 [ThemeData.dividerColor] 的 [Border]。
  ///
  /// 另请参阅：
  ///
  /// * [ExpansionTileTheme.of]，它返回最接近的 [ExpansionTileTheme] 的
  ///   [ExpansionTileThemeData]。
  final ShapeBorder? shape;

  /// 子列表折叠时 panel 的边框形状。
  ///
  /// 如果此属性为 null，则使用 [ExpansionTileThemeData.collapsedShape]。如果这也为
  /// null，则使用垂直边默认为 Color [Colors.transparent] 的 [Border]。
  ///
  /// 另请参阅：
  ///
  /// * [ExpansionTileTheme.of]，它返回最接近的 [ExpansionTileTheme] 的
  ///   [ExpansionTileThemeData]。
  final ShapeBorder? collapsedShape;

  /// {@macro flutter.material.Material.clipBehavior}
  ///
  /// 如果此属性为 null，则使用 [ExpansionTileThemeData.clipBehavior]。如果这也为
  /// null，则使用 [Clip.none]。
  ///
  /// 另请参阅：
  ///
  /// * [ExpansionTileTheme.of]，它返回最接近的 [ExpansionTileTheme] 的
  ///   [ExpansionTileThemeData]。
  final Clip? clipBehavior;

  /// 如果提供，控制器可用于展开和折叠切片。
  ///
  /// 如果需要通过 panel 中的小部件触发的回调来控制 panel 的状态，则
  /// [TxExpansionPanelController.of]可能比提供控制器更方便。
  final TxExpansionPanelController? controller;

  /// 是否显示控制文字
  ///
  /// 默认值为 true
  final bool showControlText;

  /// 收起按钮文字
  ///
  /// 默认值为TxLocalizations.of(context).collapsedButtonLabel
  final String? collapseLabel;

  /// 展开按钮文字
  ///
  /// 默认值为TxLocalizations.of(context).moreButtonLabel
  final String? expandLabel;

  /// 通常用于将扩展文字和箭头图标强制到[leading]、[trailing]或[footer]。
  ///
  /// 默认情况下，[controlAffinity] 的值为 [ListTileControlAffinity.trailing]。
  final ExpansionPanelControlAffinity? controlAffinity;

  /// [collapsedChildren] 和 [children] 装饰器
  final Decoration? childrenDecoration;

  /// {@macro flutter.material.ListTile.dense}
  final bool? dense;

  /// 定义展开磁贴布局的紧凑程度。
  ///
  /// {@macro flutter.material.themedata.visualDensity}
  final VisualDensity? visualDensity;

  /// {@macro flutter.material.ListTile.enableFeedback}
  final bool? enableFeedback;

  /// 此扩展磁贴是否为交互式磁贴。
  ///
  /// 如果为 false，则内部 [TxPanel] 将被禁用，根据主题更改其外观并禁用用户交互。
  ///
  /// 即使禁用，仍可以通过 [ExpansionTileController] 以编程方式切换扩展。
  final bool enabled;

  /// 用于覆盖展开动画曲线和持续时间。
  ///
  /// 如果提供了 [AnimationStyle.duration]，它将用于覆盖扩展动画持续时间。如果为 null，
  /// 则将使用 [TxExpansionPanelThemeData.expansionAnimationStyle] 中的
  /// [AnimationStyle.duration]。否则，默认为 200 毫秒。
  ///
  /// 如果提供了 [AnimationStyle.curve]，它将用于覆盖展开动画曲线。如果为 null，则将使用
  /// [ExpansionTileThemeData.expansionAnimationStyle] 中的
  /// [AnimationStyle.curve]。否则，默认为 [Curves.easeIn]。
  ///
  /// 要禁用主题动画，请使用 [AnimationStyle.noAnimation]。
  final AnimationStyle? expansionAnimationStyle;

  @override
  State<TxExpansionPanel> createState() => _ExpansionTileState();
}

class _ExpansionTileState extends State<TxExpansionPanel>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeOutTween =
      CurveTween(curve: Curves.easeOut);
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);
  static final Animatable<double> _halfTween =
      Tween<double>(begin: 0.0, end: 0.5);

  final ShapeBorderTween _borderTween = ShapeBorderTween();
  final ColorTween _headerColorTween = ColorTween();
  final ColorTween _iconColorTween = ColorTween();
  final ColorTween _backgroundColorTween = ColorTween();
  final CurveTween _heightFactorTween = CurveTween(curve: Curves.easeIn);

  late AnimationController _animationController;
  late Animation<double> _iconTurns;
  late Animation<double> _heightFactor;
  late Animation<ShapeBorder?> _border;
  late Animation<Color?> _headerColor;
  late Animation<Color?> _iconColor;
  late Animation<Color?> _backgroundColor;

  bool _isExpanded = false;
  late TxExpansionPanelController _tileController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: _kExpand, vsync: this);
    _heightFactor = _animationController.drive(_heightFactorTween);
    _iconTurns = _animationController.drive(_halfTween.chain(_easeInTween));
    _border = _animationController.drive(_borderTween.chain(_easeOutTween));
    _headerColor =
        _animationController.drive(_headerColorTween.chain(_easeInTween));
    _iconColor =
        _animationController.drive(_iconColorTween.chain(_easeInTween));
    _backgroundColor =
        _animationController.drive(_backgroundColorTween.chain(_easeOutTween));

    _isExpanded = PageStorage.maybeOf(context)?.readState(context) as bool? ??
        widget.initiallyExpanded;
    if (_isExpanded) {
      _animationController.value = 1.0;
    }

    assert(widget.controller?._state == null);
    _tileController = widget.controller ?? TxExpansionPanelController();
    _tileController._state = this;
  }

  @override
  void dispose() {
    _tileController._state = null;
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    final TextDirection textDirection =
        WidgetsLocalizations.of(context).textDirection;
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final String stateHint =
        _isExpanded ? localizations.expandedHint : localizations.collapsedHint;
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse().then<void>((void value) {
          if (!mounted) {
            return;
          }
          setState(() {
            // Rebuild without widget.children.
          });
        });
      }
      PageStorage.maybeOf(context)?.writeState(context, _isExpanded);
    });
    widget.onExpansionChanged?.call(_isExpanded);
    SemanticsService.announce(stateHint, textDirection);
  }

  void _handleTap() {
    _toggleExpansion();
  }

  // Platform 或 null 关联性默认为尾随。
  ExpansionPanelControlAffinity _effectiveAffinity(BuildContext context) {
    return widget.controlAffinity ??
        TxExpansionPanelTheme.of(context).controlAffinity ??
        ExpansionPanelControlAffinity.trailing;
  }

  Widget? _buildIcon(BuildContext context) {
    final Widget icon = RotationTransition(
      turns: _iconTurns,
      child: const Icon(Icons.expand_more),
    );
    if (!widget.showControlText) {
      return icon;
    }

    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final String collapseLabel =
        widget.collapseLabel ?? localizations.expandedIconTapHint;
    final String expandLabel =
        widget.expandLabel ?? localizations.collapsedIconTapHint;
    final Widget label = Text(_isExpanded ? collapseLabel : expandLabel);

    return Row(mainAxisSize: MainAxisSize.min, children: [label, icon]);
  }

  Widget? _buildLeadingIcon(BuildContext context) {
    if (_effectiveAffinity(context) != ExpansionPanelControlAffinity.leading) {
      return null;
    }
    return _buildIcon(context);
  }

  Widget? _buildTrailingIcon(BuildContext context) {
    if (_effectiveAffinity(context) != ExpansionPanelControlAffinity.trailing) {
      return null;
    }
    return _buildIcon(context);
  }

  Widget? _buildFooter(BuildContext context) {
    if (_effectiveAffinity(context) != ExpansionPanelControlAffinity.footer) {
      return null;
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Divider(height: 12.0),
        GestureDetector(
          onTap: _toggleExpansion,
          behavior: HitTestBehavior.opaque,
          child: Container(
            alignment: Alignment.center,
            child: _buildIcon(context),
          ),
        ),
      ],
    );
  }

  Widget _buildChildren(BuildContext context, Widget? child) {
    final ThemeData theme = Theme.of(context);
    final TxExpansionPanelThemeData expansionPanelTheme =
        TxExpansionPanelTheme.of(context);
    final ExpansionTileThemeData expansionTileTheme =
        ExpansionTileTheme.of(context);
    final ShapeBorder expansionTileBorder =
        _border.value ?? const RoundedRectangleBorder();
    final Clip clipBehavior = widget.clipBehavior ??
        expansionPanelTheme.clipBehavior ??
        expansionTileTheme.clipBehavior ??
        Clip.none;
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final String onTapHint = _isExpanded
        ? localizations.expansionTileExpandedTapHint
        : localizations.expansionTileCollapsedTapHint;
    String? semanticsHint;
    switch (theme.platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        semanticsHint = _isExpanded
            ? '${localizations.collapsedHint}\n '
                '${localizations.expansionTileExpandedHint}'
            : '${localizations.expandedHint}\n '
                '${localizations.expansionTileCollapsedHint}';
      case TargetPlatform.android:
      case TargetPlatform.ohos:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        break;
    }

    Widget content = ClipRect(
      child: Align(
        alignment: widget.expandedAlignment ??
            expansionTileTheme.expandedAlignment ??
            Alignment.center,
        heightFactor: _heightFactor.value,
        child: child,
      ),
    );
    if (widget.collapsedChildren?.isNotEmpty == true) {
      content = _buildContent(
        expansionPanelTheme,
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:
              widget.expandedCrossAxisAlignment ?? CrossAxisAlignment.stretch,
          children: [
            ...widget.collapsedChildren!,
            content,
          ],
        ),
      );
    }

    return Container(
      clipBehavior: clipBehavior,
      decoration: ShapeDecoration(
        color: _backgroundColor.value ??
            expansionTileTheme.backgroundColor ??
            Colors.transparent,
        shape: expansionTileBorder,
      ),
      child: Semantics(
        hint: semanticsHint,
        onTapHint: onTapHint,
        child: ListTileTheme.merge(
          iconColor: _iconColor.value ?? expansionTileTheme.iconColor,
          textColor: _headerColor.value,
          child: TxPanel(
            enabled: widget.enabled,
            onTap: _handleTap,
            dense: widget.dense,
            visualDensity: widget.visualDensity,
            enableFeedback: widget.enableFeedback,
            padding: widget.panelPadding ?? expansionPanelTheme.panelPadding,
            leading: widget.leading ?? _buildLeadingIcon(context),
            title: widget.title,
            subtitle: widget.subtitle,
            trailing: widget.trailing ?? _buildTrailingIcon(context),
            footer: widget.footer ?? _buildFooter(context),
            content: content,
          ),
        ),
      ),
    );
  }

  Widget _buildContent(TxExpansionPanelThemeData theme, Widget child) {
    final Decoration? childrenDecoration =
        widget.childrenDecoration ?? theme.childrenDecoration;
    final EdgeInsetsGeometry? childrenPadding =
        widget.childrenPadding ?? theme.childrenPadding;

    if (childrenPadding != null) {
      child = Padding(padding: childrenPadding, child: child);
    }
    if (childrenDecoration != null) {
      child = DecoratedBox(decoration: childrenDecoration, child: child);
    }
    return child;
  }

  @override
  void didUpdateWidget(covariant TxExpansionPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    final ThemeData theme = Theme.of(context);
    final ExpansionTileThemeData expansionTileTheme =
        ExpansionTileTheme.of(context);
    final TxExpansionPanelThemeData expansionPanelTheme =
        TxExpansionPanelTheme.of(context);
    final ExpansionTileThemeData defaults = _ExpansionTileDefaultsM3(context);
    if (widget.collapsedShape != oldWidget.collapsedShape ||
        widget.shape != oldWidget.shape) {
      _updateShapeBorder(expansionPanelTheme, expansionTileTheme, theme);
    }
    if (widget.collapsedTextColor != oldWidget.collapsedTextColor ||
        widget.textColor != oldWidget.textColor) {
      _updateHeaderColor(expansionPanelTheme, expansionTileTheme, defaults);
    }
    if (widget.collapsedIconColor != oldWidget.collapsedIconColor ||
        widget.iconColor != oldWidget.iconColor) {
      _updateIconColor(expansionPanelTheme, expansionTileTheme, defaults);
    }
    if (widget.backgroundColor != oldWidget.backgroundColor ||
        widget.collapsedBackgroundColor != oldWidget.collapsedBackgroundColor) {
      _updateBackgroundColor(expansionPanelTheme, expansionTileTheme);
    }
    if (widget.expansionAnimationStyle != oldWidget.expansionAnimationStyle) {
      _updateAnimationDuration(expansionPanelTheme, expansionTileTheme);
      _updateHeightFactorCurve(expansionPanelTheme, expansionTileTheme);
    }
  }

  @override
  void didChangeDependencies() {
    final ThemeData theme = Theme.of(context);
    final ExpansionTileThemeData expansionTileTheme =
        ExpansionTileTheme.of(context);
    final TxExpansionPanelThemeData expansionPanelTheme =
        TxExpansionPanelTheme.of(context);
    final ExpansionTileThemeData defaults = _ExpansionTileDefaultsM3(context);
    _updateAnimationDuration(expansionPanelTheme, expansionTileTheme);
    _updateShapeBorder(expansionPanelTheme, expansionTileTheme, theme);
    _updateHeaderColor(expansionPanelTheme, expansionTileTheme, defaults);
    _updateIconColor(expansionPanelTheme, expansionTileTheme, defaults);
    _updateBackgroundColor(expansionPanelTheme, expansionTileTheme);
    _updateHeightFactorCurve(expansionPanelTheme, expansionTileTheme);
    super.didChangeDependencies();
  }

  void _updateAnimationDuration(
    TxExpansionPanelThemeData expansionPanelTheme,
    ExpansionTileThemeData expansionTileTheme,
  ) {
    _animationController.duration = widget.expansionAnimationStyle?.duration ??
        expansionPanelTheme.expansionAnimationStyle?.duration ??
        // expansionTileTheme.expansionAnimationStyle?.duration ??
        _kExpand;
  }

  void _updateShapeBorder(
    TxExpansionPanelThemeData expansionPanelTheme,
    ExpansionTileThemeData expansionTileTheme,
    ThemeData theme,
  ) {
    _borderTween
      ..begin = widget.collapsedShape ??
          expansionPanelTheme.collapsedShape ??
          expansionTileTheme.collapsedShape ??
          const RoundedRectangleBorder()
      ..end = widget.shape ??
          expansionPanelTheme.shape ??
          expansionTileTheme.shape ??
          const RoundedRectangleBorder();
  }

  void _updateHeaderColor(
    TxExpansionPanelThemeData expansionPanelTheme,
    ExpansionTileThemeData expansionTileTheme,
    ExpansionTileThemeData defaults,
  ) {
    _headerColorTween
      ..begin = widget.collapsedTextColor ??
          expansionPanelTheme.collapsedTextColor ??
          expansionTileTheme.collapsedTextColor ??
          defaults.collapsedTextColor
      ..end = widget.textColor ??
          expansionPanelTheme.textColor ??
          expansionTileTheme.textColor ??
          defaults.textColor;
  }

  void _updateIconColor(
    TxExpansionPanelThemeData expansionPanelTheme,
    ExpansionTileThemeData expansionTileTheme,
    ExpansionTileThemeData defaults,
  ) {
    _iconColorTween
      ..begin = widget.collapsedIconColor ??
          expansionPanelTheme.collapsedIconColor ??
          expansionTileTheme.collapsedIconColor ??
          defaults.collapsedIconColor
      ..end = widget.iconColor ??
          expansionPanelTheme.iconColor ??
          expansionTileTheme.iconColor ??
          defaults.iconColor;
  }

  void _updateBackgroundColor(
    TxExpansionPanelThemeData expansionPanelTheme,
    ExpansionTileThemeData expansionTileTheme,
  ) {
    _backgroundColorTween
      ..begin = widget.collapsedBackgroundColor ??
          expansionPanelTheme.collapsedBackgroundColor ??
          expansionTileTheme.collapsedBackgroundColor
      ..end = widget.backgroundColor ??
          expansionPanelTheme.backgroundColor ??
          expansionTileTheme.backgroundColor;
  }

  void _updateHeightFactorCurve(
    TxExpansionPanelThemeData expansionPanelTheme,
    ExpansionTileThemeData expansionTileTheme,
  ) {
    _heightFactorTween.curve = widget.expansionAnimationStyle?.curve ??
        expansionPanelTheme.expansionAnimationStyle?.curve ??
        // expansionTileTheme.expansionAnimationStyle?.curve ??
        Curves.easeIn;
  }

  @override
  Widget build(BuildContext context) {
    final bool closed = !_isExpanded && _animationController.isDismissed;
    final bool shouldRemoveChildren = closed && !widget.maintainState;

    final Widget result = Offstage(
      offstage: closed,
      child: TickerMode(
        enabled: !closed,
        child: Column(
          crossAxisAlignment:
              widget.expandedCrossAxisAlignment ?? CrossAxisAlignment.stretch,
          children: widget.children,
        ),
      ),
    );

    return AnimatedBuilder(
      animation: _animationController.view,
      builder: _buildChildren,
      child: shouldRemoveChildren ? null : result,
    );
  }
}

class _ExpansionTileDefaultsM3 extends ExpansionTileThemeData {
  _ExpansionTileDefaultsM3(this.context);

  final BuildContext context;
  late final ThemeData _theme = Theme.of(context);
  late final ColorScheme _colors = _theme.colorScheme;

  @override
  Color? get textColor => _colors.outlineVariant;

  @override
  Color? get iconColor => _colors.outlineVariant;

  @override
  Color? get collapsedTextColor => _colors.outlineVariant;

  @override
  Color? get collapsedIconColor => _colors.outlineVariant;
}
