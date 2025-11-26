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
    super.labelTextAlign,
    super.padding,
    super.actionsBuilder,
    super.labelStyle,
    super.horizontalGap,
    super.tileColor,
    super.layoutDirection,
    super.trailingBuilder,
    super.leading,
    super.visualDensity,
    super.shape,
    super.iconColor,
    super.textColor,
    super.leadingAndTrailingTextStyle,
    super.minLeadingWidth,
    super.minLabelWidth,
    super.minVerticalPadding,
    super.dense,
    super.colon,
    super.focusColor,
    super.focusNode,
    super.style,
    super.strutStyle,
    super.textAlign,
    super.bordered,
    super.textAlignVertical,
    super.textDirection,
    super.maxLines,
    super.minLines,
    super.expands,
    super.scrollPadding,
    super.dragStartBehavior,
    super.onTapAlwaysCalled,
    super.onTapOutside,
    super.mouseCursor,
    super.scrollController,
    super.scrollPhysics,
    super.clipBehavior,
    super.canRequestFocus,
  }) : super.custom(
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
