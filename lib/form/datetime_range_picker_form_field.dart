import 'package:flutter/material.dart';

import '../widgets/datetime_range_picker.dart';
import 'date_range_picker_form_field.dart';

/// 日期+时间范围选择组件
class DatetimeRangePickerFormField extends DateRangePickerFormField {
  DatetimeRangePickerFormField({
    super.format = 'yyyy-MM-dd HH:mm',
    super.firstDate,
    super.lastDate,
    super.helpText,
    super.fieldStartHintText,
    super.fieldEndHintText,
    Duration? maximumTimeDifference,
    Duration? minimumTimeDifference,
    super.key,
    super.required,
    super.label,
    super.labelText,
    super.backgroundColor,
    super.direction,
    super.padding,
    super.actions,
    super.labelStyle,
    super.starStyle,
    super.horizontalGap,
    super.minLabelWidth,
    super.onSaved,
    super.validator,
    super.initialValue,
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    super.decoration,
    super.style,
    super.strutStyle,
    super.textDirection,
    super.textAlign,
    super.textAlignVertical,
    super.contextMenuBuilder,
    super.onChanged,
  }) : super(
          onTap: (BuildContext context, DateTimeRange? initialValue) =>
              showDatetimeRangePicker(
            context,
            firstDate: firstDate,
            lastDate: lastDate,
            initialDatetimeRange: initialValue,
            minimumTimeDifference: minimumTimeDifference,
            maximumTimeDifference: maximumTimeDifference,
          ),
        );
}
