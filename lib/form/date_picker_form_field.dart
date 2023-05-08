import 'package:flutter/material.dart';

import '../extensions/datetime_extension.dart';
import '../extensions/string_extension.dart';
import 'common_picker_form_field.dart';

/// 日期选择Form组件
class DatePickerFormField extends CommonPickerFormField<DateTime, DateTime> {
  DatePickerFormField({
    super.key,
    String? initialValue,
    DateTime? initialDate,
    String? format = 'yyyy-MM-dd',
    DateTime? firstDate,
    DateTime? lastDate,
    ValueChanged<String?>? onChanged,

    /// Form 参数
    super.onSaved,
    super.restorationId,
    super.enabled,
    super.autovalidateMode = AutovalidateMode.disabled,

    /// FormItemContainer参数
    super.label,
    super.labelText,
    super.padding,
    super.backgroundColor,
    super.labelStyle,
    super.starStyle,
    super.direction,

    /// TextField参数
    super.focusNode,
    super.decoration = const InputDecoration(),
    super.validator,
    super.required = false,
    super.readonly = false,
    super.style,
    super.strutStyle,
    super.textDirection,
    super.textAlign,
    super.textAlignVertical,
    super.autofocus = false,
    super.contextMenuBuilder,
    super.onTap,
    super.enableSpeech = true,
  }) : super(
          labelMapper: (DateTime? date) => date?.format(format) ?? '',
          valueMapper: (DateTime? date) => date,
          initialValue: initialDate ?? initialValue?.toDatetime(),
          onPickTap: (context, initialDate) => showDatePicker(
            context: context,
            initialDate: initialDate ?? DateTime.now(),
            firstDate: firstDate ?? DateTime(1970),
            lastDate: lastDate ??
                DateTime(
                  DateTime.now().year + 10,
                  DateTime.now().month,
                  DateTime.now().day,
                ),
          ),
          onChanged: (DateTime? date) {
            onChanged?.call(date?.format(format));
          },
        );
}
