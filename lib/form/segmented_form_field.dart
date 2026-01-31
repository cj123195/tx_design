import 'package:flutter/material.dart';

import '../utils/basic_types.dart';
import 'form_field.dart';
import 'picker_form_field.dart';

/// Segmented 选择框表单
class TxSegmentedFormField<T, V> extends TxFormField<T> {
  TxSegmentedFormField({
    required List<T> source,
    required ValueMapper<T, String?> labelMapper,
    ValueMapper<T, V?>? valueMapper,
    ValueMapper<T, bool>? disabledWhen,
    IndexedDataWidgetBuilder<T>? iconBuilder,
    ValueMapper<T, String>? tooltipMapper,
    ButtonStyle? buttonStyle,
    bool? showSelectedIcon,
    bool? emptySelectionAllowed,
    Widget? selectedIcon,
    T? initialData,
    V? initialValue,
    super.textAlign,
    super.key,
    super.onSaved,
    FormFieldValidator<T>? validator,
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    super.decoration,
    super.onChanged,
    super.required,
    super.bordered = false,
    super.label,
    super.labelText,
    super.actionsBuilder,
    TxTileThemeData? tileTheme,
    super.trailingBuilder,
    super.leading,
  }) : super(
          tileTheme: const TxTileThemeData(layoutDirection: Axis.horizontal)
              .merge(tileTheme),
          builder: (field) {
            final AlignmentGeometry align = switch (textAlign) {
              null => AlignmentDirectional.centerEnd,
              TextAlign.left => Alignment.centerLeft,
              TextAlign.right => Alignment.centerRight,
              TextAlign.center => AlignmentDirectional.center,
              TextAlign.justify => AlignmentDirectional.center,
              TextAlign.start => AlignmentDirectional.centerStart,
              TextAlign.end => AlignmentDirectional.centerEnd,
            };

            return Align(
              alignment: align,
              child: SegmentedButton<T>(
                segments: List.generate(source.length, (index) {
                  final data = source[index];

                  return ButtonSegment<T>(
                    value: data,
                    label: Text(
                      labelMapper(data) ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    icon: iconBuilder == null
                        ? null
                        : iconBuilder(field.context, index, data),
                    tooltip: tooltipMapper == null ? null : tooltipMapper(data),
                    // enabled: disabledWhen == null ? true : !disabledWhen(data),
                  );
                }),
                showSelectedIcon: showSelectedIcon ?? false,
                selectedIcon: selectedIcon,
                multiSelectionEnabled: false,
                emptySelectionAllowed: emptySelectionAllowed ?? true,
                selected: {if (field.value != null) field.value!},
                onSelectionChanged: field.isEnabled
                    ? (data) =>
                        field.didChange(data.isEmpty ? null : data.first)
                    : null,
                style: (buttonStyle ??= const ButtonStyle()).merge(ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith((states) {
                    final theme = Theme.of(field.context);
                    // 同时处理 disabled 和 selected 状态
                    if (states.contains(WidgetState.disabled)) {
                      if (states.contains(WidgetState.selected)) {
                        return theme.disabledColor.withValues(alpha: 0.1);
                        // 禁用时选中的背景色
                      }
                      return null; // 禁用时未选中的背景色
                    }
                    if (states.contains(WidgetState.selected)) {
                      return theme.colorScheme.primary; // 启用时选中的背景色
                    }
                    return null;
                  }),
                )),
              ),
            );
          },
          initialValue: TxPickerFormField.initData<T, V>(
            source,
            initialData,
            initialValue,
            valueMapper,
          ),
          validator: (value) => TxPickerFormField.generateValidator<T>(
            value,
            validator,
            required,
          ),
        );
}
