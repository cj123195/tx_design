import 'package:flutter/material.dart';

import '../extensions/iterable_extension.dart';
import '../localizations.dart';
import '../utils/basic_types.dart';
import 'form_field.dart';
import 'form_item_container.dart';

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
    DropdownButtonBuilder? selectedItemBuilder,
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
    AlignmentGeometry alignment = AlignmentDirectional.centerEnd,
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
            final InputDecoration effectiveDecoration =
                TxFormFieldItem.mergeDecoration(
              field.context,
              decoration,
              InputDecoration(
                hintText: TxLocalizations.of(field.context).pickerFormFieldHint,
              ),
            );
            final TextAlign textAlign = FormItemContainer.getTextAlign(
              field.context,
              null,
              direction,
            );
            final List<DropdownMenuItem<T>>? items = sources
                ?.map((e) => DropdownMenuItem<T>(
                      value: e,
                      alignment: FormItemContainer.getAlignment(
                        field.context,
                        direction,
                      ),
                      child: Text(labelMapper(e)),
                    ))
                .toList();

            return DropdownButtonFormField<T>(
              items: items,
              selectedItemBuilder: selectedItemBuilder,
              hint: Text(TxLocalizations.of(field.context).pickerFormFieldHint,
                  textAlign: textAlign),
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
