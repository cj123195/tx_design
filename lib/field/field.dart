import 'package:flutter/material.dart';

import '../widgets/tile.dart';
import 'field_theme.dart';

typedef FieldBuilder<T> = Widget Function(TxFieldState<T> field);

typedef FieldActionsBuilder<T> = List<Widget> Function(
  TxFieldState<T> field,
);

/// 域组件
///
/// 通常用于包装一个输入或者选择组件
class TxField<T> extends StatefulWidget {
  /// 创建一个输入框组件
  TxField({
    required FieldBuilder<T> builder,
    super.key,
    this.initialValue,
    this.decoration,
    this.enabled,
    this.onChanged,
    this.hintText,
    this.textAlign,
    this.bordered,
    String? labelText,
    Widget? label,
    TextStyle? labelStyle,
    TextAlign? labelTextAlign,
    TextOverflow? labelOverflow,
    Color? tileColor,
    Axis? layoutDirection,
    EdgeInsetsGeometry? padding,
    FieldActionsBuilder<T>? actionsBuilder,
    FieldBuilder<T>? trailingBuilder,
    Widget? leading,
    double? horizontalGap,
    VisualDensity? visualDensity,
    ShapeBorder? shape,
    Color? iconColor,
    Color? textColor,
    TextStyle? leadingAndTrailingTextStyle,
    GestureTapCallback? onTap,
    double? minLeadingWidth,
    double? minLabelWidth,
    double? minVerticalPadding,
    bool? dense,
    bool? colon,
    Color? focusColor,
  }) : builder = ((field) {
          return TxTile(
            content: builder(field),
            label: label,
            labelText: labelText,
            labelTextAlign: labelTextAlign,
            padding: padding,
            actions: actionsBuilder == null ? null : actionsBuilder(field),
            trailing: trailingBuilder == null ? null : trailingBuilder(field),
            labelStyle: labelStyle,
            horizontalGap: horizontalGap,
            tileColor: tileColor,
            layoutDirection: layoutDirection,
            leading: leading,
            visualDensity: visualDensity,
            shape: shape,
            iconColor: iconColor,
            textColor: textColor,
            leadingAndTrailingTextStyle: leadingAndTrailingTextStyle,
            enabled: field.isEnabled,
            onTap: onTap,
            minLeadingWidth: minLeadingWidth,
            minLabelWidth: minLabelWidth,
            dense: dense,
            colon: colon,
            focusColor: focusColor,
          );
        });

  TxField.decorated({
    required FieldBuilder<T> builder,
    FocusNode? focusNode,
    bool? canRequestFocus,
    super.key,
    this.initialValue,
    this.decoration,
    this.enabled,
    this.onChanged,
    this.hintText,
    this.textAlign,
    this.bordered,
    String? labelText,
    Widget? label,
    TextStyle? labelStyle,
    TextAlign? labelTextAlign,
    TextOverflow? labelOverflow,
    Color? tileColor,
    Axis? layoutDirection,
    EdgeInsetsGeometry? padding,
    FieldActionsBuilder<T>? actionsBuilder,
    FieldBuilder<T>? trailingBuilder,
    Widget? leading,
    double? horizontalGap,
    VisualDensity? visualDensity,
    ShapeBorder? shape,
    Color? iconColor,
    Color? textColor,
    TextStyle? leadingAndTrailingTextStyle,
    GestureTapCallback? onTap,
    double? minLeadingWidth,
    double? minLabelWidth,
    double? minVerticalPadding,
    bool? dense,
    bool? colon,
    Color? focusColor,
  }) : builder = ((field) {
          return TxTile(
            content: TxFieldDecorator(
              focusNode: focusNode,
              canRequestFocus: canRequestFocus ?? true,
              enabled: field.isEnabled,
              decoration: field.effectiveDecoration,
              textAlign: field.effectiveTextAlign,
              isEmpty: field.isEmpty,
              child: builder(field),
            ),
            label: label,
            labelText: labelText,
            labelTextAlign: labelTextAlign,
            padding: padding,
            actions: actionsBuilder == null ? null : actionsBuilder(field),
            trailing: trailingBuilder == null ? null : trailingBuilder(field),
            labelStyle: labelStyle,
            horizontalGap: horizontalGap,
            tileColor: tileColor,
            layoutDirection: layoutDirection,
            leading: leading,
            visualDensity: visualDensity,
            shape: shape,
            iconColor: iconColor,
            textColor: textColor,
            leadingAndTrailingTextStyle: leadingAndTrailingTextStyle,
            enabled: field.isEnabled,
            onTap: onTap,
            minLeadingWidth: minLeadingWidth,
            minLabelWidth: minLabelWidth,
            minVerticalPadding: minVerticalPadding,
            dense: dense,
            colon: colon,
            focusColor: focusColor,
          );
        });

  /// field 组件构造器
  final FieldBuilder<T> builder;

  /// 初始值
  final T? initialValue;

  /// 值变更回调
  final ValueChanged<T?>? onChanged;

  /// 要在文本字段周围显示的装饰。
  ///
  /// 默认情况下，在文本字段下绘制一条水平线，但可以配置为显示图标、标签、提示文本和错误文本。
  ///
  /// 指定 null 可完全删除修饰（包括修饰引入的额外填充，以节省标签空间）。
  final InputDecoration? decoration;

  /// 如果为 false，则文本字段为 “disabled”：它忽略 taps，并且其 [decoration] 呈现为灰色。
  ///
  /// 如果为非 null，则此属性将覆盖 [decoration] 的 [InputDecoration.enabled] 属性。
  final bool? enabled;

  /// 提示文字
  ///
  /// 当 [decoration] 的 hintText属性 为空时会使用此值代替。
  final String? hintText;

  /// 文字对齐方向
  final TextAlign? textAlign;

  /// 是否显示边框
  final bool? bordered;

  @override
  State<TxField<T>> createState() => TxFieldState<T>();
}

class TxFieldState<T> extends State<TxField<T>> {
  T? _value;

  T? get value => _value;

  bool get isEnabled => widget.enabled ?? widget.decoration?.enabled ?? true;

  bool get isEmpty => value == null;

  /// 头部图标
  List<Widget>? get prefixIcons => null;

  /// 尾部图标
  List<Widget>? get suffixIcons => null;

  /// 最终生效的装饰器
  InputDecoration get effectiveDecoration {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TxFieldThemeData fieldTheme = TxFieldTheme.of(context);
    final TxFieldThemeData defaults = _TxFieldThemeDefaultsM3(context);

    final InputDecorationTheme inputDecorationTheme =
        fieldTheme.inputDecorationTheme ?? defaults.inputDecorationTheme!;
    final String? hintText = widget.decoration?.hintText ?? widget.hintText;
    InputDecoration decoration = (widget.decoration ?? const InputDecoration())
        .applyDefaults(inputDecorationTheme);
    final BoxConstraints? constraints = decoration.isDense == true
        ? const BoxConstraints(maxHeight: kMinInteractiveDimension / 2)
        : null;

    const IconThemeData iconThemeData = IconThemeData(size: 16.0);
    final IconButtonThemeData iconButtonThemeData = IconButtonThemeData(
      style: IconButton.styleFrom(
        visualDensity: VisualDensity.compact,
        padding: EdgeInsets.zero,
      ),
    );

    final List<Widget> preIcons = prefixIcons ?? [];
    if (decoration.prefixIcon != null) {
      preIcons.insert(0, decoration.prefixIcon!);
    }
    Widget? prefixIcon;
    if (preIcons.isNotEmpty) {
      prefixIcon = IconTheme.merge(
        data: iconThemeData,
        child: IconButtonTheme(
          data: iconButtonThemeData,
          child: preIcons.length == 1
              ? preIcons[0]
              : Row(mainAxisSize: MainAxisSize.min, children: preIcons),
        ),
      );
    }

    final List<Widget> sufIcons = suffixIcons ?? [];
    if (decoration.suffixIcon != null) {
      sufIcons.add(decoration.suffixIcon!);
    }
    Widget? suffixIcon;
    if (sufIcons.isNotEmpty) {
      suffixIcon = IconTheme.merge(
        data: iconThemeData,
        child: IconButtonTheme(
          data: iconButtonThemeData,
          child: sufIcons.length == 1
              ? sufIcons[0]
              : Row(mainAxisSize: MainAxisSize.min, children: sufIcons),
        ),
      );
    }

    decoration = decoration.copyWith(
      enabled: isEnabled,
      hintText: hintText,
      prefixIconConstraints: decoration.prefixIconConstraints ?? constraints,
      suffixIconConstraints: decoration.suffixIconConstraints ?? constraints,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: true,
    );

    final bool bordered =
        widget.bordered ?? fieldTheme.bordered ?? defaults.bordered!;
    if (bordered) {
      final BorderRadius borderRadius = BorderRadius.circular(8.0);
      final InputBorder inputBorder = OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: colorScheme.outline, width: 0.5),
      );
      final InputBorder focusedBorder = OutlineInputBorder(
        borderSide: BorderSide(color: colorScheme.primary, width: 0.5),
        borderRadius: borderRadius,
      );
      final InputBorder disabledBorder = OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide:
            BorderSide(color: colorScheme.outline.withOpacity(0.3), width: 0.5),
      );
      final InputBorder errorBorder = OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: colorScheme.error, width: 0.5),
      );
      return decoration.copyWith(
          border: decoration.border == InputBorder.none
              ? inputBorder
              : decoration.border,
          enabledBorder: decoration.enabledBorder == InputBorder.none
              ? inputBorder
              : decoration.enabledBorder,
          disabledBorder: decoration.disabledBorder == InputBorder.none
              ? disabledBorder
              : decoration.disabledBorder,
          focusedBorder: decoration.focusedBorder == InputBorder.none
              ? focusedBorder
              : decoration.focusedBorder,
          errorBorder: decoration.errorBorder == InputBorder.none
              ? errorBorder
              : decoration.errorBorder,
          focusedErrorBorder: decoration.focusedErrorBorder == InputBorder.none
              ? errorBorder
              : decoration.focusedErrorBorder);
    }

    return decoration;
  }

  /// 最终生效的对齐方式
  TextAlign? get effectiveTextAlign =>
      widget.textAlign ??
      TxFieldTheme.of(context).textAlign ??
      _TxFieldThemeDefaultsM3(context).textAlign;

  /// 选择项变更回调
  @mustCallSuper
  void didChange(T? value) {
    if (value != _value) {
      _value = value;
      if (widget.onChanged != null) {
        widget.onChanged!(_value);
      }
    }
  }

  @override
  void initState() {
    _value = widget.initialValue;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant TxField<T> oldWidget) {
    if (_value != widget.initialValue) {
      _value = widget.initialValue;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(this);
  }
}

/// 装饰器容器
class TxFieldDecorator extends StatefulWidget {
  /// 创建一个装饰器容器
  const TxFieldDecorator({
    required this.focusNode,
    required this.canRequestFocus,
    required this.enabled,
    required this.decoration,
    required this.textAlign,
    required this.isEmpty,
    required this.child,
    super.key,
  });

  /// 焦点
  final FocusNode? focusNode;

  /// 是否允许请求焦点
  final bool canRequestFocus;

  /// 是否可用
  final bool enabled;

  /// 装饰器
  final InputDecoration decoration;

  /// 文字对齐方式
  final TextAlign? textAlign;

  /// 是否为空
  final bool isEmpty;

  /// 子组件
  final Widget child;

  @override
  State<TxFieldDecorator> createState() => _TxFieldDecoratorState();
}

class _TxFieldDecoratorState extends State<TxFieldDecorator> {
  FocusNode? _focusNode;

  FocusNode get effectiveFocusNode =>
      widget.focusNode ?? (_focusNode ??= FocusNode());

  bool get _canRequestFocus {
    final NavigationMode mode =
        MediaQuery.maybeNavigationModeOf(context) ?? NavigationMode.traditional;
    switch (mode) {
      case NavigationMode.traditional:
        return widget.canRequestFocus && widget.enabled;
      case NavigationMode.directional:
        return true;
    }
  }

  void _handleFocusChanged() {
    setState(() {
      // Rebuild the widget on focus change to show/hide the text selection
      // highlight.
    });
  }

  @override
  void initState() {
    super.initState();
    effectiveFocusNode.canRequestFocus =
        widget.canRequestFocus && widget.enabled;
    effectiveFocusNode.addListener(_handleFocusChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    effectiveFocusNode.canRequestFocus = _canRequestFocus;
  }

  @override
  void didUpdateWidget(covariant TxFieldDecorator oldWidget) {
    effectiveFocusNode.canRequestFocus = _canRequestFocus;

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    effectiveFocusNode.removeListener(_handleFocusChanged);
    _focusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: effectiveFocusNode,
      child: InputDecorator(
        decoration: widget.decoration,
        textAlign: widget.textAlign,
        isFocused: effectiveFocusNode.hasFocus,
        isEmpty: widget.isEmpty,
        child: widget.child,
      ),
    );
  }
}

class _TxFieldThemeDefaultsM3 extends TxFieldThemeData {
  _TxFieldThemeDefaultsM3(BuildContext context)
      : super(
          inputDecorationTheme: Theme.of(context).inputDecorationTheme.copyWith(
                border: const OutlineInputBorder(),
                // border: InputBorder.none,
                // enabledBorder: InputBorder.none,
                // disabledBorder: InputBorder.none,
                // focusedBorder: InputBorder.none,
                isDense: true,
                outlineBorder: const BorderSide(color: Colors.red),
              ),
          bordered: false,
        );
}
