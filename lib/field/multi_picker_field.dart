import 'package:flutter/material.dart';

import '../utils/basic_types.dart';
import '../widgets/multi_picker_bottom_sheet.dart';
import 'common_text_field.dart';
import 'field.dart';
import 'field_tile.dart';

typedef MultiPickVoidCallback<T> = Future<List<T>?> Function(
  BuildContext context,
  List<T>? initialValue,
);

/// 处理多选框输入内容变更事件
void _onInputChanged<T>(
  TxFieldState<List<T>> field,
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
  TxFieldState<List<T>> field,
  MultiPickVoidCallback<T> onPick,
) async {
  final res = await onPick(field.context, field.value);

  if (res != null && res != field.value) {
    field.didChange(res);
  }
}

/// 多项选择框
class TxMultiPickerField<T, V> extends TxCommonTextField<List<T>> {
  TxMultiPickerField({
    required List<T> source,
    required ValueMapper<T, String?> labelMapper,
    ValueMapper<T, V?>? valueMapper,
    IndexedValueMapper<T, bool>? enabledMapper,
    List<T>? initialData,
    List<V>? initialValue,
    int? minCount,
    int? maxCount,
    String splitCharacter = '、',
    super.clearable,
    super.key,
    super.focusNode,
    super.decoration,
    super.onChanged,
    super.enabled,
    String? hintText,
    super.textAlign,
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
  })  : assert(readOnly == true || T == String),
        assert(
          readOnly == true || enabled == false || T == String,
          '当选择框允许输入且可操作时，数据源类型 T 必须为 String',
        ),
        super(
          onTap: (field) => _onTap(
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
        );

  ///自定义选择框
  TxMultiPickerField.custom({
    required MultiPickVoidCallback<T>? onPickTap,
    required super.displayTextMapper,
    String splitCharacter = '、',
    super.clearable,
    super.key,
    super.focusNode,
    super.decoration,
    super.onChanged,
    super.enabled,
    String? hintText,
    super.textAlign,
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
  })  : assert(
          enabled != true || onPickTap != null,
          '当 enabled 为 true 即选择框为可操作状态时，onPickTap 不能为空',
        ),
        assert(
          readOnly == true || T is String,
          '当 displayTextMapper 为 null 时，T 必须为 String 类型',
        ),
        super(
          onTap: (field) => _onTap(field, onPickTap!),
          onInputChanged: (field, text) => _onInputChanged<T>(
            field,
            text,
            readOnly,
            splitCharacter,
          ),
          hintText: hintText ??
              (readOnly == true ? '请选择' : '请选择或输入，以$splitCharacter分隔'),
        );

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

/// field 为多项选择框的 [TxFieldTile]
class TxMultiPickerFieldTile<T, V> extends TxCommonTextFieldTile<List<T>> {
  TxMultiPickerFieldTile({
    required List<T> source,
    required ValueMapper<T, String?> labelMapper,
    super.clearable,
    super.key,
    super.focusNode,
    super.decoration,
    super.onChanged,
    super.enabled,
    String? hintText,
    super.textAlign,
    ValueMapper<T, V?>? valueMapper,
    IndexedValueMapper<T, bool>? enabledMapper,
    List<T>? initialData,
    List<V>? initialValue,
    int? minCount,
    int? maxCount,
    String splitCharacter = '、',
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
          initialValue: TxMultiPickerField.initData<T, V>(
              source, initialData, initialValue, valueMapper),
          hintText: hintText ??
              (readOnly == true ? '请选择' : '请选择或输入，以$splitCharacter分隔'),
        );

  TxMultiPickerFieldTile.custom({
    required MultiPickVoidCallback<T>? onPickTap,
    required super.displayTextMapper,
    super.clearable,
    super.key,
    super.focusNode,
    super.decoration,
    super.onChanged,
    super.enabled,
    String? hintText,
    super.textAlign,
    String splitCharacter = '、',
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
    ValueMapper<T, V?>? valueMapper,
    List<T>? initialData,
    List<V>? initialValue,
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
          onInputChanged: (field, text) => _onInputChanged<T>(
            field,
            text,
            readOnly,
            splitCharacter,
          ),
          hintText: hintText ??
              (readOnly == true ? '请选择' : '请选择或输入，以$splitCharacter分隔'),
        );
}
