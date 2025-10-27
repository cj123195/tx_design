import 'package:flutter/material.dart';

import '../localizations.dart';

extension TxDurationExtension on Duration {
  /// 本地化
  String localize(BuildContext context) {
    final TxLocalizations localizations = TxLocalizations.of(context);
    String? result;
    if (inDays != 0) {
      result = localizations.daysLabel(inDays);
    }

    final int hours = inHours % Duration.hoursPerDay;
    final String hourString = localizations.hoursLabel(hours);
    if (hours != 0 || result != null) {
      result = '${result ?? ''}$hourString';
    }

    final int minutes = inMinutes % Duration.minutesPerHour;
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
  /// format 支持的格式：
  /// - HH: 两位小时
  /// - H: 一位小时
  /// - mm: 两位分钟
  /// - m: 一位分钟
  /// - ss: 两位秒
  /// - s: 一位秒
  String format([String pattern = 'HH:mm:ss']) {
    final int days = inDays;
    final int hours = inHours % Duration.hoursPerDay;
    final int minutes = inMinutes % Duration.minutesPerHour;
    final int seconds = inSeconds % Duration.secondsPerMinute;

    String result = pattern.toLowerCase();

    // 处理天
    if (days != 0 && result.contains('d')) {
      result = result.replaceAll('dd', days.toString());
      result = result.replaceAll('d', days.toString());
    } else {
      final index = result.indexOf('h');
      if (index != -1) {
        result = result.substring(index);
      }
    }

    // 处理小时
    if (hours != 0 && result.contains('h')) {
      if (result.contains('hh')) {
        result = result.replaceAll('hh', _formatNum(hours));
      } else if (result.contains('h')) {
        result = result.replaceAll('h', hours.toString());
      }
    } else {
      final index = result.indexOf('m');
      if (index != -1) {
        result = result.substring(index);
      }
    }

    // 处理分钟
    if (result.contains('mm')) {
      result = result.replaceAll('mm', _formatNum(minutes));
    } else if (result.contains('m')) {
      result = result.replaceAll('m', minutes.toString());
    }

    // 处理秒
    if (result.contains('ss')) {
      result = result.replaceAll('ss', _formatNum(seconds));
    } else if (result.contains('s')) {
      result = result.replaceAll('s', seconds.toString());
    }

    return result;
  }

  String _formatNum(int num) {
    return num < 10 ? '0$num' : num.toString();
  }
}
