// ignore_for_file: prefer_mixin

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_reorderable_grid_view/widgets/reorderable_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../localizations.dart';
import '../models/tx_file.dart';
import 'bottom_sheet.dart';
import 'image_picker_theme.dart';
import 'image_viewer.dart' show TxImageGalleryViewer;
import 'toast.dart';

export '../models/tx_file.dart';

const int _kMaxImages = 9;
const double _kGap = 8.0;
const double _kPickIconSize = 32.0;
const double _kDeleteButtonSize = 16.0;
const BorderRadius _kBorderRadius = BorderRadius.all(Radius.circular(8.0));
const int _kColumnNum = 3;
const String _tag = 'tx_image_picker';

/// 图片选择模式
enum PickerMode {
  video,
  image,
  galleryVideo,
  galleryImage;

  String getLabel(BuildContext context) {
    final TxLocalizations localizations = TxLocalizations.of(context);
    switch (this) {
      case PickerMode.video:
        return localizations.captureTileLabel;
      case PickerMode.image:
        return localizations.photographTileLabel;
      case PickerMode.galleryVideo:
        return localizations.selectVideoTileLabel;
      case PickerMode.galleryImage:
        return localizations.selectPhotoTileLabel;
    }
  }

  static const List<PickerMode> videoModes = [
    PickerMode.video,
    PickerMode.galleryVideo,
  ];

  static const List<PickerMode> imageModes = [
    PickerMode.image,
    PickerMode.galleryImage,
  ];
}

/// 选择图片选择模式
Future<PickerMode?> showImagePickerModePicker(
  BuildContext context, {
  List<PickerMode>? enableModes,
}) async {
  assert(enableModes == null || enableModes.length > 1);

  enableModes ??= PickerMode.values;

  return await showSimplePickerBottomSheet<PickerMode>(
    context: context,
    itemsBuilder: (BuildContext context) => List.generate(
      enableModes!.length,
      (index) {
        final PickerMode mode = enableModes![index];
        return SimplePickerItem(
          title: Text(mode.getLabel(context)),
          value: mode,
        );
      },
    ),
  );
}

typedef TipMapper = String Function(int maxItems);

class TxImagePickerController with ChangeNotifier {
  TxImagePickerController({
    required this.maxImages,
    List<TxFile>? images,
    this.enableModes,
    this.maxDuration,
    this.maxWidth,
    this.maxHeight,
    this.imageQuality,
  })  : assert(maxImages < 300 && maxImages > 0),
        _images = images ?? [];

  /// 最大可选数量，
  ///
  /// 值不能小于0且不能大于300。
  final int maxImages;

  /// 允许选择的模式
  final List<PickerMode>? enableModes;

  /// 视频最大时长
  final Duration? maxDuration;

  /// 图片最大宽度
  final double? maxWidth;

  /// 图片最大高度
  final double? maxHeight;

  /// 图片质量
  final int? imageQuality;

  final List<TxFile> _images;

  /// 所有图片列表，包含初始图片与已选择的图片
  List<TxFile> get images => _images;

  /// 已选图片列表是否为空
  bool get hasNoImage => _images.isEmpty;

  /// 手动选择图像。即点击外部按钮。
  ///
  /// 此方法打开图像选择窗口。
  /// 如果用户已选择图像则返回true。
  Future<bool> pickImages(BuildContext context) async {
    final PickerMode? mode = await showImagePickerModePicker(
      context,
      enableModes: enableModes,
    );
    if (mode == null) {
      return false;
    }

    final ImagePicker imagePicker = ImagePicker();
    List<XFile> images = [];
    if (mode == PickerMode.galleryImage) {
      images = await imagePicker.pickMultiImage(
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: imageQuality,
      );
    } else {
      final XFile? image = await _pickByMode(mode, imagePicker);
      if (image != null) {
        images.add(image);
      }
    }

    if (images.isEmpty) {
      return false;
    }

    if (context.mounted && images.length + _images.length > maxImages) {
      Toast.show(TxLocalizations.of(context).maximumPhotoLimitLabel(maxImages));
    }

    final List<TxFile> data =
        await Future.wait([for (XFile image in images) _transform(image)]);
    _images.addAll(data);
    notifyListeners();
    return true;
  }

  /// 根据模式选择
  Future<XFile?> _pickByMode(PickerMode mode, ImagePicker picker) {
    switch (mode) {
      case PickerMode.video:
        return picker.pickVideo(
          source: ImageSource.camera,
          maxDuration: maxDuration,
        );
      case PickerMode.image:
        return picker.pickImage(
          source: ImageSource.camera,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          imageQuality: imageQuality,
        );
      case PickerMode.galleryVideo:
        return picker.pickVideo(
          source: ImageSource.gallery,
          maxDuration: maxDuration,
        );
      default:
        return Future.value(null);
    }
  }

  Future<TxFile> _transform(XFile image) async {
    return TxFile(
      image.path,
      length: await image.length(),
      mimeType: image.mimeType,
      lastModified: await image.lastModified(),
    );
  }

  /// 手动重新排序图像，即将图像从一个位置移动到另一个位置。
  void reorderImage(int oldIndex, int newIndex) {
    final TxFile bytes = _images.removeAt(oldIndex);
    _images.insert(newIndex, bytes);
    notifyListeners();
  }

  /// 手动从列表中删除图像
  void removeImage(TxFile bytes) {
    _images.remove(bytes);
    notifyListeners();
  }

  /// 删除所有选定的图像并显示默认UI
  void clearImages() {
    _images.clear();
    notifyListeners();
  }
}

class TxImagePickerView extends StatefulWidget {
  /// 创建一个图片集
  const TxImagePickerView({
    super.key,
    this.enabled = true,
    this.maxItems = 9,
    this.initialImages,
    this.onChanged,
    this.tipMapper,
    this.gap,
    this.contentPadding,
    this.deleteButtonBuilder,
    this.deleteButtonColor,
    this.deleteButtonSize,
    this.pickButtonBackground,
    this.pickButtonForeground,
    this.pickIconSize,
    this.borderRadius,
    this.itemPadding,
    this.columnNumber,
    this.controller,
    this.draggable,
    this.emptyBuilder,
    this.emptyButtonTitle,
    this.itemBuilder,
    this.addButtonBuilder,
    this.disabledEmptyTitle,
    this.emptyContainerDecoration,
    this.enableModes,
  });

  /// 图片选择控制器
  final TxImagePickerController? controller;

  /// 最大个数
  ///
  /// 当[enabled]为true，表示最大可选择的个数
  /// 当[enabled]为false，表示最大可显示的个数
  final int? maxItems;

  /// 初始图片
  final List<TxFile>? initialImages;

  /// 是否可用
  final bool enabled;

  /// 选择回调
  final ValueChanged<List<TxFile>>? onChanged;

  /// 提示文字
  final TipMapper? tipMapper;

  /// 是否可以拖拽
  final bool? draggable;

  /// 图片与图片之间的间距
  final double? gap;

  /// 图片集内边距
  final EdgeInsetsGeometry? contentPadding;

  /// 删除按钮颜色
  final Color? deleteButtonColor;

  /// 删除按钮大小
  final double? deleteButtonSize;

  /// 删除按钮构造方法
  final Widget Function(BuildContext context, Function(TxFile) deleteCallback)?
      deleteButtonBuilder;

  /// 图片列表为空时选择按钮的文字
  final String? emptyButtonTitle;

  /// 不可用状态下图片列表为空时的文字显示
  final String? disabledEmptyTitle;

  /// 列表为空时容器的装饰器
  final BoxDecoration? emptyContainerDecoration;

  /// 图片列表为空时构建方法
  final Widget Function(BuildContext context, Function() pickerCallback)?
      emptyBuilder;

  /// 图片构造方法
  final Widget Function(
          BuildContext context, TxFile file, Function(TxFile) deleteCallback)?
      itemBuilder;

  /// 选择更多构造方法
  final Widget Function(BuildContext context, Function() pickerCallback)?
      addButtonBuilder;

  /// 选择按钮背景颜色
  final Color? pickButtonBackground;

  /// 选择按钮前景色
  ///
  /// 如果不为null，则会覆盖选择组件颜色
  final Color? pickButtonForeground;

  /// 选择按钮图标大小
  final double? pickIconSize;

  /// 单个图片形状
  final BorderRadius? borderRadius;

  /// 单个图片内边距
  final EdgeInsetsGeometry? itemPadding;

  /// 列数
  final int? columnNumber;

  /// 选择模式
  final List<PickerMode>? enableModes;

  @override
  State<TxImagePickerView> createState() => _TxImagePickerViewState();
}

class _TxImagePickerViewState extends State<TxImagePickerView> {
  late ScrollController _scrollController;
  final GlobalKey _gridViewKey = GlobalKey();
  late final TxImagePickerController _controller;

  ImageProvider _getImage(TxFile file) {
    if (file is TxNetworkFile) {
      return NetworkImage(file.url);
    } else if (file is TxMemoryFile) {
      return MemoryImage(file.bytes!);
    } else {
      return FileImage(File(file.path));
    }
  }

  Future<void> _previewImage(int index, ImageProvider image) async {
    if (context.mounted) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return TxImageGalleryViewer.builder(
          itemCount: _controller.images.length,
          builder: (context, index) {
            return PhotoViewGalleryPageOptions(
              heroAttributes: PhotoViewHeroAttributes(tag: '$_tag$index'),
              imageProvider: image,
            );
          },
          initialIndex: index,
          wantKeepAlive: true,
        );
      }));
    }
  }

  void _pickImages() async {
    final bool result = await _controller.pickImages(context);
    if (!result) {
      return;
    }
    if (widget.onChanged != null) {
      widget.onChanged!(_controller.images);
    }
  }

  void _deleteImage(TxFile bytes) {
    _controller.removeImage(bytes);
    if (widget.onChanged != null) {
      widget.onChanged!(_controller.images);
    }
  }

  void _listener() {
    setState(() {});
  }

  void _createController() {
    _controller = widget.controller ??
        TxImagePickerController(
          maxImages: widget.maxItems ?? _kMaxImages,
          images: widget.initialImages,
          enableModes: widget.enableModes,
        );
    _controller.addListener(_listener);
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _createController();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant TxImagePickerView oldWidget) {
    if (oldWidget.controller != oldWidget.controller) {
      _controller.removeListener(_listener);
      _createController();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TxImagePickerViewThemeData galleryTheme =
        TxImagePickerViewTheme.of(context);
    final double gap = widget.gap ?? galleryTheme.gap ?? _kGap;
    final int columnNumber =
        widget.columnNumber ?? galleryTheme.columnNumber ?? _kColumnNum;
    final EdgeInsetsGeometry padding =
        widget.contentPadding ?? galleryTheme.contentPadding ?? EdgeInsets.zero;

    if (_controller.hasNoImage) {
      if (widget.emptyBuilder != null) {
        return widget.emptyBuilder!(context, _pickImages);
      } else {
        return _EmptyContainer(
          decoration: widget.emptyContainerDecoration,
          backgroundColor: widget.pickButtonBackground,
          foregroundColor: widget.pickButtonForeground,
          title: widget.enabled
              ? widget.emptyButtonTitle
              : widget.disabledEmptyTitle,
          onTap: widget.enabled ? _pickImages : null,
        );
      }
    }

    return LayoutBuilder(builder: (context, constraints) {
      final double maxWidth = constraints.maxWidth;
      final double width =
          (maxWidth - gap * (columnNumber - 1) - padding.horizontal * 2) /
              columnNumber;

      final List<Widget> children = widget.itemBuilder != null
          ? List.generate(
              _controller.images.length,
              (index) => widget.itemBuilder!(
                context,
                _controller.images[index],
                _deleteImage,
              ),
            )
          : List.generate(_controller.images.length, (index) {
              final ImageProvider image = _getImage(_controller.images[index]);
              return TxImagePickerItem(
                image: image,
                size: width,
                tag: '$_tag$index',
                key: ValueKey('image$index'),
                onDeleteTap: widget.enabled
                    ? () => _deleteImage(_controller.images[index])
                    : null,
                padding: widget.itemPadding,
                deleteButtonColor: widget.deleteButtonColor,
                deleteButtonSize: widget.deleteButtonSize,
                borderRadius: widget.borderRadius,
                onTap: () => _previewImage(index, image),
              );
            });

      if (widget.enabled && _controller.maxImages > _controller.images.length) {
        final Widget pickButton = widget.addButtonBuilder != null
            ? widget.addButtonBuilder!(context, _pickImages)
            : _PickButton(
                key: const ValueKey('pickButton'),
                color: widget.pickButtonBackground,
                foregroundColor: widget.pickButtonForeground,
                iconSize: widget.pickIconSize,
                borderRadius: widget.borderRadius,
                onTap: _pickImages,
              );
        children.add(pickButton);
      }

      if (!widget.enabled || widget.draggable != true) {
        return Wrap(
          alignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.start,
          key: _gridViewKey,
          // controller: _scrollController,
          spacing: gap,
          runSpacing: gap,
          children: children
              .map((e) => SizedBox.square(dimension: width, child: e))
              .toList(),
        );
      }

      return AspectRatio(
        aspectRatio: 1.0,
        child: ReorderableBuilder(
          scrollController: _scrollController,
          key: Key(_gridViewKey.toString()),
          lockedIndices: [_controller.images.length],
          longPressDelay: const Duration(milliseconds: 100),
          onReorder: (updateEntities) {
            for (final orderUpdateEntity in updateEntities) {
              _controller.reorderImage(
                  orderUpdateEntity.oldIndex, orderUpdateEntity.newIndex);
              if (widget.onChanged != null) {
                widget.onChanged!(_controller.images);
              }
            }
          },
          builder: (children) {
            return GridView.count(
              crossAxisCount: columnNumber,
              key: _gridViewKey,
              controller: _scrollController,
              mainAxisSpacing: gap,
              crossAxisSpacing: gap,
              childAspectRatio: 1.0,
              children: children,
            );
          },
          children: children,
        ),
      );
    });
  }
}

class _EmptyContainer extends StatelessWidget {
  const _EmptyContainer({
    this.foregroundColor,
    this.backgroundColor,
    this.title,
    this.onTap,
    this.decoration,
  });

  final Color? foregroundColor;
  final Color? backgroundColor;
  final BoxDecoration? decoration;
  final String? title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final TxImagePickerViewThemeData galleryTheme =
        TxImagePickerViewTheme.of(context);

    final Color foreground = foregroundColor ??
        galleryTheme.pickButtonForeground ??
        Theme.of(context).colorScheme.outline;
    final Color? background =
        backgroundColor ?? galleryTheme.pickButtonBackground;
    final String title = this.title ??
        galleryTheme.emptyButtonTitle ??
        TxLocalizations.of(context).selectPhotoButtonLabel;

    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        foregroundColor: foreground,
        backgroundColor: background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
      onPressed: onTap,
      icon: const Icon(Icons.image),
      label: Text(title),
    );
  }
}

class _PickButton extends StatelessWidget {
  const _PickButton({
    super.key,
    this.color,
    this.foregroundColor,
    this.iconSize,
    this.onTap,
    this.borderRadius,
  });

  final Color? color;
  final Color? foregroundColor;
  final double? iconSize;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final TxImagePickerViewThemeData pickerTheme =
        TxImagePickerViewTheme.of(context);

    final BorderRadius borderRadius =
        this.borderRadius ?? pickerTheme.borderRadius ?? _kBorderRadius;
    final Color? background = color ?? pickerTheme.pickButtonBackground;
    final Color? foreground =
        foregroundColor ?? pickerTheme.pickButtonForeground;
    final double iconSize =
        this.iconSize ?? pickerTheme.pickIconSize ?? _kPickIconSize;

    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: background,
        foregroundColor: foreground,
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
      ),
      child: Icon(Icons.add, size: iconSize, color: foreground),
    );
  }
}

/// 选择器图片
class TxImagePickerItem extends StatelessWidget {
  const TxImagePickerItem({
    required this.image,
    required this.size,
    required this.tag,
    super.key,
    this.onDeleteTap,
    this.padding,
    this.deleteButtonColor,
    this.deleteButtonSize,
    this.borderRadius,
    this.onTap,
  });

  final ImageProvider image;
  final double size;
  final dynamic tag;
  final VoidCallback? onDeleteTap;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final Color? deleteButtonColor;
  final double? deleteButtonSize;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final TxImagePickerViewThemeData galleryTheme =
        TxImagePickerViewTheme.of(context);

    final EdgeInsetsGeometry? padding =
        this.padding ?? galleryTheme.itemPadding;

    Widget child = GestureDetector(
      onTap: onTap,
      child: Hero(
        tag: tag,
        child: DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: image,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );

    if (padding != null) {
      child = Padding(padding: padding, child: child);
    }

    if (onDeleteTap != null) {
      final ColorScheme scheme = Theme.of(context).colorScheme;
      final double deleteButtonSize = this.deleteButtonSize ??
          galleryTheme.deleteButtonSize ??
          _kDeleteButtonSize;
      final Color deleteButtonColor = this.deleteButtonColor ??
          galleryTheme.deleteButtonColor ??
          scheme.error;
      const ShapeBorder shape = CircleBorder();

      final Widget button = Material(
        shape: shape,
        color: deleteButtonColor,
        child: InkWell(
          customBorder: shape,
          onTap: onDeleteTap,
          child: Icon(
            Icons.close,
            size: deleteButtonSize,
            color: scheme.onError,
          ),
        ),
      );
      child = OverflowBox(
        maxHeight: size + 12,
        maxWidth: size + 12,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Padding(padding: const EdgeInsets.all(6.0), child: child),
            Align(alignment: Alignment.topRight, child: button)
          ],
        ),
      );
    }

    return child;
  }
}
