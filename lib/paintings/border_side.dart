import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'dash_painter.dart';

/// 盒子边框的一侧。
///
/// [gradient] 渐变色
/// [dashPattern] 虚线的格式
///
/// 详细信息请参考 [BorderSide]
@immutable
class TxBorderSide extends BorderSide {
  const TxBorderSide({
    Color? color,
    double? width,
    BorderStyle? style,
    this.gradient,
    this.dashPattern,
    super.strokeAlign = BorderSide.strokeAlignInside,
  })  : assert(width == null || width >= 0.0),
        super(
          width: width ?? 1.0,
          color: color ?? const Color(0xFF000000),
          style: style ?? BorderStyle.solid,
        );

  static TxBorderSide merge(TxBorderSide a, TxBorderSide b) {
    assert(canMerge(a, b));
    final bool aIsNone = a.style == BorderStyle.none && a.width == 0.0;
    final bool bIsNone = b.style == BorderStyle.none && b.width == 0.0;
    if (aIsNone && bIsNone) {
      return TxBorderSide.none;
    }
    if (aIsNone) {
      return b;
    }
    if (bIsNone) {
      return a;
    }
    assert(a.color == b.color);
    assert(a.style == b.style);
    assert(a.gradient == b.gradient);
    assert(a.dashPattern == b.dashPattern);
    return TxBorderSide(
      color: a.color,
      width: a.width + b.width,
      strokeAlign: math.max(a.strokeAlign, b.strokeAlign),
      style: a.style,
      gradient: a.gradient,
      dashPattern: a.dashPattern,
    );
  }

  /// 渐变色
  final LinearGradient? gradient;

  /// 虚线的格式
  ///
  /// 值为null时为实线，不为null时为虚线
  ///
  /// 详细信息请参考[DashedPainter.pattern]
  final List<double>? dashPattern;

  static const TxBorderSide none =
      TxBorderSide(width: 0.0, style: BorderStyle.none);

  @override
  TxBorderSide copyWith({
    Color? color,
    double? width,
    BorderStyle? style,
    LinearGradient? gradient,
    double? strokeAlign,
    List<double>? dashPattern,
  }) {
    assert(width == null || width >= 0.0);
    return TxBorderSide(
      color: color ?? this.color,
      width: width ?? this.width,
      style: style ?? this.style,
      gradient: gradient ?? this.gradient,
      dashPattern: dashPattern ?? this.dashPattern,
      strokeAlign: strokeAlign ?? this.strokeAlign,
    );
  }

  @override
  TxBorderSide scale(double t) {
    return TxBorderSide(
      color: color,
      width: math.max(0.0, width * t),
      style: t <= 0.0 ? BorderStyle.none : style,
      gradient: gradient,
      dashPattern: dashPattern?.map((e) => math.max(0.0, e * t)).toList(),
    );
  }

  Paint toRectPaint(Rect rect) {
    switch (style) {
      case BorderStyle.solid:
        return Paint()
          ..shader = gradient?.createShader(rect)
          ..color = color
          ..strokeWidth = width
          ..style = PaintingStyle.stroke;
      case BorderStyle.none:
        return Paint()
          ..color = const Color(0x00000000)
          ..strokeWidth = 0.0
          ..style = PaintingStyle.stroke;
    }
  }

  static bool canMerge(BorderSide a, BorderSide b) {
    if ((a.style == BorderStyle.none && a.width == 0.0) ||
        (b.style == BorderStyle.none && b.width == 0.0)) {
      return true;
    }
    return a.style == b.style && a.color == b.color;
  }

  static TxBorderSide lerp(TxBorderSide a, TxBorderSide b, double t) {
    if (t == 0.0) {
      return a;
    }
    if (t == 1.0) {
      return b;
    }
    final double width = ui.lerpDouble(a.width, b.width, t)!;
    if (width < 0.0) {
      return TxBorderSide.none;
    }
    final LinearGradient? gradient =
        a.gradient?.lerpTo(b.gradient, t) as LinearGradient?;
    if (a.style == b.style && a.strokeAlign == b.strokeAlign) {
      return TxBorderSide(
        color: Color.lerp(a.color, b.color, t)!,
        width: width,
        style: a.style,
        strokeAlign: a.strokeAlign,
        gradient: gradient,
        dashPattern: a.dashPattern,
      );
    }
    Color colorA, colorB;
    switch (a.style) {
      case BorderStyle.solid:
        colorA = a.color;
        break;
      case BorderStyle.none:
        colorA = a.color.withAlpha(0x00);
        break;
    }
    switch (b.style) {
      case BorderStyle.solid:
        colorB = b.color;
        break;
      case BorderStyle.none:
        colorB = b.color.withAlpha(0x00);
        break;
    }
    if (a.strokeAlign != b.strokeAlign) {
      return TxBorderSide(
        color: Color.lerp(colorA, colorB, t)!,
        width: width,
        gradient: gradient,
        dashPattern: a.dashPattern,
        strokeAlign: ui.lerpDouble(a.strokeAlign, b.strokeAlign, t)!,
      );
    }
    return TxBorderSide(
      color: Color.lerp(colorA, colorB, t)!,
      width: width,
      gradient: gradient,
      dashPattern: a.dashPattern,
      strokeAlign: a.strokeAlign,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is TxBorderSide &&
        other.color == color &&
        other.width == width &&
        other.style == style &&
        other.gradient == gradient &&
        other.dashPattern == dashPattern;
  }

  @override
  int get hashCode => Object.hash(color, width, style, gradient, dashPattern);
}

void paintTxBorder(
  Canvas canvas,
  Rect rect, {
  TxBorderSide? top,
  TxBorderSide? right,
  TxBorderSide? bottom,
  TxBorderSide? left,
}) {
  top ??= TxBorderSide.none;
  right ??= TxBorderSide.none;
  bottom ??= TxBorderSide.none;
  left ??= TxBorderSide.none;

  final Paint paint = Paint()
    ..strokeWidth = 0.0
    ..style = PaintingStyle.stroke;

  final Path path = Path();

  switch (top.style) {
    case BorderStyle.solid:
      if (top.width == 0.0) {
        break;
      }
      paint.color = top.color;
      path.reset();
      if (top.dashPattern == null) {
        path.moveTo(rect.left, rect.top);
        path.lineTo(rect.right, rect.top);
        path.lineTo(rect.right - right.width, rect.top + top.width);
        path.lineTo(rect.left + left.width, rect.top + top.width);
        paint
          ..style = PaintingStyle.fill
          ..shader = top.gradient?.createShader(path.getBounds())
          ..strokeWidth = 0.0;
        canvas.drawPath(path, paint);
      } else {
        path.moveTo(rect.left + left.width, rect.top + top.width / 2);
        path.lineTo(rect.right - right.width, rect.top + top.width / 2);
        paint
          ..shader = top.gradient?.createShader(path.getBounds())
          ..strokeWidth = top.width;
        DashedPainter(top.dashPattern!).paint(canvas, path, paint);
      }
      break;
    case BorderStyle.none:
      break;
  }

  switch (right.style) {
    case BorderStyle.solid:
      if (right.width == 0.0) {
        break;
      }
      paint.color = right.color;
      path.reset();
      if (right.dashPattern == null) {
        path.moveTo(rect.right, rect.top);
        path.lineTo(rect.right, rect.bottom);
        path.lineTo(rect.right - right.width, rect.bottom - bottom.width);
        path.lineTo(rect.right - right.width, rect.top + top.width);
        paint
          ..style = PaintingStyle.fill
          ..shader = right.gradient?.createShader(path.getBounds())
          ..strokeWidth = 0.0;
        canvas.drawPath(path, paint);
      } else {
        path.moveTo(rect.right - right.width / 2, rect.top + top.width);
        path.lineTo(rect.right - right.width / 2, rect.bottom - bottom.width);
        paint
          ..shader = right.gradient?.createShader(path.getBounds())
          ..style = PaintingStyle.stroke
          ..strokeWidth = right.width;
        DashedPainter(right.dashPattern!).paint(canvas, path, paint);
      }
      break;
    case BorderStyle.none:
      break;
  }

  switch (bottom.style) {
    case BorderStyle.solid:
      if (bottom.width == 0.0) {
        break;
      }
      paint.color = bottom.color;
      path.reset();
      if (bottom.dashPattern == null) {
        path.moveTo(rect.right, rect.bottom);
        path.lineTo(rect.left, rect.bottom);
        path.lineTo(rect.left + left.width, rect.bottom - bottom.width);
        path.lineTo(rect.right - right.width, rect.bottom - bottom.width);
        paint
          ..style = PaintingStyle.fill
          ..shader = bottom.gradient?.createShader(path.getBounds())
          ..strokeWidth = 0.0;
        canvas.drawPath(path, paint);
      } else {
        path.moveTo(rect.right - right.width, rect.bottom - bottom.width / 2);
        path.lineTo(rect.left + left.width, rect.bottom - bottom.width / 2);
        paint
          ..shader = bottom.gradient?.createShader(path.getBounds())
          ..style = PaintingStyle.stroke
          ..strokeWidth = bottom.width;
        DashedPainter(bottom.dashPattern!).paint(canvas, path, paint);
      }
      break;
    case BorderStyle.none:
      break;
  }

  switch (left.style) {
    case BorderStyle.solid:
      if (left.width == 0.0) {
        break;
      }
      paint.color = left.color;
      path.reset();
      if (left.dashPattern == null) {
        path.moveTo(rect.left, rect.bottom);
        path.lineTo(rect.left, rect.top);
        path.lineTo(rect.left + left.width, rect.top + top.width);
        path.lineTo(rect.left + left.width, rect.bottom - bottom.width);
        paint
          ..style = PaintingStyle.fill
          ..shader = left.gradient?.createShader(path.getBounds())
          ..strokeWidth = 0.0;
        canvas.drawPath(path, paint);
      } else {
        path.moveTo(rect.left + left.width / 2, rect.bottom - bottom.width);
        path.lineTo(rect.left + left.width / 2, rect.top + top.width);
        paint
          ..shader = left.gradient?.createShader(path.getBounds())
          ..style = PaintingStyle.stroke
          ..strokeWidth = left.width;
        DashedPainter(left.dashPattern!).paint(canvas, path, paint);
      }
      break;
    case BorderStyle.none:
      break;
  }
}
