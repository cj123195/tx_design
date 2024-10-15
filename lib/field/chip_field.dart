import 'package:flutter/material.dart';

import '../utils/basic_types.dart';
import 'multi_picker_field.dart';
import 'wrap_field.dart';

/// Chip 选择框组件
class TxChipField<T, V> extends TxWrapField<List<T>> {
  /// 创建一个默认的复选域
  ///
  /// [source] 和 [labelMapper] 必传
  TxChipField({
    required List<T> source,
    required ValueMapper<T, String> labelMapper,
    ValueMapper<T, V?>? valueMapper,
    IndexedValueMapper<T, bool>? enabledMapper,
    List<T>? initialData,
    List<V>? initialValue,
    int? minCount,
    int? maxCount,
    super.key,
    super.decoration,
    super.focusNode,
    super.enabled,
    super.onChanged,
    IndexedValueMapper<T, Widget>? avatarBuilder,
    TextStyle? labelStyle,
    EdgeInsetsGeometry? labelPadding,
    double? pressElevation,
    Color? selectedColor,
    Color? disabledColor,
    IndexedValueMapper<T, String>? tooltipMapper,
    BorderSide? chipSide,
    OutlinedBorder? chipShape,
    Clip? clipBehavior,
    MaterialStateProperty<Color?>? chipColor,
    Color? chipBackgroundColor,
    EdgeInsetsGeometry? chipPadding,
    VisualDensity? visualDensity,
    MaterialTapTargetSize? materialTapTargetSize,
    double? elevation,
    Color? shadowColor,
    Color? surfaceTintColor,
    IconThemeData? iconTheme,
    Color? selectedShadowColor,
    bool? showCheckmark,
    Color? checkmarkColor,
    ShapeBorder? avatarBorder,
    double? runSpacing,
    double? spacing,
    super.alignment,
    super.runAlignment,
    super.crossAxisAlignment,
  })  : assert(minCount == null || maxCount == null || maxCount > minCount),
        super(
          runSpacing: runSpacing ?? 8.0,
          spacing: spacing ?? 8.0,
          itemBuilder: (field, index, data, onChanged) => _ChipItem(
            index: index,
            item: source[index],
            data: data,
            labelMapper: labelMapper,
            enabled: field.isEnabled,
            onChanged: field.didChange,
            enabledMapper: enabledMapper,
            avatarBuilder: avatarBuilder,
            minCount: minCount,
            maxCount: maxCount,
            tooltipMapper: tooltipMapper,
            labelStyle: labelStyle,
            labelPadding: labelPadding,
            avatarBorder: avatarBorder,
            pressElevation: pressElevation,
            selectedColor: selectedColor,
            disabledColor: disabledColor,
            side: chipSide,
            shape: chipShape,
            clipBehavior: clipBehavior,
            color: chipColor,
            backgroundColor: chipBackgroundColor,
            padding: chipPadding,
            visualDensity: visualDensity,
            materialTapTargetSize: materialTapTargetSize,
            elevation: elevation,
            shadowColor: shadowColor,
            surfaceTintColor: surfaceTintColor,
            iconTheme: iconTheme,
            selectedShadowColor: selectedShadowColor,
            showCheckmark: showCheckmark,
            checkmarkColor: checkmarkColor,
          ),
          itemCount: source.length,
          initialValue: TxMultiPickerField.initData<T, V>(
            source,
            initialData,
            initialValue,
            valueMapper,
          ),
        );
}

/// field 为 [TxChipField] 的 [TxWrapFieldTile]
class TxChipFieldTile<T, V> extends TxWrapFieldTile<List<T>> {
  TxChipFieldTile({
    required List<T> source,
    required ValueMapper<T, String> labelMapper,
    ValueMapper<T, V?>? valueMapper,
    IndexedValueMapper<T, bool>? enabledMapper,
    List<T>? initialData,
    List<V>? initialValue,
    int? minCount,
    int? maxCount,
    super.key,
    super.decoration,
    super.focusNode,
    super.enabled,
    super.onChanged,
    super.runSpacing = 8.0,
    super.spacing = 8.0,
    super.alignment,
    super.runAlignment,
    super.crossAxisAlignment,
    IndexedValueMapper<T, Widget>? avatarBuilder,
    TextStyle? chipLabelStyle,
    EdgeInsetsGeometry? chipLabelPadding,
    double? pressElevation,
    Color? selectedColor,
    Color? disabledColor,
    IndexedValueMapper<T, String>? tooltipMapper,
    BorderSide? chipSide,
    OutlinedBorder? chipShape,
    Clip? clipBehavior,
    MaterialStateProperty<Color?>? chipColor,
    Color? chipBackgroundColor,
    EdgeInsetsGeometry? chipPadding,
    MaterialTapTargetSize? materialTapTargetSize,
    double? elevation,
    Color? shadowColor,
    Color? surfaceTintColor,
    IconThemeData? iconTheme,
    Color? selectedShadowColor,
    bool? showCheckmark,
    Color? checkmarkColor,
    ShapeBorder? avatarBorder,
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
          itemBuilder: (field, index, data, onChanged) => _ChipItem(
            index: index,
            item: source[index],
            data: data,
            labelMapper: labelMapper,
            enabled: field.isEnabled,
            onChanged: field.didChange,
            enabledMapper: enabledMapper,
            avatarBuilder: avatarBuilder,
            minCount: minCount,
            maxCount: maxCount,
            tooltipMapper: tooltipMapper,
            labelStyle: chipLabelStyle,
            labelPadding: chipLabelPadding,
            avatarBorder: avatarBorder,
            pressElevation: pressElevation,
            selectedColor: selectedColor,
            disabledColor: disabledColor,
            side: chipSide,
            shape: chipShape,
            clipBehavior: clipBehavior,
            color: chipColor,
            backgroundColor: chipBackgroundColor,
            padding: chipPadding,
            visualDensity: visualDensity,
            materialTapTargetSize: materialTapTargetSize,
            elevation: elevation,
            shadowColor: shadowColor,
            surfaceTintColor: surfaceTintColor,
            iconTheme: iconTheme,
            selectedShadowColor: selectedShadowColor,
            showCheckmark: showCheckmark,
            checkmarkColor: checkmarkColor,
          ),
          itemCount: source.length,
          initialValue: TxMultiPickerField.initData<T, V>(
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
    required this.data,
    required this.labelMapper,
    required this.enabled,
    required this.onChanged,
    this.enabledMapper,
    this.avatarBuilder,
    this.minCount,
    this.maxCount,
    super.key,
    this.labelStyle,
    this.labelPadding,
    this.pressElevation,
    this.selectedColor,
    this.disabledColor,
    this.tooltipMapper,
    this.side,
    this.shape,
    this.clipBehavior,
    this.color,
    this.backgroundColor,
    this.padding,
    this.visualDensity,
    this.materialTapTargetSize,
    this.elevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.iconTheme,
    this.selectedShadowColor,
    this.showCheckmark,
    this.checkmarkColor,
    this.avatarBorder,
  });

  final int index;
  final T item;
  final List<T>? data;
  final ValueMapper<T, String> labelMapper;
  final IndexedValueMapper<T, bool>? enabledMapper;
  final IndexedValueMapper<T, Widget>? avatarBuilder;
  final int? minCount;
  final int? maxCount;
  final bool enabled;
  final ValueChanged<List<T>?> onChanged;
  final TextStyle? labelStyle;
  final EdgeInsetsGeometry? labelPadding;
  final double? pressElevation;
  final Color? selectedColor;
  final Color? disabledColor;
  final IndexedValueMapper<T, String>? tooltipMapper;
  final BorderSide? side;
  final OutlinedBorder? shape;
  final Clip? clipBehavior;
  final MaterialStateProperty<Color?>? color;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final VisualDensity? visualDensity;
  final MaterialTapTargetSize? materialTapTargetSize;
  final double? elevation;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final IconThemeData? iconTheme;
  final Color? selectedShadowColor;
  final bool? showCheckmark;
  final Color? checkmarkColor;
  final ShapeBorder? avatarBorder;

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
    bool effectiveEnabled = enabled != false &&
        (enabledMapper == null ? true : enabledMapper!(index, item));
    if (minCount != null) {
      effectiveEnabled =
          effectiveEnabled && (!selected || data!.length > minCount!);
    }

    if (maxCount != null) {
      effectiveEnabled =
          effectiveEnabled && (selected || (data?.length ?? 0) < maxCount!);
    }

    return ChoiceChip(
      label: Text(labelMapper(item)),
      labelStyle: labelStyle,
      labelPadding: labelPadding,
      avatar: avatarBuilder == null ? null : avatarBuilder!(index, item),
      avatarBorder: avatarBorder ?? const CircleBorder(),
      onSelected: effectiveEnabled ? onChangedHandler : null,
      pressElevation: pressElevation,
      selected: selected,
      selectedColor: selectedColor,
      disabledColor: disabledColor,
      tooltip: tooltipMapper == null ? null : tooltipMapper!(index, item),
      side: side,
      shape: shape,
      clipBehavior: clipBehavior ?? Clip.none,
      color: color,
      backgroundColor: backgroundColor,
      padding: padding,
      visualDensity: visualDensity,
      materialTapTargetSize: materialTapTargetSize,
      elevation: elevation,
      shadowColor: shadowColor,
      surfaceTintColor: surfaceTintColor,
      iconTheme: iconTheme,
      selectedShadowColor: selectedShadowColor,
      showCheckmark: showCheckmark ?? false,
      checkmarkColor: checkmarkColor,
    );
  }
}
