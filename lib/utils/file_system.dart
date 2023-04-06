import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// 文件系统工具类
class FileSystem {
  FileSystem._();

  /// 创建文件夹
  static Future<Directory> createDirectory(String name) async {
    final Directory externalDir = (await getExternalStorageDir())!;
    final Directory savedDir =
        Directory(externalDir.path + Platform.pathSeparator + name);
    if (!savedDir.existsSync()) {
      await savedDir.create();
    }
    return savedDir;
  }

  /// 获取下载路径
  static Future<Directory?> getDownloadDir() async {
    Directory? downloadDir;

    if (Platform.isAndroid) {
      try {
        final Directory? directory = await getDownloadsDirectory();
        if (directory == null) {
          downloadDir = await getExternalStorageDir();
        } else {
          downloadDir = directory;
        }
      } on UnsupportedError {
        downloadDir = await getExternalStorageDir();
      }
    } else if (Platform.isIOS) {
      downloadDir = await getExternalStorageDir();
    }
    return downloadDir;
  }

  /// 获取应用外部存储路径
  static Future<Directory?> getExternalStorageDir() async {
    if (Platform.isAndroid) {
      return (await getExternalStorageDirectory())!;
    } else if (Platform.isIOS) {
      return (await getApplicationDocumentsDirectory()).absolute;
    }
    return null;
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
    path ??= (await getDownloadDir())!.path;
    File file = File('$path${Platform.pathSeparator}$name');
    if (await file.exists() && force) {
      file.delete();
    }
    file = await file.create();
    return file;
  }

  /// 创建缓存文件
  static Future<File> createCacheFile(String name, {bool force = true}) async {
    return await createFile(
      name,
      force: force,
      path: (await getTemporaryDirectory()).path,
    );
  }

  /// 查找文件
  static Future<File?> searchFile(String name, {String? path}) async {
    path ??= (await getDownloadDir())!.path;
    final File file = File('$path${Platform.pathSeparator}$name');
    return file.existsSync() ? file : null;
  }
}
