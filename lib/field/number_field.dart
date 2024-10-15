import 'package:flutter/material.dart';

import '../utils/basic_types.dart';
import 'common_text_field.dart';

/// 数字输入框
class TxNumberField<T extends num> extends TxCommonTextField<T> {
  TxNumberField({
    super.key,
    super.initialValue,
    super.focusNode,
    super.decoration,
    super.onChanged,
    super.enabled,
    super.hintText = '请输入',
    this.maxValue,
    this.minValue,
    bool? autodecrement,
    this.autodecrementDifference,
    ValueMapper<String, T>? format,
    super.controller,
    super.undoController,
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
          displayTextMapper: (context, val) => val.toString(),
          keyboardType: TextInputType.number,
          textAlign:
              textAlign ?? (autodecrement == true ? TextAlign.center : null),
          onInputChanged: (field, val) => field.didChange(val.isEmpty
              ? null
              : format == null
                  ? _format(val)
                  : format(val)),
        );

  static T? _format<T extends num>(String val) => T == int
      ? int.tryParse(val, radix: 10) as T
      : T == double
          ? double.tryParse(val) as T
          : num.tryParse(val) as T;

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

  @override
  TxCommonTextFieldState<T> createState() => _TxNumberFieldState<T>();
}

class _TxNumberFieldState<T extends num> extends TxCommonTextFieldState<T> {
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
}

/// field 为文本输入框的 [TxCommonTextFieldTile]
class TxNumberFieldTile<T extends num> extends TxCommonTextFieldTile<T> {
  TxNumberFieldTile({
    super.key,
    super.initialValue,
    super.focusNode,
    super.decoration,
    super.onChanged,
    super.enabled,
    super.hintText = '请输入',
    this.maxValue,
    this.minValue,
    bool? autodecrement,
    this.autodecrementDifference,
    ValueMapper<String, T>? format,
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
    super.onTap,
    super.minLeadingWidth,
    super.minLabelWidth,
    super.minVerticalPadding,
    super.dense,
    super.controller,
    super.undoController,
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
  })  : autodecrement = autodecrement ?? false,
        super(
          displayTextMapper: (context, val) => val.toString(),
          keyboardType: TextInputType.number,
          textAlign:
              textAlign ?? (autodecrement == true ? TextAlign.center : null),
          onInputChanged: (field, val) => field.didChange(val.isEmpty
              ? null
              : format == null
                  ? _format(val)
                  : format(val)),
        );

  static T? _format<T extends num>(String val) => T == int
      ? int.tryParse(val, radix: 10) as T
      : T == double
          ? double.tryParse(val) as T
          : num.tryParse(val) as T;

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

  @override
  TxCommonTextFieldTileState<T> createState() => _TxNumberFieldTileState<T>();
}

class _TxNumberFieldTileState<T extends num>
    extends TxCommonTextFieldTileState<T> {
  @override
  TxNumberFieldTile<T> get widget => super.widget as TxNumberFieldTile<T>;

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
}
