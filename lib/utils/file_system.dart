import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// 文件系统工具类
class FileSystem {
  FileSystem._();

  /// 准备下载目录
  static Future<String> prepareDownloadDir() async {
    final String path = (await getDownloadDir())!;
    final Directory savedDir = Directory(path);
    if (!savedDir.existsSync()) {
      await savedDir.create();
    }
    return path;
  }

  /// 获取下载路径
  static Future<String?> getDownloadDir() async {
    String? externalStorageDirPath;

    if (Platform.isAndroid) {
      try {
        final Directory? directory = await getDownloadsDirectory();
        if (directory == null) {
          externalStorageDirPath = (await getExternalStorageDirectory())?.path;
        } else {
          externalStorageDirPath = directory.path;
        }
      } on UnsupportedError {
        final directory = await getExternalStorageDirectory();
        externalStorageDirPath = directory?.path;
      }
    } else if (Platform.isIOS) {
      externalStorageDirPath =
          (await getApplicationDocumentsDirectory()).absolute.path;
    }
    return externalStorageDirPath;
  }

  /// 创建一个文件
  ///
  /// [name] 文件名
  /// [path] 路径
  /// [force] 是否强制，为true时，若文件已存在，则删除该文件并重新创建
  static Future<File> createFile(
    String name, {
    String? path,
    bool force = true,
  }) async {
    path ??= await prepareDownloadDir();
    File file = File('$path/$name');
    if (await file.exists() && force) {
      file.delete();
    }
    file = await file.create();
    return file;
  }

  static Future<File> createCacheFile(String name, {bool force = true}) async {
    return await createFile(
      name,
      force: force,
      path: (await getTemporaryDirectory()).path,
    );
  }
}
