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

            final List<Widget> children = sources == null
                ? []
                : List.generate(
                    sources.length,
                    (index) => _RadioItem<T?>(
                      key: ValueKey('RadioFormItem-$index-${sources[index]}'),
                      label: labelMapper(sources[index]),
                      value: sources[index],
                      groupValue: field.value,
                      onChanged: enableMapper?.call(sources[index]) != false
                          ? onChangedHandler
                          : null,
                    ),
                  );

            return Wrap(children: children);
          },
          actionsBuilder: (field) => actions,
          decoration: const InputDecoration(contentPadding: EdgeInsets.zero),
        );
}

class _RadioItem<T> extends StatelessWidget {
  const _RadioItem({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    super.key,
  });

  final String label;
  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;

  @override
  Widget build(BuildContext context) {
    final bool checked = value == groupValue;

    return InkWell(
      borderRadius: BorderRadius.circular(4.0),
      onTap: onChanged != null
          ? () {
              if (checked) {
                onChanged!(null);
              } else {
                onChanged!(value);
              }
            }
          : null,
      child: Padding(
        padding: const EdgeInsets.only(left: 4.0, right: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Radio<T>(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,
            ),
            Text(label),
          ],
        ),
      ),
    );
  }
}
