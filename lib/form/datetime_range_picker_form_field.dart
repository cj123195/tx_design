import 'package:flutter/material.dart';

import '../utils/basic_types.dart';
import '../widgets/datetime_range_picker.dart';
import 'date_range_picker_form_field.dart';

/// 日期+时间范围选择组件
class DatetimeRangePickerFormField extends DateRangePickerFormField {
  DatetimeRangePickerFormField({
    super.format = 'yyyy-MM-dd HH:mm',
    super.onChanged,
    super.decoration = const InputDecoration(),
    super.firstDate,
    super.lastDate,
    Duration? maximumTimeDifference,
    Duration? minimumTimeDifference,

    /// Form 参数
    super.validator,
    super.key,
    super.onSaved,
    super.initialDateRange,
    super.required = false,
    super.enabled,
    super.restorationId,
    super.autovalidateMode,

    // FormItemContainer参数
    super.label,
    super.labelText,
    super.padding,
    super.backgroundColor,
    super.labelStyle,
    super.starStyle,
    super.direction,

    /// TextField参数
    super.style,
    super.strutStyle,
    super.textDirection,
    super.textAlign = TextAlign.center,
    super.textAlignVertical,
    super.contextMenuBuilder,
    PickerFuture<DateTimeRange?>? onTap,
  }) : super(
          onTap: onTap ??
              (BuildContext context, DateTimeRange? initialValue) =>
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
