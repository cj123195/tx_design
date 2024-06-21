import 'package:flutter/material.dart';

import 'datetime_extension.dart' show comFormat;

extension TimeOfDayExtension on TimeOfDay {
  /// 判断当前时间是否早于另一时间
  bool isBefore(TimeOfDay time) {
    if (hour < time.hour) {
      return true;
    }
    if (hour > time.hour) {
      return false;
    }
    return minute < time.minute;
  }

  /// 判断当前时间是否晚于另一时间
  bool isAfter(TimeOfDay time) {
    if (hour > time.hour) {
      return true;
    }
    if (hour < time.hour) {
      return false;
    }
    return minute > time.minute;
  }

  /// 是否为夜晚时间
  ///
  /// [sunrise] 日出时间，默认值为 TimeOfDay(hour: 6, minute: 0)
  /// [sunset] 日落时间，默认值为 TimeOfDay(hour: 18, minute: 0)
  bool isNight({TimeOfDay? sunrise, TimeOfDay? sunset}) {
    sunrise ??= const TimeOfDay(hour: 6, minute: 0);
    sunset ??= const TimeOfDay(hour: 18, minute: 0);
    return isBefore(sunrise) || isAfter(sunset);
  }

  /// 不使用本地化格式化
  String formatWithoutLocalization([String format = 'HH:mm']) {
    format = comFormat(hour, format, 'H', 'HH');
    format = comFormat(minute, format, 'm', 'mm');
    return format;
  }

  /// 转换为 DateTime
  ///
  /// [date] 日期，年月日形式
  DateTime toDateTime([DateTime? date]) {
    date ??= DateTime.now();
    return DateTime(date.year, date.month, date.day, hour, minute);
  }
}
