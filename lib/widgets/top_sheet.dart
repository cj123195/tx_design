import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'top_sheet_theme.dart';

const Duration _topSheetEnterDuration = Duration(milliseconds: 250);
const Duration _topSheetExitDuration = Duration(milliseconds: 200);
const Curve _modalTopSheetCurve = Easing.legacyDecelerate;
const double _minFlingVelocity = 700.0;
const double _closeProgressThreshold = 0.5;
const double _defaultScrollControlDisabledMaxHeightRatio = 9.0 / 16.0;

class ModalTopSheetRoute<T> extends PopupRoute<T> {
  /// 模态顶部工作表路由。
  ModalTopSheetRoute({
    required this.builder,
    required this.isScrollControlled,
    this.capturedThemes,
    this.barrierLabel,
    this.barrierOnTapHint,
    this.backgroundColor,
    this.elevation,
    this.shape,
    this.clipBehavior,
    this.constraints,
    this.modalBarrierColor,
    this.isDismissible = true,
    this.enableDrag = true,
    this.showDragHandle,
    this.scrollControlDisabledMaxHeightRatio =
        _defaultScrollControlDisabledMaxHeightRatio,
    super.settings,
    this.transitionAnimationController,
    this.anchorPoint,
    this.useSafeArea = false,
  });

  /// 工作表内容的构建器。
  ///
  /// 顶部的工作表将把这个构建器生成的小部件包装在一个 [Material] 小部件中。
  final WidgetBuilder builder;

  /// 存储已捕获的 [InheritedTheme] 列表，这些列表环绕在顶部工作表周围。
  ///
  /// 当通过 [Navigator.push] 及其好友创建 [ModalTopSheetRoute] 时，请考虑设置此属性。
  final CapturedThemes? capturedThemes;

  /// 指定这是否是将使用 [DraggableScrollableSheet] 的顶部工作表的路由。
  ///
  /// 如果此顶部工作表具有可滚动的子工作表（如 [ListView] 或 [GridView]），请考虑将此参数设置为 true，以使顶部工作表可拖动。
  final bool isScrollControlled;

  /// 当 [isScrollControlled] 设置为 false 时，顶部工作表的最大高度约束比率，
  /// 当 [isScrollControlled] 设置为 true 时，将不应用任何比率。
  ///
  /// 默认值为 9 / 16.
  final double scrollControlDisabledMaxHeightRatio;

  /// 顶部工作表的背景颜色。
  ///
  /// 定义顶部工作表的 [Material.color]。
  ///
  /// 如果未提供此属性，则回退到 [Material] 的默认值。
  final Color? backgroundColor;

  /// 放置此材料相对于其父材质的 z 坐标。
  ///
  /// 这将控制材质下方阴影的大小。
  ///
  /// 默认值为 0，不得为负数。
  final double? elevation;

  /// 顶部工作表的形状。
  ///
  /// 定义顶部工作表的 [Material.shape]。
  ///
  /// 如果未提供此属性，则回退到 [Material] 的默认值。
  final ShapeBorder? shape;

  /// {@macro flutter.material.Material.clipBehavior}
  ///
  /// 定义顶页的 [Material.clipBehavior]。
  ///
  /// 当顶部工作表具有自定义 [Material] 并且内容可以延伸到此形状之外时，使用此属性可以启用内容剪裁。
  /// 例如，具有圆角的顶部工作表和顶部的边缘到边缘 [Image]。
  ///
  /// 如果此属性为 null，则使用 [ThemeData.bottomSheetTheme] 的
  /// [BottomSheetThemeData.clipBehavior]。如果为 null，则行为默认为 [Clip.none]
  /// 将为 [Clip.none]。
  final Clip? clipBehavior;

  /// 定义 [TopSheet] 的最小和最大大小。
  ///
  /// 如果为 null，则将使用环境 [ThemeData.bottomSheetTheme] 的
  /// [BottomSheetThemeData.constraints]。如果该值为 null 且 [ThemeData.useMaterial3]
  /// 为 true，则顶部工作表的最大宽度为 640dp。如果 [ThemeData.useMaterial3] 为 false，
  /// 则顶部工作表的大小将受其父级（通常为 [Scaffold]）的约束。在这种情况下，请考虑通过为大
  /// 屏幕设置较小的约束来限制宽度。
  ///
  /// 如果指定了约束（在此属性中或在主题中），则顶部工作表将与可用空间的顶部中心对齐。否则，
  /// 不会应用任何对齐方式。
  final BoxConstraints? constraints;

  /// 指定模态屏障的颜色，该色栏使顶部工作表下方的所有内容变暗。
  ///
  /// 如果未提供，则默认为“Colors.black54”。
  final Color? modalBarrierColor;

  /// 指定当用户点击稀松布时是否关闭顶页。
  ///
  /// 如果为 true，则当用户点击稀松布时，顶部工作表将被关闭。
  ///
  /// 默认值为 true。
  final bool isDismissible;

  /// 指定是否可以上下拖动顶部工作表，并通过向下滑动来关闭。
  ///
  /// 如果为 true，则可以上下拖动顶部工作表，并通过向下滑动来关闭。
  ///
  /// 如果 showDragHandle 为 true，则这适用于拖动句柄下方的内容。
  ///
  /// 默认值为 true.
  final bool enableDrag;

  /// 指定是否显示拖动手柄。
  ///
  /// 拖动手柄显示在顶部工作表的顶部。默认颜色为 [ColorScheme.onSurfaceVariant]，不透明度为 0.4，
  /// 可以使用 dragHandleColor 进行自定义。默认大小为“Size（32,4）”，可以使用 dragHandleSize 进行自定义。
  ///
  /// 如果为 null，则使用 [BottomSheetThemeData.showDragHandle] 的值。如果该值也为 null，
  /// 则默认为 false。
  final bool? showDragHandle;

  /// 控制顶部工作表的入口和出口动画的动画控制器。
  ///
  /// TopSheet 小部件将操纵此动画的位置，它不仅仅是一个被动的观察者。
  final AnimationController? transitionAnimationController;

  /// {@macro flutter.widgets.DisplayFeatureSubScreen.anchorPoint}
  final Offset? anchorPoint;

  /// 是否避免上、左、右的系统入侵。
  ///
  /// 如果为 true，则插入 [SafeArea] 以使顶部工作表远离屏幕顶部、左侧和右侧的系统入侵。
  ///
  /// 如果为 false，则顶部工作表将延伸到顶部、左侧和右侧的任何系统入侵。
  ///
  /// 如果为 false，则 [MediaQuery.removePadding] 将用于删除顶部填充，以便顶部工作表内的
  /// [SafeArea] 小部件在顶部边缘不起作用。如果不希望这样做，请考虑将 [useSafeArea] 设置为
  /// true。或者，将 [SafeArea] 包装在 [MediaQuery] 中，该 [MediaQuery] 从外部 [builder]
  /// 重述环境 [MediaQueryData]。
  ///
  /// 无论哪种情况，顶部工作表都会一直延伸到屏幕底部，包括任何系统入侵。
  ///
  /// 默认值为 false。
  final bool useSafeArea;

  /// {@template flutter.material.ModalTopSheetRoute.barrierOnTapHint}
  /// 语义提示文本，通知用户点击小组件时会发生什么。以“双击...”的格式宣布。
  ///
  /// 如果该字段为 null，则将使用默认提示，这会导致“双击激活”的公告。
  /// {@endtemplate}
  ///
  /// 另请参阅：
  ///
  ///  * [barrierDismissible], 它控制屏障在点击时的行为。
  ///  * [ModalBarrier], 当此字段具有 onTap 操作时，它将此字段用作 onTapHint。
  final String? barrierOnTapHint;

  final ValueNotifier<EdgeInsets> _clipDetailsNotifier =
      ValueNotifier<EdgeInsets>(EdgeInsets.zero);

  @override
  void dispose() {
    _clipDetailsNotifier.dispose();
    super.dispose();
  }

  /// 更新有关如何裁剪此 [ModalTopSheetRoute] 的屏障的 [SemanticsNode.rect]（焦点）
  /// 的详细信息。
  ///
  /// 如果 clipDetails 确实发生了变化，则返回 true，否则返回 false。
  bool _didChangeBarrierSemanticsClip(EdgeInsets newClipDetails) {
    if (_clipDetailsNotifier.value == newClipDetails) {
      return false;
    }
    _clipDetailsNotifier.value = newClipDetails;
    return true;
  }

  @override
  Duration get transitionDuration => _topSheetEnterDuration;

  @override
  Duration get reverseTransitionDuration => _topSheetExitDuration;

  @override
  bool get barrierDismissible => isDismissible;

  @override
  final String? barrierLabel;

  @override
  Color get barrierColor => modalBarrierColor ?? Colors.black54;

  AnimationController? _animationController;

  @override
  AnimationController createAnimationController() {
    assert(_animationController == null);
    if (transitionAnimationController != null) {
      _animationController = transitionAnimationController;
      willDisposeAnimationController = false;
    } else {
      _animationController = TopSheet.createAnimationController(navigator!);
    }
    return _animationController!;
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    final double top = MediaQuery.of(context).padding.top;

    final Widget content = DisplayFeatureSubScreen(
      anchorPoint: anchorPoint,
      child: Builder(
        builder: (BuildContext context) {
          final BottomSheetThemeData sheetTheme =
              Theme.of(context).bottomSheetTheme;
          final BottomSheetThemeData defaults = _TopSheetDefaultsM3(context);
          return _ModalTopSheet<T>(
            route: this,
            backgroundColor: backgroundColor ??
                sheetTheme.modalBackgroundColor ??
                sheetTheme.backgroundColor ??
                defaults.backgroundColor,
            elevation: elevation ??
                sheetTheme.modalElevation ??
                sheetTheme.elevation ??
                defaults.modalElevation,
            shape: shape,
            clipBehavior: clipBehavior,
            constraints: constraints,
            isScrollControlled: isScrollControlled,
            scrollControlDisabledMaxHeightRatio:
                scrollControlDisabledMaxHeightRatio,
            enableDrag: enableDrag,
            showDragHandle: showDragHandle ??
                (enableDrag && (sheetTheme.showDragHandle ?? false)),
            padding: EdgeInsets.only(top: top),
          );
        },
      ),
    );

    final Widget topSheet = MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: content,
    );

    return capturedThemes?.wrap(topSheet) ?? topSheet;
  }

  @override
  Widget buildModalBarrier() {
    if (barrierColor.alpha != 0 && !offstage) {
      // 如果 barrierColor 或 offstage 更新，则调用 changedInternalState
      assert(barrierColor != barrierColor.withOpacity(0.0));
      final Animation<Color?> color = animation!.drive(
        ColorTween(
          begin: barrierColor.withOpacity(0.0),
          end: barrierColor, // 如果 barrierColor 更新，则调用 changedInternalState
        ).chain(
          CurveTween(curve: barrierCurve),
        ), // 如果 barrierCurve 更新，则调用 changedInternalState
      );
      return AnimatedModalBarrier(
        color: color,
        dismissible: barrierDismissible,
        // 如果 barrierDismissible 更新，则调用 changedInternalState
        semanticsLabel: barrierLabel,
        // 如果 barrierLabel 更新，则调用 changedInternalState
        barrierSemanticsDismissible: semanticsDismissible,
        clipDetailsNotifier: _clipDetailsNotifier,
        semanticsOnTapHint: barrierOnTapHint,
      );
    } else {
      return ModalBarrier(
        dismissible: barrierDismissible,
        // 如果 barrierDismissible 更新，则调用 changedInternalState
        semanticsLabel: barrierLabel,
        // 如果 barrierLabel 更新，则调用 changedInternalState
        barrierSemanticsDismissible: semanticsDismissible,
        clipDetailsNotifier: _clipDetailsNotifier,
        semanticsOnTapHint: barrierOnTapHint,
      );
    }
  }
}

class _ModalTopSheet<T> extends StatefulWidget {
  const _ModalTopSheet({
    required this.route,
    super.key,
    this.backgroundColor,
    this.elevation,
    this.shape,
    this.clipBehavior,
    this.constraints,
    this.isScrollControlled = false,
    this.scrollControlDisabledMaxHeightRatio =
        _defaultScrollControlDisabledMaxHeightRatio,
    this.enableDrag = true,
    this.showDragHandle = false,
    this.padding,
  });

  final ModalTopSheetRoute<T> route;
  final bool isScrollControlled;
  final double scrollControlDisabledMaxHeightRatio;
  final Color? backgroundColor;
  final double? elevation;
  final ShapeBorder? shape;
  final Clip? clipBehavior;
  final BoxConstraints? constraints;
  final bool enableDrag;
  final bool showDragHandle;
  final EdgeInsetsGeometry? padding;

  @override
  _ModalTopSheetState<T> createState() => _ModalTopSheetState<T>();
}

class _ModalTopSheetState<T> extends State<_ModalTopSheet<T>> {
  ParametricCurve<double> animationCurve = _modalTopSheetCurve;

  String _getRouteLabel(MaterialLocalizations localizations) {
    switch (Theme.of(context).platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return '';
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return localizations.dialogLabel;
    }
  }

  EdgeInsets _getNewClipDetails(Size topLayerSize) {
    return EdgeInsets.fromLTRB(0, 0, 0, topLayerSize.height);
  }

  void handleDragStart(DragStartDetails details) {
    // 允许顶部工作表准确跟踪用户的手指。
    animationCurve = Curves.linear;
  }

  void handleDragEnd(DragEndDetails details, {bool? isClosing}) {
    // 让顶部工作表从其当前位置平滑地进行动画处理。
    animationCurve = _TopSheetSuspendedCurve(
      widget.route.animation!.value,
      curve: _modalTopSheetCurve,
    );
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMediaQuery(context));
    assert(debugCheckHasMaterialLocalizations(context));
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final String routeLabel = _getRouteLabel(localizations);

    return AnimatedBuilder(
      animation: widget.route.animation!,
      child: TopSheet(
        animationController: widget.route._animationController,
        onClosing: () {
          if (widget.route.isCurrent) {
            Navigator.pop(context);
          }
        },
        builder: widget.route.builder,
        backgroundColor: widget.backgroundColor,
        elevation: widget.elevation,
        shape: widget.shape,
        clipBehavior: widget.clipBehavior,
        constraints: widget.constraints,
        enableDrag: widget.enableDrag,
        showDragHandle: widget.showDragHandle,
        onDragStart: handleDragStart,
        onDragEnd: handleDragEnd,
        padding: widget.padding,
      ),
      builder: (BuildContext context, Widget? child) {
        final double animationValue = animationCurve.transform(
          widget.route.animation!.value,
        );
        return Semantics(
          scopesRoute: true,
          namesRoute: true,
          label: routeLabel,
          explicitChildNodes: true,
          child: ClipRect(
            child: _TopSheetLayoutWithSizeListener(
              onChildSizeChanged: (Size size) {
                widget.route._didChangeBarrierSemanticsClip(
                  _getNewClipDetails(size),
                );
              },
              animationValue: animationValue,
              isScrollControlled: widget.isScrollControlled,
              scrollControlDisabledMaxHeightRatio:
                  widget.scrollControlDisabledMaxHeightRatio,
              child: child,
            ),
          ),
        );
      },
    );
  }
}

// TODO(guidezpl): Look into making this public. A copy of this class is in
//  scaffold.dart, for now, https://github.com/flutter/flutter/issues/51627
/// 一条线性进展的曲线，直到指定的 [起点]，该点 [curve] 将开始。与 [Interval] 不同，
/// [curve] 不会从零开始，而是使用 [startingPoint] 作为 Y 位置。
///
/// 例如，如果 [startingPoint] 设置为 '0.5'，而 [curve] 设置为 [Curves.easeOut]，
/// 则曲线的左下角四分之一将是一条直线，右上角的四分之一将包含 [Curves.easeOut] 的全部内容。
///
/// 这在小部件必须跟踪用户的手指（这需要线性动画）的情况下非常有用，然后可以在释放手指后使用使用
/// [curve] 参数指定的曲线进行甩出。在这种情况下，[startingPoint] 的值将是松开手指时动画的进度。
class _TopSheetSuspendedCurve extends ParametricCurve<double> {
  /// 创建悬浮曲线。
  const _TopSheetSuspendedCurve(
    this.startingPoint, {
    this.curve = Curves.easeOutCubic,
  });

  /// [curve] 应从此开始的进度值。
  final double startingPoint;

  /// 到达 [startingPoint] 时要使用的曲线。
  ///
  /// 默认为 [Curves.easeOutCubic]。
  final Curve curve;

  @override
  double transform(double t) {
    assert(t >= 0.0 && t <= 1.0);
    assert(startingPoint >= 0.0 && startingPoint <= 1.0);

    if (t < startingPoint) {
      return t;
    }

    if (t == 1.0) {
      return t;
    }

    final double curveProgress = (t - startingPoint) / (1 - startingPoint);
    final double transformed = curve.transform(curveProgress);
    return lerpDouble(startingPoint, 1, transformed)!;
  }

  @override
  String toString() {
    return '${describeIdentity(this)}($startingPoint, $curve)';
  }
}

typedef _SizeChangeCallback<Size> = void Function(Size size);

class _TopSheetLayoutWithSizeListener extends SingleChildRenderObjectWidget {
  const _TopSheetLayoutWithSizeListener({
    required this.onChildSizeChanged,
    required this.animationValue,
    required this.isScrollControlled,
    required this.scrollControlDisabledMaxHeightRatio,
    super.child,
  });

  final _SizeChangeCallback<Size> onChildSizeChanged;
  final double animationValue;
  final bool isScrollControlled;
  final double scrollControlDisabledMaxHeightRatio;

  @override
  _RenderTopSheetLayoutWithSizeListener createRenderObject(
    BuildContext context,
  ) {
    return _RenderTopSheetLayoutWithSizeListener(
      onChildSizeChanged: onChildSizeChanged,
      animationValue: animationValue,
      isScrollControlled: isScrollControlled,
      scrollControlDisabledMaxHeightRatio: scrollControlDisabledMaxHeightRatio,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderTopSheetLayoutWithSizeListener renderObject,
  ) {
    renderObject.onChildSizeChanged = onChildSizeChanged;
    renderObject.animationValue = animationValue;
    renderObject.isScrollControlled = isScrollControlled;
    renderObject.scrollControlDisabledMaxHeightRatio =
        scrollControlDisabledMaxHeightRatio;
  }
}

class _RenderTopSheetLayoutWithSizeListener extends RenderShiftedBox {
  _RenderTopSheetLayoutWithSizeListener({
    required _SizeChangeCallback<Size> onChildSizeChanged,
    required double animationValue,
    required bool isScrollControlled,
    required double scrollControlDisabledMaxHeightRatio,
    RenderBox? child,
  })  : _onChildSizeChanged = onChildSizeChanged,
        _animationValue = animationValue,
        _isScrollControlled = isScrollControlled,
        _scrollControlDisabledMaxHeightRatio =
            scrollControlDisabledMaxHeightRatio,
        super(child);

  Size _lastSize = Size.zero;

  _SizeChangeCallback<Size> get onChildSizeChanged => _onChildSizeChanged;
  _SizeChangeCallback<Size> _onChildSizeChanged;

  set onChildSizeChanged(_SizeChangeCallback<Size> newCallback) {
    if (_onChildSizeChanged == newCallback) {
      return;
    }

    _onChildSizeChanged = newCallback;
    markNeedsLayout();
  }

  double get animationValue => _animationValue;
  double _animationValue;

  set animationValue(double newValue) {
    if (_animationValue == newValue) {
      return;
    }

    _animationValue = newValue;
    markNeedsLayout();
  }

  bool get isScrollControlled => _isScrollControlled;
  bool _isScrollControlled;

  set isScrollControlled(bool newValue) {
    if (_isScrollControlled == newValue) {
      return;
    }

    _isScrollControlled = newValue;
    markNeedsLayout();
  }

  double get scrollControlDisabledMaxHeightRatio =>
      _scrollControlDisabledMaxHeightRatio;
  double _scrollControlDisabledMaxHeightRatio;

  set scrollControlDisabledMaxHeightRatio(double newValue) {
    if (_scrollControlDisabledMaxHeightRatio == newValue) {
      return;
    }

    _scrollControlDisabledMaxHeightRatio = newValue;
    markNeedsLayout();
  }

  Size _getSize(BoxConstraints constraints) {
    return constraints.constrain(constraints.biggest);
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    final double width =
        _getSize(BoxConstraints.tightForFinite(height: height)).width;
    if (width.isFinite) {
      return width;
    }
    return 0.0;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    final double width =
        _getSize(BoxConstraints.tightForFinite(height: height)).width;
    if (width.isFinite) {
      return width;
    }
    return 0.0;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    final double height =
        _getSize(BoxConstraints.tightForFinite(width: width)).height;
    if (height.isFinite) {
      return height;
    }
    return 0.0;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    final double height =
        _getSize(BoxConstraints.tightForFinite(width: width)).height;
    if (height.isFinite) {
      return height;
    }
    return 0.0;
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return _getSize(constraints);
  }

  BoxConstraints _getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints(
      minWidth: constraints.maxWidth,
      maxWidth: constraints.maxWidth,
      maxHeight: isScrollControlled
          ? constraints.maxHeight
          : constraints.maxHeight * scrollControlDisabledMaxHeightRatio,
    );
  }

  Offset _getPositionForChild(Size size, Size childSize) {
    return Offset(0.0, childSize.height * animationValue - childSize.height);
  }

  @override
  void performLayout() {
    size = _getSize(constraints);
    if (child != null) {
      final BoxConstraints childConstraints =
          _getConstraintsForChild(constraints);
      assert(childConstraints.debugAssertIsValid(isAppliedConstraint: true));
      child!
          .layout(childConstraints, parentUsesSize: !childConstraints.isTight);
      final BoxParentData childParentData = child!.parentData! as BoxParentData;
      childParentData.offset = _getPositionForChild(
        size,
        childConstraints.isTight ? childConstraints.smallest : child!.size,
      );
      final Size childSize =
          childConstraints.isTight ? childConstraints.smallest : child!.size;

      if (_lastSize != childSize) {
        _lastSize = childSize;
        _onChildSizeChanged.call(_lastSize);
      }
    }
  }
}

/// Material Design 顶部工作表。
///
///  模式顶部工作表是菜单或对话框的替代方法，可防止用户与应用的其余部分进行交互。
///  可以使用 [showModalTopSheet] 函数创建和显示模态顶部工作表。
///
/// [TopSheet] 小部件本身很少直接使用。相反，最好使用 [showModalTopSheet] 创建模态顶部工作表。
///
/// 另请参阅：
///
///  * [showModalTopSheet], 可用于显示模态顶部工作表。
///  * [BottomSheetThemeData], 可用于自定义默认的顶部工作表属性值。
///  * Material 2 规范位于 <https://m2.material.io/components/sheets-bottom>.
///  * Material 3 规范位于 <https://m3.material.io/components/bottom-sheets/overview>.
class TopSheet extends StatefulWidget {
  /// 创建顶部工作表。
  ///
  /// 通常，顶部工作表由 [showModalTopSheet] 隐式创建。
  const TopSheet({
    required this.onClosing,
    required this.builder,
    super.key,
    this.animationController,
    this.enableDrag = true,
    this.showDragHandle,
    this.dragHandleColor,
    this.dragHandleSize,
    this.onDragStart,
    this.onDragEnd,
    this.backgroundColor,
    this.shadowColor,
    this.elevation,
    this.shape,
    this.clipBehavior,
    this.constraints,
    this.padding,
  }) : assert(elevation == null || elevation >= 0.0);

  /// 控制顶部工作表的入口和出口动画的动画控制器。
  ///
  /// TopSheet 小部件将操纵此动画的位置，它不仅仅是一个被动的观察者。
  final AnimationController? animationController;

  /// 当顶部工作表开始关闭时调用。
  ///
  /// 即使在调用此回调后，顶部工作表也可能被阻止关闭（例如，通过用户交互）。因此，对于给定的顶部工作表，
  /// 可能会多次调用此回调。
  final VoidCallback onClosing;

  /// 工作表内容的构建器。
  ///
  /// 顶部的工作表将把这个构建器生成的小部件包装在一个 [Material] 小部件中。
  final WidgetBuilder builder;

  /// 如果为 true，则可以上下拖动顶部工作表，并通过向下滑动来关闭。
  ///
  /// 如果 [showDragHandle] 为 true，则这仅适用于拖动手柄下方的内容，因为拖动手柄始终是可拖动的。
  ///
  /// 默认值为 true。
  ///
  /// 如果为 true，则 [animationController] 不能为 null。使用
  /// [TopSheet.createAnimationController] 创建一个，或提供另一个 AnimationController。
  final bool enableDrag;

  /// 指定是否显示拖动手柄。
  ///
  /// 拖动手柄显示在顶部工作表的顶部。默认颜色为 [ColorScheme.onSurfaceVariant]，不透明度
  /// 为 0.4，可以使用 [dragHandleColor] 进行自定义。默认大小为“Size（32,4）”，可以使用
  /// [dragHandleSize] 自定义。
  ///
  /// 如果为 null，则使用 [BottomSheetThemeData.showDragHandle] 的值。
  /// 如果该值也为 null，则默认为 false。
  ///
  /// 如果为 true，则 [animationController] 不能为 null。使用
  /// [TopSheet.createAnimationController] 创建一个，或提供另一个 AnimationController。
  final bool? showDragHandle;

  /// 顶部工作表拖动手柄的颜色。
  ///
  /// 默认为 [BottomSheetThemeData.dragHandleColor]。如果该值也为 null，
  /// 则默认为 [ColorScheme.onSurfaceVariant]，不透明度为 0.4。
  final Color? dragHandleColor;

  /// 默认为 [BottomSheetThemeData.dragHandleSize]。
  /// 如果该值也为 null，则默认为 Size(32， 4)。
  final Size? dragHandleSize;

  /// 当用户开始垂直拖动顶部工作表时调用，如果 [enableDrag] 为 true。
  ///
  /// 通常用于更改顶部工作表的动画曲线，以便准确跟踪用户的手指。
  final BottomSheetDragStartHandler? onDragStart;

  /// 如果 [enableDrag] 为 true，则在用户停止拖动顶部工作表时调用。
  ///
  /// 通常用于重置顶部工作表动画曲线，使其以非线性方式进行动画处理。如果顶部工作表正在关闭，
  /// 则在 [onClosing] 之前调用。
  final BottomSheetDragEndHandler? onDragEnd;

  /// 顶部工作表的背景颜色。
  ///
  /// 定义顶部工作表的 [Material.color]。
  ///
  /// 默认为 null 并回退到 [Material] 的默认值。
  final Color? backgroundColor;

  /// 工作表下方阴影的颜色。
  ///
  /// 如果此属性为 null，则使用 [ThemeData.bottomSheetTheme] 的
  /// [BottomSheetThemeData.shadowColor]。如果该值也为 null，则默认值为透明值。
  ///
  /// 另请参阅：
  ///
  ///  * [elevation], 它定义了工作表下方阴影的大小。
  ///  * [shape], 它定义了工作表的形状及其阴影。
  final Color? shadowColor;

  /// 放置此材料相对于其父材质的 z 坐标。
  ///
  /// 这将控制材质下方阴影的大小。
  ///
  /// 默认值为 0。该值为非负数。
  final double? elevation;

  /// 顶部工作表的形状。
  ///
  /// 定义顶部工作表的 [Material.shape]。
  ///
  /// 默认为 null 并回退到 [Material] 的默认值。
  final ShapeBorder? shape;

  /// {@macro flutter.material.Material.clipBehavior}
  ///
  /// 定义顶部工作表的 [Material.clipBehavior]。
  ///
  /// 使用此属性可在顶部工作表具有自定义 [shape]，内容可以延伸到此形状之外。例如带有圆角的顶部工作表和 [图像]返回页首。
  ///
  /// 如果此属性为 null，则 [BottomSheetThemeData.clipBehavior] 的使用
  /// [ThemeData.bottomSheetTheme]。如果为 null，则行为将是 [Clip.none]。
  final Clip? clipBehavior;

  /// 定义 [TopSheet] 的最小和最大尺寸。
  ///
  /// 如果为 null，则环境 [ThemeData.bottomSheetTheme] 的将使用
  /// [BottomSheetThemeData.constraints]。如果那样的话为 null，
  /// [ThemeData.useMaterial3] 为 true，则顶部工作表最大宽度为 640dp。
  /// 如果 [ThemeData.useMaterial3] 为 false，则顶部工作表的大小将受其父项的约束（通常为 [Scaffold]）。
  /// 在这种情况下，请考虑将宽度限制为为大屏幕设置较小的约束。
  ///
  /// 如果指定了约束（在此属性中或theme），顶部工作表将与底部中心对齐可用空间。否则，不会应用任何对齐方式。
  final BoxConstraints? constraints;

  /// 内边距
  final EdgeInsetsGeometry? padding;

  @override
  State<TopSheet> createState() => _TopSheetState();

  /// 创建适用于 [TopSheet.animationController] 的 [AnimationController]。
  ///
  /// 此 API 可方便地制作符合 Material 的顶部工作表动画。如果需要替代动画持续时间，则可以提供不同的动画控制器。
  static AnimationController createAnimationController(TickerProvider vsync) {
    return AnimationController(
      duration: _topSheetEnterDuration,
      reverseDuration: _topSheetExitDuration,
      debugLabel: 'TopSheet',
      vsync: vsync,
    );
  }
}

class _TopSheetState extends State<TopSheet> {
  final GlobalKey _childKey = GlobalKey(debugLabel: 'TopSheet child');

  double get _childHeight {
    final RenderBox renderBox =
        _childKey.currentContext!.findRenderObject()! as RenderBox;
    return renderBox.size.height;
  }

  bool get _dismissUnderway =>
      widget.animationController!.status == AnimationStatus.reverse;

  Set<MaterialState> dragHandleMaterialState = <MaterialState>{};

  void _handleDragStart(DragStartDetails details) {
    setState(() {
      dragHandleMaterialState.add(MaterialState.dragged);
    });
    widget.onDragStart?.call(details);
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    assert(
      (widget.enableDrag || (widget.showDragHandle ?? false)) &&
          widget.animationController != null,
      "'TopSheet.animationController' cannot be null when 'TopSheet.enableDrag'"
      "or 'TopSheet.showDragHandle' is true. "
      "Use 'TopSheet.createAnimationController' to create one, "
      'or provide another AnimationController.',
    );
    if (_dismissUnderway) {
      return;
    }
    widget.animationController!.value -= -details.primaryDelta! / _childHeight;
  }

  void _handleDragEnd(DragEndDetails details) {
    assert(
      (widget.enableDrag || (widget.showDragHandle ?? false)) &&
          widget.animationController != null,
      "'TopSheet.animationController' cannot be null when 'TopSheet.enableDrag'"
      "or 'TopSheet.showDragHandle' is true. "
      "Use 'TopSheet.createAnimationController' to create one, "
      'or provide another AnimationController.',
    );
    if (_dismissUnderway) {
      return;
    }
    setState(() {
      dragHandleMaterialState.remove(MaterialState.dragged);
    });
    bool isClosing = false;
    if (details.velocity.pixelsPerSecond.dy > _minFlingVelocity) {
      final double flingVelocity =
          -details.velocity.pixelsPerSecond.dy / _childHeight;
      if (widget.animationController!.value > 0.0) {
        widget.animationController!.fling(velocity: flingVelocity);
      }
      if (flingVelocity < 0.0) {
        isClosing = true;
      }
    } else if (widget.animationController!.value < _closeProgressThreshold) {
      if (widget.animationController!.value > 0.0) {
        widget.animationController!.fling(velocity: -1.0);
      }
      isClosing = true;
    } else {
      widget.animationController!.forward();
    }

    widget.onDragEnd?.call(
      details,
      isClosing: isClosing,
    );

    if (isClosing) {
      widget.onClosing();
    }
  }

  bool extentChanged(DraggableScrollableNotification notification) {
    if (notification.extent == notification.minExtent &&
        notification.shouldCloseOnMinExtent) {
      widget.onClosing();
    }
    return false;
  }

  void _handleDragHandleHover(bool hovering) {
    if (hovering != dragHandleMaterialState.contains(MaterialState.hovered)) {
      setState(() {
        if (hovering) {
          dragHandleMaterialState.add(MaterialState.hovered);
        } else {
          dragHandleMaterialState.remove(MaterialState.hovered);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final BottomSheetThemeData topSheetTheme =
        TopSheetTheme.of(context).data ?? Theme.of(context).bottomSheetTheme;
    final bool useMaterial3 = Theme.of(context).useMaterial3;
    final BottomSheetThemeData defaults = useMaterial3
        ? _TopSheetDefaultsM3(context)
        : const BottomSheetThemeData();
    final BoxConstraints? constraints =
        widget.constraints ?? topSheetTheme.constraints ?? defaults.constraints;
    final Color? color = widget.backgroundColor ??
        topSheetTheme.backgroundColor ??
        defaults.backgroundColor;
    final Color? surfaceTintColor =
        topSheetTheme.surfaceTintColor ?? defaults.surfaceTintColor;
    final Color? shadowColor =
        widget.shadowColor ?? topSheetTheme.shadowColor ?? defaults.shadowColor;
    final double elevation =
        widget.elevation ?? topSheetTheme.elevation ?? defaults.elevation ?? 0;
    final ShapeBorder? shape =
        widget.shape ?? topSheetTheme.shape ?? defaults.shape;
    final Clip clipBehavior =
        widget.clipBehavior ?? topSheetTheme.clipBehavior ?? Clip.none;
    final bool showDragHandle = widget.showDragHandle ??
        (widget.enableDrag && (topSheetTheme.showDragHandle ?? false));

    Widget? dragHandle;
    if (showDragHandle) {
      dragHandle = _DragHandle(
        onSemanticsTap: widget.onClosing,
        handleHover: _handleDragHandleHover,
        materialState: dragHandleMaterialState,
        dragHandleColor: widget.dragHandleColor,
        dragHandleSize: widget.dragHandleSize,
      );
      // 仅当顶部工作表的其余部分不可拖动时，才将 [_TopSheetGestureDetector] 添加到拖动手柄。
      // 如果整个顶部工作表是可拖动的，则无需添加。
      if (!widget.enableDrag) {
        dragHandle = _TopSheetGestureDetector(
          onVerticalDragStart: _handleDragStart,
          onVerticalDragUpdate: _handleDragUpdate,
          onVerticalDragEnd: _handleDragEnd,
          child: dragHandle,
        );
      }
    }

    Widget sheetContent = !showDragHandle
        ? widget.builder(context)
        : Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              dragHandle!,
              Padding(
                padding: const EdgeInsets.only(
                  bottom: kMinInteractiveDimension,
                ),
                child: widget.builder(context),
              ),
            ],
          );
    if (widget.padding != null) {
      sheetContent = Padding(padding: widget.padding!, child: sheetContent);
    }

    Widget topSheet = Material(
      key: _childKey,
      color: color,
      elevation: elevation,
      surfaceTintColor: surfaceTintColor,
      shadowColor: shadowColor,
      shape: shape,
      clipBehavior: clipBehavior,
      child: NotificationListener<DraggableScrollableNotification>(
        onNotification: extentChanged,
        child: sheetContent,
      ),
    );

    if (constraints != null) {
      topSheet = Align(
        alignment: Alignment.topCenter,
        heightFactor: 1.0,
        child: ConstrainedBox(
          constraints: constraints,
          child: topSheet,
        ),
      );
    }

    return !widget.enableDrag
        ? topSheet
        : _TopSheetGestureDetector(
            onVerticalDragStart: _handleDragStart,
            onVerticalDragUpdate: _handleDragUpdate,
            onVerticalDragEnd: _handleDragEnd,
            child: topSheet,
          );
  }
}

class _DragHandle extends StatelessWidget {
  const _DragHandle({
    required this.onSemanticsTap,
    required this.handleHover,
    required this.materialState,
    this.dragHandleColor,
    this.dragHandleSize,
  });

  final VoidCallback? onSemanticsTap;
  final ValueChanged<bool> handleHover;
  final Set<MaterialState> materialState;
  final Color? dragHandleColor;
  final Size? dragHandleSize;

  @override
  Widget build(BuildContext context) {
    final BottomSheetThemeData topSheetTheme =
        TopSheetTheme.of(context).data ?? Theme.of(context).bottomSheetTheme;
    final BottomSheetThemeData m3Defaults = _TopSheetDefaultsM3(context);
    final Size handleSize = dragHandleSize ??
        topSheetTheme.dragHandleSize ??
        m3Defaults.dragHandleSize!;

    return MouseRegion(
      onEnter: (PointerEnterEvent event) => handleHover(true),
      onExit: (PointerExitEvent event) => handleHover(false),
      child: Semantics(
        label: MaterialLocalizations.of(context).modalBarrierDismissLabel,
        container: true,
        onTap: onSemanticsTap,
        child: SizedBox(
          height: kMinInteractiveDimension,
          width: kMinInteractiveDimension,
          child: Center(
            child: Container(
              height: handleSize.height,
              width: handleSize.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(handleSize.height / 2),
                color: MaterialStateProperty.resolveAs<Color?>(
                      dragHandleColor,
                      materialState,
                    ) ??
                    MaterialStateProperty.resolveAs<Color?>(
                      topSheetTheme.dragHandleColor,
                      materialState,
                    ) ??
                    m3Defaults.dragHandleColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TopSheetGestureDetector extends StatelessWidget {
  const _TopSheetGestureDetector({
    required this.child,
    required this.onVerticalDragStart,
    required this.onVerticalDragUpdate,
    required this.onVerticalDragEnd,
  });

  final Widget child;
  final GestureDragStartCallback onVerticalDragStart;
  final GestureDragUpdateCallback onVerticalDragUpdate;
  final GestureDragEndCallback onVerticalDragEnd;

  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(
      excludeFromSemantics: true,
      gestures: <Type, GestureRecognizerFactory<GestureRecognizer>>{
        VerticalDragGestureRecognizer:
            GestureRecognizerFactoryWithHandlers<VerticalDragGestureRecognizer>(
          () => VerticalDragGestureRecognizer(debugOwner: this),
          (VerticalDragGestureRecognizer instance) {
            instance
              ..onStart = onVerticalDragStart
              ..onUpdate = onVerticalDragUpdate
              ..onEnd = onVerticalDragEnd
              ..onlyAcceptDragOnThreshold = true;
          },
        ),
      },
      child: child,
    );
  }
}

/// 显示模态 Material Design 顶部工作表。
///
/// {@macro flutter.material.ModalTopSheetRoute}
///
/// {@macro flutter.widgets.RawDialogRoute}
///
/// 'context' 参数用于查找顶部工作表的 [Navigator] 和 [Theme]。它仅在调用该方法时使用。
/// 在顶部工作表关闭之前，可以安全地从树上移除其相应的小部件。
///
/// “useRootNavigator”参数确保根导航器在设置为“true”时用于显示 [TopSheet]。
/// 当一个模态 [TopSheet] 需要显示在所有其他内容之上，但调用方位于另一个 [Navigator] 中时，这很有用。
///
/// 返回一个“Future”，该解析为在关闭模态顶部工作表时传递给 [Navigator.pop] 的值（如果有）。
///
/// “barrierLabel”参数可用于设置自定义 barrierLabel。如果未设置，则默认为 context的
/// modalBarrierDismissLabel。
///
/// 另请参阅：
///
///  * [TopSheet], 它成为作为“builder”参数传递给 [showModalTopSheet] 的函数返回的小部件的父级。
///  * [DraggableScrollableSheet], 创建一个底部工作表，该工作表会增长，然后在达到最大尺寸后变得可滚动。
///  * [DisplayFeatureSubScreen], 它记录了 [DisplayFeature] 如何将屏幕拆分为子屏幕的细节。
///  * Material 2 规范位于 <https://m2.material.io/components/sheets-bottom>.
///  * Material 3 规范位于 <https://m3.material.io/components/bottom-sheets/overview>.
Future<T?> showModalTopSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  Color? backgroundColor,
  String? barrierLabel,
  double? elevation,
  ShapeBorder? shape,
  Clip? clipBehavior,
  BoxConstraints? constraints,
  Color? barrierColor,
  bool isScrollControlled = false,
  double scrollControlDisabledMaxHeightRatio =
      _defaultScrollControlDisabledMaxHeightRatio,
  bool useRootNavigator = false,
  bool isDismissible = true,
  bool enableDrag = true,
  bool? showDragHandle,
  bool useSafeArea = true,
  RouteSettings? routeSettings,
  AnimationController? transitionAnimationController,
  Offset? anchorPoint,
}) {
  assert(debugCheckHasMediaQuery(context));
  assert(debugCheckHasMaterialLocalizations(context));

  final NavigatorState navigator =
      Navigator.of(context, rootNavigator: useRootNavigator);
  final MaterialLocalizations localizations = MaterialLocalizations.of(context);
  return navigator.push(
    ModalTopSheetRoute<T>(
      builder: builder,
      capturedThemes:
          InheritedTheme.capture(from: context, to: navigator.context),
      isScrollControlled: isScrollControlled,
      scrollControlDisabledMaxHeightRatio: scrollControlDisabledMaxHeightRatio,
      barrierLabel: barrierLabel ?? localizations.scrimLabel,
      barrierOnTapHint:
          localizations.scrimOnTapHint(localizations.bottomSheetLabel),
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape,
      clipBehavior: clipBehavior,
      constraints: constraints,
      isDismissible: isDismissible,
      modalBarrierColor: barrierColor ??
          TopSheetTheme.of(context).data?.modalBarrierColor ??
          Theme.of(context).bottomSheetTheme.modalBarrierColor,
      enableDrag: enableDrag,
      showDragHandle: showDragHandle,
      settings: routeSettings,
      transitionAnimationController: transitionAnimationController,
      anchorPoint: anchorPoint,
      useSafeArea: useSafeArea,
    ),
  );
}

class _TopSheetDefaultsM3 extends BottomSheetThemeData {
  _TopSheetDefaultsM3(this.context)
      : super(
          elevation: 1.0,
          modalElevation: 1.0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(16.0)),
          ),
          constraints: const BoxConstraints(maxWidth: 640),
        );

  final BuildContext context;
  late final ColorScheme _colors = Theme.of(context).colorScheme;

  @override
  Color? get backgroundColor => _colors.surface;

  @override
  Color? get surfaceTintColor => _colors.surfaceTint;

  @override
  Color? get shadowColor => Colors.transparent;

  @override
  Color? get dragHandleColor => _colors.onSurfaceVariant.withOpacity(0.4);

  @override
  Size? get dragHandleSize => const Size(32, 4);

  @override
  BoxConstraints? get constraints => const BoxConstraints(maxWidth: 640.0);
}
