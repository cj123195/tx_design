import 'package:flutter/material.dart';

import '../utils/basic_types.dart';
import 'picker_field.dart';
import 'wrap_field.dart';

/// Radio 单项选择框
class TxRadioField<T, V> extends TxWrapField<T> {
  TxRadioField({
    required List<T> source,
    required ValueMapper<T, String> labelMapper,
    super.key,
    super.decoration,
    super.focusNode,
    super.enabled,
    super.onChanged,
    ValueMapper<T, V?>? valueMapper,
    IndexedValueMapper<T, bool>? enabledMapper,
    T? initialData,
    V? initialValue,
    double? runSpacing,
    double? spacing,
    super.alignment,
    super.runAlignment,
    super.crossAxisAlignment,
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
          itemBuilder: (field, index, data, onChanged) {
            final item = source[index];
            return _ChipItem<T>(
              index: index,
              item: item,
              selected: field.value == item,
              labelMapper: labelMapper,
              enabled: field.isEnabled,
              onChanged: field.didChange,
              enabledMapper: enabledMapper,
              avatarBuilder: avatarBuilder,
            );
          },
          itemCount: source.length,
          initialValue: TxPickerField.initData<T, V>(
            source,
            initialData,
            initialValue,
            valueMapper,
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
    this.enabledMapper,
    this.avatarBuilder,
    this.tooltipMapper,
    super.key,
  });

  final int index;
  final T item;
  final bool selected;
  final ValueMapper<T, String> labelMapper;
  final IndexedValueMapper<T, bool>? enabledMapper;
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
        (enabledMapper == null ? true : enabledMapper!(index, item));

    final OutlinedBorder shape = ChipTheme.of(context).shape ??
        StadiumBorder(
          side: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        );

    return ChoiceChip(
      label: Text(labelMapper(item)),
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
