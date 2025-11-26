import 'package:flutter/material.dart';

import '../utils/basic_types.dart';
import 'form_field.dart';
import 'picker_form_field.dart';

/// 下拉选择框表单
class TxDropdownFormField<T, V> extends TxFormField<T> {
  TxDropdownFormField({
    required List<T> source,
    required ValueMapper<T, String?> labelMapper,
    ValueMapper<T, V?>? valueMapper,
    IndexedValueMapper<T, bool>? enabledMapper,
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
    FocusNode? focusNode,
    String? hintText,
    Widget? hint,
    Widget? disabledHint,
    VoidCallback? onTap,
    int? elevation,
    TextStyle? style,
    Widget? icon,
    Color? iconDisabledColor,
    Color? iconEnabledColor,
    double? iconSize,
    bool? isDense,
    bool? isExpanded,
    double? itemHeight,
    Color? focusColor,
    bool? autofocus,
    Color? dropdownColor,
    double? menuMaxHeight,
    bool? enableFeedback,
    AlignmentGeometry? alignment,
    BorderRadius? borderRadius,
    EdgeInsetsGeometry? menuPadding,
    DropdownButtonBuilder? selectedItemBuilder,
    super.label,
    super.labelText,
    super.labelTextAlign,
    super.padding,
    super.actionsBuilder,
    super.labelStyle,
    super.horizontalGap,
    super.tileColor,
    super.layoutDirection,
    super.trailingBuilder,
    super.leading,
    super.visualDensity,
    super.shape,
    super.iconColor,
    super.textColor,
    super.leadingAndTrailingTextStyle,
    super.minLeadingWidth,
    super.dense,
    super.colon,
    super.minLabelWidth,
    super.minVerticalPadding,
  }) : super(
          initialValue: TxPickerFormField.initData(
            source,
            initialData,
            initialValue,
            valueMapper,
          ),
          builder: (field) {
            final AlignmentGeometry effectiveAlign = alignment ??
                (layoutDirection == Axis.horizontal
                    ? Alignment.centerRight
                    : Alignment.centerLeft);

            return DropdownButtonFormField<T>(
              items: List.generate(
                source.length,
                (i) {
                  final T item = source[i];
                  final bool enabled =
                      enabledMapper == null ? true : enabledMapper(i, item);
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
              ),
              selectedItemBuilder: selectedItemBuilder,
              value: field.value,
              hint: hint ?? Text(hintText ?? '请选择'),
              disabledHint: disabledHint ?? const Text('无'),
              onChanged: readOnly == false ? null : field.didChange,
              onTap: onTap,
              elevation: elevation ?? 4,
              style: style ?? Theme.of(field.context).textTheme.bodyLarge,
              icon: icon,
              iconDisabledColor: iconDisabledColor,
              iconEnabledColor: iconEnabledColor,
              iconSize: iconSize ?? 24.0,
              isDense: isDense ?? true,
              isExpanded: isExpanded ?? true,
              itemHeight: itemHeight,
              focusColor: focusColor,
              focusNode: focusNode,
              autofocus: autofocus ?? false,
              dropdownColor: dropdownColor,
              decoration: field.effectiveDecoration,
              menuMaxHeight: menuMaxHeight,
              enableFeedback: enableFeedback,
              alignment: effectiveAlign,
              borderRadius: borderRadius,
              padding: menuPadding,
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
    FocusNode? focusNode,
    String? hintText,
    Widget? hint,
    Widget? disabledHint,
    VoidCallback? onTap,
    int? elevation,
    TextStyle? style,
    Widget? icon,
    Color? iconDisabledColor,
    Color? iconEnabledColor,
    double? iconSize,
    bool? isDense,
    bool? isExpanded,
    double? itemHeight,
    Color? focusColor,
    bool? autofocus,
    Color? dropdownColor,
    double? menuMaxHeight,
    bool? enableFeedback,
    AlignmentGeometry? alignment,
    BorderRadius? borderRadius,
    EdgeInsetsGeometry? menuPadding,
    DropdownButtonBuilder? selectedItemBuilder,
    super.label,
    super.labelText,
    super.labelTextAlign,
    super.padding,
    super.actionsBuilder,
    super.labelStyle,
    super.horizontalGap,
    super.tileColor,
    super.layoutDirection,
    super.trailingBuilder,
    super.leading,
    super.visualDensity,
    super.shape,
    super.iconColor,
    super.textColor,
    super.leadingAndTrailingTextStyle,
    super.minLeadingWidth,
    super.dense,
    super.colon,
    super.minLabelWidth,
    super.minVerticalPadding,
  }) : super(
          builder: (field) {
            final AlignmentGeometry effectiveAlign = alignment ??
                (layoutDirection == Axis.horizontal
                    ? Alignment.centerRight
                    : Alignment.centerLeft);

            return DropdownButtonFormField<T>(
              items: items,
              selectedItemBuilder: selectedItemBuilder,
              value: field.value,
              onChanged: readOnly == false ? null : field.didChange,
              hint: hint ?? Text(hintText ?? '请选择'),
              disabledHint: disabledHint ?? const Text('无'),
              onTap: onTap,
              elevation: elevation ?? 4,
              style: style ?? Theme.of(field.context).textTheme.bodyLarge,
              icon: icon,
              iconDisabledColor: iconDisabledColor,
              iconEnabledColor: iconEnabledColor,
              iconSize: iconSize ?? 24.0,
              isDense: isDense ?? true,
              isExpanded: isExpanded ?? true,
              itemHeight: itemHeight,
              focusColor: focusColor,
              focusNode: focusNode,
              autofocus: autofocus ?? false,
              dropdownColor: dropdownColor,
              decoration: field.effectiveDecoration,
              menuMaxHeight: menuMaxHeight,
              enableFeedback: enableFeedback,
              alignment: effectiveAlign,
              borderRadius: borderRadius,
              padding: menuPadding,
            );
          },
          validator: (val) =>
              TxPickerFormField.generateValidator(val, validator, required),
          hintText: hintText ?? '请选择',
        );
}
