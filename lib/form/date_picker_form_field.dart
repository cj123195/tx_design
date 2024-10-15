import 'package:flutter/material.dart';

import '../extensions/datetime_extension.dart';
import '../widgets/date_picker.dart';
import 'picker_form_field.dart';

const String _defaultFormat = 'yyyy-MM-dd';

/// 日期选择Form组件
@Deprecated(
  'Use TxDatePickerFormFieldTile instead. '
  'This feature was deprecated after v0.3.0.',
)
class DatePickerFormField extends TxDatePickerFormFieldTile {
  @Deprecated(
    'Use TxDatePickerFormFieldTile instead. '
    'This feature was deprecated after v0.3.0.',
  )
  DatePickerFormField({
    super.initialDateStr,
    super.initialDate,
    super.format,
    DateTime? minimumDate,
    DateTime? maximumDate,
    super.minimumYear,
    super.maximumYear,
    super.key,
    super.onSaved,
    super.validator,
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    super.required,
    Widget? label,
    super.labelText,
    Color? backgroundColor,
    Axis? direction,
    super.padding,
    super.actionsBuilder,
    super.labelStyle,
    super.horizontalGap,
    super.minLabelWidth,
    super.controller,
    super.focusNode,
    super.decoration,
    super.keyboardType,
    super.textCapitalization,
    super.textInputAction,
    super.style,
    super.strutStyle,
    super.textDirection,
    super.textAlign,
    super.textAlignVertical,
    super.autofocus,
    super.maxLines,
    super.minLines,
    super.maxLength,
    super.onChanged,
    super.onEditingComplete,
    super.inputFormatters,
    super.showCursor,
    super.obscuringCharacter,
    super.obscureText,
    super.autocorrect,
    super.smartDashesType,
    super.smartQuotesType,
    super.enableSuggestions,
    super.maxLengthEnforcement,
    super.expands,
    super.onTapOutside,
    super.onFieldSubmitted,
    super.cursorWidth,
    super.cursorHeight,
    super.cursorRadius,
    super.cursorColor,
    super.keyboardAppearance,
    super.scrollPadding,
    super.enableInteractiveSelection,
    super.selectionControls,
    super.buildCounter,
    super.scrollPhysics,
    super.autofillHints,
    super.scrollController,
    super.enableIMEPersonalizedLearning,
    super.mouseCursor,
    super.contextMenuBuilder,
  }) : super(
          labelBuilder: label == null ? null : (context) => label,
          layoutDirection: direction,
          tileColor: backgroundColor,
          firstDate: minimumDate,
          lastDate: maximumDate,
        );
}

/// builder 构建组件为日期选择框的 [FormField]
class TxDatePickerFormField extends TxPickerFormField<DateTime, String> {
  TxDatePickerFormField({
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
    String? initialDateStr,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    int? minimumYear,
    int? maximumYear,
    String? format,
    String? titleText,
    super.controller,
    super.focusNode,
    super.undoController,
    super.keyboardType,
    super.textInputAction,
    super.textCapitalization,
    super.style,
    super.strutStyle,
    super.textAlign,
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
          initialValue: initialDate ??
              (initialDateStr == null
                  ? null
                  : DateTime.tryParse(initialDateStr)),
          onPickTap: (context, date) => showCupertinoDatePicker(
            context,
            initialDate: date,
            titleText: titleText,
            minimumDate: firstDate,
            maximumDate: lastDate,
            minimumYear: minimumYear,
            maximumYear: maximumYear,
          ),
          displayTextMapper: (context, date) =>
              date.format(format ?? _defaultFormat),
        );
}

/// field 为日期选择框表单的 [TxPickerFormFieldTile]
class TxDatePickerFormFieldTile
    extends TxPickerFormFieldTile<DateTime, String> {
  TxDatePickerFormFieldTile({
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
    String? initialDateStr,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    int? minimumYear,
    int? maximumYear,
    String? format,
    String? titleText,
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
    super.focusNode,
    super.undoController,
    super.keyboardType,
    super.textInputAction,
    super.textCapitalization,
    super.style,
    super.strutStyle,
    super.textAlign,
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
          initialValue: initialDate ??
              (initialDateStr == null
                  ? null
                  : DateTime.tryParse(initialDateStr)),
          onPickTap: (context, date) => showCupertinoDatePicker(
            context,
            initialDate: date,
            titleText: titleText,
            minimumDate: firstDate,
            maximumDate: lastDate,
            minimumYear: minimumYear,
            maximumYear: maximumYear,
          ),
          displayTextMapper: (context, date) =>
              date.format(format ?? _defaultFormat),
        );
}
