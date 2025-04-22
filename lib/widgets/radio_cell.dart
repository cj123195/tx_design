import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 带有标签的单选按钮。
class TxRadioCell<T> extends StatelessWidget {
  const TxRadioCell({
    required this.label,
    required this.value,
    required this.groupValue,
    this.onChanged,
    super.key,
    this.mouseCursor,
    this.activeColor,
    this.fillColor,
    this.hoverColor,
    this.overlayColor,
    this.splashRadius,
    this.materialTapTargetSize,
    ListTileControlAffinity? controlAffinity,
    this.padding,
    bool? toggleable,
    this.shape,
    this.labelStyle,
    this.textColor,
    this.visualDensity,
    this.focusColor,
    this.focusNode,
    bool? autofocus,
    bool? useCupertinoCheckmarkStyle,
  })  : toggleable = toggleable ?? false,
        controlAffinity = controlAffinity ?? ListTileControlAffinity.platform,
        autofocus = autofocus ?? false,
        useCupertinoCheckmarkStyle = useCupertinoCheckmarkStyle ?? false;

  /// 此单选按钮表示的值。
  final T value;

  /// 当前一组单选按钮选择的值。
  ///
  /// 如果此单选按钮的 [value] 与 [groupValue] 匹配，则认为此单选按钮处于选中状态。
  final T? groupValue;

  /// 是否选中此单选按钮。
  ///
  /// 要控制此值，请适当设置 [value] 和 [groupValue]。
  bool get checked => value == groupValue;

  /// 当用户选择此单选按钮时调用。
  ///
  /// 单选按钮将 [value] 作为参数传递给此回调。单选按钮实际上不会更改状态，直到父 widget 使
  /// 用新的 [groupValue] 重新构建单选按钮。
  ///
  /// 如果为 null，则单选按钮将显示为已禁用。
  ///
  /// 如果已选择此单选按钮，则不会调用提供的回调。
  ///
  /// 提供给 [onChanged] 的回调应使用 [State.setState] 方法更新父级 [StatefulWidget]
  /// 的状态，以便重建父级;例如：
  ///
  /// ```dart
  /// Radio<SingingCharacter>(
  ///   value: SingingCharacter.lafayette,
  ///   groupValue: _character,
  ///   onChanged: (SingingCharacter? newValue) {
  ///     setState(() {
  ///       _character = newValue;
  ///     });
  ///   },
  /// )
  /// ```
  final ValueChanged<T?>? onChanged;

  /// 是否允许操作。
  ///
  /// 要控制此值，请适当设置 [onChanged]。
  bool get enabled => onChanged != null;

  /// 鼠标指针进入窗口小部件或悬停在 Widget 上时的光标。
  final MouseCursor? mouseCursor;

  /// 如果允许此单选按钮在选中时再次选择，将其返回到不确定状态，则设置为 true。
  ///
  /// 为了指示返回到不确定状态，将使用 null 调用 [onChanged]。
  ///
  /// 如果为 true，则可以在 [groupValue] ！= [value] 时用 [value] 调用 [onChanged]，
  /// 或者在 [groupValue] == [value] 时再次选中时用 null 调用 [onChanged]。
  ///
  /// 如果为 false，则当 [groupValue] ！= [value] 时选中 [onChanged] 时，将使用 [value]
  /// 调用 [onChanged]，并且只有通过选择组中的另一个单选按钮（即更改 [groupValue] 的值）
  /// 才能取消选中此单选按钮。
  ///
  /// 默认值为 false。
  ///
  /// {@tool dartpad}
  /// 此示例说明如何通过设置 [toggleable] 属性来启用取消选择单选按钮。
  ///
  /// ** 请参阅 examples/api/lib/material/radio/radio.toggleable.0.dart 中的代码 **
  /// {@end-tool}
  final bool toggleable;

  /// 选中此复选框时要使用的颜色。
  ///
  /// 默认为当前 [Theme] 的 [ColorScheme.primary]。
  final Color? activeColor;

  /// 填充复选框的颜色。
  ///
  /// 如果为 null，则在所选状态中使用 [activeColor] 的值。如果该值也是 null，则使用
  /// [RadioThemeData.fillColor] 的值。如果该值也是 null，则使用默认值。
  final WidgetStateProperty<Color?>? fillColor;

  /// {@macro flutter.material.checkbox.hoverColor}
  final Color? hoverColor;

  /// 复选框的 [Material] 的颜色。
  ///
  /// 解决以下状态：
  ///  * [WidgetState.pressed].
  ///  * [WidgetState.selected].
  ///  * [WidgetState.hovered].
  ///
  /// 如果为 null，则在按下和悬停状态中使用 alpha 为 [kRadialReactionAlpha] 和
  /// [hoverColor] 的 [activeColor] 的值。如果该值也是 null，则使用
  /// [RadioThemeData.overlayColor] 的值。如果该值也是 null，则在 pressed 和
  /// hovered 状态中使用默认值。
  final WidgetStateProperty<Color?>? overlayColor;

  /// {@macro flutter.material.checkbox.splashRadius}
  ///
  /// 如果为 null，则使用 [RadioThemeData.splashRadius] 的值。如果该字段也为 null，
  /// 则使用 [kRadialReactionRadius]。
  final double? splashRadius;

  /// {@macro flutter.material.checkbox.materialTapTargetSize}
  ///
  /// 默认为 [MaterialTapTargetSize.shrinkWrap]。
  final MaterialTapTargetSize? materialTapTargetSize;

  /// {@template flutter.material.radio.visualDensity}
  /// 定义单选按钮布局的紧凑程度。
  /// {@endtemplate}
  ///
  /// {@macro flutter.material.themedata.visualDensity}
  ///
  /// 如果为 null，则使用 [RadioThemeData.visualDensity] 的值。如果该值也是 null，
  /// 则使用 [ThemeData.visualDensity] 的值。
  ///
  /// 另请参阅：
  ///
  ///  * [ThemeData.visualDensity]，它指定 [Theme] 中所有小部件的 [visualDensity]。
  final VisualDensity? visualDensity;

  /// 单选按钮的 [Material] 具有输入焦点时的颜色。
  ///
  /// 如果 [overlayColor] 在 [WidgetState.focused] 状态中返回非 null 颜色，则将改用该颜色。
  ///
  /// 如果为 null，则 [RadioThemeData.overlayColor] 的值用于焦点状态。如果该值也是 null，
  /// 则使用 [ThemeData.focusColor] 的值。
  final Color? focusColor;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  /// {@macro flutter.widgets.Focus.autofocus}
  final bool autofocus;

  /// 控制是否在 iOS 样式的单选按钮中使用复选标记样式。
  ///
  /// 只能在 [Radio.adaptive] 构造函数下使用。如果设置为 true，则在 Apple 平台上，单选按
  /// 钮将显示为 iOS 样式的复选标记。通过 [CupertinoRadio.useCheckmarkStyle] 控制
  /// [CupertinoRadio]
  ///
  /// 默认为 false。
  final bool useCupertinoCheckmarkStyle;

  /// 当前 [TxRadioCell] 的主要内容。
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

  /// [TxRadioCell] 的形状
  final ShapeBorder? shape;

  /// [label] 的文字样式。
  final TextStyle? labelStyle;

  /// 文字的颜色
  final Color? textColor;

  /// Radio 实际绘制占据的区域半径大小
  ///
  /// 由绘制半径 8.0 及 画笔宽度 2.0 计算而来。
  static const double _radioRadius = 8.0 + 2.0;

  void _handleValueChange() {
    assert(onChanged != null);
    if (toggleable && checked) {
      onChanged!(null);
      return;
    }
    if (!checked) {
      onChanged!(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final effectiveOverlayColor = overlayColor ??
        WidgetStateProperty.resolveWith((Set<WidgetState> states) {
          if (states.contains(WidgetState.error)) {
            if (states.contains(WidgetState.pressed)) {
              return colorScheme.error.withOpacity(0.12);
            }
            if (states.contains(WidgetState.hovered)) {
              return colorScheme.error.withOpacity(0.08);
            }
            if (states.contains(WidgetState.focused)) {
              return colorScheme.error.withOpacity(0.12);
            }
          }
          if (states.contains(WidgetState.selected)) {
            if (states.contains(WidgetState.pressed)) {
              return colorScheme.onSurface.withOpacity(0.12);
            }
            if (states.contains(WidgetState.hovered)) {
              return colorScheme.primary.withOpacity(0.08);
            }
            if (states.contains(WidgetState.focused)) {
              return colorScheme.primary.withOpacity(0.12);
            }
            return Colors.transparent;
          }
          if (states.contains(WidgetState.pressed)) {
            return colorScheme.primary.withOpacity(0.12);
          }
          if (states.contains(WidgetState.hovered)) {
            return colorScheme.onSurface.withOpacity(0.08);
          }
          if (states.contains(WidgetState.focused)) {
            return colorScheme.onSurface.withOpacity(0.12);
          }
          return Colors.transparent;
        });
    final effectiveMaterialTapTargetSize =
        materialTapTargetSize ?? MaterialTapTargetSize.shrinkWrap;
    final effectiveVisualDensity = visualDensity ?? VisualDensity.compact;

    final double radioSize = switch (effectiveMaterialTapTargetSize) {
          MaterialTapTargetSize.padded => kMinInteractiveDimension,
          MaterialTapTargetSize.shrinkWrap => kMinInteractiveDimension - 8.0,
        } +
        effectiveVisualDensity.baseSizeAdjustment.dx;

    final Widget control = Radio.adaptive(
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      toggleable: toggleable,
      activeColor: activeColor,
      materialTapTargetSize:
          materialTapTargetSize ?? MaterialTapTargetSize.shrinkWrap,
      autofocus: autofocus,
      fillColor: fillColor,
      mouseCursor: mouseCursor,
      hoverColor: hoverColor,
      overlayColor: overlayColor,
      splashRadius: splashRadius,
      useCupertinoCheckmarkStyle: useCupertinoCheckmarkStyle,
      visualDensity: visualDensity ?? VisualDensity.compact,
    );

    final TextStyle effectiveStyle =
        labelStyle ?? Theme.of(context).textTheme.labelLarge!;
    final Widget labelWidget = DefaultTextStyle(
      style: effectiveStyle.copyWith(
        color: enabled
            ? textColor
            : Theme.of(context).colorScheme.onSurface.withOpacity(0.38),
      ),
      child: label,
    );

    final double fixHorizontalPadding = radioSize / 2 - _radioRadius;
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
      onTap: enabled ? _handleValueChange : null,
      overlayColor: effectiveOverlayColor,
      focusNode: focusNode,
      focusColor: focusColor,
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
