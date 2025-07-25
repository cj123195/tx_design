import 'package:flutter/material.dart';

import '../widgets/multi_cascade_picker.dart';
import 'multi_picker_form_field.dart';

export '../widgets/multi_cascade_picker.dart'
    show
        ValueMapper,
        DataWidgetBuilder,
        MultiPickerItemBuilder,
        MultiPickerActionBarBuilder,
        MultiPickerSelectedItemBuilder;

/// 级联选择框表单
class TxMultiCascadePickerFormField<T, V> extends TxMultiPickerFormField<T, V> {
  TxMultiCascadePickerFormField({
    required super.source,
    required super.labelMapper,
    required ValueMapper<T, List<T>?> childrenMapper,
    super.valueMapper,
    super.initialData,
    super.initialValue,
    super.maxCount,
    super.minCount,
    bool? linkage,
    super.actionBarBuilder,
    super.selectedItemBuilder,
    super.itemBuilder,
    super.listTileTheme,
    bool? parentCheckable,
    super.subtitleBuilder,
    super.showSearchField,
    super.placeholder,
    super.disabledWhen,
    super.readOnly,
    super.key,
    super.onSaved,
    super.validator,
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    super.decoration,
    super.onChanged,
    super.required,
    super.focusNode,
    super.hintText,
    super.textAlign,
    super.bordered,
    super.canRequestFocus,
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
    super.minLeadingWidth,
    super.minLabelWidth,
    super.minVerticalPadding,
    super.dense,
    super.colon,
    super.focusColor,
  }) : super(
          onPickTap: (context, initialData) => showMultiCascadePicker<T, V>(
            title: labelText,
            context: context,
            source: source ?? [],
            labelMapper: labelMapper,
            valueMapper: valueMapper,
            childrenMapper: childrenMapper,
            initialData: initialData,
            parentCheckable: parentCheckable,
            itemBuilder: itemBuilder,
            listTileTheme: listTileTheme,
            placeholder: placeholder,
            maxCount: maxCount,
            linkage: linkage,
            actionBarBuilder: actionBarBuilder,
            selectedItemBuilder: selectedItemBuilder,
            showSearchField: showSearchField,
            subtitleBuilder: subtitleBuilder,
            disabledWhen: disabledWhen,
          ),
        );

  TxMultiCascadePickerFormField.fromMapList({
    required List<Map> source,
    String? labelKey,
    String? valueKey,
    String? idKey,
    String? pidKey,
    String? rootId,
    List<Map>? initialData,
    super.initialValue,
    DataWidgetBuilder<Map>? subtitleBuilder,
    MultiPickerItemBuilder<Map>? itemBuilder,
    MultiPickerActionBarBuilder<Map>? actionBarBuilder,
    MultiPickerSelectedItemBuilder<Map>? selectedItemBuilder,
    super.maxCount,
    super.minCount,
    ValueMapper<Map, bool>? disabledWhen,
    super.showSearchField,
    super.placeholder,
    bool? parentCheckable,
    bool? linkage,
    super.listTileTheme,
    super.readOnly,
    super.key,
    super.onSaved,
    FormFieldValidator<List<Map>>? validator,
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    super.decoration,
    super.onChanged,
    super.required,
    super.focusNode,
    super.hintText,
    super.textAlign,
    super.bordered,
    super.canRequestFocus,
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
    super.minLeadingWidth,
    super.minLabelWidth,
    super.minVerticalPadding,
    super.dense,
    super.colon,
    super.focusColor,
  }) : super(
          source: source as List<T>,
          labelMapper: (val) => (val as Map)[labelKey],
          initialData: initialData as List<T>?,
          onPickTap: (context, initialData) => showMultiMapListCascadePicker<V>(
            title: labelText,
            context: context,
            source: source,
            labelKey: labelKey,
            valueKey: valueKey,
            idKey: idKey,
            pidKey: pidKey,
            rootId: rootId,
            initialData: initialData?.cast<Map>(),
            parentCheckable: parentCheckable,
            itemBuilder: itemBuilder,
            listTileTheme: listTileTheme,
            placeholder: placeholder,
            maxCount: maxCount,
            linkage: linkage,
            actionBarBuilder: actionBarBuilder,
            selectedItemBuilder: selectedItemBuilder,
            showSearchField: showSearchField,
            subtitleBuilder: subtitleBuilder,
            disabledWhen: disabledWhen,
          ) as Future<List<T>?>,
        );
}
