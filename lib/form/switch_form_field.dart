import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'form_field.dart';

/// 开关配置
class SwitchConfig {
  SwitchConfig(
    this.textAlign,
    this.activeTrackColor,
    this.thumbColor,
    this.inactiveTrackColor,
    this.onLabelColor,
    this.offLabelColor,
    this.dragStartBehavior,
    this.focusColor,
    this.focusNode,
    this.onFocusChange,
    this.autofocus,
    this.applyTheme,
  );

  final TextAlign? textAlign;
  final Color? activeTrackColor;
  final Color? thumbColor;
  final Color? inactiveTrackColor;
  final Color? onLabelColor;
  final Color? offLabelColor;
  final DragStartBehavior? dragStartBehavior;
  final Color? focusColor;
  final FocusNode? focusNode;
  final ValueChanged<bool>? onFocusChange;
  final bool? autofocus;
  final bool? applyTheme;
}

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
    SwitchConfig? switchConfig,
    super.label,
    super.labelText,
    super.actionsBuilder,
    super.trailingBuilder,
    super.leading,
    TxTileThemeData? tileTheme,
  }) : super(
          textAlign: TextAlign.end,
          tileTheme: (tileTheme ?? const TxTileThemeData())
              .copyWith(layoutDirection: Axis.horizontal),
          builder: (field) {
            final AlignmentGeometry align = switch (switchConfig?.textAlign) {
              null => AlignmentDirectional.centerEnd,
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
                activeTrackColor: switchConfig?.activeTrackColor ??
                    theme.switchTheme.trackColor
                        ?.resolve({WidgetState.selected}) ??
                    theme.colorScheme.primary,
                thumbColor: switchConfig?.thumbColor,
                inactiveTrackColor: switchConfig?.inactiveTrackColor,
                applyTheme: switchConfig?.applyTheme,
                focusColor: switchConfig?.focusColor,
                onLabelColor: switchConfig?.onLabelColor,
                offLabelColor: switchConfig?.offLabelColor,
                focusNode: switchConfig?.focusNode,
                autofocus: switchConfig?.autofocus ?? false,
                dragStartBehavior:
                    switchConfig?.dragStartBehavior ?? DragStartBehavior.start,
                onFocusChange: switchConfig?.onFocusChange,
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
