import 'package:flutter/material.dart';

import '../extensions/string_extension.dart' show StringExtension;
import '../extensions/time_of_day_extension.dart';
import 'common_picker_form_field.dart';

/// 时间选择Form组件
class TimePickerFormField extends CommonPickerFormField<TimeOfDay, TimeOfDay> {
  TimePickerFormField({
    super.key,
    String? initialValue,
    TimeOfDay? initialTime,
    String format = 'HH:mm',
    ValueChanged<String?>? onChanged,

    /// Form 参数
    super.onSaved,
    super.restorationId,
    super.enabled,
    super.autovalidateMode = AutovalidateMode.disabled,

    /// FormItemContainer参数
    super.label,
    super.labelText,
    super.labelPadding,
    super.background,
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
    super.textAlign = TextAlign.start,
    super.textAlignVertical,
    super.autofocus = false,
    super.contextMenuBuilder,
    super.onTap,
    super.enableSpeech = true,
  }) : super(
          labelMapper: (TimeOfDay? time) =>
              time?.formatWithoutLocalization() ?? '',
          valueMapper: (TimeOfDay? time) => time,
          initialValue: initialTime ?? initialValue?.toTime(),
          onPickTap: (context, initialTime) => showTimePicker(
            context: context,
            initialTime: initialTime ?? TimeOfDay.now(),
          ),
          onChanged: (TimeOfDay? date) {
            onChanged?.call(date?.formatWithoutLocalization(format));
          },
        );
}
