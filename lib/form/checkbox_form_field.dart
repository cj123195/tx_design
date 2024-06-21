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

            final List<Widget> children = sources == null
                ? []
                : List.generate(
                    sources.length,
                    (index) => _CheckboxItem(
                      key:
                          ValueKey('CheckboxFormItem-$index-${sources[index]}'),
                      label: labelMapper(sources[index]),
                      value: field.value?.contains(sources[index]) == true,
                      enabled: enabledMapper?.call(sources[index]),
                      onChanged: (value) =>
                          onChangedHandler(value, sources[index]),
                    ),
                  );

            return Wrap(children: children);
          },
          actionsBuilder: (field) => actions,
        );
}

class _CheckboxItem<T> extends StatelessWidget {
  const _CheckboxItem({
    required this.label,
    required this.value,
    required this.enabled,
    required this.onChanged,
    super.key,
  });

  final String label;
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final bool? enabled;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(4.0),
      onTap: onChanged != null ? () => onChanged!(!value) : null,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 4.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label),
            Checkbox(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
              value: value,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}
