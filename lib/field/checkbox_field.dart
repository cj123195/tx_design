import 'package:flutter/material.dart';

import '../utils/basic_types.dart';
import 'field.dart';
import 'multi_picker_field.dart';
import 'wrap_field.dart';

/// Checkbox 复选框组件
class TxCheckboxField<T, V> extends TxWrapField<List<T>> {
  /// 创建一个默认的复选域
  ///
  /// [source] 和 [labelMapper] 必传
  TxCheckboxField({
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
    MouseCursor? mouseCursor,
    Color? activeColor,
    MaterialStateProperty<Color?>? fillColor,
    Color? checkColor,
    Color? hoverColor,
    MaterialStateProperty<Color?>? overlayColor,
    double? splashRadius,
    MaterialTapTargetSize? materialTapTargetSize,
    IndexedValueMapper<T, bool>? errorMapper,
    ListTileControlAffinity? controlAffinity,
    EdgeInsetsGeometry? checkboxPadding,
    IndexedValueMapper<T, bool>? tristateMapper,
    OutlinedBorder? checkboxShape,
    IndexedValueMapper<T, String>? checkboxSemanticLabelMapper,
    BorderSide? checkboxSide,
    ShapeBorder? checkboxCellShape,
    TextStyle? labelStyle,
    Color? textColor,
    super.runSpacing,
    super.spacing,
    super.alignment,
    super.runAlignment,
    super.crossAxisAlignment,
  })  : assert(minCount == null || maxCount == null || maxCount > minCount),
        super(
          itemBuilder: (field, index, data, onChanged) => _buildCheckboxItem<T>(
            field: field,
            index: index,
            item: source[index],
            labelMapper: labelMapper,
            data: data,
            onChanged: onChanged,
            enabledMapper: enabledMapper,
            minCount: minCount,
            maxCount: maxCount,
            mouseCursor: mouseCursor,
            activeColor: activeColor,
            fillColor: fillColor,
            checkColor: checkColor,
            hoverColor: hoverColor,
            overlayColor: overlayColor,
            splashRadius: splashRadius,
            materialTapTargetSize: materialTapTargetSize,
            errorMapper: errorMapper,
            controlAffinity: controlAffinity,
            checkboxPadding: checkboxPadding,
            tristateMapper: tristateMapper,
            checkboxShape: checkboxShape,
            checkboxSemanticLabelMapper: checkboxSemanticLabelMapper,
            checkboxSide: checkboxSide,
            checkboxCellShape: checkboxCellShape,
            labelStyle: labelStyle,
            textColor: textColor,
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

/// builder 为 [TxCheckboxField] 的 [TxWrapFieldTile]
class TxCheckboxFieldTile<T, V> extends TxWrapFieldTile<List<T>> {
  TxCheckboxFieldTile({
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
    super.runSpacing,
    super.spacing,
    super.alignment,
    super.runAlignment,
    super.crossAxisAlignment,
    MouseCursor? mouseCursor,
    Color? activeColor,
    MaterialStateProperty<Color?>? fillColor,
    Color? checkColor,
    Color? hoverColor,
    MaterialStateProperty<Color?>? overlayColor,
    double? splashRadius,
    MaterialTapTargetSize? materialTapTargetSize,
    IndexedValueMapper<T, bool>? errorMapper,
    ListTileControlAffinity? controlAffinity,
    EdgeInsetsGeometry? checkboxPadding,
    IndexedValueMapper<T, bool>? tristateMapper,
    OutlinedBorder? checkboxShape,
    IndexedValueMapper<T, String>? checkboxSemanticLabelMapper,
    BorderSide? checkboxSide,
    ShapeBorder? checkboxCellShape,
    TextStyle? cellLabelStyle,
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
          itemBuilder: (field, index, data, onChanged) => _buildCheckboxItem<T>(
            field: field,
            index: index,
            item: source[index],
            labelMapper: labelMapper,
            data: data,
            onChanged: onChanged,
            enabledMapper: enabledMapper,
            minCount: minCount,
            maxCount: maxCount,
            mouseCursor: mouseCursor,
            activeColor: activeColor,
            fillColor: fillColor,
            checkColor: checkColor,
            hoverColor: hoverColor,
            overlayColor: overlayColor,
            splashRadius: splashRadius,
            materialTapTargetSize: materialTapTargetSize,
            errorMapper: errorMapper,
            controlAffinity: controlAffinity,
            checkboxPadding: checkboxPadding,
            tristateMapper: tristateMapper,
            checkboxShape: checkboxShape,
            checkboxSemanticLabelMapper: checkboxSemanticLabelMapper,
            checkboxSide: checkboxSide,
            checkboxCellShape: checkboxCellShape,
            labelStyle: labelStyle,
            textColor: textColor,
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

/// 构建复选框
Widget _buildCheckboxItem<T>({
  required TxFieldState<List<T>> field,
  required int index,
  required T item,
  required ValueMapper<T, String> labelMapper,
  required List<T>? data,
  required ValueChanged<List<T>> onChanged,
  required IndexedValueMapper<T, bool>? enabledMapper,
  required int? minCount,
  required int? maxCount,
  required MouseCursor? mouseCursor,
  required Color? activeColor,
  required MaterialStateProperty<Color?>? fillColor,
  required Color? checkColor,
  required Color? hoverColor,
  required MaterialStateProperty<Color?>? overlayColor,
  required double? splashRadius,
  required MaterialTapTargetSize? materialTapTargetSize,
  required IndexedValueMapper<T, bool>? errorMapper,
  required ListTileControlAffinity? controlAffinity,
  required EdgeInsetsGeometry? checkboxPadding,
  required IndexedValueMapper<T, bool>? tristateMapper,
  required OutlinedBorder? checkboxShape,
  required IndexedValueMapper<T, String>? checkboxSemanticLabelMapper,
  required BorderSide? checkboxSide,
  required ShapeBorder? checkboxCellShape,
  required TextStyle? labelStyle,
  required Color? textColor,
}) {
  final bool value = data == null ? false : data.contains(item);
  bool effectiveEnabled = field.isEnabled &&
      (enabledMapper == null ? true : enabledMapper(index, item));
  if (minCount != null) {
    effectiveEnabled = effectiveEnabled && (!value || data.length > minCount);
  }

  if (maxCount != null) {
    effectiveEnabled =
        effectiveEnabled && (value || (data?.length ?? 0) < maxCount);
  }

  void onChangedHandler(bool? val) {
    if (val == true && data?.contains(item) != true) {
      onChanged([...?data, item]);
    } else if (val != true && data?.contains(item) == true) {
      onChanged([...data!]..remove(item));
    }
  }

  return TxCheckboxCell(
    label: Text(labelMapper(item)),
    value: value,
    enabled: effectiveEnabled,
    onChanged: onChangedHandler,
    mouseCursor: mouseCursor,
    activeColor: activeColor,
    fillColor: fillColor,
    checkColor: checkColor,
    hoverColor: hoverColor,
    overlayColor: overlayColor,
    splashRadius: splashRadius,
    materialTapTargetSize: materialTapTargetSize,
    isError: errorMapper == null ? null : errorMapper(index, item),
    controlAffinity: controlAffinity,
    padding: checkboxPadding,
    tristate: tristateMapper == null ? null : tristateMapper(index, item),
    checkboxShape: checkboxShape,
    checkboxSemanticLabel: checkboxSemanticLabelMapper == null
        ? null
        : checkboxSemanticLabelMapper(index, item),
    side: checkboxSide,
    shape: checkboxCellShape,
    labelStyle: labelStyle,
    textColor: textColor,
  );
}

/// 带有标签的复选按钮。
class TxCheckboxCell extends StatelessWidget {
  const TxCheckboxCell({
    required this.label,
    required this.value,
    this.enabled,
    this.onChanged,
    super.key,
    this.mouseCursor,
    this.activeColor,
    this.fillColor,
    this.checkColor,
    this.hoverColor,
    this.overlayColor,
    this.splashRadius,
    this.materialTapTargetSize,
    bool? isError,
    ListTileControlAffinity? controlAffinity,
    this.padding,
    bool? tristate,
    this.checkboxShape,
    this.checkboxSemanticLabel,
    this.side,
    this.shape,
    this.labelStyle,
    this.textColor,
  })  : tristate = tristate ?? false,
        isError = isError ?? false,
        controlAffinity = controlAffinity ?? ListTileControlAffinity.platform;

  /// 当前 [TxCheckboxCell] 是否可选
  ///
  /// 默认值为 true。
  final bool? enabled;

  /// 是否选中此复选框。
  final bool? value;

  /// 当复选框的值应更改时调用。
  ///
  /// 该复选框将新值传递给回调，该小组件会自己管理选中状态，即使父组件没有将新值传入，选中状态
  /// 也会更改。
  ///
  /// 即使为 null，复选框也不会禁用，如果需要禁用，请设置 [enabled] 为 false。
  final ValueChanged<bool?>? onChanged;

  /// 鼠标指针进入窗口小部件或悬停在 Widget 上时的光标。
  final MouseCursor? mouseCursor;

  /// 选中此复选框时要使用的颜色。
  ///
  /// 默认为当前 [Theme] 的 [ColorScheme.primary]。
  final Color? activeColor;

  /// 填充复选框的颜色。
  ///
  /// 如果为 null，则在所选状态中使用 [activeColor] 的值。如果该值也是 null，则使用
  /// [CheckboxThemeData.fillColor] 的值。如果该值也是 null，则使用默认值。
  final MaterialStateProperty<Color?>? fillColor;

  /// 选中此复选框时用于复选图标的颜色。
  ///
  /// 默认为当前 [Theme] 的 [ColorScheme.onPrimary]。
  final Color? checkColor;

  /// {@macro flutter.material.checkbox.hoverColor}
  final Color? hoverColor;

  /// 复选框的 [Material] 的颜色。
  ///
  /// 解决以下状态：
  ///  * [MaterialState.pressed].
  ///  * [MaterialState.selected].
  ///  * [MaterialState.hovered].
  ///
  /// 如果为 null，则在按下和悬停状态中使用 alpha 为 [kRadialReactionAlpha] 和
  /// [hoverColor] 的 [activeColor] 的值。如果该值也是 null，则使用
  /// [CheckboxThemeData.overlayColor] 的值。如果该值也是 null，则在 pressed 和
  /// hovered 状态中使用默认值。
  final MaterialStateProperty<Color?>? overlayColor;

  /// {@macro flutter.material.checkbox.splashRadius}
  ///
  /// 如果为 null，则使用 [CheckboxThemeData.splashRadius] 的值。如果该字段也为 null，
  /// 则使用 [kRadialReactionRadius]。
  final double? splashRadius;

  /// {@macro flutter.material.checkbox.materialTapTargetSize}
  ///
  /// 默认为 [MaterialTapTargetSize.shrinkWrap]。
  final MaterialTapTargetSize? materialTapTargetSize;

  /// {@macro flutter.material.checkbox.isError}
  ///
  /// 默认为 false。
  final bool isError;

  /// 当前 [TxCheckboxCell] 的主要内容。
  ///
  /// Typically a [Text] widget.
  final Widget label;

  /// 相对于文本放置控件的位置。
  final ListTileControlAffinity controlAffinity;

  /// 定义内容周围的内边距。
  ///
  /// 当值为 null 时，[padding] 为
  /// 'EdgeInsets.symmetric(horizontal： 4.0, vertical: 2.0)'。
  final EdgeInsetsGeometry? padding;

  /// 如果为 true，则复选框的 [value] 可以是 true、false 或 null。
  ///
  /// 复选框的值为 null 时显示短划线。
  ///
  /// 当点击三态复选框（[tristate] 为 true）时，如果当前值为 false，则其 [onChanged] 回
  /// 调将应用于 true，如果 value 为 true，则应用于 null，如果值为 null，则应用于 false（
  /// 即，点击时，它会在 false => true => null => false 之间循环）。
  ///
  /// 如果 tristate 为 false（默认值），则 [value] 不能为 null。
  final bool tristate;

  /// {@macro flutter.material.checkbox.shape}
  ///
  /// 如果此属性为 null，则使用 [ThemeData.checkboxTheme] 的 [CheckboxThemeData.shape]。
  /// 如果为 null，则形状将是圆角半径为 1.0 的 [RoundedRectangleBorder]。
  final OutlinedBorder? checkboxShape;

  /// {@macro flutter.material.checkbox.side}
  ///
  /// 给定的值直接传递给 [Checkbox.side]。
  ///
  /// 如果此属性为 null，则使用 [ThemeData.checkboxTheme] 的 [CheckboxThemeData.side]。
  /// 如果该字段也为 null，则 side 的宽度为 2。
  final BorderSide? side;

  /// {@macro flutter.material.checkbox.semanticLabel}
  final String? checkboxSemanticLabel;

  /// [TxCheckboxCell] 的形状
  final ShapeBorder? shape;

  /// [label] 的文字样式。
  final TextStyle? labelStyle;

  /// 文字的颜色
  final Color? textColor;

  void _handleValueChange() {
    assert(onChanged != null);
    switch (value) {
      case false:
        onChanged!(true);
      case true:
        onChanged!(tristate ? null : false);
      case null:
        onChanged!(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final effectiveOverlayColor = overlayColor ??
        MaterialStateProperty.resolveWith((Set<MaterialState> states) {
          if (states.contains(MaterialState.error)) {
            if (states.contains(MaterialState.pressed)) {
              return colorScheme.error.withOpacity(0.12);
            }
            if (states.contains(MaterialState.hovered)) {
              return colorScheme.error.withOpacity(0.08);
            }
            if (states.contains(MaterialState.focused)) {
              return colorScheme.error.withOpacity(0.12);
            }
          }
          if (states.contains(MaterialState.selected)) {
            if (states.contains(MaterialState.pressed)) {
              return colorScheme.onSurface.withOpacity(0.12);
            }
            if (states.contains(MaterialState.hovered)) {
              return colorScheme.primary.withOpacity(0.08);
            }
            if (states.contains(MaterialState.focused)) {
              return colorScheme.primary.withOpacity(0.12);
            }
            return Colors.transparent;
          }
          if (states.contains(MaterialState.pressed)) {
            return colorScheme.primary.withOpacity(0.12);
          }
          if (states.contains(MaterialState.hovered)) {
            return colorScheme.onSurface.withOpacity(0.08);
          }
          if (states.contains(MaterialState.focused)) {
            return colorScheme.onSurface.withOpacity(0.12);
          }
          return Colors.transparent;
        });
    final effectiveMaterialTapTargetSize =
        materialTapTargetSize ?? MaterialTapTargetSize.shrinkWrap;

    final Widget control = Checkbox.adaptive(
      value: value,
      onChanged: enabled ?? true ? onChanged : null,
      mouseCursor: mouseCursor,
      activeColor: activeColor,
      fillColor: fillColor,
      checkColor: checkColor,
      hoverColor: hoverColor,
      overlayColor: overlayColor,
      splashRadius: splashRadius,
      materialTapTargetSize: effectiveMaterialTapTargetSize,
      tristate: tristate,
      shape: checkboxShape,
      side: side,
      isError: isError,
      semanticLabel: checkboxSemanticLabel,
      visualDensity: VisualDensity.compact,
    );

    final TextStyle effectiveStyle =
        labelStyle ?? Theme.of(context).textTheme.labelLarge!;
    final Widget labelWidget = DefaultTextStyle(
      style: effectiveStyle.copyWith(
        color: enabled ?? true
            ? isError
                ? colorScheme.error
                : textColor
            : Theme.of(context).colorScheme.onSurface.withOpacity(0.38),
      ),
      child: label,
    );

    final double size = switch (effectiveMaterialTapTargetSize) {
      MaterialTapTargetSize.padded => kMinInteractiveDimension,
      MaterialTapTargetSize.shrinkWrap => kMinInteractiveDimension - 8.0,
    };
    final double fixHorizontalPadding = (size - Checkbox.width) / 2;
    final EdgeInsets fixPadding;
    Widget? leading, trailing;
    switch (controlAffinity) {
      case ListTileControlAffinity.leading:
        leading = control;
        trailing = labelWidget;
        fixPadding = EdgeInsets.only(right: fixHorizontalPadding);
      case ListTileControlAffinity.trailing:
      case ListTileControlAffinity.platform:
        leading = labelWidget;
        trailing = control;
        fixPadding = EdgeInsets.only(left: fixHorizontalPadding);
    }
    final effectivePadding = (padding ?? EdgeInsets.zero).add(fixPadding);

    return InkWell(
      customBorder: shape ??
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(6.0)),
          ),
      onTap: enabled ?? true ? _handleValueChange : null,
      overlayColor: effectiveOverlayColor,
      child: Padding(
        padding: effectivePadding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [leading, trailing],
        ),
      ),
    );
  }
}
