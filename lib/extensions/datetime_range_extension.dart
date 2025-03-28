import 'package:flutter/material.dart';

import 'datetime_extension.dart';

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
    separator ??= ' — ';

    final startStr = start.format(format);
    final endStr = end.format(format);

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
