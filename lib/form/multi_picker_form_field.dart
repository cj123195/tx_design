import 'package:flutter/material.dart';

import '../utils/basic_types.dart';
import '../widgets/multi_picker_bottom_sheet.dart';
import 'common_text_form_field.dart';
import 'form_field.dart';

export '../utils/basic_types.dart' show ValueMapper;
export '../widgets/multi_picker_bottom_sheet.dart' show MultiPickerItemBuilder;

/// 多选Form组件
@Deprecated(
  'Use TxMultiPickerFormField instead. '
  'This feature was deprecated after v0.3.0.',
)
class MultiPickerFormField<T, V> extends TxMultiPickerFormField {
  @Deprecated(
    'Use TxMultiPickerFormField instead. '
    'This feature was deprecated after v0.3.0.',
  )
  MultiPickerFormField({
    required List<T> sources,
    required super.labelMapper,
    super.valueMapper,
    super.enabledMapper,
    int? minPickNumber,
    int? maxPickNumber,
    Set<V>? initialValue,
    Set<T>? initialData,
    super.key,
    super.onSaved,
    super.validator,
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
          source: sources,
          minCount: minPickNumber,
          maxCount: maxPickNumber,
          initialValue: initialValue?.toList(),
          initialData: initialData?.toList(),
          label: label,
          tileColor: backgroundColor,
          layoutDirection: direction,
          enabled: readonly,
        );
}

typedef MultiPickVoidCallback<T> = Future<List<T>?> Function(
  BuildContext context,
  List<T>? initialValue,
);

/// 处理多选框输入内容变更事件
void _onInputChanged<T>(
  TxFormFieldState<List<T>> field,
  String? text,
  bool? readOnly,
  String splitCharacter,
) {
  if (readOnly != true) {
    final List<String>? data = text?.split(splitCharacter);
    if (data != field.value) {
      field.didChange(data as List<T>?);
    }
  }
}

/// 处理输入框点击事件
Future<void> _onTap<T>(
  TxFormFieldState<List<T>> field,
  MultiPickVoidCallback<T> onPick,
) async {
  final res = await onPick(field.context, field.value);

  if (res != null && res != field.value) {
    field.didChange(res);
  }
}

/// 多项选择框表单
class TxMultiPickerFormField<T, V> extends TxCommonTextFormField<List<T>> {
  TxMultiPickerFormField({
    required List<T> source,
    required ValueMapper<T, String?> labelMapper,
    super.clearable,
    super.key,
    super.onSaved,
    FormFieldValidator<List<T>>? validator,
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    super.decoration,
    super.onChanged,
    super.required,
    ValueMapper<T, V?>? valueMapper,
    IndexedValueMapper<T, bool>? enabledMapper,
    List<T>? initialData,
    List<V>? initialValue,
    int? minCount,
    int? maxCount,
    String splitCharacter = '、',
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
          onFieldTap: (field) => _onTap(
            field,
            (context, value) => showMultiPickerBottomSheet<T, T>(
              context,
              sources: readOnly == true
                  ? source
                  : <T>{...source, ...?field.value}.toList(),
              labelMapper: labelMapper,
              initialValue: value,
              enabledMapper: enabledMapper,
              maxCount: maxCount,
              minCount: minCount,
            ),
          ),
          onInputChanged: (field, text) => _onInputChanged<T>(
            field,
            text,
            readOnly,
            splitCharacter,
          ),
          displayTextMapper: (context, val) =>
              val.map((e) => labelMapper(e)).join(splitCharacter),
          initialValue:
              initData<T, V>(source, initialData, initialValue, valueMapper),
          hintText: hintText ??
              (readOnly == true ? '请选择' : '请选择或输入，以$splitCharacter分隔'),
          validator: (val) =>
              generateValidator(val, validator, required, minCount, maxCount),
          isEmpty: (val) => val.isEmpty,
        );

  TxMultiPickerFormField.custom({
    required MultiPickVoidCallback<T>? onPickTap,
    required super.displayTextMapper,
    super.clearable,
    super.key,
    super.onSaved,
    FormFieldValidator<List<T>>? validator,
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    super.decoration,
    super.onChanged,
    super.required,
    String splitCharacter = '、',
    int? minCount,
    int? maxCount,
    super.focusNode,
    String? hintText,
    super.textAlign,
    super.bordered,
    super.controller,
    super.initialValue,
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
          onFieldTap: (field) => _onTap(field, onPickTap!),
          onInputChanged: (field, text) => _onInputChanged<T>(
            field,
            text,
            readOnly,
            splitCharacter,
          ),
          hintText: hintText ??
              (readOnly == true ? '请选择' : '请选择或输入，以$splitCharacter分隔'),
          validator: (val) =>
              generateValidator(val, validator, required, minCount, maxCount),
          isEmpty: (val) => val.isEmpty,
        );

  /// 根据当前表单值 [value]、传入验证器 [validator]、 是否必填 [required]、最小选择数量
  /// [minCount]、最大选择 数量 [maxCount] 生成默认验证器法。
  static String? generateValidator<T>(
    List<T>? value,
    FormFieldValidator<List<T>>? validator,
    bool? required,
    int? minCount,
    int? maxCount,
  ) {
    if (required == true && (value == null || value.isEmpty)) {
      return '请选择';
    }

    if (validator != null) {
      final String? errorText = validator(value);
      if (errorText != null) {
        return errorText;
      }
    }

    /// 如果最小数量不为空，判断已选数量是否小于最小数量
    if (minCount != null && (value?.length ?? 0) < minCount) {
      return '请至少选择$minCount项';
    }

    /// 如果最小数量不为空，判断已选数量是否小于最小数量
    if (maxCount != null && (value?.length ?? 0) > maxCount) {
      return '最多可选择$maxCount项';
    }

    return null;
  }

  /// 通过传入数据源 [source]、[D] 类型初始数据列表 [initialData]、[V] 类型初始值列表
  /// [initialValue]以及值生成器 [valueMapper] 生成 [D]类型列表初始化数据的方法。
  static List<D>? initData<D, V>(
    List<D> source,
    List<D>? initialData,
    List<V>? initialValue,
    ValueMapper<D, V?>? valueMapper,
  ) {
    return initialData ??
        (initialValue == null
            ? null
            : valueMapper == null
                ? initialValue as List<D>
                : source
                    .where((s) => initialValue.contains(valueMapper(s)))
                    .toList());
  }
}
