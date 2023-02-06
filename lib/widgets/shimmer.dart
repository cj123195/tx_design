import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// 枚举定义所有支持的微光效果方向
/// [ShimmerDirection.ltr] 从左到右方向
/// [ShimmerDirection.rtl] 从右到左方向
/// [ShimmerDirection.ttb] 从上到下方向
/// [ShimmerDirection.btt] 从下到上方向
enum ShimmerDirection { ltr, rtl, ttb, btt }

/// 小部件树上呈现微光效果的组件。
/// [child] 定义了闪光效果混合的区域。
/// 您可以从您喜欢的任何 [Widget] 构建 [child]，
/// 但为了获得准确的预期效果并获得更好的渲染性能，请注意一些注意事项：
/// 使用静态 [Widget]（它是 [StatelessWidget] 的一个实例）。
/// [Widget] 应该是纯色元素。您在这些 [Widget] 上设置的每种颜色都将被
///
/// [gradient] 的颜色覆盖。微光效果只影响 [child] 的不透明区域，透明区域仍然保持透明。
/// [period] 控制微光效果的速度。默认值为 1500 毫秒。
/// [direction] 控制微光效果的方向。默认值为 [ShimmerDirection.ltr]。
/// [gradient] 控制微光效果的颜色。
/// [loop] 动画循环次数，设置为 `0` 使动画永远运行。
/// [enabled] 控制是否激活微光效果。设置为 false 时动画暂停
///
/// 专业提示：[child] 应由基本简单的 [Widget] 组成，
/// 例如 [Container]、[Row] 和 [Column]，以避免副作用。
///
/// 使用一个 [TxShimmer] 来包装 [Widget] 的列表，而不是许多 [TxShimmer] 的列表
@immutable
class TxShimmer extends StatefulWidget {
  /// 创建一个[TxShimmer]
  const TxShimmer({
    required this.child,
    required this.gradient,
    super.key,
    this.direction = ShimmerDirection.ltr,
    this.period = const Duration(milliseconds: 1500),
    this.loop = 0,
    this.enabled = true,
  });

  /// 一个方便的构造函数提供了一种简单方便的方法来创建一个 [TxShimmer]，
  /// 其中 [gradient] 是由 `baseColor` 和 `highlightColor` 组成的 [LinearGradient]。
  TxShimmer.fromColors({
    required this.child,
    required Color baseColor,
    required Color highlightColor,
    super.key,
    this.period = const Duration(milliseconds: 1500),
    this.direction = ShimmerDirection.ltr,
    this.loop = 0,
    this.enabled = true,
  }) : gradient = LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.centerRight,
            colors: <Color>[
              baseColor,
              baseColor,
              highlightColor,
              baseColor,
              baseColor
            ],
            stops: const <double>[
              0.0,
              0.35,
              0.5,
              0.65,
              1.0
            ]);

  final Widget child;
  final Duration period;
  final ShimmerDirection direction;
  final Gradient gradient;
  final int loop;
  final bool enabled;

  @override
  State createState() => _TxShimmerState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Gradient>('gradient', gradient,
        defaultValue: null));
    properties.add(EnumProperty<ShimmerDirection>('direction', direction));
    properties.add(
        DiagnosticsProperty<Duration>('period', period, defaultValue: null));
    properties
        .add(DiagnosticsProperty<bool>('enabled', enabled, defaultValue: null));
    properties.add(DiagnosticsProperty<int>('loop', loop, defaultValue: 0));
  }
}

class _TxShimmerState extends State<TxShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _count = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.period)
      ..addStatusListener((AnimationStatus status) {
        if (status != AnimationStatus.completed) {
          return;
        }
        _count++;
        if (widget.loop <= 0) {
          _controller.repeat();
        } else if (_count < widget.loop) {
          _controller.forward(from: 0.0);
        }
      });
    if (widget.enabled) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(TxShimmer oldWidget) {
    if (widget.enabled) {
      _controller.forward();
    } else {
      _controller.stop();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (BuildContext context, Widget? child) => _TxShimmer(
        direction: widget.direction,
        gradient: widget.gradient,
        percent: _controller.value,
        child: child,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

@immutable
class _TxShimmer extends SingleChildRenderObjectWidget {
  const _TxShimmer({
    required this.percent,
    required this.direction,
    required this.gradient,
    super.child,
  });

  final double percent;
  final ShimmerDirection direction;
  final Gradient gradient;

  @override
  _TxShimmerFilter createRenderObject(BuildContext context) {
    return _TxShimmerFilter(percent, direction, gradient);
  }

  @override
  void updateRenderObject(BuildContext context, _TxShimmerFilter shimmer) {
    shimmer.percent = percent;
    shimmer.gradient = gradient;
    shimmer.direction = direction;
  }
}

class _TxShimmerFilter extends RenderProxyBox {
  _TxShimmerFilter(this._percent, this._direction, this._gradient);

  ShimmerDirection _direction;
  Gradient _gradient;
  double _percent;

  @override
  ShaderMaskLayer? get layer => super.layer as ShaderMaskLayer?;

  @override
  bool get alwaysNeedsCompositing => child != null;

  set percent(double newValue) {
    if (newValue == _percent) {
      return;
    }
    _percent = newValue;
    markNeedsPaint();
  }

  set gradient(Gradient newValue) {
    if (newValue == _gradient) {
      return;
    }
    _gradient = newValue;
    markNeedsPaint();
  }

  set direction(ShimmerDirection newDirection) {
    if (newDirection == _direction) {
      return;
    }
    _direction = newDirection;
    markNeedsLayout();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null) {
      assert(needsCompositing);

      final double width = child!.size.width;
      final double height = child!.size.height;
      Rect rect;
      double dx, dy;
      if (_direction == ShimmerDirection.rtl) {
        dx = _offset(width, -width, _percent);
        dy = 0.0;
        rect = Rect.fromLTWH(dx - width, dy, 3 * width, height);
      } else if (_direction == ShimmerDirection.ttb) {
        dx = 0.0;
        dy = _offset(-height, height, _percent);
        rect = Rect.fromLTWH(dx, dy - height, width, 3 * height);
      } else if (_direction == ShimmerDirection.btt) {
        dx = 0.0;
        dy = _offset(height, -height, _percent);
        rect = Rect.fromLTWH(dx, dy - height, width, 3 * height);
      } else {
        dx = _offset(-width, width, _percent);
        dy = 0.0;
        rect = Rect.fromLTWH(dx - width, dy, 3 * width, height);
      }
      layer ??= ShaderMaskLayer();
      layer!
        ..shader = _gradient.createShader(rect)
        ..maskRect = offset & size
        ..blendMode = BlendMode.srcIn;
      context.pushLayer(layer!, super.paint, offset);
    } else {
      layer = null;
    }
  }

  double _offset(double start, double end, double percent) {
    return start + (end - start) * percent;
  }
}
