import 'package:flutter/material.dart';

import 'form_field_tile.dart';

/// [builder] 构建的组件为 Wrap 布局的 [FormField]。
///
/// 通常用于多个选择组件，如 Checkbox、Radio、Chip 等。
class TxWrapFormField<T> extends FormField<T> {
  const TxWrapFormField({
    required super.builder,
    T? initialValue,
    ValueChanged<T?>? onChanged,
    double? runSpacing,
    double? spacing,
    WrapAlignment? alignment,
    WrapAlignment? runAlignment,
    WrapCrossAlignment? crossAxisAlignment,
    InputDecoration? decoration,
    FocusNode? focusNode,
    super.key,
    super.onSaved,
    super.validator,
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    bool? required,
  });
}

/// [field] 为 [TxWrapFormField] 的 [TxFormFieldTile]。
///
/// 通常用于多个选择组件，如 Checkbox、Radio、Chip 等。
class TxWrapFormFieldTile<T> extends TxFormFieldTile<T> {
  TxWrapFormFieldTile({
    required super.field,
    super.initialValue,
    ValueChanged<T?>? onChanged,
    double? runSpacing,
    double? spacing,
    WrapAlignment? alignment,
    WrapAlignment? runAlignment,
    WrapCrossAlignment? crossAxisAlignment,
    InputDecoration? decoration,
    FocusNode? focusNode,
    super.key,
    super.labelBuilder,
    super.labelText,
    super.padding,
    super.actions,
    super.labelStyle,
    super.horizontalGap,
    super.tileColor,
    super.layoutDirection,
    super.trailing,
    super.leading,
    super.visualDensity,
    super.shape,
    super.iconColor,
    super.textColor,
    super.leadingAndTrailingTextStyle,
    super.enabled,
    super.onTap,
    super.minLeadingWidth,
    super.minLabelWidth,
    super.minVerticalPadding,
    super.dense,
    super.onSaved,
    super.validator,
    super.restorationId,
    super.autovalidateMode,
    super.required,
  });
}
