import 'package:flutter/material.dart';

import '../localizations.dart';
import '../theme_extensions/spacing.dart';

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

const EdgeInsetsGeometry _contentPadding = EdgeInsets.all(12.0);

/// 默认底部弹框
Future<T?> showDefaultBottomSheet<T>(
  BuildContext context, {
  required Widget content,
  Widget? header,
  String? title,
  bool? centerTitle,
  double? titleSpacing,
  Widget? leading,
  double? leadingWidth,
  bool automaticallyImplyLeading = true,
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
  EdgeInsetsGeometry? contentPadding = _contentPadding,
  bool persistent = false,
  bool? ignoreSafeArea,
  RouteSettings? settings,
  Duration? enterBottomSheetDuration,
  Duration? exitBottomSheetDuration,
}) async {
  return showTxModalBottomSheet<T>(
    context,
    builder: (_) => _DefaultSheet(
      content: content,
      title: title,
      titleSpacing: titleSpacing,
      centerTitle: centerTitle,
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
      leadingWidth: leadingWidth,
      automaticallyImplyLeading: automaticallyImplyLeading,
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
    this.header,
    this.title,
    this.titleSpacing,
    this.centerTitle,
    this.leading,
    this.leadingWidth,
    this.automaticallyImplyLeading = true,
    this.actions,
    this.onConfirm,
    this.onClose,
    this.onCancel,
    this.textConfirm,
    this.textCancel,
    this.showConfirmButton = true,
    this.showCancelButton = true,
    this.padding,
    this.contentPadding = _contentPadding,
    this.footer,
  });

  final Widget? header;
  final Widget? leading;
  final double? leadingWidth;
  final bool automaticallyImplyLeading;
  final String? title;
  final double? titleSpacing;
  final bool? centerTitle;
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

  bool _getEffectiveCenterTitle(ThemeData theme) {
    bool platformCenter() {
      switch (theme.platform) {
        case TargetPlatform.android:
        case TargetPlatform.fuchsia:
        case TargetPlatform.linux:
        case TargetPlatform.windows:
          return false;
        case TargetPlatform.iOS:
        case TargetPlatform.macOS:
          return actions == null || actions!.length < 2;
      }
    }

    return centerTitle ?? theme.appBarTheme.centerTitle ?? platformCenter();
  }

  Widget? _getLeading(ThemeData theme) {
    Widget? leading = this.leading;
    if (leading == null && automaticallyImplyLeading) {
      leading = CloseButton(onPressed: onCancel);
    }
    if (leading != null) {
      final BoxConstraints constraints =
          BoxConstraints.tightFor(width: leadingWidth ?? kToolbarHeight);
      if (theme.useMaterial3) {
        leading = ConstrainedBox(
          constraints: constraints,
          child: leading is IconButton ? Center(child: leading) : leading,
        );
      } else {
        leading = ConstrainedBox(
          constraints: constraints,
          child: leading,
        );
      }
    }
    return leading;
  }

  @override
  Widget build(BuildContext context) {
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final ThemeData theme = Theme.of(context);

    Widget? footer;
    if (this.footer != null) {
      footer = this.footer;
    } else {
      final List<Widget> buttons = [
        if (showCancelButton)
          OutlinedButton(
            onPressed: onCancel ?? () => Navigator.pop(context, false),
            child: Text(textCancel ?? localizations.cancelButtonLabel),
          ),
        if (showConfirmButton)
          FilledButton(
            onPressed: onConfirm ?? () => Navigator.pop(context, true),
            child: Text(textConfirm ?? localizations.okButtonLabel),
          ),
      ];
      if (buttons.isNotEmpty) {
        footer = Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (int i = 0; i < buttons.length; i++) ...[
              Expanded(child: buttons[i]),
              if (i != buttons.length - 1) const SizedBox(width: 12.0),
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

    Widget? header = this.header;
    if (header == null && title != null) {
      header = SizedBox(
        height: kToolbarHeight,
        child: NavigationToolbar(
          leading: _getLeading(theme),
          middle: Text(title!, style: theme.textTheme.titleMedium),
          trailing: action,
          centerMiddle: _getEffectiveCenterTitle(theme),
          middleSpacing: titleSpacing ?? NavigationToolbar.kMiddleSpacing,
        ),
      );
    }

    Widget content = this.content;
    if (contentPadding != null) {
      content = Padding(padding: contentPadding!, child: content);
    }

    Widget result = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (header != null) header,
        Expanded(child: content),
        if (footer != null)
          Padding(
            padding: const EdgeInsets.all(12.0),
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

typedef SimplePickerItemsBuilder<T> = List<SimplePickerItem<T>> Function(BuildContext context);

/// 显示简易选择弹框
Future<T?> showSimplePickerBottomSheet<T>({
  required BuildContext context,
  required SimplePickerItemsBuilder<T> itemsBuilder,
  Widget? title,
}) async {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) {
      final List<Widget> items = itemsBuilder(context);
      return _SimplePickerBottomSheet(pickerItems: items, title: title);
    },
  );
}

class _SimplePickerBottomSheet<T> extends StatelessWidget {
  const _SimplePickerBottomSheet({
    required this.pickerItems,
    super.key,
    this.title,
  });

  /// 标题
  final Widget? title;

  /// 选择项
  final List<Widget> pickerItems;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final BorderRadius borderRadius = BorderRadius.vertical(
      top: Radius.circular(Theme.of(context).useMaterial3 ? 12.0 : 4.0),
    );

    final Iterable<Widget> children = ListTile.divideTiles(
      color: colorScheme.outlineVariant,
      tiles: [
        if (title != null)
          ListTile(
            title: DefaultTextStyle(
              style:
                  theme.textTheme.labelMedium!.copyWith(color: theme.hintColor),
              textAlign: TextAlign.center,
              child: title ??
                  Text(TxLocalizations.of(context).pickerFormFieldHint),
            ),
          ),
        ...pickerItems
      ],
    );
    final Widget cancelTile = ListTile(
      title: Text(
        MaterialLocalizations.of(context).cancelButtonLabel,
        textAlign: TextAlign.center,
      ),
      onTap: () => Navigator.pop(context),
    );

    return Material(
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      surfaceTintColor: theme.colorScheme.surfaceTint,
      color: theme.colorScheme.surface,
      elevation: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          ...children,
          Divider(
            thickness: SpacingTheme.of(context).medium,
            color: colorScheme.outline.withOpacity(0.05),
          ),
          cancelTile,
        ],
      ),
    );
  }
}

/// 简易选择项
class SimplePickerItem<T> extends StatelessWidget {
  const SimplePickerItem({
    required this.title,
    this.value,
    this.onTap,
    this.enabled = true,
    this.subtitle,
    super.key,
  });

  /// 如果选择此项，[showSimplePickerBottomSheet] 将返回的值。
  final T? value;

  /// 点击选择项时调用
  final VoidCallback? onTap;

  /// 是否允许用户选择此项。
  ///
  /// 参考[ListTile.enabled]
  final bool enabled;

  /// 参考[ListTile.title]
  final Widget title;

  /// 参考[ListTile.subtitle]
  final Widget? subtitle;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final Widget effectiveTitle = DefaultTextStyle(
      style: theme.textTheme.titleMedium!,
      textAlign: TextAlign.center,
      child: title,
    );

    Widget? effectiveSubtitle;
    if (subtitle != null) {
      effectiveSubtitle = DefaultTextStyle(
        style: theme.textTheme.bodySmall!.copyWith(color: theme.hintColor),
        textAlign: TextAlign.center,
        child: subtitle!,
      );
    }

    return ListTile(
      enabled: enabled,
      title: effectiveTitle,
      subtitle: effectiveSubtitle,
      onTap: enabled
          ? () {
              Navigator.pop<T>(context, value);
              onTap?.call();
            }
          : null,
    );
  }
}
