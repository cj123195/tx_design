import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../field/switch_field.dart';
import 'form_field.dart';
import 'form_field_tile.dart';

/// [builder] 构造的组件为 [TxSwitchField] 的 [FormField]。
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
  }) : super(
          builder: (field) {
            return UnmanagedRestorationScope(
              bucket: field.bucket,
              child: TxSwitchField(
                initialValue: field.value,
                onChanged: field.didChange,
                activeColor: activeColor,
                activeTrackColor: activeTrackColor,
                inactiveThumbColor: inactiveThumbColor,
                activeThumbImage: activeThumbImage,
                onActiveThumbImageError: onActiveThumbImageError,
                inactiveThumbImage: inactiveThumbImage,
                onInactiveThumbImageError: onInactiveThumbImageError,
                materialTapTargetSize: materialTapTargetSize,
                thumbColor: thumbColor,
                trackColor: trackColor,
                trackOutlineColor: trackOutlineColor,
                trackOutlineWidth: trackOutlineWidth,
                thumbIcon: thumbIcon,
                dragStartBehavior: dragStartBehavior,
                mouseCursor: mouseCursor,
                focusColor: focusColor,
                hoverColor: hoverColor,
                overlayColor: overlayColor,
                splashRadius: splashRadius,
                focusNode: focusNode,
                onFocusChange: onFocusChange,
                autofocus: autofocus,
                applyCupertinoTheme: applyCupertinoTheme,
                enabled: enabled,
                decoration: field.effectiveDecoration,
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

/// field 为 [TxSwitchFormField] 的 [TxFormFieldTile]。
class TxSwitchFormFieldTile extends TxFormFieldTile<bool> {
  TxSwitchFormFieldTile({
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
    super.labelBuilder,
    super.labelText,
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
    super.minLabelWidth,
    super.minVerticalPadding,
  }) : super(
          layoutDirection: Axis.horizontal,
          fieldBuilder: (field) {
            return TxSwitchField(
              textAlign: textAlign,
              initialValue: field.value,
              onChanged: field.didChange,
              activeColor: activeColor,
              activeTrackColor: activeTrackColor,
              inactiveThumbColor: inactiveThumbColor,
              activeThumbImage: activeThumbImage,
              onActiveThumbImageError: onActiveThumbImageError,
              inactiveThumbImage: inactiveThumbImage,
              onInactiveThumbImageError: onInactiveThumbImageError,
              materialTapTargetSize: materialTapTargetSize,
              thumbColor: thumbColor,
              trackColor: trackColor,
              trackOutlineColor: trackOutlineColor,
              trackOutlineWidth: trackOutlineWidth,
              thumbIcon: thumbIcon,
              dragStartBehavior: dragStartBehavior,
              mouseCursor: mouseCursor,
              focusColor: focusColor,
              hoverColor: hoverColor,
              overlayColor: overlayColor,
              splashRadius: splashRadius,
              focusNode: focusNode,
              onFocusChange: onFocusChange,
              autofocus: autofocus,
              applyCupertinoTheme: applyCupertinoTheme,
              enabled: enabled,
              decoration: field.effectiveDecoration,
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
