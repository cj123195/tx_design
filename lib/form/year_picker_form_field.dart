import 'package:flutter/material.dart';

import '../widgets/date_picker.dart' show showCupertinoYearPicker;
import 'form_field.dart';

/// 年份选择 Form 组件
class YearPickerFormField extends TxPickerTextFormField<int, int> {
  YearPickerFormField({
    int? initialYear,
    String format = 'yyyy',
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
          labelMapper: (int year) => format.replaceAll('yyyy', '$year'),
          valueMapper: (int year) => year,
          initialValue: initialYear,
          dataMapper: (String? value) =>
              value == null ? null : int.tryParse(value),
          onPickTap: (context, initialMonth) => showCupertinoYearPicker(
            context,
            minimumYear: minimumYear,
            maximumYear: maximumYear,
          ),
          actionsBuilder: (field) => actions,
        );
}
