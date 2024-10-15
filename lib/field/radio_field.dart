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
    super.key,
    super.decoration,
    super.focusNode,
    super.enabled,
    super.onChanged,
    ValueMapper<T, V?>? valueMapper,
    IndexedValueMapper<T, bool>? enabledMapper,
    T? initialData,
    V? initialValue,
    super.runSpacing,
    super.spacing,
    super.alignment,
    super.runAlignment,
    super.crossAxisAlignment,
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

/// field 为 Radio 单项选择框的 [TxWrapFieldTile]
class TxRadioFieldTile<T, V> extends TxWrapFieldTile<T> {
  TxRadioFieldTile({
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
    super.runSpacing,
    super.spacing,
    super.alignment,
    super.runAlignment,
    super.crossAxisAlignment,
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
    Color? cellTextColor,
    bool? useCupertinoCheckmarkStyle,
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
              labelStyle: cellLabelStyle,
              textColor: cellTextColor,
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
