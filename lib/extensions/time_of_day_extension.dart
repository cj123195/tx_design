import 'package:flutter/material.dart';

/// 日期时间范围格式化工具
class TimeOfDayFormatter {
  static const String defaultFormat = 'HH:mm';

  static String _formatTime(TimeOfDay time, String? pattern) {
    pattern ??= defaultFormat;

    final Map<String, dynamic> formatMap = {
      'hh': time.hour.toString().padLeft(2, '0'),
      'HH': time.hour.toString().padLeft(2, '0'),
      'h': time.hour.toString(),
      'H': time.hour.toString(),
      'mm': time.minute.toString().padLeft(2, '0'),
      'm': time.minute.toString(),
    };

    String result = pattern;
    formatMap.forEach((key, value) {
      result = result.replaceAll(key, value);
    });
    return result;
  }
}

extension TxTimeOfDayExtension on TimeOfDay {
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

  /// 判断时间差
  Duration difference(TimeOfDay other) {
    final Duration hoursDuration = Duration(hours: hour - other.hour);
    final Duration minutesDuration = Duration(minutes: minute - other.hour);
    return hoursDuration + minutesDuration;
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
  String formatWithoutLocalization([String? format]) {
    return TimeOfDayFormatter._formatTime(this, format);
  }

  /// 转换为 DateTime
  ///
  /// [date] 日期，年月日形式
  DateTime toDateTime([DateTime? date]) {
    date ??= DateTime.now();
    return DateTime(date.year, date.month, date.day, hour, minute);
  }
}
