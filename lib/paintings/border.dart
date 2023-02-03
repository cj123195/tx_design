import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'border_side.dart';
import 'dash_painter.dart';

/// 盒子的边框，由四个边组成：顶部、右侧、底部、左侧。
///
/// 边由 [TxBorderSide] 对象表示。
///
/// 更多信息请参考[Border]
class TxBorder extends Border {
  /// 创建边框。
  ///
  /// 边框的所有边默认为[TxBorderSide.none]。
  ///
  /// 参数不能为空。
  const TxBorder({
    TxBorderSide top = TxBorderSide.none,
    TxBorderSide right = TxBorderSide.none,
    TxBorderSide bottom = TxBorderSide.none,
    TxBorderSide left = TxBorderSide.none,
  }) : super(
          top: top,
          bottom: bottom,
          left: left,
          right: right,
        );

  /// 创建一个边都相同的边框。
  ///
  /// `side` 参数不能为空。
  const TxBorder.fromTxBorderSide(TxBorderSide side)
      : super.fromBorderSide(side);

  /// 创建一个垂直和水平对称的边框。
  ///
  /// `vertical` 参数适用于 [left] 和 [right] 侧
  /// 而`horizontal` 参数适用于 [top] 和 [bottom] 边。
  ///
  /// 所有参数默认为 [TxBorderSide.none] 并且不能为 null。
  const TxBorder.symmetric({
    TxBorderSide vertical = TxBorderSide.none,
    TxBorderSide horizontal = TxBorderSide.none,
  }) : super.symmetric(vertical: vertical, horizontal: horizontal);

  /// 一个统一的边框，所有边的颜色和宽度都相同。
  ///
  /// 边默认为黑色实心边框，一个逻辑像素宽。
  factory TxBorder.all({
    Color? color,
    double? width,
    BorderStyle? style,
    List<double>? dashPattern,
    LinearGradient? gradient,
  }) {
    final TxBorderSide side = TxBorderSide(
      color: color,
      width: width,
      style: style,
      dashPattern: dashPattern,
      gradient: gradient,
    );
    return TxBorder.fromTxBorderSide(side);
  }

  static TxBorder merge(TxBorder a, TxBorder b) {
    assert(TxBorderSide.canMerge(a.top, b.top));
    assert(TxBorderSide.canMerge(a.right, b.right));
    assert(TxBorderSide.canMerge(a.bottom, b.bottom));
    assert(TxBorderSide.canMerge(a.left, b.left));
    return TxBorder(
      top: TxBorderSide.merge(a.top as TxBorderSide, b.top as TxBorderSide),
      right:
          TxBorderSide.merge(a.right as TxBorderSide, b.right as TxBorderSide),
      bottom: TxBorderSide.merge(
          a.bottom as TxBorderSide, b.bottom as TxBorderSide),
      left: TxBorderSide.merge(a.left as TxBorderSide, b.left as TxBorderSide),
    );
  }

  @override
  EdgeInsetsGeometry get dimensions {
    return EdgeInsets.fromLTRB(
        left.width, top.width, right.width, bottom.width);
  }

  @override
  bool get isUniform =>
      _colorIsUniform &&
      _gradientIsUniform &&
      _widthIsUniform &&
      _styleIsUniform;

  bool get _colorIsUniform {
    final Color topColor = top.color;
    return right.color == topColor &&
        bottom.color == topColor &&
        left.color == topColor;
  }

  bool get _widthIsUniform {
    final double topWidth = top.width;
    return right.width == topWidth &&
        bottom.width == topWidth &&
        left.width == topWidth;
  }

  bool get _styleIsUniform {
    final BorderStyle topStyle = top.style;
    return right.style == topStyle &&
        bottom.style == topStyle &&
        left.style == topStyle;
  }

  bool get _gradientIsUniform {
    final LinearGradient? topGradient = (top as TxBorderSide).gradient;
    return (right as TxBorderSide).gradient == topGradient &&
        (bottom as TxBorderSide).gradient == topGradient &&
        (left as TxBorderSide).gradient == topGradient;
  }

  @override
  TxBorder? add(ShapeBorder other, {bool reversed = false}) {
    if (other is TxBorder &&
        TxBorderSide.canMerge(top, other.top) &&
        TxBorderSide.canMerge(right, other.right) &&
        TxBorderSide.canMerge(bottom, other.bottom) &&
        TxBorderSide.canMerge(left, other.left)) {
      return TxBorder.merge(this, other);
    }
    return null;
  }

  @override
  TxBorder scale(double t) {
    return TxBorder(
      top: (top as TxBorderSide).scale(t),
      right: (right as TxBorderSide).scale(t),
      bottom: (bottom as TxBorderSide).scale(t),
      left: (left as TxBorderSide).scale(t),
    );
  }

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is TxBorder) {
      return Border.lerp(a, this, t);
    }
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is TxBorder) {
      return Border.lerp(this, b, t);
    }
    return super.lerpTo(b, t);
  }

  void _paintUniformBorderWithRadius(
    Canvas canvas,
    Rect rect,
    TxBorderSide side,
    BorderRadius borderRadius,
  ) {
    assert(side.style != BorderStyle.none);
    final Paint paint = Paint();
    if (side.gradient != null) {
      paint.shader = side.gradient!.createShader(rect);
    } else {
      paint.color = side.color;
    }
    final RRect outer = borderRadius.toRRect(rect);
    final double width = side.width;
    if (width == 0.0) {
      paint
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.0;
      canvas.drawRRect(outer, paint);
    } else if (side.dashPattern != null) {
      paint
        ..style = PaintingStyle.stroke
        ..strokeWidth = width;
      DashedPainter(side.dashPattern!)
          .paint(canvas, Path()..addRRect(outer.deflate(width / 2)), paint);
    } else {
      final RRect inner = outer.deflate(width);
      canvas.drawDRRect(outer, inner, paint);
    }
  }

  void _paintUniformBorderWithCircle(
    Canvas canvas,
    Rect rect,
    TxBorderSide side,
  ) {
    assert(side.style != BorderStyle.none);
    final double width = side.width;
    final Paint paint = side.toRectPaint(rect);
    final double radius = (rect.shortestSide - width) / 2.0;

    if (side.dashPattern != null) {
      DashedPainter(side.dashPattern!).paint(
        canvas,
        Path()..addOval(Rect.fromCircle(center: rect.center, radius: radius)),
        paint,
      );
    } else {
      canvas.drawCircle(rect.center, radius, paint);
    }
  }

  void _paintUniformBorderWithRectangle(
    Canvas canvas,
    Rect rect,
    TxBorderSide side,
  ) {
    assert(side.style != BorderStyle.none);
    final double width = side.width;
    final Paint paint = side.toRectPaint(rect);
    if (side.dashPattern != null) {
      DashedPainter(side.dashPattern!)
          .paint(canvas, Path()..addRect(rect.deflate(width / 2.0)), paint);
    } else {
      canvas.drawRect(rect.deflate(width / 2.0), paint);
    }
  }

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    TextDirection? textDirection,
    BoxShape shape = BoxShape.rectangle,
    BorderRadius? borderRadius,
  }) {
    if (isUniform) {
      switch (top.style) {
        case BorderStyle.none:
          return;
        case BorderStyle.solid:
          switch (shape) {
            case BoxShape.circle:
              assert(borderRadius == null,
                  'A borderRadius can only be given for rectangular boxes.');
              _paintUniformBorderWithCircle(canvas, rect, top as TxBorderSide);
              break;
            case BoxShape.rectangle:
              if (borderRadius != null) {
                _paintUniformBorderWithRadius(
                  canvas,
                  rect,
                  top as TxBorderSide,
                  borderRadius,
                );
                return;
              }
              _paintUniformBorderWithRectangle(
                canvas,
                rect,
                top as TxBorderSide,
              );
              break;
          }
          return;
      }
    }

    assert(() {
      if (borderRadius != null) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary(
              'A borderRadius can only be given for a uniform TxBorder.'),
          ErrorDescription('The following is not uniform:'),
          if (!_colorIsUniform) ErrorDescription('TxBorderSide.color'),
          if (!_widthIsUniform) ErrorDescription('TxBorderSide.width'),
          if (!_styleIsUniform) ErrorDescription('TxBorderSide.style'),
        ]);
      }
      return true;
    }());
    assert(() {
      if (shape != BoxShape.rectangle) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary(
              'A TxBorder can only be drawn as a circle if it is uniform'),
          ErrorDescription('The following is not uniform:'),
          if (!_colorIsUniform) ErrorDescription('TxBorderSide.color'),
          if (!_widthIsUniform) ErrorDescription('TxBorderSide.width'),
          if (!_styleIsUniform) ErrorDescription('TxBorderSide.style'),
        ]);
      }
      return true;
    }());

    paintTxBorder(
      canvas,
      rect,
      top: top as TxBorderSide,
      right: right as TxBorderSide,
      bottom: bottom as TxBorderSide,
      left: left as TxBorderSide,
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
    return other is TxBorder &&
        other.top == top &&
        other.right == right &&
        other.bottom == bottom &&
        other.left == left;
  }

  @override
  int get hashCode => Object.hash(top, right, bottom, left);

  @override
  String toString() {
    if (isUniform) {
      return '${objectRuntimeType(this, 'TxBorder')}.all($top)';
    }
    final List<String> arguments = <String>[
      if (top != TxBorderSide.none) 'top: $top',
      if (right != TxBorderSide.none) 'right: $right',
      if (bottom != TxBorderSide.none) 'bottom: $bottom',
      if (left != TxBorderSide.none) 'left: $left',
    ];
    return '${objectRuntimeType(this, 'TxBorder')}(${arguments.join(", ")})';
  }
}
