import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

const double _kTabHeight = 46.0;
const double _kTextAndIconTabHeight = 72.0;
const double _cubicOffset = 20.0;

class _TabStyle extends AnimatedWidget {
  const _TabStyle({
    required Animation<double> animation,
    required this.isSelected,
    required this.isPrimary,
    required this.labelColor,
    required this.unselectedLabelColor,
    required this.labelStyle,
    required this.unselectedLabelStyle,
    required this.defaults,
    required this.child,
  }) : super(listenable: animation);

  final TextStyle? labelStyle;
  final TextStyle? unselectedLabelStyle;
  final bool isSelected;
  final bool isPrimary;
  final Color? labelColor;
  final Color? unselectedLabelColor;
  final TabBarTheme defaults;
  final Widget child;

  WidgetStateColor _resolveWithLabelColor(BuildContext context) {
    final TabBarThemeData tabBarTheme = TabBarTheme.of(context);
    final Animation<double> animation = listenable as Animation<double>;

    Color selectedColor = labelColor ??
        tabBarTheme.labelColor ??
        labelStyle?.color ??
        tabBarTheme.labelStyle?.color ??
        defaults.labelColor!;

    final Color unselectedColor;

    if (selectedColor is WidgetStateColor) {
      unselectedColor = selectedColor.resolve(const <WidgetState>{});
      selectedColor =
          selectedColor.resolve(const <WidgetState>{WidgetState.selected});
    } else {
      // unselectedLabelColor and tabBarTheme.unselectedLabelColor are ignored
      // when labelColor is a WidgetStateColor.
      unselectedColor = unselectedLabelColor ??
          tabBarTheme.unselectedLabelColor ??
          unselectedLabelStyle?.color ??
          tabBarTheme.unselectedLabelStyle?.color ??
          defaults.unselectedLabelColor!; // 70% alpha
    }

    return WidgetStateColor.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return Color.lerp(selectedColor, unselectedColor, animation.value)!;
      }
      return Color.lerp(unselectedColor, selectedColor, animation.value)!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final TabBarThemeData tabBarTheme = TabBarTheme.of(context);
    final Animation<double> animation = listenable as Animation<double>;

    final Set<WidgetState> states = isSelected
        ? const <WidgetState>{WidgetState.selected}
        : const <WidgetState>{};

    // To enable TextStyle.lerp(style1, style2, value), both styles must have
    // the same value of inherit. Force that to be inherit=true here.
    final TextStyle selectedStyle =
        (labelStyle ?? tabBarTheme.labelStyle ?? defaults.labelStyle!)
            .copyWith(inherit: true);
    final TextStyle unselectedStyle = (unselectedLabelStyle ??
            tabBarTheme.unselectedLabelStyle ??
            labelStyle ??
            defaults.unselectedLabelStyle!)
        .copyWith(inherit: true);
    final TextStyle textStyle = isSelected
        ? TextStyle.lerp(selectedStyle, unselectedStyle, animation.value)!
        : TextStyle.lerp(unselectedStyle, selectedStyle, animation.value)!;
    final Color color = _resolveWithLabelColor(context).resolve(states);

    return DefaultTextStyle(
      style: textStyle.copyWith(color: color),
      child: IconTheme.merge(
        data: IconThemeData(
          size: 24.0,
          color: color,
        ),
        child: child,
      ),
    );
  }
}

class _ChangeAnimation extends Animation<double>
    with AnimationWithParentMixin<double> {
  _ChangeAnimation(this.controller);

  final TabController controller;

  @override
  Animation<double> get parent => controller.animation!;

  @override
  void removeStatusListener(AnimationStatusListener listener) {
    if (controller.animation != null) {
      super.removeStatusListener(listener);
    }
  }

  @override
  void removeListener(VoidCallback listener) {
    if (controller.animation != null) {
      super.removeListener(listener);
    }
  }

  @override
  double get value => _indexChangeProgress(controller);
}

double _indexChangeProgress(TabController controller) {
  final double controllerValue = controller.animation!.value;
  final double previousIndex = controller.previousIndex.toDouble();
  final double currentIndex = controller.index.toDouble();

  // 控制器的偏移量正在更改，因为用户将 TabBarView 的 PageView 向左或向右拖动。
  if (!controller.indexIsChanging) {
    return clampDouble((currentIndex - controllerValue).abs(), 0.0, 1.0);
  }

  // TabController 动画的值从 previousIndex 更改为 currentIndex。
  return (controllerValue - currentIndex).abs() /
      (currentIndex - previousIndex).abs();
}

class _DragAnimation extends Animation<double>
    with AnimationWithParentMixin<double> {
  _DragAnimation(this.controller, this.index);

  final TabController controller;
  final int index;

  @override
  Animation<double> get parent => controller.animation!;

  @override
  void removeStatusListener(AnimationStatusListener listener) {
    if (controller.animation != null) {
      super.removeStatusListener(listener);
    }
  }

  @override
  void removeListener(VoidCallback listener) {
    if (controller.animation != null) {
      super.removeListener(listener);
    }
  }

  @override
  double get value {
    assert(!controller.indexIsChanging);
    final double controllerMaxValue = (controller.length - 1).toDouble();
    final double controllerValue =
        clampDouble(controller.animation!.value, 0.0, controllerMaxValue);
    return clampDouble((controllerValue - index.toDouble()).abs(), 0.0, 1.0);
  }
}

typedef _LayoutCallback = void Function(
  List<double> xOffsets,
  TextDirection textDirection,
  double width,
);

class _TabLabelBar extends Flex {
  const _TabLabelBar({
    required this.onPerformLayout,
    required super.mainAxisSize,
    super.children,
  }) : super(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          verticalDirection: VerticalDirection.down,
        );

  final _LayoutCallback onPerformLayout;

  @override
  RenderFlex createRenderObject(BuildContext context) {
    return _TabLabelBarRenderer(
      direction: direction,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      textDirection: getEffectiveTextDirection(context)!,
      verticalDirection: verticalDirection,
      onPerformLayout: onPerformLayout,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _TabLabelBarRenderer renderObject,
  ) {
    super.updateRenderObject(context, renderObject);
    renderObject.onPerformLayout = onPerformLayout;
  }
}

class _TabLabelBarRenderer extends RenderFlex {
  _TabLabelBarRenderer({
    required super.direction,
    required super.mainAxisSize,
    required super.mainAxisAlignment,
    required super.crossAxisAlignment,
    required TextDirection super.textDirection,
    required super.verticalDirection,
    required this.onPerformLayout,
  });

  _LayoutCallback onPerformLayout;

  @override
  void performLayout() {
    super.performLayout();
    // xOffsets will contain childCount+1 values, giving the offsets of the
    // leading edge of the first tab as the first value, of the leading edge of
    // the each subsequent tab as each subsequent value, and of the trailing
    // edge of the last tab as the last value.
    RenderBox? child = firstChild;
    final List<double> xOffsets = <double>[];
    while (child != null) {
      final FlexParentData childParentData =
          child.parentData! as FlexParentData;
      xOffsets.add(childParentData.offset.dx);
      assert(child.parentData == childParentData);
      child = childParentData.nextSibling;
    }
    assert(textDirection != null);
    switch (textDirection!) {
      case TextDirection.rtl:
        xOffsets.insert(0, size.width);
      case TextDirection.ltr:
        xOffsets.add(size.width);
    }
    onPerformLayout(xOffsets, textDirection!, size.width);
  }
}

@immutable
class TabIndicatorDecoration {
  const TabIndicatorDecoration({
    this.color,
    this.borderRadius,
    this.gradient,
    this.backgroundBlendMode,
  });

  /// 要填充指示器背景的颜色。
  final Color? color;

  /// 第一个和最后一个的圆角大小。
  final BorderRadius? borderRadius;

  /// 填充指示器时使用的渐变。
  ///
  /// 如果指定此选项，则 [color] 不起作用。
  final Gradient? gradient;

  /// 应用于指示器的 [color] 或 [gradient] 背景的混合模式。
  ///
  /// 如果未提供 [backgroundBlendMode]，则使用默认的绘画混合模式。
  ///
  /// 如果未提供 [color] 或 [gradient]，则混合模式没有影响。
  final BlendMode? backgroundBlendMode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is TabIndicatorDecoration &&
        other.color == color &&
        other.borderRadius == borderRadius &&
        other.gradient == gradient &&
        other.backgroundBlendMode == backgroundBlendMode;
  }

  @override
  int get hashCode => Object.hash(
        color,
        borderRadius,
        gradient,
        backgroundBlendMode,
      );
}

/// 一个不规则形状的TabBar
///
/// 此TabBar不可滚动
class TxTabBar extends CustomTabBar implements PreferredSizeWidget {
  /// 创建一个不规则形状的TabBar
  const TxTabBar({
    required super.tabs,
    super.key,
    super.controller,
    super.padding,
    super.indicatorColor,
    super.automaticIndicatorColorAdjustment = true,
    this.indicatorDecoration,
    super.indicatorWeight = 2.0,
    super.indicatorPadding = EdgeInsets.zero,
    super.indicator,
    super.indicatorSize,
    this.dividerColor,
    this.dividerHeight,
    super.labelColor,
    super.labelStyle,
    super.labelPadding,
    super.unselectedLabelColor,
    super.unselectedLabelStyle,
    super.onTap,
  }) : assert(indicator != null || (indicatorWeight > 0.0));

  /// 创建一个不规则形状的副标题栏.
  const TxTabBar.secondary({
    required super.tabs,
    super.key,
    super.controller,
    super.padding,
    super.indicatorColor,
    super.automaticIndicatorColorAdjustment,
    super.indicatorWeight,
    this.indicatorDecoration,
    super.indicatorPadding,
    super.indicator,
    super.indicatorSize,
    this.dividerColor,
    this.dividerHeight,
    super.labelColor,
    super.labelStyle,
    super.labelPadding,
    super.unselectedLabelColor,
    super.unselectedLabelStyle,
    super.onTap,
  })  : assert(indicator != null || (indicatorWeight > 0.0)),
        super(isPrimary: false);

  /// 参考[TabBar.dividerColor]
  final Color? dividerColor;

  /// 参考[TabBar.dividerHeight]
  final double? dividerHeight;

  /// 指示器装饰器
  final TabIndicatorDecoration? indicatorDecoration;

  /// 参考[TabBar.preferredSize]
  @override
  Size get preferredSize {
    double maxHeight = _kTabHeight;
    for (final Widget item in tabs) {
      if (item is PreferredSizeWidget) {
        final double itemHeight = item.preferredSize.height;
        maxHeight = math.max(itemHeight, maxHeight);
      }
    }
    return Size.fromHeight(maxHeight + indicatorWeight);
  }

  @override
  State<CustomTabBar> createState() => _TabBarState();
}

class _TabBarState extends _CustomTabBarState {
  @override
  TxTabBar get widget => super.widget as TxTabBar;

  @override
  void initState() {
    super.initState();
    // 如果 indicatorSize 为 TabIndicatorSize.label，则 _tabKeys[i] 用于查找选项卡
    // 小部件 i 的宽度。 参见 _IndicatorPainter.indicatorRect()。
    _tabKeys = widget.tabs.map((tab) => GlobalKey()).toList();
    _labelPaddings = List<EdgeInsetsGeometry>.filled(
      widget.tabs.length,
      EdgeInsets.zero,
      growable: true,
    );
  }

  @override
  void _initIndicatorPainter() {
    final ThemeData theme = Theme.of(context);
    final TabBarThemeData tabBarTheme = TabBarTheme.of(context);
    final TabBarIndicatorSize indicatorSize = widget.indicatorSize ??
        tabBarTheme.indicatorSize ??
        _defaults.indicatorSize!;
    final TabIndicatorDecoration decoration = widget.indicatorDecoration ??
        TabIndicatorDecoration(
          color: theme.colorScheme.primaryContainer,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4.0)),
        );

    _indicatorPainter = !_controllerIsValid
        ? null
        : _IndicatorPainter(
            controller: _controller!,
            indicator: _getIndicator(indicatorSize),
            indicatorSize: widget.indicatorSize ??
                tabBarTheme.indicatorSize ??
                _defaults.indicatorSize!,
            indicatorPadding: widget.indicatorPadding,
            tabKeys: _tabKeys,
            old: _indicatorPainter as _IndicatorPainter?,
            labelPaddings: _labelPaddings,
            dividerColor: widget.dividerColor ??
                tabBarTheme.dividerColor ??
                _defaults.dividerColor,
            dividerHeight: widget.dividerHeight ??
                tabBarTheme.dividerHeight ??
                _defaults.dividerHeight,
            showDivider: theme.useMaterial3,
            decoration: decoration,
          );
  }

  @override
  void didUpdateWidget(TxTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.dividerColor != oldWidget.dividerColor ||
        widget.dividerHeight != oldWidget.dividerHeight ||
        widget.indicatorDecoration != oldWidget.indicatorDecoration) {
      _initIndicatorPainter();
    }
  }

  @override
  Widget _buildTabBar() {
    return CustomPaint(
      painter: _indicatorPainter,
      child: super._buildTabBar(),
    );
  }
}

class _IndicatorPainter extends _TabBarPainter {
  _IndicatorPainter({
    required super.controller,
    required super.indicator,
    required super.indicatorSize,
    required super.tabKeys,
    required super.old,
    required super.indicatorPadding,
    required super.labelPaddings,
    required this.showDivider,
    required this.decoration,
    this.dividerColor,
    this.dividerHeight,
  });

  final Color? dividerColor;
  final double? dividerHeight;
  final bool showDivider;
  final TabIndicatorDecoration decoration;

  @override
  bool shouldRepaint(_IndicatorPainter old) {
    return dividerColor != old.dividerColor ||
        showDivider != old.showDivider ||
        dividerHeight != old.dividerHeight ||
        decoration != old.decoration;
  }

  @override
  void paintDecoration(
    Canvas canvas,
    Size size,
    double value,
    int from,
    int to,
  ) {
    if (showDivider && dividerHeight! > 0) {
      final Paint dividerPaint = Paint()
        ..color = dividerColor!
        ..strokeWidth = dividerHeight!;
      final Offset dividerP1 =
          Offset(0, size.height - (dividerPaint.strokeWidth / 2));
      final Offset dividerP2 =
          Offset(size.width, size.height - (dividerPaint.strokeWidth / 2));
      canvas.drawLine(dividerP1, dividerP2, dividerPaint);
    }

    final double t = (value - from).abs();
    final Rect tabFromRect = indicatorRect(size.height, from, true);
    final Rect tabToRect = indicatorRect(size.height, to, true);
    final Rect tabRect = Rect.lerp(tabFromRect, tabToRect, t)!;

    final Paint paint = Paint()
      ..shader = decoration.gradient?.createShader(tabRect)
      ..style = PaintingStyle.fill;

    if (decoration.color != null) {
      paint.color = decoration.color!;
    }
    if (decoration.backgroundBlendMode != null) {
      paint.blendMode = decoration.backgroundBlendMode!;
    }

    final Path path = Path();

    final double left = tabRect.left;
    final double right = tabRect.right;
    final double bottom = tabRect.bottom;
    final double top = tabRect.top;

    final BorderRadius borderRadius = decoration.borderRadius ??
        const BorderRadius.vertical(top: Radius.circular(4));

    // 绘制左侧
    if (controller.index == 0) {
      //  第一个Tab左侧应为垂直的Path

      // 左下
      final Radius bottomRadius = borderRadius.bottomLeft;
      if (bottomRadius == Radius.zero) {
        // 直角
        path.moveTo(left, bottom);
      } else {
        // 圆角
        final Offset start = Offset(left + bottomRadius.x, bottom);
        final Offset end = Offset(left, bottom - bottomRadius.y);
        path
          ..moveTo(start.dx, start.dy)
          ..arcToPoint(end, radius: bottomRadius);
      }

      // 左上
      final Radius topRadius = borderRadius.topLeft;
      if (topRadius == Radius.zero) {
        // 直角
        path.lineTo(left, top);
      } else {
        // 圆角
        final Offset start = Offset(left, top + topRadius.y);
        final Offset end = Offset(left + topRadius.x, top);
        path
          ..lineTo(start.dx, start.dy)
          ..arcToPoint(end, radius: topRadius);
      }
    } else {
      // 左下
      final Offset start = Offset(left - 10, bottom);
      final Offset end = Offset(left, bottom - 10);
      final Offset control = Offset(left - 5, bottom);
      path
        ..moveTo(start.dx, start.dy)
        ..quadraticBezierTo(control.dx, control.dy, end.dx, end.dy);

      // 左上
      final Offset start1 = Offset(left + 10, top + 10);
      final Offset end1 = Offset(left + 25, top);
      final Offset control1 = Offset(left + 15, top);
      path
        ..lineTo(start1.dx, start1.dy)
        ..quadraticBezierTo(control1.dx, control1.dy, end1.dx, end1.dy);
    }

    /// 绘制右侧
    if (controller.index == maxTabIndex) {
      // 右上
      final Radius topRadius = borderRadius.topRight;
      if (topRadius == Radius.zero) {
        // 直角
        path.lineTo(right, top);
      } else {
        // 圆角
        final Offset start = Offset(right - topRadius.x, top);
        final Offset end = Offset(right, top + topRadius.y);
        path
          ..lineTo(start.dx, start.dy)
          ..arcToPoint(end, radius: topRadius);
      }

      // 右下
      final Radius bottomRadius = borderRadius.bottomRight;
      if (bottomRadius == Radius.zero) {
        // 直角
        path.lineTo(right, bottom);
      } else {
        // 圆角
        final Offset start = Offset(right, bottom - bottomRadius.y);
        final Offset end = Offset(right - bottomRadius.x, bottom);
        path
          ..lineTo(start.dx, start.dy)
          ..arcToPoint(end, radius: bottomRadius);
      }
    } else {
      final Offset start = Offset(right - 25, top);
      final Offset end = Offset(right - 10, top + 10);
      final Offset control = Offset(right - 15, top);
      path
        ..lineTo(start.dx, start.dy)
        ..quadraticBezierTo(control.dx, control.dy, end.dx, end.dy);

      final Offset start1 = Offset(right, bottom - 10);
      final Offset end1 = Offset(right + 10, bottom);
      final Offset control1 = Offset(right + 5, bottom);
      path
        ..lineTo(start1.dx, start1.dy)
        ..quadraticBezierTo(control1.dx, control1.dy, end1.dx, end1.dy);
    }

    path.close();

    canvas.drawPath(path, paint);
  }
}

class TxTabBarView extends CustomTabBar {
  const TxTabBarView({
    required super.tabs,
    required this.body,
    super.key,
    super.controller,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? tabBarPadding,
    super.indicatorColor,
    super.indicatorWeight = 0.0,
    super.indicatorPadding,
    super.indicator,
    super.automaticIndicatorColorAdjustment,
    super.indicatorSize,
    super.labelColor,
    super.unselectedLabelColor,
    super.labelStyle,
    super.unselectedLabelStyle,
    super.labelPadding,
    super.onTap,
    this.decoration,
    this.unSelectedTabDecoration,
    this.heightDifference,
  })  : _padding = padding,
        super(padding: tabBarPadding);

  /// 页面内边距
  final EdgeInsetsGeometry? _padding;

  /// 装饰器
  final BoxDecoration? decoration;

  /// 页面主体
  final Widget body;

  /// 未选择的Tab装饰器
  final BoxDecoration? unSelectedTabDecoration;

  /// 未选择的Tab高度差
  final double? heightDifference;

  double get _tabBarHeight {
    double result = _kTabHeight;
    for (final Widget item in tabs) {
      if (item is PreferredSizeWidget) {
        final double itemHeight = item.preferredSize.height;
        result = math.max(itemHeight, result);
      }
    }
    return result;
  }

  @override
  State<CustomTabBar> createState() => _TxTabBarViewState();
}

class _TxTabBarViewState extends _CustomTabBarState {
  @override
  TxTabBarView get widget => super.widget as TxTabBarView;

  @override
  void _initIndicatorPainter() {
    timeDilation = 1.0;

    final ThemeData theme = Theme.of(context);
    final TabBarThemeData tabBarTheme = TabBarTheme.of(context);
    final TabBarIndicatorSize indicatorSize = widget.indicatorSize ??
        tabBarTheme.indicatorSize ??
        _defaults.indicatorSize!;
    const BorderRadius borderRadius = BorderRadius.all(Radius.circular(12.0));
    final BoxDecoration decoration = widget.decoration ??
        BoxDecoration(
          color: theme.colorScheme.surfaceContainerLowest,
          borderRadius: borderRadius,
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withValues(alpha: 0.1),
              blurRadius: 8.0,
            ),
          ],
        );
    final BoxDecoration unSelectedDecoration = widget.unSelectedTabDecoration ??
        BoxDecoration(
          color: theme.colorScheme.primaryContainer,
          borderRadius: borderRadius,
        );

    _indicatorPainter = !_controllerIsValid
        ? null
        : _DecorationPainter(
            controller: _controller!,
            indicator: _getIndicator(indicatorSize),
            indicatorSize: widget.indicatorSize ??
                tabBarTheme.indicatorSize ??
                _defaults.indicatorSize!,
            indicatorPadding: widget.indicatorPadding,
            tabKeys: _tabKeys,
            old: _indicatorPainter as _DecorationPainter?,
            labelPaddings: _labelPaddings,
            decoration: decoration,
            tabBarHeight: widget._tabBarHeight,
            heightDifference: widget.heightDifference ?? 8.0,
            unSelectedTabDecoration: unSelectedDecoration,
          );
  }

  @override
  void didUpdateWidget(TxTabBarView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.decoration != oldWidget.decoration ||
        widget.body != oldWidget.body ||
        widget.unSelectedTabDecoration != oldWidget.unSelectedTabDecoration ||
        widget.heightDifference != oldWidget.heightDifference) {
      _initIndicatorPainter();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget tabBarView = CustomPaint(
      painter: _indicatorPainter,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          super.build(context),
          widget.body,
        ],
      ),
    );

    if (widget._padding != null) {
      return Padding(padding: widget._padding!, child: tabBarView);
    }

    return tabBarView;
  }
}

class _DecorationPainter extends _TabBarPainter {
  _DecorationPainter({
    required super.controller,
    required super.indicator,
    required super.indicatorSize,
    required super.tabKeys,
    required super.old,
    required super.indicatorPadding,
    required super.labelPaddings,
    required this.decoration,
    required double super.tabBarHeight,
    required this.unSelectedTabDecoration,
    required this.heightDifference,
  });

  final BoxDecoration decoration;
  final BoxDecoration unSelectedTabDecoration;
  final double heightDifference;

  void _paintDecoration(
    Canvas canvas,
    Path path,
    BoxDecoration decoration,
    Rect rect,
  ) {
    if (decoration.boxShadow != null) {
      for (final BoxShadow shadow in decoration.boxShadow!) {
        final Paint shadowPainter = shadow.toPaint();
        if (shadow.spreadRadius == 0) {
          canvas.drawPath(path.shift(shadow.offset), shadowPainter);
        } else {
          final Rect zone = path.getBounds();
          final double xScale = (zone.width + shadow.spreadRadius) / zone.width;
          final double yScale =
              (zone.height + shadow.spreadRadius) / zone.height;
          final Matrix4 m4 = Matrix4.identity();
          m4.translate(zone.width / 2, zone.height / 2);
          m4.scale(xScale, yScale);
          m4.translate(-zone.width / 2, -zone.height / 2);
          canvas.drawPath(
            path.shift(shadow.offset).transform(m4.storage),
            shadowPainter,
          );
        }
      }
    }

    final Paint paint = Paint()
      ..shader = decoration.gradient?.createShader(rect)
      ..style = PaintingStyle.fill;

    if (decoration.color != null) {
      paint.color = decoration.color!;
    }
    if (decoration.backgroundBlendMode != null) {
      paint.blendMode = decoration.backgroundBlendMode!;
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_DecorationPainter old) {
    return decoration != old.decoration ||
        unSelectedTabDecoration != old.unSelectedTabDecoration ||
        heightDifference != old.heightDifference;
  }

  @override
  void paintDecoration(
    Canvas canvas,
    Size size,
    double value,
    int from,
    int to,
  ) {
    final double t = (value - from).abs();
    final Rect tabFromRect = indicatorRect(tabBarHeight!, from, true);
    final Rect tabToRect = indicatorRect(tabBarHeight!, to, true);
    final Rect tabRect = Rect.lerp(tabFromRect, tabToRect, t)!;
    final double left = tabRect.left;
    final double right = tabRect.right;
    final double bottom = tabRect.bottom;

    final BorderRadius borderRadius =
        decoration.borderRadius?.resolve(_currentTextDirection) ??
            const BorderRadius.vertical(top: Radius.circular(8.0));
    final BorderRadius unSelectedBorderRadius =
        unSelectedTabDecoration.borderRadius?.resolve(_currentTextDirection) ??
            borderRadius;

    final Path path = Path()
      ..moveTo(size.width, size.height - borderRadius.bottomRight.y)
      ..arcToPoint(
        Offset(size.width - borderRadius.bottomRight.x, size.height),
        radius: borderRadius.bottomRight,
      )
      ..lineTo(borderRadius.bottomLeft.x, size.height)
      ..arcToPoint(
        Offset(0.0, size.height - borderRadius.bottomLeft.y),
        radius: borderRadius.bottomLeft,
      );

    final Radius topLeftRadius = borderRadius.topLeft;
    final double leftDx = topLeftRadius.x;
    final double leftDy = topLeftRadius.y;
    final Offset beginPoint = Offset(0, bottom + leftDy);

    Offset lcp1 = Offset(left + _cubicOffset / 2, bottom);
    Offset lcp2 = Offset(left - _cubicOffset / 2, 0.0);
    double lcbX = left - _cubicOffset;
    double lceX = left + _cubicOffset;
    double lcbY = bottom;
    if (left < _currentTabOffsets![1]) {
      final Offset targetP1 = Offset(0.0, leftDy / 2);
      final Offset targetP2 = Offset(leftDx / 2, 0.0);

      if (controller.index == 0) {
        final double dt = left == 0.0 ? 1 : t;
        lcbX = lerpDouble(lcbX, 0.0, dt)!;
        lceX = lerpDouble(lceX, leftDx, dt)!;
        lcp1 = Offset.lerp(lcp1, targetP1, dt)!;
        lcp2 = Offset.lerp(lcp2, targetP2, dt)!;
      } else {
        final double dt = left == _currentTabOffsets![1] ? 1 : t;
        lcbX = lerpDouble(0.0, lcbX, dt)!;
        lceX = lerpDouble(leftDx, lceX, dt)!;
        lcp1 = Offset.lerp(targetP1, lcp1, dt)!;
        lcp2 = Offset.lerp(targetP2, lcp2, dt)!;
      }
      lcbX = math.max(0.0, lcbX);
      if (leftDx >= lcbX) {
        final double percent = (leftDx - lcbX) / leftDx;
        lcbY = leftDy / 2 + bottom - (bottom - leftDy) * percent;
      }
    }

    path.lineTo(beginPoint.dx, beginPoint.dy);

    final Radius unSelectedLeftRadius = unSelectedBorderRadius.topLeft;
    final Path leftTabPath = Path()
      ..moveTo(lceX, heightDifference)
      ..lineTo(unSelectedLeftRadius.x, heightDifference)
      ..arcToPoint(
        Offset(0.0, unSelectedLeftRadius.y + heightDifference),
        radius: unSelectedLeftRadius,
        clockwise: false,
      )
      ..lineTo(beginPoint.dx, beginPoint.dy);

    path.quadraticBezierTo(
      0.0,
      bottom,
      math.min(lcbX, leftDx),
      lcbY,
    );
    leftTabPath.quadraticBezierTo(
      0.0,
      bottom,
      math.min(lcbX, leftDx),
      lcbY,
    );
    if (leftDx < lcbX) {
      path.lineTo(lcbX, lcbY);
      leftTabPath.lineTo(lcbX, lcbY);
    }

    path.cubicTo(
      lcp1.dx,
      lcp1.dy,
      lcp2.dx,
      lcp2.dy,
      lceX,
      0.0,
    );
    leftTabPath.cubicTo(
      lcp1.dx,
      lcp1.dy,
      lcp2.dx,
      lcp2.dy + heightDifference,
      lceX,
      heightDifference,
    );

    _paintDecoration(
      canvas,
      leftTabPath,
      unSelectedTabDecoration,
      Rect.fromLTRB(0.0, heightDifference, tabRect.left + 20, tabRect.bottom),
    );

    final Radius topRightRadius = borderRadius.topRight;
    final double dx = topRightRadius.x;
    final double dy = topRightRadius.y;
    double rcbX = right - _cubicOffset;
    double rceX = right + _cubicOffset;
    double rceY = bottom;
    Offset controlP1 = Offset(right + _cubicOffset / 2, 0.0);
    Offset controlP2 = Offset(right - _cubicOffset / 2, bottom);

    if (right > _currentTabOffsets![maxTabIndex]) {
      final Offset targetP1 = Offset(right - dx / 2, 0);
      final Offset targetP2 = Offset(right, dy / 2);

      if (controller.index == maxTabIndex) {
        final double dt = right == size.width ? 1 : t;
        rceX = lerpDouble(rceX, right, dt)!;
        rcbX = lerpDouble(rcbX, right - dx, dt)!;
        controlP1 = Offset.lerp(controlP1, targetP1, dt)!;
        controlP2 = Offset.lerp(controlP2, targetP2, dt)!;
      } else {
        final double dt = right == _currentTabOffsets![maxTabIndex - 1] ? 1 : t;
        rceX = lerpDouble(right, rceX, dt)!;
        rcbX = lerpDouble(right - dx, rcbX, dt)!;
        controlP1 = Offset.lerp(targetP1, controlP1, dt)!;
        controlP2 = Offset.lerp(targetP2, controlP2, dt)!;
      }
      rceX = math.min(size.width, rceX);
      if (rceX > size.width - dx) {
        final double percent = (dx - (size.width - rceX)) / dx;
        rceY = bottom - (bottom - dy) * percent;
      }
    }

    final Radius unSelectedRadius = unSelectedBorderRadius.topRight;

    path
      ..lineTo(rcbX, 0.0)
      ..cubicTo(
        controlP1.dx,
        controlP1.dy,
        controlP2.dx,
        controlP2.dy,
        rceX,
        rceY,
      );
    final Path rightTabPath = Path()
      ..moveTo(rcbX, heightDifference)
      ..cubicTo(
        controlP1.dx,
        controlP1.dy + heightDifference,
        controlP2.dx,
        controlP2.dy,
        rceX,
        rceY,
      );

    if (rceX < size.width - dx) {
      path.lineTo(size.width - topRightRadius.x, tabRect.bottom);
      rightTabPath.lineTo(size.width - topRightRadius.x, tabRect.bottom);
    }

    path.quadraticBezierTo(
      size.width,
      bottom,
      size.width,
      bottom + dy,
    );
    rightTabPath
      ..quadraticBezierTo(
        size.width,
        bottom,
        size.width,
        bottom + dy,
      )
      ..lineTo(size.width, unSelectedRadius.y + heightDifference)
      ..arcToPoint(
        Offset(size.width - unSelectedRadius.x, heightDifference),
        radius: unSelectedRadius,
        clockwise: false,
      )
      ..close();
    _paintDecoration(
      canvas,
      rightTabPath,
      unSelectedTabDecoration,
      Rect.fromLTRB(
        0.0,
        heightDifference,
        right,
        bottom,
      ),
    );

    path.lineTo(size.width, size.height);

    _paintDecoration(
      canvas,
      path,
      decoration,
      Rect.fromLTRB(0.0, 0.0, size.width, size.height),
    );
  }
}

abstract class CustomTabBar extends StatefulWidget {
  const CustomTabBar({
    required this.tabs,
    super.key,
    this.controller,
    this.padding,
    this.indicatorColor,
    this.automaticIndicatorColorAdjustment = true,
    this.indicatorWeight = 2.0,
    this.indicatorPadding = EdgeInsets.zero,
    this.indicator,
    this.indicatorSize,
    this.labelColor,
    this.unselectedLabelColor,
    this.labelStyle,
    this.unselectedLabelStyle,
    this.labelPadding,
    this.onTap,
    bool isPrimary = true,
  }) : _isPrimary = isPrimary;

  /// 参考[TabBar.tabs]
  final List<Widget> tabs;

  /// 参考[TabBar.controller]
  final TabController? controller;

  /// 参考[TabBar.padding]
  final EdgeInsetsGeometry? padding;

  /// 参考[TabBar.indicatorColor]
  final Color? indicatorColor;

  /// 参考[TabBar.indicatorWeight]
  final double indicatorWeight;

  /// 参考[TabBar.indicatorPadding]
  final EdgeInsetsGeometry indicatorPadding;

  /// 参考[TabBar.indicator]
  final UnderlineTabIndicator? indicator;

  /// 参考[TabBar.automaticIndicatorColorAdjustment]
  final bool automaticIndicatorColorAdjustment;

  /// 参考[TabBar.indicatorSize]
  final TabBarIndicatorSize? indicatorSize;

  /// 参考[TabBar.labelColor]
  final Color? labelColor;

  /// 参考[TabBar.unselectedLabelColor]
  final Color? unselectedLabelColor;

  /// 参考[TabBar.labelStyle]
  final TextStyle? labelStyle;

  /// 参考[TabBar.unselectedLabelStyle]
  final TextStyle? unselectedLabelStyle;

  /// 参考[TabBar.labelPadding]
  final EdgeInsetsGeometry? labelPadding;

  /// 参考[TabBar.onTap]
  final ValueChanged<int>? onTap;

  /// 参考[TabBar._isPrimary]
  final bool _isPrimary;

  /// 参考[TabBar.tabHasTextAndIcon]
  bool get tabHasTextAndIcon {
    for (final Widget item in tabs) {
      if (item is PreferredSizeWidget) {
        if (item.preferredSize.height == _kTextAndIconTabHeight) {
          return true;
        }
      }
    }
    return false;
  }

  @override
  State<CustomTabBar> createState();
}

abstract class _CustomTabBarState extends State<CustomTabBar> {
  TabController? _controller;
  _TabBarPainter? _indicatorPainter;
  int? _currentIndex;
  late List<GlobalKey> _tabKeys;
  late List<EdgeInsetsGeometry> _labelPaddings;
  bool _debugHasScheduledValidTabsCountCheck = false;

  @override
  void initState() {
    super.initState();
    // 如果 indicatorSize 为 TabIndicatorSize.label，则 _tabKeys[i] 用于查找选项卡
    // 小部件 i 的宽度。 参见 _IndicatorPainter.indicatorRect()。
    _tabKeys = widget.tabs.map((tab) => GlobalKey()).toList();
    _labelPaddings = List<EdgeInsetsGeometry>.filled(
      widget.tabs.length,
      EdgeInsets.zero,
      growable: true,
    );
  }

  TabBarTheme get _defaults {
    if (Theme.of(context).useMaterial3) {
      return widget._isPrimary
          ? _TabsPrimaryDefaultsM3(context)
          : _TabsSecondaryDefaultsM3(context);
    } else {
      return _TabsDefaultsM2(context);
    }
  }

  // 如果使用新的选项卡控制器重新生成 TabBar，则调用方应释放旧的选项卡控制器。在这种情况下，
  // 旧控制器的动画将为 null，不应访问。
  bool get _controllerIsValid => _controller?.animation != null;

  void _updateTabController() {
    final TabController? newController =
        widget.controller ?? DefaultTabController.maybeOf(context);
    assert(() {
      if (newController == null) {
        throw FlutterError(
          'No TabController for ${widget.runtimeType}.\n'
          'When creating a ${widget.runtimeType}, you must either provide an '
          'explicit TabController using the "controller" property, or you must '
          'ensure that there is a DefaultTabController above the '
          '${widget.runtimeType}.\n In this case, there was neither an explicit'
          'controller nor a default controller.',
        );
      }
      return true;
    }());

    if (newController == _controller) {
      return;
    }

    if (_controllerIsValid) {
      _controller!.animation!.removeListener(_handleTabControllerAnimationTick);
      _controller!.removeListener(_handleTabControllerTick);
    }
    _controller = newController;
    if (_controller != null) {
      _controller!.animation!.addListener(_handleTabControllerAnimationTick);
      _controller!.addListener(_handleTabControllerTick);
      _currentIndex = _controller!.index;
    }
  }

  void _initIndicatorPainter();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    assert(debugCheckHasMaterial(context));
    _updateTabController();
    _initIndicatorPainter();
  }

  @override
  void didUpdateWidget(CustomTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _updateTabController();
      _initIndicatorPainter();
    } else if (widget.indicatorColor != oldWidget.indicatorColor ||
        widget.indicatorWeight != oldWidget.indicatorWeight ||
        widget.indicatorSize != oldWidget.indicatorSize ||
        widget.indicatorPadding != oldWidget.indicatorPadding ||
        widget.indicator != oldWidget.indicator) {
      _initIndicatorPainter();
    }

    if (widget.tabs.length > _tabKeys.length) {
      final int delta = widget.tabs.length - _tabKeys.length;
      _tabKeys.addAll(List<GlobalKey>.generate(delta, (n) => GlobalKey()));
      _labelPaddings
          .addAll(List<EdgeInsetsGeometry>.filled(delta, EdgeInsets.zero));
    } else if (widget.tabs.length < _tabKeys.length) {
      _tabKeys.removeRange(widget.tabs.length, _tabKeys.length);
      _labelPaddings.removeRange(widget.tabs.length, _tabKeys.length);
    }
  }

  @override
  void dispose() {
    _indicatorPainter!.dispose();
    if (_controllerIsValid) {
      _controller!.animation!.removeListener(_handleTabControllerAnimationTick);
      _controller!.removeListener(_handleTabControllerTick);
    }
    _controller = null;
    // 我们不拥有 _controller Animation，所以这里没有处理它。
    super.dispose();
  }

  int get maxTabIndex => _indicatorPainter!.maxTabIndex;

  void _handleTabControllerAnimationTick() {
    assert(mounted);
    if (!_controller!.indexIsChanging) {
      // 将 TabBar 的滚动位置与 TabBarView 的 PageView 同步。
      _currentIndex = _controller!.index;
    }
  }

  void _handleTabControllerTick() {
    if (_controller!.index != _currentIndex) {
      _currentIndex = _controller!.index;
    }
    setState(() {
      // Rebuild the tabs after a (potentially animated) index change
      // has completed.
    });
  }

  // 每次布局完成时调用。
  void _saveTabOffsets(
    List<double> tabOffsets,
    TextDirection textDirection,
    double width,
  ) {
    _indicatorPainter?.saveTabOffsets(tabOffsets, textDirection);
  }

  void _handleTap(int index) {
    assert(index >= 0 && index < widget.tabs.length);
    _controller!.animateTo(index);
    widget.onTap?.call(index);
  }

  Decoration? _getIndicator(TabBarIndicatorSize indicatorSize) {
    final ThemeData theme = Theme.of(context);
    final TabBarThemeData tabBarTheme = TabBarTheme.of(context);

    if (widget.indicator != null) {
      return widget.indicator!;
    }
    if (tabBarTheme.indicator != null) {
      return tabBarTheme.indicator!;
    }

    if (widget.indicatorWeight == 0) {
      return null;
    }

    Color color = widget.indicatorColor ??
        tabBarTheme.indicatorColor ??
        _defaults.indicatorColor!;

    if (widget.automaticIndicatorColorAdjustment &&
        color == Material.maybeOf(context)?.color) {
      color = Colors.white;
    }

    final bool primaryWithLabelIndicator =
        widget._isPrimary && indicatorSize == TabBarIndicatorSize.label;
    final double effectiveIndicatorWeight =
        theme.useMaterial3 && primaryWithLabelIndicator
            ? math.max(
                widget.indicatorWeight,
                _TabsPrimaryDefaultsM3.indicatorWeight,
              )
            : widget.indicatorWeight;
    final BorderRadius? effectiveBorderRadius =
        theme.useMaterial3 && primaryWithLabelIndicator
            ? BorderRadius.only(
                topLeft: Radius.circular(effectiveIndicatorWeight),
                topRight: Radius.circular(effectiveIndicatorWeight),
              )
            : null;
    return UnderlineTabIndicator(
      borderRadius: effectiveBorderRadius,
      borderSide: BorderSide(
        width: effectiveIndicatorWeight,
        color: color,
      ),
    );
  }

  Widget _buildStyledTab(
    Widget child,
    bool isSelected,
    Animation<double> animation,
    TabBarTheme defaults,
  ) {
    return _TabStyle(
      animation: animation,
      isSelected: isSelected,
      isPrimary: widget._isPrimary,
      labelColor: widget.labelColor,
      unselectedLabelColor: widget.unselectedLabelColor,
      labelStyle: widget.labelStyle,
      unselectedLabelStyle: widget.unselectedLabelStyle,
      defaults: defaults,
      child: child,
    );
  }

  bool _debugScheduleCheckHasValidTabsCount() {
    if (_debugHasScheduledValidTabsCountCheck) {
      return true;
    }
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      _debugHasScheduledValidTabsCountCheck = false;
      if (!mounted) {
        return;
      }
      assert(() {
        if (_controller!.length != widget.tabs.length) {
          throw FlutterError(
            "Controller's length property (${_controller!.length}) does not "
            'match the number of tabs (${widget.tabs.length}) present in '
            "TabBar's tabs property.",
          );
        }
        return true;
      }());
    });
    _debugHasScheduledValidTabsCountCheck = true;
    return true;
  }

  Widget _buildTabBar() {
    assert(debugCheckHasMaterialLocalizations(context));
    assert(_debugScheduleCheckHasValidTabsCount());
    final TabBarThemeData tabBarTheme = TabBarTheme.of(context);

    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    if (_controller!.length == 0) {
      return Container(
        height: _kTabHeight + widget.indicatorWeight,
      );
    }

    final List<Widget> wrappedTabs =
        List<Widget>.generate(widget.tabs.length, (index) {
      const double verticalAdjustment =
          (_kTextAndIconTabHeight - _kTabHeight) / 2.0;
      EdgeInsetsGeometry? adjustedPadding;

      if (widget.tabs[index] is PreferredSizeWidget) {
        final PreferredSizeWidget tab =
            widget.tabs[index] as PreferredSizeWidget;
        if (widget.tabHasTextAndIcon &&
            tab.preferredSize.height == _kTabHeight) {
          if (widget.labelPadding != null || tabBarTheme.labelPadding != null) {
            adjustedPadding = (widget.labelPadding ?? tabBarTheme.labelPadding!)
                .add(const EdgeInsets.symmetric(vertical: verticalAdjustment));
          } else {
            adjustedPadding = const EdgeInsets.symmetric(
              vertical: verticalAdjustment,
              horizontal: 16.0,
            );
          }
        }
      }

      _labelPaddings[index] = adjustedPadding ??
          widget.labelPadding ??
          tabBarTheme.labelPadding ??
          kTabLabelPadding;

      return Center(
        heightFactor: 1.0,
        child: Padding(
          padding: _labelPaddings[index],
          child: KeyedSubtree(
            key: _tabKeys[index],
            child: widget.tabs[index],
          ),
        ),
      );
    });

    // If the controller was provided by DefaultTabController and we're part
    // of a Hero (typically the AppBar), then we will not be able to find the
    // controller during a Hero transition. See https://github.com/flutter/flutter/issues/213.
    if (_controller != null) {
      final int previousIndex = _controller!.previousIndex;

      if (_controller!.indexIsChanging) {
        // The user tapped on a tab, the tab controller's animation is running.
        assert(_currentIndex != previousIndex);
        final Animation<double> animation = _ChangeAnimation(_controller!);
        wrappedTabs[_currentIndex!] = _buildStyledTab(
          wrappedTabs[_currentIndex!],
          true,
          animation,
          _defaults,
        );
        wrappedTabs[previousIndex] = _buildStyledTab(
          wrappedTabs[previousIndex],
          false,
          animation,
          _defaults,
        );
      } else {
        // The user is dragging the TabBarView's PageView left or right.
        final int tabIndex = _currentIndex!;
        final Animation<double> centerAnimation =
            _DragAnimation(_controller!, tabIndex);
        wrappedTabs[tabIndex] = _buildStyledTab(
          wrappedTabs[tabIndex],
          true,
          centerAnimation,
          _defaults,
        );
        if (_currentIndex! > 0) {
          final int tabIndex = _currentIndex! - 1;
          final Animation<double> previousAnimation =
              ReverseAnimation(_DragAnimation(_controller!, tabIndex));
          wrappedTabs[tabIndex] = _buildStyledTab(
            wrappedTabs[tabIndex],
            false,
            previousAnimation,
            _defaults,
          );
        }
        if (_currentIndex! < widget.tabs.length - 1) {
          final int tabIndex = _currentIndex! + 1;
          final Animation<double> nextAnimation =
              ReverseAnimation(_DragAnimation(_controller!, tabIndex));
          wrappedTabs[tabIndex] = _buildStyledTab(
            wrappedTabs[tabIndex],
            false,
            nextAnimation,
            _defaults,
          );
        }
      }
    }

    // 将点击处理程序添加到每个选项卡。如果选项卡栏不可滚动，则为所有选项卡提供同等的灵活性，
    // 以便它们各自占据选项卡栏总宽度的相同份额。
    final int tabCount = widget.tabs.length;
    for (int index = 0; index < tabCount; index += 1) {
      wrappedTabs[index] = Expanded(
        child: GestureDetector(
          onTap: () {
            _handleTap(index);
          },
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: EdgeInsets.only(bottom: widget.indicatorWeight),
            child: Stack(
              children: <Widget>[
                wrappedTabs[index],
                Semantics(
                  selected: index == _currentIndex,
                  label: localizations.tabLabel(
                    tabIndex: index + 1,
                    tabCount: tabCount,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return _TabStyle(
      animation: kAlwaysDismissedAnimation,
      isSelected: false,
      isPrimary: widget._isPrimary,
      labelColor: widget.labelColor,
      unselectedLabelColor: widget.unselectedLabelColor,
      labelStyle: widget.labelStyle,
      unselectedLabelStyle: widget.unselectedLabelStyle,
      defaults: _defaults,
      child: _TabLabelBar(
        onPerformLayout: _saveTabOffsets,
        mainAxisSize: MainAxisSize.max,
        children: wrappedTabs,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget tabBar = _buildTabBar();

    if (widget.padding != null) {
      tabBar = Padding(
        padding: widget.padding!,
        child: tabBar,
      );
    }

    return tabBar;
  }
}

abstract class _TabBarPainter extends CustomPainter {
  _TabBarPainter({
    required this.controller,
    required this.indicator,
    required this.indicatorSize,
    required this.tabKeys,
    required _TabBarPainter? old,
    required this.indicatorPadding,
    required this.labelPaddings,
    this.tabBarHeight,
  }) : super(repaint: controller.animation) {
    if (old != null) {
      saveTabOffsets(old._currentTabOffsets, old._currentTextDirection);
    }
  }

  final TabController controller;
  final Decoration? indicator;
  final TabBarIndicatorSize? indicatorSize;
  final EdgeInsetsGeometry indicatorPadding;
  final List<GlobalKey> tabKeys;
  final List<EdgeInsetsGeometry> labelPaddings;

  // 每次完成 TabBar 布局时都会设置_currentTabOffsets和_currentTextDirection。
  // 当 TabBar 不包含选项卡时，这些值可以为 null，因为没有要布局的内容。
  List<double>? _currentTabOffsets;
  TextDirection? _currentTextDirection;

  Rect? _indicatorRect;
  BoxPainter? _painter;
  bool _needsPaint = false;
  double? tabBarHeight;

  void markNeedsPaint() {
    _needsPaint = true;
  }

  void dispose() {
    _painter?.dispose();
  }

  void saveTabOffsets(List<double>? tabOffsets, TextDirection? textDirection) {
    _currentTabOffsets = tabOffsets;
    _currentTextDirection = textDirection;
  }

  // _currentTabOffsets[index] 是制表符在索引处的起始边缘的偏移量，
  // _currentTabOffsets[_currentTabOffsets.length] 是最后一个制表符的结束边缘。
  int get maxTabIndex => _currentTabOffsets!.length - 2;

  double centerOf(int tabIndex) {
    assert(_currentTabOffsets != null);
    assert(_currentTabOffsets!.isNotEmpty);
    assert(tabIndex >= 0);
    assert(tabIndex <= maxTabIndex);
    return (_currentTabOffsets![tabIndex] + _currentTabOffsets![tabIndex + 1]) /
        2.0;
  }

  Rect indicatorRect(double tabBarHeight, int tabIndex, [bool isTab = false]) {
    assert(_currentTabOffsets != null);
    assert(_currentTextDirection != null);
    assert(_currentTabOffsets!.isNotEmpty);
    assert(tabIndex >= 0);
    assert(tabIndex <= maxTabIndex);
    double tabLeft, tabRight;
    switch (_currentTextDirection!) {
      case TextDirection.rtl:
        tabLeft = _currentTabOffsets![tabIndex + 1];
        tabRight = _currentTabOffsets![tabIndex];
      case TextDirection.ltr:
        tabLeft = _currentTabOffsets![tabIndex];
        tabRight = _currentTabOffsets![tabIndex + 1];
    }

    if (isTab) {
      return Rect.fromLTWH(tabLeft, 0.0, tabRight - tabLeft, tabBarHeight);
    }

    if (indicatorSize == TabBarIndicatorSize.label) {
      final double tabWidth = tabKeys[tabIndex].currentContext!.size!.width;
      final EdgeInsetsGeometry labelPadding = labelPaddings[tabIndex];
      final EdgeInsets insets = labelPadding.resolve(_currentTextDirection);
      final double delta =
          ((tabRight - tabLeft) - (tabWidth + insets.horizontal)) / 2.0;
      tabLeft += delta + insets.left;
      tabRight = tabLeft + tabWidth;
    }

    final EdgeInsets insets = indicatorPadding.resolve(_currentTextDirection);
    final Rect rect =
        Rect.fromLTWH(tabLeft, 0.0, tabRight - tabLeft, tabBarHeight);

    if (!(rect.size >= insets.collapsedSize)) {
      throw FlutterError(
        'indicatorPadding insets should be less than Tab Size\n'
        'Rect Size : ${rect.size}, Insets: $insets',
      );
    }
    return insets.deflateRect(rect);
  }

  void paintDecoration(
    Canvas canvas,
    Size size,
    double value,
    int from,
    int to,
  );

  @override
  void paint(Canvas canvas, Size size) {
    _needsPaint = false;

    final double index = controller.index.toDouble();
    final double value = controller.animation!.value;
    final bool ltr = index > value;
    final int from = (ltr ? value.floor() : value.ceil()).clamp(0, maxTabIndex);
    final int to = (ltr ? from + 1 : from - 1).clamp(0, maxTabIndex);

    if (indicator != null) {
      _painter ??= indicator!.createBoxPainter(markNeedsPaint);
      final double index = controller.index.toDouble();
      final double value = controller.animation!.value;
      final bool ltr = index > value;
      final int from =
          (ltr ? value.floor() : value.ceil()).clamp(0, maxTabIndex);
      final int to = (ltr ? from + 1 : from - 1).clamp(0, maxTabIndex);
      final Rect fromRect = indicatorRect(tabBarHeight ?? size.height, from);
      final Rect toRect = indicatorRect(tabBarHeight ?? size.height, to);
      _indicatorRect = Rect.lerp(fromRect, toRect, (value - from).abs());
      assert(_indicatorRect != null);

      final ImageConfiguration configuration = ImageConfiguration(
        size: _indicatorRect!.size,
        textDirection: _currentTextDirection,
      );
      _painter!.paint(canvas, _indicatorRect!.topLeft, configuration);
    } else if (_painter != null) {
      _painter!.dispose();
      _painter = null;
    }

    paintDecoration(canvas, size, value, from, to);
  }

  @override
  bool shouldRepaint(_TabBarPainter old) {
    return _needsPaint ||
        controller != old.controller ||
        indicator != old.indicator ||
        tabKeys.length != old.tabKeys.length ||
        (!listEquals(_currentTabOffsets, old._currentTabOffsets)) ||
        _currentTextDirection != old._currentTextDirection ||
        tabBarHeight != old.tabBarHeight;
  }
}

// 基于 Material Design 2 的手写编码默认值。
class _TabsDefaultsM2 extends TabBarTheme {
  const _TabsDefaultsM2(this.context)
      : super(indicatorSize: TabBarIndicatorSize.tab);

  final BuildContext context;

  @override
  Color? get indicatorColor => Theme.of(context).indicatorColor;

  @override
  Color? get labelColor => Theme.of(context).colorScheme.primary;

  @override
  Color? get unselectedLabelColor =>
      Theme.of(context).textTheme.bodyLarge!.color;

  @override
  TextStyle? get labelStyle => Theme.of(context).textTheme.bodyLarge;

  @override
  TextStyle? get unselectedLabelStyle =>
      Theme.of(context).primaryTextTheme.bodyLarge;

  @override
  InteractiveInkFeatureFactory? get splashFactory =>
      Theme.of(context).splashFactory;

  @override
  TabAlignment? get tabAlignment => TabAlignment.fill;
}

class _TabsPrimaryDefaultsM3 extends TabBarTheme {
  _TabsPrimaryDefaultsM3(this.context)
      : super(indicatorSize: TabBarIndicatorSize.label);

  final BuildContext context;
  late final ColorScheme _colors = Theme.of(context).colorScheme;
  late final TextTheme _textTheme = Theme.of(context).textTheme;

  @override
  Color? get dividerColor => _colors.surfaceContainerHighest;

  @override
  double? get dividerHeight => 1.0;

  @override
  Color? get indicatorColor => _colors.primary;

  @override
  Color? get labelColor => _colors.primary;

  @override
  TextStyle? get labelStyle => _textTheme.titleSmall;

  @override
  Color? get unselectedLabelColor => _colors.onSurfaceVariant;

  @override
  TextStyle? get unselectedLabelStyle => _textTheme.titleSmall;

  @override
  WidgetStateProperty<Color?> get overlayColor {
    return WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        if (states.contains(WidgetState.pressed)) {
          return _colors.primary.withValues(alpha: 0.12);
        }
        if (states.contains(WidgetState.hovered)) {
          return _colors.primary.withValues(alpha: 0.08);
        }
        if (states.contains(WidgetState.focused)) {
          return _colors.primary.withValues(alpha: 0.12);
        }
        return null;
      }
      if (states.contains(WidgetState.pressed)) {
        return _colors.primary.withValues(alpha: 0.12);
      }
      if (states.contains(WidgetState.hovered)) {
        return _colors.onSurface.withValues(alpha: 0.08);
      }
      if (states.contains(WidgetState.focused)) {
        return _colors.onSurface.withValues(alpha: 0.12);
      }
      return null;
    });
  }

  @override
  InteractiveInkFeatureFactory? get splashFactory =>
      Theme.of(context).splashFactory;

  @override
  TabAlignment? get tabAlignment => TabAlignment.fill;

  static double indicatorWeight = 3.0;
}

class _TabsSecondaryDefaultsM3 extends TabBarTheme {
  _TabsSecondaryDefaultsM3(this.context)
      : super(indicatorSize: TabBarIndicatorSize.tab);

  final BuildContext context;
  late final ColorScheme _colors = Theme.of(context).colorScheme;
  late final TextTheme _textTheme = Theme.of(context).textTheme;

  @override
  Color? get dividerColor => _colors.surfaceContainerHighest;

  @override
  double? get dividerHeight => 1.0;

  @override
  Color? get indicatorColor => _colors.primary;

  @override
  Color? get labelColor => _colors.onSurface;

  @override
  TextStyle? get labelStyle => _textTheme.titleSmall;

  @override
  Color? get unselectedLabelColor => _colors.onSurfaceVariant;

  @override
  TextStyle? get unselectedLabelStyle => _textTheme.titleSmall;

  @override
  WidgetStateProperty<Color?> get overlayColor {
    return WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        if (states.contains(WidgetState.pressed)) {
          return _colors.onSurface.withValues(alpha: 0.12);
        }
        if (states.contains(WidgetState.hovered)) {
          return _colors.onSurface.withValues(alpha: 0.08);
        }
        if (states.contains(WidgetState.focused)) {
          return _colors.onSurface.withValues(alpha: 0.12);
        }
        return null;
      }
      if (states.contains(WidgetState.pressed)) {
        return _colors.onSurface.withValues(alpha: 0.12);
      }
      if (states.contains(WidgetState.hovered)) {
        return _colors.onSurface.withValues(alpha: 0.08);
      }
      if (states.contains(WidgetState.focused)) {
        return _colors.onSurface.withValues(alpha: 0.12);
      }
      return null;
    });
  }

  @override
  InteractiveInkFeatureFactory? get splashFactory =>
      Theme.of(context).splashFactory;

  @override
  TabAlignment? get tabAlignment => TabAlignment.fill;
}
