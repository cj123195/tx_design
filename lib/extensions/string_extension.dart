import 'package:flutter/material.dart';

import 'datetime_extension.dart';
import 'time_of_day_extension.dart';

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
  DateTime? toDatetime({bool? isUtc, String? format}) {
    // 尝试使用标准解析
    DateTime? dateTime = DateTime.tryParse(this);

    // 如果标准解析失败，尝试使用自定义格式解析
    if (dateTime == null && format != null) {
      dateTime = _parseDateTime(this, format);
    } else if (dateTime == null) {
      // 尝试使用预定义格式解析
      for (final formatPattern in DateTimeFormatter.defaultFormats.values) {
        dateTime = _parseDateTime(this, formatPattern);
        if (dateTime != null) {
          break;
        }
      }
    }

    // 处理时区
    if (dateTime != null) {
      if (isUtc == true) {
        dateTime = dateTime.toUtc();
      } else if (isUtc == false) {
        dateTime = dateTime.toLocal();
      }
    }

    return dateTime;
  }

  /// 根据格式解析日期时间字符串
  DateTime? _parseDateTime(String dateStr, String format) {
    try {
      // 构建正则表达式模式
      String pattern = '';
      final List<String> formatTokens = [];

      // 逐字符处理格式字符串
      int i = 0;
      while (i < format.length) {
        if (i + 4 <= format.length &&
            (format.substring(i, i + 4) == 'yyyy' ||
                format.substring(i, i + 4) == 'YYYY')) {
          pattern += r'(\d{4})';
          formatTokens.add('yyyy');
          i += 4;
        } else if (i + 2 <= format.length &&
            (format.substring(i, i + 2) == 'yy' ||
                format.substring(i, i + 2) == 'YY')) {
          pattern += r'(\d{2})';
          formatTokens.add('yy');
          i += 2;
        } else if (i + 2 <= format.length &&
            format.substring(i, i + 2) == 'MM') {
          pattern += r'(\d{2})';
          formatTokens.add('MM');
          i += 2;
        } else if (i + 1 <= format.length &&
            format.substring(i, i + 1) == 'M') {
          pattern += r'(\d{1,2})';
          formatTokens.add('M');
          i += 1;
        } else if (i + 2 <= format.length &&
            (format.substring(i, i + 2) == 'dd' ||
                format.substring(i, i + 2) == 'DD')) {
          pattern += r'(\d{2})';
          formatTokens.add('dd');
          i += 2;
        } else if (i + 1 <= format.length &&
            (format.substring(i, i + 1) == 'd' ||
                format.substring(i, i + 1) == 'D')) {
          pattern += r'(\d{1,2})';
          formatTokens.add('d');
          i += 1;
        } else if (i + 2 <= format.length &&
            (format.substring(i, i + 2) == 'HH' ||
                format.substring(i, i + 2) == 'hh')) {
          pattern += r'(\d{2})';
          formatTokens.add('HH');
          i += 2;
        } else if (i + 1 <= format.length &&
            (format.substring(i, i + 1) == 'H' ||
                format.substring(i, i + 1) == 'h')) {
          pattern += r'(\d{1,2})';
          formatTokens.add('H');
          i += 1;
        } else if (i + 2 <= format.length &&
            format.substring(i, i + 2) == 'mm') {
          pattern += r'(\d{2})';
          formatTokens.add('mm');
          i += 2;
        } else if (i + 1 <= format.length &&
            format.substring(i, i + 1) == 'm') {
          pattern += r'(\d{1,2})';
          formatTokens.add('m');
          i += 1;
        } else if (i + 2 <= format.length &&
            (format.substring(i, i + 2) == 'ss' ||
                format.substring(i, i + 2) == 'SS')) {
          pattern += r'(\d{2})';
          formatTokens.add('ss');
          i += 2;
        } else if (i + 1 <= format.length &&
            format.substring(i, i + 1) == 's') {
          pattern += r'(\d{1,2})';
          formatTokens.add('s');
          i += 1;
        } else if (i + 3 <= format.length &&
            format.substring(i, i + 3) == 'SSS') {
          pattern += r'(\d{3})';
          formatTokens.add('SSS');
          i += 3;
        } else {
          // 转义特殊字符
          final char = format[i];
          if ('.-:/ '.contains(char)) {
            pattern += '\\$char';
          } else {
            pattern += char;
          }
          i += 1;
        }
      }

      final RegExp regExp = RegExp('^$pattern\$');
      final Match? match = regExp.firstMatch(dateStr);

      if (match == null) {
        return null;
      }

      // 设置默认值
      int year = DateTime.now().year;
      int month = 1;
      int day = 1;
      int hour = 0;
      int minute = 0;
      int second = 0;
      int millisecond = 0;

      // 根据匹配的格式标记提取值
      for (int i = 0; i < formatTokens.length; i++) {
        final token = formatTokens[i];
        final value = match.group(i + 1);

        if (value == null) {
          continue;
        }

        if (token == 'yyyy') {
          year = int.parse(value);
        } else if (token == 'yy') {
          final DateTime now = DateTime.now();
          year = int.parse('${now.year.toString().substring(0, 2)}$value');
        } else if (token == 'MM' || token == 'M') {
          month = int.parse(value);
        } else if (token == 'dd' || token == 'd') {
          day = int.parse(value);
        } else if (token == 'HH' || token == 'H') {
          hour = int.parse(value);
        } else if (token == 'mm' || token == 'm') {
          minute = int.parse(value);
        } else if (token == 'ss' || token == 's') {
          second = int.parse(value);
        } else if (token == 'SSS') {
          millisecond = int.parse(value);
        }
      }

      return DateTime(year, month, day, hour, minute, second, millisecond);
    } catch (e) {
      return null;
    }
  }

  /// 转换为格式化的时间
  String? toFormattedTime({String? format, bool? isUtc}) {
    return toDatetime(isUtc: isUtc, format: format)?.format(format);
  }

  /// 转换为时分秒
  TimeOfDay? toTime([String? format]) {
    if (format != null) {
      return _parseTime(this, format);
    }
    try {
      return _parseTime(this, format ?? TimeOfDayFormatter.defaultFormat);
    } on FormatException {
      return null;
    }
  }

  /// 根据格式解析日期时间字符串
  TimeOfDay? _parseTime(String dateStr, String format) {
    try {
      // 替换格式中的特殊字符为正则表达式
      String pattern = format
          .replaceAll('HH', r'(\d{2})')
          .replaceAll('hh', r'(\d{2})')
          .replaceAll('H', r'(\d{1,2})')
          .replaceAll('h', r'(\d{1,2})')
          .replaceAll('mm', r'(\d{2})')
          .replaceAll('m', r'(\d{1,2})');

      // 转义特殊字符
      pattern = pattern
          .replaceAll('/', r'\/')
          .replaceAll('.', r'\.')
          .replaceAll('-', r'\-')
          .replaceAll(':', r'\:')
          .replaceAll(' ', r'\s');

      final RegExp regExp = RegExp('^$pattern\$');
      final Match? match = regExp.firstMatch(dateStr);

      if (match == null) {
        return null;
      }

      // 提取年月日时分秒
      int hour = 0, minute = 0;

      int groupIndex = 1;
      if (format.contains('HH') || format.contains('hh')) {
        hour = int.parse(match.group(groupIndex++)!);
      } else if (format.contains('H') || format.contains('h')) {
        hour = int.parse(match.group(groupIndex++)!);
      }

      if (format.contains('mm')) {
        minute = int.parse(match.group(groupIndex++)!);
      } else if (format.contains('m')) {
        minute = int.parse(match.group(groupIndex++)!);
      }

      return TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
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
