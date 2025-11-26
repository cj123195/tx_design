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
