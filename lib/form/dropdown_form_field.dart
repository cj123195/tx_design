import 'package:flutter/material.dart';

import '../extensions/iterable_extension.dart';
import '../localizations.dart';
import '../utils/basic_types.dart';
import '../widgets/dropdown.dart';
import 'form_field.dart';

/// 下拉选择Form组件
class DropdownFormField<T, V> extends TxFormFieldItem {
  DropdownFormField({
    required ValueMapper<T, String> labelMapper,
    required List<T>? sources,
    ValueMapper<T, V>? valueMapper,
    ValueMapper<T, bool>? enabledMapper,
    super.key,
    V? initialValue,
    T? initialData,
    ValueChanged<T?>? onChanged,
    super.onSaved,
    super.validator,
    super.enabled,
    super.autovalidateMode = AutovalidateMode.disabled,
    super.labelText,
    super.label,
    super.required,
    super.backgroundColor,
    super.labelStyle,
    super.starStyle,
    super.direction,
    super.padding,
    super.horizontalGap,
    super.minLabelWidth,
    TxDropdownButtonBuilder? selectedItemBuilder,
    T? value,
    Widget? hint,
    Widget? disabledHint,
    VoidCallback? onTap,
    int elevation = 8,
    TextStyle? style,
    Widget? icon,
    Color? iconDisabledColor,
    Color? iconEnabledColor,
    double iconSize = 24.0,
    bool isDense = true,
    bool isExpanded = false,
    double? itemHeight,
    Color? focusColor,
    FocusNode? focusNode,
    bool autofocus = false,
    Color? dropdownColor,
    InputDecoration? decoration,
    double? menuMaxHeight,
    AlignmentGeometry alignment = AlignmentDirectional.centerStart,
    BorderRadius? borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    EdgeInsetsGeometry? fieldPadding = EdgeInsets.zero,
  }) : super(
          builder: (field) {
            final FormFieldValidator<T>? effectiveValidator = validator ??
                (required
                    ? (value) => value == null
                        ? TxLocalizations.of(field.context).pickerFormFieldHint
                        : null
                    : null);
            final List<TxDropdownMenuItem<T>>? items = sources
                ?.map((e) => TxDropdownMenuItem<T>(
                      value: e,
                      child: Text(labelMapper(e)),
                    ))
                .toList();
            final InputDecoration effectiveDecoration =
                TxFormFieldItem.mergeDecoration(
              field.context,
              decoration,
              InputDecoration(
                hintText: TxLocalizations.of(field.context).pickerFormFieldHint,
              ),
            );

            return TxDropdownButtonFormField<T>(
              items: items,
              selectedItemBuilder: selectedItemBuilder,
              hint: hint,
              disabledHint: disabledHint,
              onTap: onTap,
              elevation: elevation,
              style: style,
              icon: icon,
              iconDisabledColor: iconDisabledColor,
              iconEnabledColor: iconEnabledColor,
              iconSize: iconSize,
              isDense: isDense,
              isExpanded: isExpanded,
              itemHeight: itemHeight,
              focusNode: focusNode,
              focusColor: focusColor,
              autofocus: autofocus,
              dropdownColor: dropdownColor,
              menuMaxHeight: menuMaxHeight,
              alignment: alignment,
              value: initialData ??
                  sources?.tryFind((e) =>
                      (valueMapper?.call(e) ?? labelMapper(e)) == initialValue),
              onChanged: onChanged,
              autovalidateMode: autovalidateMode,
              enableFeedback: enabled,
              onSaved: onSaved,
              decoration: effectiveDecoration,
              borderRadius: borderRadius,
              padding: fieldPadding,
              validator: effectiveValidator,
            );
          },
        );
}
