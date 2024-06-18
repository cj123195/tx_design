import 'dart:math';

import 'package:flutter/material.dart';

import '../../../theme_extensions/spacing.dart';
import '../../extensions/paint_extension.dart';

/// 图例项布局
class LegendItem extends StatelessWidget {
  const LegendItem({
    required this.indicator,
    this.text,
    this.child,
    this.padding,
    this.gap,
    super.key,
  });

  final Widget indicator;

  /// 展示在[indicator]后的文字
  ///
  /// 当[child]不为null时不生效
  final String? text;

  /// 展示在[indicator]后的组件
  ///
  /// 优先级高于[text]
  final Widget? child;

  /// 内边距
  final EdgeInsetsGeometry? padding;

  /// [indicator]与[child]或[text]之间的间距
  final double? gap;

  @override
  Widget build(BuildContext context) {
    final SpacingThemeData spacingTheme = SpacingTheme.of(context);

    Widget result = indicator;

    if (child != null || text?.isNotEmpty == true) {
      final Widget label = Padding(
        padding: EdgeInsets.only(left: gap ?? spacingTheme.mini),
        child: DefaultTextStyle(
          style: Theme.of(context).textTheme.labelSmall!.copyWith(height: 1.2),
          child: child ?? Text(text!),
        ),
      );
      result = Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [result, label],
      );
    }

    return Padding(
      padding: padding ?? spacingTheme.edgeInsetsMedium / 2,
      child: result,
    );
  }
}

/// 基本图例样式
class LegendIndicator extends StatelessWidget {
  const LegendIndicator({
    super.key,
    this.width,
    this.height,
    this.color,
    this.gradient,
    this.borderRadius,
    this.shape,
    this.boxShadow,
    this.border,
    this.image,
  });

  /// 宽度
  ///
  /// 默认值为14.0
  final double? width;

  /// 高度
  ///
  /// 默认值为14.0
  final double? height;

  /// 颜色
  final Color? color;

  /// 渐变色
  final Gradient? gradient;

  /// 圆角大小
  ///
  /// 默认值为2.0
  final BorderRadius? borderRadius;

  /// 形状
  ///
  /// 默认值为[BoxShape.rectangle]
  final BoxShape? shape;

  /// 阴影
  final List<BoxShadow>? boxShadow;

  /// 边框
  final BoxBorder? border;

  /// 背景图片
  final DecorationImage? image;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 14.0,
      height: height ?? 14.0,
      decoration: BoxDecoration(
        color: color,
        gradient: gradient,
        borderRadius: borderRadius ?? BorderRadius.circular(2.0),
        shape: shape ?? BoxShape.rectangle,
        boxShadow: boxShadow,
        border: border,
        image: image,
      ),
    );
  }
}

/// 饼状图图例
class PieLegendIndicator extends StatelessWidget {
  const PieLegendIndicator({
    super.key,
    this.iconSize = 14.0,
    this.iconCenterRadius = 4.0,
    this.color,
    this.gradient,
  })  : assert(iconCenterRadius * 2 < iconSize),
        assert(color != null || gradient != null);

  /// 颜色
  final Color? color;

  /// 渐变色
  final Gradient? gradient;

  /// 图标大小
  final double iconSize;

  /// 中间区域大小
  final double iconCenterRadius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: iconSize,
      height: iconSize,
      child: CustomPaint(
        painter: _PieLegendPainter(
          iconCenterRadius,
          color,
          gradient,
        ),
      ),
    );
  }
}

class _PieLegendPainter extends CustomPainter {
  const _PieLegendPainter(this.centerRadius, this.color, this.gradient);

  final double centerRadius;
  final Color? color;
  final Gradient? gradient;

  @override
  void paint(Canvas canvas, Size size) {
    Rect rect;
    final Paint paint = Paint();
    if (centerRadius == 0.0) {
      paint.style = PaintingStyle.fill;
      rect = Rect.fromLTWH(
        0,
        0,
        size.width,
        size.height,
      );
      paint.setColorOrGradient(color, gradient, rect);
      canvas.drawArc(rect, 0.0, 2 * pi * 3 / 4, true, paint);

      final Rect translateRect = rect.translate(2, -2);
      canvas.drawArc(
        rect.translate(1, -1),
        2 * pi * 3.1 / 4,
        2 * pi / 4 * 0.9,
        true,
        paint..setColorOrGradient(color, gradient, translateRect),
      );
    } else {
      final double strokeWidth = size.width / 2 - centerRadius;
      final double width = size.width - strokeWidth;
      rect = Rect.fromLTWH(strokeWidth / 2, strokeWidth / 2, width, width);
      paint
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;
      paint.setColorOrGradient(color, gradient, rect);
      canvas.drawArc(rect, 0.0, 2 * pi * 3.5 / 4, false, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _PieLegendPainter oldDelegate) {
    return centerRadius != oldDelegate.centerRadius ||
        color != oldDelegate.color ||
        gradient != oldDelegate.gradient;
  }
}

/// 折线图图例
class LineLegendIndicator extends StatelessWidget {
  const LineLegendIndicator({
    super.key,
    this.color,
    this.gradient,
    this.strokeWidth = 2,
    this.iconSize = 14.0,
  });

  /// 颜色
  final Color? color;

  /// 渐变色
  final Gradient? gradient;

  /// 线宽度
  final double strokeWidth;

  /// 图标大小
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: iconSize,
      height: iconSize,
      child: CustomPaint(
        painter: _LineLegendPainter(
          strokeWidth,
          color,
          gradient,
        ),
      ),
    );
  }
}

class _LineLegendPainter extends CustomPainter {
  const _LineLegendPainter(this.strokeWidth, this.color, this.gradient);

  final Color? color;
  final Gradient? gradient;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final Path path = Path()
      ..moveTo(0, size.height * 4 / 5)
      ..cubicTo(
        size.width / 2,
        0,
        size.width / 2,
        size.height,
        size.width,
        size.height * 1 / 5,
      );

    final Paint paint = Paint()
      ..setColorOrGradient(
        color,
        gradient,
        path.getBounds(),
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _LineLegendPainter oldDelegate) {
    return color != oldDelegate.color ||
        gradient != oldDelegate.gradient ||
        strokeWidth != oldDelegate.strokeWidth;
  }
}
