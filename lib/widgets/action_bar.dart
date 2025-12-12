import 'package:flutter/material.dart';

import 'action_bar_theme.dart';

/// 一个横置排列的操作按钮栏
class TxActionBar extends StatelessWidget {
  const TxActionBar({
    super.key,
    this.buttonStyle,
    this.leadingTextStyle,
    this.actions,
    this.leading,
    this.actionGap,
    this.iconButtonStyle,
    this.iconTheme,
    this.minLeadingWidth,
    this.leadingGap,
    this.isActionsScrollable = false,
  });

  /// 按钮样式
  ///
  /// 如果为 null，则使用 [TxActionBarThemeData.buttonStyle] 的值。 如果它也为
  /// null，则使用 [_DefaultButtonStyle] 的值。
  final ButtonStyle? buttonStyle;

  /// 图标按钮样式
  ///
  /// 如果为 null，则使用 [TxActionBarThemeData.iconButtonStyle] 的值。 如果它也为
  /// null，则使用 [_DefaultIconButtonStyle] 的值。
  final ButtonStyle? iconButtonStyle;

  /// 图标样式
  ///
  /// 同时用于[leading]与[actions]子组件中图标样式。
  ///
  /// 如果为 null，则使用 [ThemeData.iconTheme] 的值。 如果它也为
  /// null，则使用 [_DefaultIconButtonStyle] 的值。
  final IconThemeData? iconTheme;

  /// 图标样式
  ///
  /// 用于[leading]的文字样式。
  ///
  /// 如果为 null，则使用 [TxActionBarThemeData.minLeadingWidth] 的值。 如果它也为
  /// null，则使用 [TextTheme.bodySmall] 的值。
  final TextStyle? leadingTextStyle;

  /// 操作按钮列表
  final List<Widget>? actions;

  /// 展示在操作按钮列表前的小部件
  final Widget? leading;

  /// 操作按钮间的距离
  ///
  /// 如果为 null，则使用 [TxActionBarThemeData.actionGap] 的值。 如果它也为
  /// null，4.0
  final double? actionGap;

  /// [actions]与[leading]之间的间距
  ///
  /// 如果为 null，则使用 [TxActionBarThemeData.minLeadingWidth] 的值。
  final double? minLeadingWidth;

  /// [actions]与[leading]之间的间距
  ///
  /// 如果为 null，则使用 [TxActionBarThemeData.leadingGap] 的值。 如果它也为
  /// null，默认值为12.0
  final double? leadingGap;

  /// [actions] 是否可滚动
  final bool isActionsScrollable;

  @override
  Widget build(BuildContext context) {
    assert(
      leading != null || actions?.isNotEmpty == true,
      'leading must be not null or action must be not empty',
    );

    final ThemeData theme = Theme.of(context);
    final TxActionBarThemeData actionTheme = TxActionBarTheme.of(context);

    final IconThemeData? effectiveIconTheme =
        iconTheme ?? actionTheme.iconTheme;
    final ButtonStyle effectiveButtonStyle =
        buttonStyle ?? actionTheme.buttonStyle ?? _DefaultButtonStyle(context);
    final ButtonStyle effectiveIconButtonStyle = iconButtonStyle ??
        actionTheme.iconButtonStyle ??
        _DefaultIconButtonStyle(context, effectiveIconTheme?.size);
    final TextStyle effectiveLeadingTextStyle = leadingTextStyle ??
        actionTheme.leadingTextStyle ??
        theme.textTheme.bodySmall!
            .copyWith(fontSize: theme.textTheme.labelSmall!.fontSize);
    final double effectiveActionGap = actionGap ?? actionTheme.actionGap ?? 8.0;
    final double effectiveLeadingGap =
        leadingGap ?? actionTheme.leadingGap ?? 12.0;
    final double? effectiveMinLeadingWidth =
        minLeadingWidth ?? actionTheme.minLeadingWidth;

    Widget? effectiveActions;
    if (actions?.isNotEmpty == true) {
      effectiveActions = Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          for (int i = 0; i < actions!.length; i++) ...[
            actions![i],
            if (i != actions!.length - 1) SizedBox(width: effectiveActionGap)
          ]
        ],
      );
      if (isActionsScrollable) {
        effectiveActions = SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: effectiveActions,
        );
      }
    }

    Widget result;
    if (leading != null) {
      result = Align(
        alignment: Alignment.centerLeft,
        child: DefaultTextStyle(
          style: effectiveLeadingTextStyle,
          child: effectiveIconTheme == null
              ? leading!
              : IconTheme(data: effectiveIconTheme, child: leading!),
        ),
      );
      if (effectiveMinLeadingWidth != null) {
        result = ConstrainedBox(
          constraints: BoxConstraints(minWidth: effectiveMinLeadingWidth),
          child: result,
        );
      }

      if (effectiveActions != null) {
        result = Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            result,
            SizedBox(width: effectiveLeadingGap),
            Expanded(child: effectiveActions),
          ],
        );
      }
    } else {
      result = effectiveActions!;
    }

    return OutlinedButtonTheme(
      data: OutlinedButtonThemeData(
          style:
              effectiveButtonStyle.merge(_DefaultOutlinedButtonStyle(context))),
      child: ElevatedButtonTheme(
        data: ElevatedButtonThemeData(style: effectiveButtonStyle),
        child: FilledButtonTheme(
          data: FilledButtonThemeData(style: effectiveButtonStyle),
          child: TextButtonTheme(
            data: TextButtonThemeData(style: effectiveButtonStyle),
            child: IconButtonTheme(
              data: IconButtonThemeData(style: effectiveIconButtonStyle),
              child: result,
            ),
          ),
        ),
      ),
    );
  }
}

class _DefaultButtonStyle extends ButtonStyle {
  const _DefaultButtonStyle(this.context)
      : super(
          animationDuration: kThemeChangeDuration,
          enableFeedback: true,
          alignment: Alignment.center,
        );

  final BuildContext context;

  @override
  WidgetStateProperty<OutlinedBorder?>? get shape =>
      Theme.of(context).outlinedButtonTheme.style?.shape;

  @override
  WidgetStateProperty<TextStyle?> get textStyle =>
      WidgetStatePropertyAll<TextStyle?>(
          Theme.of(context).textTheme.labelMedium);

  @override
  WidgetStateProperty<EdgeInsetsGeometry>? get padding =>
      WidgetStatePropertyAll<EdgeInsetsGeometry>(
          ButtonStyleButton.scaledPadding(
        const EdgeInsets.symmetric(horizontal: 12.0),
        const EdgeInsets.symmetric(horizontal: 4.0),
        const EdgeInsets.symmetric(horizontal: 2.0),
        1,
      ));

  @override
  WidgetStateProperty<Size>? get minimumSize =>
      const WidgetStatePropertyAll<Size>(Size(40.0, 32.0));

  @override
  VisualDensity? get visualDensity => VisualDensity.compact;

  @override
  MaterialTapTargetSize? get tapTargetSize => MaterialTapTargetSize.shrinkWrap;
}

class _DefaultOutlinedButtonStyle extends ButtonStyle {
  _DefaultOutlinedButtonStyle(BuildContext context)
      : colorScheme = Theme.of(context).colorScheme;

  final ColorScheme colorScheme;

  @override
  WidgetStateProperty<BorderSide>? get side =>
      WidgetStateProperty.resolveWith((Set<WidgetState> states) {
        if (states.contains(WidgetState.disabled)) {
          return BorderSide(
            color: colorScheme.onSurface.withValues(alpha: 0.12),
          );
        }
        if (states.contains(WidgetState.focused)) {
          return BorderSide(color: colorScheme.primary);
        }
        return BorderSide(color: colorScheme.primary);
      });
}

class _DefaultIconButtonStyle extends ButtonStyle {
  _DefaultIconButtonStyle(this.context, double? iconSize)
      : super(
          animationDuration: kThemeChangeDuration,
          enableFeedback: true,
          alignment: Alignment.center,
          iconSize: WidgetStatePropertyAll<double>(iconSize ?? 24.0),
        );

  final BuildContext context;

  @override
  WidgetStateProperty<EdgeInsetsGeometry>? get padding =>
      const WidgetStatePropertyAll<EdgeInsetsGeometry>(EdgeInsets.all(4.0));

  @override
  WidgetStateProperty<Size>? get minimumSize =>
      const WidgetStatePropertyAll<Size>(Size(36.0, 36.0));

  @override
  VisualDensity? get visualDensity => VisualDensity.compact;

  @override
  MaterialTapTargetSize? get tapTargetSize => MaterialTapTargetSize.shrinkWrap;
}
