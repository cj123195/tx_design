import 'package:flutter/material.dart';

import 'datetime_extension.dart' show comFormat;

extension TimeOfDayExtension on TimeOfDay {
  bool isBefore(TimeOfDay time) {
    if (hour < time.hour) {
      return true;
    }
    if (hour > time.hour) {
      return false;
    }
    return minute < time.minute;
  }

  bool isAfter(TimeOfDay time) {
    if (hour > time.hour) {
      return true;
    }
    if (hour < time.hour) {
      return false;
    }
    return minute > time.minute;
  }

  bool isNight({TimeOfDay? sunrise, TimeOfDay? sunset}) {
    sunrise ??= const TimeOfDay(hour: 6, minute: 0);
    sunset ??= const TimeOfDay(hour: 18, minute: 0);
    return isBefore(sunrise) || isAfter(sunset);
  }

  String formatWithoutLocalization([String format = 'HH:mm']) {
    format = comFormat(hour, format, 'H', 'HH');
    format = comFormat(minute, format, 'm', 'mm');
    return format;
  }
}
