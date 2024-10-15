import 'package:flutter/material.dart';

import '../utils/basic_types.dart';
import '../widgets/radio_cell.dart';
import 'picker_field.dart';
import 'wrap_field.dart';

/// Radio 单项选择框
class TxRadioField<T, V> extends TxWrapField<T> {
  /// 创建一个默认的复选域
  ///
  /// [source] 和 [labelMapper] 必传
  TxRadioField({
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
    super.enabled,
    super.key,
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
    TextStyle? labelStyle,
    Color? textColor,
    bool? useCupertinoCheckmarkStyle,
  }) : super(
          itemBuilder: (context, index, data, onChanged) {
            final item = source[index];

            final bool effectiveEnabled = enabled != false &&
                (enabledMapper == null ? true : enabledMapper(index, item));

            void onChangedHandler(T? val) {
              if (val != null && val != data) {
                onChanged(val);
              }
            }

            return TxRadioCell<T>(
              label: Text(labelMapper(item)),
              value: item,
              groupValue: data,
              onChanged: effectiveEnabled ? onChangedHandler : null,
              mouseCursor: mouseCursor,
              activeColor: activeColor,
              fillColor: fillColor,
              focusColor: focusColor,
              hoverColor: hoverColor,
              overlayColor: overlayColor,
              splashRadius: splashRadius,
              materialTapTargetSize: materialTapTargetSize,
              controlAffinity: controlAffinity,
              padding: cellPadding,
              toggleable: toggleableMapper == null
                  ? null
                  : toggleableMapper(index, item),
              useCupertinoCheckmarkStyle: useCupertinoCheckmarkStyle,
              shape: cellShape,
              labelStyle: labelStyle,
              textColor: textColor,
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

/// [field] 为 Radio 单项选择框的 [TxWrapFieldTile]
class TxRadioFieldTile<T, V> extends TxWrapFieldTile {
  TxRadioFieldTile({
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
  }) : super(
          field: TxRadioField(
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
            controlAffinity: controlAffinity,
            cellPadding: cellPadding,
            toggleableMapper: toggleableMapper,
            cellShape: cellShape,
            labelStyle: cellLabelStyle,
            textColor: textColor,
            useCupertinoCheckmarkStyle: useCupertinoCheckmarkStyle,
          ),
        );
}
