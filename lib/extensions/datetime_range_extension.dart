import 'package:flutter/material.dart';

/// 日期时间范围格式化工具
class DateTimeRangeFormatter {
  static const Map<String, String> _defaultFormats = {
    'full': 'yyyy-MM-dd HH:mm:ss',
    'datetime': 'yyyy-MM-dd HH:mm',
    'slashDatetime': 'yyyy/MM/dd HH:mm',
    'date': 'yyyy-MM-dd',
    'slashDate': 'yyyy/MM/dd',
    'time': 'HH:mm:ss',
    'compact': 'yyyyMMdd',
    'shortDate': 'yy-MM-dd',
  };

  static String _formatDateTime(DateTime dateTime, String pattern) {
    final Map<String, dynamic> formatMap = {
      'yyyy': dateTime.year.toString(),
      'YYYY': dateTime.year.toString(),
      'yy': dateTime.year.toString().substring(2),
      'YY': dateTime.year.toString().substring(2),
      'MM': dateTime.month.toString().padLeft(2, '0'),
      'M': dateTime.month.toString(),
      'dd': dateTime.day.toString().padLeft(2, '0'),
      'DD': dateTime.day.toString().padLeft(2, '0'),
      'd': dateTime.day.toString(),
      'D': dateTime.day.toString(),
      'hh': dateTime.hour.toString().padLeft(2, '0'),
      'HH': dateTime.hour.toString().padLeft(2, '0'),
      'h': dateTime.hour.toString(),
      'H': dateTime.hour.toString(),
      'mm': dateTime.minute.toString().padLeft(2, '0'),
      'm': dateTime.minute.toString(),
      'ss': dateTime.second.toString().padLeft(2, '0'),
      'SS': dateTime.second.toString().padLeft(2, '0'),
      's': dateTime.second.toString(),
      'SSS': dateTime.millisecond.toString().padLeft(3, '0'),
      'Q': ((dateTime.month - 1) ~/ 3 + 1).toString(),
      'W': dateTime.weekday.toString(),
      'WW': _getWeekName(dateTime.weekday),
    };

    String result = pattern;
    formatMap.forEach((key, value) {
      result = result.replaceAll(key, value);
    });
    return result;
  }

  static String _getWeekName(int weekday) {
    const weeks = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    return weeks[weekday - 1];
  }
}

extension DateTimeRangeExtension on DateTimeRange {
  /// 格式化日期时间范围
  /// [format] 可以是预定义格式的key，也可以是自定义格式字符串
  /// [separator] 开始时间和结束时间的分隔符
  /// 支持的格式：
  /// - yyyy/YYYY: 四位年份
  /// - yy/YY: 两位年份
  /// - MM: 两位月份
  /// - M: 一位月份
  /// - dd/DD: 两位日期
  /// - d/D: 一位日期
  /// - HH: 两位小时
  /// - H: 一位小时
  /// - mm: 两位分钟
  /// - m: 一位分钟
  /// - ss/SS: 两位秒
  /// - s: 一位秒
  /// - SSS: 三位毫秒
  /// - Q: 季度
  /// - W: 星期几(数字)
  /// - WW: 星期几(中文)
  String format({String? format, String? separator}) {
    format ??= 'full';
    separator ??= ' — ';

    // 如果是预定义格式，获取对应的格式字符串
    final pattern = DateTimeRangeFormatter._defaultFormats[format] ?? format;

    final startStr = DateTimeRangeFormatter._formatDateTime(start, pattern);
    final endStr = DateTimeRangeFormatter._formatDateTime(end, pattern);

    return '$startStr$separator$endStr';
  }

  /// 获取范围内的天数
  int get days => end.difference(start).inDays;

  /// 获取范围内的小时数
  int get hours => end.difference(start).inHours;

  /// 获取范围内的分钟数
  int get minutes => end.difference(start).inMinutes;

  /// 是否为同一天
  bool get isSameDay =>
      start.year == end.year &&
      start.month == end.month &&
      start.day == end.day;

  /// 是否为同一月
  bool get isSameMonth => start.year == end.year && start.month == end.month;
}
