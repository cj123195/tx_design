import 'package:flutter/material.dart';

import '../extensions/iterable_extension.dart';
import '../utils/basic_types.dart';
import 'form_item_container.dart';

/// Radio单选Form 组件
class RadioFormField<T, V> extends FormField<T> {
  RadioFormField({
    required List<T> sources, // 数据源
    required ValueMapper<T, String> labelMapper, // 选项多对应的描述文字
    ValueMapper<T, V>? enableMapper, // 选项是否可选
    ValueMapper<T, V>? valueMapper, // 选项对应的值
    ValueChanged<T?>? onChanged,

    /// FormItemContainer参数
    Widget? label,
    String? labelText,
    EdgeInsetsGeometry? padding,
    Color? backgroundColor,
    TextStyle? labelStyle,
    TextStyle? starStyle,
    double? horizontalGap,
    double? minLabelWidth,
    Axis? direction,

    /// Form参数
    super.key,
    V? initialValue,
    T? initialData,
    super.onSaved,
    FormFieldValidator<T>? validator,
    super.restorationId,
    super.enabled,
    super.autovalidateMode = AutovalidateMode.disabled,
    bool required = false,
    InputDecoration decoration = const InputDecoration(),
  }) : super(
          initialValue: initialData ??
              sources
                  .tryFind((e) => (valueMapper?.call(e) ?? e) == initialValue),
          validator: validator ??
              (required
                  ? (T? value) {
                      return value == null ? '${labelText ?? ''}不能为空' : null;
                    }
                  : null),
          builder: (FormFieldState<T> field) {
            void onChangedHandler(T? value) {
              field.didChange(value);
              if (onChanged != null) {
                onChanged(value);
              }
            }

            final InputDecoration effectiveDecoration =
                FormItemContainer.createDecoration(
              field.context,
              decoration,
              hintText: '请选择',
              errorText: field.errorText,
            );

            final List<RadioListTile> children = sources
                .map(
                  (e) => RadioListTile<T?>(
                    title: Text(labelMapper(e)),
                    value: e,
                    groupValue: field.value,
                    onChanged: enableMapper?.call(e) != false
                        ? onChangedHandler
                        : null,
                  ),
                )
                .toList();

            return UnmanagedRestorationScope(
              bucket: field.bucket,
              child: FormItemContainer(
                label: label,
                labelText: labelText,
                required: required,
                direction: direction,
                backgroundColor: backgroundColor,
                labelStyle: labelStyle,
                starStyle: starStyle,
                horizontalGap: horizontalGap,
                minLabelWidth: minLabelWidth,
                padding: padding,
                formField: InputDecorator(
                  decoration: effectiveDecoration,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: children,
                  ),
                ),
              ),
            );
          },
        );

  @override
  FormFieldState<T> createState() => _RadioFormFieldState<T, V>();
}

class _RadioFormFieldState<T, V> extends FormFieldState<T> {
  @override
  RadioFormField<T, V> get widget => super.widget as RadioFormField<T, V>;

  @override
  void didUpdateWidget(covariant RadioFormField<T, V> oldWidget) {
    if (widget.initialValue != value) {
      setValue(widget.initialValue);
    }
    super.didUpdateWidget(oldWidget);
  }
}
