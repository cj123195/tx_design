import 'package:flutter/material.dart';

import '../widgets/date_range_picker.dart';
import 'picker_form_field.dart';

export '../widgets/date_range_picker.dart' show TimeRange;

String _defaultFormat(BuildContext context, TimeRange timeRange) =>
    '${timeRange.start.format(context)}\t—\t${timeRange.end.format(context)}';

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
    TimeRange? initialTimeRange,
    TimeOfDay? minimumTime,
    TimeOfDay? maximumTime,
    String? helpText,
    String? fieldStartHintText,
    String? fieldEndHintText,
    String Function(BuildContext context, TimeRange timeRange)? format,
    super.label,
    super.labelText,
    super.labelTextAlign,
    super.labelOverflow,
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
    super.controller,
    super.focusNode,
    super.undoController,
    super.keyboardType,
    super.textInputAction,
    super.textCapitalization,
    super.style,
    super.strutStyle,
    super.textAlign,
    super.bordered,
    super.textAlignVertical,
    super.textDirection,
    super.showCursor,
    super.autofocus,
    super.statesController,
    super.obscuringCharacter,
    super.obscureText,
    super.autocorrect,
    super.smartDashesType,
    super.smartQuotesType,
    super.enableSuggestions,
    super.maxLines,
    super.minLines,
    super.expands,
    super.maxLength,
    super.maxLengthEnforcement,
    super.onEditingComplete,
    super.onFieldSubmitted,
    super.onAppPrivateCommand,
    super.inputFormatters,
    super.cursorWidth,
    super.cursorHeight,
    super.cursorRadius,
    super.cursorOpacityAnimates,
    super.cursorColor,
    super.cursorErrorColor,
    super.selectionHeightStyle,
    super.selectionWidthStyle,
    super.keyboardAppearance,
    super.scrollPadding,
    super.dragStartBehavior,
    super.enableInteractiveSelection,
    super.selectionControls,
    super.onTap,
    super.onTapAlwaysCalled,
    super.onTapOutside,
    super.mouseCursor,
    super.buildCounter,
    super.scrollController,
    super.scrollPhysics,
    super.autofillHints,
    super.contentInsertionConfiguration,
    super.clipBehavior,
    super.scribbleEnabled,
    super.enableIMEPersonalizedLearning,
    super.contextMenuBuilder,
    super.canRequestFocus,
    super.spellCheckConfiguration,
    super.magnifierConfiguration,
  }) : super.custom(
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
          displayTextMapper: format ?? _defaultFormat,
        );

  @override
  TxPickerFormFieldState<TimeRange> createState() =>
      _TxTimeRangePickerFormFieldState();
}

class _TxTimeRangePickerFormFieldState
    extends TxPickerFormFieldState<TimeRange> {
  @override
  List<Widget>? get prefixIcons =>
      [...?super.prefixIcons, const Icon(Icons.access_time)];
}
