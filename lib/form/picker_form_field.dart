import 'package:flutter/material.dart';

import '../extensions/iterable_extension.dart';
import '../utils/basic_types.dart';
import '../widgets/picker_bottom_sheet.dart';
import 'common_picker_form_field.dart';

/// 单选Form组件
class PickerFormField<T, V> extends CommonPickerFormField<T, V> {
  PickerFormField({
    required List<T> sources,
    required super.labelMapper,
    ValueMapper<T, V>? valueMapper,
    ValueMapper<T, String>? subtitleMapper,

    /// FormItemContainer参数
    super.label,
    super.labelText,
    super.labelPadding,
    super.background,
    super.direction,

    /// Form参数
    V? initialValue,
    T? initialData,
    super.key,
    super.onSaved,
    super.restorationId,
    super.enabled,
    super.autovalidateMode = AutovalidateMode.disabled,
    super.textCapitalization = TextCapitalization.none,

    /// TextField参数
    super.focusNode,
    super.decoration = const InputDecoration(),
    super.validator,
    PickerItemBuilder<T>? pickerItemBuilder,
    super.onChanged,
    super.required = false,
    super.readonly = false,
    // bool inputEnabled = false,
    super.keyboardType,
    PickerFuture<T>? onPickTap,
    super.style,
    super.textInputAction,
    super.strutStyle,
    super.textDirection,
    super.textAlign = TextAlign.start,
    super.textAlignVertical,
    super.autofocus = false,
    super.contextMenuBuilder,
    super.maxLines = 1,
    super.minLines,
    super.maxLength,
    super.onTap,
    super.onEditingComplete,
    super.inputFormatters,
    super.enableSpeech = true,
  }) : super(
          valueMapper: valueMapper ?? labelMapper as ValueMapper<T, V>,
          onPickTap: onPickTap ??
              (BuildContext context, T? initialValue) =>
                  showPickerBottomSheet<T, V>(
                    context,
                    title: labelText,
                    labelMapper: labelMapper,
                    valueMapper: valueMapper,
                    sources: sources,
                    subtitleMapper: subtitleMapper,
                    pickerItemBuilder: pickerItemBuilder,
                    initialData: initialValue,
                  ),
          initialValue: initialData ??
              sources.tryFind((e) =>
                  (valueMapper?.call(e) ?? labelMapper(e)) == initialValue),
        );
}
