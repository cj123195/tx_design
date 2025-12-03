import 'package:flutter/material.dart';

import '../extensions.dart';
import '../widgets/date_picker.dart';
import 'picker_form_field.dart';

const String _defaultFormat = 'yyyy-MM-dd';

/// 日期选择框表单
class TxDatePickerFormField extends TxPickerFormField<DateTime, String> {
  TxDatePickerFormField({
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
    String? initialDateStr,
    DateTime? initialDate,
    DateTime? minimumDate,
    DateTime? maximumDate,
    int? minimumYear,
    int? maximumYear,
    String? format,
    String? titleText,
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
    super.readOnly,
    super.displayConfig,
    super.scrollConfig,
  }) : super.withoutSource(
          initialValue:
              initialDate ?? initialDateStr?.toDatetime(format: format),
          onPickTap: (context, date) => showCupertinoDatePicker(
            context,
            initialDate: date,
            titleText: titleText,
            minimumDate: minimumDate,
            maximumDate: maximumDate,
            minimumYear: minimumYear,
            maximumYear: maximumYear,
          ),
          displayTextMapper: (context, date) =>
              date.format(format ?? _defaultFormat),
        );

  @override
  TxPickerFormFieldState<DateTime, String> createState() =>
      _TxDatePickerFormFieldState();
}

class _TxDatePickerFormFieldState
    extends TxPickerFormFieldState<DateTime, String> {
  @override
  Widget? get prefixIcon => const Icon(Icons.calendar_month);
}
