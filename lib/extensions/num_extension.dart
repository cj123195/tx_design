/// num 类型拓展
extension NumExtension on num {
  /// 只能的转换为String类型并保留给定位数的小数部分，当小数部分为0时，则只保留整数部分。
  String toCompactFixed([int fractionDigits = 0]) {
    assert(
      fractionDigits >= 0 && fractionDigits <= 20,
      'fractionDigits 必须在 0~20 之间',
    );

    if (fractionDigits == 0 || this % 1 == 0) {
      return toStringAsFixed(0);
    }

    return toStringAsFixed(fractionDigits);
  }
}
