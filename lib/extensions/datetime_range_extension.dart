import 'package:flutter/material.dart';

String _comFormat(int value, String format, String single, String full) {
  if (format.contains(single)) {
    if (format.contains(full)) {
      format =
          format.replaceFirst(full, value < 10 ? '0$value' : value.toString());
    } else {
      format = format.replaceFirst(single, value.toString());
    }
  }
  return format;
}

extension DateTimeRangeExtension on DateTimeRange {
  String format([String? format]) {
    format ??= 'yyyy/MM/dd\t——\tyyyy/MM/dd';

    if (format.contains("yy")) {
      final String startYear = start.year.toString();
      final String endYear = end.year.toString();
      if (format.contains("yyyy")) {
        format = format.replaceFirst("yyyy", startYear);
        format = format.replaceAll("yyyy", endYear);
      } else {
        format = format.replaceFirst(
          "yy",
          startYear.substring(startYear.length - 2, startYear.length),
        );
        format = format.replaceAll(
          "yy",
          endYear.substring(endYear.length - 2, endYear.length),
        );
      }
    }

    format = _comFormat(start.month, format, 'M', 'MM');
    format = _comFormat(start.day, format, 'd', 'dd');
    format = _comFormat(start.hour, format, 'H', 'HH');
    format = _comFormat(start.minute, format, 'm', 'mm');
    format = _comFormat(start.second, format, 's', 'ss');
    format = _comFormat(start.millisecond, format, 'S', 'SSS');

    format = _comFormat(end.month, format, 'M', 'MM');
    format = _comFormat(end.day, format, 'd', 'dd');
    format = _comFormat(end.hour, format, 'H', 'HH');
    format = _comFormat(end.minute, format, 'm', 'mm');
    format = _comFormat(end.second, format, 's', 'ss');
    format = _comFormat(end.millisecond, format, 'S', 'SSS');

    return format;
  }
}
