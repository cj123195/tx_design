import 'package:flutter/material.dart';

import '../localizations.dart';
import '../theme_extensions/spacing.dart';

/// 自定义底部弹出面板路由
///
/// 相比 [ModalBottomSheetRoute]，增加了以下功能：
/// - 支持自定义高度比例 [heightRatio]
/// - 支持自定义动画时长
/// - 支持移除顶部安全区域
/// 自定义模态底部弹窗路由
///
/// 继承自 [PopupRoute]，提供高度可定制的底部弹窗实现
///
/// 特性：
/// - 支持自定义高度比例 [heightRatio]
/// - 可配置动画时长 [enterBottomSheetDuration]/[exitBottomSheetDuration]
/// - 可移除顶部安全区域 [removeTop]
/// - 支持主题定制 [theme]
/// - 支持滚动控制 [isScrollControlled]
/// - 可配置背景遮罩 [modalBarrierColor]
class TxModalBottomSheetRoute<T> extends PopupRoute<T> {
  /// 构造函数参数说明：
  /// [builder] - 构建弹窗内容的构建器
  /// [theme] - 自定义主题
  /// [barrierLabel] - 无障碍标签
  /// [backgroundColor] - 弹窗背景色
  /// [isPersistent] - 是否持久化显示
  /// [elevation] - 阴影高度
  /// [shape] - 弹窗形状
  /// [removeTop] - 是否移除顶部安全区域
  /// [clipBehavior] - 裁剪行为
  /// [modalBarrierColor] - 遮罩层颜色
  /// [isDismissible] - 是否可点击遮罩关闭
  /// [enableDrag] - 是否允许拖动关闭
  /// [isScrollControlled] - 是否支持内容滚动
  /// [heightRatio] - 弹窗高度占屏幕比例 (0.0-1.0)
  /// [enterBottomSheetDuration] - 进入动画时长
  /// [exitBottomSheetDuration] - 退出动画时长
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
  required WidgetBuilder contentBuilder,
  WidgetBuilder? headerBuilder,
  String? title,
  bool? centerTitle,
  double? titleSpacing,
  WidgetBuilder? leadingBuilder,
  double? leadingWidth,
  bool automaticallyImplyLeading = true,
  List<Widget> Function(BuildContext context)? actionsBuilder,
  WidgetBuilder? footerBuilder,
  VoidCallback? onConfirm,
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
  ActionsPosition? actionsPosition,
}) async {
  return showTxModalBottomSheet<T>(
    context,
    builder: (_) => TxBottomSheet(
      content: contentBuilder(context),
      title: title,
      titleSpacing: titleSpacing,
      centerTitle: centerTitle,
      header: headerBuilder?.call(context),
      actions: actionsBuilder?.call(context),
      onConfirm: onConfirm ?? () => Navigator.pop(context, true),
      onCancel: onCancel ?? () => Navigator.pop(context),
      textConfirm: textConfirm,
      textCancel: textCancel,
      padding: padding,
      contentPadding: contentPadding,
      leading: leadingBuilder?.call(context),
      leadingWidth: leadingWidth,
      automaticallyImplyLeading: automaticallyImplyLeading,
      footer: footerBuilder?.call(context),
      actionsPosition: actionsPosition,
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

/// 操作按钮显示位置
enum ActionsPosition {
  /// 显示在头部
  header,

  /// 显示在底部
  footer,
}

/// 默认样式的底部弹出面板
///
/// 包含标题栏、内容区域和底部操作按钮，支持自定义各个部分的内容和样式
class TxBottomSheet extends StatelessWidget {
  const TxBottomSheet({
    required this.content,
    super.key,
    this.header,
    this.title,
    this.titleSpacing,
    this.centerTitle,
    this.leading,
    this.leadingWidth,
    this.automaticallyImplyLeading = true,
    this.actions,
    this.onConfirm,
    this.onCancel,
    this.textConfirm,
    this.textCancel,
    this.padding,
    this.contentPadding = _contentPadding,
    this.footer,
    ActionsPosition? actionsPosition,
  }) : actionsPosition = actionsPosition ?? ActionsPosition.header;

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
  final VoidCallback? onCancel;
  final String? textConfirm;
  final String? textCancel;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry? padding;
  final ActionsPosition actionsPosition;

  bool _getEffectiveCenterTitle(ThemeData theme, List<Widget>? actions) {
    bool platformCenter() {
      switch (theme.platform) {
        case TargetPlatform.android:
        case TargetPlatform.fuchsia:
        case TargetPlatform.linux:
        case TargetPlatform.windows:
        case TargetPlatform.ohos:
          return true;
        case TargetPlatform.iOS:
        case TargetPlatform.macOS:
          return actions == null || actions.length < 2;
      }
    }

    return centerTitle ?? theme.appBarTheme.centerTitle ?? platformCenter();
  }

  Widget? _getLeading(BuildContext context) {
    if (leading != null) {
      final BoxConstraints constraints =
          BoxConstraints.tightFor(width: leadingWidth ?? kToolbarHeight);
      if (Theme.of(context).useMaterial3) {
        return ConstrainedBox(
          constraints: constraints,
          child: leading is IconButton ? Center(child: leading) : leading,
        );
      } else {
        return ConstrainedBox(constraints: constraints, child: leading);
      }
    }

    if (actionsPosition == ActionsPosition.header) {
      final MaterialLocalizations localizations =
          MaterialLocalizations.of(context);

      return TextButton(
        onPressed: onCancel ?? () => Navigator.pop(context),
        style: TextButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.onSurface,
        ),
        child: Text(textCancel ?? localizations.cancelButtonLabel),
      );
    }

    return automaticallyImplyLeading ? const CloseButton() : null;
  }

  @override
  Widget build(BuildContext context) {
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final ThemeData theme = Theme.of(context);

    Widget? effectiveFooter;
    if (footer != null) {
      effectiveFooter = footer;
    } else if (actionsPosition == ActionsPosition.footer) {
      final List<Widget> buttons = [
        if (onCancel != null)
          OutlinedButton(
            onPressed: onCancel,
            child: Text(textCancel ?? localizations.cancelButtonLabel),
          ),
        if (onConfirm != null)
          FilledButton(
            onPressed: onConfirm,
            child: Text(textConfirm ?? localizations.okButtonLabel),
          ),
      ];
      if (buttons.isNotEmpty) {
        effectiveFooter = Row(
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

    Widget? effectiveHeader;
    if (header != null) {
      effectiveHeader = header;
    } else {
      Widget? trailing;
      if (actions != null && actions!.isNotEmpty) {
        trailing = Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: actions!,
        );
      } else if (actionsPosition == ActionsPosition.header) {
        trailing = TextButton(
          onPressed: onConfirm,
          child: Text(textConfirm ?? localizations.okButtonLabel),
        );
      }

      final Widget? leading = _getLeading(context);

      final Widget? middle = title == null
          ? null
          : Text(title!, style: theme.textTheme.titleMedium);

      effectiveHeader = SizedBox(
        height: kToolbarHeight,
        child: NavigationToolbar(
          leading: leading,
          middle: middle,
          trailing: trailing,
          centerMiddle: _getEffectiveCenterTitle(theme, actions),
          middleSpacing: titleSpacing ?? NavigationToolbar.kMiddleSpacing,
        ),
      );
    }

    final Widget effectiveContent = contentPadding == null
        ? content
        : Padding(padding: contentPadding!, child: content);

    Widget result = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (effectiveHeader != null) effectiveHeader,
        Expanded(child: effectiveContent),
        if (effectiveFooter != null)
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: effectiveFooter,
          ),
      ],
    );

    if (padding != null) {
      result = Padding(padding: padding!, child: result);
    }

    return result;
  }
}

typedef SimplePickerItemsBuilder<T> = List<SimplePickerItem<T>> Function(
    BuildContext context);

/// 显示简易选择弹框
Future<T?> showSimplePickerBottomSheet<T>({
  required BuildContext context,
  required SimplePickerItemsBuilder<T> itemsBuilder,
  Widget? title,
  Widget? divider,
}) async {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) {
      final List<Widget> items = itemsBuilder(context);
      return _SimplePickerBottomSheet(
        pickerItems: items,
        title: title,
        divider: divider,
      );
    },
  );
}

class _SimplePickerBottomSheet<T> extends StatelessWidget {
  const _SimplePickerBottomSheet({
    required this.pickerItems,
    super.key,
    this.title,
    this.divider,
  });

  /// 标题
  final Widget? title;

  /// 选择项
  final List<Widget> pickerItems;

  /// 分隔线
  final Widget? divider;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final BorderRadius borderRadius = BorderRadius.vertical(
      top: Radius.circular(Theme.of(context).useMaterial3 ? 12.0 : 4.0),
    );

    final List<Widget> children = [
      if (title != null) ...[
        ListTile(
          title: DefaultTextStyle(
            style:
                theme.textTheme.labelMedium!.copyWith(color: theme.hintColor),
            textAlign: TextAlign.center,
            child:
                title ?? Text(TxLocalizations.of(context).pickerFormFieldHint),
          ),
        ),
        const Divider(),
      ],
    ];
    List<Widget> pickTiles;
    if (divider != null) {
      pickTiles = [
        for (int i = 0; i < pickerItems.length; i++) ...[
          pickerItems[i],
          if (i != pickerItems.length - 1) divider!,
        ],
      ];
    } else {
      pickTiles = ListTile.divideTiles(
        color: colorScheme.outlineVariant,
        tiles: pickerItems,
      ).toList();
    }
    children.addAll(pickTiles);
    final Widget cancelTile = ListTile(
      title: Text(
        MaterialLocalizations.of(context).cancelButtonLabel,
        textAlign: TextAlign.center,
      ),
      onTap: () => Navigator.pop(context),
    );

    return Material(
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      surfaceTintColor: theme.colorScheme.surface,
      color: theme.colorScheme.surface,
      elevation: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          ...children,
          Container(
            height: SpacingTheme.of(context).medium,
            color: colorScheme.outline.withValues(alpha: 0.05),
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
    this.leading,
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

  /// 参考[ListTile.leading]
  final Widget? leading;

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
      leading: leading,
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
