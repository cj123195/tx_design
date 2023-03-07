import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';

export 'package:easy_refresh/easy_refresh.dart';

/// 列表刷新组件
class TxRefreshListView extends EasyRefresh {
  const TxRefreshListView({
    required super.child,
    super.key,
    super.controller,
    super.header,
    super.footer,
    super.onRefresh,
    super.onLoad,
    super.spring,
    super.frictionFactor,
    super.notRefreshHeader,
    super.notLoadFooter,
    super.simultaneously = false,
    super.noMoreRefresh = false,
    super.noMoreLoad = false,
    super.resetAfterRefresh = true,
    super.refreshOnStart = false,
    super.refreshOnStartHeader,
    super.callRefreshOverOffset = 20,
    super.callLoadOverOffset = 20,
    super.fit = StackFit.loose,
    super.clipBehavior = Clip.hardEdge,
    super.scrollBehaviorBuilder,
    super.scrollController,
  });

  TxRefreshListView.builder({
    required int itemCount,
    required NullableIndexedWidgetBuilder itemBuilder,
    EdgeInsetsGeometry? padding,
    super.key,
    super.controller,
    super.header,
    super.footer,
    super.onRefresh,
    super.onLoad,
    super.spring,
    super.frictionFactor,
    super.notRefreshHeader,
    super.notLoadFooter,
    super.simultaneously = false,
    super.noMoreRefresh = false,
    super.noMoreLoad = false,
    super.resetAfterRefresh = true,
    super.refreshOnStart = false,
    super.refreshOnStartHeader,
    super.callRefreshOverOffset = 20,
    super.callLoadOverOffset = 20,
    super.fit = StackFit.loose,
    super.clipBehavior = Clip.hardEdge,
    super.scrollBehaviorBuilder,
    super.scrollController,
  }) : super(
          child: ListView.builder(
            itemBuilder: itemBuilder,
            itemCount: itemCount,
            padding: padding,
          ),
        );

  TxRefreshListView.separated({
    required int itemCount,
    required NullableIndexedWidgetBuilder itemBuilder,
    IndexedWidgetBuilder? separatorBuilder,
    EdgeInsetsGeometry? padding,
    super.key,
    super.controller,
    super.header,
    super.footer,
    super.onRefresh,
    super.onLoad,
    super.spring,
    super.frictionFactor,
    super.notRefreshHeader,
    super.notLoadFooter,
    super.simultaneously = false,
    super.noMoreRefresh = false,
    super.noMoreLoad = false,
    super.resetAfterRefresh = true,
    super.refreshOnStart = false,
    super.refreshOnStartHeader,
    super.callRefreshOverOffset = 20,
    super.callLoadOverOffset = 20,
    super.fit = StackFit.loose,
    super.clipBehavior = Clip.hardEdge,
    super.scrollBehaviorBuilder,
    super.scrollController,
  }) : super(
            child: ListView.separated(
          itemBuilder: itemBuilder,
          itemCount: itemCount,
          padding: padding,
          separatorBuilder:
              separatorBuilder ?? (context, index) => const SizedBox(height: 8),
        ));
}
