import 'package:flutter/material.dart';

typedef AnimatedIconBuilder = AnimatedIcon Function(
  BuildContext context,
  Animation<double> animation,
);

const Duration _kDuration = Duration(milliseconds: 300);

/// 动画图标按钮
class TxAnimatedIconButton extends StatefulWidget {
  const TxAnimatedIconButton({
    required this.icon,
    super.key,
    this.animation,
    this.duration,
    this.reverseDuration,
    this.iconSize,
    this.visualDensity,
    this.padding,
    this.alignment,
    this.splashRadius,
    this.focusColor,
    this.hoverColor,
    this.color,
    this.splashColor,
    this.highlightColor,
    this.disabledColor,
    this.onPressed,
    this.mouseCursor,
    this.focusNode,
    this.autofocus = false,
    this.tooltip,
    this.enableFeedback,
    this.constraints,
    this.style,
  }) : builder = null;

  const TxAnimatedIconButton.builder({
    required this.builder,
    super.key,
    this.animation,
    this.duration,
    this.reverseDuration,
    this.iconSize,
    this.visualDensity,
    this.padding,
    this.alignment,
    this.splashRadius,
    this.focusColor,
    this.hoverColor,
    this.color,
    this.splashColor,
    this.highlightColor,
    this.disabledColor,
    this.onPressed,
    this.mouseCursor,
    this.focusNode,
    this.autofocus = false,
    this.tooltip,
    this.enableFeedback,
    this.constraints,
    this.style,
  }) : icon = null;

  /// 动画时间
  final Duration? duration;

  /// 反向动画时间
  final Duration? reverseDuration;

  /// 动画
  final Animation<double>? animation;

  /// 动画图标
  final AnimatedIconData? icon;

  /// 动画图标构造方法
  final AnimatedIconBuilder? builder;

  /// 参考[IconButton.iconSize]
  final double? iconSize;

  /// 参考[IconButton.visualDensity]
  final VisualDensity? visualDensity;

  /// 参考[IconButton.padding]
  final EdgeInsetsGeometry? padding;

  /// 参考[IconButton.alignment]
  final AlignmentGeometry? alignment;

  /// 参考[IconButton.splashRadius]
  final double? splashRadius;

  /// 参考[IconButton.focusColor]
  final Color? focusColor;

  /// 参考[IconButton.hoverColor]
  final Color? hoverColor;

  /// 参考[IconButton.color]
  final Color? color;

  /// 参考[IconButton.splashColor]
  final Color? splashColor;

  /// 参考[IconButton.highlightColor]
  final Color? highlightColor;

  /// 参考[IconButton.disabledColor]
  final Color? disabledColor;

  /// 参考[IconButton.onPressed]
  final VoidCallback? onPressed;

  /// 参考[IconButton.mouseCursor]
  final MouseCursor? mouseCursor;

  /// 参考[IconButton.focusNode]
  final FocusNode? focusNode;

  /// 参考[IconButton.autofocus]
  final bool autofocus;

  /// 参考[IconButton.tooltip]
  final String? tooltip;

  /// 参考[IconButton.enableFeedback]
  final bool? enableFeedback;

  /// 参考[IconButton.constraints]
  final BoxConstraints? constraints;

  /// 参考[IconButton.style]
  final ButtonStyle? style;

  @override
  State<TxAnimatedIconButton> createState() => _TxAnimatedIconButtonState();
}

class _TxAnimatedIconButtonState extends State<TxAnimatedIconButton>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  void _onPress() {
    if (_controller != null) {
      if (_controller!.status == AnimationStatus.completed ||
          _controller!.status == AnimationStatus.forward) {
        _controller!.reverse();
      } else {
        _controller!.forward();
      }
    }
    widget.onPressed?.call();
  }

  @override
  void initState() {
    if (widget.animation == null) {
      _controller = AnimationController(
        vsync: this,
        duration: widget.duration ?? _kDuration,
        reverseDuration:
            widget.reverseDuration ?? widget.duration ?? _kDuration,
      );
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _onPress,
      icon: widget.builder == null
          ? AnimatedIcon(
              icon: widget.icon!,
              progress: widget.animation ?? _controller!,
            )
          : widget.builder!(context, widget.animation ?? _controller!),
      key: widget.key,
      iconSize: widget.iconSize,
      visualDensity: widget.visualDensity,
      padding: widget.padding,
      alignment: widget.alignment,
      splashRadius: widget.splashRadius,
      color: widget.color,
      focusColor: widget.focusColor,
      hoverColor: widget.hoverColor,
      highlightColor: widget.highlightColor,
      splashColor: widget.splashColor,
      disabledColor: widget.disabledColor,
      mouseCursor: widget.mouseCursor,
      focusNode: widget.focusNode,
      tooltip: widget.tooltip,
      enableFeedback: widget.enableFeedback,
      constraints: widget.constraints,
      style: widget.style,
    );
  }
}
