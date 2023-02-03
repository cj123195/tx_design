import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// 一个在初始化时执行一个打勾动画小部件。
class TxDone extends LeafRenderObjectWidget {
  const TxDone({
    super.key,
    this.strokeWidth = 2.0,
    this.color = Colors.green,
    this.outline = false,
  });

  /// 线条宽度
  final double strokeWidth;

  /// 轮廓颜色或填充色
  final Color color;

  /// 如果为true，则没有填充色，color代表轮廓的颜色；如果为false，则color为填充色
  final bool outline;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderDoneObject(strokeWidth, color, outline)
      ..animationStatus = AnimationStatus.forward;
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderDoneObject renderObject) {
    renderObject
      ..strokeWidth = strokeWidth
      ..outline = outline
      ..color = color;
    super.updateRenderObject(context, renderObject);
  }
}

class RenderDoneObject extends RenderBox with RenderObjectAnimationMixin {
  RenderDoneObject(
    this.strokeWidth,
    this.color,
    this.outline,
  );

  double strokeWidth;
  Color color;
  bool outline;

  ValueChanged<bool>? onChanged;

  // 动画执行时间为 300ms
  @override
  Duration get duration => const Duration(milliseconds: 300);

  @override
  void doPaint(PaintingContext context, Offset offset) {
    const Curve curve = Curves.easeIn;
    final progress = curve.transform(this.progress);

    Rect rect = offset & size;
    final paint = Paint()
      ..isAntiAlias = true
      ..style = outline ? PaintingStyle.stroke : PaintingStyle.fill //填充
      ..color = color;

    if (outline) {
      paint.strokeWidth = strokeWidth;
      rect = rect.deflate(strokeWidth / 2);
    }

    // 画背景圆
    context.canvas.drawCircle(rect.center, rect.shortestSide / 2, paint);

    paint
      ..style = PaintingStyle.stroke
      ..color = outline ? color : Colors.white
      ..strokeWidth = strokeWidth;

    final path = Path();

    final Offset firstOffset =
        Offset(rect.left + rect.width / 6, rect.top + rect.height / 2.1);

    final secondOffset = Offset(
      rect.left + rect.width / 2.5,
      rect.bottom - rect.height / 3.3,
    );

    path.moveTo(firstOffset.dx, firstOffset.dy);

    const adjustProgress = .6;
    //画 "勾"
    if (_progress < adjustProgress) {
      //第一个点到第二个点的连线做动画(第二个点不停的变)
      final Offset betweenOffset = Offset.lerp(
        firstOffset,
        secondOffset,
        _progress / adjustProgress,
      )!;
      path.lineTo(betweenOffset.dx, betweenOffset.dy);
    } else {
      //链接第一个点和第二个点
      path.lineTo(secondOffset.dx, secondOffset.dy);
      //第三个点位置随着动画变，做动画
      final lastOffset = Offset(
        rect.right - rect.width / 5,
        rect.top + rect.height / 3.5,
      );
      final Offset lerpOffset = Offset.lerp(
        secondOffset,
        lastOffset,
        (progress - adjustProgress) / (1 - adjustProgress),
      )!;
      path.lineTo(lerpOffset.dx, lerpOffset.dy);
    }
    context.canvas.drawPath(path, paint..style = PaintingStyle.stroke);
  }

  @override
  void performLayout() {
    // 如果父组件指定了固定宽高，则使用父组件指定的，否则宽高默认置为 25
    size = constraints.constrain(
      constraints.isTight ? Size.infinite : const Size(25, 25),
    );
  }
}

mixin RenderObjectAnimationMixin on RenderObject {
  double _progress = 0.0;
  int? _lastTimestamp;

  double get progress => _progress;

  Duration get duration => const Duration(milliseconds: 200);

  AnimationStatus _animationStatus = AnimationStatus.completed;

  set animationStatus(AnimationStatus status) {
    if (_animationStatus != status) {
      _animationStatus = status;
      markNeedsPaint();
    }
  }

  set progress(double value) {
    _progress = value.clamp(0.0, 1.0);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    doPaint(context, offset);
    _scheduleAnimation();
    super.paint(context, offset);
  }

  void doPaint(PaintingContext context, Offset offset);

  void _scheduleAnimation() {
    if (_animationStatus != AnimationStatus.completed) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        if (_lastTimestamp != null) {
          double delta = (timeStamp.inMilliseconds - _lastTimestamp!) /
              duration.inMilliseconds;
          if (delta == 0) {
            markNeedsPaint();
            return;
          }
          if (_animationStatus == AnimationStatus.reverse) {
            delta = -delta;
          }

          _progress += delta;
          if (_progress >= 1 || _progress <= 0) {
            _animationStatus = AnimationStatus.completed;
            _progress = _progress.clamp(0.0, 1.0);
          }
        }
        markNeedsPaint();
        _lastTimestamp = timeStamp.inMilliseconds;
      });
    } else {
      _lastTimestamp = null;
    }
  }
}
