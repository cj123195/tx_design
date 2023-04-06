import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';

export 'package:easy_refresh/easy_refresh.dart';

const Header _defaultHeader = ClassicHeader(
  dragText: '下拉刷新',
  armedText: '松开刷新',
  readyText: '正在刷新',
  processingText: '正在刷新',
  processedText: '刷新完成',
  noMoreText: '没有更多啦',
  failedText: '刷新失败',
  messageText: '上次更新时间 %T',
);
const Footer _defaultFooter = ClassicFooter(
  dragText: '上拉加载',
  armedText: '松开加载',
  readyText: '正在加载',
  processingText: '正在加载',
  processedText: '加载完成',
  noMoreText: '没有更多啦',
  failedText: '加载失败',
  messageText: '上次更新时间 %T',
);

/// 列表刷新组件
class TxRefreshView extends EasyRefresh {
  const TxRefreshView({
    required super.child,
    super.key,
    super.controller,
    super.header = _defaultHeader,
    super.footer = _defaultFooter,
    super.onRefresh,
    super.onLoad,
    super.spring,
    super.frictionFactor,
    super.notRefreshHeader,
    super.notLoadFooter,
    super.simultaneously,
    super.noMoreRefresh = true,
    super.noMoreLoad,
    super.resetAfterRefresh,
    super.refreshOnStart = true,
    super.refreshOnStartHeader,
    super.callRefreshOverOffset,
    super.callLoadOverOffset,
    super.fit,
    super.clipBehavior,
    super.scrollBehaviorBuilder,
    super.scrollController,
  });

  const TxRefreshView.builder({
    required ERChildBuilder? childBuilder,
    EdgeInsetsGeometry? padding,
    super.key,
    super.controller,
    super.header = _defaultHeader,
    super.footer = _defaultFooter,
    super.onRefresh,
    super.onLoad,
    super.spring,
    super.frictionFactor,
    super.notRefreshHeader,
    super.notLoadFooter,
    super.simultaneously,
    super.noMoreRefresh = true,
    super.noMoreLoad,
    super.resetAfterRefresh,
    super.refreshOnStart = true,
    super.refreshOnStartHeader,
    super.callRefreshOverOffset,
    super.callLoadOverOffset,
    super.fit,
    super.clipBehavior,
    super.scrollBehaviorBuilder,
    super.scrollController,
  }) : super.builder(childBuilder: childBuilder);
}
