import 'package:flutter/material.dart';

import '../localizations.dart';
import '../utils/basic_types.dart';

const EdgeInsets _defaultInsetPadding =
    EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0);

Future<T?> showDefaultDialog<T>(
  BuildContext context, {
  bool showTitle = true,
  String? titleText,
  WidgetBuilder? titleBuilder,
  EdgeInsetsGeometry? titlePadding,
  TextStyle? titleTextStyle,
  String? contentText,
  WidgetBuilder? contentBuilder,
  EdgeInsetsGeometry? contentPadding,
  TextStyle? contentTextStyle,
  WidgetsBuilder? actionsBuilder,
  EdgeInsetsGeometry? actionsPadding,
  MainAxisAlignment? actionsAlignment,
  OverflowBarAlignment? actionsOverflowAlignment,
  VerticalDirection? actionsOverflowDirection,
  double? actionsOverflowButtonSpacing,
  EdgeInsetsGeometry? buttonPadding,
  String? confirmText,
  WidgetBuilder? confirmBuilder,
  ButtonStyle? confirmButtonStyle,
  ValueChanged<BuildContext>? onConfirm,
  bool showConfirmButton = true,
  String? cancelText,
  WidgetBuilder? cancelBuilder,
  ButtonStyle? cancelButtonStyle,
  ValueChanged<BuildContext>? onCancel,
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
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor,
    useSafeArea: useSafeArea,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    anchorPoint: anchorPoint,
    builder: (context) {
      final MaterialLocalizations localizations =
          MaterialLocalizations.of(context);
      final TxLocalizations txLocalizations = TxLocalizations.of(context);

      Widget? title;
      if (showTitle) {
        if (titleBuilder != null) {
          title = titleBuilder(context);
        } else {
          title = Text(titleText ?? txLocalizations.dialogTitle);
        }
      }

      Widget content;
      if (contentBuilder != null) {
        content = contentBuilder(context);
      } else {
        content = Text(contentText ?? txLocalizations.dialogContent);
      }

      List<Widget>? actions;
      if (actionsBuilder != null) {
        actions = actionsBuilder(context);
      } else if (showCancelButton || showConfirmButton) {
        actions = [];

        if (showCancelButton) {
          final Widget cancel = cancelBuilder == null
              ? TextButton(
                  onPressed: () => onCancel == null
                      ? Navigator.pop(context)
                      : onCancel(context),
                  style: cancelButtonStyle,
                  child: Text(cancelText ?? localizations.cancelButtonLabel),
                )
              : cancelBuilder(context);
          actions.add(cancel);
        }

        if (showConfirmButton) {
          final Widget confirm = confirmBuilder == null
              ? FilledButton(
                  onPressed: () => onConfirm == null
                      ? Navigator.pop<T>(context, true as T)
                      : onConfirm(context),
                  style: confirmButtonStyle,
                  child: Text(confirmText ?? localizations.okButtonLabel),
                )
              : confirmBuilder(context);
          actions.add(confirm);
        }
      }

      return AlertDialog(
        icon: icon,
        iconPadding: iconPadding,
        iconColor: iconColor,
        title: title,
        titlePadding: titlePadding,
        titleTextStyle: titleTextStyle,
        content: content,
        contentPadding: contentPadding,
        contentTextStyle: contentTextStyle,
        actions: actions,
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
