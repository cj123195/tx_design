import 'package:flutter/material.dart';
import 'radio.dart';
import 'radio_theme.dart';

/// [TxRadioCell.label]位置
enum RadioCellLabelPosition {
  left,
  right,
}

/// 一个包含[Radio]及其文字描述的小部件
///
/// 详细信息请参考[Radio]
class TxRadioCell<T> extends StatelessWidget {
  const TxRadioCell({
    required this.label,
    required this.value,
    required this.groupValue,
    super.key,
    this.onChanged,
    this.mouseCursor,
    this.toggleable = false,
    this.activeColor,
    this.fillColor,
    this.materialTapTargetSize,
    this.visualDensity,
    this.focusColor,
    this.hoverColor,
    this.overlayColor,
    this.splashRadius,
    this.focusNode,
    this.autofocus = false,
    this.shape,
    this.radioShape,
    this.side,
    this.labelPosition = RadioCellLabelPosition.right,
  });

  /// 此单选按钮表示的值。
  final T value;

  /// 一组单选按钮的当前选定值。
  ///
  /// 如果此单选按钮的 [value] 与 [groupValue] 匹配，则认为该单选按钮已选中。
  final T groupValue;

  /// 当用户选择此单选按钮时调用。
  ///
  /// 单选按钮将 [value] 作为参数传递给此回调。 单选按钮实际上不会改变状态，直到父部件用
  /// 新的 [groupValue] 重建单选按钮。
  ///
  /// 如果为空，单选按钮将显示为禁用。
  ///
  /// 如果已选择此单选按钮，则不会调用提供的回调。
  ///
  /// 提供给 [onChanged] 的回调应该使用 [State.setState] 方法更新父级 [StatefulWidget]
  /// 的状态，以便父级重建；例如:
  ///
  /// ```dart
  /// Radio<SingingCharacter>(
  ///   value: SingingCharacter.lafayette,
  ///   groupValue: _character,
  ///   onChanged: (SingingCharacter newValue) {
  ///     setState(() {
  ///       _character = newValue;
  ///     });
  ///   },
  /// )
  /// ```
  final ValueChanged<T?>? onChanged;

  /// 描述当前选项的组件
  final Widget label;

  /// 定义[label]相对于[TxRadio]的位置
  final RadioCellLabelPosition labelPosition;

  /// [TxRadioCell]的 [Material] 的形状。
  ///
  /// 如果为 null，则形状将是 [StadiumBorder]。
  final ShapeBorder? shape;

  /// {@template flutter.material.radio.mouseCursor}
  /// 鼠标指针进入或悬停在小部件上时的光标。
  ///
  /// 如果 [mouseCursor] 是 [MaterialStateProperty<MouseCursor>]，
  /// [MaterialStateProperty.resolve] 用于以下 [MaterialState]：
  ///
  ///  * [MaterialState.selected].
  ///  * [MaterialState.hovered].
  ///  * [MaterialState.focused].
  ///  * [MaterialState.disabled].
  /// {@endtemplate}
  ///
  /// 如果为 null，则使用 [RadioThemeData.mouseCursor] 的值。 如果它也为 null，
  /// 则使用 [MaterialStateMouseCursor.clickable]。
  final MouseCursor? mouseCursor;

  /// 如果允许通过在选中时再次选择此单选按钮将其返回到不确定状态，则设置为 true。
  ///
  /// 为了指示返回到不确定状态，将使用 null 调用 [onChanged]。
  ///
  /// 如果为 true，则在 [groupValue] != [value] 时选择时可以使用 [value] 调用
  /// [onChanged]，或者在 [groupValue] == [value] 时再次选择时使用 null 调用。
  ///
  /// 如果为 false，当 [groupValue] != [value] 被选中时 [onChanged] 将被调用 [value]，
  /// 并且只有通过选择组中的另一个单选按钮（即更改 [groupValue] 的值）才能调用此单选按钮
  /// 按钮被取消选择。
  ///
  /// 默认为false.
  final bool toggleable;

  /// 选择此单选按钮时使用的颜色。
  ///
  /// 默认为 [ColorScheme.secondary]。
  ///
  /// 如果 [fillColor] 在 [MaterialState.selected] 状态下返回一个非空颜色，它将被用来
  /// 代替这个颜色。
  final Color? activeColor;

  /// 在所有 [MaterialState] 中填充单选按钮的颜色。
  ///
  /// Resolves in the following states:
  ///  * [MaterialState.selected].
  ///  * [MaterialState.hovered].
  ///  * [MaterialState.focused].
  ///  * [MaterialState.disabled].
  ///
  /// 如果为 null，则 [activeColor] 的值用于选定状态。 如果它也为 null，则使用
  /// [RadioThemeData.fillColor] 的值。 如果那也是null，则[ThemeData.disabledColor]
  /// 在禁用状态下使用，[ColorScheme.secondary]在选中状态下使用，
  /// [ThemeData.unselectedWidgetColor]在默认状态下使用。
  final MaterialStateProperty<Color?>? fillColor;

  /// {@template flutter.material.radio.materialTapTargetSize}
  /// 配置点击目标的最小尺寸。
  /// {@endtemplate}
  ///
  /// 如果为 null，则使用 [RadioThemeData.materialTapTargetSize] 的值。 如果它也为
  /// null，则使用 [ThemeData.materialTapTargetSize] 的值。
  final MaterialTapTargetSize? materialTapTargetSize;

  /// {@template flutter.material.radio.visualDensity}
  /// 定义单选按钮布局的紧凑程度。
  /// {@endtemplate}
  ///
  /// {@macro flutter.material.themedata.visualDensity}
  ///
  /// 如果为 null，则使用 [RadioThemeData.visualDensity] 的值。 如果它也为 null，
  /// 则使用 [ThemeData.visualDensity] 的值。
  final VisualDensity? visualDensity;

  /// 单选按钮的 [Material] 具有输入焦点时的颜色。
  ///
  /// 如果 [overlayColor] 在 [MaterialState.focused] 状态下返回非空颜色，它将被使用。
  ///
  /// 如果为 null，则在聚焦状态下使用 [RadioThemeData.overlayColor] 的值。 如果它也为
  /// null，则使用 [ThemeData.focusColor] 的值。
  final Color? focusColor;

  /// 当指针悬停在收音机上方时，单选按钮 [Material] 的颜色。
  ///
  /// 如果 [overlayColor] 在 [MaterialState.hovered] 状态下返回非空颜色，它将被使用。
  ///
  /// 如果为 null，则在悬停状态下使用 [RadioThemeData.overlayColor] 的值。 如果它也为
  /// null，则使用 [ThemeData.hoverColor] 的值。
  final Color? hoverColor;

  /// {@template flutter.material.radio.overlayColor}
  /// 单选按钮 [Material] 的颜色。
  ///
  /// 解析为以下状态：
  ///  * [MaterialState.pressed].
  ///  * [MaterialState.selected].
  ///  * [MaterialState.hovered].
  ///  * [MaterialState.focused].
  /// {@endtemplate}
  ///
  /// 如果为 null，则在按下、聚焦和悬停状态下使用具有阿尔法 ialReactionAlpha、[focusColor]
  /// 和 [hoverColor] 的 [activeColor] 的值。 如果它也为 null，则使用
  /// [RadioThemeData.overlayColor] 的值。 如果它也为 null，则
  /// [ColorScheme.secondary] 的值与 alpha [kRadialReactionAlpha]、
  /// [ThemeData.focusColor] 和 [ThemeData.hoverColor] 用于按下、聚焦和悬停状态。
  final MaterialStateProperty<Color?>? overlayColor;

  /// {@template flutter.material.radio.splashRadius}
  /// 圆形 [Material] 点击响应的水波纹半径。
  /// {@endtemplate}
  ///
  /// 如果为 null，则使用 [RadioThemeData.splashRadius] 的值。 如果它也为 null，
  /// 则使用 [kRadialReactionRadius]。
  final double? splashRadius;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  /// {@macro flutter.widgets.Focus.autofocus}
  final bool autofocus;

  /// 单选按钮的 [Material] 的形状。
  final OutlinedBorder? radioShape;

  /// 单选框边框的颜色和宽度。
  ///
  /// 此属性可以是 [MaterialStateBorderSide]，可以根据复选框的状态指定不同的边框颜色和宽度。
  ///
  /// 解析为以下状态：
  ///  * [MaterialState.pressed].
  ///  * [MaterialState.selected].
  ///  * [MaterialState.hovered].
  ///  * [MaterialState.focused].
  ///  * [MaterialState.disabled].
  ///
  /// 如果此属性不是 [MaterialStateBorderSide] 且非空，则仅当复选框的值为 false 时才会呈现。
  /// 解释上的差异是为了向后兼容。
  final BorderSide? side;

  bool get checked => value == groupValue;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    TextStyle textStyle = theme.textTheme.bodyMedium!;
    if (onChanged == null) {
      textStyle = textStyle.copyWith(color: textStyle.color?.withOpacity(0.5));
    }

    final Widget radio = TxRadio<T>(
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: visualDensity ?? VisualDensity.compact,
      toggleable: toggleable,
      side: side,
      shape: radioShape,
      focusColor: focusColor,
      overlayColor: overlayColor,
      hoverColor: hoverColor,
      fillColor: fillColor,
      splashRadius: splashRadius,
      activeColor: activeColor,
    );
    final Widget labelText = DefaultTextStyle(style: textStyle, child: label);

    final VisualDensity effectiveVisualDensity = visualDensity ??
        TxRadioTheme.of(context).visualDensity ??
        theme.visualDensity;
    final Widget spacing =
        SizedBox(width: 4.0 + effectiveVisualDensity.baseSizeAdjustment.dx);

    final List<Widget> children = labelPosition == RadioCellLabelPosition.right
        ? [radio, spacing, labelText]
        : [labelText, spacing, radio];

    return InkWell(
      onTap: onChanged == null
          ? null
          : () {
              if (toggleable && checked) {
                onChanged!(null);
                return;
              }
              if (!checked) {
                onChanged!(value);
              }
            },
      focusNode: focusNode,
      focusColor: focusColor,
      overlayColor: overlayColor,
      mouseCursor: mouseCursor,
      autofocus: autofocus,
      customBorder: shape ?? const StadiumBorder(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}
