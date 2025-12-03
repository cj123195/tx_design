import 'package:flutter/material.dart';

import '../extensions/datetime_range_extension.dart';
import '../widgets/date_range_picker.dart';
import 'picker_form_field.dart';

const String _defaultFormat = 'slashDatetime';

/// 日期时间范围选择框表单
class TxDatetimeRangePickerFormField
    extends TxPickerFormField<DateTimeRange, DateTimeRange> {
  TxDatetimeRangePickerFormField({
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
    DateTimeRange? initialDatetimeRange,
    DateTime? minimumDate,
    DateTime? maximumDate,
    String? helpText,
    String? titleText,
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
          initialValue: initialDatetimeRange,
          onPickTap: (context, range) => showCupertinoDatetimeRangePicker(
            context,
            minimumDate: minimumDate,
            maximumDate: maximumDate,
            initialDatetimeRange: range,
            helpText: helpText,
            titleText: titleText,
          ),
          displayTextMapper: (context, range) => range.format(
            format: format ?? _defaultFormat,
            separator: separator,
          ),
        );

  @override
  TxPickerFormFieldState<DateTimeRange, DateTimeRange> createState() =>
      _TxDatetimeRangePickerFormFieldState();
}

class _TxDatetimeRangePickerFormFieldState
    extends TxPickerFormFieldState<DateTimeRange, DateTimeRange> {
  @override
  Widget? get prefixIcon => const Icon(Icons.date_range);
}
