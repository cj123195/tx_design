import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:value_layout_builder/value_layout_builder.dart';

/// 吸顶Sliver组件
///
/// 原插件：flutter_sticky_header，由于原插件配置无法完全适应业务，所以拷贝源码加以改造
///
/// [TxSliverStickyHeader.builder] 用于在粘性标头状态更改时构建标头的签名。
typedef SliverStickyHeaderWidgetBuilder = Widget Function(
  BuildContext context,
  SliverStickyHeaderState state,
);

class StickyHeaderController extends ChangeNotifier {
  /// 为了跳转到当前粘性标题的第一项而使用的偏移量。
  ///
  /// 如果没有粘性标头，则为 0。
  double get stickyHeaderScrollOffset => _stickyHeaderScrollOffset;
  double _stickyHeaderScrollOffset = 0;

  /// 此 setter 只能由 flutter_sticky_header 包使用。
  set stickyHeaderScrollOffset(double value) {
    if (_stickyHeaderScrollOffset != value) {
      _stickyHeaderScrollOffset = value;
      notifyListeners();
    }
  }
}

/// [StickyHeaderController] 用于未明确指定的后代小部件。.
///
/// [DefaultStickyHeaderController] 是一个继承的小部件，用于与 [TxSliverStickyHeader]
/// 共享一个 [StickyHeaderController]。 当共享显式创建的 [StickyHeaderController]
/// 不方便时使用它，因为粘性标头是由无状态父小部件或不同父小部件创建的。
class DefaultStickyHeaderController extends StatefulWidget {
  const DefaultStickyHeaderController({required this.child, super.key});

  /// 树中此小部件下方的小部件。
  ///
  /// 通常是一个 [Scaffold]，其 [AppBar] 包含一个 [TabBar]。
  final Widget child;

  /// 包含给定上下文的此类的最近实例。
  ///
  /// 典型用法：
  /// ```dart
  /// StickyHeaderController controller =
  ///   DefaultStickyHeaderController.of(context);
  /// ```
  static StickyHeaderController? of(BuildContext context) {
    final _StickyHeaderControllerScope? scope = context
        .dependOnInheritedWidgetOfExactType<_StickyHeaderControllerScope>();
    return scope?.controller;
  }

  @override
  State<DefaultStickyHeaderController> createState() =>
      _DefaultStickyHeaderControllerState();
}

class _DefaultStickyHeaderControllerState
    extends State<DefaultStickyHeaderController> {
  StickyHeaderController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = StickyHeaderController();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _StickyHeaderControllerScope(
      controller: _controller,
      child: widget.child,
    );
  }
}

class _StickyHeaderControllerScope extends InheritedWidget {
  const _StickyHeaderControllerScope({required super.child, this.controller});

  final StickyHeaderController? controller;

  @override
  bool updateShouldNotify(_StickyHeaderControllerScope old) {
    return controller != old.controller;
  }
}

/// 描述如何呈现粘性标头的状态。
@immutable
class SliverStickyHeaderState {
  const SliverStickyHeaderState(
    this.scrollPercentage,
    this.isPinned,
  );

  final double scrollPercentage;

  final bool isPinned;

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! SliverStickyHeaderState) {
      return false;
    }
    final SliverStickyHeaderState typedOther = other;
    return scrollPercentage == typedOther.scrollPercentage &&
        isPinned == typedOther.isPinned;
  }

  @override
  int get hashCode {
    return Object.hash(scrollPercentage, isPinned);
  }
}

/// 在它的sliver之前显示标题的sliver。 只有当sliver滚动时，标题才会滚出视口。
///
/// 将此小部件放在 [CustomScrollView] 或类似的内部。
class TxSliverStickyHeader extends RenderObjectWidget {
  /// 创建一个在 [sliver] 之前显示 [header] 的 sliver，除非 [overlapsContent] 为真。
  /// 当 [header] 到达视口的起点时，它会保持固定状态，直到 [sliver] 滚出视口。
  ///
  /// [overlapsContent] 和 [sticky] 参数不能为空。
  ///
  /// 如果未提供 [StickyHeaderController]，则将使用 [DefaultStickyHeaderController.of] 的值。
  const TxSliverStickyHeader({
    Key? key,
    this.header,
    this.sliver,
    this.overlapsContent = false,
    this.sticky = true,
    this.controller,
    this.pinnedOffset = 0.0,
  }) : super(key: key);

  /// 创建一个小部件，每次滚动百分比发生变化时，该小部件都会构建 [TxSliverStickyHeader] 的标题。
  ///
  /// [builder]、[overlapsContent] 和 [sticky] 参数不能为空。
  ///
  /// 如果未提供 [StickyHeaderController]，则将使用 [DefaultStickyHeaderController.of] 的值。
  TxSliverStickyHeader.builder({
    required SliverStickyHeaderWidgetBuilder builder,
    Key? key,
    Widget? sliver,
    bool overlapsContent = false,
    bool sticky = true,
    StickyHeaderController? controller,
    double pinnedOffset = 0.0,
  }) : this(
          key: key,
          header: ValueLayoutBuilder<SliverStickyHeaderState>(
            builder: (context, constraints) =>
                builder(context, constraints.value),
          ),
          sliver: sliver,
          overlapsContent: overlapsContent,
          sticky: sticky,
          controller: controller,
          pinnedOffset: pinnedOffset,
        );

  /// 在sliver之前显示的标题。
  final Widget? header;

  /// 在页眉之后显示的sliver。
  final Widget? sliver;

  /// 标题是否应该绘制在sliver的顶部而不是之前。
  final bool overlapsContent;

  /// 是否贴表头。
  ///
  /// 默认为true.
  final bool sticky;

  /// 吸顶偏移量
  /// 用来决定header何时吸顶，例如[pinnedOffset]为0时则在header到达父容器顶端时立刻吸顶
  /// 默认为0
  final double pinnedOffset;

  /// 用于与此sliver交互的控制器。
  ///
  /// 如果未提供 [StickyHeaderController]，则将使用 [DefaultStickyHeaderController.of] 的值。
  final StickyHeaderController? controller;

  @override
  RenderSliverStickyHeader createRenderObject(BuildContext context) {
    return RenderSliverStickyHeader(
      overlapsContent: overlapsContent,
      sticky: sticky,
      controller: controller ?? DefaultStickyHeaderController.of(context),
      pinnedOffset: pinnedOffset,
    );
  }

  @override
  TxSliverStickyHeaderRenderObjectElement createElement() =>
      TxSliverStickyHeaderRenderObjectElement(this);

  @override
  void updateRenderObject(
    BuildContext context,
    RenderSliverStickyHeader renderObject,
  ) {
    renderObject
      ..overlapsContent = overlapsContent
      ..sticky = sticky
      ..pinnedOffset = pinnedOffset
      ..controller = controller ?? DefaultStickyHeaderController.of(context);
  }
}

class TxSliverStickyHeaderRenderObjectElement extends RenderObjectElement {
  /// 创建一个使用给定小部件作为其配置的元素。
  TxSliverStickyHeaderRenderObjectElement(TxSliverStickyHeader widget)
      : super(widget);

  @override
  TxSliverStickyHeader get widget => super.widget as TxSliverStickyHeader;

  Element? _header;

  Element? _sliver;

  @override
  void visitChildren(ElementVisitor visitor) {
    if (_header != null) {
      visitor(_header!);
    }
    if (_sliver != null) {
      visitor(_sliver!);
    }
  }

  @override
  void forgetChild(Element child) {
    super.forgetChild(child);
    if (child == _header) {
      _header = null;
    }
    if (child == _sliver) {
      _sliver = null;
    }
  }

  @override
  void mount(Element? parent, dynamic newSlot) {
    super.mount(parent, newSlot);
    _header = updateChild(_header, widget.header, 0);
    _sliver = updateChild(_sliver, widget.sliver, 1);
  }

  @override
  void update(TxSliverStickyHeader newWidget) {
    super.update(newWidget);
    assert(widget == newWidget);
    _header = updateChild(_header, widget.header, 0);
    _sliver = updateChild(_sliver, widget.sliver, 1);
  }

  @override
  void insertRenderObjectChild(RenderObject child, int? slot) {
    final RenderSliverStickyHeader renderObject =
        this.renderObject as RenderSliverStickyHeader;
    if (slot == 0) {
      renderObject.header = child as RenderBox?;
    }
    if (slot == 1) {
      renderObject.child = child as RenderSliver?;
    }
    assert(renderObject == this.renderObject);
  }

  @override
  void moveRenderObjectChild(RenderObject child, oldSlot, newSlot) {
    assert(false);
  }

  @override
  void removeRenderObjectChild(RenderObject child, slot) {
    final RenderSliverStickyHeader renderObject =
        this.renderObject as RenderSliverStickyHeader;
    if (renderObject.header == child) {
      renderObject.header = null;
    }
    if (renderObject.child == child) {
      renderObject.child = null;
    }
    assert(renderObject == this.renderObject);
  }
}

/// 以 [RenderBox] 作为标头和 [RenderSliver] 作为子项的sliver。
///
/// 当 [header] 到达视口的开头时，它会保持固定状态，直到 [child] 滚动出视口。
class RenderSliverStickyHeader extends RenderSliver with RenderSliverHelpers {
  RenderSliverStickyHeader({
    RenderObject? header,
    RenderSliver? child,
    bool overlapsContent = false,
    bool sticky = true,
    StickyHeaderController? controller,
    double pinnedOffset = 0.0,
  })  : _overlapsContent = overlapsContent,
        _sticky = sticky,
        _pinnedOffset = pinnedOffset,
        _controller = controller {
    this.header = header as RenderBox?;
    this.child = child;
  }

  SliverStickyHeaderState? _oldState;
  double? _headerExtent;
  late bool _isPinned;

  double get pinnedOffset => _pinnedOffset;
  double _pinnedOffset;

  set pinnedOffset(double value) {
    if (_pinnedOffset == value) {
      return;
    }
    _pinnedOffset = value;
    markNeedsLayout();
  }

  bool get overlapsContent => _overlapsContent;
  bool _overlapsContent;

  set overlapsContent(bool value) {
    if (_overlapsContent == value) {
      return;
    }
    _overlapsContent = value;
    markNeedsLayout();
  }

  bool get sticky => _sticky;
  bool _sticky;

  set sticky(bool value) {
    if (_sticky == value) {
      return;
    }
    _sticky = value;
    markNeedsLayout();
  }

  StickyHeaderController? get controller => _controller;
  StickyHeaderController? _controller;

  set controller(StickyHeaderController? value) {
    if (_controller == value) {
      return;
    }
    if (_controller != null && value != null) {
      // 我们复制旧控制器的状态。
      value.stickyHeaderScrollOffset = _controller!.stickyHeaderScrollOffset;
    }
    _controller = value;
  }

  /// 渲染对象的标题
  RenderBox? get header => _header;
  RenderBox? _header;

  set header(RenderBox? value) {
    if (_header != null) {
      dropChild(_header!);
    }
    _header = value;
    if (_header != null) {
      adoptChild(_header!);
    }
  }

  /// 渲染对象的唯一子对象
  RenderSliver? get child => _child;
  RenderSliver? _child;

  set child(RenderSliver? value) {
    if (_child != null) {
      dropChild(_child!);
    }
    _child = value;
    if (_child != null) {
      adoptChild(_child!);
    }
  }

  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! SliverPhysicalParentData) {
      child.parentData = SliverPhysicalParentData();
    }
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    if (_header != null) {
      _header!.attach(owner);
    }
    if (_child != null) {
      _child!.attach(owner);
    }
  }

  @override
  void detach() {
    super.detach();
    if (_header != null) {
      _header!.detach();
    }
    if (_child != null) {
      _child!.detach();
    }
  }

  @override
  void redepthChildren() {
    if (_header != null) {
      redepthChild(_header!);
    }
    if (_child != null) {
      redepthChild(_child!);
    }
  }

  @override
  void visitChildren(RenderObjectVisitor visitor) {
    if (_header != null) {
      visitor(_header!);
    }
    if (_child != null) {
      visitor(_child!);
    }
  }

  @override
  List<DiagnosticsNode> debugDescribeChildren() {
    final List<DiagnosticsNode> result = <DiagnosticsNode>[];
    if (header != null) {
      result.add(header!.toDiagnosticsNode(name: 'header'));
    }
    if (child != null) {
      result.add(child!.toDiagnosticsNode(name: 'child'));
    }
    return result;
  }

  double computeHeaderExtent() {
    if (header == null) {
      return 0.0;
    }
    assert(header!.hasSize);
    switch (constraints.axis) {
      case Axis.vertical:
        return header!.size.height;
      case Axis.horizontal:
        return header!.size.width;
    }
  }

  double? get headerLogicalExtent => overlapsContent ? 0.0 : _headerExtent;

  @override
  void performLayout() {
    if (header == null && child == null) {
      geometry = SliverGeometry.zero;
      return;
    }

    // One of them is not null.
    final AxisDirection axisDirection = applyGrowthDirectionToAxisDirection(
        constraints.axisDirection, constraints.growthDirection);

    if (header != null) {
      header!.layout(
        BoxValueConstraints<SliverStickyHeaderState>(
          value: _oldState ?? const SliverStickyHeaderState(0.0, false),
          constraints: constraints.asBoxConstraints(),
        ),
        parentUsesSize: true,
      );
      _headerExtent = computeHeaderExtent();
    }

    // Compute the header extent only one time.
    final double headerExtent = headerLogicalExtent!;
    final double headerPaintExtent =
        calculatePaintOffset(constraints, from: 0.0, to: headerExtent);
    final double headerCacheExtent =
        calculateCacheOffset(constraints, from: 0.0, to: headerExtent);

    if (child == null) {
      geometry = SliverGeometry(
          scrollExtent: headerExtent,
          maxPaintExtent: headerExtent,
          paintExtent: headerPaintExtent,
          cacheExtent: headerCacheExtent,
          hitTestExtent: headerPaintExtent,
          hasVisualOverflow: headerExtent > constraints.remainingPaintExtent ||
              constraints.scrollOffset > 0.0);
    } else {
      child!.layout(
        constraints.copyWith(
          scrollOffset: math.max(0.0, constraints.scrollOffset - headerExtent),
          cacheOrigin: math.min(0.0, constraints.cacheOrigin + headerExtent),
          overlap: math.min(headerExtent, constraints.scrollOffset) +
              (sticky ? constraints.overlap : 0),
          remainingPaintExtent:
              constraints.remainingPaintExtent - headerPaintExtent,
          remainingCacheExtent:
              constraints.remainingCacheExtent - headerCacheExtent,
        ),
        parentUsesSize: true,
      );
      final SliverGeometry childLayoutGeometry = child!.geometry!;
      if (childLayoutGeometry.scrollOffsetCorrection != null) {
        geometry = SliverGeometry(
          scrollOffsetCorrection: childLayoutGeometry.scrollOffsetCorrection,
        );
        return;
      }

      final double paintExtent = math.min(
        headerPaintExtent +
            math.max(childLayoutGeometry.paintExtent,
                childLayoutGeometry.layoutExtent),
        constraints.remainingPaintExtent,
      );

      geometry = SliverGeometry(
        scrollExtent: headerExtent + childLayoutGeometry.scrollExtent,
        maxScrollObstructionExtent: sticky ? headerPaintExtent : 0,
        paintExtent: paintExtent,
        layoutExtent: math.min(
            headerPaintExtent + childLayoutGeometry.layoutExtent, paintExtent),
        cacheExtent: math.min(
            headerCacheExtent + childLayoutGeometry.cacheExtent,
            constraints.remainingCacheExtent),
        maxPaintExtent: headerExtent + childLayoutGeometry.maxPaintExtent,
        hitTestExtent: math.max(
            headerPaintExtent + childLayoutGeometry.paintExtent,
            headerPaintExtent + childLayoutGeometry.hitTestExtent),
        hasVisualOverflow: childLayoutGeometry.hasVisualOverflow,
      );

      final SliverPhysicalParentData? childParentData =
          child!.parentData as SliverPhysicalParentData?;
      switch (axisDirection) {
        case AxisDirection.up:
          childParentData!.paintOffset = Offset.zero;
          break;
        case AxisDirection.right:
          childParentData!.paintOffset = Offset(
              calculatePaintOffset(constraints, from: 0.0, to: headerExtent),
              0.0);
          break;
        case AxisDirection.down:
          childParentData!.paintOffset = Offset(0.0,
              calculatePaintOffset(constraints, from: 0.0, to: headerExtent));
          break;
        case AxisDirection.left:
          childParentData!.paintOffset = Offset.zero;
          break;
      }
    }

    if (header != null) {
      final SliverPhysicalParentData? headerParentData =
          header!.parentData as SliverPhysicalParentData?;
      final double childScrollExtent = child?.geometry?.scrollExtent ?? 0.0;

      _isPinned = sticky &&
          ((constraints.scrollOffset + constraints.overlap) > pinnedOffset ||
              constraints.remainingPaintExtent - pinnedOffset ==
                  constraints.viewportMainAxisExtent);

      final double headerPosition = (sticky && _isPinned)
          ? math.min(
              constraints.overlap,
              childScrollExtent -
                  constraints.scrollOffset -
                  (overlapsContent ? _headerExtent! : 0.0))
          : -constraints.scrollOffset;

      final double headerScrollRatio =
          (headerPosition - constraints.overlap).abs() / _headerExtent!;
      if (_isPinned && headerScrollRatio <= 1) {
        controller?.stickyHeaderScrollOffset =
            constraints.precedingScrollExtent;
      }
      // second layout if scroll percentage changed and header is a
      // RenderStickyHeaderLayoutBuilder.
      if (header is RenderConstrainedLayoutBuilder<
          BoxValueConstraints<SliverStickyHeaderState>, RenderBox>) {
        final double headerScrollRatioClamped =
            headerScrollRatio.clamp(0.0, 1.0);

        final SliverStickyHeaderState state =
            SliverStickyHeaderState(headerScrollRatioClamped, _isPinned);
        if (_oldState != state) {
          _oldState = state;
          header!.layout(
            BoxValueConstraints<SliverStickyHeaderState>(
              value: _oldState!,
              constraints: constraints.asBoxConstraints(),
            ),
            parentUsesSize: true,
          );
        }
      }

      switch (axisDirection) {
        case AxisDirection.up:
          headerParentData!.paintOffset = Offset(
              0.0, geometry!.paintExtent - headerPosition - _headerExtent!);
          break;
        case AxisDirection.down:
          headerParentData!.paintOffset = Offset(0.0, headerPosition);
          break;
        case AxisDirection.left:
          headerParentData!.paintOffset = Offset(
            geometry!.paintExtent - headerPosition - _headerExtent!,
            0.0,
          );
          break;
        case AxisDirection.right:
          headerParentData!.paintOffset = Offset(headerPosition, 0.0);
          break;
      }
    }
  }

  @override
  bool hitTestChildren(SliverHitTestResult result,
      {required double mainAxisPosition, required double crossAxisPosition}) {
    assert(geometry!.hitTestExtent > 0.0);
    final double childScrollExtent = child?.geometry?.scrollExtent ?? 0.0;
    final double headerPosition = sticky
        ? math.min(
            constraints.overlap,
            childScrollExtent -
                constraints.scrollOffset -
                (overlapsContent ? _headerExtent! : 0.0))
        : -constraints.scrollOffset;

    if (header != null &&
        (mainAxisPosition - headerPosition) <= _headerExtent!) {
      final didHitHeader = hitTestBoxChild(
        BoxHitTestResult.wrap(SliverHitTestResult.wrap(result)),
        header!,
        mainAxisPosition: mainAxisPosition - childMainAxisPosition(header),
        crossAxisPosition: crossAxisPosition,
      );

      return didHitHeader ||
          (_overlapsContent &&
              child != null &&
              child!.geometry!.hitTestExtent > 0.0 &&
              child!.hitTest(result,
                  mainAxisPosition:
                      mainAxisPosition - childMainAxisPosition(child),
                  crossAxisPosition: crossAxisPosition));
    } else if (child != null && child!.geometry!.hitTestExtent > 0.0) {
      return child!.hitTest(result,
          mainAxisPosition: mainAxisPosition - childMainAxisPosition(child),
          crossAxisPosition: crossAxisPosition);
    }
    return false;
  }

  @override
  double childMainAxisPosition(RenderObject? child) {
    if (child == header) {
      return _isPinned
          ? 0.0
          : -(constraints.scrollOffset + constraints.overlap);
    }
    if (child == this.child) {
      return calculatePaintOffset(constraints,
          from: 0.0, to: headerLogicalExtent!);
    }
    return 0;
  }

  @override
  double? childScrollOffset(RenderObject child) {
    assert(child.parent == this);
    if (child == this.child) {
      return _headerExtent;
    } else {
      return super.childScrollOffset(child);
    }
  }

  @override
  void applyPaintTransform(RenderObject child, Matrix4 transform) {
    final SliverPhysicalParentData childParentData =
        child.parentData as SliverPhysicalParentData;
    childParentData.applyPaintTransform(transform);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (geometry!.visible) {
      if (child != null && child!.geometry!.visible) {
        final SliverPhysicalParentData childParentData =
            child!.parentData as SliverPhysicalParentData;
        context.paintChild(child!, offset + childParentData.paintOffset);
      }

      // The header must be drawn over the sliver.
      if (header != null) {
        final SliverPhysicalParentData headerParentData =
            header!.parentData as SliverPhysicalParentData;
        context.paintChild(header!, offset + headerParentData.paintOffset);
      }
    }
  }
}
