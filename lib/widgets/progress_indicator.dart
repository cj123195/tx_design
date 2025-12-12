import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const int _kIndeterminateLinearDuration = 1800;

/// 线性渐变进度指示器
class _LinearGradientProgressIndicatorPainter extends CustomPainter {
  const _LinearGradientProgressIndicatorPainter({
    required this.backgroundColor,
    required this.valueColor,
    required this.animationValue,
    required this.textDirection,
    this.value,
    this.radius,
    this.showValueText = false,
    this.textStyle,
  });

  final Color backgroundColor;
  final LinearGradient valueColor;
  final double? value;
  final double animationValue;
  final TextDirection textDirection;
  final Radius? radius;
  final bool showValueText;
  final TextStyle? textStyle;

  static const Curve line1Head = Interval(
    0.0,
    750.0 / _kIndeterminateLinearDuration,
    curve: Cubic(0.2, 0.0, 0.8, 1.0),
  );
  static const Curve line1Tail = Interval(
    333.0 / _kIndeterminateLinearDuration,
    (333.0 + 750.0) / _kIndeterminateLinearDuration,
    curve: Cubic(0.4, 0.0, 1.0, 1.0),
  );
  static const Curve line2Head = Interval(
    1000.0 / _kIndeterminateLinearDuration,
    (1000.0 + 567.0) / _kIndeterminateLinearDuration,
    curve: Cubic(0.0, 0.0, 0.65, 1.0),
  );
  static const Curve line2Tail = Interval(
    1267.0 / _kIndeterminateLinearDuration,
    (1267.0 + 533.0) / _kIndeterminateLinearDuration,
    curve: Cubic(0.10, 0.0, 0.45, 1.0),
  );

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    if (radius == null) {
      canvas.drawRect(Offset.zero & size, paint);
    } else {
      final RRect rRect = RRect.fromRectAndRadius(Offset.zero & size, radius!);
      canvas.drawRRect(rRect, paint);
    }

    void drawBar(double x, double width) {
      if (width <= 0.0) {
        return;
      }

      final double left;
      switch (textDirection) {
        case TextDirection.rtl:
          left = size.width - width - x;
          break;
        case TextDirection.ltr:
          left = x;
          break;
      }
      final Rect rect = Offset(left, 0.0) & Size(width, size.height);
      paint.shader = valueColor.createShader(rect);
      if (radius == null) {
        canvas.drawRect(rect, paint);
      } else {
        canvas.drawRRect(RRect.fromRectAndRadius(rect, radius!), paint);
      }
    }

    if (value != null) {
      final double valueWidth = clampDouble(value!, 0.0, 1.0) * size.width;
      drawBar(0.0, valueWidth);

      if (showValueText) {
        final TextPainter textPainter = TextPainter(
          text: TextSpan(text: '${(value! * 100).toInt()}%', style: textStyle),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout(minWidth: 0, maxWidth: valueWidth);
        final double offsetX = valueWidth - textPainter.width - 12.0;
        final double offsetY = (size.height - textPainter.height) / 2;
        textPainter.paint(canvas, Offset(offsetX, offsetY));
      }
    } else {
      final double x1 = size.width * line1Tail.transform(animationValue);
      final double width1 =
          size.width * line1Head.transform(animationValue) - x1;

      final double x2 = size.width * line2Tail.transform(animationValue);
      final double width2 =
          size.width * line2Head.transform(animationValue) - x2;

      drawBar(x1, width1);
      drawBar(x2, width2);
    }
  }

  @override
  bool shouldRepaint(_LinearGradientProgressIndicatorPainter oldPainter) {
    return oldPainter.backgroundColor != backgroundColor ||
        oldPainter.valueColor != valueColor ||
        oldPainter.value != value ||
        oldPainter.animationValue != animationValue ||
        oldPainter.textDirection != textDirection;
  }
}

class TxLinearGradientProgressIndicator extends StatefulWidget {
  const TxLinearGradientProgressIndicator({
    super.key,
    this.value,
    this.backgroundColor,
    this.gradient,
    this.valueColor,
    this.minHeight,
    this.semanticsLabel,
    this.semanticsValue,
    this.radius,
    this.showValueText,
    this.textStyle,
  }) : assert(minHeight == null || minHeight > 0);

  final double? value;
  final Color? backgroundColor;
  final LinearGradient? gradient;
  final Animation<LinearGradient?>? valueColor;
  final String? semanticsLabel;
  final String? semanticsValue;
  final double? minHeight;
  final Radius? radius;
  final bool? showValueText;
  final TextStyle? textStyle;

  LinearGradient _getValueColor(BuildContext context) {
    return valueColor?.value ??
        gradient ??
        LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        );
  }

  Widget _buildSemanticsWrapper({
    required BuildContext context,
    required Widget child,
  }) {
    String? expandedSemanticsValue = semanticsValue;
    if (value != null) {
      expandedSemanticsValue ??= '${(value! * 100).round()}%';
    }
    return Semantics(
      label: semanticsLabel,
      value: expandedSemanticsValue,
      child: child,
    );
  }

  @override
  State<TxLinearGradientProgressIndicator> createState() =>
      _TxLinearGradientProgressIndicatorState();
}

class _TxLinearGradientProgressIndicatorState
    extends State<TxLinearGradientProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: _kIndeterminateLinearDuration),
      vsync: this,
    );
    if (widget.value == null) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(TxLinearGradientProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value == null && !_controller.isAnimating) {
      _controller.repeat();
    } else if (widget.value != null && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildIndicator(BuildContext context, double animationValue,
      TextDirection textDirection) {
    final ProgressIndicatorThemeData indicatorTheme =
        ProgressIndicatorTheme.of(context);
    final Color trackColor = widget.backgroundColor ??
        indicatorTheme.linearTrackColor ??
        Theme.of(context).colorScheme.surface;
    final double minHeight =
        widget.minHeight ?? indicatorTheme.linearMinHeight ?? 4.0;
    final TextStyle textStyle =
        widget.textStyle ?? Theme.of(context).primaryTextTheme.bodySmall!;

    return widget._buildSemanticsWrapper(
      context: context,
      child: Container(
        constraints: BoxConstraints(
          minWidth: double.infinity,
          minHeight: minHeight,
        ),
        child: CustomPaint(
          painter: _LinearGradientProgressIndicatorPainter(
            backgroundColor: trackColor,
            valueColor: widget._getValueColor(context),
            value: widget.value,
            animationValue: animationValue,
            textDirection: textDirection,
            radius: widget.radius,
            showValueText: widget.showValueText == true,
            textStyle: textStyle,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextDirection textDirection = Directionality.of(context);

    if (widget.value != null) {
      return _buildIndicator(context, _controller.value, textDirection);
    }

    return AnimatedBuilder(
      animation: _controller.view,
      builder: (BuildContext context, Widget? child) {
        return _buildIndicator(context, _controller.value, textDirection);
      },
    );
  }
}

/// 环形渐变进度指示器
class TxGradientCircularProgressIndicator extends StatelessWidget {
  const TxGradientCircularProgressIndicator({
    this.radius,
    this.colors,
    super.key,
    this.strokeWidth = 2.0,
    this.stops,
    this.strokeCapRound = false,
    this.backgroundColor,
    this.totalAngle = 2 * math.pi,
    this.value,
  });

  ///粗细
  final double strokeWidth;

  /// 圆的半径
  final double? radius;

  ///两端是否为圆角
  final bool strokeCapRound;

  /// 当前进度，取值范围 [0.0-1.0]
  final double? value;

  /// 进度条背景色
  final Color? backgroundColor;

  /// 进度条的总弧度，2*PI为整圆，小于2*PI则不是整圆
  final double totalAngle;

  /// 渐变色数组
  final List<Color>? colors;

  /// 渐变色的终止点，对应colors属性
  final List<double>? stops;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    double angle = -math.pi;
    // 如果两端为圆角，则需要对起始位置进行调整，否则圆角部分会偏离起始位置
    // 下面调整的角度的计算公式是通过数学几何知识得出，读者有兴趣可以研究一下为什么是这样
    if (strokeCapRound && radius != null) {
      final double offset =
          math.asin(strokeWidth / (radius! * 2 - strokeWidth));
      angle = -math.pi / 2.0 - offset;
    }
    List<Color>? colors = this.colors;
    if (colors == null) {
      final Color color = colorScheme.primary;
      colors = [color, color.withValues(alpha: 0.3)];
    }
    return Transform.rotate(
      angle: angle,
      child: CustomPaint(
        size: radius == null ? Size.zero : Size.fromRadius(radius!),
        painter: _GradientCircularProgressPainter(
          strokeWidth: strokeWidth,
          strokeCapRound: strokeCapRound,
          backgroundColor: backgroundColor ??
              colorScheme.outlineVariant.withValues(alpha: 0.3),
          value: value,
          total: totalAngle,
          radius: radius,
          colors: colors,
          stops: stops,
        ),
      ),
    );
  }
}

/// 实现画笔
class _GradientCircularProgressPainter extends CustomPainter {
  _GradientCircularProgressPainter({
    required this.colors,
    this.radius,
    this.stops,
    this.strokeWidth = 2.0,
    this.strokeCapRound = false,
    this.backgroundColor = const Color(0xFFEEEEEE),
    this.total = 2 * math.pi,
    this.value,
  });

  final double strokeWidth;
  final bool strokeCapRound;
  final double? value;
  final Color backgroundColor;
  final List<Color> colors;
  final double total;
  final double? radius;
  final List<double>? stops;

  @override
  void paint(Canvas canvas, Size size) {
    if (radius != null) {
      size = Size.fromRadius(radius!);
    }
    final double offset = strokeWidth / 2.0;
    double value = this.value ?? .0;
    value = value.clamp(.0, 1.0) * total;
    double start = .0;

    if (strokeCapRound) {
      start = math.asin(strokeWidth / (size.width - strokeWidth));
    }

    final Rect rect = Offset(offset, offset) &
        Size(size.width - strokeWidth, size.height - strokeWidth);

    final Paint paint = Paint()
      ..strokeCap = strokeCapRound ? StrokeCap.round : StrokeCap.butt
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true
      ..strokeWidth = strokeWidth;

    // 先画背景
    if (backgroundColor != Colors.transparent) {
      paint.color = backgroundColor;
      canvas.drawArc(rect, start, total, false, paint);
    }

    // 再画前景，应用渐变
    if (value > 0) {
      paint.shader = SweepGradient(
        endAngle: value,
        colors: colors,
        stops: stops,
      ).createShader(rect);

      canvas.drawArc(rect, start, value, false, paint);
    }
  }

  //简单返回true，实践中应该根据画笔属性是否变化来确定返回true还是false
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
