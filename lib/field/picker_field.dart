import 'package:flutter/material.dart';

import '../utils/basic_types.dart';
import '../widgets/picker_bottom_sheet.dart';
import 'common_text_field.dart';
import 'field.dart';

typedef PickVoidCallback<T> = Future<T?> Function(
  BuildContext context,
  T? initialValue,
);

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

/// 单项选择框
class TxPickerField<T, V> extends TxCommonTextField<T> {
  TxPickerField({
    required List<T> source,
    required ValueMapper<T, String?> labelMapper,
    super.key,
    super.focusNode,
    super.decoration,
    super.onChanged,
    super.enabled,
    super.clearable,
    String? hintText,
    super.textAlign,
    super.bordered,
    ValueMapper<T, V?>? valueMapper,
    IndexedValueMapper<T, bool>? enabledMapper,
    T? initialData,
    V? initialValue,
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
    super.onSubmitted,
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
    super.restorationId,
    super.scribbleEnabled,
    super.enableIMEPersonalizedLearning,
    super.contextMenuBuilder,
    super.canRequestFocus,
    super.spellCheckConfiguration,
    super.magnifierConfiguration,
  }) : super(
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
          onInputChanged: (field, text) =>
              _onInputChanged<T>(field, text, readOnly),
          displayTextMapper: (context, val) => labelMapper(val) ?? '',
          initialValue: initData<T, V>(
            source,
            initialData,
            initialValue,
            valueMapper,
          ),
          hintText: hintText ?? (readOnly == true ? '请选择' : '请选择或输入'),
        );

  TxPickerField.custom({
    required PickVoidCallback<T>? onPickTap,
    required super.displayTextMapper,
    super.clearable,
    super.key,
    super.focusNode,
    super.decoration,
    super.onChanged,
    super.enabled,
    String? hintText,
    super.textAlign,
    super.bordered,
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
    super.onSubmitted,
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
    super.restorationId,
    super.scribbleEnabled,
    super.enableIMEPersonalizedLearning,
    super.contextMenuBuilder,
    super.canRequestFocus,
    super.spellCheckConfiguration,
    super.magnifierConfiguration,
  }) : super(
          onTap: (field) => _onTap(field, onPickTap!),
          onInputChanged: (field, text) =>
              _onInputChanged<T>(field, text, readOnly),
          hintText: hintText ?? (readOnly == true ? '请选择' : '请选择或输入'),
        );

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
}
