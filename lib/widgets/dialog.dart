import 'package:flutter/material.dart';

import '../localizations.dart';

const EdgeInsets _defaultInsetPadding =
    EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0);

Future<T?> showDefaultDialog<T>(
  BuildContext context, {
  bool showTitle = true,
  String? titleText,
  Widget? title,
  EdgeInsetsGeometry? titlePadding,
  TextStyle? titleTextStyle,
  String? contentText,
  Widget? content,
  EdgeInsetsGeometry? contentPadding,
  TextStyle? contentTextStyle,
  List<Widget>? actions,
  EdgeInsetsGeometry? actionsPadding,
  MainAxisAlignment? actionsAlignment,
  OverflowBarAlignment? actionsOverflowAlignment,
  VerticalDirection? actionsOverflowDirection,
  double? actionsOverflowButtonSpacing,
  EdgeInsetsGeometry? buttonPadding,
  String? confirmText,
  Widget? confirm,
  ButtonStyle? confirmButtonStyle,
  VoidCallback? onConfirm,
  bool showConfirmButton = true,
  String? cancelText,
  Widget? cancel,
  ButtonStyle? cancelButtonStyle,
  VoidCallback? onCancel,
  bool showCancelButton = true,
  Color? backgroundColor,
  bool barrierDismissible = true,
  Color? barrierColor = Colors.black54,
  String? barrierLabel,
  bool useSafeArea = true,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  Offset? anchorPoint,
  Widget? icon,
  EdgeInsetsGeometry? iconPadding,
  Color? iconColor,
  double? elevation,
  Color? shadowColor,
  Color? surfaceTintColor,
  String? semanticLabel,
  EdgeInsets insetPadding = _defaultInsetPadding,
  Clip? clipBehavior = Clip.none,
  ShapeBorder? shape,
  AlignmentGeometry? alignment,
  bool scrollable = false,
}) async {
  final MaterialLocalizations localizations = MaterialLocalizations.of(context);
  final TxLocalizations txLocalizations = TxLocalizations.of(context);

  Widget? effectiveTitle;
  if (showTitle) {
    if (title != null) {
      effectiveTitle = title;
    } else {
      effectiveTitle = Text(titleText ?? txLocalizations.dialogTitle);
    }
  }

  Widget? effectiveContent;
  if (content != null) {
    effectiveContent = content;
  } else {
    effectiveContent = Text(contentText ?? txLocalizations.dialogContent);
  }

  List<Widget>? effectiveActions;
  if (actions != null) {
    effectiveActions = actions;
  } else {
    if (showCancelButton) {
      final VoidCallback effectiveOnCancel =
          onCancel ?? () => Navigator.pop(context);
      final Widget effectiveCancel =
          cancel ?? Text(cancelText ?? localizations.cancelButtonLabel);
      effectiveActions = [
        TextButton(
          onPressed: effectiveOnCancel,
          style: cancelButtonStyle,
          child: effectiveCancel,
        ),
      ];
    }

    if (showConfirmButton) {
      final VoidCallback effectiveOnConfirm =
          onConfirm ?? () => Navigator.pop<T>(context, true as T);
      final Widget effectiveConfirm =
          confirm ?? Text(confirmText ?? localizations.okButtonLabel);
      effectiveActions = [
        ...?effectiveActions,
        FilledButton(
          onPressed: effectiveOnConfirm,
          style: confirmButtonStyle,
          child: effectiveConfirm,
        ),
      ];
    }
  }

  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor,
    useSafeArea: useSafeArea,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    anchorPoint: anchorPoint,
    builder: (context) {
      return AlertDialog(
        icon: icon,
        iconPadding: iconPadding,
        iconColor: iconColor,
        title: effectiveTitle,
        titlePadding: titlePadding,
        titleTextStyle: titleTextStyle,
        content: effectiveContent,
        contentPadding: contentPadding,
        contentTextStyle: contentTextStyle,
        actions: effectiveActions,
        actionsPadding: actionsPadding,
        actionsAlignment: actionsAlignment,
        actionsOverflowAlignment: actionsOverflowAlignment,
        actionsOverflowDirection: actionsOverflowDirection,
        actionsOverflowButtonSpacing: actionsOverflowButtonSpacing,
        buttonPadding: buttonPadding,
        backgroundColor: backgroundColor,
        elevation: elevation,
        shadowColor: shadowColor,
        surfaceTintColor: surfaceTintColor,
        semanticLabel: semanticLabel,
        insetPadding: insetPadding,
        clipBehavior: clipBehavior ?? Clip.none,
        shape: shape,
        alignment: alignment,
        scrollable: scrollable,
      );
    },
  );
}
