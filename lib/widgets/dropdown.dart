// ignore_for_file: prefer_mixin

import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

const Duration _kTxDropdownMenuDuration = Duration(milliseconds: 300);
const double _kMenuItemHeight = kMinInteractiveDimension;
const double _kDenseButtonHeight = 24.0;
const EdgeInsets _kMenuItemPadding = EdgeInsets.symmetric(horizontal: 16.0);
const EdgeInsetsGeometry _kAlignedButtonPadding =
    EdgeInsetsDirectional.only(start: 16.0, end: 4.0);
const EdgeInsets _kUnalignedButtonPadding = EdgeInsets.zero;
const EdgeInsets _kAlignedMenuMargin = EdgeInsets.zero;
const EdgeInsetsGeometry _kUnalignedMenuMargin =
    EdgeInsetsDirectional.only(start: 16.0, end: 24.0);

typedef TxDropdownButtonBuilder = List<Widget> Function(BuildContext context);

class _TxDropdownMenuPainter extends CustomPainter {
  _TxDropdownMenuPainter({
    required this.resize,
    required this.getSelectedItemOffset,
    this.color,
    this.elevation,
    this.borderRadius,
  })  : _painter = BoxDecoration(
          // 如果您在此处添加图像，则必须在 paint() 函数中提供真实的配置，你必须在这里提供
          // onChanged 回调的排序。
          color: color,
          borderRadius:
              borderRadius ?? const BorderRadius.all(Radius.circular(2.0)),
          boxShadow: kElevationToShadow[elevation],
        ).createBoxPainter(),
        super(repaint: resize);

  final Color? color;
  final int? elevation;
  final BorderRadius? borderRadius;
  final Animation<double> resize;
  final ValueGetter<double> getSelectedItemOffset;
  final BoxPainter _painter;

  @override
  void paint(Canvas canvas, Size size) {
    final Tween<double> bottom = Tween<double>(
      begin: 0.0,
      end: size.height,
    );

    final Rect rect =
        Rect.fromLTRB(0.0, 0.0, size.width, bottom.evaluate(resize));

    _painter.paint(canvas, rect.topLeft, ImageConfiguration(size: rect.size));
  }

  @override
  bool shouldRepaint(_TxDropdownMenuPainter oldPainter) {
    return oldPainter.color != color ||
        oldPainter.elevation != elevation ||
        oldPainter.borderRadius != borderRadius ||
        oldPainter.resize != resize;
  }
}

// 作为包装菜单项的按钮的小部件。
class _TxDropdownMenuItemButton<T> extends StatefulWidget {
  const _TxDropdownMenuItemButton({
    required this.route,
    required this.buttonRect,
    required this.constraints,
    required this.itemIndex,
    required this.enableFeedback,
    super.key,
    this.padding,
  });

  final _TxDropdownRoute<T> route;
  final EdgeInsets? padding;
  final Rect buttonRect;
  final BoxConstraints constraints;
  final int itemIndex;
  final bool enableFeedback;

  @override
  _TxDropdownMenuItemButtonState<T> createState() =>
      _TxDropdownMenuItemButtonState<T>();
}

class _TxDropdownMenuItemButtonState<T>
    extends State<_TxDropdownMenuItemButton<T>> {
  void _handleFocusChange(bool focused) {
    final bool inTraditionalMode;
    switch (FocusManager.instance.highlightMode) {
      case FocusHighlightMode.touch:
        inTraditionalMode = false;
        break;
      case FocusHighlightMode.traditional:
        inTraditionalMode = true;
        break;
    }

    if (focused && inTraditionalMode) {
      final _MenuLimits menuLimits = widget.route.getMenuLimits(
        widget.buttonRect,
        widget.constraints.maxHeight,
        widget.itemIndex,
      );
      widget.route.scrollController!.animateTo(
        menuLimits.scrollOffset,
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: 100),
      );
    }
  }

  void _handleOnTap() {
    final TxDropdownMenuItem<T> dropdownMenuItem =
        widget.route.items[widget.itemIndex].item!;

    dropdownMenuItem.onTap?.call();

    Navigator.pop(
      context,
      _TxDropdownRouteResult<T>(dropdownMenuItem.value),
    );
  }

  static const Map<ShortcutActivator, Intent> _webShortcuts =
      <ShortcutActivator, Intent>{
    // 在web上，上/下不会改变焦点，除了 <select> 元素，这是下拉菜单所模拟的。
    SingleActivator(LogicalKeyboardKey.arrowDown):
        DirectionalFocusIntent(TraversalDirection.down),
    SingleActivator(LogicalKeyboardKey.arrowUp):
        DirectionalFocusIntent(TraversalDirection.up),
  };

  @override
  Widget build(BuildContext context) {
    final TxDropdownMenuItem<T> dropdownMenuItem =
        widget.route.items[widget.itemIndex].item!;
    final double unit = 0.5 / (widget.route.items.length + 1.0);

    final double start = (widget.itemIndex + 1) * unit;
    final double end = (start + 1.5 * unit).clamp(0.0, 1.0);
    final CurvedAnimation opacity = CurvedAnimation(
      parent: widget.route.animation!,
      curve: Interval(start, end),
    );

    Color? backgroundColor;
    Widget child = widget.route.items[widget.itemIndex];
    if (widget.itemIndex == widget.route.selectedIndex) {
      backgroundColor = Theme.of(context).colorScheme.primaryContainer;
    }
    child = Container(
      padding: widget.padding,
      height: widget.route.itemHeight,
      color: backgroundColor,
      child: child,
    );
    //[InkWell] 只有在启用时才会添加到项中
    if (dropdownMenuItem.enabled) {
      child = InkWell(
        autofocus: widget.itemIndex == widget.route.selectedIndex,
        enableFeedback: widget.enableFeedback,
        onTap: _handleOnTap,
        onFocusChange: _handleFocusChange,
        child: child,
      );
    }
    child = FadeTransition(opacity: opacity, child: child);
    if (kIsWeb && dropdownMenuItem.enabled) {
      child = Shortcuts(
        shortcuts: _webShortcuts,
        child: child,
      );
    }
    return child;
  }
}

class _TxDropdownMenu<T> extends StatefulWidget {
  const _TxDropdownMenu({
    required this.route,
    required this.buttonRect,
    required this.constraints,
    required this.enableFeedback,
    super.key,
    this.padding,
    this.dropdownColor,
    this.borderRadius,
  });

  final _TxDropdownRoute<T> route;
  final EdgeInsets? padding;
  final Rect buttonRect;
  final BoxConstraints constraints;
  final Color? dropdownColor;
  final bool enableFeedback;
  final BorderRadius? borderRadius;

  @override
  _TxDropdownMenuState<T> createState() => _TxDropdownMenuState<T>();
}

class _TxDropdownMenuState<T> extends State<_TxDropdownMenu<T>> {
  late CurvedAnimation _fadeOpacity;
  late CurvedAnimation _resize;

  @override
  void initState() {
    super.initState();
    // 由于它们的曲线的方向，我们需要将这些动画保持为状态。 当路线的动画反转时，如果我们要重新
    // 创建build中的 CurvedAnimation 对象，我们会丢失CurvedAnimation._curveDirection.
    _fadeOpacity = CurvedAnimation(
      parent: widget.route.animation!,
      curve: const Interval(0.0, 0.25),
      reverseCurve: const Interval(0.75, 1.0),
    );
    _resize = CurvedAnimation(
      parent: widget.route.animation!,
      curve: const Interval(0.25, 0.5),
      reverseCurve: const Threshold(0.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 菜单分三个阶段显示（括号内为单位时间）：
    // [0s - 0.25s] - 淡入带有所选项目的矩形大小的菜单容器。
    // [0.25s - 0.5s] - 从中心开始增加原本为空的菜单容器直到它足够大，可以容纳我们要展示
    // 的项目。
    // [0.5s - 1.0s] 从上到下淡入剩余的可见项目。
    //
    // 当菜单被关闭时，我们只是在前 0.25 秒内淡出整个菜单。
    assert(debugCheckHasMaterialLocalizations(context));
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final _TxDropdownRoute<T> route = widget.route;
    final List<Widget> children = <Widget>[
      for (int itemIndex = 0; itemIndex < route.items.length; ++itemIndex)
        _TxDropdownMenuItemButton<T>(
          route: widget.route,
          padding: widget.padding,
          buttonRect: widget.buttonRect,
          constraints: widget.constraints,
          itemIndex: itemIndex,
          enableFeedback: widget.enableFeedback,
        ),
    ];

    return FadeTransition(
      opacity: _fadeOpacity,
      child: CustomPaint(
        painter: _TxDropdownMenuPainter(
          color: widget.dropdownColor ?? Theme.of(context).canvasColor,
          elevation: route.elevation,
          resize: _resize,
          borderRadius: widget.borderRadius,
          // 此偏移量作为回调传递，而不是值，因为它必须在绘制时（布局后）检索，而不是在构建时
          // 检索。
          getSelectedItemOffset: () => route.getItemOffset(route.selectedIndex),
        ),
        child: Semantics(
          scopesRoute: true,
          namesRoute: true,
          explicitChildNodes: true,
          label: localizations.popupMenuLabel,
          child: ClipRRect(
            borderRadius: widget.borderRadius ?? BorderRadius.zero,
            clipBehavior:
                widget.borderRadius != null ? Clip.antiAlias : Clip.none,
            child: Material(
              type: MaterialType.transparency,
              textStyle: route.style,
              child: ScrollConfiguration(
                // 下拉菜单不应过度滚动或显示过度滚动指示器。
                // 下面内置了滚动条。
                // 平台必须使用 Theme 并且 ScrollPhysics 必须是 Clamping。
                behavior: ScrollConfiguration.of(context).copyWith(
                  scrollbars: false,
                  overscroll: false,
                  physics: const ClampingScrollPhysics(),
                  platform: Theme.of(context).platform,
                ),
                child: PrimaryScrollController(
                  controller: widget.route.scrollController!,
                  child: Scrollbar(
                    thumbVisibility: true,
                    child: ListView(
                      // 确保这始终继承 PrimaryScrollController
                      primary: true,
                      padding: kMaterialListPadding,
                      shrinkWrap: true,
                      children: children,
                    ),
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

class _TxDropdownMenuRouteLayout<T> extends SingleChildLayoutDelegate {
  _TxDropdownMenuRouteLayout({
    required this.buttonRect,
    required this.route,
    required this.textDirection,
  });

  final Rect buttonRect;
  final _TxDropdownRoute<T> route;
  final TextDirection? textDirection;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    // 简单菜单的最大高度应小于一行或多行视图高度。 这确保了简单菜单之外的可点击区域关闭菜单。
    double maxHeight =
        math.max(0.0, constraints.maxHeight - 2 * _kMenuItemHeight);
    if (route.menuMaxHeight != null && route.menuMaxHeight! <= maxHeight) {
      maxHeight = route.menuMaxHeight!;
    }
    // 菜单的宽度最多应为视图宽度。 这确保了 菜单不会超出屏幕的左右边缘。
    final double width = math.min(constraints.maxWidth, buttonRect.width);
    return BoxConstraints(
      minWidth: width,
      maxWidth: width,
      maxHeight: maxHeight,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final _MenuLimits menuLimits =
        route.getMenuLimits(buttonRect, size.height, route.selectedIndex);

    assert(() {
      final Rect container = Offset.zero & size;
      if (container.intersect(buttonRect) == buttonRect) {
        // 如果按钮完全在屏幕上，则验证菜单也在屏幕上。
        assert(menuLimits.top >= 0.0);
        assert(menuLimits.top + menuLimits.height <= size.height);
      }
      return true;
    }());
    assert(textDirection != null);
    final double left;
    switch (textDirection!) {
      case TextDirection.rtl:
        left = clampDouble(buttonRect.right, 0.0, size.width) - childSize.width;
        break;
      case TextDirection.ltr:
        left = clampDouble(buttonRect.left, 0.0, size.width - childSize.width);
        break;
    }

    return Offset(left, menuLimits.top);
  }

  @override
  bool shouldRelayout(_TxDropdownMenuRouteLayout<T> oldDelegate) {
    return buttonRect != oldDelegate.buttonRect ||
        textDirection != oldDelegate.textDirection;
  }
}

// 我们把返回值封装起来，这样返回值就可以为null。 否则，取消路由（返回 null）会与 actually
// 混淆返回一个真正的空值。
@immutable
class _TxDropdownRouteResult<T> {
  const _TxDropdownRouteResult(this.result);

  final T? result;

  @override
  bool operator ==(Object other) {
    return other is _TxDropdownRouteResult<T> && other.result == result;
  }

  @override
  int get hashCode => result.hashCode;
}

class _MenuLimits {
  const _MenuLimits(this.top, this.bottom, this.height, this.scrollOffset);

  final double top;
  final double bottom;
  final double height;
  final double scrollOffset;
}

class _TxDropdownRoute<T> extends PopupRoute<_TxDropdownRouteResult<T>> {
  _TxDropdownRoute({
    required this.capturedThemes,
    required this.style,
    required this.items,
    required this.padding,
    required this.buttonRect,
    required this.selectedIndex,
    required this.enableFeedback,
    this.elevation = 8,
    this.barrierLabel,
    this.itemHeight,
    this.dropdownColor,
    this.menuMaxHeight,
    this.borderRadius,
    this.highlightColor,
  }) : itemHeights = List<double>.filled(
            items.length, itemHeight ?? kMinInteractiveDimension);

  final List<_MenuItem<T>> items;
  final EdgeInsetsGeometry padding;
  final Rect buttonRect;
  final int selectedIndex;
  final int elevation;
  final CapturedThemes capturedThemes;
  final TextStyle style;
  final double? itemHeight;
  final Color? dropdownColor;
  final double? menuMaxHeight;
  final bool enableFeedback;
  final BorderRadius? borderRadius;
  final Color? highlightColor;

  final List<double> itemHeights;
  ScrollController? scrollController;

  @override
  Duration get transitionDuration => _kTxDropdownMenuDuration;

  @override
  bool get barrierDismissible => true;

  @override
  Color? get barrierColor => null;

  @override
  final String? barrierLabel;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return _TxDropdownRoutePage<T>(
          route: this,
          constraints: constraints,
          items: items,
          padding: padding,
          buttonRect: buttonRect,
          selectedIndex: selectedIndex,
          elevation: elevation,
          capturedThemes: capturedThemes,
          style: style,
          dropdownColor: dropdownColor,
          enableFeedback: enableFeedback,
          borderRadius: borderRadius,
        );
      },
    );
  }

  void _dismiss() {
    if (isActive) {
      navigator?.removeRoute(this);
    }
  }

  double getItemOffset(int index) {
    double offset = kMaterialListPadding.top;
    if (items.isNotEmpty && index > 0) {
      assert(items.length == itemHeights.length);
      offset += itemHeights
          .sublist(0, index)
          .reduce((double total, double height) => total + height);
    }
    return offset;
  }

  // 返回菜单的垂直范围和包含菜单项的 ListView 的初始 scrollOffset。 在给定
  // availableHeight 的情况下，所选项目的垂直中心与按钮的垂直中心对齐。
  _MenuLimits getMenuLimits(
      Rect buttonRect, double availableHeight, int index) {
    double computedMaxHeight = availableHeight - 2.0 * _kMenuItemHeight;
    if (menuMaxHeight != null) {
      computedMaxHeight = math.min(computedMaxHeight, menuMaxHeight!);
    }
    final double buttonTop = buttonRect.top;
    final double buttonBottom = math.min(buttonRect.bottom, availableHeight);
    final double selectedItemOffset = getItemOffset(index);

    // 如果按钮被放置在屏幕的底部或顶部，它的顶部或底部距离屏幕边缘可能小于[_kMenuItemHeight]。
    // 在这种情况下，我们要更改菜单限制以与顶部或底部对齐 按钮的边缘。
    final double topLimit = math.min(_kMenuItemHeight, buttonTop);
    final double bottomLimit =
        math.max(availableHeight - _kMenuItemHeight, buttonBottom);

    double menuTop = buttonBottom + 5.0;
    double preferredMenuHeight = kMaterialListPadding.vertical;
    if (items.isNotEmpty) {
      preferredMenuHeight +=
          itemHeights.reduce((double total, double height) => total + height);
    }

    // 如果菜单中的元素太多，我们需要将其缩小，使其最多为 computedMaxHeight。
    final double menuHeight = math.min(computedMaxHeight, preferredMenuHeight);
    double menuBottom = menuTop + menuHeight;

    // 如果菜单的计算顶部或底部超出指定范围，我们需要将它们放入范围内。 如果项目高度大于按钮高
    // 度并且按钮位于屏幕的最底部或顶部，则菜单将分别与按钮的底部或顶部对齐。
    if (menuTop < topLimit) {
      menuTop = math.min(buttonTop, topLimit);
      menuBottom = menuTop + menuHeight;
    }

    if (menuBottom > bottomLimit) {
      menuBottom = math.max(buttonBottom, bottomLimit);
      menuTop = menuBottom - menuHeight;
    }

    if (menuBottom - itemHeights[selectedIndex] / 2.0 <
        buttonBottom - buttonRect.height / 2.0) {
      menuBottom = buttonBottom -
          buttonRect.height / 2.0 +
          itemHeights[selectedIndex] / 2.0;
      menuTop = menuBottom - menuHeight;
    }

    double scrollOffset = 0;
    // 如果所有菜单项都不适合 availableHeight，则计算滚动偏移量，使所选菜单项与选择项对齐。
    // 这仅在菜单首次显示时完成 - 随后我们将滚动偏移保留在用户离开的位置。 此滚动偏移仅适用于
    // 固定高度的菜单项（默认值）。
    if (preferredMenuHeight > computedMaxHeight) {
      // 如果所选项目在菜单开头可见，则偏移量应为零。 否则，滚动偏移应尽可能使项目居中。
      scrollOffset = math.max(0.0, selectedItemOffset - (buttonTop - menuTop));
      // 如果所选项目的滚动偏移量大于最大滚动偏移量，则将其设置为允许的最大滚动偏移量。
      scrollOffset = math.min(scrollOffset, preferredMenuHeight - menuHeight);
    }

    assert((menuBottom - menuTop - menuHeight).abs() < precisionErrorTolerance);
    return _MenuLimits(menuTop, menuBottom, menuHeight, scrollOffset);
  }
}

class _TxDropdownRoutePage<T> extends StatelessWidget {
  const _TxDropdownRoutePage({
    required this.route,
    required this.constraints,
    required this.padding,
    required this.buttonRect,
    required this.selectedIndex,
    required this.capturedThemes,
    required this.dropdownColor,
    required this.enableFeedback,
    super.key,
    this.items,
    this.elevation = 8,
    this.style,
    this.borderRadius,
  });

  final _TxDropdownRoute<T> route;
  final BoxConstraints constraints;
  final List<_MenuItem<T>>? items;
  final EdgeInsetsGeometry padding;
  final Rect buttonRect;
  final int selectedIndex;
  final int elevation;
  final CapturedThemes capturedThemes;
  final TextStyle? style;
  final Color? dropdownColor;
  final bool enableFeedback;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasDirectionality(context));

    // 现在计算 initialScrollOffset，在项目被布局之前。 这仅在项目高度有效固定时有效，
    // 即指定 TxDropdownButton.itemHeight 或 TxDropdownButton.itemHeight 为 null 并且
    // 所有项目的固有高度都小于 kMinInteractiveDimension。 否则，initialScrollOffset
    // 只是一个粗略的近似值，基于将项目视为它们的高度都等于 kMinInteractiveDimension。
    if (route.scrollController == null) {
      final _MenuLimits menuLimits =
          route.getMenuLimits(buttonRect, constraints.maxHeight, selectedIndex);
      route.scrollController =
          ScrollController(initialScrollOffset: menuLimits.scrollOffset);
    }

    final TextDirection? textDirection = Directionality.maybeOf(context);
    final Widget menu = _TxDropdownMenu<T>(
      route: route,
      padding: padding.resolve(textDirection),
      buttonRect: buttonRect,
      constraints: constraints,
      dropdownColor: dropdownColor,
      enableFeedback: enableFeedback,
      borderRadius: borderRadius,
    );

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      removeLeft: true,
      removeRight: true,
      child: Builder(
        builder: (BuildContext context) {
          return CustomSingleChildLayout(
            delegate: _TxDropdownMenuRouteLayout<T>(
              buttonRect: buttonRect,
              route: route,
              textDirection: textDirection,
            ),
            child: capturedThemes.wrap(menu),
          );
        },
      ),
    );
  }
}

// 此小部件使 _TxDropdownRoute 能够查找每个菜单项的大小。
// 这些大小用于计算所选项目的偏移量，以便 _TxDropdownRoutePage 可以将所选项目的垂直中心与下拉
// 按钮的垂直中心尽可能对齐。
class _MenuItem<T> extends SingleChildRenderObjectWidget {
  const _MenuItem({
    required this.onLayout,
    required this.item,
    super.key,
  }) : super(child: item);

  final ValueChanged<Size> onLayout;
  final TxDropdownMenuItem<T>? item;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderMenuItem(onLayout);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant _RenderMenuItem renderObject) {
    renderObject.onLayout = onLayout;
  }
}

class _RenderMenuItem extends RenderProxyBox {
  _RenderMenuItem(this.onLayout, [RenderBox? child]) : super(child);

  ValueChanged<Size> onLayout;

  @override
  void performLayout() {
    super.performLayout();
    onLayout(size);
  }
}

// [TxDropdownButton] 创建的菜单项的容器小部件。
// 它为 [TxDropdownMenuItem] 提供默认配置，以及 [TxDropdownButton] 的提示和 disabledHint 小部件。
class _DropdownMenuItemContainer extends StatelessWidget {
  /// 为下拉菜单创建一个项目。
  ///
  /// [child] 参数是必需的。
  const _DropdownMenuItemContainer({
    required this.child,
    super.key,
    this.alignment = AlignmentDirectional.centerStart,
  });

  /// 树中此小部件下方的小部件。
  ///
  /// 通常是 [Text] 小部件。
  final Widget child;

  /// 定义项目在容器中的定位方式。
  ///
  /// 此属性不能为空。 它默认为 [AlignmentDirectional.centerStart]。
  ///
  /// 参考：
  ///
  /// * [Alignment]，一个具有方便常量的类，通常用于指定一个[AlignmentGeometry]。
  /// * [AlignmentDirectional]，像[Alignment]一样用于指定对齐方式相对于文本方向。
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: _kMenuItemHeight),
      alignment: alignment,
      child: child,
    );
  }
}

/// 由 [TxDropdownButton] 创建的菜单中的项目。
///
/// `T` 类型是条目表示的值的类型。 给定菜单中的所有条目必须表示具有一致类型的值。
class TxDropdownMenuItem<T> extends _DropdownMenuItemContainer {
  /// 为下拉菜单创建一个项目。
  ///
  /// [child] 参数是必需的。
  const TxDropdownMenuItem({
    required super.child,
    super.key,
    this.onTap,
    this.value,
    this.enabled = true,
    super.alignment,
  });

  /// 点击下拉菜单项时调用。
  final VoidCallback? onTap;

  /// 如果用户选择此菜单项，则返回值。
  ///
  /// 最终在对 [TxDropdownButton.onChanged] 的调用中返回。
  final T? value;

  /// 用户是否可以选择这个菜单项。
  ///
  /// 默认为 `true`。
  final bool enabled;
}

/// 一个继承的小部件，它会导致任何后代 [TxDropdownButton] 小部件不包含它们的常规下划线。
///
/// 根据 Material Design 规范的要求，[DataTable] 使用它来从放置在材料数据表中的任何
/// [TxDropdownButton] 小部件中删除下划线。
class TxDropdownButtonHideUnderline extends InheritedWidget {
  /// Creates a [TxDropdownButtonHideUnderline]. A non-null [child] must
  /// be given.
  const TxDropdownButtonHideUnderline({
    required super.child,
    super.key,
  });

  /// 返回是否应隐藏 [TxDropdownButton] 小部件的下划线。
  static bool at(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<
            TxDropdownButtonHideUnderline>() !=
        null;
  }

  @override
  bool updateShouldNotify(TxDropdownButtonHideUnderline oldWidget) => false;
}

/// 用于从项目列表中进行选择的 Material Design 按钮。
///
/// 下拉按钮允许用户从多个项目中进行选择。 该按钮显示当前选择的项目以及打开菜单以选择另一个项目
/// 的箭头。
///
/// 一个祖先必须是 [Material] 小部件，通常这是由应用程序的 [Scaffold] 提供的。
///
/// 类型“T”是每个下拉项代表的 [value] 的类型。 给定菜单中的所有条目必须表示具有一致类型的值。
/// 通常，使用枚举。 [items] 中的每个 [TxDropdownMenuItem] 都必须使用相同类型的参数进行专门化。
///
/// [onChanged] 回调应该更新定义下拉列表值的状态变量。 它还应调用 [State.setState]
/// 以使用新值重建下拉列表。
///
/// 如果 [onChanged] 回调为 null 或者 [items] 列表为 null 则下拉按钮将被禁用，即它的箭头
/// 将显示为灰色并且不会响应输入。 如果禁用按钮不为空，则将显示 [disabledHint] 小部件。
/// 但是，如果 [disabledHint] 为空且 [hint] 为非空，则将显示 [hint] 小部件。
///
/// 要求其祖先之一是 [Material] 小部件。
///
/// 参考：
///
/// * [TxDropdownButtonFormField]，与 [Form] 小部件集成。
/// * [TxDropdownMenuItem]，用于表示[项目]的类。
/// * [TxDropdownButtonHideUnderline]，防止其后代下拉按钮显示下划线。
/// * [ElevatedButton]、[TextButton]，触发单个动作的普通按钮。
class TxDropdownButton<T> extends StatefulWidget {
  /// 创建一个下拉按钮。
  ///
  /// [items] 必须具有不同的值。 如果 [value] 不为空，则它必须等于 [TxDropdownMenuItem]
  /// 值之一。 如果 [items] 或 [onChanged] 为空，按钮将被禁用，向下箭头将变灰。
  ///
  /// 如果[value] 为null 且按钮启用，则[hint] 为非null 时将显示。
  ///
  /// 如果[value] 为null 且按钮被禁用，则[disabledHint] 为非null 时将显示。
  /// 如果 [disabledHint] 为 null，则 [hint] 为非 null 时将显示。
  ///
  /// [elevation] 和 [iconSize] 参数不能为空（它们都有默认值，因此不需要指定）。
  /// 布尔 [isDense] 和 [isExpanded] 参数不能为空。
  ///
  /// [autofocus] 参数不能为空。
  ///
  /// [dropdownColor] 参数指定下拉菜单打开时的背景颜色。 如果为 null，则将使用当前主题的
  /// [ThemeData.canvasColor]。
  TxDropdownButton({
    required this.items,
    required this.onChanged,
    super.key,
    this.selectedItemBuilder,
    this.value,
    this.hint,
    this.disabledHint,
    this.onTap,
    this.elevation = 8,
    this.style,
    this.underline,
    this.icon,
    this.iconDisabledColor,
    this.iconEnabledColor,
    this.iconSize = 24.0,
    this.isDense = false,
    this.isExpanded = false,
    this.itemHeight = kMinInteractiveDimension,
    this.focusColor,
    this.focusNode,
    this.autofocus = false,
    this.dropdownColor,
    this.menuMaxHeight,
    this.enableFeedback,
    this.alignment = AlignmentDirectional.centerStart,
    this.borderRadius,
    this.selectedColor,
    this.padding,
    // 添加新参数时，考虑向 TxDropdownButtonFormField 添加类似的参数。
  })  : assert(
          items == null ||
              items.isEmpty ||
              value == null ||
              items.where((TxDropdownMenuItem<T> item) {
                    return item.value == value;
                  }).length ==
                  1,
          "There should be exactly one item with [TxDropdownButton]'s value: "
          '$value. \n'
          'Either zero or 2 or more [TxDropdownMenuItem]s were detected '
          'with the same value',
        ),
        assert(itemHeight == null || itemHeight >= kMinInteractiveDimension),
        _inputDecoration = null,
        _isEmpty = false,
        _isFocused = false;

  TxDropdownButton._formField({
    required this.items,
    required this.onChanged,
    required InputDecoration inputDecoration,
    required bool isEmpty,
    required bool isFocused,
    super.key,
    this.selectedItemBuilder,
    this.value,
    this.hint,
    this.disabledHint,
    this.onTap,
    this.elevation = 8,
    this.style,
    this.underline,
    this.icon,
    this.iconDisabledColor,
    this.iconEnabledColor,
    this.iconSize = 24.0,
    this.isDense = false,
    this.isExpanded = false,
    this.itemHeight = kMinInteractiveDimension,
    this.focusColor,
    this.focusNode,
    this.autofocus = false,
    this.dropdownColor,
    this.menuMaxHeight,
    this.enableFeedback,
    this.alignment = AlignmentDirectional.centerStart,
    this.borderRadius,
    this.selectedColor,
    this.padding,
  })  : assert(
          items == null ||
              items.isEmpty ||
              value == null ||
              items.where((TxDropdownMenuItem<T> item) {
                    return item.value == value;
                  }).length ==
                  1,
          "There should be exactly one item with [TxDropdownButtonFormField]'s "
          'value: $value. \n'
          'Either zero or 2 or more [TxDropdownMenuItem]s were detected '
          'with the same value',
        ),
        assert(itemHeight == null || itemHeight >= kMinInteractiveDimension),
        _inputDecoration = inputDecoration,
        _isEmpty = isEmpty,
        _isFocused = isFocused;

  /// 用户可以选择的项目列表。
  ///
  /// 如果 [onChanged] 回调为空或项目列表为空，则下拉按钮将被禁用，即其箭头将显示为灰色并且
  /// 不会响应输入。
  final List<TxDropdownMenuItem<T>>? items;

  /// 当前选中的 [TxDropdownMenuItem] 的值。
  ///
  /// 如果[value] 为null 且按钮启用，则[hint] 为非null 时将显示。
  ///
  /// 如果[value] 为null 且按钮被禁用，则[disabledHint] 为非null 时将显示。
  /// 如果 [disabledHint] 为 null，则 [hint] 为非 null 时将显示。
  final T? value;

  /// 由下拉按钮显示的占位符小部件。
  ///
  /// 如果 [value] 为 null 并且下拉菜单已启用（[items] 和 [onChanged] 为非 null），
  /// 则此小部件将显示为下拉按钮值的占位符。
  ///
  /// 如果 [value] 为 null 并且下拉菜单被禁用并且 [disabledHint] 为 null，则此小部件
  /// 用作占位符。
  final Widget? hint;

  /// 禁用下拉列表时显示的首选占位符小部件。
  ///
  /// 如果 [value] 为 null，则禁用下拉列表（[items] 或 [onChanged] 为 null），此小部件
  /// 显示为下拉按钮值的占位符。
  final Widget? disabledHint;

  /// {@template flutter.material.dropdownButton.onChanged}
  /// 当用户选择一个项目时调用。
  ///
  /// 如果 [onChanged] 回调为 null 或者 [TxDropdownButton.items] 列表为 null 则下拉按钮
  /// 将被禁用，即它的箭头将显示为灰色并且不会响应输入。 如果禁用按钮不为空，则将显示
  /// [TxDropdownButton.disabledHint] 小部件。 如果 [TxDropdownButton.disabledHint] 也
  /// 为空，但 [TxDropdownButton.hint] 不为空，则将显示 [TxDropdownButton.hint]。
  /// {@contemplate}
  final ValueChanged<T?>? onChanged;

  /// 点击下拉按钮时调用。
  ///
  /// 这与 [onChanged] 不同，后者在用户从下拉列表中选择项目时调用。
  ///
  /// 如果下拉按钮被禁用，则不会调用回调。
  final VoidCallback? onTap;

  /// 一个构建器，用于自定义与 [items] 中的 [TxDropdownMenuItem] 对应的下拉按钮。
  ///
  /// /// 当一个[TxDropdownMenuItem]被选中时，从列表中显示的widget对应于[items]中相同索引
  /// 的[TxDropdownMenuItem]。
  ///
  /// {@tool dartpad}
  /// 此示例显示了一个带有按钮的 `TxDropdownButton`，其中 [Text] 对应于 [TxDropdownMenuItem]
  /// 但与 [TxDropdownMenuItem] 不同。
  ///
  /// ** 请参阅 examples/api/lib/material/dropdown/dropdown_button.selected_item_builder.0.dart 中的代码 **
  /// {@end-tool}
  ///
  /// 如果此回调为 null，将显示 [items] 中匹配 [value] 的 [TxDropdownMenuItem]。
  final TxDropdownButtonBuilder? selectedItemBuilder;

  /// 打开时放置菜单的 z 坐标。
  ///
  /// 以下高度定义了阴影：1、2、3、4、6、8、9、12、16 和 24。参见 [kElevationToShadow]。
  ///
  /// 默认为 8，下拉按钮的适当高度。
  final int elevation;

  /// 用于下拉按钮和点击按钮时出现的下拉菜单中的文本的文本样式。
  ///
  /// 要在下拉按钮中显示的所选项目使用单独的文本样式，请考虑使用 [selectedItemBuilder]。
  ///
  /// {@tool dartpad}
  /// 此示例显示了一个下拉按钮文本样式与其菜单项不同的“TxDropdownButton”。
  ///
  /// ** 请参阅 examples/api/lib/material/dropdown/dropdown_button.style.0.dart 中的代码 **
  /// {@end-tool}
  ///
  /// 默认为当前 [Theme] 当前 [ThemeData.textTheme] 的 [TextTheme.titleMedium] 值。
  final TextStyle? style;

  /// 用于绘制下拉按钮下划线的小部件。
  ///
  /// 默认为 0.0 宽度的底部边框，颜色为 0xFFBDBDBD。
  final Widget? underline;

  /// 用于下拉按钮图标的小部件。
  ///
  /// 默认为带有 [Icons.arrow_drop_down] 字形的 [Icon]。
  final Widget? icon;

  /// 如果此按钮被禁用，即 [onChanged] 为 null，则 [icon] 的任何 [Icon] 后代的颜色。
  ///
  /// 当主题的 [ThemeData.brightness] 为 [Brightness.light] 时默认为 [Colors.grey]
  /// 的 [MaterialColor.shade400]，当主题为 [Brightness.dark] 时默认为 [Colors.white10]
  final Color? iconDisabledColor;

  /// 如果启用此按钮，即如果定义了 [onChanged]，则 [icon] 的任何 [Icon] 后代的颜色。
  ///
  /// 当主题的 [ThemeData.brightness] 为 [Brightness.light] 时默认为 [Colors.grey]
  /// 的 [MaterialColor.shade700]，当主题为 [Brightness.dark] 时默认为 [Colors.white70]
  final Color? iconEnabledColor;

  /// 用于下拉按钮的向下箭头图标按钮的大小。
  ///
  /// 默认为 24.0。
  final double iconSize;

  /// 降低按钮的高度。
  ///
  /// 默认情况下，此按钮的高度与其菜单项的高度相同。 如果 isDense 为真，按钮的高度将减少大约
  /// 一半。 当按钮嵌入到添加自己装饰的容器中时，这会很有用，例如 [InputDecorator]。
  final bool isDense;

  /// 将下拉列表的内部内容设置为水平填充其父项。
  ///
  /// 默认情况下，此按钮的内部宽度是其内容的最小尺寸。 如果 [isExpanded] 为真，内部宽度将
  /// 扩展以填充其周围的容器。
  final bool isExpanded;

  /// 如果为 null，则菜单项高度将根据每个菜单项的固有高度而变化。
  ///
  /// 默认值为 [kMinInteractiveDimension]，这也是菜单项的最小高度。
  ///
  /// 如果此值为 null 并且菜单没有足够的垂直空间，则菜单的初始滚动偏移可能不会将所选项目与下
  /// 拉按钮对齐。 这是因为，在这种情况下，初始滚动偏移的计算就好像所有菜单项的高度都是
  /// [kMinInteractiveDimension] 一样。
  final double? itemHeight;

  /// 按钮的 [Material] 具有输入焦点时的颜色。
  final Color? focusColor;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  /// {@macro flutter.widgets.Focus.autofocus}
  final bool autofocus;

  /// 下拉菜单的背景颜色。
  ///
  /// 如果未提供，将使用主题的 [ThemeData.canvasColor]。
  final Color? dropdownColor;

  /// 菜单的最大高度。
  ///
  /// 菜单的最大高度必须至少比应用视图的高度短一排。 这确保了简单菜单之外的可点击区域存在，
  /// 以便用户可以关闭菜单。
  ///
  /// 如果此属性设置为高于上述最大允许高度阈值，则菜单默认在菜单的顶部和底部填充一个菜单项的高度。
  final double? menuMaxHeight;

  /// 检测到的手势是否应提供声音和/或触觉反馈。
  ///
  /// 例如，在 Android 上，当启用反馈时，点击会产生咔哒声，长按会产生短促的振动。
  ///
  /// 默认情况下，启用特定于平台的反馈。
  ///
  /// 参考:
  ///
  ///  * [Feedback] 用于为某些操作提供特定于平台的反馈。
  final bool? enableFeedback;

  /// 定义提示或所选项目在按钮内的定位方式。
  ///
  /// 此属性不得为空。 它默认为 [AlignmentDirectional.centerStart]。
  ///
  /// 参考:
  ///
  ///  * [Alignment], 具有方便常量的类，通常用于指定 [AlignmentGeometry]。
  ///  * [AlignmentDirectional], 像 [Alignment] 用于指定相对于文本方向的对齐方式。
  final AlignmentGeometry alignment;

  /// 定义菜单圆角矩形的角半径。
  final BorderRadius? borderRadius;

  /// 定义按钮的内边距
  final EdgeInsetsGeometry? padding;

  final InputDecoration? _inputDecoration;

  final bool _isEmpty;

  final bool _isFocused;

  final Color? selectedColor;

  @override
  State<TxDropdownButton<T>> createState() => _TxDropdownButtonState<T>();
}

class _TxDropdownButtonState<T> extends State<TxDropdownButton<T>>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _iconTurns;
  int? _selectedIndex;
  _TxDropdownRoute<T>? _dropdownRoute;
  Orientation? _lastOrientation;
  FocusNode? _internalNode;

  FocusNode? get focusNode => widget.focusNode ?? _internalNode;
  bool _hasPrimaryFocus = false;
  late Map<Type, Action<Intent>> _actionMap;

  // 仅在需要创建 _internalNode 时使用。
  FocusNode _createFocusNode() {
    return FocusNode(debugLabel: '${widget.runtimeType}');
  }

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: _kTxDropdownMenuDuration);
    _iconTurns = _controller.drive(Tween<double>(begin: 0.0, end: 0.5)
        .chain(CurveTween(curve: Curves.easeIn)));
    _updateSelectedIndex();
    if (widget.focusNode == null) {
      _internalNode ??= _createFocusNode();
    }
    _actionMap = <Type, Action<Intent>>{
      ActivateIntent: CallbackAction<ActivateIntent>(
        onInvoke: (ActivateIntent intent) => _handleTap(),
      ),
      ButtonActivateIntent: CallbackAction<ButtonActivateIntent>(
        onInvoke: (ButtonActivateIntent intent) => _handleTap(),
      ),
    };
    focusNode!.addListener(_handleFocusChanged);
  }

  @override
  void dispose() {
    _controller.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _removeTxDropdownRoute();
    focusNode!.removeListener(_handleFocusChanged);
    _internalNode?.dispose();
    super.dispose();
  }

  void _removeTxDropdownRoute() {
    _dropdownRoute?._dismiss();
    _dropdownRoute = null;
    _lastOrientation = null;
  }

  void _handleFocusChanged() {
    if (_controller.status == AnimationStatus.completed) {
      _controller.reverse();
    }
    if (_hasPrimaryFocus != focusNode!.hasPrimaryFocus) {
      setState(() {
        _hasPrimaryFocus = focusNode!.hasPrimaryFocus;
      });
    }
  }

  @override
  void didUpdateWidget(TxDropdownButton<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode != oldWidget.focusNode) {
      oldWidget.focusNode?.removeListener(_handleFocusChanged);
      if (widget.focusNode == null) {
        _internalNode ??= _createFocusNode();
      }
      _hasPrimaryFocus = focusNode!.hasPrimaryFocus;
      focusNode!.addListener(_handleFocusChanged);
    }
    _updateSelectedIndex();
  }

  void _updateSelectedIndex() {
    if (widget.items == null ||
        widget.items!.isEmpty ||
        (widget.value == null &&
            widget.items!
                .where((TxDropdownMenuItem<T> item) =>
                    item.enabled && item.value == widget.value)
                .isEmpty)) {
      _selectedIndex = null;
      return;
    }

    assert(widget.items!
            .where((TxDropdownMenuItem<T> item) => item.value == widget.value)
            .length ==
        1);
    for (int itemIndex = 0; itemIndex < widget.items!.length; itemIndex++) {
      if (widget.items![itemIndex].value == widget.value) {
        _selectedIndex = itemIndex;
        return;
      }
    }
  }

  TextStyle? get _textStyle =>
      widget.style ?? Theme.of(context).textTheme.titleMedium;

  void _handleTap() {
    _controller.forward();
    final TextDirection? textDirection = Directionality.maybeOf(context);
    final EdgeInsetsGeometry menuMargin =
        ButtonTheme.of(context).alignedDropdown
            ? _kAlignedMenuMargin
            : _kUnalignedMenuMargin;

    final List<_MenuItem<T>> menuItems = <_MenuItem<T>>[
      for (int index = 0; index < widget.items!.length; index += 1)
        _MenuItem<T>(
          item: widget.items![index],
          onLayout: (Size size) {
            // 如果 [_dropdownRoute] 为 null 并且 onLayout 被调用，这意味着
            // performLayout 被调用在 _TxDropdownRoute 上，该 _TxDropdownRoute 还没有
            // 离开小部件树，但已经在它的出路上。
            //
            // 由于 onLayout 主要用于在布局之前收集每个菜单项的所需高度，因此不让
            // _TxDropdownRoute 收集每个项目的高度进行布局是可以的，因为路线已经在其出口处。
            if (_dropdownRoute == null) {
              return;
            }

            _dropdownRoute!.itemHeights[index] = size.height;
          },
        ),
    ];

    final NavigatorState navigator = Navigator.of(context);
    assert(_dropdownRoute == null);
    final RenderBox itemBox = context.findRenderObject()! as RenderBox;
    final Rect itemRect = itemBox.localToGlobal(Offset.zero,
            ancestor: navigator.context.findRenderObject()) &
        itemBox.size;
    final EdgeInsetsGeometry padding = _kMenuItemPadding.resolve(textDirection);
    _dropdownRoute = _TxDropdownRoute<T>(
      items: menuItems,
      buttonRect: menuMargin.resolve(textDirection).inflateRect(itemRect),
      padding: padding,
      selectedIndex: _selectedIndex ?? 0,
      elevation: widget.elevation,
      capturedThemes:
          InheritedTheme.capture(from: context, to: navigator.context),
      style: _textStyle!,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      itemHeight: widget.itemHeight,
      dropdownColor: widget.dropdownColor,
      menuMaxHeight: widget.menuMaxHeight,
      enableFeedback: widget.enableFeedback ?? true,
      borderRadius: widget.borderRadius,
    );

    focusNode?.requestFocus();
    navigator
        .push(_dropdownRoute!)
        .then<void>((_TxDropdownRouteResult<T>? newValue) {
      _removeTxDropdownRoute();
      if (!mounted || newValue == null) {
        return;
      }
      widget.onChanged?.call(newValue.result);
    });

    widget.onTap?.call();
  }

  // 当 isDense 为真时，将此按钮的高度从 _kMenuItemHeight 减小到 _kDenseButtonHeight，
  // 但不要使其小于它包含的文本。 类似地，我们不会将按钮的高度降低到其图标会被剪裁的程度。
  double get _denseButtonHeight {
    final double fontSize = _textStyle!.fontSize ??
        Theme.of(context).textTheme.titleMedium!.fontSize!;
    return math.max(fontSize, math.max(widget.iconSize, _kDenseButtonHeight));
  }

  Color get _iconColor {
    // Material Design 规范中未定义这些颜色。
    if (_enabled) {
      if (widget.iconEnabledColor != null) {
        return widget.iconEnabledColor!;
      }

      switch (Theme.of(context).brightness) {
        case Brightness.light:
          return Colors.grey.shade700;
        case Brightness.dark:
          return Colors.white70;
      }
    } else {
      if (widget.iconDisabledColor != null) {
        return widget.iconDisabledColor!;
      }

      switch (Theme.of(context).brightness) {
        case Brightness.light:
          return Colors.grey.shade400;
        case Brightness.dark:
          return Colors.white10;
      }
    }
  }

  bool get _enabled =>
      widget.items != null &&
      widget.items!.isNotEmpty &&
      widget.onChanged != null;

  Orientation _getOrientation(BuildContext context) {
    Orientation? result = MediaQuery.maybeOf(context)?.orientation;
    if (result == null) {
      // 如果没有 MediaQuery，则使用窗口方面来确定方向。
      final Size size = WidgetsBinding.instance.window.physicalSize;
      result = size.width > size.height
          ? Orientation.landscape
          : Orientation.portrait;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    assert(debugCheckHasMaterialLocalizations(context));
    final Orientation newOrientation = _getOrientation(context);
    _lastOrientation ??= newOrientation;
    if (newOrientation != _lastOrientation) {
      _removeTxDropdownRoute();
      _lastOrientation = newOrientation;
    }

    // 按钮和菜单的宽度由最宽的项目和提示的宽度定义。
    // 我们应该将项目列表显式类型化为 <Widget> 列表，否则，在提供提示和
    // selectedItemBuilder 时，没有显式类型添加项目可能会触发崩溃/失败。
    final List<Widget> items = widget.selectedItemBuilder == null
        ? (widget.items != null ? List<Widget>.of(widget.items!) : <Widget>[])
        : List<Widget>.of(widget.selectedItemBuilder!(context));

    int? hintIndex;
    if (widget.hint != null || (!_enabled && widget.disabledHint != null)) {
      Widget displayedHint =
          _enabled ? widget.hint! : widget.disabledHint ?? widget.hint!;
      if (widget.selectedItemBuilder == null) {
        displayedHint = _DropdownMenuItemContainer(
            alignment: widget.alignment, child: displayedHint);
      }

      hintIndex = items.length;
      items.add(DefaultTextStyle(
        style: _textStyle!.copyWith(color: Theme.of(context).hintColor),
        child: IgnorePointer(
          ignoringSemantics: false,
          child: displayedHint,
        ),
      ));
    }

    final EdgeInsetsGeometry padding = widget.padding ??
        (ButtonTheme.of(context).alignedDropdown
            ? _kAlignedButtonPadding
            : _kUnalignedButtonPadding);

    // 如果 value 为 null（然后 _selectedIndex 为 null），则我们显示提示或根本不显示
    // 任何内容。
    final Widget innerItemsWidget;
    if (items.isEmpty) {
      innerItemsWidget = Container();
    } else {
      innerItemsWidget = IndexedStack(
        index: _selectedIndex ?? hintIndex,
        alignment: widget.alignment,
        children: widget.isDense
            ? items
            : items.map((Widget item) {
                return widget.itemHeight != null
                    ? SizedBox(height: widget.itemHeight, child: item)
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[item]);
              }).toList(),
      );
    }

    final Widget defaultIcon = AnimatedBuilder(
      builder: (context, index) {
        return RotationTransition(
          turns: _iconTurns,
          child: const Icon(Icons.arrow_drop_down),
        );
      },
      animation: _iconTurns,
    );

    Widget result = DefaultTextStyle(
      style: _enabled
          ? _textStyle!
          : _textStyle!.copyWith(color: Theme.of(context).disabledColor),
      child: Container(
        padding: padding.resolve(Directionality.of(context)),
        height: widget.isDense ? _denseButtonHeight : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (widget.isExpanded)
              Expanded(child: innerItemsWidget)
            else
              innerItemsWidget,
            IconTheme(
              data: IconThemeData(
                color: _iconColor,
                size: widget.iconSize,
              ),
              child: widget.icon ?? defaultIcon,
            ),
          ],
        ),
      ),
    );

    if (!TxDropdownButtonHideUnderline.at(context)) {
      final double bottom =
          (widget.isDense || widget.itemHeight == null) ? 0.0 : 8.0;
      result = Stack(
        children: <Widget>[
          result,
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: bottom,
            child: widget.underline ??
                Container(
                  height: 1.0,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Color(0xFFBDBDBD),
                        width: 0.0,
                      ),
                    ),
                  ),
                ),
          ),
        ],
      );
    }

    final MouseCursor effectiveMouseCursor =
        MaterialStateProperty.resolveAs<MouseCursor>(
      MaterialStateMouseCursor.clickable,
      <MaterialState>{
        if (!_enabled) MaterialState.disabled,
      },
    );

    BorderRadius? borderRadius = widget.borderRadius;
    if (widget._inputDecoration != null) {
      if (widget._inputDecoration?.border is OutlineInputBorder) {
        borderRadius = (widget._inputDecoration!.border as OutlineInputBorder)
            .borderRadius;
      }
      result = InputDecorator(
        decoration: widget._inputDecoration!,
        isEmpty: widget._isEmpty,
        isFocused: widget._isFocused,
        child: result,
      );
    }

    return Semantics(
      button: true,
      child: Actions(
        actions: _actionMap,
        child: InkWell(
          mouseCursor: effectiveMouseCursor,
          onTap: _enabled ? _handleTap : null,
          canRequestFocus: _enabled,
          borderRadius: borderRadius,
          focusNode: focusNode,
          autofocus: widget.autofocus,
          focusColor: widget.focusColor ?? Theme.of(context).focusColor,
          enableFeedback: false,
          child: result,
        ),
      ),
    );
  }
}

/// 包含 [TxDropdownButton] 的 [FormField]。
///
/// 这是一个方便的小部件，将 [TxDropdownButton] 小部件包装在 [FormField] 中。
///
/// 不需要 [Form] 祖先。 [Form] 只是让一次保存、重置或验证多个字段变得更容易。 要在没有
/// [Form] 的情况下使用，请将 [GlobalKey] 传递给构造函数并使用 [GlobalKey.currentState]
/// 保存或重置表单字段。
///
/// 参考:
///
///  * [TxDropdownButton]，这是没有 [Form] 集成的基础文本字段。
class TxDropdownButtonFormField<T> extends FormField<T> {
  /// 创建一个 [TxDropdownButton] 小部件，它是一个 [FormField]，包装在 [InputDecorator]
  /// 中。
  ///
  /// 有关“onSaved”、“validator”或“autovalidateMode”参数的说明，请参阅 [FormField]。
  /// 其余部分（[decoration] 除外），参见[TxDropdownButton]。
  ///
  /// `items`、`elevation`、`iconSize`、`isDense`、`isExpanded`、`autofocus` 和
  /// `decoration` 参数不得为空。
  TxDropdownButtonFormField({
    required List<TxDropdownMenuItem<T>>? items,
    required this.onChanged,
    super.key,
    TxDropdownButtonBuilder? selectedItemBuilder,
    T? value,
    Widget? hint,
    Widget? disabledHint,
    VoidCallback? onTap,
    int elevation = 8,
    TextStyle? style,
    Widget? icon,
    Color? iconDisabledColor,
    Color? iconEnabledColor,
    double iconSize = 24.0,
    bool isDense = true,
    bool isExpanded = false,
    double? itemHeight,
    Color? focusColor,
    FocusNode? focusNode,
    bool autofocus = false,
    Color? dropdownColor,
    InputDecoration? decoration,
    super.onSaved,
    super.validator,
    AutovalidateMode? autovalidateMode,
    double? menuMaxHeight,
    bool? enableFeedback,
    AlignmentGeometry alignment = AlignmentDirectional.centerStart,
    BorderRadius? borderRadius,
    EdgeInsetsGeometry? padding,
    // 添加新参数时，考虑向 TxDropdownButton 添加类似的参数。
  })  : assert(
          items == null ||
              items.isEmpty ||
              value == null ||
              items.where((TxDropdownMenuItem<T> item) {
                    return item.value == value;
                  }).length ==
                  1,
          "There should be exactly one item with [TxDropdownButton]'s value: "
          '$value. \n'
          'Either zero or 2 or more [TxDropdownMenuItem]s were detected '
          'with the same value',
        ),
        assert(itemHeight == null || itemHeight >= kMinInteractiveDimension),
        decoration = decoration ?? InputDecoration(focusColor: focusColor),
        super(
          initialValue: value,
          autovalidateMode: autovalidateMode ?? AutovalidateMode.disabled,
          builder: (FormFieldState<T> field) {
            final _TxDropdownButtonFormFieldState<T> state =
                field as _TxDropdownButtonFormFieldState<T>;
            final InputDecoration decorationArg =
                decoration ?? InputDecoration(focusColor: focusColor);
            final InputDecoration effectiveDecoration =
                decorationArg.applyDefaults(
              Theme.of(field.context).inputDecorationTheme,
            );

            final bool showSelectedItem = items != null &&
                items
                    .where((TxDropdownMenuItem<T> item) =>
                        item.value == state.value)
                    .isNotEmpty;
            bool isHintOrDisabledHintAvailable() {
              final bool isTxDropdownDisabled =
                  onChanged == null || (items == null || items.isEmpty);
              if (isTxDropdownDisabled) {
                return hint != null || disabledHint != null;
              } else {
                return hint != null;
              }
            }

            final bool isEmpty =
                !showSelectedItem && !isHintOrDisabledHintAvailable();

            // 一个不可聚焦的 Focus 小部件，以便此小部件可以检测其后代是否具有焦点。
            return Focus(
              canRequestFocus: false,
              skipTraversal: true,
              child: Builder(builder: (BuildContext context) {
                return TxDropdownButtonHideUnderline(
                  child: TxDropdownButton<T>._formField(
                    items: items,
                    selectedItemBuilder: selectedItemBuilder,
                    value: state.value,
                    hint: hint,
                    disabledHint: disabledHint,
                    onChanged: onChanged == null ? null : state.didChange,
                    onTap: onTap,
                    elevation: elevation,
                    style: style,
                    icon: icon,
                    iconDisabledColor: iconDisabledColor,
                    iconEnabledColor: iconEnabledColor,
                    iconSize: iconSize,
                    isDense: isDense,
                    isExpanded: isExpanded,
                    itemHeight: itemHeight,
                    focusColor: focusColor,
                    focusNode: focusNode,
                    autofocus: autofocus,
                    dropdownColor: dropdownColor,
                    menuMaxHeight: menuMaxHeight,
                    enableFeedback: enableFeedback,
                    alignment: alignment,
                    borderRadius: borderRadius,
                    padding: padding,
                    inputDecoration: effectiveDecoration.copyWith(
                        errorText: field.errorText),
                    isEmpty: isEmpty,
                    isFocused: Focus.of(context).hasFocus,
                  ),
                );
              }),
            );
          },
        );

  /// {@macro flutter.material.dropdownButton.onChanged}
  final ValueChanged<T?>? onChanged;

  /// 在下拉按钮表单字段周围显示的装饰。
  ///
  /// 默认情况下，在下拉按钮字段下方绘制一条水平线，但可以配置为显示图标、标签、提示文本和
  /// 错误文本。
  ///
  /// 如果未指定，将使用将“focusColor”设置为提供的“focusColor”（如果有）的 [InputDecorator]。
  final InputDecoration decoration;

  @override
  FormFieldState<T> createState() => _TxDropdownButtonFormFieldState<T>();
}

class _TxDropdownButtonFormFieldState<T> extends FormFieldState<T> {
  @override
  void didChange(T? value) {
    super.didChange(value);
    final TxDropdownButtonFormField<T> dropdownButtonFormField =
        widget as TxDropdownButtonFormField<T>;
    assert(dropdownButtonFormField.onChanged != null);
    dropdownButtonFormField.onChanged!(value);
  }

  @override
  void didUpdateWidget(TxDropdownButtonFormField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      setValue(widget.initialValue);
    }
  }
}
