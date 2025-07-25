import 'package:flutter/material.dart';

import '../extensions/datetime_extension.dart';
import '../extensions/string_extension.dart';
import '../widgets/date_picker.dart';
import 'picker_form_field.dart';

const String _defaultFormat = 'yyyy/MM/dd HH:mm';

/// 日期时间选择框表单
class TxDatetimePickerFormField extends TxPickerFormField<DateTime, String> {
  TxDatetimePickerFormField({
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
    String? initialDatetimeStr,
    DateTime? initialDatetime,
    DateTime? minimumDate,
    DateTime? maximumDate,
    int? minimumYear,
    int? maximumYear,
    String? format,
    String? titleText,
    super.readOnly,
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
          initialValue:
              initialDatetime ?? initialDatetimeStr?.toDatetime(format: format),
          onPickTap: (context, date) => showCupertinoDatetimePicker(
            context,
            initialDateTime: date,
            titleText: titleText,
            minimumDate: minimumDate,
            maximumDate: maximumDate,
            minimumYear: minimumYear,
            maximumYear: maximumYear,
            showSeconds: format?.toLowerCase().contains('s') == true,
          ),
          displayTextMapper: (context, datetime) =>
              datetime.format(format ?? _defaultFormat),
        );

  @override
  TxPickerFormFieldState<DateTime, String> createState() =>
      _TxDatetimePickerFormFieldState();
}

class _TxDatetimePickerFormFieldState
    extends TxPickerFormFieldState<DateTime, String> {
  @override
  Widget? get prefixIcon => const Icon(Icons.calendar_month);
}
