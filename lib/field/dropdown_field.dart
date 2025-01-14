import 'package:flutter/material.dart';

import '../utils/basic_types.dart';
import 'field.dart';
import 'picker_field.dart';

/// 下拉选择框
class TxDropdownField<T, V> extends TxField<T> {
  TxDropdownField({
    required List<T> source,
    required ValueMapper<T, String?> labelMapper,
    ValueMapper<T, V?>? valueMapper,
    IndexedValueMapper<T, bool>? enabledMapper,
    T? initialData,
    V? initialValue,
    super.key,
    super.decoration,
    super.enabled,
    super.onChanged,
    super.hintText = '请选择',
    super.textAlign,
    super.bordered,
    Widget? hint,
    Widget? disabledHint,
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
    FocusNode? focusNode,
    bool? autofocus,
    Color? dropdownColor,
    double? menuMaxHeight,
    bool? enableFeedback,
    AlignmentGeometry alignment = AlignmentDirectional.centerStart,
    BorderRadius? borderRadius,
    DropdownButtonBuilder? selectedItemBuilder,
    EdgeInsetsGeometry? menuPadding,
    super.label,
    super.labelText,
    super.labelTextAlign,
    super.labelOverflow,
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
    super.onTap,
    super.minLeadingWidth,
    super.dense,
    super.colon,
    super.minLabelWidth,
    super.minVerticalPadding,
  }) : super(
          builder: (field) {
            return DropdownButtonFormField<T>(
              items: List.generate(
                source.length,
                (i) {
                  final T item = source[i];
                  return DropdownMenuItem<T>(
                    value: item,
                    alignment: alignment,
                    enabled:
                        enabledMapper == null ? true : enabledMapper(i, item),
                    child: Text(labelMapper(item) ?? ''),
                  );
                },
              ),
              selectedItemBuilder: selectedItemBuilder,
              value: field.value,
              hint: hint,
              onChanged: field.didChange,
              onTap: onTap,
              elevation: elevation ?? 0,
              style: style,
              icon: icon,
              iconDisabledColor: iconDisabledColor,
              iconEnabledColor: iconEnabledColor,
              iconSize: iconSize ?? 24.0,
              isDense: isDense ?? true,
              isExpanded: isExpanded ?? false,
              itemHeight: itemHeight,
              focusColor: focusColor,
              focusNode: focusNode,
              autofocus: autofocus ?? false,
              dropdownColor: dropdownColor,
              decoration: field.effectiveDecoration,
              menuMaxHeight: menuMaxHeight,
              enableFeedback: enableFeedback,
              alignment: alignment,
              borderRadius: borderRadius,
              padding: menuPadding,
            );
          },
          initialValue: TxPickerField.initData(
              source, initialData, initialValue, valueMapper),
        );

  /// 自定义下拉选择框
  TxDropdownField.custom({
    required List<DropdownMenuItem<T>>? items,
    DropdownButtonBuilder? selectedItemBuilder,
    super.initialValue,
    super.key,
    super.decoration,
    super.enabled,
    super.onChanged,
    super.hintText,
    super.textAlign,
    super.bordered,
    Widget? hint,
    Widget? disabledHint,
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
    FocusNode? focusNode,
    bool? autofocus,
    Color? dropdownColor,
    double? menuMaxHeight,
    bool? enableFeedback,
    AlignmentGeometry alignment = AlignmentDirectional.centerStart,
    BorderRadius? borderRadius,
    EdgeInsetsGeometry? menuPadding,
    super.label,
    super.labelText,
    super.labelTextAlign,
    super.labelOverflow,
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
    super.onTap,
    super.minLeadingWidth,
    super.dense,
    super.colon,
    super.minLabelWidth,
    super.minVerticalPadding,
  }) : super(
          builder: (field) {
            return DropdownButtonFormField<T>(
              items: items,
              selectedItemBuilder: selectedItemBuilder,
              value: field.value,
              hint: hint,
              onChanged: field.didChange,
              onTap: onTap,
              elevation: elevation ?? 0,
              style: style,
              icon: icon,
              iconDisabledColor: iconDisabledColor,
              iconEnabledColor: iconEnabledColor,
              iconSize: iconSize ?? 24.0,
              isDense: isDense ?? true,
              isExpanded: isExpanded ?? false,
              itemHeight: itemHeight,
              focusColor: focusColor,
              focusNode: focusNode,
              autofocus: autofocus ?? false,
              dropdownColor: dropdownColor,
              decoration: field.effectiveDecoration,
              menuMaxHeight: menuMaxHeight,
              enableFeedback: enableFeedback,
              alignment: alignment,
              borderRadius: borderRadius,
              padding: menuPadding,
            );
          },
        );
}
