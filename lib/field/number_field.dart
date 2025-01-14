import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'common_text_field.dart';

Widget _suffixIcon(
  num? value,
  num? step,
  num? max,
  TextEditingController? controller,
  ValueChanged<num?> didChange,
) {
  void changeValue(num value) {
    controller?.text = value.toString();
    didChange(value);
  }

  final num effectiveValue = value ?? 0;
  final num diff = step ?? 1;

  final bool canAdd = max == null || effectiveValue < max;
  final Widget suffixIcon = IconButton(
    onPressed: canAdd ? () => changeValue(effectiveValue + diff) : null,
    icon: const Icon(Icons.add),
  );

  return suffixIcon;
}

Widget _prefixIcon(
  num? value,
  num? step,
  num? min,
  TextEditingController? controller,
  ValueChanged<num?> didChange,
) {
  void changeValue(num value) {
    controller?.text = value.toString();
    didChange(value);
  }

  final num effectiveValue = value ?? 0;
  final num diff = step ?? 1;

  final bool canRemove = min == null || effectiveValue > min;
  final Widget prefixIcon = IconButton(
    onPressed: canRemove ? () => changeValue(effectiveValue + diff) : null,
    icon: const Icon(Icons.remove),
  );

  return prefixIcon;
}

InputDecoration _decoration(
    InputDecoration decoration, num? min, num? max, int? precision) {
  String? helperText = decoration.helperText;
  if (min != null || max != null) {
    final String text = (max != null && min != null)
        ? '输入值应大于等于$min且小于等于$max'
        : max != null
            ? '输入值应小于等于$max'
            : '输入值应大于等于$min';
    helperText = '${helperText == null ? '' : '$helperText，'}$text';
  }
  if (precision != null) {
    helperText = '${helperText == null ? '' : '$helperText，'}结果保留'
        '${precision == 0 ? '整数' : '$precision位小数'}';
  }
  return decoration.copyWith(helperText: helperText);
}

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
    String? hintText,
    this.maxValue,
    this.minValue,
    bool? stepped,
    this.step,
    this.precision,
    bool? stepStrictly,
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
    super.onTap,
    super.minLeadingWidth,
    super.minLabelWidth,
    super.minVerticalPadding,
    super.dense,
    super.colon,
    super.focusColor,
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
  })  : assert(step == null || step > 0),
        stepped = stepped ?? false,
        stepStrictly = stepStrictly ?? false,
        super(
          hintText: hintText ?? '请输入',
          clearable: clearable ?? false,
          displayTextMapper: (context, val) => val.toString(),
          keyboardType: TextInputType.number,
          textAlign: textAlign ?? (stepped == true ? TextAlign.center : null),
          onInputChanged: (field, val) {
            final num? number = num.tryParse(val);
            if (number != field.value) {
              (field as TxCommonTextFieldState).setValue(number);
            }
          },
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

  /// 精度
  final int? precision;

  /// 是否严格步进
  ///
  /// 值为 true，输入值必须为 [step] 的整数倍。
  final bool stepStrictly;

  @override
  TxCommonTextFieldState<num> createState() => _TxNumberFieldState();
}

class _TxNumberFieldState extends TxCommonTextFieldState<num> {
  FocusNode? _focusNode;

  @override
  FocusNode? get focusNode => widget.focusNode ?? _focusNode;

  void _formatText() {
    if (!focusNode!.hasFocus) {
      final step = widget.step ?? 1;
      if (value != null && value! % step != 0) {
        num number = (value! ~/ step) * step;
        if (widget.minValue != null && number < widget.minValue!) {
          number += step;
        }
        didChange(number);
      }
    }
  }

  @override
  void initState() {
    if (widget.stepped && widget.stepStrictly == true) {
      if (widget.focusNode == null) {
        _focusNode = FocusNode();
      }
      focusNode!.addListener(_formatText);
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant TxNumberField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode != oldWidget.focusNode ||
        widget.stepped != oldWidget.stepped ||
        widget.stepStrictly != oldWidget.stepStrictly) {
      (oldWidget.focusNode ?? _focusNode)?.removeListener(_formatText);
      if (widget.stepped && widget.stepStrictly) {
        if (widget.focusNode == null) {
          _focusNode = FocusNode();
        }
        (widget.focusNode ?? _focusNode)!.addListener(_formatText);
      }
    }
  }

  @override
  void dispose() {
    focusNode?.removeListener(_formatText);
    if (_focusNode != null) {
      _focusNode!.unfocus();
      _focusNode!.dispose();
    }
    super.dispose();
  }

  @override
  InputDecoration get effectiveDecoration => _decoration(
        super.effectiveDecoration,
        widget.minValue,
        widget.maxValue,
        widget.precision,
      );

  @override
  TxNumberField get widget => super.widget as TxNumberField;

  @override
  List<Widget>? get suffixIcons {
    final List<Widget> result = [...?super.suffixIcons];
    if (widget.stepped == true) {
      result.add(_suffixIcon(
        value,
        widget.step,
        widget.maxValue,
        controller,
        didChange,
      ));
    }
    return result;
  }

  @override
  List<Widget>? get prefixIcons {
    final List<Widget> result = [...?super.prefixIcons];
    if (widget.stepped == true) {
      result.add(_prefixIcon(
        value,
        widget.step,
        widget.minValue,
        controller,
        didChange,
      ));
    }
    return result;
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
          precision == null || precision >= 0,
          'precision 精度必须为非负整数',
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

    String text = newValue.text;
    final num? value = num.tryParse(text);
    if (value == null) {
      return const TextEditingValue();
    }

    if (min != null && value < min!) {
      return oldValue;
    }

    if (max != null && value > max!) {
      return oldValue;
    }

    if (stepStrictly && value % step != 0) {
      text = ((value ~/ step) * step).toString();
    }

    if (precision != null && text.contains('.')) {
      final list = text.split('.');
      final int decimalLength = list.last.length;
      final int integerLength = list.first.length;
      if (decimalLength > precision!) {
        text = text.substring(0, integerLength + 1 + precision!);
      }
    }

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
