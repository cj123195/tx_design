import 'package:flutter/material.dart';

import '../localizations.dart';
import '../utils/basic_types.dart';
import '../widgets/multi_picker_bottom_sheet.dart';
import 'common_text_field.dart';
import 'field_tile.dart';

typedef MultiPickVoidCallback<T> = Future<List<T>?> Function(
  BuildContext context,
  List<T>? initialValue,
);

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
    this.splitCharacter = '、',
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
    super.onChanged,
    super.onEditingComplete,
    super.onSubmitted,
    super.onAppPrivateCommand,
    super.inputFormatters,
    super.enabled,
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
        onPickTap = ((BuildContext context, List<T>? value) =>
            showMultiPickerBottomSheet<T, T>(
              context,
              sources: readOnly == true
                  ? source
                  : <T>{...source, ...?value}.toList(),
              labelMapper: labelMapper,
              initialValue: value,
              enabledMapper: enabledMapper,
              maxCount: maxCount,
              minCount: minCount,
            )),
        displayTextMapper = labelMapper,
        super(
          initialValue:
              initData<T, V>(source, initialData, initialValue, valueMapper),
        );

  ///自定义选择框
  const TxMultiPickerField.custom({
    required this.onPickTap,
    this.displayTextMapper,
    this.splitCharacter = '、',
    super.key,
    super.controller,
    super.initialValue,
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
    super.onChanged,
    super.onEditingComplete,
    super.onSubmitted,
    super.onAppPrivateCommand,
    super.inputFormatters,
    super.enabled,
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
          displayTextMapper != null || T is String,
          '当 displayTextMapper 为 null 时，T 必须为 String 类型',
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

  /// 选择点击回调
  final MultiPickVoidCallback<T>? onPickTap;

  /// 选择框展示的文字生成器
  final ValueMapper<T, String?>? displayTextMapper;

  /// 选项显示拆分字符
  final String splitCharacter;

  @override
  TxCommonTextFieldState<List<T>> createState() =>
      _TxMultiPickerFieldState<T, V>();
}

class _TxMultiPickerFieldState<T, V> extends TxCommonTextFieldState<List<T>> {
  @override
  void onChangedHandler(String? value) {
    if (widget.readOnly != true) {
      final List<String>? data = controller?.text.split(widget.splitCharacter);
      if (data != this.value) {
        didChange(data as List<T>?);
      }
    }
  }

  @override
  void onTapHandler() async {
    final res = await widget.onPickTap!(context, value);
    if (res != null && res != value) {
      if (displayText != controller?.text) {
        controller?.text = displayText ?? '';
      }
      didChange(res);
    }
    super.onTapHandler();
  }

  @override
  void didUpdateWidget(covariant TxMultiPickerField<T, V> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.splitCharacter != oldWidget.splitCharacter) {
      controller?.text = displayText ?? '';
    }
  }

  @override
  TxMultiPickerField<T, V> get widget =>
      super.widget as TxMultiPickerField<T, V>;

  @override
  String? get defaultHintText => widget.readOnly == true
      ? TxLocalizations.of(context).pickerFormFieldHint
      : TxLocalizations.of(context)
          .multiPickerFormFieldHint(widget.splitCharacter);

  @override
  String? get displayText {
    if (value == null) {
      return null;
    }
    if (widget.displayTextMapper == null) {
      return (value as List<String>).join(widget.splitCharacter);
    }
    return value!
        .map((e) => widget.displayTextMapper!(e))
        .join(widget.splitCharacter);
  }
}

/// [field] 为多项选择框的 [TxFieldTile]
class TxMultiPickerFieldTile<T, V> extends TxCommonTextFieldTile<List<T>> {
  TxMultiPickerFieldTile({
    required List<T> source,
    required ValueMapper<T, String?> labelMapper,
    ValueMapper<T, V?>? valueMapper,
    IndexedValueMapper<T, bool>? enabledMapper,
    List<T>? initialData,
    List<V>? initialValue,
    int? minCount,
    int? maxCount,
    String splitCharacter = '、',
    super.key,
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
    super.enabled,
    super.minLeadingWidth,
    super.minLabelWidth,
    super.minVerticalPadding,
    super.dense,
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
    super.onChanged,
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
          field: TxMultiPickerField<T, V>(
            source: source,
            labelMapper: labelMapper,
            valueMapper: valueMapper,
            enabledMapper: enabledMapper,
            initialData: initialData,
            initialValue: initialValue,
            minCount: minCount,
            maxCount: maxCount,
            splitCharacter: splitCharacter,
            controller: controller,
            focusNode: focusNode,
            undoController: undoController,
            decoration: decoration,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            textCapitalization: textCapitalization,
            style: style,
            strutStyle: strutStyle,
            textAlign: textAlign,
            textAlignVertical: textAlignVertical,
            textDirection: textDirection,
            readOnly: readOnly,
            showCursor: showCursor,
            autofocus: autofocus,
            statesController: statesController,
            obscuringCharacter: obscuringCharacter,
            obscureText: obscureText,
            autocorrect: autocorrect,
            smartDashesType: smartDashesType,
            smartQuotesType: smartQuotesType,
            enableSuggestions: enableSuggestions,
            maxLines: maxLines,
            minLines: minLines,
            expands: expands,
            maxLength: maxLength,
            maxLengthEnforcement: maxLengthEnforcement,
            onChanged: onChanged,
            onEditingComplete: onEditingComplete,
            onSubmitted: onSubmitted,
            onAppPrivateCommand: onAppPrivateCommand,
            inputFormatters: inputFormatters,
            enabled: enabled,
            cursorWidth: cursorWidth,
            cursorHeight: cursorHeight,
            cursorRadius: cursorRadius,
            cursorOpacityAnimates: cursorOpacityAnimates,
            cursorColor: cursorColor,
            cursorErrorColor: cursorErrorColor,
            selectionHeightStyle: selectionHeightStyle,
            selectionWidthStyle: selectionWidthStyle,
            keyboardAppearance: keyboardAppearance,
            scrollPadding: scrollPadding,
            dragStartBehavior: dragStartBehavior,
            enableInteractiveSelection: enableInteractiveSelection,
            selectionControls: selectionControls,
            onTapAlwaysCalled: onTapAlwaysCalled,
            onTapOutside: onTapOutside,
            mouseCursor: mouseCursor,
            buildCounter: buildCounter,
            scrollController: scrollController,
            scrollPhysics: scrollPhysics,
            autofillHints: autofillHints,
            contentInsertionConfiguration: contentInsertionConfiguration,
            clipBehavior: clipBehavior,
            restorationId: restorationId,
            scribbleEnabled: scribbleEnabled,
            enableIMEPersonalizedLearning: enableIMEPersonalizedLearning,
            contextMenuBuilder: contextMenuBuilder,
            canRequestFocus: canRequestFocus,
            spellCheckConfiguration: spellCheckConfiguration,
            magnifierConfiguration: magnifierConfiguration,
          ),
        );

  TxMultiPickerFieldTile.custom({
    required MultiPickVoidCallback<T>? onPickTap,
    required String? Function(T data)? displayTextMapper,
    String splitCharacter = '、',
    super.key,
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
    super.enabled,
    super.minLeadingWidth,
    super.minLabelWidth,
    super.minVerticalPadding,
    super.dense,
    super.controller,
    super.initialValue,
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
    super.onChanged,
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
          field: TxMultiPickerField<T, V>.custom(
            onPickTap: onPickTap,
            displayTextMapper: displayTextMapper,
            splitCharacter: splitCharacter,
            initialValue: initialValue,
            controller: controller,
            focusNode: focusNode,
            undoController: undoController,
            decoration: decoration,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            textCapitalization: textCapitalization,
            style: style,
            strutStyle: strutStyle,
            textAlign: textAlign,
            textAlignVertical: textAlignVertical,
            textDirection: textDirection,
            readOnly: readOnly,
            showCursor: showCursor,
            autofocus: autofocus,
            statesController: statesController,
            obscuringCharacter: obscuringCharacter,
            obscureText: obscureText,
            autocorrect: autocorrect,
            smartDashesType: smartDashesType,
            smartQuotesType: smartQuotesType,
            enableSuggestions: enableSuggestions,
            maxLines: maxLines,
            minLines: minLines,
            expands: expands,
            maxLength: maxLength,
            maxLengthEnforcement: maxLengthEnforcement,
            onChanged: onChanged,
            onEditingComplete: onEditingComplete,
            onSubmitted: onSubmitted,
            onAppPrivateCommand: onAppPrivateCommand,
            inputFormatters: inputFormatters,
            enabled: enabled,
            cursorWidth: cursorWidth,
            cursorHeight: cursorHeight,
            cursorRadius: cursorRadius,
            cursorOpacityAnimates: cursorOpacityAnimates,
            cursorColor: cursorColor,
            cursorErrorColor: cursorErrorColor,
            selectionHeightStyle: selectionHeightStyle,
            selectionWidthStyle: selectionWidthStyle,
            keyboardAppearance: keyboardAppearance,
            scrollPadding: scrollPadding,
            dragStartBehavior: dragStartBehavior,
            enableInteractiveSelection: enableInteractiveSelection,
            selectionControls: selectionControls,
            onTapAlwaysCalled: onTapAlwaysCalled,
            onTapOutside: onTapOutside,
            mouseCursor: mouseCursor,
            buildCounter: buildCounter,
            scrollController: scrollController,
            scrollPhysics: scrollPhysics,
            autofillHints: autofillHints,
            contentInsertionConfiguration: contentInsertionConfiguration,
            clipBehavior: clipBehavior,
            restorationId: restorationId,
            scribbleEnabled: scribbleEnabled,
            enableIMEPersonalizedLearning: enableIMEPersonalizedLearning,
            contextMenuBuilder: contextMenuBuilder,
            canRequestFocus: canRequestFocus,
            spellCheckConfiguration: spellCheckConfiguration,
            magnifierConfiguration: magnifierConfiguration,
          ),
        );
}
