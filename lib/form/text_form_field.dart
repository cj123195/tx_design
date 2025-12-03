import 'package:flutter/material.dart';

import 'common_text_form_field.dart';

/// 文本输入框表单
class TxTextFormField extends TxCommonTextFormField<String> {
  TxTextFormField({
    super.clearable,
    super.key,
    super.onSaved,
    FormFieldValidator<String>? validator,
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    super.decoration,
    super.onChanged,
    super.required,
    super.initialValue,
    super.focusNode,
    String? hintText,
    super.bordered,
    super.controller,
    super.readOnly,
    super.maxLines,
    super.minLines,
    super.editConfig,
    super.onTap,
    super.label,
    super.labelText,
    super.actionsBuilder,
    super.trailingBuilder,
    super.leading,
    super.tileTheme,
  }) : super(
          displayTextMapper: (context, val) => val,
          validator: (value) {
            if (required == true && (value == null || value.isEmpty)) {
              return '请输入';
            }

            if (validator != null) {
              return validator(value);
            }
            return null;
          },
          isEmpty: (val) => val.isEmpty,
          hintText: readOnly == true ? null : hintText ?? '请输入',
        );
}
