import 'package:flutter/material.dart';

import '../extensions/datetime_range_extension.dart';
import '../widgets/date_range_picker.dart';
import 'picker_form_field.dart';

const String _defaultFormat = 'slashDatetime';

/// 日期+时间范围选择组件
@Deprecated(
  'Use TxDatetimeRangePickerFormField instead. '
  'This feature was deprecated after v0.3.0.',
)
class DatetimeRangePickerFormField extends TxDatetimeRangePickerFormField {
  @Deprecated(
    'Use TxDatetimeRangePickerFormField instead. '
    'This feature was deprecated after v0.3.0.',
  )
  DatetimeRangePickerFormField({
    super.format,
    super.minimumDate,
    super.maximumDate,
    super.helpText,
    super.key,
    super.required,
    Widget? label,
    super.labelText,
    super.labelTextAlign,
    super.labelOverflow,
    Color? backgroundColor,
    Axis direction = Axis.vertical,
    super.padding,
    super.actionsBuilder,
    super.labelStyle,
    super.horizontalGap,
    super.minLabelWidth,
    super.onSaved,
    super.validator,
    DateTimeRange? initialValue,
    bool? readonly,
    super.autovalidateMode,
    super.restorationId,
    super.decoration,
    super.style,
    super.strutStyle,
    super.textDirection,
    super.textAlign,
    super.bordered,
    super.textAlignVertical,
    super.contextMenuBuilder,
    super.onChanged,
  }) : super(
          label: label,
          tileColor: backgroundColor,
          layoutDirection: direction,
          initialDatetimeRange: initialValue,
          enabled: readonly,
        );
}

/// 日期时间范围选择框表单
class TxDatetimeRangePickerFormField
    extends TxPickerFormField<DateTimeRange, DateTimeRange> {
  TxDatetimeRangePickerFormField({
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
    DateTimeRange? initialDatetimeRange,
    DateTime? minimumDate,
    DateTime? maximumDate,
    String? helpText,
    String? titleText,
    String? format,
    String? separator,
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
          initialValue: initialDatetimeRange,
          onPickTap: (context, range) => showCupertinoDatetimeRangePicker(
            context,
            minimumDate: minimumDate,
            maximumDate: maximumDate,
            initialDatetimeRange: range,
            helpText: helpText,
            titleText: titleText,
          ),
          displayTextMapper: (context, range) => range.format(
            format: format ?? _defaultFormat,
            separator: separator,
          ),
        );

  @override
  TxPickerFormFieldState<DateTimeRange> createState() =>
      _TxDatetimeRangePickerFormFieldState();
}

class _TxDatetimeRangePickerFormFieldState
    extends TxPickerFormFieldState<DateTimeRange> {
  @override
  List<Widget>? get prefixIcons =>
      [...?super.prefixIcons, const Icon(Icons.date_range)];
}
