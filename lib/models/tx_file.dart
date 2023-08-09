import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:file_picker/file_picker.dart' show PlatformFile;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

extension PlatformFileExtension on PlatformFile {
  TxFile toTxFile() {
    if (path == null) {
      return TxMemoryFile(bytes!, name: name);
    }
    return TxFile(path!, length: size);
  }
}

abstract class TxFileBase {
  Future<void> saveTo(String path);

  String get name;

  String? get mimeType;

  Future<int> length();

  Future<String?> readAsString({Encoding encoding = utf8});

  Future<Uint8List?> readAsBytes();

  Stream<Uint8List?> openRead([int? start, int? end]);

  Future<DateTime> lastModified();
}

class TxFile extends TxFileBase {
  TxFile(
    String path, {
    String? mimeType,
    int? length,
    DateTime? lastModified,
  })  : _mimeType = mimeType,
        _file = File(path),
        _lastModified = lastModified,
        _length = length;

  File _file;
  final String? _mimeType;
  final DateTime? _lastModified;
  final int? _length;

  @override
  Future<DateTime> lastModified() {
    if (_lastModified != null) {
      return Future<DateTime>.value(_lastModified);
    }
    return _file.lastModified();
  }

  @override
  Future<void> saveTo(String path) async {
    await _file.copy(path);
  }

  @override
  String? get mimeType => _mimeType;

  String get path => _file.path;

  @override
  String get name => _file.path.split(Platform.pathSeparator).last;

  @override
  Future<int> length() {
    if (_length != null) {
      return Future<int>.value(_length);
    }
    return _file.length();
  }

  @override
  Future<String?> readAsString({Encoding encoding = utf8}) {
    return _file.readAsString(encoding: encoding);
  }

  @override
  Future<Uint8List?> readAsBytes() {
    return _file.readAsBytes();
  }

  @override
  Stream<Uint8List?> openRead([int? start, int? end]) {
    return _file.openRead(start ?? 0, end).map(Uint8List.fromList);
  }

  Future<ShareResult> share({
    String? subject,
    String? text,
    Rect? sharePositionOrigin,
  }) async {
    final XFile? file = await _getFile();
    if (file == null) {
      return const ShareResult('', ShareResultStatus.unavailable);
    }
    return Share.shareXFiles([file]);
  }

  Future<XFile?> _getFile() async {
    if (this.path.isNotEmpty) {
      return XFile(this.path);
    }

    final String tempPath = (await getTemporaryDirectory()).path;
    final String path = '$tempPath${Platform.pathSeparator}$name';
    final File file = File(path);

    final Uint8List? data = await readAsBytes();
    if (data == null) {
      return null;
    }
    await file.writeAsBytes(data);
    return XFile(path);
  }
}

class TxMemoryFile extends TxFile {
  TxMemoryFile(
    Uint8List bytes, {
    required String name,
    super.mimeType,
    super.lastModified,
  })  : _name = name,
        _bytes = bytes,
        super('', length: bytes.length);

  TxMemoryFile._fromNetwork({
    int? length,
    super.mimeType,
    super.lastModified,
    String? name,
  })  : _name = name,
        _bytes = null,
        super('', length: length);

  final String? _name;
  Uint8List? _bytes;

  Uint8List? get bytes => _bytes;

  @override
  Future<void> saveTo(String path) async {
    if (path.isNotEmpty) {
      super.saveTo(path);
    } else {
      _file = File(path);
      await _file.writeAsBytes(_bytes!);
    }
  }

  @override
  String get name => _name ?? _file.path.split(Platform.pathSeparator).last;

  @override
  Future<String?> readAsString({Encoding encoding = utf8}) {
    return Future<String>.value(String.fromCharCodes(_bytes!));
  }

  @override
  Future<Uint8List?> readAsBytes() {
    return Future<Uint8List>.value(_bytes);
  }

  Stream<Uint8List> _getBytes(int? start, int? end) async* {
    yield _bytes!.sublist(start ?? 0, end ?? _bytes!.length);
  }

  @override
  Stream<Uint8List?> openRead([int? start, int? end]) {
    return _getBytes(start, end);
  }
}

abstract class TxNetworkFile extends TxMemoryFile {
  TxNetworkFile(
    String url, {
    super.name,
    super.lastModified,
    super.mimeType,
    super.length,
  })  : _url = url,
        super._fromNetwork();

  final String _url;

  String get url => _url;

  Future<Uint8List?> fetchFileData();

  @override
  Future<void> saveTo(String path) async {
    if (_bytes == null) {
      _bytes = await fetchFileData();
      if (_bytes != null) {
        super.saveTo(path);
      }
    } else {
      super.saveTo(path);
    }
  }

  @override
  Future<Uint8List?> readAsBytes() async {
    if (_bytes == null) {
      _bytes = await fetchFileData();
      return _bytes;
    } else {
      return super.readAsBytes();
    }
  }

  @override
  Stream<Uint8List?> openRead([int? start, int? end]) {
    if (_bytes == null) {
      return const Stream.empty();
    }
    return super.openRead(start, end);
  }

  @override
  Future<String?> readAsString({Encoding encoding = utf8}) async {
    if (_bytes == null) {
      _bytes = await fetchFileData();
      if (_bytes == null) {
        return null;
      }
    }
    return String.fromCharCodes(_bytes!);
  }
}
