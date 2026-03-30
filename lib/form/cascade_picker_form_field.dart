import 'package:flutter/material.dart';

import '../extensions/iterable_extension.dart';
import '../widgets/cascade_picker.dart';
import 'picker_form_field.dart';

export '../widgets/cascade_picker.dart'
    show ValueMapper, DataWidgetBuilder, EqualityMatcher, FilterMatcher;

/// 级联选择配置
class TxCascadePickerConfig<T> extends TxPickerConfig<T> {
  const TxCascadePickerConfig({
    super.subtitleBuilder,
    super.itemBuilder,
    super.disabledWhen,
    super.showSearchField,
    super.placeholder,
    super.listTileTheme,
    super.filterMatcher,
    super.equalityMatcher,
    super.secondaryBuilder,
    this.parentCheckable,
  });

  final bool? parentCheckable;
}

/// 级联选择框表单
class TxCascadePickerFormField<T, V> extends TxPickerFormField<T, V> {
  TxCascadePickerFormField({
    required super.source,
    required super.labelMapper,
    required ValueMapper<T, List<T>?> childrenMapper,
    V? initialValue,
    T? initialData,
    super.valueMapper,
    TxCascadePickerConfig<T>? super.pickerConfig,
    super.clearable,
    super.key,
    super.onSaved,
    super.validator,
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    super.decoration,
    super.onChanged,
    super.required,
    super.readOnly,
    super.focusNode,
    super.hintText,
    super.bordered,
    super.maxLines,
    super.minLines,
    super.displayConfig,
    super.scrollConfig,
    super.label,
    super.labelText,
    super.actionsBuilder,
    super.trailingBuilder,
    super.leading,
    super.tileTheme,
  }) : super(
          initialData: source.getInitialData<V>(
            initialData: initialData,
            initialValue: initialValue,
            valueMapper: valueMapper,
            childrenMapper: childrenMapper,
          ),
          onPickTap: (context, initialData) => showCascadePicker<T>(
            context: context,
            source: source,
            labelMapper: labelMapper,
            childrenMapper: childrenMapper,
            disabledWhen: pickerConfig?.disabledWhen,
            initialData: initialData,
            parentCheckable: pickerConfig?.parentCheckable,
            subtitleBuilder: pickerConfig?.subtitleBuilder,
            itemBuilder: pickerConfig?.itemBuilder,
            listTileTheme: pickerConfig?.listTileTheme,
            placeholder: pickerConfig?.placeholder,
            title: labelText,
            showSearchField: pickerConfig?.showSearchField,
            filterMatcher: pickerConfig?.filterMatcher,
            equalityMatcher: pickerConfig?.equalityMatcher,
            secondaryBuilder: pickerConfig?.secondaryBuilder,
          ),
        );

  TxCascadePickerFormField.fromMapList({
    required List<Map> source,
    String? labelKey,
    String? valueKey,
    String? idKey,
    String? pidKey,
    String? rootId,
    Map? initialData,
    super.initialValue,
    TxCascadePickerConfig<Map>? pickerConfig,
    super.readOnly,
    super.clearable,
    super.key,
    super.onSaved,
    FormFieldValidator<Map>? validator,
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    super.decoration,
    ValueChanged<Map?>? onChanged,
    super.required,
    super.focusNode,
    super.hintText,
    super.bordered,
    super.maxLines,
    super.minLines,
    super.displayConfig,
    super.scrollConfig,
    super.label,
    super.labelText,
    super.actionsBuilder,
    super.trailingBuilder,
    super.leading,
    super.tileTheme,
  }) : super(
          source: source as List<T>,
          initialData: TxPickerFormField.initData(
            source,
            initialData,
            initialValue,
            (data) => data[valueKey ?? idKey ?? labelKey ?? kLabelKey],
          ) as T?,
          labelMapper: (data) => (data as Map)[labelKey ?? kLabelKey],
          valueMapper: (data) =>
              (data as Map)[valueKey ?? labelKey ?? kLabelKey],
          onPickTap: ((context, initialData) => showMapListCascadePicker<V>(
                context: context,
                source: source,
                labelKey: labelKey,
                rootId: rootId,
                idKey: idKey,
                pidKey: pidKey,
                initialData: initialData as Map?,
                parentCheckable: pickerConfig?.parentCheckable,
                disabledWhen: pickerConfig?.disabledWhen,
                itemBuilder: pickerConfig?.itemBuilder,
                listTileTheme: pickerConfig?.listTileTheme,
                placeholder: pickerConfig?.placeholder,
                subtitleBuilder: pickerConfig?.subtitleBuilder,
                showSearchField: pickerConfig?.showSearchField,
                filterMatcher: pickerConfig?.filterMatcher,
                equalityMatcher: pickerConfig?.equalityMatcher,
                secondaryBuilder: pickerConfig?.secondaryBuilder,
                title: labelText,
              )) as PickVoidCallback<T>?,
          validator: validator as FormFieldValidator<T>?,
          onChanged:
              onChanged == null ? null : (value) => onChanged(value as Map?),
        );
}
