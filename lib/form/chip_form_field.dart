import 'package:flutter/material.dart';

import '../utils/basic_types.dart';
import 'multi_picker_form_field.dart';
import 'wrap_field.dart';

/// Chip 多选 Form 表单
class TxChipFormField<T, V> extends TxWrapFormField<List<T>> {
  TxChipFormField({
    required List<T> source,
    required ValueMapper<T, String?> labelMapper,
    ValueMapper<T, V?>? valueMapper,
    ValueMapper<T, bool>? disabledWhen,
    List<T>? initialData,
    List<V>? initialValue,
    int? minCount,
    int? maxCount,
    double? spacing,
    double? runSpacing,
    WrapAlignment? alignment,
    WrapAlignment? runAlignment,
    WrapCrossAlignment? crossAxisAlignment,
    super.focusNode,
    super.key,
    super.onSaved,
    FormFieldValidator<List<T>>? validator,
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
  }) : super(
          runSpacing: runSpacing ?? 8.0,
          spacing: spacing ?? 8.0,
          alignment: alignment,
          runAlignment: runAlignment,
          crossAxisAlignment: crossAxisAlignment,
          itemBuilder: (field, index, data, onChanged) => _ChipItem(
            index: index,
            item: source[index],
            data: data,
            labelMapper: labelMapper,
            enabled: field.isEnabled,
            onChanged: field.didChange,
            disabledWhen: disabledWhen,
            avatarBuilder: avatarBuilder,
            minCount: minCount,
            maxCount: maxCount,
            tooltipMapper: tooltipMapper,
          ),
          itemCount: source.length,
          initialValue: TxMultiPickerFormField.initData<T, V>(
            source,
            initialData,
            initialValue,
            valueMapper,
          ),
          validator: (value) => TxMultiPickerFormField.generateValidator<T>(
            value,
            validator,
            required,
            minCount,
            maxCount,
          ),
        );
}

class _ChipItem<T> extends StatelessWidget {
  const _ChipItem({
    required this.index,
    required this.item,
    required this.data,
    required this.labelMapper,
    required this.enabled,
    required this.onChanged,
    this.disabledWhen,
    this.avatarBuilder,
    this.minCount,
    this.maxCount,
    super.key,
    this.tooltipMapper,
  });

  final int index;
  final T item;
  final List<T>? data;
  final ValueMapper<T, String?> labelMapper;
  final ValueMapper<T, bool>? disabledWhen;
  final IndexedValueMapper<T, Widget>? avatarBuilder;
  final int? minCount;
  final int? maxCount;
  final bool enabled;
  final ValueChanged<List<T>?> onChanged;
  final IndexedValueMapper<T, String>? tooltipMapper;

  void onChangedHandler(bool? val) {
    if (val == true && data?.contains(item) != true) {
      onChanged([...?data, item]);
    } else if (val != true && data?.contains(item) == true) {
      onChanged([...data!]..remove(item));
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool selected = data == null ? false : data!.contains(item);
    bool effectiveEnabled =
        enabled && (disabledWhen == null ? true : !disabledWhen!(item));
    if (minCount != null) {
      effectiveEnabled =
          effectiveEnabled && (!selected || data!.length > minCount!);
    }

    if (maxCount != null) {
      effectiveEnabled =
          effectiveEnabled && (selected || (data?.length ?? 0) < maxCount!);
    }

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
