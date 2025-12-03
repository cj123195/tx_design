import 'package:flutter/material.dart';

import '../extensions/datetime_range_extension.dart';
import '../widgets/date_range_picker.dart';
import 'picker_form_field.dart';

const String _defaultFormat = 'slashDate';

/// 日期范围选择框表单
class TxDateRangePickerFormField
    extends TxPickerFormField<DateTimeRange, DateTimeRange> {
  TxDateRangePickerFormField({
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
    DateTimeRange? initialDateRange,
    DateTime? minimumDate,
    DateTime? maximumDate,
    String? helpText,
    String? fieldStartHintText,
    String? fieldEndHintText,
    List<DateRangeQuickChoice>? quickChoices,
    String? format,
    String? separator,
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
          initialValue: initialDateRange,
          onPickTap: (context, range) => showCupertinoDateRangePicker(
            context,
            minimumDate: minimumDate,
            maximumDate: maximumDate,
            initialDateRange: range,
            helpText: helpText,
            quickChoices: quickChoices,
            fieldEndHintText: fieldEndHintText,
            fieldStartHintText: fieldStartHintText,
          ),
          displayTextMapper: (context, range) => range.format(
            format: format ?? _defaultFormat,
            separator: separator,
          ),
        );

  @override
  TxPickerFormFieldState<DateTimeRange, DateTimeRange> createState() =>
      _TxDateRangePickerFormFieldState();
}

class _TxDateRangePickerFormFieldState
    extends TxPickerFormFieldState<DateTimeRange, DateTimeRange> {
  @override
  Widget? get prefixIcon => const Icon(Icons.date_range);
}
