import 'package:flutter/material.dart';

import '../localizations.dart';
import '../utils/basic_types.dart';
import 'common_text_field.dart';

/// 数字输入框
class TxNumberField<T extends num> extends TxCommonTextField<T> {
  const TxNumberField({
    this.maxValue,
    this.minValue,
    bool? autodecrement,
    this.autodecrementDifference,
    this.format,
    super.key,
    super.controller,
    super.initialValue,
    super.focusNode,
    super.undoController,
    super.decoration,
    super.textInputAction,
    super.textCapitalization,
    super.style,
    super.strutStyle,
    TextAlign? textAlign,
    super.textAlignVertical,
    super.textDirection,
    super.readOnly,
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
    super.restorationId,
    super.scribbleEnabled,
    super.enableIMEPersonalizedLearning,
    super.contextMenuBuilder,
    super.canRequestFocus,
    super.spellCheckConfiguration,
    super.magnifierConfiguration,
  })  : autodecrement = autodecrement ?? false,
        super(
          keyboardType: TextInputType.number,
          textAlign: autodecrement == true ? TextAlign.center : null,
        );

  /// 可输入的最大值
  final T? maxValue;

  /// 可输入的最小值
  final T? minValue;

  /// 是否允许自增自减
  ///
  /// 值为 true 时，输入框前后会显示加减按钮
  ///
  /// 默认值为 false
  final bool autodecrement;

  /// 每一次自增自减的差值
  final T? autodecrementDifference;

  /// 将输入值格式化为 T 类型值的方法
  final ValueMapper<String, T>? format;

  @override
  TxCommonTextFieldState<T> createState() => _TxNumberFieldState<T>();
}

class _TxNumberFieldState<T extends num> extends TxCommonTextFieldState<T> {
  ValueMapper<String, T?> get _format =>
      widget.format ??
      (T == int
          ? (val) => int.tryParse(val, radix: 10)
          : T == double
              ? double.tryParse
              : num.tryParse) as ValueMapper<String, T?>;

  @override
  TxNumberField<T> get widget => super.widget as TxNumberField<T>;

  @override
  InputDecoration get effectiveDecoration {
    if (widget.autodecrement == true) {
      void changeValue(T value) {
        controller?.text = value.toString();
        didChange(value);
      }

      final ButtonStyle style = IconButton.styleFrom(
        visualDensity: VisualDensity.compact,
        padding: EdgeInsets.zero,
      );

      final T effectiveValue = (value ?? 0) as T;
      final T diff = (widget.autodecrementDifference ?? 1) as T;

      final bool canAdd =
          widget.maxValue == null || effectiveValue < widget.maxValue!;
      final Widget suffixIcon = IconButton(
        onPressed:
            canAdd ? () => changeValue((effectiveValue + diff) as T) : null,
        icon: const Icon(Icons.add),
        style: style,
      );

      final bool canRemove =
          widget.minValue == null || effectiveValue > widget.minValue!;
      final Widget prefixIcon = IconButton(
        onPressed:
            canRemove ? () => changeValue((effectiveValue + diff) as T) : null,
        icon: const Icon(Icons.remove),
        style: style,
      );

      return super.effectiveDecoration.copyWith(
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
          );
    }

    return super.effectiveDecoration;
  }

  @override
  void onChangedHandler(String? value) =>
      didChange(value == null || value.isEmpty ? null : _format(value));

  @override
  String? get defaultHintText => TxLocalizations.of(context).textFormFieldHint;

  @override
  String? get displayText => value?.toString();
}

/// [field] 为文本输入框的 [TxCommonTextFieldTile]
class TxNumberFieldTile<T extends num> extends TxCommonTextFieldTile<T> {
  TxNumberFieldTile({
    T? maxValue,
    T? minValue,
    bool? autodecrement,
    T? autodecrementDifference,
    ValueMapper<String, T>? format,
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
    super.onTap,
    super.minLeadingWidth,
    super.minLabelWidth,
    super.minVerticalPadding,
    super.dense,
    super.controller,
    super.initialValue,
    super.focusNode,
    super.undoController,
    super.decoration,
    super.textInputAction,
    super.textCapitalization,
    super.style,
    super.strutStyle,
    super.textAlign,
    super.textAlignVertical,
    super.textDirection,
    super.readOnly,
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
          field: TxNumberField<T>(
            minValue: minValue,
            maxValue: maxValue,
            autodecrement: autodecrement,
            autodecrementDifference: autodecrementDifference,
            format: format,
            initialValue: initialValue,
            controller: controller,
            focusNode: focusNode,
            undoController: undoController,
            decoration: decoration,
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
            onTap: onTap,
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
