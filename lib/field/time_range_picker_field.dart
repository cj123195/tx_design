import 'package:flutter/material.dart';

import '../widgets/date_range_picker.dart';
import 'picker_field.dart';

export '../widgets/date_range_picker.dart' show TimeRange;

String _defaultFormat(BuildContext context, TimeRange timeRange) =>
    '${timeRange.start.format(context)}\t-\t${timeRange.end.format(context)}';

/// 时间段选择框
class TxTimeRangePickerField extends TxPickerField<TimeRange, TimeRange> {
  TxTimeRangePickerField({
    super.key,
    super.focusNode,
    super.decoration,
    super.onChanged,
    super.enabled,
    super.hintText,
    super.textAlign,
    TimeRange? initialTimeRange,
    TimeOfDay? minimumTime,
    TimeOfDay? maximumTime,
    String? helpText,
    String? fieldStartHintText,
    String? fieldEndHintText,
    String Function(BuildContext context, TimeRange timeRange)? format,
    super.controller,
    super.undoController,
    super.keyboardType,
    super.textInputAction,
    super.textCapitalization,
    super.style,
    super.strutStyle,
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
    super.onSubmitted,
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
    super.onTapAlwaysCalled,
    super.onTapOutside,
    super.mouseCursor,
    super.buildCounter,
    super.scrollController,
    super.scrollPhysics,
    super.autofillHints,
    super.contentInsertionConfiguration,
    super.clipBehavior,
    super.restorationId,
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
}

/// field 为日期范围选择框的 [TxPickerFieldTile]
class TxTimeRangePickerFieldTile
    extends TxPickerFieldTile<TimeRange, TimeRange> {
  TxTimeRangePickerFieldTile({
    super.key,
    super.focusNode,
    super.decoration,
    super.onChanged,
    super.enabled,
    super.hintText,
    super.textAlign,
    TimeRange? initialTimeRange,
    TimeOfDay? minimumTime,
    TimeOfDay? maximumTime,
    String? helpText,
    String? fieldStartHintText,
    String? fieldEndHintText,
    String Function(BuildContext context, TimeRange timeRange)? format,
    super.labelBuilder,
    super.labelText,
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
    super.controller,
    super.undoController,
    super.keyboardType,
    super.textInputAction,
    super.textCapitalization,
    super.style,
    super.strutStyle,
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
    super.onSubmitted,
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
    super.onTapAlwaysCalled,
    super.onTapOutside,
    super.mouseCursor,
    super.buildCounter,
    super.scrollController,
    super.scrollPhysics,
    super.autofillHints,
    super.contentInsertionConfiguration,
    super.clipBehavior,
    super.restorationId,
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
}