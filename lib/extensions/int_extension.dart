import 'datetime_extension.dart';

extension TxIntExtension on int {
  /// Return whether it is leap year.
  /// 是否是闰年
  bool get isLeapYear {
    return this % 4 == 0 && this % 100 != 0 || this % 400 == 0;
  }

  /// is today.
  /// 是否是当天.
  bool isToday({bool isUtc = false, int? locMs}) {
    final DateTime old = toDatetime(isUtc: isUtc);
    DateTime now;
    if (locMs != null) {
      now = DateTime.fromMillisecondsSinceEpoch(locMs, isUtc: isUtc);
    } else {
      now = isUtc ? DateTime.now().toUtc() : DateTime.now().toLocal();
    }
    return old.year == now.year && old.month == now.month && old.day == now.day;
  }

  /// get weekDay By Milliseconds
  /// 根据时间戳获取工作日
  String? toWeekday(
      {bool isUtc = false, String? languageCode, bool short = false}) {
    final DateTime dateTime = toDatetime(isUtc: isUtc);
    return dateTime.formattedWeekday(languageCode: languageCode, short: short);
  }

  /// get DateTime By Milliseconds.
  /// 根据时间戳获取时间
  DateTime toDatetime({bool isUtc = false}) {
    return DateTime.fromMillisecondsSinceEpoch(this, isUtc: isUtc);
  }

  /// format Date By Milliseconds.
  /// 根据时间戳格式化时间
  String toFormattedDatetime({bool isUtc = false, String? format}) {
    return toDatetime(isUtc: isUtc).format(format);
  }

  /// is yesterday by Milliseconds.
  /// 是否是昨天
  bool isYesterdayByMs([int? locMs]) {
    return toDatetime().isYesterday(locMs?.toDatetime());
  }

  /// is Week.
  //  是否是本周
  bool equalsWeek({bool isUtc = false, int? locMs}) {
    if (this <= 0) {
      return false;
    }
    DateTime old = toDatetime(isUtc: isUtc);
    DateTime now;
    if (locMs != null) {
      now = locMs.toDatetime(isUtc: isUtc);
    } else {
      now = isUtc ? DateTime.now().toUtc() : DateTime.now().toLocal();
    }

    old = now.millisecondsSinceEpoch > old.millisecondsSinceEpoch ? old : now;
    now = now.millisecondsSinceEpoch > old.millisecondsSinceEpoch ? now : old;
    return (now.weekday >= old.weekday) &&
        (now.millisecondsSinceEpoch - old.millisecondsSinceEpoch <=
            7 * 24 * 60 * 60 * 1000);
  }

  /// is Week.
  //  是否是本年
  bool equalsYear([int? locMs]) {
    return toDatetime().equalsYear(locMs?.toDatetime());
  }

  /// 获取文档大小
  String sizeFormat() {
    double res = this / 1024.0;
    if (res < 1024) {
      return '${res.toStringAsFixed(1)}KB';
    } else {
      res = res / 1024;
    }
    if (res < 1024) {
      return '${res.toStringAsFixed(1)}MB';
    } else {
      return '${(res / 1024).toStringAsFixed(2)}GB';
    }
  }
}
