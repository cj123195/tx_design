import 'package:flutter/material.dart';

import 'form_field.dart';

typedef WrapWidgetBuilder<T> = Widget Function(
  TxFormFieldState<T> field,
  int index,
  T? initialValue,
  ValueChanged<T> onChanged,
);

/// Wrap 布局选择框组件。
///
/// 通常用于多个选择组件，如 Checkbox、Radio、Chip 等。
class TxWrapFormField<T> extends TxFormField<T> {
  TxWrapFormField({
    required WrapWidgetBuilder<T> itemBuilder,
    required int itemCount,
    super.initialValue,
    super.onSaved,
    super.validator,
    super.autovalidateMode = AutovalidateMode.onUserInteraction,
    super.restorationId,
    super.onChanged,
    super.decoration,
    super.focusNode,
    super.enabled,
    super.required,
    super.bordered,
    double? spacing,
    double? runSpacing,
    WrapAlignment? alignment,
    WrapAlignment? runAlignment,
    WrapCrossAlignment? crossAxisAlignment,
    super.key,
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
    super.minLabelWidth,
    super.minVerticalPadding,
    super.dense,
    super.colon,
    super.focusColor,
  }) : super.decorated(
          textAlign: alignment == WrapAlignment.center
              ? TextAlign.center
              : alignment == WrapAlignment.end
                  ? TextAlign.right
                  : alignment == WrapAlignment.start || alignment == null
                      ? TextAlign.left
                      : TextAlign.justify,
          builder: (field) => Wrap(
            spacing: spacing ?? 0.0,
            runSpacing: spacing ?? 0.0,
            alignment: alignment ?? WrapAlignment.start,
            runAlignment: runAlignment ?? WrapAlignment.start,
            crossAxisAlignment: crossAxisAlignment ?? WrapCrossAlignment.start,
            children: List.generate(
              itemCount,
              (index) => itemBuilder(
                field,
                index,
                field.value,
                field.didChange,
              ),
            ),
          ),
        );
}
