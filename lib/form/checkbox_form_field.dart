import 'package:flutter/material.dart';

import 'form_field.dart';

/// Checkbox多选Form组件
class CheckboxFormField<T, V> extends TxMultiPickerFormFieldItem<T, V> {
  CheckboxFormField({
    required super.labelMapper,
    required super.sources,
    super.initialData,
    super.valueMapper,
    super.enabledMapper,
    super.inputEnabledMapper,
    super.dataMapper,
    super.minPickNumber,
    super.maxPickNumber,
    super.onChanged,
    super.key,
    super.onSaved,
    super.validator,
    super.initialValue,
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    super.required,
    super.label,
    super.labelText,
    super.backgroundColor,
    super.direction,
    super.padding,
    List<Widget>? actions,
    super.labelStyle,
    super.starStyle,
    super.horizontalGap,
    super.minLabelWidth,
  }) : super(
          builder: (field) {
            void onChangedHandler(bool? value, T data) {
              Set<T>? list = field.value;
              if (value == true) {
                (list ??= <T>{}).add(data);
              } else {
                list!.remove(data);
              }
              field.didChange(list);
              if (onChanged != null) {
                onChanged(list);
              }
            }

            final List<Widget> children = sources?.map((e) {
                  final bool value = field.value?.contains(e) == true;
                  return CheckboxListTile(
                    title: Text(labelMapper(e)),
                    enabled: enabledMapper?.call(e),
                    value: value,
                    onChanged: (value) => onChangedHandler(value, e),
                  );
                }).toList() ??
                [];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: children,
            );
          },
          actionsBuilder: (field) => actions,
        );
}
