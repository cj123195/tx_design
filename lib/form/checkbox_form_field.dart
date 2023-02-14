import 'package:flutter/material.dart';

import '../utils/basic_types.dart';
import 'form_item_container.dart';

/// CheckBox多选表单组件
class CheckboxFormField<T, V> extends FormField<List<T>> {
  CheckboxFormField({
    required List<T> sources, // 数据源
    required ValueMapper<T, String> labelMapper, // 选项多对应的描述文字
    ValueMapper<T, bool>? enabledMapper, // 选项是否可选
    ValueMapper<T, V>? valueMapper, // 选项对应的值，主要用于比较
    /// FormItemContainer参数
    Widget? label,
    String? labelText,
    EdgeInsetsGeometry? labelPadding,
    Color? background,
    Axis? direction,

    /// Form参数
    List<V>? initialValue,
    List<T>? initialData,
    FormFieldValidator<List<T>>? validator,
    int? minimumNumber, // 最少选择个数
    int? maximumNumber, // 最多选择个数
    super.key,
    super.onSaved,
    super.restorationId,
    bool? enabled,
    super.autovalidateMode = AutovalidateMode.disabled,
    ValueChanged<List<T>?>? onChanged,
    InputDecoration decoration = const InputDecoration(),
  })  : assert(minimumNumber == null || minimumNumber > 0),
        super(
          initialValue: initialData ??
              (initialValue == null
                  ? null
                  : sources
                      .where((T e) => initialValue.contains(
                          valueMapper?.call(e) ?? labelMapper.call(e)))
                      .toList()),
          validator: validator ??
              (List<T>? value) {
                final int length = value?.length ?? 0;
                if (minimumNumber != null && length < minimumNumber) {
                  return '请至少选择$minimumNumber项';
                } else if (maximumNumber != null && length > maximumNumber) {
                  return '最多可选择$maximumNumber项';
                }
                return null;
              },
          builder: (FormFieldState<List<T>> field) {
            void onChangedHandler(List<T>? value) {
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

            final List<CheckboxListTile> children = sources.map((e) {
              final bool value = initialValue?.contains(e) == true;
              final bool enable = enabledMapper?.call(e) ??
                  (value ||
                      maximumNumber == null ||
                      initialValue == null ||
                      initialValue.length < maximumNumber);

              return CheckboxListTile(
                title: Text(labelMapper(e)),
                value: value,
                onChanged: enable
                    ? (val) {
                        List<T>? list = field.value;
                        if (val == true) {
                          (list ??= <T>[]).add(e);
                        } else {
                          list!.remove(e);
                        }
                        onChangedHandler(list);
                      }
                    : null,
              );
            }).toList();

            return UnmanagedRestorationScope(
              bucket: field.bucket,
              child: FormItemContainer(
                label: label,
                labelText: labelText,
                required: minimumNumber != null && minimumNumber > 0,
                direction: direction ?? Axis.vertical,
                background: background,
                padding: labelPadding,
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
  FormFieldState<List<T>> createState() => _CheckboxFormFieldState<T, V>();
}

class _CheckboxFormFieldState<T, V> extends FormFieldState<List<T>> {
  @override
  CheckboxFormField<T, V> get widget => super.widget as CheckboxFormField<T, V>;

  @override
  void didUpdateWidget(covariant CheckboxFormField<T, V> oldWidget) {
    if (widget.initialValue != value) {
      setValue(widget.initialValue);
    }
    super.didUpdateWidget(oldWidget);
  }
}
