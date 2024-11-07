import 'package:flutter/material.dart';

import 'field.dart';
import 'field_tile.dart';

typedef WrapWidgetBuilder<T> = Widget Function(
  TxFieldState<T> field,
  int index,
  T? initialValue,
  ValueChanged<T> onChanged,
);

/// Wrap 包裹的 [TxField] 组件
///
/// 通常用于多个选择组件，如 Checkbox、Radio、Chip 等。
class TxWrapField<T> extends TxField<T> {
  TxWrapField({
    required WrapWidgetBuilder<T> itemBuilder,
    required int itemCount,
    double? spacing,
    double? runSpacing,
    WrapAlignment? alignment,
    WrapAlignment? runAlignment,
    WrapCrossAlignment? crossAxisAlignment,
    super.key,
    super.initialValue,
    super.decoration,
    super.focusNode,
    super.enabled,
    super.onChanged,
  }) : super(
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

/// field 为 [TxWrapField] 的 [TxFieldTile]。
///
/// 通常用于多个选择组件，如 Checkbox、Radio、Chip 等。
class TxWrapFieldTile<T> extends TxFieldTile<T> {
  TxWrapFieldTile({
    required WrapWidgetBuilder<T> itemBuilder,
    required int itemCount,
    super.initialValue,
    super.onChanged,
    super.decoration,
    super.focusNode,
    super.enabled,
    double? spacing,
    double? runSpacing,
    WrapAlignment? alignment,
    WrapAlignment? runAlignment,
    WrapCrossAlignment? crossAxisAlignment,
    super.key,
    super.labelBuilder,
    super.labelText,
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
  }) : super(
          textAlign: alignment == WrapAlignment.center
              ? TextAlign.center
              : alignment == WrapAlignment.end
                  ? TextAlign.right
                  : alignment == WrapAlignment.start || alignment == null
                      ? TextAlign.left
                      : TextAlign.justify,
          fieldBuilder: (field) => Wrap(
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