import 'dart:math' as math;

import 'package:flutter/material.dart';

const double _radiansPerDegree = math.pi / 180;
const double _defaultRadius = 100.0;
const double _totalAngle = 180.0;
const double _startAngle = -90.0;
const Duration _kAnimationDuration = Duration(milliseconds: 1000);
const double _defaultButtonSize = 48.0;

/// [RadialMenu]中的一项
///
/// 类型[T]是每项代表的值的类型. 给定菜单中的所有条目必须表示具有一致类型的值。
class RadialMenuItem<T> extends StatelessWidget {
  const RadialMenuItem({
    required this.child,
    super.key,
    this.value,
    this.tooltip,
    this.backgroundColor,
    this.size = _defaultButtonSize,
    this.iconColor,
  });

  /// 树中此小部件下方的小部件
  ///
  /// 通常是一个 [Icon] 组件
  final Widget child;

  /// 如果用户选择此菜单项的返回值
  ///
  /// 最终会在 [RadialMenu.onSelect] 回调中返回
  final T? value;

  /// 描述按下按钮时将发生的操作的提示性文字.
  ///
  /// 当用户长按按钮时会显示此文本并用于辅助功能。
  final String? tooltip;

  /// 按钮的背景色
  ///
  /// 默认为当前主题的[Theme.of(context).primaryColor]。
  final Color? backgroundColor;

  /// 按钮的大小。
  ///
  /// 默认为 48.0
  final double? size;

  /// 绘制子图标时使用的颜色。
  ///
  /// 默认为[Theme.of(context).iconColor].
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final Color? iconColor =
        this.iconColor ?? Theme.of(context).primaryIconTheme.color;

    Widget child = Center(
      child: IconTheme.merge(
          data: IconThemeData(color: iconColor), child: this.child),
    );

    if (tooltip != null) {
      child = Tooltip(
        message: tooltip!,
        child: child,
      );
    }

    return SizedBox(
      width: size,
      height: size,
      child: child,
    );
  }
}

typedef ItemAngleCalculator = double Function(
    double totalAngle, double startAngle, int index);

/// 用于从项目列表中进行选择的径向菜单。
///
/// 径向菜单允许用户从多个项目中进行选择. 它显示一个打开菜单的按钮，显示按弧形排列的项目。
/// 选择一个项目会触发在中央菜单按钮周围指定 [半径] 处绘制的进度条的动画。
///
/// 类型[T]是径向菜单所代表的值的类型。给定菜单中的所有条目必须表示具有一致类型的值。
/// 通常使用枚举. [items]中的每一个[RadialMenuItem]必须用相同的类型参数。
///
/// See also:
///
///  * [RadialMenuItem], 用于表示[items]的小部件。
///  * [RadialMenuCenterButton], 用于打开和关闭菜单的按钮。
class RadialMenu<T> extends StatefulWidget {
  const RadialMenu({
    required this.items,
    super.key,
    this.onSelect,
    this.radius = _defaultRadius,
    this.menuAnimationDuration = _kAnimationDuration,
    this.progressAnimationDuration = _kAnimationDuration,
    this.totalAngle = _totalAngle,
    this.startAngle = _startAngle,
  });

  /// 要从中选择的项目的列表。
  final List<RadialMenuItem<T>> items;

  /// 当用户选择一个项目时调用。
  final ValueChanged<T>? onSelect;

  /// 用于布置项目和绘制进度条的圆弧半径。
  ///
  /// 默认为 100.0.
  final double radius;

  /// 用于布置项目和绘制进度条的圆弧角度。
  ///
  /// 默认为 360.0.
  final double totalAngle;

  /// 用于布置项目和绘制进度条的圆弧开始绘制的角度。
  ///
  /// 默认为 -90.
  final double startAngle;

  /// 菜单打开关闭动画的持续时间。
  ///
  /// 默认为 1000 毫秒。
  final Duration? menuAnimationDuration;

  /// 动作激活进度弧动画的持续时间。
  ///
  /// 默认为 1000 毫秒。
  final Duration? progressAnimationDuration;

  @override
  RadialMenuState createState() => RadialMenuState();
}

class RadialMenuState extends State<RadialMenu> with TickerProviderStateMixin {
  late AnimationController _menuController;
  late AnimationController _progressController;
  bool _isOpen = false;
  int? _activeIndex;

  double calculateItemAngle(double totalAngle, double startAngle, int index) {
    final double itemSpacing = totalAngle / widget.items.length;
    return (startAngle + index * itemSpacing) * _radiansPerDegree;
  }

  void _openMenu() {
    _menuController.forward();
    setState(() {
      _isOpen = true;
    });
  }

  void _closeMenu() async {
    if (!_progressController.isDismissed) {
      await _progressController.reverse();
      setState(() {
        _activeIndex = null;
      });
    } else {
      _menuController.reverse();
      setState(() {
        _isOpen = false;
      });
    }
  }

  Future<void> _activate(int itemIndex) async {
    setState(() {
      _activeIndex = itemIndex;
    });
    await _progressController.forward();
    if (widget.onSelect != null) {
      widget.onSelect!(widget.items[itemIndex].value);
    }
  }

  void reset() {
    _menuController.reset();
    _progressController.reverse();
    setState(() {
      _isOpen = false;
      _activeIndex = null;
    });
  }

  @override
  void initState() {
    _menuController = AnimationController(
        vsync: this, duration: widget.menuAnimationDuration);
    _progressController = AnimationController(
        vsync: this, duration: widget.progressAnimationDuration);
    super.initState();
  }

  @override
  void dispose() {
    _menuController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[];

    for (int i = 0; i < widget.items.length; i++) {
      if (_activeIndex != i) {
        children.add(_actionButton(i));
      }
    }

    if (_activeIndex != null) {
      children.add(_activeAction(_activeIndex!));
    }

    children.add(_centerButton());

    return SizedBox(
      width: widget.radius * 2,
      height: widget.radius * 2,
      child: AnimatedBuilder(
          animation: _menuController,
          builder: (context, child) {
            return CustomMultiChildLayout(
              delegate: _RadialMenuLayout(
                  itemCount: widget.items.length + 1,
                  radius: widget.radius,
                  calculateItemAngle: calculateItemAngle,
                  controller: _menuController,
                  totalAngle: widget.totalAngle,
                  startAngle: widget.startAngle),
              children: children,
            );
          }),
    );
  }

  Widget _actionButton(int index) {
    final RadialMenuItem item = widget.items[index];

    return LayoutId(
        id: '${_RadialMenuLayout.actionButton}$index',
        child: RadialMenuButton(
          backgroundColor: item.backgroundColor,
          onPressed: () => _activate(index),
          child: item,
        ));
  }

  Widget _activeAction(int index) {
    final RadialMenuItem item = widget.items[index];
    return LayoutId(
        id: '${_RadialMenuLayout.activeAction}$index',
        child: _ArcProgressIndicator(
          radius: widget.radius,
          controller: _progressController.view,
          color: item.backgroundColor,
          icon: item.child is Icon ? (item.child as Icon).icon : null,
          iconColor: item.iconColor,
          iconSize: item.size,
          width: item.size,
          startAngle:
              calculateItemAngle(widget.totalAngle, widget.startAngle, index),
        ));
  }

  Widget _centerButton() {
    return LayoutId(
        id: _RadialMenuLayout.menuButton,
        child: RadialMenuCenterButton(
          openCloseAnimationController: _menuController.view,
          activateAnimationController: _progressController.view,
          isOpen: _isOpen,
          onPressed: _isOpen ? _closeMenu : _openMenu,
        ));
  }
}

class _RadialMenuLayout extends MultiChildLayoutDelegate {
  _RadialMenuLayout({
    required this.itemCount,
    required this.radius,
    required this.calculateItemAngle,
    required this.controller,
    this.startAngle = 0,
    this.totalAngle = 360,
  }) : _progress = Tween<double>(begin: 0.0, end: radius).animate(
            CurvedAnimation(parent: controller, curve: Curves.elasticInOut));
  static const String menuButton = 'menuButton';
  static const String actionButton = 'actionButton';
  static const String activeAction = 'activeAction';

  final int itemCount;
  final double radius;
  final double startAngle;
  final double totalAngle;
  final ItemAngleCalculator calculateItemAngle;
  final Animation<double> controller;
  final Animation<double> _progress;

  late Offset center;

  @override
  void performLayout(Size size) {
    center = Offset(size.width / 2, size.height / 2);

    if (hasChild(menuButton)) {
      final Size menuButtonSize =
          layoutChild(menuButton, BoxConstraints.loose(size));

      positionChild(
        menuButton,
        Offset(center.dx - menuButtonSize.width / 2,
            center.dy - menuButtonSize.height / 2),
      );

      for (int i = 0; i < itemCount; i++) {
        final String actionButtonId = '$actionButton$i';
        final String actionArcId = '$activeAction$i';
        if (hasChild(actionArcId)) {
          final Size arcSize = layoutChild(
              actionArcId,
              BoxConstraints.expand(
                  width: _progress.value * 2, height: _progress.value * 2));

          positionChild(
              actionArcId,
              Offset(center.dx - arcSize.width / 2,
                  center.dy - arcSize.height / 2));
        }

        if (hasChild(actionButtonId)) {
          final Size buttonSize =
              layoutChild(actionButtonId, BoxConstraints.loose(size));

          final double itemAngle =
              calculateItemAngle(totalAngle, startAngle, i);

          positionChild(
            actionButtonId,
            Offset(
                center.dx -
                    buttonSize.width / 2 +
                    _progress.value * math.cos(itemAngle),
                (center.dy - buttonSize.height / 2) +
                    _progress.value * math.sin(itemAngle)),
          );
        }
      }
    }
  }

  @override
  bool shouldRelayout(_RadialMenuLayout oldDelegate) {
    return itemCount != oldDelegate.itemCount ||
        radius != oldDelegate.radius ||
        calculateItemAngle != oldDelegate.calculateItemAngle ||
        controller != oldDelegate.controller ||
        _progress != oldDelegate._progress;
  }
}

/// 位于 [RadialMenu] 中心的按钮，控制其打开关闭状态。
class RadialMenuCenterButton extends StatelessWidget {
  RadialMenuCenterButton({
    required this.isOpen,
    required this.openCloseAnimationController,
    super.key,
    this.activateAnimationController,
    this.onPressed,
    this.iconColor,
    this.closedColor,
    this.openedColor,
    this.size = _defaultButtonSize,
  }) : _progress = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: openCloseAnimationController,
            curve: const Interval(0.0, 0.5, curve: Curves.ease)));

  // _scale = activateAnimationController == null
  //     ? null
  //     : Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(
  //         parent: activateAnimationController, curve: Curves.elasticIn)
  //         );

  /// 驱动 [RadialMenu] 开闭的动画。
  final Animation<double> openCloseAnimationController;

  /// 当按下 [RadialMenu] 中的项目时的动画。
  final Animation<double>? activateAnimationController;
  final VoidCallback? onPressed;

  /// 菜单的打开关闭状态。
  ///
  /// 确定应使用 [closedColor] 或 [openedColor] 中的哪一个作为按钮的背景颜色。
  final bool isOpen;

  /// 绘制图标时使用的颜色。
  ///
  /// 默认为 [Theme.of(context).iconColor]。
  final Color? iconColor;

  /// 处于关闭状态时的背景颜色。
  ///
  /// 默认为 [Theme.of(context).primaryColor]。
  final Color? closedColor;

  /// 处于打开状态时的背景颜色。
  ///
  /// 默认为 [Theme.of(context).accentColor]。
  final Color? openedColor;

  /// 按钮的大小。
  ///
  /// 默认为 48.0。
  final double size;

  /// 按钮中心的 [AnimatedIcon] 的动画进度。
  final Animation<double> _progress;

  // /// 应用于按钮的比例因子。
  // ///
  // /// 当菜单中的某个项目被按下并且 [activateAnimationController] 进行时，
  // /// 动画从 1.0 到 0.0。
  // final Animation<double>? _scale;

  @override
  Widget build(BuildContext context) {
    final AnimatedIcon animatedIcon = AnimatedIcon(
      icon: AnimatedIcons.menu_close,
      progress: _progress,
      color: iconColor ?? Colors.white,
    );

    final Widget child = SizedBox(
      width: size,
      height: size,
      child: Center(child: animatedIcon),
    );

    final Color color = isOpen
        ? openedColor ?? Theme.of(context).colorScheme.secondary
        : closedColor ?? Theme.of(context).primaryColor;
    return RadialMenuButton(
      backgroundColor: color,
      onPressed: onPressed,
      child: child,
    );
  }
}

class RadialMenuButton extends StatelessWidget {
  const RadialMenuButton({
    required this.child,
    this.backgroundColor,
    this.onPressed,
    super.key,
  });

  final Widget child;
  final Color? backgroundColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final Color color = backgroundColor ?? Theme.of(context).primaryColor;

    return Semantics(
      button: true,
      enabled: true,
      child: Material(
        type: MaterialType.circle,
        color: color,
        child: InkWell(
          borderRadius: BorderRadius.circular(100),
          onTap: onPressed,
          child: child,
        ),
      ),
    );
  }
}

/// 绘制表示活动动作的 [RadialMenuButton] 和 [_ArcProgressPainter]。
/// 随着提供的 [Animation] 的进行，ActionArc 会变成一个完整的圆圈，
/// 并且 [RadialMenuButton] 会沿着它移动。
class _ArcProgressIndicator extends StatelessWidget {
  _ArcProgressIndicator({
    required this.controller,
    required this.radius,
    this.startAngle = 0.0,
    this.color,
    this.icon,
    this.iconColor,
    this.iconSize,
    this.width,
  }) : _progress = Tween<double>(begin: 0.0, end: 1.0).animate(controller);
  final Animation<double> controller;
  final double radius;
  final double startAngle;
  final double? width;

  /// 填充圆弧时使用的颜色。
  ///
  /// 默认为[Theme.of(context).accentColor]。
  final Color? color;
  final IconData? icon;
  final Color? iconColor;
  final double? iconSize;

  final Animation<double> _progress;

  @override
  Widget build(BuildContext context) {
    TextPainter? iconPainter;
    final ThemeData theme = Theme.of(context);
    final Color iconColor = this.iconColor ?? theme.colorScheme.secondary;
    final double iconSize = this.iconSize ?? IconTheme.of(context).size ?? 24;

    if (icon != null) {
      iconPainter = TextPainter(
        textDirection: Directionality.of(context),
        text: TextSpan(
          text: String.fromCharCode(icon!.codePoint),
          style: TextStyle(
            inherit: false,
            color: iconColor,
            fontSize: iconSize,
            fontFamily: icon!.fontFamily,
            package: icon!.fontPackage,
          ),
        ),
      )..layout();
    }

    return CustomPaint(
      painter: _ArcProgressPainter(
        width: width ?? iconSize * 2,
        color: color ?? theme.colorScheme.secondary,
        radius: radius,
        controller: _progress,
        startAngle: startAngle,
        icon: iconPainter,
      ),
    );
  }
}

class _ArcProgressPainter extends CustomPainter {
  _ArcProgressPainter({
    required this.controller,
    required this.color,
    required this.radius,
    required this.width,
    this.startAngle = 0.0,
    this.icon,
  }) : super(repaint: controller);
  final Animation<double> controller;
  final Color color;
  final double radius;
  final double width;

  final double startAngle;
  final TextPainter? icon;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final double sweepAngle = controller.value * 2 * math.pi;

    canvas.drawArc(Offset.zero & size, startAngle, sweepAngle, false, paint);

    if (icon != null) {
      final double angle = startAngle + sweepAngle;
      final Offset offset = Offset(
        (size.width / 2 - icon!.size.width / 2) + radius * math.cos(angle),
        (size.height / 2 - icon!.size.height / 2) + radius * math.sin(angle),
      );

      icon!.paint(canvas, offset);
    }
  }

  @override
  bool shouldRepaint(_ArcProgressPainter oldDelegate) {
    return controller.value != oldDelegate.controller.value ||
        color != oldDelegate.color ||
        radius != oldDelegate.radius ||
        width != oldDelegate.width ||
        startAngle != oldDelegate.startAngle ||
        icon != oldDelegate.icon;
  }
}
