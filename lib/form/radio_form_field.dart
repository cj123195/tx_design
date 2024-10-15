import 'package:flutter/material.dart';

import '../field/picker_field.dart';
import '../field/radio_field.dart';
import '../utils/basic_types.dart';
import 'picker_form_field.dart';
import 'wrap_form_field.dart';

/// Radio单选Form 组件
@Deprecated(
  'Use TxRadioFormFieldTile instead. '
  'This feature was deprecated after v0.3.0.',
)
class RadioFormField<T, V> extends TxRadioFormFieldTile<T, V> {
  @Deprecated(
    'Use TxRadioFormFieldTile instead. '
    'This feature was deprecated after v0.3.0.',
  )
  RadioFormField({
    required super.labelMapper,
    required List<T>? sources,
    super.initialData,
    super.valueMapper,
    super.enabledMapper,
    super.onChanged,
    super.key,
    super.onSaved,
    super.validator,
    super.initialValue,
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    super.required,
    Widget? label,
    super.labelText,
    Color? backgroundColor,
    Axis? direction,
    super.padding,
    super.actions,
    super.labelStyle,
    super.horizontalGap,
    super.minLabelWidth,
  }) : super(
          source: sources ?? [],
          labelBuilder: label == null ? null : (context) => label,
          tileColor: backgroundColor,
          layoutDirection: direction,
        );
}

/// [builder] 构建组件为 Radio 单项选择框的 [FormField]
class TxRadioFormField<T, V> extends TxWrapFormField<T> {
  TxRadioFormField({
    required List<T> source,
    required ValueMapper<T, String> labelMapper,
    ValueMapper<T, V?>? valueMapper,
    IndexedValueMapper<T, bool>? enabledMapper,
    T? initialData,
    V? initialValue,
    super.onChanged,
    super.runSpacing,
    super.spacing,
    super.decoration,
    super.alignment,
    super.runAlignment,
    super.crossAxisAlignment,
    super.focusNode,
    MouseCursor? mouseCursor,
    Color? activeColor,
    MaterialStateProperty<Color?>? fillColor,
    Color? focusColor,
    Color? hoverColor,
    MaterialStateProperty<Color?>? overlayColor,
    double? splashRadius,
    MaterialTapTargetSize? materialTapTargetSize,
    IndexedValueMapper<T, bool>? toggleableMapper,
    ListTileControlAffinity? controlAffinity,
    EdgeInsetsGeometry? cellPadding,
    ShapeBorder? cellShape,
    TextStyle? cellLabelStyle,
    bool? useCupertinoCheckmarkStyle,
    Color? textColor,
    super.key,
    super.onSaved,
    FormFieldValidator<T>? validator,
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    bool? required,
  }) : super(
          builder: (field) {
            void onChangedHandler(T? value) {
              field.didChange(value);
              onChanged?.call(value);
            }

            final InputDecoration effectiveDecoration =
                (decoration ?? const InputDecoration())
                    .copyWith(errorText: field.errorText);

            return UnmanagedRestorationScope(
              bucket: field.bucket,
              child: TxRadioField(
                source: source,
                labelMapper: labelMapper,
                valueMapper: valueMapper,
                enabledMapper: enabledMapper,
                initialData: field.value,
                onChanged: onChangedHandler,
                runSpacing: runSpacing,
                spacing: spacing,
                decoration: effectiveDecoration,
                alignment: alignment,
                runAlignment: runAlignment,
                crossAxisAlignment: crossAxisAlignment,
                focusNode: focusNode,
                enabled: enabled,
                mouseCursor: mouseCursor,
                activeColor: activeColor,
                fillColor: fillColor,
                focusColor: focusColor,
                hoverColor: hoverColor,
                overlayColor: overlayColor,
                splashRadius: splashRadius,
                materialTapTargetSize: materialTapTargetSize,
                controlAffinity: controlAffinity,
                cellPadding: cellPadding,
                cellShape: cellShape,
                labelStyle: cellLabelStyle,
                useCupertinoCheckmarkStyle: useCupertinoCheckmarkStyle,
                toggleableMapper: toggleableMapper,
                textColor: textColor,
              ),
            );
          },
          initialValue: TxPickerField.initData<T, V>(
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

/// [field] 为 Radio 单项选择框表单的 [TxWrapFormFieldTile]
class TxRadioFormFieldTile<T, V> extends TxWrapFormFieldTile<T> {
  TxRadioFormFieldTile({
    required List<T> source,
    required ValueMapper<T, String> labelMapper,
    ValueMapper<T, V?>? valueMapper,
    IndexedValueMapper<T, bool>? enabledMapper,
    T? initialData,
    V? initialValue,
    super.onChanged,
    super.runSpacing,
    super.spacing,
    super.decoration,
    super.alignment,
    super.runAlignment,
    super.crossAxisAlignment,
    super.focusNode,
    MouseCursor? mouseCursor,
    Color? activeColor,
    MaterialStateProperty<Color?>? fillColor,
    Color? focusColor,
    Color? hoverColor,
    MaterialStateProperty<Color?>? overlayColor,
    double? splashRadius,
    MaterialTapTargetSize? materialTapTargetSize,
    IndexedValueMapper<T, bool>? toggleableMapper,
    ListTileControlAffinity? controlAffinity,
    EdgeInsetsGeometry? cellPadding,
    ShapeBorder? cellShape,
    TextStyle? cellLabelStyle,
    bool? useCupertinoCheckmarkStyle,
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
  }) : super(
          field: TxRadioFormField<T, V>(
            source: source,
            labelMapper: labelMapper,
            valueMapper: valueMapper,
            enabledMapper: enabledMapper,
            initialData: initialData,
            initialValue: initialValue,
            onChanged: onChanged,
            runSpacing: runSpacing,
            spacing: spacing,
            decoration: decoration,
            alignment: alignment,
            runAlignment: runAlignment,
            crossAxisAlignment: crossAxisAlignment,
            focusNode: focusNode,
            enabled: enabled,
            mouseCursor: mouseCursor,
            activeColor: activeColor,
            fillColor: fillColor,
            focusColor: focusColor,
            hoverColor: hoverColor,
            overlayColor: overlayColor,
            splashRadius: splashRadius,
            materialTapTargetSize: materialTapTargetSize,
            cellPadding: cellPadding,
            controlAffinity: controlAffinity,
            cellLabelStyle: cellLabelStyle,
            cellShape: cellShape,
            toggleableMapper: toggleableMapper,
            useCupertinoCheckmarkStyle: useCupertinoCheckmarkStyle,
            textColor: textColor,
            onSaved: onSaved,
            validator: validator,
            required: required,
            autovalidateMode: autovalidateMode,
            restorationId: restorationId,
          ),
        );
}
