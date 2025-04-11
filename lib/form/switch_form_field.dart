import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'form_field.dart';

/// Switch 表单组件。
class TxSwitchFormField extends TxFormField<bool> {
  TxSwitchFormField({
    super.key,
    super.onSaved,
    FormFieldValidator<bool>? validator,
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    super.decoration,
    super.onChanged,
    super.required,
    super.initialValue,
    TextAlign? textAlign = TextAlign.end,
    Color? activeColor,
    Color? activeTrackColor,
    Color? inactiveThumbColor,
    Color? inactiveTrackColor,
    ImageProvider? activeThumbImage,
    ImageErrorListener? onActiveThumbImageError,
    ImageProvider? inactiveThumbImage,
    ImageErrorListener? onInactiveThumbImageError,
    MaterialStateProperty<Color?>? thumbColor,
    MaterialStateProperty<Color?>? trackColor,
    MaterialStateProperty<Color?>? trackOutlineColor,
    MaterialStateProperty<double?>? trackOutlineWidth,
    MaterialStateProperty<Icon?>? thumbIcon,
    MaterialTapTargetSize? materialTapTargetSize,
    DragStartBehavior? dragStartBehavior,
    MouseCursor? mouseCursor,
    MaterialStateProperty<Color?>? overlayColor,
    double? splashRadius,
    Color? focusColor,
    FocusNode? focusNode,
    ValueChanged<bool>? onFocusChange,
    bool? autofocus,
    Color? hoverColor,
    bool? applyCupertinoTheme,
    TextDirection? textDirection,
    super.label,
    super.labelText,
    super.labelTextAlign,
    super.labelOverflow,
    super.padding,
    super.actionsBuilder,
    super.labelStyle,
    super.horizontalGap,
    super.tileColor,
    super.trailingBuilder,
    super.leading,
    super.visualDensity,
    super.shape,
    super.iconColor,
    super.textColor,
    super.leadingAndTrailingTextStyle,
    super.onTap,
    super.minLeadingWidth,
    super.dense,
    super.colon,
    super.minLabelWidth,
    super.minVerticalPadding,
  }) : super(
          layoutDirection: Axis.horizontal,
          builder: (field) {
            final AlignmentGeometry align = switch (textAlign) {
              null => AlignmentDirectional.centerStart,
              TextAlign.left => Alignment.centerLeft,
              TextAlign.right => Alignment.centerRight,
              TextAlign.center => AlignmentDirectional.center,
              TextAlign.justify => AlignmentDirectional.center,
              TextAlign.start => AlignmentDirectional.centerStart,
              TextAlign.end => AlignmentDirectional.centerEnd,
            };

            return Align(
              alignment: align,
              child: Switch.adaptive(
                value: field.value ?? false,
                onChanged: field.didChange,
                activeColor: activeColor,
                activeTrackColor: activeTrackColor,
                inactiveThumbColor: inactiveThumbColor,
                activeThumbImage: activeThumbImage,
                onActiveThumbImageError: onActiveThumbImageError,
                inactiveThumbImage: inactiveThumbImage,
                onInactiveThumbImageError: onInactiveThumbImageError,
                materialTapTargetSize:
                    materialTapTargetSize ?? MaterialTapTargetSize.shrinkWrap,
                thumbColor: thumbColor,
                trackColor: trackColor,
                trackOutlineColor: trackOutlineColor,
                trackOutlineWidth: trackOutlineWidth,
                thumbIcon: thumbIcon,
                dragStartBehavior: dragStartBehavior ?? DragStartBehavior.start,
                mouseCursor: mouseCursor,
                focusColor: focusColor,
                hoverColor: hoverColor,
                overlayColor: overlayColor,
                splashRadius: splashRadius,
                focusNode: focusNode,
                autofocus: autofocus ?? false,
                applyCupertinoTheme: applyCupertinoTheme,
              ),
            );
          },
          validator: (bool? val) {
            if (required == true && val == null) {
              return '请选择';
            }
            if (validator != null) {
              return validator(val);
            }
            return null;
          },
        );
}
