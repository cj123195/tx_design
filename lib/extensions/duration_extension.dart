import 'package:flutter/material.dart';

import '../localizations.dart';

extension DurationExtension on Duration {
  /// 本地化
  String localize(BuildContext context) {
    final TxLocalizations localizations = TxLocalizations.of(context);
    String? result;
    if (inDays != 0) {
      result = localizations.daysLabel(inDays);
    }

    final int hours = inSeconds ~/ Duration.secondsPerHour;
    final String hourString = localizations.hoursLabel(hours);
    if (hours != 0 || result != null) {
      result = '${result ?? ''}$hourString';
    }

    final int minutes = inSeconds ~/ Duration.secondsPerMinute;
    final String minutesString = localizations.minutesLabel(minutes);
    if (minutes != 0 || result != null) {
      result = '${result ?? ''}$minutesString';
    }

    final int seconds = inSeconds % Duration.secondsPerMinute;
    final String secondsString = localizations.secondsLabel(seconds);
    if (result != null && seconds == 0) {
      return result;
    }
    result = '${result ?? ''}$secondsString';
    return result;
  }

  /// 格式化
  String format() {
    String text;
    final int total = inSeconds;
    final int second = total % 60;
    text = _formatNum(second);
    int minute = total ~/ 60;
    if (minute > 60) {
      minute = minute % 60;
      text = '${_formatNum(minute)}:$text';
      final int hour = minute ~/ 60;
      text = '$hour:$text';
    } else {
      text = '${_formatNum(minute)}:$text';
    }
    return text;
  }

  String _formatNum(int num) {
    return num < 10 ? '0$num' : num.toString();
  }
}
