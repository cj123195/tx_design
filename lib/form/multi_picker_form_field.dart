import 'package:flutter/material.dart';

import '../widgets/multi_picker.dart';
import 'form_field.dart';

export '../utils/basic_types.dart' show ValueMapper;
export '../widgets/multi_picker.dart'
    show
        MultiPickerItemBuilder,
        MultiPickerActionBarBuilder,
        MultiPickerSelectedItemBuilder;

typedef MultiPickVoidCallback<T> = Future<List<T>?> Function(
  BuildContext context,
  List<T>? initialValue,
);

/// 多项选择框表单
class TxMultiPickerFormField<T, V> extends TxFormField<List<T>> {
  TxMultiPickerFormField({
    required List<T>? source,
    required ValueMapper<T, String?> labelMapper,
    MultiPickVoidCallback<T>? onPickTap,
    super.key,
    super.onSaved,
    FormFieldValidator<List<T>>? validator,
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    InputDecoration? decoration,
    super.onChanged,
    super.required,
    ValueMapper<T, V?>? valueMapper,
    ValueMapper<T, bool>? disabledWhen,
    List<T>? initialData,
    List<V>? initialValue,
    int? minCount,
    int? maxCount,
    DataWidgetBuilder<T>? subtitleBuilder,
    MultiPickerItemBuilder<T>? itemBuilder,
    MultiPickerActionBarBuilder<T>? actionBarBuilder,
    MultiPickerSelectedItemBuilder<T>? selectedItemBuilder,
    bool? showSearchField,
    Widget? placeholder,
    ListTileThemeData? listTileTheme,
    super.focusNode,
    String? hintText,
    bool? readOnly,
    super.textAlign,
    super.bordered,
    super.onTap,
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
  })  : readOnly = readOnly ?? false,
        super.decorated(
          initialValue:
              initData<T, V>(source, initialData, initialValue, valueMapper),
          decoration: (decoration ?? const InputDecoration()).copyWith(
            contentPadding: decoration?.contentPadding ??
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
          ),
          hintText: readOnly == true ? null : '请选择',
          validator: (val) =>
              generateValidator(val, validator, required, minCount, maxCount),
          builder: (field) {
            return Wrap(
              children: List.generate(
                field.value?.length ?? 0,
                (index) => Chip(
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  label: Text(labelMapper(field.value![index]) ?? ''),
                  onDeleted: readOnly == true
                      ? null
                      : () {
                          final list = [...field.value!]..removeAt(index);
                          field.didChange(list);
                        },
                  deleteIcon: readOnly == true
                      ? null
                      : const Icon(Icons.close, size: 18),
                  side: const BorderSide(color: Colors.transparent),
                  backgroundColor: Theme.of(field.context).colorScheme.surface,
                  padding:
                      const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                ),
              ),
            );
          },
          onFieldTap: readOnly == true
              ? null
              : (field) async {
                  onPickTap ??=
                      (context, value) => showMultiPickerBottomSheet<T, V>(
                            context,
                            source: source ?? [],
                            labelMapper: labelMapper,
                            initialData: value,
                            disabledWhen: disabledWhen,
                            valueMapper: valueMapper,
                            itemBuilder: itemBuilder,
                            subtitleBuilder: subtitleBuilder,
                            selectedItemBuilder: selectedItemBuilder,
                            actionBarBuilder: actionBarBuilder,
                            maxCount: maxCount,
                            showSearchField: showSearchField,
                            placeholder: placeholder,
                            listTileTheme: listTileTheme,
                            title: labelText,
                          );

                  final res = await onPickTap!(field.context, field.value);

                  if (res != null && res != field.value) {
                    field.didChange(res);
                  }
                },
        );

  /// 是否只读
  final bool readOnly;

  /// 根据当前表单值 [value]、传入验证器 [validator]、 是否必填 [required]、最小选择数量
  /// [minCount]、最大选择 数量 [maxCount] 生成默认验证器法。
  static String? generateValidator<T>(
    List<T>? value,
    FormFieldValidator<List<T>>? validator,
    bool? required,
    int? minCount,
    int? maxCount,
  ) {
    if (required == true && (value == null || value.isEmpty)) {
      return '请选择';
    }

    if (validator != null) {
      final String? errorText = validator(value);
      if (errorText != null) {
        return errorText;
      }
    }

    /// 如果最小数量不为空，判断已选数量是否小于最小数量
    if (minCount != null && (value?.length ?? 0) < minCount) {
      return '请至少选择$minCount项';
    }

    /// 如果最小数量不为空，判断已选数量是否小于最小数量
    if (maxCount != null && (value?.length ?? 0) > maxCount) {
      return '最多可选择$maxCount项';
    }

    return null;
  }

  /// 通过传入数据源 [source]、[D] 类型初始数据列表 [initialData]、[V] 类型初始值列表
  /// [initialValue]以及值生成器 [valueMapper] 生成 [D]类型列表初始化数据的方法。
  static List<D>? initData<D, V>(
    List<D>? source,
    List<D>? initialData,
    List<V>? initialValue,
    ValueMapper<D, V?>? valueMapper,
  ) {
    valueMapper ??= (D data) => data as V;

    final List<D> result = [];
    if (initialData != null && initialData.isNotEmpty) {
      result.addAll(initialData);
    }

    if (source != null &&
        source.isNotEmpty &&
        initialValue != null &&
        initialValue.isNotEmpty) {
      final List<D> data =
          source.where((s) => initialValue.contains(valueMapper!(s))).toList();
      if (data.isNotEmpty) {
        result.addAll(data);
      }
    }

    return result;
  }

  @override
  TxFormFieldState<List<T>> createState() => TxMultiPickerFormFieldState();
}

class TxMultiPickerFormFieldState<T, V> extends TxFormFieldState<List<T>> {
  @override
  TxMultiPickerFormField<T, V> get widget =>
      super.widget as TxMultiPickerFormField<T, V>;

  @override
  bool get isEmpty {
    return value == null || value!.isEmpty;
  }

  @override
  List<Widget>? get suffixIcons => [
        ...?super.suffixIcons,
        if (isEnabled && !widget.readOnly)
          const Icon(Icons.keyboard_arrow_right),
      ];
}
