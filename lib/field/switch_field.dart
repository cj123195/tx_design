import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'field.dart';
import 'field_tile.dart';

/// 开关操作框
class TxSwitchField extends TxField<bool> {
  TxSwitchField({
    super.key,
    super.initialValue,
    super.decoration,
    super.focusNode,
    super.enabled,
    this.activeColor,
    this.activeTrackColor,
    this.inactiveThumbColor,
    this.inactiveTrackColor,
    this.activeThumbImage,
    this.onActiveThumbImageError,
    this.inactiveThumbImage,
    this.onInactiveThumbImageError,
    this.thumbColor,
    this.trackColor,
    this.trackOutlineColor,
    this.trackOutlineWidth,
    this.thumbIcon,
    this.materialTapTargetSize,
    this.applyCupertinoTheme,
    this.dragStartBehavior,
    this.mouseCursor,
    this.focusColor,
    this.hoverColor,
    this.overlayColor,
    this.splashRadius,
    this.onFocusChange,
    this.autofocus,
    this.textDirection,
    ValueChanged<bool>? onChanged,
  }) : super(
          onChanged: onChanged == null ? null : (val) => onChanged(val!),
        );

  /// {@template flutter.material.switch.activeColor}
  /// 此开关打开时要使用的颜色。
  /// {@endtemplate}
  ///
  /// 默认为 [ColorScheme.secondary]。
  ///
  /// 如果 [thumbColor] 在 [MaterialState.selected] 状态中返回非 null 颜色，则将使用
  /// 该颜色而不是此颜色。
  final Color? activeColor;

  /// {@template flutter.material.switch.activeTrackColor}
  /// 当此开关打开时，轨道上使用的颜色。
  /// {@endtemplate}
  ///
  /// 默认为 [ColorScheme.secondary]，不透明度设置为 50%。
  ///
  /// 如果 [trackColor] 在 [MaterialState.selected] 状态中返回非 null 颜色，则将使用该
  /// 颜色而不是此颜色。
  final Color? activeTrackColor;

  /// {@template flutter.material.switch.inactiveThumbColor}
  /// 此开关关闭时要在 Thumb 上使用的颜色。
  /// {@endtemplate}
  ///
  /// 默认为 Material Design 规范中描述的颜色。
  ///
  /// 如果 [thumbColor] 在默认状态下返回非 null 颜色，则将使用该颜色而不是此颜色。
  final Color? inactiveThumbColor;

  /// {@template flutter.material.switch.inactiveTrackColor}
  /// 当此开关关闭时，轨道上使用的颜色。
  /// {@endtemplate}
  ///
  /// 默认为 Material Design 规范中描述的颜色。
  ///
  /// 如果 [trackColor] 在默认状态下返回非 null 颜色，则将使用该颜色而不是此颜色。
  final Color? inactiveTrackColor;

  /// {@template flutter.material.switch.activeThumbImage}
  /// 当开关打开时，在此开关的 Thumb 上使用的图像。
  /// {@endtemplate}
  final ImageProvider? activeThumbImage;

  /// {@template flutter.material.switch.onActiveThumbImageError}
  /// 一个可选的错误回调，用于加载 [activeThumbImage] 时发出的错误。
  /// {@endtemplate}
  final ImageErrorListener? onActiveThumbImageError;

  /// {@template flutter.material.switch.inactiveThumbImage}
  /// 当开关关闭时，在此开关的 thumb 上使用的图像。
  /// {@endtemplate}
  final ImageProvider? inactiveThumbImage;

  /// {@template flutter.material.switch.onInactiveThumbImageError}
  /// 加载 [inactiveThumbImage] 时发出的错误的可选错误回调。
  /// {@endtemplate}
  final ImageErrorListener? onInactiveThumbImageError;

  /// 参考 [Switch.thumbColor]
  final MaterialStateProperty<Color?>? thumbColor;

  /// 参考 [Switch.trackColor]
  final MaterialStateProperty<Color?>? trackColor;

  /// 参考 [Switch.trackOutlineColor]
  final MaterialStateProperty<Color?>? trackOutlineColor;

  /// 参考 [Switch.trackOutlineWidth]
  final MaterialStateProperty<double?>? trackOutlineWidth;

  /// 参考 [Switch.thumbIcon]
  final MaterialStateProperty<Icon?>? thumbIcon;

  /// {@template flutter.material.switch.materialTapTargetSize}
  /// 配置点按目标的最小大小。
  /// {@endtemplate}
  ///
  /// 如果为 null，则使用 [SwitchThemeData.materialTapTargetSize] 的值。如果该值也是 null，
  /// 则使用 [ThemeData.materialTapTargetSize] 的值。
  ///
  /// 另请参阅：
  ///
  ///  * [MaterialTapTargetSize]，了解这如何影响 Tap 目标。
  final MaterialTapTargetSize? materialTapTargetSize;

  /// {@macro flutter.cupertino.CupertinoSwitch.applyTheme}
  final bool? applyCupertinoTheme;

  /// {@macro flutter.cupertino.CupertinoSwitch.dragStartBehavior}
  final DragStartBehavior? dragStartBehavior;

  /// {@template flutter.material.switch.mouseCursor}
  /// 鼠标指针进入窗口小部件或悬停在 Widget 上时的光标。
  ///
  /// 如果 [mouseCursor] 是 [MaterialStateProperty]<MouseCursor>，则
  /// [MaterialStateProperty.resolve] 用于以下 [MaterialState]：
  ///
  ///  * [MaterialState.selected].
  ///  * [MaterialState.hovered].
  ///  * [MaterialState.focused].
  ///  * [MaterialState.disabled].
  /// {@endtemplate}
  ///
  /// 如果为 null，则使用 [SwitchThemeData.mouseCursor] 的值。如果该字段也是 null，则
  /// 使用 [MaterialStateMouseCursor.clickable]。
  ///
  /// 另请参阅：
  ///
  ///  * [MaterialStateMouseCursor]，一个实现 'MaterialStateProperty' 的
  ///     [MouseCursor]，用于需要接受 [MouseCursor] 或 [MaterialStateProperty] 的
  ///     API<MouseCursor>。
  final MouseCursor? mouseCursor;

  /// 按钮的 [Material] 具有输入焦点时的颜色。
  ///
  /// 如果 [overlayColor] 在 [MaterialState.focused] 状态中返回非 null 颜色，则将改用该颜色。
  ///
  /// 如果为 null，则 [SwitchThemeData.overlayColor] 的值用于焦点状态。如果该值也是
  /// null，则使用 [ThemeData.focusColor] 的值。
  final Color? focusColor;

  /// 当指针悬停在按钮上的 [Material] 时，按钮的 [Material] 的颜色。
  ///
  /// 如果 [overlayColor] 在 [MaterialState.hovered] 状态中返回非 null 颜色，则将改用该颜色。
  ///
  /// 如果为 null，则在悬停状态下使用 [SwitchThemeData.overlayColor] 的值。如果该值也是
  /// null，则使用 [ThemeData.hoverColor] 的值。
  final Color? hoverColor;

  /// {@template flutter.material.switch.overlayColor}
  /// 开关的 [Material] 的颜色。
  ///
  /// 处理以下状态：
  ///  * [MaterialState.pressed].
  ///  * [MaterialState.selected].
  ///  * [MaterialState.hovered].
  ///  * [MaterialState.focused].
  /// {@endtemplate}
  ///
  /// 如果为 null，则在按下、聚焦和悬停状态中使用具有 alpha [kRadialReactionAlpha]、
  /// [focusColor] 和 [hoverColor] 的 [activeColor] 的值。如果该值也是 null，则使用
  /// [SwitchThemeData.overlayColor] 的值。如果该值也为 null，则 alpha 为
  /// [kRadialReactionAlpha]、[ThemeData.focusColor] 和 [ThemeData.hoverColor]
  /// 的 [ColorScheme.secondary] 值将用于按下、聚焦和悬停状态。
  final MaterialStateProperty<Color?>? overlayColor;

  /// {@template flutter.material.switch.splashRadius}
  /// 圆形 [Material] 墨迹响应的飞溅半径。
  /// {@endtemplate}
  ///
  /// 如果为 null，则使用 [SwitchThemeData.splashRadius] 的值。如果该字段也为 null，
  /// 则使用 [kRadialReactionRadius]。
  final double? splashRadius;

  /// {@macro flutter.material.inkwell.onFocusChange}
  final ValueChanged<bool>? onFocusChange;

  /// {@macro flutter.widgets.Focus.autofocus}
  final bool? autofocus;

  /// 组件文字的方向。
  ///
  /// 会影响 [Switch] 组件的和 [decoration] 文字的方向。
  final TextDirection? textDirection;

  @override
  State<TxField<bool>> createState() => _TxSwitchFieldState();
}

class _TxSwitchFieldState extends TxFieldState<bool> {
  bool get _value => value ?? false;

  FocusNode? _focusNode;

  FocusNode get _effectiveFocusNode =>
      widget.focusNode ?? (_focusNode ??= FocusNode());

  void _handleFocusChanged(bool val) {
    if (widget.onFocusChange != null) {
      widget.onFocusChange!(val);
    }
    setState(() {
      // Rebuild the widget on focus change to show/hide the text selection
      // highlight.
    });
  }

  @override
  void didChange(bool? value) {
    super.didChange(value);
    setState(() {});
  }

  @override
  void dispose() {
    _focusNode?.unfocus();
    super.dispose();
  }

  @override
  TxSwitchField get widget => super.widget as TxSwitchField;

  @override
  Widget build(BuildContext context) {
    final FocusNode focusNode = _effectiveFocusNode;

    Widget switcher = Switch.adaptive(
      value: _value,
      onChanged: didChange,
      activeColor: widget.activeColor,
      activeTrackColor: widget.activeTrackColor,
      inactiveThumbColor: widget.inactiveThumbColor,
      activeThumbImage: widget.activeThumbImage,
      onActiveThumbImageError: widget.onActiveThumbImageError,
      inactiveThumbImage: widget.inactiveThumbImage,
      onInactiveThumbImageError: widget.onInactiveThumbImageError,
      materialTapTargetSize:
          widget.materialTapTargetSize ?? MaterialTapTargetSize.shrinkWrap,
      thumbColor: widget.thumbColor,
      trackColor: widget.trackColor,
      trackOutlineColor: widget.trackOutlineColor,
      trackOutlineWidth: widget.trackOutlineWidth,
      thumbIcon: widget.thumbIcon,
      dragStartBehavior: widget.dragStartBehavior ?? DragStartBehavior.start,
      mouseCursor: widget.mouseCursor,
      focusColor: widget.focusColor,
      hoverColor: widget.hoverColor,
      overlayColor: widget.overlayColor,
      splashRadius: widget.splashRadius,
      focusNode: widget.focusNode,
      onFocusChange: _handleFocusChanged,
      autofocus: widget.autofocus ?? false,
      applyCupertinoTheme: widget.applyCupertinoTheme,
    );

    if (widget.decoration != null) {
      final textDirection = widget.textDirection ?? Directionality.of(context);
      switcher = Align(
        alignment: switch (textDirection) {
          TextDirection.ltr => Alignment.centerLeft,
          TextDirection.rtl => Alignment.centerRight,
        },
        child: switcher,
      );

      switcher = InputDecorator(
        decoration: effectiveDecoration,
        isFocused: focusNode.hasFocus,
        textAlign: TextAlign.end,
        child: switcher,
      );

      if (widget.textDirection == null) {
        return switcher;
      }

      return Directionality(
        textDirection: widget.textDirection!,
        child: switcher,
      );
    }

    return switcher;
  }

  @override
  String? get defaultHintText => null;
}

/// [field] 为 [TxSwitchField] 的 [TxFieldTile]。
class TxSwitchFieldTile extends TxFieldTile {
  TxSwitchFieldTile({
    InputDecoration? decoration,
    bool? initialValue,
    ValueChanged<bool>? onChanged,
    Color? activeColor,
    Color? activeTrackColor,
    Color? inactiveThumbColor,
    Color? inactiveTrackColor,
    ImageProvider? activeThumbImage,
    ImageErrorListener? onActiveThumbImageError,
    ImageProvider? inactiveThumbImage,
    ImageErrorListener? onInactiveThumbImageError,
    MaterialStateProperty<Color?>? thumbColor,
    MaterialStateProperty<Color?>? trackColor,
    MaterialStateProperty<Color?>? trackOutlineColor,
    MaterialStateProperty<double?>? trackOutlineWidth,
    MaterialStateProperty<Icon?>? thumbIcon,
    MaterialTapTargetSize? materialTapTargetSize,
    DragStartBehavior? dragStartBehavior,
    MouseCursor? mouseCursor,
    MaterialStateProperty<Color?>? overlayColor,
    double? splashRadius,
    Color? focusColor,
    FocusNode? focusNode,
    ValueChanged<bool>? onFocusChange,
    bool? autofocus,
    Color? hoverColor,
    bool? applyCupertinoTheme,
    TextDirection? textDirection,
    super.key,
    super.labelBuilder,
    super.labelText,
    super.padding,
    super.actions,
    super.labelStyle,
    super.horizontalGap,
    super.tileColor,
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
    super.dense,
    super.minLabelWidth,
    super.minVerticalPadding,
  }) : super(
          layoutDirection: Axis.horizontal,
          field: TxSwitchField(
            initialValue: initialValue,
            onChanged: onChanged,
            activeColor: activeColor,
            activeTrackColor: activeTrackColor,
            inactiveThumbColor: inactiveThumbColor,
            activeThumbImage: activeThumbImage,
            onActiveThumbImageError: onActiveThumbImageError,
            inactiveThumbImage: inactiveThumbImage,
            onInactiveThumbImageError: onInactiveThumbImageError,
            materialTapTargetSize: materialTapTargetSize,
            thumbColor: thumbColor,
            trackColor: trackColor,
            trackOutlineColor: trackOutlineColor,
            trackOutlineWidth: trackOutlineWidth,
            thumbIcon: thumbIcon,
            dragStartBehavior: dragStartBehavior,
            mouseCursor: mouseCursor,
            focusColor: focusColor,
            hoverColor: hoverColor,
            overlayColor: overlayColor,
            splashRadius: splashRadius,
            focusNode: focusNode,
            onFocusChange: onFocusChange,
            autofocus: autofocus,
            applyCupertinoTheme: applyCupertinoTheme,
            enabled: enabled,
            decoration: decoration,
            textDirection: textDirection ?? TextDirection.rtl,
          ),
        );
}
