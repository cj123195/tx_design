import 'package:flutter/material.dart';

import '../extensions/string_extension.dart';
import '../extensions/time_of_day_extension.dart';
import '../widgets/date_picker.dart';
import 'picker_form_field.dart';

/// 时间选择框表单
class TxTimePickerFormField extends TxPickerFormField<TimeOfDay, String> {
  TxTimePickerFormField({
    super.key,
    super.onSaved,
    super.validator,
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    super.decoration,
    super.onChanged,
    super.required,
    super.hintText,
    super.clearable,
    String? initialTimeStr,
    TimeOfDay? initialTime,
    TimeOfDay? minimumTime,
    TimeOfDay? maximumTime,
    String? titleText,
    super.readOnly,
    super.label,
    super.labelText,
    super.actionsBuilder,
    super.trailingBuilder,
    super.leading,
    super.tileTheme,
    super.focusNode,
    super.bordered,
    super.maxLines,
    super.minLines,
    super.displayConfig,
    super.scrollConfig,
  }) : super.withoutSource(
          initialValue: initialTime ?? initialTimeStr?.toTime(),
          onPickTap: (context, time) => showCupertinoTimePicker(
            context,
            initialTime: time,
            titleText: titleText,
            minimumTime: minimumTime,
            maximumTime: maximumTime,
          ),
          displayTextMapper: (context, time) =>
              time.formatWithoutLocalization(),
        );

  @override
  TxPickerFormFieldState<TimeOfDay, String> createState() =>
      _TxTimePickerFormFieldState();
}

class _TxTimePickerFormFieldState
    extends TxPickerFormFieldState<TimeOfDay, String> {
  @override
  Widget? get prefixIcon => const Icon(Icons.access_time);
}
