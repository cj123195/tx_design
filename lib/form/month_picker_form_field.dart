import 'package:flutter/material.dart';

import '../extensions/datetime_extension.dart';
import '../extensions/string_extension.dart';
import '../widgets/date_picker.dart';
import 'picker_form_field.dart';

const String _defaultFormat = 'yyyy-MM';

/// 月份选择框表单
class TxMonthPickerFormField extends TxPickerFormField<DateTime, String> {
  TxMonthPickerFormField({
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
    String? initialMonthStr,
    DateTime? initialMonth,
    DateTime? minimumMonth,
    DateTime? maximumMonth,
    int? minimumYear,
    int? maximumYear,
    String? format,
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
          initialValue: initialMonth ??
              initialMonthStr?.toDatetime(format: format ?? _defaultFormat),
          onPickTap: (context, month) => showCupertinoMonthPicker(
            context,
            initialMonth: month,
            titleText: titleText,
            minimumMonth: minimumMonth,
            maximumMonth: maximumMonth,
            minimumYear: minimumYear,
            maximumYear: maximumYear,
          ),
          displayTextMapper: (context, month) =>
              month.format(format ?? _defaultFormat),
        );

  @override
  TxPickerFormFieldState<DateTime, String> createState() =>
      _TxMonthPickerFormFieldState();
}

class _TxMonthPickerFormFieldState
    extends TxPickerFormFieldState<DateTime, String> {
  @override
  Widget? get prefixIcon => const Icon(Icons.calendar_month);
}
