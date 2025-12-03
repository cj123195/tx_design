import 'package:flutter/material.dart';

import 'form_field.dart';
import 'picker_form_field.dart';

/// 下拉选择框配置
class DropdownConfig {
  DropdownConfig({
    this.focusNode,
    this.hintText,
    this.hint,
    this.disabledHint,
    this.onTap,
    this.elevation,
    this.style,
    this.icon,
    this.iconDisabledColor,
    this.iconEnabledColor,
    this.iconSize,
    this.isDense,
    this.isExpanded,
    this.itemHeight,
    this.focusColor,
    this.autofocus,
    this.dropdownColor,
    this.menuMaxHeight,
    this.enableFeedback,
    this.alignment,
    this.borderRadius,
    this.menuPadding,
    this.selectedItemBuilder,
  });

  final FocusNode? focusNode;
  final String? hintText;
  final Widget? hint;
  final Widget? disabledHint;
  final VoidCallback? onTap;
  final int? elevation;
  final TextStyle? style;
  final Widget? icon;
  final Color? iconDisabledColor;
  final Color? iconEnabledColor;
  final double? iconSize;
  final bool? isDense;
  final bool? isExpanded;
  final double? itemHeight;
  final Color? focusColor;
  final bool? autofocus;
  final Color? dropdownColor;
  final double? menuMaxHeight;
  final bool? enableFeedback;
  final AlignmentGeometry? alignment;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? menuPadding;
  final DropdownButtonBuilder? selectedItemBuilder;
}

/// 下拉选择框表单
class TxDropdownFormField<T, V> extends TxFormField<T> {
  TxDropdownFormField({
    required List<T> source,
    required ValueMapper<T, String?> labelMapper,
    ValueMapper<T, V?>? valueMapper,
    ValueMapper<T, bool>? disabledWhen,
    T? initialData,
    V? initialValue,
    super.key,
    super.onSaved,
    FormFieldValidator<T>? validator,
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    super.decoration,
    super.onChanged,
    super.required,
    super.bordered,
    bool? readOnly,
    String? hintText,
    DropdownConfig? dropdownConfig,
    super.label,
    super.labelText,
    super.actionsBuilder,
    super.trailingBuilder,
    super.leading,
    super.tileTheme,
  }) : super(
          initialValue: TxPickerFormField.initData(
            source,
            initialData,
            initialValue,
            valueMapper,
          ),
          builder: (field) {
            final AlignmentGeometry effectiveAlign =
                dropdownConfig?.alignment ??
                    (tileTheme?.layoutDirection == Axis.horizontal
                        ? Alignment.centerRight
                        : Alignment.centerLeft);

            final items = List.generate(
              source.length,
              (i) {
                final T item = source[i];
                final bool enabled =
                    disabledWhen == null ? true : !disabledWhen(item);
                return DropdownMenuItem<T>(
                  value: item,
                  alignment: effectiveAlign,
                  enabled: enabled,
                  child: Text(
                    labelMapper(item) ?? '',
                    style: enabled
                        ? null
                        : TextStyle(
                            color: Theme.of(field.context).disabledColor,
                          ),
                  ),
                );
              },
            );

            return DropdownButtonFormField<T>(
              items: items,
              selectedItemBuilder: dropdownConfig?.selectedItemBuilder,
              value: field.value,
              hint: readOnly == true
                  ? null
                  : dropdownConfig?.hint ?? Text(hintText ?? '请选择'),
              disabledHint: dropdownConfig?.disabledHint ?? const Text('无'),
              onChanged: readOnly == false ? null : field.didChange,
              onTap: dropdownConfig?.onTap,
              elevation: dropdownConfig?.elevation ?? 4,
              style: dropdownConfig?.style ??
                  Theme.of(field.context).textTheme.bodyLarge,
              icon: dropdownConfig?.icon,
              iconDisabledColor: dropdownConfig?.iconDisabledColor,
              iconEnabledColor: dropdownConfig?.iconEnabledColor,
              iconSize: dropdownConfig?.iconSize ?? 24.0,
              isDense: dropdownConfig?.isDense ?? true,
              isExpanded: dropdownConfig?.isExpanded ?? true,
              itemHeight: dropdownConfig?.itemHeight,
              focusColor: dropdownConfig?.focusColor,
              focusNode: dropdownConfig?.focusNode,
              autofocus: dropdownConfig?.autofocus ?? false,
              dropdownColor: dropdownConfig?.dropdownColor,
              decoration: field.effectiveDecoration,
              menuMaxHeight: dropdownConfig?.menuMaxHeight,
              enableFeedback: dropdownConfig?.enableFeedback,
              alignment: effectiveAlign,
              borderRadius: dropdownConfig?.borderRadius,
              padding: dropdownConfig?.menuPadding,
            );
          },
          validator: (val) =>
              TxPickerFormField.generateValidator(val, validator, required),
        );

  TxDropdownFormField.custom({
    required List<DropdownMenuItem<T>> items,
    super.key,
    super.initialValue,
    super.onSaved,
    FormFieldValidator<T>? validator,
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    super.decoration,
    super.onChanged,
    super.required,
    bool? readOnly,
    String? hintText,
    DropdownConfig? dropdownConfig,
    super.label,
    super.labelText,
    super.actionsBuilder,
    super.trailingBuilder,
    super.leading,
    super.tileTheme,
  }) : super(
          builder: (field) {
            final AlignmentGeometry effectiveAlign =
                dropdownConfig?.alignment ??
                    (tileTheme?.layoutDirection == Axis.horizontal
                        ? Alignment.centerRight
                        : Alignment.centerLeft);

            return DropdownButtonFormField<T>(
              items: items,
              selectedItemBuilder: dropdownConfig?.selectedItemBuilder,
              value: field.value,
              onChanged: readOnly == false ? null : field.didChange,
              hint: readOnly == true
                  ? null
                  : dropdownConfig?.hint ?? Text(hintText ?? '请选择'),
              disabledHint: dropdownConfig?.disabledHint ?? const Text('无'),
              onTap: dropdownConfig?.onTap,
              elevation: dropdownConfig?.elevation ?? 4,
              style: dropdownConfig?.style ??
                  Theme.of(field.context).textTheme.bodyLarge,
              icon: dropdownConfig?.icon,
              iconDisabledColor: dropdownConfig?.iconDisabledColor,
              iconEnabledColor: dropdownConfig?.iconEnabledColor,
              iconSize: dropdownConfig?.iconSize ?? 24.0,
              isDense: dropdownConfig?.isDense ?? true,
              isExpanded: dropdownConfig?.isExpanded ?? true,
              itemHeight: dropdownConfig?.itemHeight,
              focusColor: dropdownConfig?.focusColor,
              focusNode: dropdownConfig?.focusNode,
              autofocus: dropdownConfig?.autofocus ?? false,
              dropdownColor: dropdownConfig?.dropdownColor,
              decoration: field.effectiveDecoration,
              menuMaxHeight: dropdownConfig?.menuMaxHeight,
              enableFeedback: dropdownConfig?.enableFeedback,
              alignment: effectiveAlign,
              borderRadius: dropdownConfig?.borderRadius,
              padding: dropdownConfig?.menuPadding,
            );
          },
          validator: (val) =>
              TxPickerFormField.generateValidator(val, validator, required),
          hintText: hintText ?? '请选择',
        );
}
