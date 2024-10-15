import 'package:flutter/material.dart';

import '../utils/basic_types.dart';
import 'multi_picker_field.dart';
import 'wrap_field.dart';

/// [field] 为 [TxChipField] 的 [TxWrapFieldTile]
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
    super.onChanged,
    super.runSpacing,
    super.spacing,
    super.alignment,
    super.runAlignment,
    super.crossAxisAlignment,
    super.decoration,
    super.focusNode,
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
  }) : super(
          field: TxChipField(
            source: source,
            valueMapper: valueMapper,
            enabledMapper: enabledMapper,
            initialData: initialData,
            initialValue: initialValue,
            minCount: minCount,
            maxCount: maxCount,
            onChanged: onChanged,
            runSpacing: runSpacing,
            spacing: spacing,
            decoration: decoration,
            alignment: alignment,
            runAlignment: runAlignment,
            crossAxisAlignment: crossAxisAlignment,
            focusNode: focusNode,
            enabled: enabled,
            avatarBuilder: avatarBuilder,
            avatarBorder: avatarBorder,
            labelMapper: labelMapper,
            labelStyle: chipLabelStyle,
            labelPadding: chipLabelPadding,
            pressElevation: pressElevation,
            selectedColor: selectedColor,
            disabledColor: disabledColor,
            tooltipMapper: tooltipMapper,
            chipSide: chipSide,
            chipShape: chipShape,
            clipBehavior: clipBehavior,
            chipColor: chipColor,
            chipBackgroundColor: chipBackgroundColor,
            chipPadding: chipPadding,
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
        );
}

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
    super.onChanged,
    double? runSpacing,
    double? spacing,
    super.decoration,
    super.alignment,
    super.runAlignment,
    super.crossAxisAlignment,
    super.focusNode,
    super.enabled,
    super.key,
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
  })  : assert(minCount == null || maxCount == null || maxCount > minCount),
        super(
          itemBuilder: (context, index, data, onChanged) {
            final item = source[index];

            final bool selected = data == null ? false : data.contains(item);
            bool effectiveEnabled = enabled != false &&
                (enabledMapper == null ? true : enabledMapper(index, item));
            if (minCount != null) {
              effectiveEnabled =
                  effectiveEnabled && (!selected || data.length > minCount);
            }

            if (maxCount != null) {
              effectiveEnabled = effectiveEnabled &&
                  (selected || (data?.length ?? 0) < maxCount);
            }

            void onChangedHandler(bool? val) {
              if (val == true && data?.contains(item) != true) {
                onChanged([...?data, item]);
              } else if (val != true && data?.contains(item) == true) {
                onChanged([...data!]..remove(item));
              }
            }

            return ChoiceChip(
              label: Text(labelMapper(item)),
              labelStyle: labelStyle,
              labelPadding: labelPadding,
              avatar: avatarBuilder == null ? null : avatarBuilder(index, item),
              avatarBorder: avatarBorder ?? const CircleBorder(),
              onSelected: effectiveEnabled ? onChangedHandler : null,
              pressElevation: pressElevation,
              selected: selected,
              selectedColor: selectedColor,
              disabledColor: disabledColor,
              tooltip:
                  tooltipMapper == null ? null : tooltipMapper(index, item),
              side: chipSide,
              shape: chipShape,
              clipBehavior: clipBehavior ?? Clip.none,
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
              showCheckmark: showCheckmark ?? false,
              checkmarkColor: checkmarkColor,
            );
          },
          itemCount: source.length,
          initialValue: TxMultiPickerField.initData<T, V>(
            source,
            initialData,
            initialValue,
            valueMapper,
          ),
          spacing: 8.0,
          runSpacing: 8.0,
        );
}
