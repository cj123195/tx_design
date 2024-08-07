import 'package:flutter/material.dart';

import 'datetime_extension.dart';

const Map<String, MaterialColor> _colorMap = {
  'red': Colors.red,
  'pink': Colors.pink,
  'purple': Colors.purple,
  'deepPurple': Colors.deepPurple,
  'indigo': Colors.indigo,
  'blue': Colors.blue,
  'lightBlue': Colors.lightBlue,
  'cyan': Colors.cyan,
  'teal': Colors.teal,
  'green': Colors.green,
  'lightGreen': Colors.lightGreen,
  'lime': Colors.lime,
  'yellow': Colors.yellow,
  'amber': Colors.amber,
  'orange': Colors.orange,
  'deepOrange': Colors.deepOrange,
  'brown': Colors.brown,
  'blueGrey': Colors.blueGrey,
};

const Map<String, MaterialAccentColor> _accentColorMap = {
  'redAccent': Colors.redAccent,
  'pinkAccent': Colors.pinkAccent,
  'purpleAccent': Colors.purpleAccent,
  'deepPurpleAccent': Colors.deepPurpleAccent,
  'indigoAccent': Colors.indigoAccent,
  'blueAccent': Colors.blueAccent,
  'lightBlueAccent': Colors.lightBlueAccent,
  'cyanAccent': Colors.cyanAccent,
  'tealAccent': Colors.tealAccent,
  'greenAccent': Colors.greenAccent,
  'lightGreenAccent': Colors.lightGreenAccent,
  'limeAccent': Colors.limeAccent,
  'yellowAccent': Colors.yellowAccent,
  'amberAccent': Colors.amberAccent,
  'orangeAccent': Colors.orangeAccent,
  'deepOrangeAccent': Colors.deepOrangeAccent,
};

extension StringExtension on String {
  /// 获取有效的Rgb值
  int _getValidRgbValue(int value) {
    if (value < 0) {
      return 0;
    }
    if (value > 255) {
      return 255;
    }
    return value;
  }

  /// 以argb方式生成Color
  Color? _toArgbColor() {
    final List<String> rgba = (toLowerCase()
          ..replaceAll('rgba', '')
          ..replaceAll('rgb', '')
          ..replaceAll('(', '')
          ..replaceAll(')', ''))
        .split(',');
    if (rgba.length < 3) {
      return null;
    }
    final int? r = int.tryParse(rgba[0]);
    if (r == null) {
      return null;
    }
    final int? g = int.tryParse(rgba[1]);
    if (g == null) {
      return null;
    }
    final int? b = int.tryParse(rgba[2]);
    if (b == null) {
      return null;
    }
    int? a;
    if (rgba.length > 3) {
      a = int.tryParse(rgba[3]);
    }
    return Color.fromARGB(
      a == null ? 255 : _getValidRgbValue(a),
      _getValidRgbValue(r),
      _getValidRgbValue(g),
      _getValidRgbValue(b),
    );
  }

  /// 以rgbo方式生成Color
  Color? _toRgboColor() {
    final List<String> rgbo = (toLowerCase()
          ..replaceAll('rgbo(', '')
          ..replaceAll(')', ''))
        .split(',');
    if (rgbo.length < 3) {
      return null;
    }
    final int? r = int.tryParse(rgbo[0]);
    if (r == null) {
      return null;
    }
    final int? g = int.tryParse(rgbo[1]);
    if (g == null) {
      return null;
    }
    final int? b = int.tryParse(rgbo[2]);
    if (b == null) {
      return null;
    }
    double? o;
    if (rgbo.length > 3) {
      o = double.tryParse(rgbo[3]);
    }
    return Color.fromRGBO(
      _getValidRgbValue(r),
      _getValidRgbValue(r),
      _getValidRgbValue(r),
      o ?? 1.0,
    );
  }

  /// 格式化为颜色
  Color? toColor() {
    if (toLowerCase().startsWith('rgbo')) {
      return _toRgboColor();
    }

    if (toLowerCase().startsWith('rgb')) {
      return _toArgbColor();
    }

    String? value;
    if (length == 10 && startsWith('0x')) {
      value = this;
    } else {
      value = startsWith('#') ? replaceAll('#', '') : this;
      if (value.length == 6) {
        value = '0xFF$value';
      } else if (value.length == 8) {
        value = '0x$value';
      }
    }

    final int? colorValue = int.tryParse(value);
    if (colorValue == null) {
      return null;
    }

    return Color(colorValue);
  }

  /// 转换为[MaterialColor]
  MaterialColor? toMaterialColor() {
    return _colorMap[this];
  }

  /// 转换为[MaterialAccentColor]
  MaterialAccentColor? toMaterialAccentColor() {
    return _accentColorMap[this];
  }

  /// 转换为时间
  DateTime? toDatetime({bool? isUtc}) {
    DateTime? dateTime = DateTime.tryParse(this);
    if (isUtc != null) {
      dateTime = dateTime?.toUtc();
    } else {
      dateTime = dateTime?.toLocal();
    }
    return dateTime;
  }

  /// 转换为格式化的时间
  String? toFormattedTime({String? format, bool? isUtc}) {
    return toDatetime(isUtc: isUtc)?.format(format);
  }

  /// 转换为时分秒
  TimeOfDay? toTime() {
    try {
      final Match? match = RegExp(r'(\d\d):(\d\d)').firstMatch(this);
      if (match == null) {
        return null;
      } else {
        return TimeOfDay(
          hour: int.parse(match[1]!),
          minute: int.parse(match[2]!),
        );
      }
    } on FormatException {
      return null;
    }
  }

  /// 转换为时间戳
  int? toDateMs() {
    final DateTime? dateTime = DateTime.tryParse(this);
    return dateTime?.millisecondsSinceEpoch;
  }

  /// 判断日期相同
  bool equalsDay(String? locDay) {
    return toDatetime()?.equalsDay(locDay?.toDatetime()) ?? false;
  }

  /// 是否是今天
  bool get isToday {
    return toDatetime()?.equalsDay(DateTime.now()) ?? false;
  }

  /// 检查字符串是否为视频文件名。
  bool get isVideoFileName {
    final String path = toLowerCase();

    return path.endsWith(".mp4") ||
        path.endsWith(".avi") ||
        path.endsWith(".wmv") ||
        path.endsWith(".rmvb") ||
        path.endsWith(".mpg") ||
        path.endsWith(".mpeg") ||
        path.endsWith(".3gp");
  }

  /// 检查字符串是否为图片文件名。
  bool get isImageFileName {
    final String path = toLowerCase();

    return path.endsWith(".jpg") ||
        path.endsWith(".jpeg") ||
        path.endsWith(".png") ||
        path.endsWith(".gif") ||
        path.endsWith(".bmp");
  }

  /// 检查字符串是否为音频文件名。
  bool get isAudioFileName {
    final String path = toLowerCase();

    return path.endsWith(".mp3") ||
        path.endsWith(".wav") ||
        path.endsWith(".wma") ||
        path.endsWith(".amr") ||
        path.endsWith(".ogg");
  }

  /// 检查字符串是否为PPT文件名。
  bool get isPPTFileName {
    final String path = toLowerCase();

    return path.endsWith(".ppt") || path.endsWith(".pptx");
  }

  /// 检查字符串是否为Word文件名。
  bool get isWordFileName {
    final String path = toLowerCase();

    return path.endsWith(".doc") || path.endsWith(".docx");
  }

  /// 检查字符串是否为Excel文件名。
  bool get isExcelFileName {
    final String path = toLowerCase();

    return path.endsWith(".xls") || path.endsWith(".xlsx");
  }

  /// 检查字符串是否为APK文件名。
  bool get isAPKFilename {
    return toLowerCase().endsWith(".apk");
  }

  /// 检查字符串是否为PDF文件名。
  bool get isPDFFileName {
    return toLowerCase().endsWith(".pdf");
  }

  /// 检查字符串是否为Txt文件名。
  bool get isTxtFileName {
    return toLowerCase().endsWith(".txt");
  }

  /// 检查字符串是否为Chm文件名。
  bool get isChmFileName {
    return toLowerCase().endsWith(".chm");
  }

  /// 检查字符串是否为Vector文件名。
  bool get isVectorFileName {
    return toLowerCase().endsWith(".svg");
  }

  /// 检查字符串是否为html文件名。
  bool get isHTMLFileName {
    return toLowerCase().endsWith(".html");
  }

  /// 检查字符串是否为3D文件名。
  bool get isThreeDFileName {
    return toLowerCase().endsWith(".max");
  }

  /// 检查字符串是否为WPS文件名。
  bool get isWPSFileName {
    return toLowerCase().endsWith(".wps");
  }

  /// 检查字符串是否为gif文件名。
  bool get isGifFileName {
    return toLowerCase().endsWith(".gif");
  }

  /// 检查字符串是否为cad文件名。
  bool get isCadFileName {
    final String path = toLowerCase();

    return path.endsWith(".dwg") ||
        path.endsWith(".bak") ||
        path.endsWith('.dwt');
  }

  /// 检查字符串是否为exe文件名。
  bool get isExeFileName {
    final String path = toLowerCase();

    return path.endsWith(".exe") || path.endsWith('.com');
  }

  /// 检查字符串是否为数据库文件名。
  bool get isDatabaseFileName {
    return toLowerCase().endsWith(".db");
  }

  /// 检查字符串是否为压缩文件名。
  bool get isCompressedFileName {
    final String path = toLowerCase();

    return path.endsWith(".rar") ||
        path.endsWith(".zip") ||
        path.endsWith('.arj') ||
        path.endsWith('.gz') ||
        path.endsWith('.z');
  }

  /// 检查字符串是否为配置文件名。
  bool get isConfigurationFileName {
    final String path = toLowerCase();

    return path.endsWith(".ini") ||
        path.endsWith(".conf") ||
        path.endsWith('.py') ||
        path.endsWith('.json');
  }

  /// 判断是否为网络地址
  bool get isNetworkUrl {
    final Uri? uri = Uri.tryParse(this);
    if (uri == null) {
      return false;
    }

    final String scheme = uri.scheme.toLowerCase();
    if (scheme == 'http' || scheme == 'https' || scheme == 'www') {
      return true;
    }

    return false;
  }

  /// 针对 Dart 字符串优化的 64 位哈希算法 FNV-1a
  int get fastHash {
    dynamic hash = BigInt.parse('0xcbf29ce484222325');

    var i = 0;
    while (i < length) {
      final codeUnit = codeUnitAt(i++);
      hash ^= codeUnit >> 8;
      hash *= 0x100000001b3;
      hash ^= codeUnit & 0xFF;
      hash *= 0x100000001b3;
    }

    return hash;
  }
}
