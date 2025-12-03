import 'package:flutter/material.dart';

import '../extensions/datetime_extension.dart';
import '../widgets/date_picker.dart';
import 'picker_form_field.dart';

const String _defaultFormat = 'yyyy年';

/// 年份选择框表单
class TxYearPickerFormField extends TxPickerFormField<int, String> {
  TxYearPickerFormField({
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
    int? initialYear,
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
          initialValue: initialYear,
          onPickTap: (context, year) => showCupertinoYearPicker(
            context,
            initialYear: year,
            titleText: titleText,
            minimumYear: minimumYear,
            maximumYear: maximumYear,
          ),
          displayTextMapper: (context, year) =>
              DateTime(year).format(format ?? _defaultFormat),
        );

  @override
  TxPickerFormFieldState<int, String> createState() =>
      _TxYearPickerFormFieldState();
}

class _TxYearPickerFormFieldState extends TxPickerFormFieldState<int, String> {
  @override
  Widget? get prefixIcon => const Icon(Icons.calendar_month);
}
