import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/svg.dart';
import '../extensions/int_extension.dart';
import '../extensions/string_extension.dart';
import 'text_button.dart';

const double _kIconSize = 40.0;

/// 一个用于展示文件信息的小部件，可以对其进行部分操作
///
/// 由于此组件包含默认的文件图标，所以在使用前请确保将'../example/assets/svgs'目录下资源
/// 拷贝到项目相同目录下，并在pubspec.yaml中配置资源路径：
/// ```
///   assets:
///     - assets/svgs/
/// ```
/// 如使用了不同的目录或者资源请自行配置[fileIcon]来修改文件图标。
class TxFileListTile extends StatelessWidget {
  /// 创建一个文件Tile
  const TxFileListTile({
    required this.name,
    super.key,
    this.size,
    this.onDeleteTap,
    this.onPreviewTap,
    this.onShareTap,
    this.actions,
    this.fileIcon,
    this.dense = true,
    this.tileColor,
    this.visualDensity,
    this.shape,
    this.selectedColor,
    this.iconColor,
    this.textColor,
    this.style,
    this.contentPadding,
    this.enabled = true,
    this.mouseCursor,
    this.selected = false,
    this.focusColor,
    this.hoverColor,
    this.splashColor,
    this.focusNode,
    this.autofocus = false,
    this.selectedTileColor,
    this.enableFeedback,
    this.horizontalTitleGap,
    this.minVerticalPadding,
    this.minLeadingWidth,
  });

  /// 名称
  final String name;

  /// 大小
  final int? size;

  /// 删除点击回调
  final VoidCallback? onDeleteTap;

  /// 预览点击回调
  final VoidCallback? onPreviewTap;

  /// 分享点击回调
  final VoidCallback? onShareTap;

  /// 其他操作按钮
  final List<Widget>? actions;

  /// 图标
  final Widget? fileIcon;

  /// 参考[ListTile.dense]
  final bool dense;

  /// 参考[ListTile.visualDensity]
  final VisualDensity? visualDensity;

  /// 参考[ListTile.shape]
  final ShapeBorder? shape;

  /// 参考[ListTile.selectedColor]
  final Color? selectedColor;

  /// 参考[ListTile.iconColor]
  final Color? iconColor;

  /// 参考[ListTile.textColor]
  final Color? textColor;

  /// 参考[ListTile.style]
  final ListTileStyle? style;

  /// 参考[ListTile.contentPadding]
  final EdgeInsetsGeometry? contentPadding;

  /// 参考[ListTile.enabled]
  final bool enabled;

  /// 参考[ListTile.mouseCursor]
  final MouseCursor? mouseCursor;

  /// 参考[ListTile.selected]
  final bool selected;

  /// 参考[ListTile.focusColor]
  final Color? focusColor;

  /// 参考[ListTile.hoverColor]
  final Color? hoverColor;

  /// 参考[ListTile.splashColor]
  final Color? splashColor;

  /// 参考[ListTile.focusNode]
  final FocusNode? focusNode;

  /// 参考[ListTile.autofocus]
  final bool autofocus;

  /// 参考[ListTile.tileColor]
  final Color? tileColor;

  /// 参考[ListTile.selectedTileColor]
  final Color? selectedTileColor;

  /// 参考[ListTile.enableFeedback]
  final bool? enableFeedback;

  /// 参考[ListTile.horizontalTitleGap]
  final double? horizontalTitleGap;

  /// 参考[ListTile.minVerticalPadding]
  final double? minVerticalPadding;

  /// 参考[ListTile.minLeadingWidth]
  final double? minLeadingWidth;

  String get _fileSvgPath {
    if (name.isThreeDFileName) {
      return SvgConstant.three_d;
    }
    if (name.isAudioFileName) {
      return SvgConstant.audio;
    }
    if (name.isCadFileName) {
      return SvgConstant.cad;
    }
    if (name.isConfigurationFileName) {
      return SvgConstant.config;
    }
    if (name.isDatabaseFileName) {
      return SvgConstant.database;
    }
    if (name.isExcelFileName) {
      return SvgConstant.excel;
    }
    if (name.isExeFileName) {
      return SvgConstant.exe;
    }
    if (name.isGifFileName) {
      return SvgConstant.gif;
    }
    if (name.isHTMLFileName) {
      return SvgConstant.html;
    }
    if (name.isPDFFileName) {
      return SvgConstant.pdf;
    }
    if (name.isImageFileName) {
      return SvgConstant.image;
    }
    if (name.isPPTFileName) {
      return SvgConstant.ppt;
    }
    if (name.isTxtFileName) {
      return SvgConstant.txt;
    }
    if (name.isVideoFileName) {
      return SvgConstant.video;
    }
    if (name.isWordFileName) {
      return SvgConstant.word;
    }
    if (name.isWPSFileName) {
      return SvgConstant.wps;
    }
    if (name.isCompressedFileName) {
      return SvgConstant.zip;
    }
    return SvgConstant.unknown;
  }

  /// 显示操作栏
  void _showActionPane(BuildContext context) {
    final List<Widget> buttons = [
      if (onPreviewTap != null)
        TxTextButton.icon(
          label: const Text('预览'),
          icon: const Icon(Icons.preview),
          iconPosition: TextButtonIconPosition.top,
          onPressed: onPreviewTap,
        ),
      if (onShareTap != null)
        TxTextButton.icon(
          label: const Text('分享'),
          icon: const Icon(Icons.share),
          iconPosition: TextButtonIconPosition.top,
          onPressed: onShareTap,
        ),
      if (onDeleteTap != null)
        TxTextButton.icon(
          label: const Text('删除'),
          icon: const Icon(Icons.delete_outline),
          iconPosition: TextButtonIconPosition.top,
          onPressed: onDeleteTap,
        ),
      ...?actions
    ];

    showModalBottomSheet<void>(
      context: context,
      constraints: const BoxConstraints(maxWidth: 640),
      builder: (context) {
        return ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: 125.0,
            minWidth: double.infinity,
            maxWidth: double.infinity
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              runAlignment: WrapAlignment.spaceAround,
              alignment: WrapAlignment.spaceAround,
              children: buttons,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget leading = fileIcon ??
        SvgPicture.asset(
          _fileSvgPath,
          width: _kIconSize,
          height: _kIconSize,
        );
    final Widget subtitle = Text(size?.sizeFormat() ?? '未知大小');
    final Widget title = Text(name);
    const Widget trailing = Icon(Icons.more_horiz);

    return ListTile(
      leading: leading,
      title: title,
      subtitle: subtitle,
      trailing: trailing,
      onTap: () => _showActionPane(context),
      dense: dense,
      visualDensity: visualDensity,
      shape: shape,
      style: style,
      selectedColor: selectedColor,
      iconColor: iconColor,
      textColor: textColor,
      contentPadding: contentPadding ?? EdgeInsets.zero,
      enabled: enabled,
      mouseCursor: mouseCursor,
      selected: selected,
      focusColor: focusColor,
      hoverColor: hoverColor,
      splashColor: splashColor,
      focusNode: focusNode,
      autofocus: autofocus,
      tileColor: tileColor,
      selectedTileColor: selectedTileColor,
      enableFeedback: enableFeedback,
      horizontalTitleGap: horizontalTitleGap,
      minVerticalPadding: minVerticalPadding,
      minLeadingWidth: minLeadingWidth,
    );
  }
}
