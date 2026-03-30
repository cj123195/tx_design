import 'package:flutter/material.dart';

import '../widgets/picker.dart';
import 'common_text_form_field.dart';

export '../widgets/picker.dart'
    show PickerItemBuilder, EqualityMatcher, FilterMatcher, ValueMapper;
export 'common_text_form_field.dart' show FormFieldTapCallback;

typedef PickVoidCallback<T> = Future<T?> Function(
  BuildContext context,
  T? initialValue,
);

/// 处理输入框点击事件
Future<void> _onTap<T>(
  TxCommonTextFormFieldState<T> field,
  PickVoidCallback<T> onPick,
) async {
  FocusScope.of(field.context).requestFocus(FocusNode());

  final res = await onPick(field.context, field.value);

  if (res != null && res != field.value) {
    field.didChange(res);
  }
}

/// 选择器配置
class TxPickerConfig<T> {
  const TxPickerConfig({
    this.subtitleBuilder,
    this.itemBuilder,
    this.disabledWhen,
    this.showSearchField,
    this.placeholder,
    this.listTileTheme,
    this.filterMatcher,
    this.equalityMatcher,
    this.secondaryBuilder,
  });

  final DataWidgetBuilder<T>? subtitleBuilder;
  final PickerItemBuilder<T>? itemBuilder;
  final ValueMapper<T, bool>? disabledWhen;
  final bool? showSearchField;
  final Widget? placeholder;
  final ListTileThemeData? listTileTheme;
  final FilterMatcher<T>? filterMatcher;
  final EqualityMatcher<T>? equalityMatcher;
  final DataWidgetBuilder<T>? secondaryBuilder;
}

/// 单项选择框表单
class TxPickerFormField<T, V> extends TxCommonTextFormField<T> {
  /// 默认构造方法
  ///
  /// [source] 数据源
  /// [labelMapper] 根据已知 T 类型数据生成展示标签的方法
  TxPickerFormField({
    required List<T> source,
    required ValueMapper<T, String?> labelMapper,
    super.clearable,
    super.key,
    super.onSaved,
    FormFieldValidator<T>? validator,
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    super.decoration,
    super.onChanged,
    super.required,
    T? initialData,
    V? initialValue,
    ValueMapper<T, V?>? valueMapper,
    TxPickerConfig<T>? pickerConfig,
    PickVoidCallback<T>? onPickTap,
    FormFieldTapCallback<T>? onTap,
    super.focusNode,
    super.hintText,
    super.bordered,
    super.readOnly,
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
  }) : super.readonly(
          initialValue:
              initData<T, V>(source, initialData, initialValue, valueMapper),
          onTap: (field) {
            // 如果用户提供了自定义 onTap，优先使用
            if (onTap != null) {
              return onTap(field);
            }

            // 只读模式下不执行任何操作
            if (readOnly == true) {
              return;
            }

            FocusScope.of(field.context).requestFocus(FocusNode());

            onPickTap ??= (context, value) => showPickerBottomSheet<T>(
                  context,
                  source: readOnly == true
                      ? source
                      : <T>{...source, if (field.value != null) field.value!}
                          .toList(),
                  labelMapper: labelMapper,
                  initialData: value,
                  disabledWhen: pickerConfig?.disabledWhen,
                  title: labelText,
                  subtitleBuilder: pickerConfig?.subtitleBuilder,
                  itemBuilder: pickerConfig?.itemBuilder,
                  showSearchField: pickerConfig?.showSearchField,
                  placeholder: pickerConfig?.placeholder,
                  listTileTheme: pickerConfig?.listTileTheme,
                  filterMatcher: pickerConfig?.filterMatcher,
                  equalityMatcher: pickerConfig?.equalityMatcher,
                  secondaryBuilder: pickerConfig?.secondaryBuilder,
                );

            _onTap(field, onPickTap!);
          },
          displayTextMapper: (context, val) => labelMapper(val) ?? '',
          validator: readOnly == true
              ? null
              : (val) => generateValidator(val, validator, required),
        );

  /// 无需数据源的选择器构造方法
  ///
  /// 主要提供给时间选择组件使用
  TxPickerFormField.withoutSource({
    required PickVoidCallback<T>? onPickTap,
    required super.displayTextMapper,
    super.clearable,
    super.key,
    super.onSaved,
    FormFieldValidator<T>? validator,
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    super.decoration,
    super.onChanged,
    super.required,
    super.initialValue,
    super.hintText,
    super.focusNode,
    super.bordered,
    super.readOnly,
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
  }) : super.readonly(
          onTap: readOnly == true ? null : (field) => _onTap(field, onPickTap!),
          validator: (val) => readOnly == true
              ? null
              : generateValidator(val, validator, required),
        );

  /// 根据当前表单值 [value]、传入验证器 [validator]、 是否必填 [required] 生成默认验证器法。
  static String? generateValidator<T>(
    T? value,
    FormFieldValidator<T>? validator,
    bool? required,
  ) {
    if (required == true && value == null) {
      return '请选择';
    }

    if (validator != null) {
      final String? errorText = validator(value);
      if (errorText != null) {
        return errorText;
      }
    }

    return null;
  }

  /// 通过传入数据源 [source]、[D] 类型初始数据 [initialData]、[V] 类型初始值
  /// [initialValue]以及值生成器 [valueMapper] 生成 [D] 类型初始化数据的方法。
  static D? initData<D, V>(
    List<D> source,
    D? initialData,
    V? initialValue,
    ValueMapper<D, V?>? valueMapper,
  ) {
    if (initialData != null) {
      return initialData;
    }
    if (initialValue == null) {
      return null;
    }
    if (valueMapper == null) {
      return initialValue as D;
    }
    for (D item in source) {
      if (initialValue == valueMapper(item)) {
        return item;
      }
    }
    return null;
  }

  @override
  TxPickerFormFieldState<T, V> createState() => TxPickerFormFieldState<T, V>();
}

class TxPickerFormFieldState<T, V> extends TxCommonTextFormFieldState<T> {
  @override
  TxPickerFormField<T, V> get widget => super.widget as TxPickerFormField<T, V>;

  @override
  List<Widget>? get suffixIcons => [
        ...?super.suffixIcons,
        if (isEnabled && !widget.readOnly)
          const Icon(Icons.keyboard_arrow_right),
      ];
}
