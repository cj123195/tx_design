import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'common_text_form_field.dart';

// InputDecoration _decoration(
//     InputDecoration decoration, num? min, num? max, int? precision) {
//   String? helperText = decoration.helperText;
//   if (helperText != null) {
//     return decoration;
//   }
//
//   if (min != null || max != null) {
//     helperText = (max != null && min != null)
//         ? '输入值应大于等于$min且小于等于$max'
//         : max != null
//             ? '输入值应小于等于$max'
//             : '输入值应大于等于$min';
//   }
//   if (precision != null) {
//     helperText = '${helperText == null ? '' : '$helperText，'}结果保留'
//         '${precision == 0 ? '整数' : '$precision位小数'}';
//   }
//   return decoration.copyWith(helperText: helperText);
// }

/// 数字输入框表单
class TxNumberFormField extends TxCommonTextFormField<num> {
  TxNumberFormField({
    bool? clearable,
    super.key,
    super.onSaved,
    FormFieldValidator<num>? validator,
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    super.decoration,
    super.onChanged,
    super.required,
    super.initialValue,
    super.bordered,
    String? hintText,
    this.maxValue,
    this.minValue,
    bool? stepped,
    this.step,
    this.precision,
    bool? stepStrictly,
    super.controller,
    super.readOnly,
    super.onTap,
    EditConfig? editConfig,
    super.label,
    super.labelText,
    super.actionsBuilder,
    super.trailingBuilder,
    super.leading,
    super.focusNode,
    super.tileTheme,
  })  : stepped = stepped ?? false,
        stepStrictly = stepStrictly ?? false,
        super(
          hintText: hintText ?? '请输入',
          clearable: clearable ?? false,
          displayTextMapper: (context, val) => val.toString(),
          valueMapper: num.tryParse,
          validator: (value) {
            if (required == true && value == null) {
              return '请输入';
            }

            if (validator != null) {
              final String? errorText = validator(value);
              if (errorText != null) {
                return errorText;
              }
            }

            /// 如果最小值不为空，判断输入值是否小于最小值
            if (minValue != null && value != null && value < minValue) {
              return '输入值需大于或等于$minValue';
            }

            /// 如果最小数量不为空，判断已选数量是否小于最小数量
            if (maxValue != null && value != null && value > maxValue) {
              return '输入值需小于或等于$maxValue';
            }

            return null;
          },
          editConfig: (editConfig ?? const EditConfig()).copyWith(
            keyboardType: TextInputType.number,
            textAlign: editConfig?.textAlign ??
                (stepped == true ? TextAlign.center : null),
            inputFormatters: [
              ...?editConfig?.inputFormatters,
              NumberInputFormatter(
                min: minValue,
                max: maxValue,
                precision: precision,
                step: step,
                stepStrictly: stepStrictly,
              ),
            ],
          ),
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
  TxCommonTextFormFieldState<num> createState() => _TxNumberFormFieldState();
}

class _TxNumberFormFieldState extends TxCommonTextFormFieldState<num> {
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
  void didUpdateWidget(covariant TxNumberFormField oldWidget) {
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

  // @override
  // InputDecoration get effectiveDecoration => _decoration(
  //       super.effectiveDecoration,
  //       widget.minValue,
  //       widget.maxValue,
  //       widget.precision,
  //     );

  @override
  TxNumberFormField get widget => super.widget as TxNumberFormField;

  @override
  List<Widget>? get suffixIcons {
    final List<Widget> result = [...?super.suffixIcons];
    if (widget.stepped == true) {
      void changeValue(num value) {
        controller?.text = value.toString();
        didChange(value);
      }

      final num effectiveValue = value ?? 0;
      final num diff = widget.step ?? 1;

      final bool canAdd =
          widget.maxValue == null || effectiveValue < widget.maxValue!;
      final Widget suffixIcon = IconButton(
        onPressed: canAdd ? () => changeValue(effectiveValue + diff) : null,
        icon: const Icon(Icons.add),
      );

      result.add(suffixIcon);
    }
    return result;
  }

  @override
  Widget? get prefixIcon {
    if (!widget.stepped) {
      return null;
    }

    void changeValue(num value) {
      controller?.text = value.toString();
      didChange(value);
    }

    final num effectiveValue = value ?? 0;
    final num diff = widget.step ?? 1;

    final bool canRemove =
        widget.minValue == null || effectiveValue > widget.minValue!;
    return IconButton(
      onPressed: canRemove ? () => changeValue(effectiveValue - diff) : null,
      icon: const Icon(Icons.remove),
    );
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
