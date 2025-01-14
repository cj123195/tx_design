import 'package:flutter/material.dart';

import '../field/field.dart';
import '../field/picker_field.dart';
import '../utils/basic_types.dart';
import '../widgets/picker_bottom_sheet.dart';
import 'common_text_form_field.dart';

export '../utils/basic_types.dart' show ValueMapper;
export '../widgets/picker_bottom_sheet.dart' show PickerItemBuilder;

/// 单选Form组件
@Deprecated(
  'Use TxPickerFormFieldTile instead. '
  'This feature was deprecated after v0.3.0.',
)
class PickerFormField<T, V> extends TxPickerFormField<T, V> {
  @Deprecated(
    'Use TxPickerFormFieldTile instead. '
    'This feature was deprecated after v0.3.0.',
  )
  PickerFormField({
    required List<T>? sources,
    required super.labelMapper,
    super.valueMapper,
    super.enabledMapper,
    super.initialValue,
    super.initialData,
    super.key,
    super.onSaved,
    super.validator,
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    super.required,
    Widget? label,
    super.labelText,
    super.labelTextAlign,
    super.labelOverflow,
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
    super.bordered,
    super.textAlignVertical,
    super.autofocus,
    super.readOnly,
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
          source: sources ?? [],
          label: label,
          tileColor: backgroundColor,
          layoutDirection: direction,
        );
}

/// 处理多选框输入内容变更事件
void _onInputChanged<T>(TxFieldState<T> field, String? text, bool? readOnly) {
  if (readOnly != true) {
    if (text != field.value) {
      field.didChange(text as T?);
    }
  }
}

/// 处理输入框点击事件
Future<void> _onTap<T>(
  TxFieldState<T> field,
  PickVoidCallback<T> onPick,
) async {
  final res = await onPick(field.context, field.value);

  if (res != null && res != field.value) {
    field.didChange(res);
  }
}

/// 单项选择框表单
class TxPickerFormField<T, V> extends TxCommonTextFormField<T> {
  TxPickerFormField({
    required List<T> source,
    required ValueMapper<T, String?> labelMapper,
    super.clearable,
    super.key,
    super.onSaved,
    FormFieldValidator<T>? validator,
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    super.decoration,
    super.onChanged,
    super.required,
    ValueMapper<T, V?>? valueMapper,
    IndexedValueMapper<T, bool>? enabledMapper,
    T? initialData,
    V? initialValue,
    super.focusNode,
    String? hintText,
    super.textAlign,
    super.bordered,
    super.controller,
    super.undoController,
    super.keyboardType,
    super.textInputAction,
    super.textCapitalization,
    super.style,
    super.strutStyle,
    super.textAlignVertical,
    super.textDirection,
    super.readOnly = true,
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
  }) : super(
          initialValue: TxPickerField.initData<T, V>(
              source, initialData, initialValue, valueMapper),
          onTap: (field) => _onTap(
            field,
            (context, value) => showPickerBottomSheet<T, T>(
              context,
              sources: readOnly == true
                  ? source
                  : <T>{...source, if (field.value != null) field.value!}
                      .toList(),
              labelMapper: labelMapper,
              initialValue: value,
              enabledMapper: enabledMapper,
            ),
          ),
          onInputChanged: (field, text) => _onInputChanged<T>(
            field,
            text,
            readOnly,
          ),
          displayTextMapper: (context, val) => labelMapper(val) ?? '',
          hintText: hintText ?? (readOnly == true ? '请选择' : '请选择或输入'),
          validator: (val) => generateValidator(val, validator, required),
        );

  TxPickerFormField.custom({
    required PickVoidCallback<T>? onPickTap,
    required super.displayTextMapper,
    super.clearable,
    super.key,
    super.onSaved,
    FormFieldValidator<T>? validator,
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    super.decoration,
    super.onChanged,
    super.required,
    super.initialValue,
    String? hintText,
    super.controller,
    super.focusNode,
    super.keyboardType,
    super.textCapitalization,
    super.textInputAction,
    super.style,
    super.strutStyle,
    super.textDirection,
    super.textAlign,
    super.bordered,
    super.textAlignVertical,
    super.autofocus,
    super.readOnly = true,
    super.showCursor,
    super.obscuringCharacter,
    super.obscureText,
    super.autocorrect,
    super.smartDashesType,
    super.smartQuotesType,
    super.enableSuggestions,
    super.maxLengthEnforcement,
    super.maxLines,
    super.minLines,
    super.expands,
    super.maxLength,
    super.onTapAlwaysCalled,
    super.onTapOutside,
    super.onEditingComplete,
    super.onFieldSubmitted,
    super.inputFormatters,
    super.cursorWidth,
    super.cursorHeight,
    super.cursorColor,
    super.cursorRadius,
    super.cursorErrorColor,
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
    super.spellCheckConfiguration,
    super.magnifierConfiguration,
    super.undoController,
    super.onAppPrivateCommand,
    super.cursorOpacityAnimates,
    super.selectionHeightStyle,
    super.selectionWidthStyle,
    super.dragStartBehavior,
    super.contentInsertionConfiguration,
    super.statesController,
    super.clipBehavior,
    super.scribbleEnabled,
    super.canRequestFocus,
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
    super.focusColor,
    super.colon,
  }) : super(
          onTap: (field) => _onTap(field, onPickTap!),
          onInputChanged: (field, text) =>
              _onInputChanged<T>(field, text, readOnly),
          hintText: hintText ?? (readOnly == true ? '请选择' : '请选择或输入'),
          validator: (val) => generateValidator(val, validator, required),
        );

  /// 根据当前表单值 [value]、传入验证器 [validator]、 是否必填 [required] 生成默认验证器法。
  static String? generateValidator<T>(
    T? value,
    FormFieldValidator<T>? validator,
    bool? required,
  ) {
    if (required == true && value == null) {
      return '请选择';
    }

    if (validator != null) {
      final String? errorText = validator(value);
      if (errorText != null) {
        return errorText;
      }
    }

    return null;
  }
}
