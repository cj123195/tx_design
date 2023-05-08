import 'package:flutter/material.dart';

import '../extensions/datetime_extension.dart';
import '../extensions/string_extension.dart';
import '../widgets/date_picker.dart';
import 'common_picker_form_field.dart';

/// 日期+时间选择组件
class DatetimePickerFormField
    extends CommonPickerFormField<DateTime, DateTime> {
  DatetimePickerFormField({
    super.key,
    String? initialValue,
    DateTime? initialDatetime,
    String? format = 'yyyy-MM-dd HH:mm',
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
    // bool inputEnabled = false,
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
          initialValue: initialDatetime ?? initialValue?.toDatetime(),
          onPickTap: (context, initialDate) => showDatetimePicker(
            context,
            initialDateTime: initialDate ?? DateTime.now(),
            minimumDate: firstDate ?? DateTime(1970),
            maximumDate: lastDate,
          ),
          onChanged: (DateTime? date) {
            onChanged?.call(date?.format(format));
          },
        );
}
