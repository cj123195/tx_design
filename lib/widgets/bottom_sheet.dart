import 'package:flutter/material.dart';

class TxModalBottomSheetRoute<T> extends PopupRoute<T> {
  TxModalBottomSheetRoute(
    BuildContext context, {
    this.builder,
    this.theme,
    this.barrierLabel,
    this.backgroundColor,
    this.isPersistent,
    this.elevation,
    this.shape,
    this.removeTop = true,
    this.clipBehavior,
    this.modalBarrierColor,
    this.isDismissible = true,
    this.enableDrag = true,
    this.isScrollControlled = false,
    RouteSettings? settings,
    this.enterBottomSheetDuration = const Duration(milliseconds: 250),
    this.exitBottomSheetDuration = const Duration(milliseconds: 200),
    this.heightRatio,
  }) : super(settings: settings);

  final bool? isPersistent;
  final WidgetBuilder? builder;
  final ThemeData? theme;
  final bool isScrollControlled;
  final Color? backgroundColor;
  final double? elevation;
  final ShapeBorder? shape;
  final Clip? clipBehavior;
  final Color? modalBarrierColor;
  final bool isDismissible;
  final bool enableDrag;
  final double? heightRatio; // 高度比例

  // final String name;
  final Duration enterBottomSheetDuration;
  final Duration exitBottomSheetDuration;

  // remove safearea from top
  final bool removeTop;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 700);

  @override
  bool get barrierDismissible => isDismissible;

  @override
  final String? barrierLabel;

  @override
  Color get barrierColor => modalBarrierColor ?? Colors.black54;

  AnimationController? _animationController;

  @override
  AnimationController createAnimationController() {
    assert(_animationController == null);
    _animationController =
        BottomSheet.createAnimationController(navigator!.overlay!);
    _animationController!.duration = enterBottomSheetDuration;
    _animationController!.reverseDuration = exitBottomSheetDuration;
    return _animationController!;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    final sheetTheme =
        theme?.bottomSheetTheme ?? Theme.of(context).bottomSheetTheme;
    Widget bottomSheet = MediaQuery.removePadding(
      context: context,
      removeTop: removeTop,
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: _TxModalBottomSheet<T>(
          route: this,
          backgroundColor: backgroundColor ??
              sheetTheme.modalBackgroundColor ??
              sheetTheme.backgroundColor,
          elevation:
              elevation ?? sheetTheme.modalElevation ?? sheetTheme.elevation,
          shape: shape,
          clipBehavior: clipBehavior,
          isScrollControlled: isScrollControlled,
          heightRatio: heightRatio,
          enableDrag: enableDrag,
        ),
      ),
    );
    if (theme != null) {
      bottomSheet = Theme(data: theme!, child: bottomSheet);
    }
    return bottomSheet;
  }
}

class _TxModalBottomSheet<T> extends StatefulWidget {
  const _TxModalBottomSheet({
    Key? key,
    this.route,
    this.backgroundColor,
    this.elevation,
    this.shape,
    this.clipBehavior,
    this.isScrollControlled = false,
    this.enableDrag = true,
    this.isPersistent = false,
    this.heightRatio,
  }) : super(key: key);
  final bool isPersistent;
  final TxModalBottomSheetRoute<T>? route;
  final bool isScrollControlled;
  final Color? backgroundColor;
  final double? elevation;
  final ShapeBorder? shape;
  final Clip? clipBehavior;
  final bool enableDrag;
  final double? heightRatio;

  @override
  _TxModalBottomSheetState<T> createState() => _TxModalBottomSheetState<T>();
}

class _TxModalBottomSheetState<T> extends State<_TxModalBottomSheet<T>> {
  String _getRouteLabel(MaterialLocalizations localizations) {
    if ((Theme.of(context).platform == TargetPlatform.android) ||
        (Theme.of(context).platform == TargetPlatform.fuchsia)) {
      return localizations.dialogLabel;
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMediaQuery(context));
    assert(debugCheckHasMaterialLocalizations(context));
    final mediaQuery = MediaQuery.of(context);
    final localizations = MaterialLocalizations.of(context);
    final routeLabel = _getRouteLabel(localizations);

    return AnimatedBuilder(
      animation: widget.route!.animation!,
      builder: (context, child) {
        // Disable the initial animation when accessible navigation is on so
        // that the semantics are added to the tree at the correct time.
        final animationValue = mediaQuery.accessibleNavigation
            ? 1.0
            : widget.route!.animation!.value;
        return Semantics(
          scopesRoute: true,
          namesRoute: true,
          label: routeLabel,
          explicitChildNodes: true,
          child: ClipRect(
            child: CustomSingleChildLayout(
              delegate: _TxModalBottomSheetLayout(
                animationValue,
                widget.isScrollControlled,
                widget.heightRatio,
              ),
              child: widget.isPersistent == false
                  ? BottomSheet(
                      animationController: widget.route!._animationController,
                      onClosing: () {
                        if (widget.route!.isCurrent) {
                          Navigator.pop(context);
                        }
                      },
                      builder: widget.route!.builder!,
                      backgroundColor: widget.backgroundColor,
                      elevation: widget.elevation,
                      shape: widget.shape,
                      clipBehavior: widget.clipBehavior,
                      enableDrag: widget.enableDrag,
                    )
                  : Scaffold(
                      bottomSheet: BottomSheet(
                        animationController: widget.route!._animationController,
                        onClosing: () {
                          // if (widget.route.isCurrent) {
                          //   Navigator.pop(context);
                          // }
                        },
                        builder: widget.route!.builder!,
                        backgroundColor: widget.backgroundColor,
                        elevation: widget.elevation,
                        shape: widget.shape,
                        clipBehavior: widget.clipBehavior,
                        enableDrag: widget.enableDrag,
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}

class _TxModalBottomSheetLayout extends SingleChildLayoutDelegate {
  _TxModalBottomSheetLayout(
    this.progress,
    this.isScrollControlled,
    this.heightRatio,
  );

  final double progress;
  final bool isScrollControlled;
  final double? heightRatio;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints(
      minWidth: constraints.maxWidth,
      maxWidth: constraints.maxWidth,
      minHeight: 0.0,
      maxHeight: constraints.maxHeight *
          (heightRatio ?? (isScrollControlled ? 0.83 : 9.0 / 16.0)),
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return Offset(0.0, size.height - childSize.height * progress);
  }

  @override
  bool shouldRelayout(_TxModalBottomSheetLayout oldDelegate) {
    return progress != oldDelegate.progress;
  }
}

Future<T?> showTxModalBottomSheet<T>(
  BuildContext context, {
  required WidgetBuilder? builder,
  Color? backgroundColor,
  double? elevation,
  ShapeBorder? shape,
  Clip? clipBehavior,
  Color? barrierColor,
  bool isScrollControlled = false,
  bool useRootNavigator = false,
  bool isDismissible = true,
  bool enableDrag = true,
  EdgeInsetsGeometry? padding,
  EdgeInsetsGeometry? contentPadding,
  bool persistent = false,
  bool? ignoreSafeArea,
  RouteSettings? settings,
  Duration? enterBottomSheetDuration,
  Duration? exitBottomSheetDuration,
}) {
  final NavigatorState navigator =
      Navigator.of(context, rootNavigator: useRootNavigator);
  return navigator.push(TxModalBottomSheetRoute<T>(
    context,
    builder: builder,
    isPersistent: persistent,
    theme: Theme.of(context),
    isScrollControlled: isScrollControlled,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    backgroundColor: backgroundColor,
    elevation: elevation,
    shape: shape,
    removeTop: ignoreSafeArea ?? true,
    clipBehavior: clipBehavior,
    isDismissible: isDismissible,
    modalBarrierColor: barrierColor,
    settings: settings,
    enableDrag: enableDrag,
    enterBottomSheetDuration:
        enterBottomSheetDuration ?? const Duration(milliseconds: 250),
    exitBottomSheetDuration:
        exitBottomSheetDuration ?? const Duration(milliseconds: 200),
  ));
}

/// 默认底部弹框
Future<T?> showDefaultBottomSheet<T>(
  BuildContext context, {
  required Widget content,
  Widget? header,
  String? title,
  Widget? leading,
  List<Widget>? actions,
  Widget? footer,
  VoidCallback? onConfirm,
  VoidCallback? onClose,
  VoidCallback? onCancel,
  String? textConfirm,
  String? textCancel,
  bool showConfirmButton = true,
  bool showCancelButton = false,
  bool? showCloseButton,
  Color? backgroundColor,
  double? elevation,
  ShapeBorder? shape,
  Clip? clipBehavior,
  Color? barrierColor,
  bool isScrollControlled = false,
  bool useRootNavigator = false,
  bool isDismissible = true,
  bool enableDrag = true,
  EdgeInsetsGeometry? padding,
  EdgeInsetsGeometry? contentPadding,
  bool persistent = false,
  bool? ignoreSafeArea,
  RouteSettings? settings,
  Duration? enterBottomSheetDuration,
  Duration? exitBottomSheetDuration,
}) async {
  assert(header != null || title != null);
  return showTxModalBottomSheet<T>(
    context,
    builder: (_) => _DefaultSheet(
      content: content,
      title: title,
      header: header,
      actions: actions,
      onConfirm: onConfirm,
      onCancel: onCancel,
      onClose: onClose,
      textConfirm: textConfirm,
      textCancel: textCancel,
      showConfirmButton: showConfirmButton,
      showCancelButton: showCancelButton,
      padding: padding,
      contentPadding: contentPadding,
      leading: leading,
      footer: footer,
    ),
    persistent: persistent,
    isScrollControlled: isScrollControlled,
    backgroundColor: backgroundColor,
    elevation: elevation,
    shape: shape,
    ignoreSafeArea: ignoreSafeArea ?? true,
    clipBehavior: clipBehavior,
    isDismissible: isDismissible,
    barrierColor: barrierColor,
    settings: settings,
    enableDrag: enableDrag,
    enterBottomSheetDuration:
        enterBottomSheetDuration ?? const Duration(milliseconds: 250),
    exitBottomSheetDuration:
        exitBottomSheetDuration ?? const Duration(milliseconds: 200),
  );
}

class _DefaultSheet extends StatelessWidget {
  const _DefaultSheet({
    required this.content,
    Key? key,
    this.header,
    this.title,
    this.leading,
    this.actions,
    this.onConfirm,
    this.onClose,
    this.onCancel,
    this.textConfirm,
    this.textCancel,
    this.showConfirmButton = true,
    this.showCancelButton = true,
    this.padding,
    this.contentPadding = const EdgeInsets.all(16),
    this.footer,
  }) : super(key: key);
  final Widget? header;
  final Widget? leading;
  final String? title;
  final Widget content;
  final Widget? footer;
  final List<Widget>? actions;
  final VoidCallback? onConfirm;
  final VoidCallback? onClose;
  final VoidCallback? onCancel;
  final String? textConfirm;
  final String? textCancel;
  final bool showConfirmButton;
  final bool showCancelButton;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    Widget? footer;
    if (this.footer != null) {
      footer = this.footer;
    } else {
      final List<Widget> buttons = [
        if (showCancelButton)
          OutlinedButton(
            onPressed: onCancel ?? () => Navigator.pop(context, false),
            child: Text(textCancel ?? '取消'),
          ),
        if (showConfirmButton)
          FilledButton(
            onPressed: onConfirm ?? () => Navigator.pop(context, false),
            child: Text(textConfirm ?? '确定'),
          ),
      ];
      if (buttons.isNotEmpty) {
        footer = Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (int i = 0; i < buttons.length; i++) ...[
              Expanded(child: buttons[i]),
              if (i != buttons.length - 1) const SizedBox(width: 16),
            ]
          ],
        );
      }
    }

    final Widget? action = actions == null
        ? null
        : Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: actions!,
          );

    final Widget header = SizedBox(
      height: kToolbarHeight,
      child: this.header ??
          NavigationToolbar(
            leading: leading ??
                IconButton(
                  onPressed: onCancel ?? () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
            middle:
                Text(title!, style: Theme.of(context).textTheme.titleMedium),
            trailing: action,
            centerMiddle: true,
          ),
    );

    Widget result = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        header,
        Expanded(child: content),
        if (footer != null)
          Padding(
            padding: const EdgeInsets.all(16),
            child: footer,
          ),
      ],
    );

    if (padding != null) {
      result = Padding(padding: padding!, child: result);
    }

    return result;
  }
}
