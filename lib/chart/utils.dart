import 'dart:math' as math;
import 'dart:math';

import 'package:flutter/material.dart';

class ChartUtils {
  factory ChartUtils() {
    return _singleton;
  }

  ChartUtils._internal();

  static ChartUtils _singleton = ChartUtils._internal();

  @visibleForTesting
  static void changeInstance(ChartUtils val) => _singleton = val;

  static const double _degrees2Radians = math.pi / 180.0;

  /// 将度数转换为弧度
  double radians(double degrees) => degrees * _degrees2Radians;

  static const double _radians2Degrees = 180.0 / math.pi;

  /// 将弧度转换为度
  double degrees(double radians) => radians * _radians2Degrees;

  /// 返回基于屏幕大小的默认大小，即基于屏幕缩放的 70% 正方形。
  Size getDefaultSize(Size screenSize) {
    Size resultSize;
    if (screenSize.width < screenSize.height) {
      resultSize = Size(screenSize.width, screenSize.width);
    } else if (screenSize.height < screenSize.width) {
      resultSize = Size(screenSize.height, screenSize.height);
    } else {
      resultSize = Size(screenSize.width, screenSize.height);
    }
    return resultSize * 0.7;
  }

  /// 根据视图的程度转发视图
  double translateRotatedPosition(double size, double degree) {
    return (size / 4) * math.sin(radians(degree.abs()));
  }

  Offset calculateRotationOffset(Size size, double degree) {
    final rotatedHeight = (size.width * math.sin(radians(degree))).abs() +
        (size.height * cos(radians(degree))).abs();
    final rotatedWidth = (size.width * cos(radians(degree))).abs() +
        (size.height * sin(radians(degree))).abs();
    return Offset(
      (size.width - rotatedWidth) / 2,
      (size.height - rotatedHeight) / 2,
    );
  }

  /// 将 [borderRadius] 减小到 <= 宽度 / 2
  BorderRadius? normalizeBorderRadius(
    BorderRadius? borderRadius,
    double width,
  ) {
    if (borderRadius == null) {
      return null;
    }

    Radius topLeft;
    if (borderRadius.topLeft.x > width / 2 ||
        borderRadius.topLeft.y > width / 2) {
      topLeft = Radius.circular(width / 2);
    } else {
      topLeft = borderRadius.topLeft;
    }

    Radius topRight;
    if (borderRadius.topRight.x > width / 2 ||
        borderRadius.topRight.y > width / 2) {
      topRight = Radius.circular(width / 2);
    } else {
      topRight = borderRadius.topRight;
    }

    Radius bottomLeft;
    if (borderRadius.bottomLeft.x > width / 2 ||
        borderRadius.bottomLeft.y > width / 2) {
      bottomLeft = Radius.circular(width / 2);
    } else {
      bottomLeft = borderRadius.bottomLeft;
    }

    Radius bottomRight;
    if (borderRadius.bottomRight.x > width / 2 ||
        borderRadius.bottomRight.y > width / 2) {
      bottomRight = Radius.circular(width / 2);
    } else {
      bottomRight = borderRadius.bottomRight;
    }

    return BorderRadius.only(
      topLeft: topLeft,
      topRight: topRight,
      bottomLeft: bottomLeft,
      bottomRight: bottomRight,
    );
  }

  /// borderSide 的默认值，其中 borderSide 值不存在
  static const BorderSide defaultBorderSide = BorderSide(width: 0);

  /// 将 [borderSide] 减小到 <= 宽度 / 2
  BorderSide normalizeBorderSide(BorderSide? borderSide, double width) {
    if (borderSide == null) {
      return defaultBorderSide;
    }

    double borderWidth;
    if (borderSide.width > width / 2) {
      borderWidth = width / 2.toDouble();
    } else {
      borderWidth = borderSide.width;
    }

    return borderSide.copyWith(width: borderWidth);
  }

  /// 返回用于显示轴标题、网格线或...
  ///
  /// 如果没有提供任何间隔，我们使用此函数来计算要应用的间隔，
  /// 使用 [axisViewSize] / [pixelPerInterval]，我们计算轴中的 allowedCount 行，
  /// 然后使用 [diffInAxis] / allowedCount，我们可以找出我们需要多少间隔，
  /// 然后，我们通过在此模式中找到最接近的数字来舍入该数字：
  /// 1, 2, 5, 10, 20, 50, 100, 200, 500, 1000, 5000, 10000,...
  double getEfficientInterval(
    double axisViewSize,
    double diffInAxis, {
    double pixelPerInterval = 40,
  }) {
    final allowedCount = math.max(axisViewSize ~/ pixelPerInterval, 1);
    if (diffInAxis == 0) {
      return 1;
    }
    final accurateInterval =
        diffInAxis == 0 ? axisViewSize : diffInAxis / allowedCount;
    if (allowedCount <= 2) {
      return accurateInterval;
    }
    return roundInterval(accurateInterval);
  }

  @visibleForTesting
  double roundInterval(double input) {
    if (input < 1) {
      return _roundIntervalBelowOne(input);
    }
    return _roundIntervalAboveOne(input);
  }

  double _roundIntervalBelowOne(double input) {
    assert(input < 1.0);

    if (input < 0.000001) {
      return input;
    }

    final inputString = input.toString();
    var precisionCount = inputString.length - 2;

    var zeroCount = 0;
    for (var i = 2; i <= inputString.length; i++) {
      if (inputString[i] != '0') {
        break;
      }
      zeroCount++;
    }

    final afterZerosNumberLength = precisionCount - zeroCount;
    if (afterZerosNumberLength > 2) {
      final numbersToRemove = afterZerosNumberLength - 2;
      precisionCount -= numbersToRemove;
    }

    final pow10onPrecision = pow(10, precisionCount);
    input *= pow10onPrecision;
    return _roundIntervalAboveOne(input) / pow10onPrecision;
  }

  double _roundIntervalAboveOne(double input) {
    assert(input >= 1.0);
    final decimalCount = input.toInt().toString().length - 1;
    input /= pow(10, decimalCount);

    final scaled = input >= 10 ? input.round() / 10 : input;

    if (scaled >= 7.6) {
      return 10 * pow(10, decimalCount).toInt().toDouble();
    } else if (scaled >= 2.6) {
      return 5 * pow(10, decimalCount).toInt().toDouble();
    } else if (scaled >= 1.6) {
      return 2 * pow(10, decimalCount).toInt().toDouble();
    } else {
      return 1 * pow(10, decimalCount).toInt().toDouble();
    }
  }

  /// 短期内亿数 (https://en.wikipedia.org/wiki/Billion)
  static const double billion = 1000000000;

  /// 百万数字
  static const double million = 1000000;

  /// 千（千）数
  static const double kilo = 1000;

  /// 返回值的小数位数计数
  int getFractionDigits(double value) {
    if (value >= 1) {
      return 1;
    } else if (value >= 0.1) {
      return 2;
    } else if (value >= 0.01) {
      return 3;
    } else if (value >= 0.001) {
      return 4;
    } else if (value >= 0.0001) {
      return 5;
    } else if (value >= 0.00001) {
      return 6;
    } else if (value >= 0.000001) {
      return 7;
    } else if (value >= 0.0000001) {
      return 8;
    } else if (value >= 0.00000001) {
      return 9;
    } else if (value >= 0.000000001) {
      return 10;
    }
    return 1;
  }

  /// 格式化并在数字末尾添加符号（K、M、B）。
  ///
  /// 如果 number 大于 [billion]，则返回一个短数字，如 13.3B，
  /// 如果 number 大于 [million]，则返回一个短数字行 43M，
  /// if number 大于 [kilo]，则返回一个短数字，如 4K，
  /// 否则，它将返回数字本身。
  /// 此外，为了简单起见，它删除了数字末尾的 .0。
  String formatNumber(double axisMin, double axisMax, double axisValue) {
    final isNegative = axisValue < 0;

    if (isNegative) {
      axisValue = axisValue.abs();
    }

    String resultNumber;
    String symbol;
    if (axisValue >= billion) {
      resultNumber = (axisValue / billion).toStringAsFixed(1);
      symbol = 'B';
    } else if (axisValue >= million) {
      resultNumber = (axisValue / million).toStringAsFixed(1);
      symbol = 'M';
    } else if (axisValue >= kilo) {
      resultNumber = (axisValue / kilo).toStringAsFixed(1);
      symbol = 'K';
    } else {
      final diff = (axisMin - axisMax).abs();
      resultNumber = axisValue.toStringAsFixed(
        getFractionDigits(diff),
      );
      symbol = '';
    }

    if (resultNumber.endsWith('.0')) {
      resultNumber = resultNumber.substring(0, resultNumber.length - 2);
    }

    if (isNegative) {
      resultNumber = '-$resultNumber';
    }

    if (resultNumber == '-0') {
      resultNumber = '0';
    }

    return resultNumber + symbol;
  }

  /// 根据提供的 [context] 返回一个 TextStyle，如果 [providedStyle] 提供我们尝试合并它。
  TextStyle getThemeAwareTextStyle(
    BuildContext context,
    TextStyle? providedStyle,
  ) {
    final TextStyle defaultTextStyle = DefaultTextStyle.of(context)
        .style
        .copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer);
    var effectiveTextStyle = providedStyle;
    if (providedStyle == null || providedStyle.inherit) {
      effectiveTextStyle = defaultTextStyle.merge(providedStyle);
    }
    if (MediaQuery.boldTextOf(context)) {
      effectiveTextStyle = effectiveTextStyle!
          .merge(const TextStyle(fontWeight: FontWeight.bold));
    }
    return effectiveTextStyle!;
  }

  /// 找到最佳初始间隔值
  ///
  /// 如果轴上有一个零点，我们就是一个通过它的值。
  /// 例如，如果我们有 -3 到 +3，间隔为 2。如果我们从 -3 开始，我们得到如下结果：-3、-1、+1、+3
  /// 但在大多数情况下，最重要的一点是零。通过这个逻辑，我们得到：-2， 0， 2
  double getBestInitialIntervalValue(
    double min,
    double max,
    double interval, {
    double baseline = 0.0,
  }) {
    final diff = baseline - min;
    final mod = diff % interval;
    if ((max - min).abs() <= mod) {
      return min;
    }
    if (mod == 0) {
      return min;
    }
    return min + mod;
  }

  /// 将半径数转换为西格玛以绘制阴影
  double convertRadiusToSigma(double radius) {
    return radius * 0.57735 + 0.5;
  }
}
