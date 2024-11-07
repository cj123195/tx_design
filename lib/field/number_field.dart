import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'common_text_field.dart';

/// 数字输入框
class TxNumberField extends TxCommonTextField<num> {
  TxNumberField({
    bool? clearable,
    super.key,
    super.initialValue,
    super.focusNode,
    super.decoration,
    super.onChanged,
    super.enabled,
    super.hintText = '请输入',
    this.maxValue,
    this.minValue,
    bool? stepped,
    this.step,
    int? precision,
    bool? stepStrictly,
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
    List<TextInputFormatter>? inputFormatters,
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
  })  : stepped = stepped ?? false,
        super(
          clearable: clearable ?? false,
          displayTextMapper: (context, val) => val.toString(),
          keyboardType: TextInputType.number,
          textAlign: textAlign ?? (stepped == true ? TextAlign.center : null),
          onInputChanged: (field, val) => field.didChange(num.tryParse(val)),
          inputFormatters: [
            ...?inputFormatters,
            NumberInputFormatter(
              min: minValue,
              max: maxValue,
              precision: precision,
              step: step,
              stepStrictly: stepStrictly,
            ),
          ],
        );

  /// 可输入的最大值
  final num? maxValue;

  /// 可输入的最小值
  final num? minValue;

  /// 是否允许步进
  ///
  /// 值为 true 时，输入框前后会显示加减按钮
  ///
  /// 默认值为 false
  final bool stepped;

  /// 步进值
  final num? step;

  @override
  TxCommonTextFieldState<num> createState() => _TxNumberFieldState();
}

class _TxNumberFieldState extends TxCommonTextFieldState<num> {
  @override
  TxNumberField get widget => super.widget as TxNumberField;

  @override
  InputDecoration get effectiveDecoration {
    if (widget.stepped == true) {
      void changeValue(num value) {
        controller?.text = value.toString();
        didChange(value);
      }

      final ButtonStyle style = IconButton.styleFrom(
        visualDensity: VisualDensity.compact,
        padding: EdgeInsets.zero,
      );

      final num effectiveValue = value ?? 0;
      final num diff = widget.step ?? 1;

      final bool canAdd =
          widget.maxValue == null || effectiveValue < widget.maxValue!;
      final Widget suffixIcon = IconButton(
        onPressed: canAdd ? () => changeValue(effectiveValue + diff) : null,
        icon: const Icon(Icons.add),
        style: style,
      );

      final bool canRemove =
          widget.minValue == null || effectiveValue > widget.minValue!;
      final Widget prefixIcon = IconButton(
        onPressed: canRemove ? () => changeValue(effectiveValue + diff) : null,
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
class TxNumberFieldTile extends TxCommonTextFieldTile<num> {
  TxNumberFieldTile({
    bool? clearable,
    super.key,
    super.initialValue,
    super.focusNode,
    super.decoration,
    super.onChanged,
    super.enabled,
    super.hintText = '请输入',
    this.maxValue,
    this.minValue,
    bool? stepped,
    this.step,
    int? precision,
    bool? stepStrictly,
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
    List<TextInputFormatter>? inputFormatters,
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
  })  : stepped = stepped ?? false,
        super(
          clearable: clearable ?? false,
          displayTextMapper: (context, val) => val.toString(),
          keyboardType: TextInputType.number,
          textAlign: textAlign ?? (stepped == true ? TextAlign.center : null),
          onInputChanged: (field, val) => field.didChange(num.tryParse(val)),
          inputFormatters: [
            ...?inputFormatters,
            NumberInputFormatter(
              min: minValue,
              max: maxValue,
              precision: precision,
              step: step,
              stepStrictly: stepStrictly,
            ),
          ],
        );

  /// 可输入的最大值
  final num? maxValue;

  /// 可输入的最小值
  final num? minValue;

  /// 是否允许步进
  ///
  /// 值为 true 时，输入框前后会显示加减按钮
  ///
  /// 默认值为 false
  final bool stepped;

  /// 步进值
  final num? step;

  @override
  TxCommonTextFieldTileState<num> createState() => _TxNumberFieldTileState();
}

class _TxNumberFieldTileState extends TxCommonTextFieldTileState<num> {
  @override
  TxNumberFieldTile get widget => super.widget as TxNumberFieldTile;

  @override
  InputDecoration get effectiveDecoration {
    if (widget.stepped == true) {
      void changeValue(num value) {
        controller?.text = value.toString();
        didChange(value);
      }

      final ButtonStyle style = IconButton.styleFrom(
        visualDensity: VisualDensity.compact,
        padding: EdgeInsets.zero,
      );

      final num effectiveValue = value ?? 0;
      final num diff = widget.step ?? 1;

      final bool canAdd =
          widget.maxValue == null || effectiveValue < widget.maxValue!;
      final Widget suffixIcon = IconButton(
        onPressed: canAdd ? () => changeValue(effectiveValue + diff) : null,
        icon: const Icon(Icons.add),
        style: style,
      );

      final bool canRemove =
          widget.minValue == null || effectiveValue > widget.minValue!;
      final Widget prefixIcon = IconButton(
        onPressed: canRemove ? () => changeValue(effectiveValue + diff) : null,
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

class NumberInputFormatter extends TextInputFormatter {
  NumberInputFormatter({
    this.min,
    this.max,
    num? step,
    this.precision,
    bool? stepStrictly,
  })  : step = step ?? 1,
        assert(
          precision == null || precision > 0,
          'precision 的值必须是一个非负整数',
        ),
        assert(
          min == null || max == null || min <= max,
          'min 必须小于或等于 max',
        ),
        stepStrictly = stepStrictly ?? false;

  /// 最小可输入值
  final num? min;

  /// 最大可输入值
  final num? max;

  /// 步进值
  ///
  /// 默认值为 1。
  final num step;

  /// 输入精度
  final int? precision;

  /// 是否严格步进
  ///
  /// 值为 true 且 [step] 不为 null 时则只能输入 [step] 的倍数。
  final bool stepStrictly;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    assert(
      min == null ||
          max == null ||
          !stepStrictly ||
          (min! % step == 0 && max! % step == 0),
      '当严格步进时，min 和 max 都应是 step 的整数倍',
    );
    assert(
      precision == null ||
          !step.toString().contains('.') ||
          precision! >= step.toString().split('.').length,
      '当 step 和 precision 均不为 null 时，precision 并且不能小于 step 的小数位数',
    );

    num? value = num.tryParse(newValue.text);
    if (value == null) {
      return const TextEditingValue();
    }

    if (min != null && value < min!) {
      value = min!;
    }

    if (max != null && value > max!) {
      value = max!;
    }

    if (stepStrictly && value % step != 0) {
      value = (value ~/ step) * step;
    }

    final String text = precision == null
        ? value.toString()
        : value.toStringAsFixed(precision!);
    return TextEditingValue(
      text: text,
      selection: newValue.selection.copyWith(
        baseOffset: math.min(newValue.selection.start, text.length),
        extentOffset: math.min(newValue.selection.end, text.length),
      ),
      composing: !newValue.composing.isCollapsed &&
              text.length > newValue.composing.start
          ? TextRange(
              start: newValue.composing.start,
              end: math.min(newValue.composing.end, text.length),
            )
          : TextRange.empty,
    );
  }
}
