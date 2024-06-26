import 'package:flutter/material.dart';

import '../extensions/datetime_extension.dart';
import '../extensions/string_extension.dart';
import '../widgets/date_picker.dart' show showCupertinoDatetimePicker;
import 'form_field.dart';

/// 日期+时间选择组件
class DatetimePickerFormField
    extends TxPickerTextFormField<DateTime, DateTime> {
  DatetimePickerFormField({
    String? initialDatetimeStr,
    DateTime? initialDatetime,
    String? format = 'yyyy-MM-dd HH:mm',
    DateTime? minimumDate,
    DateTime? maximumDate,
    int? minimumYear,
    int? maximumYear,
    super.key,
    super.onSaved,
    super.validator,
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    super.required,
    super.label,
    super.labelText,
    super.backgroundColor,
    super.direction,
    super.padding,
    List<Widget>? actions,
    super.labelStyle,
    super.starStyle,
    super.horizontalGap,
    super.minLabelWidth,
    super.controller,
    super.prefixIconMergeMode,
    super.suffixIconMergeMode,
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
    super.readonly,
    super.maxLines,
    super.minLines,
    super.maxLength,
    super.onChanged,
    super.onTap,
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
          labelMapper: (DateTime date) => date.format(format),
          valueMapper: (DateTime date) => date,
          initialValue: initialDatetime ?? initialDatetimeStr?.toDatetime(),
          onPickTap: (context, initialDate) => showCupertinoDatetimePicker(
            context,
            initialDateTime: initialDate,
            minimumDate: minimumDate,
            maximumDate: maximumDate,
            minimumYear: minimumYear,
            maximumYear: maximumYear,
          ),
          actionsBuilder: (field) => actions,
        );
}
