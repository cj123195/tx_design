import 'package:flutter/material.dart';

import '../utils/basic_types.dart';
import 'form_field.dart';

/// Radio单选Form 组件
class RadioFormField<T, V> extends TxPickerFormFieldItem<T, V> {
  RadioFormField({
    required super.labelMapper,
    required super.sources,
    ValueMapper<T, V>? enableMapper, // 选项是否可选
    super.initialData,
    super.valueMapper,
    super.enabledMapper,
    super.inputEnabledMapper,
    super.dataMapper,
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
            void onChangedHandler(T? value) {
              field.didChange(value);
              if (onChanged != null) {
                onChanged(value);
              }
            }

            final List<Widget> children = sources?.map((e) {
                  return RadioListTile<T?>(
                    title: Text(labelMapper(e)),
                    value: e,
                    groupValue: field.value,
                    onChanged: enableMapper?.call(e) != false
                        ? onChangedHandler
                        : null,
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
