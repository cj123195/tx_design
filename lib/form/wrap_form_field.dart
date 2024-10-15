import 'package:flutter/material.dart';

import '../field/wrap_field.dart';
import 'form_field.dart';
import 'form_field_tile.dart';

/// [builder] 构建的组件为 Wrap 布局的 [FormField]。
///
/// 通常用于多个选择组件，如 Checkbox、Radio、Chip 等。
class TxWrapFormField<T> extends TxFormField<T> {
  TxWrapFormField({
    required WrapWidgetBuilder<T> itemBuilder,
    required int itemCount,
    double? spacing,
    double? runSpacing,
    WrapAlignment? alignment,
    WrapAlignment? runAlignment,
    WrapCrossAlignment? crossAxisAlignment,
    FocusNode? focusNode,
    super.key,
    super.onSaved,
    super.validator,
    super.initialValue,
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    super.decoration,
    super.onChanged,
    super.required,
  }) : super(
          builder: (field) => TxWrapField(
            spacing: spacing ?? 0.0,
            runSpacing: spacing ?? 0.0,
            alignment: alignment ?? WrapAlignment.start,
            runAlignment: runAlignment ?? WrapAlignment.start,
            crossAxisAlignment: crossAxisAlignment ?? WrapCrossAlignment.start,
            itemBuilder: itemBuilder,
            itemCount: itemCount,
            focusNode: focusNode,
            decoration: field.effectiveDecoration,
            onChanged: field.didChange,
            initialValue: field.value,
            enabled: enabled,
          ),
        );
}

/// field 为 [TxWrapFormField] 的 [TxFormFieldTile]。
///
/// 通常用于多个选择组件，如 Checkbox、Radio、Chip 等。
class TxWrapFormFieldTile<T> extends TxFormFieldTile<T> {
  TxWrapFormFieldTile({
    required WrapWidgetBuilder<T> itemBuilder,
    required int itemCount,
    super.key,
    super.onSaved,
    super.validator,
    super.initialValue,
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    super.decoration,
    super.onChanged,
    super.required,
    double? spacing,
    double? runSpacing,
    WrapAlignment? alignment,
    WrapAlignment? runAlignment,
    WrapCrossAlignment? crossAxisAlignment,
    FocusNode? focusNode,
    super.labelBuilder,
    super.labelText,
    super.padding,
    super.labelStyle,
    super.horizontalGap,
    super.tileColor,
    super.layoutDirection,
    super.leading,
    super.visualDensity,
    super.shape,
    super.iconColor,
    super.textColor,
    super.leadingAndTrailingTextStyle,
    super.onTap,
    super.minLeadingWidth,
    super.minLabelWidth,
    super.minVerticalPadding,
    super.dense,
  }) : super(
          fieldBuilder: (field) => TxWrapField(
            spacing: spacing ?? 0.0,
            runSpacing: spacing ?? 0.0,
            alignment: alignment ?? WrapAlignment.start,
            runAlignment: runAlignment ?? WrapAlignment.start,
            crossAxisAlignment: crossAxisAlignment ?? WrapCrossAlignment.start,
            itemBuilder: itemBuilder,
            itemCount: itemCount,
            focusNode: focusNode,
            decoration: field.effectiveDecoration,
            onChanged: field.didChange,
            initialValue: field.value,
            enabled: enabled,
          ),
        );
}
