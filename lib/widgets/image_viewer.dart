import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

export 'package:photo_view/photo_view_gallery.dart'
    show PhotoViewGalleryPageOptions;

/// 一个查看图片的小部件
class TxImageViewer extends StatelessWidget {
  /// 创建一个图片查看器
  ///
  /// [image]不能为空
  const TxImageViewer(
    this.image, {
    super.key,
    this.tag,
  });

  /// 通过asset路径创建一个图片查看器
  ///
  /// [path] 不能为空
  TxImageViewer.asset(
    String path, {
    super.key,
    this.tag,
  }) : image = AssetImage(path);

  /// 通过网络地址路径创建一个图片查看器
  ///
  /// [path] 不能为空
  TxImageViewer.network(
    String path, {
    super.key,
    this.tag,
  }) : image = NetworkImage(path);

  /// 通过文件创建一个图片查看器
  ///
  /// [file] 不能为空
  TxImageViewer.file(
    File file, {
    super.key,
    this.tag,
  }) : image = FileImage(file);

  factory TxImageViewer.unknown(String path, {String? tag}) {
    if (path.startsWith('http') || path.startsWith('https')) {
      return TxImageViewer.network(path, tag: tag);
    } else if (path.startsWith('assets')) {
      return TxImageViewer.asset(path, tag: tag);
    } else {
      return TxImageViewer.file(File(path), tag: tag);
    }
  }

  /// 标签
  ///
  /// 主要用于创建Hero动画
  final String? tag;

  /// 图片
  final ImageProvider image;

  @override
  Widget build(BuildContext context) {
    Widget child = PhotoView(
      imageProvider: image,
      loadingBuilder: (context, event) {
        return Center(
          child: CircularProgressIndicator(
            value: (event == null || event.expectedTotalBytes == null)
                ? null
                : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
            color: Colors.white70,
          ),
        );
      },
      errorBuilder: (context, event, track) {
        return const Icon(
          Icons.broken_image_outlined,
          color: Colors.grey,
        );
      },
    );
    if (tag != null) {
      child = Hero(tag: tag!, child: child);
    }

    return Material(color: Colors.black87, child: SafeArea(child: child));
  }
}

typedef ImageGalleryIndicatorBuilder = Widget Function(
    BuildContext context, PageController controller);

/// 一个查看多张图片的小部件
class TxImageGalleryViewer extends StatefulWidget {
  /// 创建一个图片查看器
  ///
  /// [pageOptions] 不能为空
  const TxImageGalleryViewer({
    required this.pageOptions,
    super.key,
    this.loadingBuilder,
    this.backgroundDecoration,
    this.wantKeepAlive = false,
    this.gaplessPlayback = false,
    this.reverse = false,
    this.pageController,
    this.onPageChanged,
    this.scaleStateChangedCallback,
    this.enableRotation = false,
    this.scrollPhysics,
    this.scrollDirection = Axis.horizontal,
    this.customSize,
    this.allowImplicitScrolling = false,
    this.initialIndex,
    this.titleBuilder,
    this.indicatorBuilder,
  })  : itemCount = null,
        builder = null;

  /// 创建一个自定义每一项的图片库查看器
  ///
  /// [itemCount]、[builder]不能为空
  /// 构建器必须返回一个[PhotoViewGalleryPageOptions]。
  const TxImageGalleryViewer.builder({
    required this.itemCount,
    required this.builder,
    super.key,
    this.loadingBuilder,
    this.backgroundDecoration,
    this.wantKeepAlive = false,
    this.gaplessPlayback = false,
    this.reverse = false,
    this.onPageChanged,
    this.scaleStateChangedCallback,
    this.enableRotation = false,
    this.scrollPhysics,
    this.scrollDirection = Axis.horizontal,
    this.customSize,
    this.allowImplicitScrolling = false,
    this.initialIndex,
    this.pageController,
    this.titleBuilder,
    this.indicatorBuilder,
  })  : pageOptions = null,
        assert(itemCount != null),
        assert(builder != null);

  /// 参考[PhotoViewGallery.pageOptions]
  final List<PhotoViewGalleryPageOptions>? pageOptions;

  /// 参考[PhotoViewGallery.itemCount]
  final int? itemCount;

  /// 参考[PhotoViewGallery.builder]
  final PhotoViewGalleryBuilder? builder;

  /// 参考[PhotoViewGallery.scrollPhysics]
  final ScrollPhysics? scrollPhysics;

  /// 参考[PhotoViewGallery.loadingBuilder]
  final LoadingBuilder? loadingBuilder;

  /// 参考[PhotoViewGallery.backgroundDecoration]
  final BoxDecoration? backgroundDecoration;

  /// 参考[PhotoViewGallery.wantKeepAlive]
  final bool wantKeepAlive;

  /// 参考[PhotoViewGallery.gaplessPlayback]
  final bool gaplessPlayback;

  /// 参考[PhotoViewGallery.reverse]
  final bool reverse;

  /// 参考[PhotoViewGallery.pageController]
  final PageController? pageController;

  /// 参考[PhotoViewGallery.onPageChanged]
  final PhotoViewGalleryPageChangedCallback? onPageChanged;

  /// 参考[PhotoViewGallery.scaleStateChangedCallback]
  final ValueChanged<PhotoViewScaleState>? scaleStateChangedCallback;

  /// 参考[PhotoViewGallery.enableRotation]
  final bool enableRotation;

  /// 参考[PhotoViewGallery.customSize]
  final Size? customSize;

  /// 参考[PhotoViewGallery.scrollDirection]
  final Axis scrollDirection;

  /// 参考[PhotoViewGallery.allowImplicitScrolling]
  final bool allowImplicitScrolling;

  /// 标题
  final ImageGalleryIndicatorBuilder? titleBuilder;

  /// 指示器
  final ImageGalleryIndicatorBuilder? indicatorBuilder;

  /// 初始位置
  final int? initialIndex;

  @override
  State<TxImageGalleryViewer> createState() => _TxImageGalleryViewerState();
}

class _TxImageGalleryViewerState extends State<TxImageGalleryViewer> {
  late final PageController _controller;

  void scaleStateChangedCallback(PhotoViewScaleState scaleState) {
    if (widget.scaleStateChangedCallback != null) {
      widget.scaleStateChangedCallback!(scaleState);
    }
  }

  int get actualPage {
    return _controller.hasClients ? _controller.page!.floor() : 0;
  }

  int get itemCount {
    if (widget.builder != null) {
      return widget.itemCount!;
    }
    return widget.pageOptions!.length;
  }

  @override
  void initState() {
    _controller = widget.pageController ??
        PageController(initialPage: widget.initialIndex ?? 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Widget title = widget.titleBuilder != null
        ? widget.titleBuilder!(context, _controller)
        : _ImageGalleryTitle(_controller, itemCount, widget.titleBuilder);
    final double height = AppBar.preferredHeightFor(
            context, const Size.fromHeight(kToolbarHeight)) +
        MediaQuery.of(context).padding.top;
    final AppBar appBar = AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      centerTitle: true,
      title: title,
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.grey.withOpacity(0.3),
            foregroundColor: Colors.white,
            shape: const CircleBorder(),
            visualDensity: VisualDensity.compact,
            minimumSize: const Size.square(36.0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Icon(Icons.close, size: 20.0),
        )
      ],
    );

    // Enable corner hit test
    return Stack(
      children: [
        PhotoViewGestureDetectorScope(
          axis: widget.scrollDirection,
          child: PageView.builder(
            reverse: widget.reverse,
            controller: _controller,
            onPageChanged: widget.onPageChanged,
            itemCount: itemCount,
            itemBuilder: _buildItem,
            scrollDirection: widget.scrollDirection,
            physics: widget.scrollPhysics,
            allowImplicitScrolling: widget.allowImplicitScrolling,
          ),
        ),
        SizedBox(
          height: height,
          child: appBar,
        ),
        if (widget.indicatorBuilder != null)
          Positioned(
            bottom: 36.0,
            child: widget.indicatorBuilder!(context, _controller),
          )
      ],
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    final pageOption = _buildPageOption(context, index);
    final isCustomChild = pageOption.child != null;

    final PhotoView photoView = isCustomChild
        ? PhotoView.customChild(
            key: ObjectKey(index),
            childSize: pageOption.childSize,
            backgroundDecoration: widget.backgroundDecoration,
            wantKeepAlive: widget.wantKeepAlive,
            controller: pageOption.controller,
            scaleStateController: pageOption.scaleStateController,
            customSize: widget.customSize,
            heroAttributes: pageOption.heroAttributes,
            scaleStateChangedCallback: scaleStateChangedCallback,
            enableRotation: widget.enableRotation,
            initialScale: pageOption.initialScale,
            minScale: pageOption.minScale,
            maxScale: pageOption.maxScale,
            scaleStateCycle: pageOption.scaleStateCycle,
            onTapUp: pageOption.onTapUp,
            onTapDown: pageOption.onTapDown,
            onScaleEnd: pageOption.onScaleEnd,
            gestureDetectorBehavior: pageOption.gestureDetectorBehavior,
            tightMode: pageOption.tightMode,
            filterQuality: pageOption.filterQuality,
            basePosition: pageOption.basePosition,
            disableGestures: pageOption.disableGestures,
            child: pageOption.child,
          )
        : PhotoView(
            key: ObjectKey(index),
            imageProvider: pageOption.imageProvider,
            loadingBuilder: widget.loadingBuilder,
            backgroundDecoration: widget.backgroundDecoration,
            wantKeepAlive: widget.wantKeepAlive,
            controller: pageOption.controller,
            scaleStateController: pageOption.scaleStateController,
            customSize: widget.customSize,
            gaplessPlayback: widget.gaplessPlayback,
            heroAttributes: pageOption.heroAttributes,
            scaleStateChangedCallback: scaleStateChangedCallback,
            enableRotation: widget.enableRotation,
            initialScale: pageOption.initialScale,
            minScale: pageOption.minScale,
            maxScale: pageOption.maxScale,
            scaleStateCycle: pageOption.scaleStateCycle,
            onTapUp: pageOption.onTapUp,
            onTapDown: pageOption.onTapDown,
            onScaleEnd: pageOption.onScaleEnd,
            gestureDetectorBehavior: pageOption.gestureDetectorBehavior,
            tightMode: pageOption.tightMode,
            filterQuality: pageOption.filterQuality,
            basePosition: pageOption.basePosition,
            disableGestures: pageOption.disableGestures,
            errorBuilder: pageOption.errorBuilder,
          );

    return ClipRect(
      child: photoView,
    );
  }

  PhotoViewGalleryPageOptions _buildPageOption(
      BuildContext context, int index) {
    if (widget.builder != null) {
      return widget.builder!(context, index);
    }
    return widget.pageOptions![index];
  }
}

class _ImageGalleryTitle extends StatefulWidget {
  const _ImageGalleryTitle(this.controller, this.total, this.builder);

  final ImageGalleryIndicatorBuilder? builder;
  final int total;
  final PageController controller;

  @override
  State<_ImageGalleryTitle> createState() => _ImageGalleryTitleState();
}

class _ImageGalleryTitleState extends State<_ImageGalleryTitle> {
  void _update() {
    setState(() {});
  }

  @override
  void initState() {
    widget.controller.addListener(_update);
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_update);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.3),
        shape: BoxShape.rectangle,
        borderRadius: const BorderRadius.all(Radius.circular(50.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
        child: Text(
          '${(widget.controller.page?.floor() ?? widget.controller.initialPage) + 1}/${widget.total}',
          style: Theme.of(context).primaryTextTheme.titleSmall,
        ),
      ),
    );
  }
}
