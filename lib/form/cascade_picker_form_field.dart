import 'package:flutter/material.dart';

import '../extensions.dart';
import '../widgets/cascade_picker.dart';
import 'common_text_form_field.dart';
import 'picker_form_field.dart';

/// 级联选择框表单
class TxCascadePickerFormField<T, V> extends TxCommonTextFormField<T> {
  TxCascadePickerFormField({
    required List<T> source,
    required ValueMapper<T, String?> labelMapper,
    required ValueMapper<T, List<T>?> childrenMapper,
    super.clearable,
    bool? isParentNodeSelectable,
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
          initialValue: source.getInitialData<V>(
            initialData: initialData,
            initialValue: initialValue,
            valueMapper: valueMapper,
          ),
          onFieldTap: (field) async {
            final res = await showCascadePicker<T, V>(
              context: field.context,
              datasource: source,
              labelMapper: labelMapper,
              valueMapper: valueMapper,
              childrenMapper: childrenMapper,
              initialData: field.value,
              isParentNodeSelectable: isParentNodeSelectable,
            );
            if (res != null) {
              field.didChange(res);
            }
          },
          displayTextMapper: (context, val) => labelMapper(val) ?? '',
          hintText: hintText ?? '请选择',
          validator: (val) => TxPickerFormField.generateValidator(
            val,
            validator,
            required,
          ),
          readOnly: true,
        );

  TxCascadePickerFormField.fromMapList({
    required List<Map> source,
    String? labelKey,
    String? valueKey,
    String? idKey,
    String? pidKey,
    String? childrenKey,
    super.clearable,
    bool? isParentNodeSelectable,
    super.key,
    super.onSaved,
    FormFieldValidator<Map>? validator,
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    super.decoration,
    super.onChanged,
    super.required,
    Map? initialData,
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
          initialValue: source.getInitialData<V>(
            initialData: initialData,
            initialValue: initialValue,
            valueMapper: (data) => data[valueKey],
          ) as T?,
          onFieldTap: (field) async {
            final res = await showMapListCascadePicker<V>(
              context: field.context,
              datasource: source,
              labelKey: labelKey,
              valueKey: valueKey,
              childrenKey: childrenKey,
              idKey: idKey,
              pidKey: pidKey,
              initialData: field.value as Map?,
              isParentNodeSelectable: isParentNodeSelectable,
            );
            if (res != null) {
              field.didChange(res as T);
            }
          },
          displayTextMapper: (context, val) =>
              (val as Map?)?[labelKey ?? kLabelKey] ?? '',
          hintText: hintText ?? '请选择',
          validator: (val) => TxPickerFormField.generateValidator(
            val,
            validator as FormFieldValidator<T>?,
            required,
          ),
          readOnly: true,
        );

  TxCascadePickerFormField.fromMapTree({
    required List<Map> source,
    String? labelKey,
    String? valueKey,
    String? childrenKey,
    super.clearable,
    bool? isParentNodeSelectable,
    super.key,
    super.onSaved,
    FormFieldValidator<Map>? validator,
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    super.decoration,
    super.onChanged,
    super.required,
    Map? initialData,
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
          initialValue: source.getInitialData<V>(
            initialData: initialData,
            initialValue: initialValue,
            valueMapper: (data) => data[valueKey],
          ) as T?,
          onFieldTap: (field) async {
            final res = await showMapTreeCascadePicker<V>(
              context: field.context,
              datasource: source,
              labelKey: labelKey,
              valueKey: valueKey,
              childrenKey: childrenKey,
              initialData: field.value as Map?,
              isParentNodeSelectable: isParentNodeSelectable,
            );
            if (res != null) {
              field.didChange(res as T);
            }
          },
          displayTextMapper: (context, val) =>
              (val as Map?)?[labelKey ?? kLabelKey] ?? '',
          hintText: hintText ?? '请选择',
          validator: (val) => TxPickerFormField.generateValidator(
            val,
            validator as FormFieldValidator<T>?,
            required,
          ),
          readOnly: true,
        );

  @override
  TxCommonTextFormFieldState<T> createState() =>
      _TxCascadePickerFormFieldState();
}

class _TxCascadePickerFormFieldState<T> extends TxCommonTextFormFieldState<T> {
  @override
  List<Widget>? get suffixIcons => [
        ...?super.suffixIcons,
        const Icon(Icons.keyboard_arrow_right),
      ];
}
