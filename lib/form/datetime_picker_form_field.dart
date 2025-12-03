import 'package:flutter/material.dart';

import '../extensions/datetime_extension.dart';
import '../extensions/string_extension.dart';
import '../widgets/date_picker.dart';
import 'picker_form_field.dart';

const String _defaultFormat = 'yyyy/MM/dd HH:mm';

/// 日期时间选择框表单
class TxDatetimePickerFormField extends TxPickerFormField<DateTime, String> {
  TxDatetimePickerFormField({
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
    String? initialDatetimeStr,
    DateTime? initialDatetime,
    DateTime? minimumDate,
    DateTime? maximumDate,
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
          initialValue:
              initialDatetime ?? initialDatetimeStr?.toDatetime(format: format),
          onPickTap: (context, date) => showCupertinoDatetimePicker(
            context,
            initialDateTime: date,
            titleText: titleText,
            minimumDate: minimumDate,
            maximumDate: maximumDate,
            minimumYear: minimumYear,
            maximumYear: maximumYear,
            showSeconds: format?.toLowerCase().contains('s') == true,
          ),
          displayTextMapper: (context, datetime) =>
              datetime.format(format ?? _defaultFormat),
        );

  @override
  TxPickerFormFieldState<DateTime, String> createState() =>
      _TxDatetimePickerFormFieldState();
}

class _TxDatetimePickerFormFieldState
    extends TxPickerFormFieldState<DateTime, String> {
  @override
  Widget? get prefixIcon => const Icon(Icons.calendar_month);
}
