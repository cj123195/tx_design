import 'package:flutter/material.dart';

import '../widgets/date_range_picker.dart';
import 'picker_form_field.dart';

export '../widgets/date_range_picker.dart' show TimeRange;

/// 日期范围选择框表单
class TxTimeRangePickerFormField
    extends TxPickerFormField<TimeRange, TimeRange> {
  TxTimeRangePickerFormField({
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
    TimeRange? initialTimeRange,
    TimeOfDay? minimumTime,
    TimeOfDay? maximumTime,
    String? helpText,
    String? fieldStartHintText,
    String? fieldEndHintText,
    String Function(BuildContext context, TimeRange timeRange)? format,
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
          initialValue: initialTimeRange,
          onPickTap: (context, range) => showCupertinoTimeRangePicker(
            context,
            minimumTime: minimumTime,
            maximumTime: maximumTime,
            initialTimeRange: range,
            helpText: helpText,
            fieldEndHintText: fieldEndHintText,
            fieldStartHintText: fieldStartHintText,
          ),
          displayTextMapper: format ?? (context, range) => range.format(),
        );

  @override
  TxPickerFormFieldState<TimeRange, TimeRange> createState() =>
      _TxTimeRangePickerFormFieldState();
}

class _TxTimeRangePickerFormFieldState
    extends TxPickerFormFieldState<TimeRange, TimeRange> {
  @override
  Widget? get prefixIcon => const Icon(Icons.access_time);
}
