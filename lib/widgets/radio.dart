import 'package:flutter/material.dart';

import 'radio_theme.dart';

const double _kOuterRadius = 18.0;
const double _kInnerRadius = 10.0;
const double _kStrokeWidth = 2.0;

/// 一个Material风格的单选按钮。
///
/// 用于在多个互斥值之间进行选择。 当一组中的一个单选按钮被选中时，该组中的其他单选按钮将停止
/// 被选中。 这些值的类型为“T”，即 [Radio] 类的类型参数。 枚举通常用于此目的。
///
/// 单选按钮本身不保持任何状态。 相反，选择选项会调用 [onChanged] 回调，将 [value] 作为
/// 参数传递。 如果 [groupValue] 和 [value] 匹配，则将选择此选项。 大多数小部件将通过
/// 调用 [State.setState] 更新单选按钮的 [groupValue] 来响应 [onChanged]。
class TxRadio<T> extends StatefulWidget {
  /// 创建一个Material风格的单选按钮
  ///
  /// 单选按钮本身不保持任何状态。 相反，当单选按钮被选中时，小部件调用 [onChanged] 回调。
  /// 大多数使用单选按钮的小部件将监听 [onChanged] 回调并使用新的 [groupValue] 重建单选
  /// 按钮以更新单选按钮的视觉外观。
  ///
  /// 需要以下参数：
  ///
  /// * [value] 和 [groupValue] 一起判断单选按钮是否被选中。
  /// * [onChanged] 在用户选择此单选按钮时调用。
  ///
  /// [autofocus] 的值不能为空。
  const TxRadio({
    required this.value,
    required this.groupValue,
    required this.onChanged,
    super.key,
    this.mouseCursor,
    this.toggleable = false,
    this.activeColor,
    this.fillColor,
    this.focusColor,
    this.hoverColor,
    this.overlayColor,
    this.splashRadius,
    this.materialTapTargetSize,
    this.visualDensity,
    this.focusNode,
    this.autofocus = false,
    this.shape,
    this.side,
  });

  /// 此单选按钮表示的值。
  final T value;

  /// 一组单选按钮的当前选定值。
  ///
  /// 如果此单选按钮的 [value] 与 [groupValue] 匹配，则认为该单选按钮已选中。
  final T? groupValue;

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
  /// [TxRadioThemeData.overlayColor] 的值。 如果它也为 null，则
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

  /// {@template flutter.material.checkbox.shape}
  /// 单选按钮的 [Material] 的形状。
  /// {@endtemplate}
  ///
  /// 如果此属性为空，则使用 [ThemeData.checkboxTheme] 的 [TxRadioThemeData.shape]。
  /// 如果为 null，则形状将是圆角半径为 1.0 的 [RoundedRectangleBorder]。
  final OutlinedBorder? shape;

  /// {@template flutter.material.checkbox.side}
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
  /// {@endtemplate}
  ///
  /// 如果此属性为 null，则使用 [ThemeData.extension<TxRadioThemeData>()!] 的
  /// [TxRadioThemeData.side]。 如果它也为 null，则该边的宽度为 2。
  final BorderSide? side;

  /// 单选框小部件的宽度。
  static const double width = 18.0;

  bool get _selected => value == groupValue;

  @override
  State<TxRadio<T>> createState() => _TxRadioState<T>();
}

class _TxRadioState<T> extends State<TxRadio<T>>
    with TickerProviderStateMixin, ToggleableStateMixin {
  final _TxRadioPainter _painter = _TxRadioPainter();

  void _handleChanged(bool? selected) {
    if (selected == null) {
      widget.onChanged!(null);
      return;
    }
    if (selected) {
      widget.onChanged!(widget.value);
    }
  }

  @override
  void didUpdateWidget(TxRadio<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget._selected != oldWidget._selected) {
      animateToValue();
    }
  }

  @override
  void dispose() {
    _painter.dispose();
    super.dispose();
  }

  @override
  ValueChanged<bool?>? get onChanged =>
      widget.onChanged != null ? _handleChanged : null;

  @override
  bool get tristate => widget.toggleable;

  @override
  bool? get value => widget._selected;

  MaterialStateProperty<Color?> get _widgetFillColor {
    return MaterialStateProperty.resolveWith((Set<MaterialState> states) {
      if (states.contains(MaterialState.disabled)) {
        return null;
      }
      if (states.contains(MaterialState.selected)) {
        return widget.activeColor;
      }
      return null;
    });
  }

  BorderSide? _resolveSide(BorderSide? side) {
    if (side is MaterialStateBorderSide) {
      return MaterialStateProperty.resolveAs<BorderSide?>(side, states);
    }
    if (!states.contains(MaterialState.selected)) {
      return side;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    final TxRadioThemeData radioTheme = TxRadioTheme.of(context);
    final TxRadioThemeData defaults = Theme.of(context).useMaterial3
        ? _RadioDefaultsM3(context)
        : _RadioDefaultsM2(context);
    final MaterialTapTargetSize effectiveMaterialTapTargetSize =
        widget.materialTapTargetSize ??
            radioTheme.materialTapTargetSize ??
            defaults.materialTapTargetSize!;
    final VisualDensity effectiveVisualDensity = widget.visualDensity ??
        radioTheme.visualDensity ??
        defaults.visualDensity!;
    Size size;
    switch (effectiveMaterialTapTargetSize) {
      case MaterialTapTargetSize.padded:
        size = const Size(kMinInteractiveDimension, kMinInteractiveDimension);
        break;
      case MaterialTapTargetSize.shrinkWrap:
        size = const Size(
            kMinInteractiveDimension - 8.0, kMinInteractiveDimension - 8.0);
        break;
    }
    size += effectiveVisualDensity.baseSizeAdjustment;

    final MaterialStateProperty<MouseCursor> effectiveMouseCursor =
        MaterialStateProperty.resolveWith<MouseCursor>(
            (Set<MaterialState> states) {
      return MaterialStateProperty.resolveAs<MouseCursor?>(
              widget.mouseCursor, states) ??
          radioTheme.mouseCursor?.resolve(states) ??
          MaterialStateProperty.resolveAs<MouseCursor>(
              MaterialStateMouseCursor.clickable, states);
    });

    // Colors need to be resolved in selected and non selected states separately
    // so that they can be lerped between.
    final Set<MaterialState> activeStates = states..add(MaterialState.selected);
    final Set<MaterialState> inactiveStates = states
      ..remove(MaterialState.selected);
    final Color? activeColor = widget.fillColor?.resolve(activeStates) ??
        _widgetFillColor.resolve(activeStates) ??
        radioTheme.fillColor?.resolve(activeStates);
    final Color effectiveActiveColor =
        activeColor ?? defaults.fillColor!.resolve(activeStates)!;
    final Color? inactiveColor = widget.fillColor?.resolve(inactiveStates) ??
        _widgetFillColor.resolve(inactiveStates) ??
        radioTheme.fillColor?.resolve(inactiveStates);
    final Color effectiveInactiveColor =
        inactiveColor ?? defaults.fillColor!.resolve(inactiveStates)!;

    final Set<MaterialState> focusedStates = states..add(MaterialState.focused);
    Color effectiveFocusOverlayColor =
        widget.overlayColor?.resolve(focusedStates) ??
            widget.focusColor ??
            radioTheme.overlayColor?.resolve(focusedStates) ??
            defaults.overlayColor!.resolve(focusedStates)!;

    final Set<MaterialState> hoveredStates = states..add(MaterialState.hovered);
    Color effectiveHoverOverlayColor =
        widget.overlayColor?.resolve(hoveredStates) ??
            widget.hoverColor ??
            radioTheme.overlayColor?.resolve(hoveredStates) ??
            defaults.overlayColor!.resolve(hoveredStates)!;

    final Set<MaterialState> activePressedStates = activeStates
      ..add(MaterialState.pressed);
    final Color effectiveActivePressedOverlayColor =
        widget.overlayColor?.resolve(activePressedStates) ??
            radioTheme.overlayColor?.resolve(activePressedStates) ??
            activeColor?.withAlpha(kRadialReactionAlpha) ??
            defaults.overlayColor!.resolve(activePressedStates)!;

    final Set<MaterialState> inactivePressedStates = inactiveStates
      ..add(MaterialState.pressed);
    final Color effectiveInactivePressedOverlayColor =
        widget.overlayColor?.resolve(inactivePressedStates) ??
            radioTheme.overlayColor?.resolve(inactivePressedStates) ??
            inactiveColor?.withAlpha(kRadialReactionAlpha) ??
            defaults.overlayColor!.resolve(inactivePressedStates)!;

    if (downPosition != null) {
      effectiveHoverOverlayColor = states.contains(MaterialState.selected)
          ? effectiveActivePressedOverlayColor
          : effectiveInactivePressedOverlayColor;
      effectiveFocusOverlayColor = states.contains(MaterialState.selected)
          ? effectiveActivePressedOverlayColor
          : effectiveInactivePressedOverlayColor;
    }

    return Semantics(
      inMutuallyExclusiveGroup: true,
      checked: widget._selected,
      child: buildToggleable(
        mouseCursor: effectiveMouseCursor,
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        size: size,
        painter: _painter
          ..position = position
          ..reaction = reaction
          ..reactionFocusFade = reactionFocusFade
          ..reactionHoverFade = reactionHoverFade
          ..inactiveReactionColor = effectiveInactivePressedOverlayColor
          ..reactionColor = effectiveActivePressedOverlayColor
          ..hoverColor = effectiveHoverOverlayColor
          ..focusColor = effectiveFocusOverlayColor
          ..splashRadius = widget.splashRadius ??
              radioTheme.splashRadius ??
              kRadialReactionRadius
          ..downPosition = downPosition
          ..isFocused = states.contains(MaterialState.focused)
          ..isHovered = states.contains(MaterialState.hovered)
          ..activeColor = effectiveActiveColor
          ..inactiveColor = effectiveInactiveColor
          ..shape = widget.shape ??
              radioTheme.shape ??
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(1.0)),
              )
          ..side = _resolveSide(widget.side) ?? _resolveSide(radioTheme.side),
      ),
    );
  }
}

class _TxRadioPainter extends ToggleablePainter {
  bool? get value => _value;
  bool? _value;

  set value(bool? value) {
    if (_value == value) {
      return;
    }
    _value = value;
    notifyListeners();
  }

  OutlinedBorder get shape => _shape!;
  OutlinedBorder? _shape;

  set shape(OutlinedBorder value) {
    if (_shape == value) {
      return;
    }
    _shape = value;
    notifyListeners();
  }

  BorderSide? get side => _side;
  BorderSide? _side;

  set side(BorderSide? value) {
    if (_side == value) {
      return;
    }
    _side = value;
    notifyListeners();
  }

  @override
  void paint(Canvas canvas, Size size) {
    paintRadialReaction(canvas: canvas, origin: size.center(Offset.zero));

    final Rect outer = Rect.fromCenter(
      center: size.center(Offset.zero),
      width: _kOuterRadius,
      height: _kOuterRadius,
    );
    final Rect inner = Rect.fromCenter(
      center: size.center(Offset.zero),
      width: _kInnerRadius * position.value,
      height: _kInnerRadius * position.value,
    );
    final Color innerColor =
        Color.lerp(inactiveColor, activeColor, position.value)!;
    final Paint paint = Paint()
      ..color = side?.color ?? innerColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = side?.width ?? _kStrokeWidth;

    canvas.drawPath(shape.getOuterPath(outer), paint);
    if (!position.isDismissed) {
      canvas.drawPath(
        shape.getOuterPath(inner),
        paint
          ..style = PaintingStyle.fill
          ..color = innerColor,
      );
    }
  }
}

class _RadioDefaultsM2 extends TxRadioThemeData {
  _RadioDefaultsM2(this.context);

  final BuildContext context;
  late final ThemeData _theme = Theme.of(context);
  late final ColorScheme _colors = _theme.colorScheme;

  @override
  MaterialStateProperty<Color> get fillColor {
    return MaterialStateProperty.resolveWith((Set<MaterialState> states) {
      if (states.contains(MaterialState.disabled)) {
        return _theme.disabledColor;
      }
      if (states.contains(MaterialState.selected)) {
        return _colors.secondary;
      }
      return _theme.unselectedWidgetColor;
    });
  }

  @override
  MaterialStateProperty<Color> get overlayColor {
    return MaterialStateProperty.resolveWith((Set<MaterialState> states) {
      if (states.contains(MaterialState.pressed)) {
        return fillColor.resolve(states).withAlpha(kRadialReactionAlpha);
      }
      if (states.contains(MaterialState.focused)) {
        return _theme.focusColor;
      }
      if (states.contains(MaterialState.hovered)) {
        return _theme.hoverColor;
      }
      return Colors.transparent;
    });
  }

  @override
  MaterialTapTargetSize get materialTapTargetSize =>
      _theme.materialTapTargetSize;

  @override
  VisualDensity get visualDensity => _theme.visualDensity;
}

class _RadioDefaultsM3 extends TxRadioThemeData {
  _RadioDefaultsM3(this.context);

  final BuildContext context;
  late final ThemeData _theme = Theme.of(context);
  late final ColorScheme _colors = _theme.colorScheme;

  @override
  MaterialStateProperty<Color> get fillColor {
    return MaterialStateProperty.resolveWith((Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        if (states.contains(MaterialState.disabled)) {
          return _colors.onSurface.withOpacity(0.38);
        }
        if (states.contains(MaterialState.pressed)) {
          return _colors.primary;
        }
        if (states.contains(MaterialState.hovered)) {
          return _colors.primary;
        }
        if (states.contains(MaterialState.focused)) {
          return _colors.primary;
        }
        return _colors.primary;
      }
      if (states.contains(MaterialState.disabled)) {
        return _colors.onSurface.withOpacity(0.38);
      }
      if (states.contains(MaterialState.pressed)) {
        return _colors.onSurface;
      }
      if (states.contains(MaterialState.hovered)) {
        return _colors.onSurface;
      }
      if (states.contains(MaterialState.focused)) {
        return _colors.onSurface;
      }
      return _colors.onSurfaceVariant;
    });
  }

  @override
  MaterialStateProperty<Color> get overlayColor {
    return MaterialStateProperty.resolveWith((Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        if (states.contains(MaterialState.pressed)) {
          return _colors.onSurface.withOpacity(0.12);
        }
        if (states.contains(MaterialState.hovered)) {
          return _colors.primary.withOpacity(0.08);
        }
        if (states.contains(MaterialState.focused)) {
          return _colors.primary.withOpacity(0.12);
        }
        return Colors.transparent;
      }
      if (states.contains(MaterialState.pressed)) {
        return _colors.primary.withOpacity(0.12);
      }
      if (states.contains(MaterialState.hovered)) {
        return _colors.onSurface.withOpacity(0.08);
      }
      if (states.contains(MaterialState.focused)) {
        return _colors.onSurface.withOpacity(0.12);
      }
      return Colors.transparent;
    });
  }

  @override
  MaterialTapTargetSize get materialTapTargetSize =>
      _theme.materialTapTargetSize;

  @override
  VisualDensity get visualDensity => _theme.visualDensity;
}
