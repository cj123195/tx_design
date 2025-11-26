import 'package:flutter/material.dart';

import '../widgets/picker.dart';
import 'common_text_form_field.dart';
import 'form_field.dart';

export '../utils/basic_types.dart' show ValueMapper;
export '../widgets/picker.dart' show PickerItemBuilder;

typedef PickVoidCallback<T> = Future<T?> Function(
  BuildContext context,
  T? initialValue,
);

/// 处理多选框输入内容变更事件
void _onInputChanged<T>(
  TxFormFieldState<T> field,
  String? text,
  bool? inputEnabled,
) {
  if (inputEnabled == true) {
    if (text != field.value) {
      field.didChange(text as T?);
    }
  }
}

/// 处理输入框点击事件
Future<void> _onTap<T>(
  TxFormFieldState<T> field,
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
    DataWidgetBuilder<T>? subtitleBuilder,
    PickerItemBuilder<T>? itemBuilder,
    ValueMapper<T, bool>? disabledWhen,
    T? initialData,
    V? initialValue,
    bool? showSearchField,
    Widget? placeholder,
    ListTileThemeData? listTileTheme,
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
    bool? readOnly,
    bool? inputEnabled,
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
    super.label,
    super.labelText,
    super.labelTextAlign,
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
  })  : _readOnly = readOnly ?? false,
        inputEnabled = inputEnabled ?? false,
        super(
          initialValue:
              initData<T, V>(source, initialData, initialValue, valueMapper),
          onFieldTap: readOnly == true
              ? null
              : (field) => _onTap(
                    field,
                    (context, value) => showPickerBottomSheet<T, V>(
                      context,
                      source: readOnly == true
                          ? source
                          : <T>{
                              ...source,
                              if (field.value != null) field.value!
                            }.toList(),
                      labelMapper: labelMapper,
                      valueMapper: valueMapper,
                      initialData: value,
                      disabledWhen: disabledWhen,
                      title: labelText,
                      subtitleBuilder: subtitleBuilder,
                      itemBuilder: itemBuilder,
                      showSearchField: showSearchField,
                      placeholder: placeholder,
                      listTileTheme: listTileTheme,
                    ),
                  ),
          readOnly: inputEnabled != true || readOnly == true,
          onInputChanged: (field, text) => _onInputChanged<T>(
            field,
            text,
            inputEnabled,
          ),
          displayTextMapper: (context, val) => labelMapper(val) ?? '',
          hintText: readOnly == true
              ? null
              : hintText ?? (inputEnabled == true ? '请选择或输入' : '请选择'),
          validator: readOnly == true
              ? null
              : (val) => generateValidator(val, validator, required),
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
    bool? readOnly,
    bool? inputEnabled,
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
    super.onTap,
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
  })  : _readOnly = readOnly ?? false,
        inputEnabled = inputEnabled ?? false,
        super(
          onFieldTap:
              readOnly == true ? null : (field) => _onTap(field, onPickTap!),
          readOnly: inputEnabled != true || readOnly == true,
          onInputChanged: (field, text) =>
              _onInputChanged<T>(field, text, inputEnabled),
          hintText: readOnly == true
              ? null
              : hintText ?? (inputEnabled == true ? '请选择或输入' : '请选择'),
          validator: (val) => generateValidator(val, validator, required),
        );

  /// 是否可选
  final bool _readOnly;

  /// 是否允许输入
  final bool inputEnabled;

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

  /// 通过传入数据源 [source]、[D] 类型初始数据 [initialData]、[V] 类型初始值
  /// [initialValue]以及值生成器 [valueMapper] 生成 [D] 类型初始化数据的方法。
  static D? initData<D, V>(
    List<D> source,
    D? initialData,
    V? initialValue,
    ValueMapper<D, V?>? valueMapper,
  ) {
    if (initialData != null) {
      return initialData;
    }
    if (initialValue == null) {
      return null;
    }
    if (valueMapper == null) {
      return initialValue as D;
    }
    for (D item in source) {
      if (initialValue == valueMapper(item)) {
        return item;
      }
    }
    return null;
  }

  @override
  TxPickerFormFieldState<T, V> createState() => TxPickerFormFieldState<T, V>();
}

class TxPickerFormFieldState<T, V> extends TxCommonTextFormFieldState<T> {
  @override
  bool get clearable =>
      !widget._readOnly && isEnabled && widget.clearable != false && !isEmpty;

  @override
  TxPickerFormField<T, V> get widget => super.widget as TxPickerFormField<T, V>;

  @override
  List<Widget>? get suffixIcons => [
        ...?super.suffixIcons,
        if (isEnabled && !widget._readOnly)
          const Icon(Icons.keyboard_arrow_right),
      ];
}
