import 'package:flutter/material.dart';

import '../utils/basic_types.dart';
import '../widgets/dropdown.dart';
import 'form_item_container.dart';

/// 下拉选择Form组件
class DropdownFormField<T, V> extends StatelessWidget {
  const DropdownFormField({
    required this.sources,
    required this.labelMapper,
    this.valueMapper,
    this.decoration,

    /// Form参数
    super.key,
    this.initialValue,
    this.initialData,
    this.onSaved,
    this.validator,
    this.enabled,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.onChanged,

    /// FormItemContainer参数
    this.labelText,
    this.label,
    this.required = false,
    this.backgroundColor,
    this.labelStyle,
    this.starStyle,
    this.direction,
    this.padding,
    this.horizontalGap,
    this.minLabelWidth,
  });

  final List<T> sources;
  final ValueMapper<T, String> labelMapper;
  final InputDecoration? decoration;
  final V? initialValue;
  final T? initialData;
  final ValueChanged<V?>? onSaved;
  final FormFieldValidator<V>? validator;
  final bool? enabled;
  final AutovalidateMode autovalidateMode;
  final ValueMapper<T, V>? valueMapper;
  final ValueChanged<V?>? onChanged;
  final String? labelText;
  final Widget? label;
  final bool required;
  final Color? backgroundColor;
  final Axis? direction;
  final EdgeInsetsGeometry? padding;
  final TextStyle? labelStyle;
  final TextStyle? starStyle;
  final double? horizontalGap;
  final double? minLabelWidth;

  @override
  Widget build(BuildContext context) {
    final InputDecoration decoration = FormItemContainer.createDecoration(
      context,
      this.decoration ?? const InputDecoration(),
      hintText: '请选择',
    );

    return FormItemContainer(
      labelText: labelText,
      label: label,
      required: required,
      backgroundColor: backgroundColor,
      labelStyle: labelStyle,
      starStyle: starStyle,
      horizontalGap: horizontalGap,
      minLabelWidth: minLabelWidth,
      direction: direction,
      padding: padding,
      formField: TxDropdownButtonFormField<V>(
        items: sources
            .map((e) => TxDropdownMenuItem<V>(
                  value: valueMapper?.call(e) ?? e as V,
                  child: Text(labelMapper(e)),
                ))
            .toList(),
        value: initialValue,
        onChanged: onChanged,
        autovalidateMode: autovalidateMode,
        enableFeedback: enabled,
        onSaved: onSaved,
        decoration: decoration,
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        padding: EdgeInsets.zero,
        validator: validator ??
            (required
                ? (V? value) {
                    return value == null ? '请选择${labelText ?? ''}' : null;
                  }
                : null),
      ),
    );
  }
}
