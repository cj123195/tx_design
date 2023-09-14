import 'int_extension.dart';

String comFormat(int value, String format, String single, String full) {
  if (format.contains(single)) {
    if (format.contains(full)) {
      format =
          format.replaceAll(full, value < 10 ? '0$value' : value.toString());
    } else {
      format = format.replaceAll(single, value.toString());
    }
  }
  return format;
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
    format ??= 'yyyy-MM-dd HH:mm:ss';
    if (format.contains("yy")) {
      final String year = this.year.toString();
      if (format.contains("yyyy")) {
        format = format.replaceAll("yyyy", year);
      } else {
        format = format.replaceAll(
            "yy", year.substring(year.length - 2, year.length));
      }
    }

    format = comFormat(month, format, 'M', 'MM');
    format = comFormat(day, format, 'd', 'dd');
    format = comFormat(hour, format, 'H', 'HH');
    format = comFormat(minute, format, 'm', 'mm');
    format = comFormat(second, format, 's', 'ss');
    format = comFormat(millisecond, format, 'S', 'SSS');

    return format;
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
}
