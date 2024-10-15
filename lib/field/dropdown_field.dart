import 'package:flutter/material.dart';

import '../localizations.dart';
import '../utils/basic_types.dart';
import 'field_theme.dart';
import 'field_tile.dart';
import 'picker_field.dart';

/// [field] 为下拉选择框的 [TxFieldTile]
class TxDropdownFieldTile<T, V> extends TxFieldTile {
  TxDropdownFieldTile({
    required List<T> source,
    required ValueMapper<T, String?> labelMapper,
    super.key,
    ValueMapper<T, V?>? valueMapper,
    IndexedValueMapper<T, bool>? enabledMapper,
    T? initialData,
    V? initialValue,
    DropdownButtonBuilder? selectedItemBuilder,
    Widget? hint,
    Widget? disabledHint,
    ValueChanged<T?>? onChanged,
    int? elevation,
    TextStyle? style,
    Widget? icon,
    Color? iconDisabledColor,
    Color? iconEnabledColor,
    double? iconSize,
    bool? isDense,
    bool? isExpanded,
    double? itemHeight,
    Color? focusColor,
    FocusNode? focusNode,
    bool? autofocus,
    Color? dropdownColor,
    InputDecoration? decoration,
    double? menuMaxHeight,
    bool? enableFeedback,
    AlignmentGeometry alignment = AlignmentDirectional.centerStart,
    BorderRadius? borderRadius,
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
    super.enabled = true,
    super.onTap,
    super.minLeadingWidth,
    super.dense,
    super.minLabelWidth,
    super.minVerticalPadding,
  }) : super(
          field: TxDropdownField<T, V>(
            source: source,
            labelMapper: labelMapper,
            valueMapper: valueMapper,
            enabledMapper: enabledMapper,
            initialData: initialData,
            selectedItemBuilder: selectedItemBuilder,
            initialValue: initialValue,
            hint: hint,
            onChanged: onChanged,
            elevation: elevation,
            style: style,
            icon: icon,
            iconDisabledColor: iconDisabledColor,
            iconEnabledColor: iconEnabledColor,
            iconSize: iconSize,
            isDense: isDense,
            isExpanded: isExpanded,
            itemHeight: itemHeight,
            focusColor: focusColor,
            focusNode: focusNode,
            autofocus: autofocus,
            dropdownColor: dropdownColor,
            decoration: decoration,
            menuMaxHeight: menuMaxHeight,
            enableFeedback: enableFeedback,
            alignment: alignment,
            borderRadius: borderRadius,
          ),
        );

  TxDropdownFieldTile.custom({
    required List<DropdownMenuItem<T>>? items,
    T? initialValue,
    super.key,
    DropdownButtonBuilder? selectedItemBuilder,
    Widget? hint,
    Widget? disabledHint,
    ValueChanged<T?>? onChanged,
    int? elevation,
    TextStyle? style,
    Widget? icon,
    Color? iconDisabledColor,
    Color? iconEnabledColor,
    double? iconSize,
    bool? isDense,
    bool? isExpanded,
    double? itemHeight,
    Color? focusColor,
    FocusNode? focusNode,
    bool? autofocus,
    Color? dropdownColor,
    InputDecoration? decoration,
    double? menuMaxHeight,
    bool? enableFeedback,
    AlignmentGeometry alignment = AlignmentDirectional.centerStart,
    BorderRadius? borderRadius,
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
    super.enabled = true,
    super.onTap,
    super.minLeadingWidth,
    super.dense,
    super.minLabelWidth,
    super.minVerticalPadding,
  }) : super(
          field: TxDropdownField<T, V>.custom(
            items: items,
            selectedItemBuilder: selectedItemBuilder,
            initialValue: initialValue,
            hint: hint,
            onChanged: onChanged,
            elevation: elevation,
            style: style,
            icon: icon,
            iconDisabledColor: iconDisabledColor,
            iconEnabledColor: iconEnabledColor,
            iconSize: iconSize,
            isDense: isDense,
            isExpanded: isExpanded,
            itemHeight: itemHeight,
            focusColor: focusColor,
            focusNode: focusNode,
            autofocus: autofocus,
            dropdownColor: dropdownColor,
            decoration: decoration,
            menuMaxHeight: menuMaxHeight,
            enableFeedback: enableFeedback,
            alignment: alignment,
            borderRadius: borderRadius,
          ),
        );
}

/// 下拉选择框
class TxDropdownField<T, V> extends StatefulWidget {
  TxDropdownField({
    required List<T> source,
    required ValueMapper<T, String?> labelMapper,
    ValueMapper<T, V?>? valueMapper,
    IndexedValueMapper<T, bool>? enabledMapper,
    T? initialData,
    V? initialValue,
    super.key,
    this.hint,
    this.disabledHint,
    this.onChanged,
    this.onTap,
    this.elevation,
    this.style,
    this.icon,
    this.iconDisabledColor,
    this.iconEnabledColor,
    this.iconSize,
    this.isDense,
    this.isExpanded,
    this.itemHeight,
    this.focusColor,
    this.focusNode,
    this.autofocus,
    this.dropdownColor,
    this.decoration,
    this.menuMaxHeight,
    this.enableFeedback,
    AlignmentGeometry this.alignment = AlignmentDirectional.centerStart,
    this.borderRadius,
    this.padding,
    this.selectedItemBuilder,
    this.enabled,
  })  : initialValue = TxPickerField.initData(
            source, initialData, initialValue, valueMapper),
        items = List.generate(
          source.length,
          (i) {
            final T item = source[i];
            return DropdownMenuItem<T>(
              value: item,
              alignment: alignment,
              enabled: enabledMapper == null ? true : enabledMapper(i, item),
              child: Text(labelMapper(item) ?? ''),
            );
          },
        ),
        onSaved = null,
        validator = null,
        autovalidateMode = null,
        required = null;

  TxDropdownField.form({
    required List<T> source,
    required ValueMapper<T, String?> labelMapper,
    ValueMapper<T, V?>? valueMapper,
    IndexedValueMapper<T, bool>? enabledMapper,
    T? initialData,
    V? initialValue,
    super.key,
    this.hint,
    this.disabledHint,
    this.onChanged,
    this.onTap,
    this.elevation,
    this.style,
    this.icon,
    this.iconDisabledColor,
    this.iconEnabledColor,
    this.iconSize,
    this.isDense,
    this.isExpanded,
    this.itemHeight,
    this.focusColor,
    this.focusNode,
    this.autofocus,
    this.dropdownColor,
    this.decoration,
    this.menuMaxHeight,
    this.enableFeedback,
    AlignmentGeometry this.alignment = AlignmentDirectional.centerStart,
    this.borderRadius,
    this.padding,
    this.selectedItemBuilder,
    this.enabled,
    this.onSaved,
    this.validator,
    this.autovalidateMode,
    this.required,
  })  : initialValue = TxPickerField.initData(
            source, initialData, initialValue, valueMapper),
        items = List.generate(
          source.length,
          (i) {
            final T item = source[i];
            return DropdownMenuItem<T>(
              value: item,
              alignment: alignment,
              enabled: enabledMapper == null ? true : enabledMapper(i, item),
              child: Text(labelMapper(item) ?? ''),
            );
          },
        );

  /// 自定义下拉选择框
  const TxDropdownField.custom({
    required this.items,
    super.key,
    this.selectedItemBuilder,
    this.initialValue,
    this.hint,
    this.disabledHint,
    this.onChanged,
    this.onTap,
    this.elevation,
    this.style,
    this.icon,
    this.iconDisabledColor,
    this.iconEnabledColor,
    this.iconSize,
    this.isDense,
    this.isExpanded,
    this.itemHeight,
    this.focusColor,
    this.focusNode,
    this.autofocus,
    this.dropdownColor,
    this.decoration,
    this.menuMaxHeight,
    this.enableFeedback,
    this.alignment,
    this.borderRadius,
    this.padding,
    this.enabled,
  })  : onSaved = null,
        validator = null,
        autovalidateMode = null,
        required = null;

  const TxDropdownField.customForm({
    required this.items,
    super.key,
    this.selectedItemBuilder,
    this.initialValue,
    this.hint,
    this.disabledHint,
    this.onChanged,
    this.onTap,
    this.elevation,
    this.style,
    this.icon,
    this.iconDisabledColor,
    this.iconEnabledColor,
    this.iconSize,
    this.isDense,
    this.isExpanded,
    this.itemHeight,
    this.focusColor,
    this.focusNode,
    this.autofocus,
    this.dropdownColor,
    this.decoration,
    this.menuMaxHeight,
    this.enableFeedback,
    this.alignment,
    this.borderRadius,
    this.padding,
    this.enabled,
    this.onSaved,
    this.validator,
    this.autovalidateMode,
    this.required,
  });

  final List<DropdownMenuItem<T>>? items;
  final DropdownButtonBuilder? selectedItemBuilder;
  final T? initialValue;
  final Widget? hint;
  final Widget? disabledHint;
  final ValueChanged<T?>? onChanged;
  final VoidCallback? onTap;
  final int? elevation;
  final TextStyle? style;
  final Widget? icon;
  final Color? iconDisabledColor;
  final Color? iconEnabledColor;
  final double? iconSize;
  final bool? isDense;
  final bool? isExpanded;
  final double? itemHeight;
  final Color? focusColor;
  final FocusNode? focusNode;
  final bool? autofocus;
  final Color? dropdownColor;
  final InputDecoration? decoration;
  final double? menuMaxHeight;
  final bool? enableFeedback;
  final AlignmentGeometry? alignment;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final bool? enabled;
  final FormFieldSetter<T>? onSaved;
  final FormFieldValidator<T>? validator;
  final AutovalidateMode? autovalidateMode;
  final bool? required;

  @override
  State<TxDropdownField<T, V>> createState() => _TxDropdownFieldState<T, V>();
}

class _TxDropdownFieldState<T, V> extends State<TxDropdownField<T, V>> {
  bool get _isEnabled => widget.enabled ?? widget.decoration?.enabled ?? true;

  /// 最终生效的验证器
  String? _effectiveValidator(T? value) {
    if (widget.required == true && value == null) {
      return TxLocalizations.of(context).pickerFormFieldHint;
    }
    if (widget.validator != null) {
      return widget.validator!(value);
    }
    return null;
  }

  /// 最终生效的装饰器
  InputDecoration get _effectiveDecoration {
    final InputDecorationTheme inputDecorationTheme =
        TxFieldTheme.of(context).inputDecorationTheme ??
            Theme.of(context).inputDecorationTheme.copyWith(
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                );
    final String hintText = widget.decoration?.hintText ??
        TxLocalizations.of(context).pickerFormFieldHint;
    return (widget.decoration ?? const InputDecoration())
        .applyDefaults(inputDecorationTheme)
        .copyWith(enabled: _isEnabled, hintText: hintText);
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      items: widget.items,
      selectedItemBuilder: widget.selectedItemBuilder,
      value: widget.initialValue,
      hint: widget.hint,
      onChanged: widget.onChanged,
      onTap: widget.onTap,
      elevation: widget.elevation ?? 0,
      style: widget.style,
      icon: widget.icon,
      iconDisabledColor: widget.iconDisabledColor,
      iconEnabledColor: widget.iconEnabledColor,
      iconSize: widget.iconSize ?? 24.0,
      isDense: widget.isDense ?? true,
      isExpanded: widget.isExpanded ?? false,
      itemHeight: widget.itemHeight,
      focusColor: widget.focusColor,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus ?? false,
      dropdownColor: widget.dropdownColor,
      decoration: _effectiveDecoration,
      menuMaxHeight: widget.menuMaxHeight,
      enableFeedback: widget.enableFeedback,
      alignment: widget.alignment ?? AlignmentDirectional.centerStart,
      borderRadius: widget.borderRadius,
      padding: widget.padding,
      validator: _effectiveValidator,
      onSaved: widget.onSaved,
      autovalidateMode: widget.autovalidateMode,
    );
  }
}
