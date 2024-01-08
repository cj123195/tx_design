import 'package:flutter/painting.dart';

/// Extensions on [Gradient]
extension GradientExtension on Gradient {
  /// 返回colorStops
  ///
  /// 如果提供了 [stops]，则直接返回，否则我们使用颜色列表计算它
  List<double> getSafeColorStops() {
    var resultStops = <double>[];
    if (stops == null || stops!.length != colors.length) {
      if (colors.length > 1) {
        /// provided colorStops is invalid and we calculate it here
        colors.asMap().forEach((index, color) {
          final percent = 1.0 / (colors.length - 1);
          resultStops.add(percent * index);
        });
      } else {
        throw ArgumentError('"colors" must have length > 1.');
      }
    } else {
      resultStops = stops!;
    }
    return resultStops;
  }
}
