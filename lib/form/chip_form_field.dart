import 'package:flutter/material.dart';

import '../field/chip_field.dart';
import '../field/multi_picker_field.dart';
import '../utils/basic_types.dart';
import 'form_field.dart';
import 'form_field_tile.dart';
import 'multi_picker_form_field.dart';
import 'wrap_form_field.dart';

/// [builder] 构建的组件为 [TxChipField] 的 [TxWrapFormField]
class TxChipFormField<T, V> extends TxFormField<List<T>> {
  TxChipFormField({
    required List<T> source,
    required ValueMapper<T, String> labelMapper,
    ValueMapper<T, V?>? valueMapper,
    IndexedValueMapper<T, bool>? enabledMapper,
    List<T>? initialData,
    List<V>? initialValue,
    int? minCount,
    int? maxCount,
    double? spacing,
    double? runSpacing,
    WrapAlignment? alignment,
    WrapAlignment? runAlignment,
    WrapCrossAlignment? crossAxisAlignment,
    FocusNode? focusNode,
    super.key,
    super.onSaved,
    FormFieldValidator<List<T>>? validator,
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    super.decoration,
    super.onChanged,
    super.required,
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
  }) : super(
          builder: (field) {
            return UnmanagedRestorationScope(
              bucket: field.bucket,
              child: TxChipField(
                source: source,
                valueMapper: valueMapper,
                enabledMapper: enabledMapper,
                initialData: field.value,
                minCount: minCount,
                maxCount: maxCount,
                onChanged: field.didChange,
                runSpacing: runSpacing,
                spacing: spacing,
                decoration: field.effectiveDecoration,
                alignment: alignment,
                runAlignment: runAlignment,
                crossAxisAlignment: crossAxisAlignment,
                focusNode: focusNode,
                enabled: enabled,
                labelMapper: labelMapper,
                labelStyle: labelStyle,
                labelPadding: labelPadding,
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
          },
          initialValue: TxMultiPickerField.initData<T, V>(
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

/// field 为 [TxChipFormField] 的 [TxWrapFormFieldTile]
class TxChipFormFieldTile<T, V> extends TxFormFieldTile<List<T>> {
  TxChipFormFieldTile({
    required List<T> source,
    required ValueMapper<T, String> labelMapper,
    ValueMapper<T, V?>? valueMapper,
    IndexedValueMapper<T, bool>? enabledMapper,
    List<T>? initialData,
    List<V>? initialValue,
    int? minCount,
    int? maxCount,
    double? spacing,
    double? runSpacing,
    WrapAlignment? alignment,
    WrapAlignment? runAlignment,
    WrapCrossAlignment? crossAxisAlignment,
    FocusNode? focusNode,
    super.key,
    super.onSaved,
    FormFieldValidator<List<T>>? validator,
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    super.decoration,
    super.onChanged,
    super.required,
    IndexedValueMapper<T, Widget>? avatarBuilder,
    TextStyle? chipLabelStyle,
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
          fieldBuilder: (field) {
            return TxChipField(
              source: source,
              valueMapper: valueMapper,
              enabledMapper: enabledMapper,
              initialData: field.value,
              minCount: minCount,
              maxCount: maxCount,
              onChanged: field.didChange,
              runSpacing: runSpacing,
              spacing: spacing,
              decoration: field.effectiveDecoration,
              alignment: alignment,
              runAlignment: runAlignment,
              crossAxisAlignment: crossAxisAlignment,
              focusNode: focusNode,
              enabled: enabled,
              labelMapper: labelMapper,
              labelStyle: chipLabelStyle,
              labelPadding: labelPadding,
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
            );
          },
          initialValue: TxMultiPickerField.initData<T, V>(
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