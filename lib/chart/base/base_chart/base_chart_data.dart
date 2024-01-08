import 'dart:core';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'base_chart_painter.dart';
import 'fl_touch_event.dart';

extension BorderExtension on Border {
  bool isVisible() {
    if (left.width == 0 &&
        top.width == 0 &&
        right.width == 0 &&
        bottom.width == 0) {
      return false;
    }

    if (left.color.opacity == 0.0 &&
        top.color.opacity == 0.0 &&
        right.color.opacity == 0.0 &&
        bottom.color.opacity == 0.0) {
      return false;
    }
    return true;
  }
}

/// 此类保存 [BaseChartPainter] 所需的所有数据。
///
/// 在这个阶段，我们绘制边框，并以抽象的方式处理触摸。
abstract class BaseChartData with EquatableMixin {
  /// 它在图表周围绘制 4 个边框，您可以使用 [borderData] 对其进行自定义，[touchData] 定义
  /// 触摸行为和响应。
  BaseChartData({
    required this.touchData,
    FlBorderData? borderData,
  }) : borderData = borderData ?? FlBorderData();

  /// 保存数据以在图表周围绘制边框。
  FlBorderData borderData;

  /// 保存触摸行为和响应所需的数据。
  FlTouchData touchData;

  BaseChartData lerp(BaseChartData a, BaseChartData b, double t);

  /// 用于相等性检查，请参阅 [EquatableMixin]。
  @override
  List<Object?> get props => [
        borderData,
        touchData,
      ];
}

/// 保存数据以在图表周围绘制边框。
class FlBorderData with EquatableMixin {
  /// [show] 确定显示或隐藏图表周围的边框。
  /// [border] 确定 4 个边框的视觉外观，请参阅 [Border]。
  FlBorderData({
    bool? show,
    Border? border,
  })  : show = show ?? true,
        border = border ?? Border.all(color: Colors.grey.withOpacity(0.5));
  final bool show;
  Border border;

  /// 如果所有边框的宽度为 0 或不透明度为 0，则返回 false
  bool isVisible() => show && border.isVisible();

  EdgeInsets get allSidesPadding {
    return EdgeInsets.only(
      left: show ? border.left.width : 0.0,
      top: show ? border.top.width : 0.0,
      right: show ? border.right.width : 0.0,
      bottom: show ? border.bottom.width : 0.0,
    );
  }

  /// 返回 [FlBorderData] 在给定 [t] 值处的值, 参阅 [Tween.lerp].
  static FlBorderData lerp(FlBorderData a, FlBorderData b, double t) {
    return FlBorderData(
      show: b.show,
      border: Border.lerp(a.border, b.border, t),
    );
  }

  /// 将当前 [FlBorderData] 复制到新的 [FlBorderData]，并替换提供的值。
  FlBorderData copyWith({
    bool? show,
    Border? border,
  }) {
    return FlBorderData(
      show: show ?? this.show,
      border: border ?? this.border,
    );
  }

  /// 用于相等性检查，请参阅 [EquatableMixin]。
  @override
  List<Object?> get props => [
        show,
        border,
      ];
}

/// 保存数据以处理触摸事件，并以抽象方式处理触摸响应。
///
/// 有一个触摸流程，查阅（https://github.com/imaNNeo/fl_chart/blob/main/repo_files/documentations/handle_touches.md）
/// 简单来说，每个图表的呈现器都会捕获触摸事件，并传递 pointerEvent给画笔，并被触摸到点，
/// 并将其包裹成混凝土 [BaseTouchResponse]。
abstract class FlTouchData<R extends BaseTouchResponse> with EquatableMixin {
  /// 您可以使用 [enabled] 标志禁用或启用触摸系统，
  const FlTouchData(
    this.enabled,
    this.touchCallback,
    this.mouseCursorResolver,
    this.longPressDuration,
  );

  /// 您可以使用 [enabled] 标志禁用或启用触摸系统，
  final bool enabled;

  /// [touchCallback] 通知您发生的触摸/指针事件。
  /// 它为您提供一个 [FlTouchEvent]，它是发生的事件，例如 [FlPointerHoverEvent]、[FlTapUpEvent]、...
  /// 它还为您提供一个 [BaseTouchResponse]，它是图表特定的类型，包含有关已触及的元素的信息。
  final BaseTouchCallback<R>? touchCallback;

  /// 使用 [mouseCursorResolver]，您可以根据提供的 [FlTouchEvent] 和 [BaseTouchResponse] 、
  /// 更改鼠标光标
  final MouseCursorResolver<R>? mouseCursorResolver;

  /// 此属性允许自定义 longPress 手势的持续时间。
  ///
  /// 默认值为 500 毫秒。
  final Duration? longPressDuration;

  /// 用于相等性检查，请参阅 [EquatableMixin]。
  @override
  List<Object?> get props => [
        enabled,
        touchCallback,
        mouseCursorResolver,
        longPressDuration,
      ];
}

/// 将数据保存到其边框周围的剪贴图中。
class FlClipData with EquatableMixin {
  /// 创建裁剪指定边的数据
  const FlClipData({
    required this.top,
    required this.bottom,
    required this.left,
    required this.right,
  });

  /// 创建裁剪所有边的数据
  const FlClipData.all()
      : this(top: true, bottom: true, left: true, right: true);

  /// 创建仅裁剪顶部和底部的数据
  const FlClipData.vertical()
      : this(top: true, bottom: true, left: false, right: false);

  /// 创建仅剪裁左侧和右侧的数据
  const FlClipData.horizontal()
      : this(top: false, bottom: false, left: true, right: true);

  /// 创建不会剪裁任何一侧的数据
  const FlClipData.none()
      : this(top: false, bottom: false, left: false, right: false);

  final bool top;
  final bool bottom;
  final bool left;
  final bool right;

  /// 检查是否应剪裁任何一侧
  bool get any => top || bottom || left || right;

  /// 将当前 [FlBorderData] 复制到新的 [FlBorderData]，并替换提供的值。
  FlClipData copyWith({
    bool? top,
    bool? bottom,
    bool? left,
    bool? right,
  }) {
    return FlClipData(
      top: top ?? this.top,
      bottom: bottom ?? this.bottom,
      left: left ?? this.left,
      right: right ?? this.right,
    );
  }

  /// 用于相等性检查，请参阅 [EquatableMixin]。
  @override
  List<Object?> get props => [top, bottom, left, right];
}

/// 图表的触摸回调。
typedef BaseTouchCallback<R extends BaseTouchResponse> = void Function(
  FlTouchEvent,
  R?,
);

/// 它为您提供事件发生的 [FlTouchEvent] 和事件位置的现有 [R] 数据，
/// 然后，您应该提供 [MouseCursor] 来更改事件位置的光标。
/// 例如，可以传递 [SystemMouseCursors.click] 以将鼠标光标更改为单击。
typedef MouseCursorResolver<R extends BaseTouchResponse> = MouseCursor Function(
  FlTouchEvent,
  R?,
);

/// 此类包含图表的触摸响应详细信息。
abstract class BaseTouchResponse {
  const BaseTouchResponse();
}

/// 控制元素与给定点的水平对齐方式。
enum FLHorizontalAlignment {
  /// 水平居中显示的元素与给定点对齐。
  center,

  /// 元素显示在给定点的左侧。
  left,

  /// 元素显示在给定点的右侧。
  right,
}

/// Holds data of showing each row indicator in the tooltip popup.
class FlTooltipIndicator with EquatableMixin {
  /// Shows a indicator as a row in the tooltip popup.
  const FlTooltipIndicator({
    this.color,
    this.shape = BoxShape.circle,
    this.style = PaintingStyle.fill,
    this.gradient,
    this.width = 8.0,
    this.height = 8.0,
    this.radius,
  });

  /// Color of showing indicator.
  final Color? color;

  /// Width of showing indicator.
  final double width;

  /// Height of showing indicator.
  final double height;

  /// Shape of showing indicator.
  final BoxShape shape;

  /// Style of showing indicator.
  final PaintingStyle style;

  /// Gradient of showing indicator.
  final Gradient? gradient;

  /// Radius of showing indicator.
  final Radius? radius;

  /// Used for equality check, see [EquatableMixin].
  @override
  List<Object?> get props => [
        color,
        width,
        height,
        shape,
        style,
        gradient,
        radius,
      ];
}
