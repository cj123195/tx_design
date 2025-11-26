import 'package:flutter/cupertino.dart';
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
    Color? activeTrackColor,
    Color? thumbColor,
    Color? inactiveTrackColor,
    Color? onLabelColor,
    Color? offLabelColor,
    DragStartBehavior? dragStartBehavior,
    Color? focusColor,
    FocusNode? focusNode,
    ValueChanged<bool>? onFocusChange,
    bool? autofocus,
    bool? applyTheme,
    super.label,
    super.labelText,
    super.labelTextAlign,
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

            final theme = Theme.of(field.context);

            return Align(
              alignment: align,
              child: CupertinoSwitch(
                value: field.value ?? false,
                onChanged: field.didChange,
                activeTrackColor: activeTrackColor ??
                    theme.switchTheme.trackColor
                        ?.resolve({WidgetState.selected}) ??
                    theme.colorScheme.primary,
                thumbColor: thumbColor,
                inactiveTrackColor: inactiveTrackColor,
                applyTheme: applyTheme,
                focusColor: focusColor,
                onLabelColor: onLabelColor,
                offLabelColor: offLabelColor,
                focusNode: focusNode,
                autofocus: autofocus ?? false,
                dragStartBehavior: dragStartBehavior ?? DragStartBehavior.start,
                onFocusChange: onFocusChange,
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
