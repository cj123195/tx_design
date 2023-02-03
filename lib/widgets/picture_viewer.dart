import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

/// 一个查看图片的小部件
class TxPictureViewer extends StatelessWidget {
  /// 创建一个图片查看器
  ///
  /// [picture]不能为空
  const TxPictureViewer(
    this.picture, {
    super.key,
    this.tag,
  });

  /// 通过asset路径创建一个图片查看器
  ///
  /// [path] 不能为空
  TxPictureViewer.asset(
    String path, {
    super.key,
    this.tag,
  }) : picture = AssetImage(path);

  /// 通过网络地址路径创建一个图片查看器
  ///
  /// [path] 不能为空
  TxPictureViewer.network(
    String path, {
    super.key,
    this.tag,
  }) : picture = NetworkImage(path);

  /// 通过文件创建一个图片查看器
  ///
  /// [file] 不能为空
  TxPictureViewer.file(
    File file, {
    super.key,
    this.tag,
  }) : picture = FileImage(file);

  factory TxPictureViewer.unknown(String path, {String? tag}) {
    if (path.startsWith('http') || path.startsWith('https')) {
      return TxPictureViewer.network(path, tag: tag);
    } else if (path.startsWith('assets')) {
      return TxPictureViewer.asset(path, tag: tag);
    } else {
      return TxPictureViewer.file(File(path), tag: tag);
    }
  }

  /// 标签
  ///
  /// 主要用于创建Hero动画
  final String? tag;

  /// 图片
  final ImageProvider picture;

  @override
  Widget build(BuildContext context) {
    Widget child = PhotoView(
      imageProvider: picture,
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
