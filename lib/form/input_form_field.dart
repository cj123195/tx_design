import 'package:flutter/material.dart';

import '../localizations.dart';
import 'form_field.dart';

/// 文本输入Form表单
class InputFormField extends TxTextFormFieldItem<String> {
  InputFormField({
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
    super.keyboardType,
    super.textCapitalization,
    super.textInputAction,
    super.style,
    super.strutStyle,
    super.textDirection,
    super.textAlign,
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
          labelMapper: (String data) => data,
          dataMapper: (String? data) => data,
          defaultValidator: required
              ? (context, val) {
                  return val?.isNotEmpty == true
                      ? null
                      : TxLocalizations.of(context).textFormFieldHint;
                }
              : null,
          actionsBuilder: (field) => actions,
        );
}
