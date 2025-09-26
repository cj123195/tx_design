import 'int_extension.dart';

/// 日期时间范围格式化工具
class DateTimeFormatter {
  static const Map<String, String> defaultFormats = {
    'full': 'yyyy-MM-dd HH:mm:ss',
    'datetime': 'yyyy-MM-dd HH:mm',
    'slashDatetime': 'yyyy/MM/dd HH:mm',
    'date': 'yyyy-MM-dd',
    'slashDate': 'yyyy/MM/dd',
    'time': 'HH:mm:ss',
    'compact': 'yyyyMMdd',
    'shortDate': 'yy-MM-dd',
    'shortTime': 'HH:mm',
  };

  static String _twoDigitYear(int year) {
    final yearStr = year.toString().padLeft(4, '0');
    return yearStr.substring(yearStr.length - 2);
  }

  static String _formatDateTime(DateTime dateTime, String pattern) {
    final Map<String, dynamic> formatMap = {
      'yyyy': dateTime.year.toString().padLeft(4, '0'),
      'YYYY': dateTime.year.toString().padLeft(4, '0'),
      'yy': _twoDigitYear(dateTime.year),
      'YY': _twoDigitYear(dateTime.year),
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

    // 先按 key 长度从长到短替换，避免冲突
    formatMap.keys.toList()
      ..sort((a, b) => b.length.compareTo(a.length))
      ..forEach((key) {
        result = result.replaceAll(key, formatMap[key]!);
      });

    return result;
  }

  static String _getWeekName(int weekday) {
    const weeks = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    return weeks[weekday - 1];
  }
}

const Map<int, int> _kMonthDay = {
  1: 31,
  2: 28,
  3: 31,
  4: 30,
  5: 31,
  6: 30,
  7: 31,
  8: 31,
  9: 30,
  10: 31,
  11: 30,
  12: 31,
};

extension DatetimeExtension on DateTime {
  String format([String? format]) {
    format ??= 'full';

    // 如果是预定义格式，获取对应的格式字符串
    final pattern = DateTimeFormatter.defaultFormats[format] ?? format;

    return DateTimeFormatter._formatDateTime(this, pattern);
  }

  String formattedWeekday({String? languageCode = 'zh', bool short = false}) {
    late String weekday;
    switch (this.weekday) {
      case 1:
        weekday = languageCode == 'zh' ? '星期一' : "Monday";
        break;
      case 2:
        weekday = languageCode == 'zh' ? '星期二' : "Tuesday";
        break;
      case 3:
        weekday = languageCode == 'zh' ? '星期三' : "Wednesday";
        break;
      case 4:
        weekday = languageCode == 'zh' ? '星期四' : "Thursday";
        break;
      case 5:
        weekday = languageCode == 'zh' ? '星期五' : "Friday";
        break;
      case 6:
        weekday = languageCode == 'zh' ? '星期六' : "Saturday";
        break;
      case 7:
        weekday = languageCode == 'zh' ? '星期日' : "Sunday";
        break;
      default:
        break;
    }
    return languageCode == 'zh'
        ? (short ? weekday.replaceAll('星期', '周') : weekday)
        : weekday.substring(0, short ? 3 : weekday.length);
  }

  int get dayOfYear {
    final int year = this.year;
    final int month = this.month;
    int days = day;
    for (int i = 1; i < month; i++) {
      days = days + _kMonthDay[i]!;
    }
    if (year.isLeapYear && month > 2) {
      days = days + 1;
    }
    return days;
  }

  bool get isToday {
    return equalsDay(DateTime.now());
  }

  bool equalsDay(DateTime? locDateTime) {
    return locDateTime == null
        ? false
        : year == locDateTime.year &&
            month == locDateTime.month &&
            day == locDateTime.day;
  }

  bool isYesterday([DateTime? locDateTime]) {
    locDateTime ??= DateTime.now();
    if (equalsYear(locDateTime)) {
      final int spDay = locDateTime.dayOfYear - dayOfYear;
      return spDay == 1;
    } else {
      return (locDateTime.year - year == 1) &&
          month == 12 &&
          locDateTime.month == 1 &&
          day == 31 &&
          locDateTime.day == 1;
    }
  }

  bool get isThisYear {
    return equalsYear(DateTime.now());
  }

  bool get isThisMonth {
    return equalsYear(DateTime.now()) && DateTime.now().month == month;
  }

  bool equalsYear(DateTime? locDateTime) {
    return locDateTime == null ? false : year == locDateTime.year;
  }

  bool get isNight {
    final DateTime today = DateTime.now();
    final DateTime morning = DateTime(today.year, today.month, today.day, 5);
    final DateTime night = DateTime(today.year, today.month, today.day, 19);
    return isBefore(morning) || isAfter(night);
  }

  /// 减去年份
  DateTime subtractYears(int yearDifference) {
    final int year = this.year - yearDifference;
    final int day = this.day + 1;
    return DateTime(year, month, day);
  }

  /// 增加年份
  DateTime addYears(int yearDifference) {
    final int year = this.year + yearDifference;
    final int day = this.day - 1;
    return DateTime(year, month, day);
  }

  /// 减去月份
  DateTime subtractMonths(int monthDifference) {
    int yearDiff = monthDifference ~/ 12;
    final int monthDiff = monthDifference % 12;
    int month = this.month - monthDiff;
    if (month < 1) {
      yearDiff = yearDiff - 1;
      month = 12 + month;
    }
    final int year = this.year - yearDiff;
    final int day = this.day + 1;
    return DateTime(year, month, day);
  }

  /// 增加月份
  DateTime addMonths(int monthDifference) {
    int yearDiff = monthDifference ~/ 12;
    final int monthDiff = monthDifference % 12;
    int month = this.month + monthDiff;
    if (month > 12) {
      yearDiff = yearDiff + 1;
      month = month - 12;
    }
    final int year = this.year + yearDiff;
    final int day = this.day - 1;
    return DateTime(year, month, day);
  }

  /// 复制当前时间
  DateTime copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) {
    return DateTime(
      year ?? this.year,
      month ?? this.month,
      day ?? this.day,
      hour ?? this.hour,
      minute ?? this.minute,
      second ?? this.second,
      millisecond ?? this.millisecond,
      microsecond ?? this.microsecond,
    );
  }
}
