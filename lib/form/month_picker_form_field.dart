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
