import 'package:flutter/material.dart';

import '../utils/basic_types.dart';
import 'picker_form_field.dart';
import 'wrap_field.dart';

/// 单项选择框表单
class TxRadioFormField<T, V> extends TxWrapFormField<T> {
  TxRadioFormField({
    required List<T> source,
    required ValueMapper<T, String?> labelMapper,
    ValueMapper<T, V?>? valueMapper,
    ValueMapper<T, bool>? disabledWhen,
    T? initialData,
    V? initialValue,
    double? spacing,
    double? runSpacing,
    WrapAlignment? alignment,
    WrapAlignment? runAlignment,
    WrapCrossAlignment? crossAxisAlignment,
    FocusNode? focusNode,
    super.key,
    super.onSaved,
    FormFieldValidator<T>? validator,
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    super.decoration,
    super.onChanged,
    super.required,
    super.bordered = false,
    IndexedValueMapper<T, Widget>? avatarBuilder,
    IndexedValueMapper<T, String>? tooltipMapper,
    super.label,
    super.labelText,
    super.labelTextAlign,
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
  }) : super(
          runSpacing: runSpacing ?? 8.0,
          spacing: spacing ?? 8.0,
          alignment: alignment ?? WrapAlignment.end,
          runAlignment: runAlignment ?? WrapAlignment.end,
          crossAxisAlignment: crossAxisAlignment ?? WrapCrossAlignment.end,
          itemBuilder: (field, index, data, onChanged) {
            final item = source[index];
            return _ChipItem<T>(
              index: index,
              item: item,
              selected: field.value == item,
              labelMapper: labelMapper,
              enabled: field.isEnabled,
              onChanged: field.didChange,
              disabledWhen: disabledWhen,
              avatarBuilder: avatarBuilder,
            );
          },
          itemCount: source.length,
          initialValue: TxPickerFormField.initData<T, V>(
            source,
            initialData,
            initialValue,
            valueMapper,
          ),
          validator: (value) => TxPickerFormField.generateValidator<T>(
            value,
            validator,
            required,
          ),
        );
}

class _ChipItem<T> extends StatelessWidget {
  const _ChipItem({
    required this.index,
    required this.item,
    required this.selected,
    required this.labelMapper,
    required this.enabled,
    required this.onChanged,
    this.disabledWhen,
    this.avatarBuilder,
    this.tooltipMapper,
    super.key,
  });

  final int index;
  final T item;
  final bool selected;
  final ValueMapper<T, String?> labelMapper;
  final ValueMapper<T, bool>? disabledWhen;
  final IndexedValueMapper<T, Widget>? avatarBuilder;
  final IndexedValueMapper<T, String>? tooltipMapper;
  final bool enabled;
  final ValueChanged<T> onChanged;

  void onChangedHandler(bool? val) {
    if (!selected) {
      onChanged(item);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool effectiveEnabled = enabled != false &&
        (disabledWhen == null ? true : !disabledWhen!(item));

    final OutlinedBorder shape = ChipTheme.of(context).shape ??
        StadiumBorder(
          side: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        );

    return ChoiceChip(
      label: Text(labelMapper(item) ?? ''),
      avatar: avatarBuilder == null ? null : avatarBuilder!(index, item),
      onSelected: effectiveEnabled ? onChangedHandler : null,
      selected: selected,
      tooltip: tooltipMapper == null ? null : tooltipMapper!(index, item),
      shape: shape,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      showCheckmark: false,
    );
  }
}
