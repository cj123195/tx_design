import 'package:flutter/material.dart';

import '../localizations.dart';
import 'form_field.dart';

/// 数字输入Form表单
class NumberFormField extends TxTextFormFieldItem<num> {
  NumberFormField({
    num? maximumValue, // 最大值
    num? minimumValue = 0, // 最小值
    bool showOperateButton = true, // 是否显示操作按钮
    num? difference, // 自增或自减时的差值，showOperateButton为true时生效
    super.key,
    super.onSaved,
    super.validator,
    super.initialValue,
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    super.required,
    super.label,
    super.labelText,
    super.backgroundColor,
    super.direction,
    super.padding,
    List<Widget>? actions,
    super.labelStyle,
    super.starStyle,
    super.horizontalGap,
    super.minLabelWidth,
    super.controller,
    super.prefixIconMergeMode,
    super.suffixIconMergeMode,
    super.focusNode,
    super.decoration,
    super.keyboardType = TextInputType.number,
    super.textCapitalization,
    super.textInputAction,
    super.style,
    super.strutStyle,
    super.textDirection,
    TextAlign? textAlign,
    super.textAlignVertical,
    super.autofocus,
    super.readonly,
    super.maxLines,
    super.minLines,
    super.maxLength,
    super.onChanged,
    super.onTap,
    super.onEditingComplete,
    super.inputFormatters,
    super.showCursor,
    super.obscuringCharacter,
    super.obscureText,
    super.autocorrect,
    super.smartDashesType,
    super.smartQuotesType,
    super.enableSuggestions,
    super.maxLengthEnforcement,
    super.expands,
    super.onTapOutside,
    super.onFieldSubmitted,
    super.cursorWidth,
    super.cursorHeight,
    super.cursorRadius,
    super.cursorColor,
    super.keyboardAppearance,
    super.scrollPadding,
    super.enableInteractiveSelection,
    super.selectionControls,
    super.buildCounter,
    super.scrollPhysics,
    super.autofillHints,
    super.scrollController,
    super.enableIMEPersonalizedLearning,
    super.mouseCursor,
    super.contextMenuBuilder,
  }) : super(
          textAlign: textAlign ?? (showOperateButton ? TextAlign.center : null),
          labelMapper: (num data) => data.toString(),
          dataMapper: (String? data) => data == null ? 0 : num.tryParse(data),
          defaultValidator: (context, value) {
            if (value == null) {
              return required == true
                  ? TxLocalizations.of(context).textFormFieldHint
                  : null;
            }
            if (minimumValue != null && value < minimumValue) {
              return TxLocalizations.of(context).minimumNumberLimitLabel(value);
            }
            if (maximumValue != null && value > maximumValue) {
              return TxLocalizations.of(context).maximumNumberLimitLabel(value);
            }
            return null;
          },
          defaultDecorationBuilder: showOperateButton
              ? (field) {
                  void onChangedHandler(num? value) {
                    field.didChange(value);
                    if (onChanged != null) {
                      onChanged(value);
                    }
                  }

                  final num value = field.value ?? 0;
                  final bool canAdd =
                      maximumValue == null || value < maximumValue;
                  final Widget suffixIcon = IconButton(
                    onPressed:
                        canAdd ? () => onChangedHandler(value + 1) : null,
                    icon: const Icon(Icons.add),
                    visualDensity: VisualDensity.compact,
                  );

                  final bool canRemove =
                      minimumValue == null || value > minimumValue;
                  final Widget prefixIcon = IconButton(
                    onPressed:
                        canRemove ? () => onChangedHandler(value - 1) : null,
                    icon: const Icon(Icons.remove),
                    visualDensity: VisualDensity.compact,
                  );

                  return InputDecoration(
                    suffixIcon: suffixIcon,
                    prefixIcon: prefixIcon,
                    hintText:
                        TxLocalizations.of(field.context).textFormFieldHint,
                  );
                }
              : null,
          actionsBuilder: (field) => actions,
        );
}
