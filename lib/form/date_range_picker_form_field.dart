import 'package:flutter/material.dart';

import '../extensions/datetime_range_extension.dart';
import '../utils/basic_types.dart';
import '../widgets/date_range_picker.dart';
import 'picker_form_field.dart';

/// 日期范围选择组件
@Deprecated(
  'Use TxDateRangePickerFormField instead. '
  'This feature was deprecated after v0.3.0.',
)
class DateRangePickerFormField extends TxDateRangePickerFormField {
  @Deprecated(
    'Use TxDateRangePickerFormField instead. '
    'This feature was deprecated after v0.3.0.',
  )
  DateRangePickerFormField({
    super.format,
    super.minimumDate,
    super.maximumDate,
    super.helpText,
    super.fieldStartHintText,
    super.fieldEndHintText,
    super.quickChoices,
    super.key,
    super.onSaved,
    super.validator,
    DateTimeRange? initialValue,
    bool? readonly,
    super.autovalidateMode,
    super.restorationId,
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
    InputDecoration decoration = const InputDecoration(),
    TextStyle? style,
    StrutStyle? strutStyle,
    TextDirection? textDirection,
    TextAlign textAlign = TextAlign.center,
    TextAlignVertical? textAlignVertical,
    EditableTextContextMenuBuilder? contextMenuBuilder,
    ValueChanged<DateTimeRange?>? onChanged,
    PickerFuture<DateTimeRange?>? onTap,
  }) : super(
          initialDateRange: initialValue,
          label: label,
          layoutDirection: direction,
          enabled: readonly,
        );
}

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
    DateTimeRange? initialDateRange,
    DateTime? minimumDate,
    DateTime? maximumDate,
    String? helpText,
    String? fieldStartHintText,
    String? fieldEndHintText,
    List<DateRangeQuickChoice>? quickChoices = const [
      DateRangeMonthQuickChoice(),
      DateRangeMonthQuickChoice(value: 6),
      DateRangeYearQuickChoice(),
    ],
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
  TxPickerFormFieldState<DateTimeRange> createState() =>
      _TxDateRangePickerFormFieldState();
}

class _TxDateRangePickerFormFieldState
    extends TxPickerFormFieldState<DateTimeRange> {
  @override
  List<Widget>? get prefixIcons =>
      [...?super.prefixIcons, const Icon(Icons.date_range)];
}
