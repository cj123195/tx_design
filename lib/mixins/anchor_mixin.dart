import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

mixin AnchorScrollMixin<T extends StatefulWidget> on State<T> {
  /// 锚点组件[Key]列表
  late List<GlobalKey> anchorKeys;

  /// 当使用SliverAppBar时需设置此值为[SliverAppBar.expandedHeight]
  double get expandedHeight => 0.0;

  /// 当使用SliverAppBar时需设置此值为[SliverAppBar.collapsedHeight]
  double get collapsedHeight => 0.0;

  /// 触发距离
  double get offset => 50;

  /// 滚动控制器
  final ScrollController scrollController = ScrollController();

  /// 根据滚动位置计算当前Index
  int computeCurrentIndex() {
    int i = 0;
    for (; i < anchorKeys.length; i++) {
      final keyRenderObject = anchorKeys[i]
          .currentContext
          ?.findAncestorRenderObjectOfType<RenderSliverToBoxAdapter>();
      if (keyRenderObject != null) {
        final offsetY = (keyRenderObject.parentData as SliverPhysicalParentData)
            .paintOffset
            .dy;
        if (offsetY > kToolbarHeight + offset) {
          break;
        }
      }
    }
    return i;
  }

  void scrollListener();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(scrollListener);
  }

  @override
  void dispose() {
    scrollController.removeListener(scrollListener);
    super.dispose();
  }
}

mixin AnchorTabMixin<T extends StatefulWidget>
    on AnchorScrollMixin<T>, SingleTickerProviderStateMixin<T> {
  late final TabController tabController;

  /// 当前是否点击Tab
  bool isTabClicked = false;

  @override
  void scrollListener() {
    if (isTabClicked) {
      return;
    }

    final int index = computeCurrentIndex();

    final newIndex = index == 0 ? 0 : index - 1;
    if (newIndex != tabController.index) {
      tabController.animateTo(newIndex);
    }
  }

  void onTabChange(int index) {
    final keyRenderObject = anchorKeys[index]
        .currentContext
        ?.findAncestorRenderObjectOfType<RenderSliverToBoxAdapter>();
    if (keyRenderObject != null) {
      // 点击的时候不让滚动影响tab
      isTabClicked = true;
      scrollController.position
          .ensureVisible(
        keyRenderObject,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      )
          .then((value) {
        isTabClicked = false;
      });
    }
  }

  @override
  void initState() {
    tabController = TabController(length: anchorKeys.length, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}
