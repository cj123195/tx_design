import 'package:flutter/material.dart';

import '../extensions/datetime_extension.dart';
import '../widgets/date_picker.dart';
import 'picker_form_field.dart';

/// 月份选择 Form 组件
@Deprecated(
  'Use TxMonthPickerFormFieldTile instead. '
  'This feature was deprecated after v0.3.0.',
)
class MonthPickerFormField extends TxMonthPickerFormFieldTile {
  @Deprecated(
    'Use TxMonthPickerFormFieldTile instead. '
    'This feature was deprecated after v0.3.0.',
  )
  MonthPickerFormField({
    super.initialMonthStr,
    super.initialMonth,
    super.format,
    super.minimumMonth,
    super.maximumMonth,
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
    List<Widget>? actions,
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
          tileColor: backgroundColor,
          layoutDirection: direction,
        );
}

const String _defaultFormat = 'yyyy-MM';

/// [builder] 构建组件为月份选择框的 [FormField]
class TxMonthPickerFormField extends TxPickerFormField<DateTime, String> {
  TxMonthPickerFormField({
    String? initialMonthStr,
    DateTime? initialMonth,
    DateTime? minimumMonth,
    DateTime? maximumMonth,
    int? minimumYear,
    int? maximumYear,
    String? format,
    String? titleText,
    super.key,
    super.controller,
    super.focusNode,
    super.undoController,
    super.decoration,
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
    super.onChanged,
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
    super.onSaved,
    super.validator,
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    super.required,
  }) : super.custom(
          initialValue: initialMonth ??
              (initialMonthStr == null
                  ? null
                  : DateTime.tryParse(initialMonthStr)),
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
}

/// [field] 为月份选择框表单的 [TxPickerFormFieldTile]
class TxMonthPickerFormFieldTile
    extends TxPickerFormFieldTile<DateTime, String> {
  TxMonthPickerFormFieldTile({
    String? initialMonthStr,
    DateTime? initialMonth,
    DateTime? minimumMonth,
    DateTime? maximumMonth,
    int? minimumYear,
    int? maximumYear,
    String? format,
    String? titleText,
    super.labelBuilder,
    super.labelText,
    super.padding,
    super.actions,
    super.labelStyle,
    super.horizontalGap,
    super.tileColor,
    super.layoutDirection,
    super.trailing,
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
    super.key,
    super.controller,
    super.focusNode,
    super.undoController,
    super.decoration,
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
    super.onChanged,
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
    super.onSaved,
    super.validator,
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    super.required,
  }) : super.custom(
          initialValue: initialMonth ??
              (initialMonthStr == null
                  ? null
                  : DateTime.tryParse(initialMonthStr)),
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
}
