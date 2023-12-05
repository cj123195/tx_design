import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'toast_theme.dart';

const double _kVerticalGap = 8.0;
const double _kIndicatorSize = 40.0;
const double _kIndicatorWidth = 5.0;
const Color _kForegroundColor = Colors.white;
const Color _kBackgroundColor = Colors.black45;
const Color _kMaskColor = Colors.transparent;
const Duration _kAnimationDuration = Duration(milliseconds: 200);
const Duration _kDisplayDuration = Duration(milliseconds: 2000);
const VisualDensity _kDensity = VisualDensity.standard;
const EdgeInsetsGeometry _kPadding =
    EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0);
const BorderRadius _kBorderRadius = BorderRadius.all(Radius.circular(8.0));

/// Toast动画构造函数
typedef ToastAnimationBuilder = Widget Function(
  Widget child,
  AnimationController controller,
  AlignmentGeometry alignment,
);

typedef ToastStatusCallback = void Function(ToastStatus status);

/// Toast状态
enum ToastStatus {
  show, // 显示
  dismiss, // 隐藏
}

/// 轻提示动画
abstract class ToastAnimation extends StatelessWidget {
  const ToastAnimation({
    required this.child,
    required this.controller,
    super.key,
  });

  final Widget child;
  final AnimationController controller;
}

/// 平移动画
class OffsetAnimation extends ToastAnimation {
  const OffsetAnimation({
    required super.child,
    required super.controller,
    required this.alignment,
    super.key,
  });

  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    final Offset begin = alignment == AlignmentDirectional.topCenter
        ? const Offset(0, -1)
        : alignment == AlignmentDirectional.bottomCenter
            ? const Offset(0, 1)
            : const Offset(0, 0);
    final Animation<Offset> animation = Tween(
      begin: begin,
      end: const Offset(0, 0),
    ).animate(controller);

    return Opacity(
      opacity: controller.value,
      child: SlideTransition(
        position: animation,
        child: child,
      ),
    );
  }
}

/// 透明度动画
class OpacityAnimation extends ToastAnimation {
  const OpacityAnimation({
    required super.child,
    required super.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(opacity: controller.value, child: child);
  }
}

/// 缩放动画
class ScaleAnimation extends ToastAnimation {
  const ScaleAnimation({
    required super.child,
    required super.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: controller.value,
      child: ScaleTransition(
        scale: controller,
        child: child,
      ),
    );
  }
}

/// 轻提示的位置
enum ToastPosition {
  top,
  center,
  bottom;

  AlignmentGeometry get alignment {
    switch (this) {
      case ToastPosition.top:
        return AlignmentDirectional.topCenter;
      case ToastPosition.center:
        return AlignmentDirectional.center;
      case ToastPosition.bottom:
        return AlignmentDirectional.bottomCenter;
    }
  }
}

/// 轻提示
///
/// 在页面中间弹出提示，用于消息通知、加载提示、操作结果提示等场景。
///
/// 使用时需在Material方法中传入builder参数。
/// dart
/// '''
/// Widget build(BuildContext context) {
///     return MaterialApp(
///       title: 'Flutter Toast',
///       home: MyHomePage(title: 'Flutter Toast'),
///       builder: Toast.init(),
///     );
///   }
/// '''
class Toast {
  factory Toast() => _instance;

  Toast._internal();

  static final Toast _instance = Toast._internal();

  static Toast get instance => _instance;

  Timer? _timer;

  GlobalKey<ToastContainerState>? _key;

  GlobalKey<ToastContainerState>? get key => _key;

  GlobalKey<ToastProgressState>? _progressKey;

  GlobalKey<ToastProgressState>? get progressKey => _progressKey;

  GlobalKey<MessageAndIndicatorState>? _loadingMessageKey;

  GlobalKey<MessageAndIndicatorState>? get loadingMessageKey =>
      _loadingMessageKey;

  GlobalKey<MessageAndIndicatorState>? _messageKey;

  GlobalKey<MessageAndIndicatorState>? get messageKey => _messageKey;

  late ToastThemeData _theme;

  ToastThemeData get theme => _theme;

  ToastOverlayEntry? overlayEntry;

  /// 监听器列表
  final List<ValueChanged<ToastStatus>> _statusCallbacks =
      <ValueChanged<ToastStatus>>[];

  /// 当前Toast是否正在显示
  static bool get isShow => _instance._container != null;

  /// 当前显示的容器
  Widget? _container;

  static TextStyle _textStyle(ToastThemeData theme, TextStyle? style) {
    return style ?? theme.textStyle ?? const TextStyle();
  }

  static TextAlign _textAlign(ToastThemeData theme, TextAlign? align) {
    return align ?? theme.textAlign ?? TextAlign.center;
  }

  static Color _foreground(ToastThemeData theme, Color? foregroundColor) {
    return foregroundColor ?? theme.foregroundColor ?? _kForegroundColor;
  }

  static double _verticalGap(ToastThemeData theme, double? verticalGap) {
    return verticalGap ?? theme.verticalGap ?? _kVerticalGap;
  }

  static double _indicatorWidth(ToastThemeData theme, double? indicatorWidth) {
    return indicatorWidth ?? theme.indicatorWidth ?? _kIndicatorWidth;
  }

  static double _indicatorSize(ToastThemeData theme, double? indicatorSize) {
    return indicatorSize ?? theme.indicatorSize ?? _kIndicatorSize;
  }

  static Widget? _indicator(ToastThemeData theme, Widget? indicator) {
    return indicator ?? theme.indicator;
  }

  static VisualDensity _visualDensity(
      ToastThemeData theme, VisualDensity? density) {
    return density ?? theme.visualDensity ?? _kDensity;
  }

  /// 拼接指示器与文字
  static Widget _spliceTextAndIndicator(
    ToastThemeData theme,
    Widget indicator,
    Widget? text,
    double? verticalGap,
    VisualDensity? visualDensity,
  ) {
    final double gap = _verticalGap(theme, verticalGap);
    final VisualDensity density = _visualDensity(theme, visualDensity);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        indicator,
        SizedBox(height: gap + density.vertical),
        if (text != null) text
      ],
    );
  }

  /// 创建文字
  static Widget _createText(
    ToastThemeData theme,
    String text, {
    Color? foregroundColor,
    TextAlign? textAlign,
    TextStyle? textStyle,
  }) {
    final TextStyle style =
        _textStyle(theme, textStyle).copyWith(color: foregroundColor);
    final TextAlign align = _textAlign(theme, textAlign);

    return Text(
      text,
      style: style,
      overflow: TextOverflow.ellipsis,
      maxLines: 4,
      textAlign: align,
    );
  }

  /// 初始化 Toast
  static TransitionBuilder init({TransitionBuilder? builder}) {
    return (BuildContext context, Widget? child) {
      _instance._theme = ToastTheme.of(context);

      if (builder != null) {
        return builder(context, FlutterToast(child: child));
      } else {
        return FlutterToast(child: child);
      }
    };
  }

  /// 显示轻提示
  Future<void> _show(
    ToastThemeData theme, {
    required Widget child,
    Color? backgroundColor,
    Color? maskColor,
    Duration? animationDuration,
    Duration? displayDuration,
    bool? dismissOnTap,
    bool? isInteractive,
    ToastPosition? position,
    ToastAnimationBuilder? animationBuilder,
    EdgeInsetsGeometry? padding,
    BorderRadius? borderRadius,
  }) async {
    final bool animation = _container == null;
    _progressKey = null;
    _loadingMessageKey = null;
    _messageKey = null;
    if (_key != null) {
      await dismiss(animation: false);
    }

    final Completer<void> completer = Completer<void>();
    _key = GlobalKey<ToastContainerState>();

    final Color background =
        backgroundColor ?? theme.backgroundColor ?? _kBackgroundColor;
    final Color effectiveMaskColor =
        maskColor ?? theme.maskColor ?? _kMaskColor;
    final Duration effectiveAnimationDuration =
        animationDuration ?? theme.animationDuration ?? _kAnimationDuration;
    final bool effectiveDismissOnTap =
        dismissOnTap ?? theme.dismissOnTap ?? false;
    final bool effectiveIsInteractive =
        isInteractive ?? theme.isInteractive ?? true;
    final ToastPosition effectivePosition =
        position ?? theme.position ?? ToastPosition.center;
    final ToastAnimationBuilder effectiveBuilder = animationBuilder ??
        theme.animationBuilder ??
        (child, controller, alignment) =>
            OpacityAnimation(controller: controller, child: child);
    final EdgeInsetsGeometry effectivePadding =
        padding ?? theme.padding ?? _kPadding;
    final BorderRadius effectiveBorderRadius =
        borderRadius ?? theme.borderRadius ?? _kBorderRadius;

    _container = ToastContainer(
      key: _key,
      backgroundColor: background,
      maskColor: effectiveMaskColor,
      duration: effectiveAnimationDuration,
      dismissOnTap: effectiveDismissOnTap,
      isInteractive: effectiveIsInteractive,
      position: effectivePosition,
      animation: animation,
      padding: effectivePadding,
      borderRadius: effectiveBorderRadius,
      animationBuilder: effectiveBuilder,
      completer: completer,
      child: child,
    );

    completer.future.whenComplete(() {
      _callback(ToastStatus.show);
      if (displayDuration != null) {
        _cancelTimer();
        _timer = Timer(displayDuration, () async {
          await dismiss();
        });
      }
    });
    _markNeedsBuild();
    return completer.future;
  }

  ///

  /// 显示加载状态
  ///
  /// [updateOnly] 只更新，值为true时，如果当前Toast已为loading状态，则只更新[message]
  /// 内容，不会重新弹出。
  static Future<void> loading({
    BuildContext? context,
    String? message,
    Widget? indicator,
    TextStyle? textStyle,
    Color? backgroundColor,
    Color? foregroundColor,
    EdgeInsetsGeometry? padding,
    BorderRadius? borderRadius,
    VisualDensity? visualDensity,
    TextAlign? textAlign,
    Color? maskColor,
    double? verticalGap,
    double? indicatorSize,
    double? indicatorWidth,
    ToastPosition? position,
    Duration? animationDuration,
    ToastAnimationBuilder? animationBuilder,
    bool? dismissOnTap = true,
    bool? isInteractive = false,
    bool updateOnly = true,
  }) async {
    final ToastThemeData theme =
        context == null ? _instance._theme : ToastTheme.of(context);
    final Color foreground = _foreground(theme, foregroundColor);
    Widget? effectiveIndicator = _indicator(theme, indicator);
    if (effectiveIndicator == null) {
      final double size = _indicatorSize(theme, indicatorSize);
      final double width = _indicatorWidth(theme, indicatorWidth);
      effectiveIndicator = ConstrainedBox(
        constraints: BoxConstraints(maxWidth: size, maxHeight: size),
        child: CircularProgressIndicator(strokeWidth: width, color: foreground),
      );
    }

    if (!updateOnly) {
      return await _instance._show(
        theme,
        dismissOnTap: dismissOnTap,
        child: effectiveIndicator,
        backgroundColor: backgroundColor,
        maskColor: maskColor,
        animationDuration: animationDuration,
        position: position,
        padding: padding,
        isInteractive: isInteractive,
        animationBuilder: animationBuilder,
        borderRadius: borderRadius,
      );
    }

    if (instance._loadingMessageKey == null) {
      final GlobalKey<MessageAndIndicatorState> loadingKey =
          GlobalKey<MessageAndIndicatorState>();
      effectiveIndicator = MessageAndIndicator(
        message: message,
        indicator: effectiveIndicator,
        key: loadingKey,
        foregroundColor: foreground,
        textAlign: textAlign,
        textStyle: textStyle,
        verticalGap: verticalGap,
        visualDensity: visualDensity,
      );
      instance._loadingMessageKey = loadingKey;
      return _instance._show(
        theme,
        dismissOnTap: dismissOnTap,
        child: effectiveIndicator,
        backgroundColor: backgroundColor,
        maskColor: maskColor,
        animationDuration: animationDuration,
        position: position,
        padding: padding,
        isInteractive: isInteractive,
        animationBuilder: animationBuilder,
        borderRadius: borderRadius,
      );
    } else {
      // 更新消息
      _instance.loadingMessageKey?.currentState?.updateMessage(message);
    }
  }

  /// 显示进度，值应在0.0-1.0之间。
  static Future<void> showProgress(
    double value, {
    BuildContext? context,
    String? message,
    TextStyle? textStyle,
    Color? backgroundColor,
    Color? foregroundColor,
    EdgeInsetsGeometry? padding,
    BorderRadius? borderRadius,
    VisualDensity? visualDensity,
    TextAlign? textAlign,
    Color? maskColor,
    double? verticalGap,
    double? indicatorSize,
    double? indicatorWidth,
    ToastPosition? position,
    Duration? animationDuration,
    ToastAnimationBuilder? animationBuilder,
    bool? dismissOnTap,
    bool? isInteractive,
  }) async {
    assert(
      value >= 0.0 && value <= 1.0,
      'progress value should be 0.0 ~ 1.0',
    );

    final ToastThemeData theme =
        context == null ? _instance._theme : ToastTheme.of(context);
    final Color foreground = _foreground(theme, foregroundColor);
    final double effectiveIndicatorSize = _indicatorSize(theme, indicatorSize);
    final double effectiveIndicatorWidth =
        _indicatorWidth(theme, indicatorWidth);

    Widget indicator;
    if (_instance._container == null || _instance.progressKey == null) {
      if (_instance.key != null) {
        await dismiss(animation: false);
      }
      final GlobalKey<ToastProgressState> progressKey =
          GlobalKey<ToastProgressState>();
      final GlobalKey<MessageAndIndicatorState> messageKey =
          GlobalKey<MessageAndIndicatorState>();
      indicator = ToastProgress(
        key: progressKey,
        value: value,
        size: effectiveIndicatorSize,
        color: foreground,
        width: effectiveIndicatorWidth,
      );

      if (message != null) {
        indicator = MessageAndIndicator(
          key: messageKey,
          textStyle: textStyle,
          textAlign: textAlign,
          foregroundColor: foreground,
          message: message,
          indicator: indicator,
          verticalGap: verticalGap,
          visualDensity: visualDensity,
        );
      }

      _instance._show(
        theme,
        child: indicator,
        dismissOnTap: dismissOnTap,
        backgroundColor: backgroundColor,
        maskColor: maskColor,
        displayDuration: animationDuration,
        position: position,
        padding: padding,
        isInteractive: isInteractive,
        animationBuilder: animationBuilder,
        borderRadius: borderRadius,
      );
      _instance._messageKey = messageKey;
      _instance._progressKey = progressKey;
    } else {
      // 更新进度
      _instance.progressKey?.currentState?.updateProgress(math.min(1.0, value));
      // 更新消息
      _instance.messageKey?.currentState?.updateMessage(message);
    }
  }

  /// 显示成功状态
  static Future<void> success(
    String message, {
    BuildContext? context,
    Widget? successIcon,
    TextStyle? textStyle,
    Color? backgroundColor,
    Color? foregroundColor,
    EdgeInsetsGeometry? padding,
    BorderRadius? borderRadius,
    VisualDensity? visualDensity,
    TextAlign? textAlign,
    Color? maskColor,
    double? verticalGap,
    double? indicatorSize,
    ToastPosition? position,
    Duration? displayDuration,
    ToastAnimationBuilder? animationBuilder,
    bool? dismissOnTap,
    bool? isInteractive,
  }) {
    final ToastThemeData theme =
        context == null ? _instance._theme : ToastTheme.of(context);
    final Color foreground = _foreground(theme, foregroundColor);
    final double effectiveIndicatorSize = _indicatorSize(theme, indicatorSize);
    final Widget effectiveSuccessIcon = successIcon ??
        theme.successIcon ??
        Icon(
          Icons.done,
          color: foreground,
          size: effectiveIndicatorSize,
        );

    return _showMsgWithIcon(
      message,
      effectiveSuccessIcon,
      theme,
      dismissOnTap: dismissOnTap,
      backgroundColor: backgroundColor,
      foregroundColor: foreground,
      textStyle: textStyle,
      textAlign: textAlign,
      visualDensity: visualDensity,
      verticalGap: verticalGap,
      maskColor: maskColor,
      duration: displayDuration,
      position: position,
      padding: padding,
      isInteractive: isInteractive,
      animationBuilder: animationBuilder,
      borderRadius: borderRadius,
    );
  }

  /// 显示失败状态
  static Future<void> error(
    String message, {
    BuildContext? context,
    Widget? errorIcon,
    TextStyle? textStyle,
    Color? backgroundColor,
    Color? foregroundColor,
    EdgeInsetsGeometry? padding,
    BorderRadius? borderRadius,
    VisualDensity? visualDensity,
    TextAlign? textAlign,
    Color? maskColor,
    double? verticalGap,
    double? indicatorSize,
    ToastPosition? position,
    Duration? displayDuration,
    ToastAnimationBuilder? animationBuilder,
    bool? dismissOnTap,
    bool? isInteractive,
  }) {
    final ToastThemeData theme =
        context == null ? _instance._theme : ToastTheme.of(context);
    final Color foreground = _foreground(theme, foregroundColor);
    final double effectiveIndicatorSize = _indicatorSize(theme, indicatorSize);
    final Widget effectiveErrorIcon = errorIcon ??
        theme.errorIcon ??
        Icon(
          Icons.clear,
          color: foreground,
          size: effectiveIndicatorSize,
        );

    return _showMsgWithIcon(
      message,
      effectiveErrorIcon,
      theme,
      dismissOnTap: dismissOnTap,
      backgroundColor: backgroundColor,
      foregroundColor: foreground,
      textStyle: textStyle,
      textAlign: textAlign,
      visualDensity: visualDensity,
      verticalGap: verticalGap,
      maskColor: maskColor,
      duration: displayDuration,
      position: position,
      padding: padding,
      isInteractive: isInteractive,
      animationBuilder: animationBuilder,
      borderRadius: borderRadius,
    );
  }

  /// 显示信息
  static Future<void> showInfo(
    String message, {
    BuildContext? context,
    Widget? icon,
    TextStyle? textStyle,
    Color? backgroundColor,
    Color? foregroundColor,
    EdgeInsetsGeometry? padding,
    BorderRadius? borderRadius,
    VisualDensity? visualDensity,
    TextAlign? textAlign,
    Color? maskColor,
    double? verticalGap,
    double? indicatorSize,
    ToastPosition? position,
    Duration? displayDuration,
    ToastAnimationBuilder? animationBuilder,
    bool? dismissOnTap,
    bool? isInteractive,
  }) {
    final ToastThemeData theme =
        context == null ? _instance._theme : ToastTheme.of(context);
    final Color foreground = _foreground(theme, foregroundColor);
    final double effectiveIndicatorSize = _indicatorSize(theme, indicatorSize);
    final Widget effectiveIcon = icon ??
        theme.informationIcon ??
        Icon(
          Icons.info,
          color: foreground,
          size: effectiveIndicatorSize,
        );

    return _showMsgWithIcon(
      message,
      effectiveIcon,
      theme,
      dismissOnTap: dismissOnTap,
      backgroundColor: backgroundColor,
      foregroundColor: foreground,
      textStyle: textStyle,
      textAlign: textAlign,
      visualDensity: visualDensity,
      verticalGap: verticalGap,
      maskColor: maskColor,
      duration: displayDuration,
      position: position,
      padding: padding,
      isInteractive: isInteractive,
      animationBuilder: animationBuilder,
      borderRadius: borderRadius,
    );
  }

  static Future<void> _showMsgWithIcon(
    String message,
    Widget icon,
    ToastThemeData theme, {
    TextStyle? textStyle,
    Color? backgroundColor,
    Color? foregroundColor,
    EdgeInsetsGeometry? padding,
    BorderRadius? borderRadius,
    VisualDensity? visualDensity,
    TextAlign? textAlign,
    Color? maskColor,
    double? verticalGap,
    ToastPosition? position,
    Duration? duration,
    ToastAnimationBuilder? animationBuilder,
    bool? dismissOnTap,
    bool? isInteractive,
  }) {
    final Duration displayDuration =
        duration ?? theme.displayDuration ?? _kDisplayDuration;
    final Widget text = _createText(
      theme,
      message,
      textAlign: textAlign,
      textStyle: textStyle,
      foregroundColor: foregroundColor,
    );
    final Widget child = _spliceTextAndIndicator(
      theme,
      icon,
      text,
      verticalGap,
      visualDensity,
    );

    return _instance._show(
      theme,
      dismissOnTap: dismissOnTap,
      child: child,
      backgroundColor: backgroundColor,
      maskColor: maskColor,
      displayDuration: displayDuration,
      position: position,
      padding: padding,
      isInteractive: isInteractive,
      animationBuilder: animationBuilder,
      borderRadius: borderRadius,
    );
  }

  /// 文字提示
  static Future<void> show(
    String message, {
    BuildContext? context,
    TextStyle? textStyle,
    Color? backgroundColor,
    Color? foregroundColor,
    EdgeInsetsGeometry? padding,
    BorderRadius? borderRadius,
    TextAlign? textAlign,
    Color? maskColor,
    ToastPosition? position,
    Duration? displayDuration,
    ToastAnimationBuilder? animationBuilder,
    bool? dismissOnTap,
    bool? isInteractive,
  }) {
    final ToastThemeData theme =
        context == null ? _instance._theme : ToastTheme.of(context);
    final Duration effectiveDisplayDuration =
        displayDuration ?? theme.displayDuration ?? _kDisplayDuration;
    final Color effectiveForegroundColor = _foreground(theme, foregroundColor);
    final Widget child = _createText(
      theme,
      message,
      textAlign: textAlign,
      textStyle: textStyle,
      foregroundColor: effectiveForegroundColor,
    );

    return _instance._show(
      theme,
      dismissOnTap: dismissOnTap,
      child: child,
      backgroundColor: backgroundColor,
      maskColor: maskColor,
      displayDuration: effectiveDisplayDuration,
      position: position,
      padding: padding,
      isInteractive: isInteractive,
      animationBuilder: animationBuilder,
      borderRadius: borderRadius,
    );
  }

  /// 关闭Toast
  static Future<void> dismiss({bool animation = true}) {
    // cancel timer
    return _instance._dismiss(animation);
  }

  /// 添加加载状态回调
  static void addStatusCallback(ToastStatusCallback callback) {
    if (!_instance._statusCallbacks.contains(callback)) {
      _instance._statusCallbacks.add(callback);
    }
  }

  /// 删除单个加载状态回调
  static void removeCallback(ToastStatusCallback callback) {
    if (_instance._statusCallbacks.contains(callback)) {
      _instance._statusCallbacks.remove(callback);
    }
  }

  /// 删除所有加载状态回调
  static void removeAllCallbacks() {
    _instance._statusCallbacks.clear();
  }

  /// 关闭
  Future<void> _dismiss(bool animation) async {
    if (key != null && key?.currentState == null) {
      _reset();
      return;
    }

    return key?.currentState?.dismiss(animation).whenComplete(_reset);
  }

  /// 退出定时器
  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  /// 重置状态
  void _reset() {
    _container = null;
    _key = null;
    _progressKey = null;
    _loadingMessageKey = null;
    _messageKey = null;
    _cancelTimer();
    _markNeedsBuild();
    _callback(ToastStatus.dismiss);
  }

  /// 调用所有监听器
  void _callback(ToastStatus status) {
    for (final ValueChanged<ToastStatus> callback in _statusCallbacks) {
      callback(status);
    }
  }

  /// 刷新
  void _markNeedsBuild() {
    overlayEntry?.markNeedsBuild();
  }
}

///遮罩
class ToastOverlayEntry extends OverlayEntry {
  ToastOverlayEntry({required super.builder});

  @override
  void markNeedsBuild() {
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        super.markNeedsBuild();
      });
    } else {
      super.markNeedsBuild();
    }
  }
}

/// Toast容器
class ToastContainer extends StatefulWidget {
  const ToastContainer({
    required this.child,
    required this.backgroundColor,
    required this.maskColor,
    required this.duration,
    required this.dismissOnTap,
    required this.isInteractive,
    required this.position,
    required this.animationBuilder,
    required this.padding,
    required this.borderRadius,
    this.animation = true,
    this.completer,
    super.key,
  });

  /// 在树中此小部件下的小部件
  final Widget child;

  /// 在[child]后显示的背景颜色
  final Color backgroundColor;

  /// 遮罩层颜色
  final Color maskColor;

  /// 动画时间
  final Duration duration;

  /// 是否点击关闭
  final bool dismissOnTap;

  /// 是够允许用户交互
  final bool isInteractive;

  /// 弹框位置
  final ToastPosition position;

  /// 动画方式
  final ToastAnimationBuilder animationBuilder;

  /// 是否使用动画
  final bool animation;

  /// 填充边框与[child]的空间
  final EdgeInsetsGeometry padding;

  /// 圆角大小
  final BorderRadius borderRadius;

  /// 结束回调
  final Completer<void>? completer;

  @override
  ToastContainerState createState() => ToastContainerState();
}

class ToastContainerState extends State<ToastContainer>
    with SingleTickerProviderStateMixin {
  Color? _maskColor;
  late AnimationController _animationController;
  late AlignmentGeometry _alignment;
  late bool _dismissOnTap;
  late bool _ignoring;

  bool get isPersistentCallbacks =>
      SchedulerBinding.instance.schedulerPhase ==
      SchedulerPhase.persistentCallbacks;

  @override
  void initState() {
    super.initState();
    if (!mounted) {
      return;
    }
    _alignment = widget.position.alignment;
    _dismissOnTap = widget.dismissOnTap;
    _ignoring = _dismissOnTap ? false : widget.isInteractive;
    _maskColor = widget.maskColor;
    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..addStatusListener((status) {
        final bool isCompleted = widget.completer?.isCompleted ?? false;
        if (status == AnimationStatus.completed && !isCompleted) {
          widget.completer?.complete();
        }
      });
    show(widget.animation);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> show(bool animation) {
    if (isPersistentCallbacks) {
      final Completer<Future> completer = Completer<Future>();
      SchedulerBinding.instance.addPostFrameCallback((_) => completer
          .complete(_animationController.forward(from: animation ? 0 : 1)));
      return completer.future;
    } else {
      return _animationController.forward(from: animation ? 0 : 1);
    }
  }

  Future<void> dismiss(bool animation) {
    if (isPersistentCallbacks) {
      final Completer<Future> completer = Completer<Future>();
      SchedulerBinding.instance.addPostFrameCallback((_) => completer
          .complete(_animationController.reverse(from: animation ? 1 : 0)));
      return completer.future;
    } else {
      return _animationController.reverse(from: animation ? 1 : 0);
    }
  }

  void _onTap() async {
    if (_dismissOnTap) {
      await Toast.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, index) {
        Widget child = Container(
          width: double.infinity,
          height: double.infinity,
          color: _maskColor,
          alignment: _alignment,
          child: widget.animationBuilder(
            DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: widget.borderRadius,
                color: widget.backgroundColor,
              ),
              child: Padding(padding: widget.padding, child: widget.child),
            ),
            _animationController,
            _alignment,
          ),
        );
        if (_dismissOnTap) {
          child = GestureDetector(
            onTap: _onTap,
            behavior: HitTestBehavior.translucent,
            child: child,
          );
        }
        return IgnorePointer(ignoring: _ignoring, child: child);
      },
    );
  }
}

class MessageAndIndicator extends StatefulWidget {
  const MessageAndIndicator({
    required this.message,
    required this.indicator,
    this.textStyle,
    this.textAlign,
    this.verticalGap,
    this.visualDensity,
    this.foregroundColor,
    super.key,
  });

  final Widget indicator;
  final String? message;
  final double? verticalGap;
  final VisualDensity? visualDensity;
  final TextStyle? textStyle;
  final TextAlign? textAlign;
  final Color? foregroundColor;

  @override
  State<MessageAndIndicator> createState() => MessageAndIndicatorState();
}

class MessageAndIndicatorState extends State<MessageAndIndicator> {
  GlobalKey<ToastMessageState>? _messageKey;
  String? _message;

  void updateMessage(String? message) {
    if (message != _message) {
      if (message == null) {
        setState(() {
          _messageKey = null;
        });
      } else {
        _messageKey ??= GlobalKey<ToastMessageState>();
        _messageKey!.currentState!.updateMessage(message);
      }
    }
  }

  @override
  void initState() {
    if (widget.message != null) {
      _messageKey = GlobalKey<ToastMessageState>();
      _message = widget.message;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Toast._spliceTextAndIndicator(
      ToastTheme.of(context),
      widget.indicator,
      _message == null
          ? null
          : ToastMessage(
              message: _message!,
              key: _messageKey,
              textAlign: widget.textAlign,
              style: widget.textStyle,
              color: widget.foregroundColor,
            ),
      widget.verticalGap,
      widget.visualDensity,
    );
  }
}

/// 提示消息
class ToastMessage extends StatefulWidget {
  const ToastMessage({
    required this.message,
    this.style,
    this.textAlign,
    this.color,
    super.key,
  });

  final String message;
  final TextStyle? style;
  final TextAlign? textAlign;
  final Color? color;

  @override
  State<ToastMessage> createState() => ToastMessageState();
}

class ToastMessageState extends State<ToastMessage> {
  late String _message;

  void updateMessage(String message) {
    setState(() {
      _message = message;
    });
  }

  @override
  void initState() {
    _message = widget.message;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Toast._createText(
      ToastTheme.of(context),
      _message,
      textStyle: widget.style,
      foregroundColor: widget.color,
      textAlign: widget.textAlign,
    );
  }
}

/// 提示进度
class ToastProgress extends StatefulWidget {
  const ToastProgress({
    required this.value,
    required this.size,
    required this.color,
    required this.width,
    super.key,
  });

  final double value;
  final double size;
  final Color color;
  final double width;

  @override
  ToastProgressState createState() => ToastProgressState();
}

class ToastProgressState extends State<ToastProgress> {
  /// 进度值，应在0.0~1.0之间
  double _value = 0;

  @override
  void initState() {
    _value = widget.value;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void updateProgress(double value) {
    setState(() {
      _value = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: _CircleProgress(
        value: _value,
        color: widget.color,
        width: widget.width,
      ),
    );
  }
}

/// 进度条
class _CircleProgress extends ProgressIndicator {
  const _CircleProgress({
    required double value,
    required this.width,
    required Color color,
  }) : super(color: color, value: value);

  final double width;

  @override
  _CircleProgressState createState() => _CircleProgressState();
}

class _CircleProgressState extends State<_CircleProgress> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CirclePainter(
        color: widget.color!,
        value: widget.value!,
        width: widget.width,
      ),
    );
  }
}

class _CirclePainter extends CustomPainter {
  _CirclePainter({
    required this.color,
    required this.value,
    required this.width,
  });

  final Color color;
  final double value;
  final double width;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = width
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Offset.zero & size,
      -math.pi / 2,
      math.pi * 2 * value,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_CirclePainter oldDelegate) => value != oldDelegate.value;
}

class FlutterToast extends StatefulWidget {
  const FlutterToast({required this.child, super.key});

  final Widget? child;

  @override
  State createState() => _FlutterToastState();
}

class _FlutterToastState extends State<FlutterToast> {
  late ToastOverlayEntry _overlayEntry;

  @override
  void initState() {
    super.initState();
    _overlayEntry = ToastOverlayEntry(
      builder: (BuildContext context) =>
          Toast.instance._container ?? Container(),
    );
    Toast.instance.overlayEntry = _overlayEntry;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Overlay(
          initialEntries: [
            ToastOverlayEntry(
              builder: (BuildContext context) {
                if (widget.child != null) {
                  return widget.child!;
                } else {
                  return Container();
                }
              },
            ),
            _overlayEntry,
          ],
        ),
      ),
    );
  }
}
