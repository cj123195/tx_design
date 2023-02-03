import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'dropdown.dart' show TxDropdownButtonFormField;

const Duration _kMenuDuration = Duration(milliseconds: 300);
const double _kMenuCloseIntervalEnd = 2.0 / 3.0;
const double _kMenuMaxWidth = 5.0 * _kMenuWidthStep;
const double _kMenuMinWidth = 2.0 * _kMenuWidthStep;
const double _kMenuHorizontalPadding = 4.0;
const double _kMenuVerticalPadding = 4.0;
const double _kMenuItemHorizontalPadding = 4.0;
const double _kMenuWidthStep = 56.0;
const double _kMenuScreenPadding = 8.0;
const double _kDefaultIconSize = 24.0;
const double _kMenuHeight = 40.0;
const BorderRadius _kMenuItemRadius = BorderRadius.all(Radius.circular(4.0));
const BorderRadius _kMenuRadius = BorderRadius.all(Radius.circular(12.0));

/// popup menu 位于 targetView 的方向
enum TxMenuPosition {
  /// 上
  above,

  /// 下
  under
}

/// 显示一个弹出菜单，其中包含位于“position”的“items”。
///
/// [padding] 弹出面板内边距
/// [highlightColor] 选中项高亮色
/// [position] 菜单展开的方向
/// 其余属性请参考[showMenu]
Future<T?> showPopup<T>({
  required BuildContext context,
  required RelativeRect rect,
  required List<PopupMenuEntry<T>> items,
  T? initialValue,
  double? elevation,
  String? semanticLabel,
  ShapeBorder? shape,
  Color? color,
  bool useRootNavigator = false,
  BoxConstraints? constraints,
  TxMenuPosition? position,
  EdgeInsetsGeometry? padding,
  Color? highlightColor,
}) {
  assert(items.isNotEmpty);
  assert(debugCheckHasMaterialLocalizations(context));

  switch (Theme.of(context).platform) {
    case TargetPlatform.iOS:
    case TargetPlatform.macOS:
      break;
    case TargetPlatform.android:
    case TargetPlatform.fuchsia:
    case TargetPlatform.linux:
    case TargetPlatform.windows:
      semanticLabel ??= MaterialLocalizations.of(context).popupMenuLabel;
  }

  final NavigatorState navigator =
      Navigator.of(context, rootNavigator: useRootNavigator);
  return navigator.push(_PopupMenuRoute<T>(
    rect: rect,
    items: items,
    initialValue: initialValue,
    elevation: elevation,
    semanticLabel: semanticLabel,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    shape: shape,
    color: color,
    capturedThemes:
        InheritedTheme.capture(from: context, to: navigator.context),
    constraints: constraints,
    position: position,
    padding: padding,
    highlightColor: highlightColor,
  ));
}

class _PopupMenuRoute<T> extends PopupRoute<T> {
  _PopupMenuRoute({
    required this.barrierLabel,
    required this.rect,
    required this.items,
    required this.capturedThemes,
    this.initialValue,
    this.elevation,
    this.semanticLabel,
    this.shape,
    this.color,
    this.constraints,
    this.position,
    this.padding,
    this.highlightColor,
  }) : itemSizes = List<Size?>.filled(items.length, null);

  final RelativeRect rect;
  final List<PopupMenuEntry<T>> items;
  final List<Size?> itemSizes;
  final T? initialValue;
  final double? elevation;
  final String? semanticLabel;
  final ShapeBorder? shape;
  final Color? color;
  final CapturedThemes capturedThemes;
  final BoxConstraints? constraints;
  final TxMenuPosition? position;
  final EdgeInsetsGeometry? padding;
  final Color? highlightColor;

  @override
  Animation<double> createAnimation() {
    return CurvedAnimation(
      parent: super.createAnimation(),
      curve: Curves.linear,
      reverseCurve: const Interval(0.0, _kMenuCloseIntervalEnd),
    );
  }

  @override
  Duration get transitionDuration => _kMenuDuration;

  @override
  bool get barrierDismissible => true;

  @override
  Color? get barrierColor => null;

  @override
  final String barrierLabel;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    int? selectedItemIndex;
    if (initialValue != null) {
      for (int index = 0;
          selectedItemIndex == null && index < items.length;
          index += 1) {
        if (items[index].represents(initialValue)) {
          selectedItemIndex = index;
        }
      }
    }

    final double totalHeight =
        items.fold<double>(0.0, (total, entry) => total + entry.height);
    late TxMenuPosition position;

    /// 如果设置弹出方式为向上弹出
    if (this.position == TxMenuPosition.above) {
      /// 如果上方空间不足且下方空间足够，则弹出方式改为向下弹出
      if (totalHeight > rect.top && totalHeight < rect.bottom) {
        position = TxMenuPosition.under;
      } else {
        position = TxMenuPosition.above;
      }
    } else {
      /// 如果下方空间不足且上方空间足够，则弹出方式改为向下弹出
      if (totalHeight > rect.bottom && totalHeight < rect.top) {
        position = TxMenuPosition.above;
      } else {
        position = TxMenuPosition.under;
      }
    }

    final Widget menu = _PopupMenu<T>(
      route: this,
      semanticLabel: semanticLabel,
      constraints: constraints,
      position: position,
      padding: padding,
    );
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      removeLeft: true,
      removeRight: true,
      child: Builder(
        builder: (BuildContext context) {
          return CustomSingleChildLayout(
            delegate: _PopupMenuRouteLayout(
              rect,
              itemSizes,
              Directionality.of(context),
              mediaQuery.padding,
              _avoidBounds(mediaQuery),
              position,
            ),
            child: capturedThemes.wrap(menu),
          );
        },
      ),
    );
  }

  Set<Rect> _avoidBounds(MediaQueryData mediaQuery) {
    return DisplayFeatureSubScreen.avoidBounds(mediaQuery).toSet();
  }
}

/// 菜单在屏幕上的定位。
class _PopupMenuRouteLayout extends SingleChildLayoutDelegate {
  _PopupMenuRouteLayout(
    this.rect,
    this.itemSizes,
    this.textDirection,
    this.padding,
    this.avoidBounds,
    this.position,
  );

  // 底层按钮的矩形，相对于覆盖层的尺寸。
  final RelativeRect rect;

  // 每个项目的大小是在布局菜单时和布局路径之前计算的。
  List<Size?> itemSizes;

  // 文字向左还是向右。
  final TextDirection textDirection;

  // 不安全区域的填充。
  EdgeInsets padding;

  // 我们应该避免重叠的矩形列表。无法使用的屏幕区域。
  final Set<Rect> avoidBounds;

  // 弹出框的位置
  final TxMenuPosition position;

  // 我们将child放在位置指定的任何位置，只要它适合指定的父尺寸（插入）8。
  // 如有必要，我们调整child的位置以使其适合。
  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    // The menu can be at most the size of the overlay minus 8.0 pixels in each
    // direction.
    return BoxConstraints.loose(constraints.biggest).deflate(
      const EdgeInsets.all(_kMenuScreenPadding) + padding,
    );
  }

  /// [size] overlay的大小。
  /// [childSize] 菜单完全打开时的大小，由 getConstraintsForChild 确定。
  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final Offset originCenter = rect.toRect(Offset.zero & size).center;

    // 找到理想的垂直位置。
    double y = rect.top;
    if (position == TxMenuPosition.above) {
      y = y - childSize.height;
    } else if (position == TxMenuPosition.under) {
      y = size.height - rect.bottom;
    }

    // 找到理想的水平位置。
    double x;
    if (originCenter.dx < childSize.width / 2) {
      x = 0;
    } else if (size.width - originCenter.dx < childSize.width / 2) {
      x = size.width - childSize.width;
    } else {
      x = originCenter.dx - childSize.width / 2;
    }

    final Offset wantedPosition = Offset(x, y);
    final Iterable<Rect> subScreens =
        DisplayFeatureSubScreen.subScreensInBounds(
            Offset.zero & size, avoidBounds);
    final Rect subScreen = _closestScreen(subScreens, originCenter);
    return _fitInsideScreen(subScreen, childSize, wantedPosition);
  }

  Rect _closestScreen(Iterable<Rect> screens, Offset point) {
    Rect closest = screens.first;
    for (final Rect screen in screens) {
      if ((screen.center - point).distance <
          (closest.center - point).distance) {
        closest = screen;
      }
    }
    return closest;
  }

  Offset _fitInsideScreen(Rect screen, Size childSize, Offset wantedPosition) {
    double x = wantedPosition.dx;
    double y = wantedPosition.dy;
    // 避免在每个方向上超出屏幕边缘 8.0 像素的矩形区域。
    if (x < screen.left + _kMenuScreenPadding + padding.left) {
      x = screen.left + _kMenuScreenPadding + padding.left;
    } else if (x + childSize.width >
        screen.right - _kMenuScreenPadding - padding.right) {
      x = screen.right - childSize.width - _kMenuScreenPadding - padding.right;
    }
    if (y < screen.top + _kMenuScreenPadding + padding.top) {
      y = _kMenuScreenPadding + padding.top;
    } else if (y + childSize.height >
        screen.bottom - _kMenuScreenPadding - padding.bottom) {
      y = screen.bottom -
          childSize.height -
          _kMenuScreenPadding -
          padding.bottom;
    }

    return Offset(x, y);
  }

  @override
  bool shouldRelayout(_PopupMenuRouteLayout oldDelegate) {
    // 如果在新旧 itemSizes 已初始化时调用，那么我们希望它们具有相同的长度，
    // 因为一旦显示菜单，就没有实际的方法来更改项目列表的长度。
    assert(itemSizes.length == oldDelegate.itemSizes.length);

    return rect != oldDelegate.rect ||
        textDirection != oldDelegate.textDirection ||
        !listEquals(itemSizes, oldDelegate.itemSizes) ||
        padding != oldDelegate.padding ||
        !setEquals(avoidBounds, oldDelegate.avoidBounds);
  }
}

class _PopupMenu<T> extends StatelessWidget {
  const _PopupMenu({
    required this.route,
    required this.semanticLabel,
    required this.position,
    this.constraints,
    this.padding,
  });

  final _PopupMenuRoute<T> route;
  final String? semanticLabel;
  final BoxConstraints? constraints;
  final TxMenuPosition position;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final double unit =
        1.0 / (route.items.length + 1.5); // 1.0 表示宽度，0.5 表示最后一项的淡入淡出
    final List<Widget> children = <Widget>[];
    final PopupMenuThemeData popupMenuTheme = PopupMenuTheme.of(context);

    for (int i = 0; i < route.items.length; i += 1) {
      final int index =
          position == TxMenuPosition.under ? i : route.items.length - 1 - i;

      final double start = (index + 1) * unit;
      final double end = (start + 1.5 * unit).clamp(0.0, 1.0);
      final CurvedAnimation opacity = CurvedAnimation(
        parent: route.animation!,
        curve: Interval(start, end),
      );
      Widget item = route.items[index];
      if (route.initialValue != null &&
          route.items[index].represents(route.initialValue)) {
        item = DecoratedBox(
          decoration: BoxDecoration(
            color: route.highlightColor ?? Theme.of(context).highlightColor,
            borderRadius: _kMenuItemRadius,
          ),
          child: item,
        );
      }
      children.add(
        _MenuItem(
          onLayout: (Size size) {
            route.itemSizes[index] = size;
          },
          child: FadeTransition(opacity: opacity, child: item),
        ),
      );
    }

    final CurveTween opacity =
        CurveTween(curve: const Interval(0.0, 1.0 / 3.0));
    final CurveTween width = CurveTween(curve: Interval(0.0, unit));
    final CurveTween height =
        CurveTween(curve: Interval(0.0, unit * route.items.length));

    final Widget child = ConstrainedBox(
      constraints: constraints ??
          const BoxConstraints(
            minWidth: _kMenuMinWidth,
            maxWidth: _kMenuMaxWidth,
          ),
      child: IntrinsicWidth(
        stepWidth: _kMenuWidthStep,
        child: Semantics(
          scopesRoute: true,
          namesRoute: true,
          explicitChildNodes: true,
          label: semanticLabel,
          child: SingleChildScrollView(
            padding: padding ??
                const EdgeInsets.symmetric(
                  vertical: _kMenuVerticalPadding,
                  horizontal: _kMenuHorizontalPadding,
                ),
            child: ListBody(children: children),
          ),
        ),
      ),
    );
    final AlignmentDirectional alignment = position == TxMenuPosition.under
        ? AlignmentDirectional.topCenter
        : AlignmentDirectional.bottomCenter;

    final ShapeBorder shape = route.shape ??
        popupMenuTheme.shape ??
        const RoundedRectangleBorder(borderRadius: _kMenuRadius);

    return AnimatedBuilder(
      animation: route.animation!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: opacity.animate(route.animation!),
          child: Material(
            shape: shape,
            color: route.color ?? popupMenuTheme.color,
            type: MaterialType.card,
            elevation: route.elevation ?? popupMenuTheme.elevation ?? 8.0,
            shadowColor: Theme.of(context).shadowColor,
            child: Align(
              alignment: alignment,
              widthFactor: width.evaluate(route.animation!),
              heightFactor: height.evaluate(route.animation!),
              child: child,
            ),
          ),
        );
      },
      child: child,
    );
  }
}

class _MenuItem extends SingleChildRenderObjectWidget {
  const _MenuItem({
    required this.onLayout,
    required super.child,
  });

  final ValueChanged<Size> onLayout;

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

class _RenderMenuItem extends RenderShiftedBox {
  _RenderMenuItem(this.onLayout, [RenderBox? child]) : super(child);

  ValueChanged<Size> onLayout;

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    if (child == null) {
      return Size.zero;
    }
    return child!.getDryLayout(constraints);
  }

  @override
  void performLayout() {
    if (child == null) {
      size = Size.zero;
    } else {
      child!.layout(constraints, parentUsesSize: true);
      size = constraints.constrain(child!.size);
      final BoxParentData childParentData = child!.parentData! as BoxParentData;
      childParentData.offset = Offset.zero;
    }
    onLayout(size);
  }
}

/// 按下时显示菜单，并在菜单因选择项目而关闭时调用 [onSelected]。 传递给 [onSelected] 的
/// 值是所选菜单项的值。
///
/// [position]用来决定菜单显示的位置，当值为[TxMenuPosition.above]且[TxPopupMenuButton]
/// 上方空间足够时向上展开，当值为[TxMenuPosition.under]且[TxPopupMenuButton]下方空间足
/// 够时向下展开。切记请勿传入过多子项，此组件未进行滑动设计，过多子项会导致布局溢出问题，如需进
/// 行多项下拉选择，请使用[TxDropdownButtonFormField]
/// [highlightColor] 用来定义选中项的颜色。
///
/// 参考[PopupMenuButton]
class TxPopupMenuButton<T> extends StatelessWidget {
  /// 创建一个显示弹出菜单的按钮
  ///
  /// [itemBuilder] 参数不能为空。
  const TxPopupMenuButton({
    required this.itemBuilder,
    super.key,
    this.initialValue,
    this.onSelected,
    this.onCanceled,
    this.tooltip,
    this.elevation,
    this.padding = const EdgeInsets.all(8.0),
    this.child,
    this.splashRadius,
    this.icon,
    this.iconSize,
    this.offset = Offset.zero,
    this.enabled = true,
    this.shape,
    this.color,
    this.enableFeedback,
    this.constraints,
    this.position,
    this.highlightColor,
    this.buttonShape,
  }) : assert(
          !(child != null && icon != null),
          'You can only pass [child] or [icon], not both.',
        );

  /// 当按下按钮以创建要在菜单中显示的项目时调用。
  final PopupMenuItemBuilder<T> itemBuilder;

  /// 菜单项的值（如果有）应在菜单打开时突出显示。
  final T? initialValue;

  /// 当用户从此按钮创建的弹出菜单中选择一个值时调用。
  ///
  /// 如果弹出菜单在没有选择值的情况下被关闭，则调用 [onCanceled]。
  final PopupMenuItemSelected<T>? onSelected;

  /// 当用户在未选择项目的情况下关闭弹出菜单时调用。
  ///
  /// 如果用户选择了一个值，则改为调用 [onSelected]。
  final PopupMenuCanceled? onCanceled;

  /// 描述按下按钮时将发生的操作的文本。
  ///
  /// 当用户长按按钮时显示此文本并用于辅助功能。
  final String? tooltip;

  /// 打开时放置菜单的 z 坐标。这控制菜单下方阴影的大小。
  ///
  /// 默认为 8，弹出菜单的适当高度。
  final double? elevation;

  /// 默认匹配 IconButton 的 8 dps 内边距。
  ///
  /// 在某些情况下，特别是在此按钮作为列表项的尾随元素出现的情况下，能够将填充设置为0很有用。
  final EdgeInsetsGeometry padding;

  /// 按钮点击水波纹效果半径
  ///
  /// 如果为 null，则使用 [InkWell] 或 [IconButton] 的默认splash radius。
  final double? splashRadius;

  /// 如果提供，[child] 是用于此按钮的小部件，并且该按钮将使用 [InkWell] 进行点击。
  final Widget? child;

  /// 如果提供，[icon] 将用于此按钮，并且该按钮的行为类似于 [IconButton]。
  final Widget? icon;

  /// 偏移量是相对于rect设置的初始位置应用的。
  ///
  /// 未设置时，偏移量默认为 [Offset.zero]。
  final Offset offset;

  /// 此弹出菜单按钮是否是交互式的。
  ///
  /// 必须为非空，默认为 `true`
  ///
  /// 如果 `true` 按钮将通过显示菜单来响应按下。
  ///
  /// 如果为 `false`，按钮将使用当前 [Theme] 中的禁用颜色进行样式设置，
  /// 并且不会响应按下或显示弹出菜单，
  /// 并且不会调用 [onSelected]、[onCanceled] 和 [itemBuilder]。
  ///
  /// 这在应用程序需要显示按钮但当前菜单中没有任何内容可显示的情况下很有用。
  final bool enabled;

  /// 如果提供，用于菜单的形状。
  ///
  /// 如果此属性为 null，则使用 [PopupMenuThemeData.shape]。
  /// 如果 [PopupMenuThemeData.shape] 也为空，则使用 [MaterialType.card] 的默认形状。
  /// 此默认形状是一个带有圆角边缘的矩形 BorderRadius.circular(2.0)。
  final ShapeBorder? shape;

  /// 如果提供，用于按钮的形状。
  final ShapeBorder? buttonShape;

  /// 如果提供，则用于菜单的背景颜色。
  ///
  /// 如果此属性为 null，则使用 [PopupMenuThemeData.color]。
  /// 如果 [PopupMenuThemeData.color] 也为 null，则使用 Theme.of(context).cardColor。
  final Color? color;

  /// 检测到的手势是否应提供声学和/或触觉反馈。
  ///
  /// 例如，在 Android 上，当启用反馈时，点击会产生点击声，长按会产生短暂的振动。
  ///
  /// 参见:
  ///
  ///  * [Feedback] 用于为某些操作提供特定于平台的反馈。
  final bool? enableFeedback;

  /// 如果提供，[图标]的大小。
  ///
  /// 如果此属性为空，则使用 [IconThemeData.size]。
  /// 如果 [IconThemeData.size] 也为 null，则默认大小为 24.0 像素。
  final double? iconSize;

  /// 菜单的可选大小限制。
  ///
  /// 未指定时，默认为：
  /// ```dart
  /// const BoxConstraints(
  ///   minWidth: 2.0 * 56.0,
  ///   maxWidth: 5.0 * 56.0,
  /// )
  /// ```
  ///
  /// 默认约束确保菜单宽度与材料设计指南推荐的最大宽度相匹配。
  /// 指定此参数可以创建比默认最大宽度更宽的菜单。
  final BoxConstraints? constraints;

  /// 弹出菜单是位于弹出菜单按钮上方还是下方。
  ///
  /// [offset] 用于改变弹出菜单相对于该参数设置的位置的位置。
  ///
  /// 未设置时，位置默认为 [TxMenuPosition.above]，
  /// 这使弹出菜单直接显示在用于创建它的按钮上方。
  final TxMenuPosition? position;

  /// 选中高亮色
  final Color? highlightColor;

  void showButtonMenu(BuildContext context) {
    final PopupMenuThemeData popupMenuTheme = PopupMenuTheme.of(context);
    final RenderBox button = context.findRenderObject()! as RenderBox;
    final RenderBox overlay =
        Navigator.of(context).overlay!.context.findRenderObject()! as RenderBox;
    final RelativeRect rect = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(offset, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero) + offset,
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );
    final List<PopupMenuEntry<T>> items = itemBuilder(context);
    if (items.isNotEmpty) {
      showPopup<T?>(
        context: context,
        elevation: elevation ?? popupMenuTheme.elevation,
        items: items,
        initialValue: initialValue,
        rect: rect,
        shape: shape ?? popupMenuTheme.shape,
        color: color ?? popupMenuTheme.color,
        constraints: constraints,
        position: position,
        highlightColor: highlightColor,
      ).then<void>((T? newValue) {
        if (newValue == null) {
          onCanceled?.call();
          return null;
        }
        onSelected?.call(newValue);
      });
    }
  }

  bool _canRequestFocus(BuildContext context) {
    final NavigationMode mode = MediaQuery.maybeOf(context)?.navigationMode ??
        NavigationMode.traditional;
    switch (mode) {
      case NavigationMode.traditional:
        return enabled;
      case NavigationMode.directional:
        return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final IconThemeData iconTheme = IconTheme.of(context);
    final bool enableFeedback = this.enableFeedback ??
        PopupMenuTheme.of(context).enableFeedback ??
        true;

    assert(debugCheckHasMaterialLocalizations(context));

    if (child != null) {
      return Tooltip(
        message: tooltip ?? MaterialLocalizations.of(context).showMenuTooltip,
        child: InkWell(
          customBorder: buttonShape,
          onTap: enabled ? () => showButtonMenu(context) : null,
          canRequestFocus: _canRequestFocus(context),
          radius: splashRadius,
          enableFeedback: enableFeedback,
          child: child,
        ),
      );
    }

    return IconButton(
      icon: icon ?? Icon(Icons.adaptive.more),
      padding: padding,
      splashRadius: splashRadius,
      iconSize: iconSize ?? iconTheme.size ?? _kDefaultIconSize,
      tooltip: tooltip ?? MaterialLocalizations.of(context).showMenuTooltip,
      onPressed: enabled ? () => showButtonMenu(context) : null,
      enableFeedback: enableFeedback,
    );
  }
}

/// Material Design 弹出菜单中的一个项目。
///
/// 参考[PopupMenuItem]
class TxPopupMenuItem<T> extends PopupMenuEntry<T> {
  const TxPopupMenuItem({
    required this.child,
    super.key,
    this.value,
    this.onTap,
    this.enabled = true,
    double height = _kMenuHeight,
    this.padding,
    this.textStyle,
    this.mouseCursor,
  }) : _height = height;

  final T? value;
  final VoidCallback? onTap;
  final bool enabled;
  final EdgeInsets? padding;
  final TextStyle? textStyle;
  final MouseCursor? mouseCursor;
  final Widget? child;
  final double _height;

  @override
  double get height => _height;

  @override
  bool represents(T? value) => value == this.value;

  @override
  TxPopupMenuItemState<T, TxPopupMenuItem<T>> createState() =>
      TxPopupMenuItemState<T, TxPopupMenuItem<T>>();
}

class TxPopupMenuItemState<T, W extends TxPopupMenuItem<T>> extends State<W> {
  /// 菜单项内容。
  ///
  /// 由 [build] 方法使用。
  ///
  /// 默认情况下，这会返回 [PopupMenuItem.child]。覆盖它以在菜单项中放置其他内容。
  @protected
  Widget? buildChild() => widget.child;

  /// 用户选择菜单项时的处理程序。
  ///
  /// 由 [build] 方法插入的 [InkWell] 使用。
  ///
  /// 默认情况下，使用 [Navigator.pop] 从菜单路由返回 [PopupMenuItem.value]。
  @protected
  void handleTap() {
    Navigator.pop<T>(context, widget.value);

    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final PopupMenuThemeData popupMenuTheme = PopupMenuTheme.of(context);
    TextStyle style = widget.textStyle ??
        popupMenuTheme.textStyle ??
        theme.textTheme.titleMedium!;

    if (!widget.enabled) {
      style = style.copyWith(color: theme.disabledColor);
    }

    Widget item = AnimatedDefaultTextStyle(
      style: style,
      duration: kThemeChangeDuration,
      child: Container(
        alignment: AlignmentDirectional.centerStart,
        constraints: BoxConstraints(minHeight: widget.height),
        padding: widget.padding ??
            const EdgeInsets.symmetric(horizontal: _kMenuItemHorizontalPadding),
        child: buildChild(),
      ),
    );

    if (!widget.enabled) {
      final bool isDark = theme.brightness == Brightness.dark;
      item = IconTheme.merge(
        data: IconThemeData(opacity: isDark ? 0.5 : 0.38),
        child: item,
      );
    }

    return MergeSemantics(
      child: Semantics(
        enabled: widget.enabled,
        button: true,
        child: InkWell(
          onTap: widget.enabled ? handleTap : null,
          canRequestFocus: widget.enabled,
          mouseCursor: _EffectiveMouseCursor(
              widget.mouseCursor, popupMenuTheme.mouseCursor),
          child: item,
        ),
      ),
    );
  }
}

class _EffectiveMouseCursor extends MaterialStateMouseCursor {
  const _EffectiveMouseCursor(this.widgetCursor, this.themeCursor);

  final MouseCursor? widgetCursor;
  final MaterialStateProperty<MouseCursor?>? themeCursor;

  @override
  MouseCursor resolve(Set<MaterialState> states) {
    return MaterialStateProperty.resolveAs<MouseCursor?>(
            widgetCursor, states) ??
        themeCursor?.resolve(states) ??
        MaterialStateMouseCursor.clickable.resolve(states);
  }

  @override
  String get debugDescription => 'MaterialStateMouseCursor(PopupMenuItemState)';
}

// class _PopupMenuBorder extends RoundedRectangleBorder {
//   final TxMenuPosition position;
//   final RelativeRect buttonRect;
//   final double arrowHeight;
//   final double arrowWidth;
//
//   const _PopupMenuBorder({
//     BorderSide side = BorderSide.none,
//     BorderRadius borderRadius = BorderRadius.zero,
//     this.arrowHeight = 8,
//     this.arrowWidth = 10,
//     required this.position,
//     required this.buttonRect,
//   }) : super(side: side, borderRadius: borderRadius);
//
//   @override
//   Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
//     return Path()
//       ..addPath(_getRectanglePath(rect), Offset.zero)
//       ..addRRect(borderRadius
//           .resolve(textDirection)
//           .toRRect(rect)
//           .deflate(side.width));
//   }
//
//   @override
//   Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
//     return Path()
//       ..addPath(_getRectanglePath(rect), Offset.zero)
//       ..addRRect(borderRadius.resolve(textDirection).toRRect(rect));
//   }
//
//   Path _getRectanglePath(Rect rect) {
//     final Size screenSize = window.physicalSize / window.devicePixelRatio;
//     final double buttonWidth =
//         screenSize.width - buttonRect.right - buttonRect.left;
//     final double width = rect.right - rect.left;
//
//     late double x;
//     if (buttonRect.left + buttonWidth / 2 < width / 2) {
//       x = buttonRect.left + buttonWidth / 2;
//     } else if (buttonRect.right - buttonWidth / 2 < width / 2) {
//       x = rect.width - buttonWidth / 2;
//     } else {
//       x = width / 2;
//     }
//
//     late Offset offset;
//     late Offset offset1;
//     late Offset offset2;
//     if (position == TxMenuPosition.under) {
//       offset = Offset(x - arrowWidth / 2, rect.top);
//       offset1 = Offset(x, rect.top - arrowHeight);
//       offset2 = Offset(x + arrowWidth / 2, rect.top);
//     } else {
//       offset = Offset(x - arrowWidth / 2, rect.bottom);
//       offset1 = Offset(x, rect.bottom + arrowHeight);
//       offset2 = Offset(x + arrowWidth / 2, rect.bottom);
//     }
//
//     return Path()
//       ..moveTo(offset.dx, offset.dy)
//       ..lineTo(offset1.dx, offset1.dy)
//       ..lineTo(offset2.dx, offset2.dy)
//       ..close();
//   }
// }
