import 'package:flutter/material.dart';

import '../widgets/tile.dart';
import 'form_field_theme.dart';

typedef TxFormFieldBuilder<T> = Widget Function(TxFormFieldState<T> field);

typedef FieldActionsBuilder<T> = List<Widget> Function(
  TxFormFieldState<T> field,
);

const BorderRadius _kBorderRadius = BorderRadius.all(Radius.circular(10.0));

/// 域组件
///
/// 通常用于包装一个输入或者选择组件
class TxFormField<T> extends FormField<T> {
  /// 创建一个输入框组件
  TxFormField({
    required TxFormFieldBuilder<T> builder,
    super.key,
    super.initialValue,
    super.onSaved,
    super.validator,
    super.autovalidateMode = AutovalidateMode.onUserInteraction,
    super.restorationId,
    this.decoration,
    bool? enabled,
    this.onChanged,
    this.hintText,
    this.textAlign,
    this.bordered,
    this.labelText,
    this.label,
    bool? required,
    TextStyle? labelStyle,
    TextAlign? labelTextAlign,
    TextOverflow? labelOverflow,
    Color? tileColor,
    Axis? layoutDirection,
    EdgeInsetsGeometry? padding,
    FieldActionsBuilder<T>? actionsBuilder,
    TxFormFieldBuilder<T>? trailingBuilder,
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
  })  : required = required ?? false,
        super(
          builder: (field) {
            final TxFormFieldState<T> state = field as TxFormFieldState<T>;

            final List<InlineSpan> spans = [
              if (required == true)
                const TextSpan(
                  text: '*\t',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              if (label != null)
                WidgetSpan(
                  child: label,
                  alignment: PlaceholderAlignment.middle,
                ),
              if (labelText != null && labelText.isNotEmpty)
                TextSpan(text: labelText),
            ];

            return TxTile(
              content: builder(state),
              label:
                  spans.isEmpty ? null : Text.rich(TextSpan(children: spans)),
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
          },
          enabled: enabled ?? decoration?.enabled ?? true,
        );

  TxFormField.decorated({
    required TxFormFieldBuilder<T> builder,
    FocusNode? focusNode,
    bool? canRequestFocus,
    super.key,
    super.initialValue,
    super.onSaved,
    super.validator,
    super.autovalidateMode = AutovalidateMode.onUserInteraction,
    super.restorationId,
    this.decoration,
    bool? enabled,
    this.onChanged,
    this.hintText,
    this.textAlign,
    this.bordered,
    this.labelText,
    this.label,
    bool? required,
    TextStyle? labelStyle,
    TextAlign? labelTextAlign,
    TextOverflow? labelOverflow,
    Color? tileColor,
    Axis? layoutDirection,
    EdgeInsetsGeometry? padding,
    FieldActionsBuilder<T>? actionsBuilder,
    TxFormFieldBuilder<T>? trailingBuilder,
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
    ValueChanged<TxFormFieldState<T>>? onFieldTap,
  })  : required = required ?? false,
        super(
          builder: (field) {
            final TxFormFieldState<T> state = field as TxFormFieldState<T>;

            final TextAlign effectiveTextAlign = textAlign ??
                (layoutDirection == Axis.horizontal
                    ? TextAlign.right
                    : TextAlign.left);

            final EdgeInsetsGeometry? contentPadding = state
                    .effectiveDecoration.contentPadding ??
                (layoutDirection == Axis.horizontal ? EdgeInsets.zero : null);

            final List<InlineSpan> spans = [
              if (required == true)
                const TextSpan(
                  text: '*\t',
                  style: TextStyle(color: Colors.red),
                ),
              if (label != null)
                WidgetSpan(
                  child: label,
                  alignment: PlaceholderAlignment.middle,
                ),
              if (labelText != null && labelText.isNotEmpty)
                TextSpan(text: labelText),
            ];

            return TxTile(
              content: TxFieldDecorator(
                focusNode: focusNode,
                canRequestFocus: canRequestFocus ?? true,
                enabled: state.isEnabled,
                decoration: state.effectiveDecoration.copyWith(
                  contentPadding: contentPadding,
                ),
                textAlign: effectiveTextAlign,
                isEmpty: state.isEmpty,
                onTap: onFieldTap == null ? null : () => onFieldTap(field),
                child: builder(state),
              ),
              label:
                  spans.isEmpty ? null : Text.rich(TextSpan(children: spans)),
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
          },
          enabled: enabled ?? decoration?.enabled ?? true,
        );

  /// 值变更回调
  final ValueChanged<T?>? onChanged;

  /// 要在文本字段周围显示的装饰。
  ///
  /// 默认情况下，在文本字段下绘制一条水平线，但可以配置为显示图标、标签、提示文本和错误文本。
  ///
  /// 指定 null 可完全删除修饰（包括修饰引入的额外填充，以节省标签空间）。
  final InputDecoration? decoration;

  /// 提示文字
  ///
  /// 当 [decoration] 的 hintText属性 为空时会使用此值代替。
  final String? hintText;

  /// 文字对齐方向
  final TextAlign? textAlign;

  /// 是否显示边框
  final bool? bordered;

  /// 标题文字
  final String? labelText;

  /// 参考 [TxTile.label]
  final Widget? label;

  /// 是否必填
  final bool required;

  @override
  FormFieldState<T> createState() => TxFormFieldState<T>();
}

class TxFormFieldState<T> extends FormFieldState<T> {
  @override
  TxFormField<T> get widget => super.widget as TxFormField<T>;

  /// 最终生效的 label
  Widget? get effectiveLabel {
    if (!widget.required) {
      return widget.label ??
          (widget.labelText != null ? Text(widget.labelText!) : null);
    }
    final InlineSpan? labelSpan = widget.label != null
        ? WidgetSpan(
            child: widget.label!,
            alignment: PlaceholderAlignment.top,
          )
        : widget.labelText != null
            ? TextSpan(text: widget.labelText)
            : null;
    const TextSpan starSpan = TextSpan(
      text: '*\t',
      style: TextStyle(color: Colors.red),
    );
    return Text.rich(
      TextSpan(
        children: [starSpan, if (labelSpan != null) labelSpan],
      ),
    );
  }

  bool get isEnabled => widget.enabled;

  bool get isEmpty => value == null;

  /// 头部图标
  Widget? get prefixIcon => null;

  /// 尾部图标
  List<Widget>? get suffixIcons => null;

  /// 最终生效的装饰器
  InputDecoration get effectiveDecoration {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TxFormFieldThemeData fieldTheme = TxFormFieldTheme.of(context);
    final TxFormFieldThemeData defaults = _TxFieldThemeDefaultsM3(context);

    final InputDecorationTheme inputDecorationTheme =
        fieldTheme.inputDecorationTheme ?? defaults.inputDecorationTheme!;
    final String? hintText =
        isEnabled ? (widget.decoration?.hintText ?? widget.hintText) : '';
    InputDecoration decoration = widget.decoration ?? const InputDecoration();
    final BoxConstraints? constraints =
        decoration.isDense == true ? const BoxConstraints(minHeight: 44) : null;

    final IconButtonThemeData iconButtonThemeData = IconButtonThemeData(
      style: IconButton.styleFrom(
        visualDensity: VisualDensity.compact,
        padding: EdgeInsets.zero,
      ),
    );

    Widget? effectivePrefixIcon = decoration.prefixIcon ?? prefixIcon;
    if (effectivePrefixIcon != null) {
      effectivePrefixIcon = IconButtonTheme(
        data: iconButtonThemeData,
        child: effectivePrefixIcon,
      );
    }

    final List<Widget> sufIcons = suffixIcons ?? [];
    if (decoration.suffixIcon != null) {
      sufIcons.add(decoration.suffixIcon!);
    }
    Widget? suffixIcon;
    if (sufIcons.isNotEmpty) {
      final iconConstraints = decoration.suffixIconConstraints ??
          theme.visualDensity.effectiveConstraints(
            const BoxConstraints(
              minWidth: kMinInteractiveDimension,
              minHeight: kMinInteractiveDimension,
            ),
          );
      suffixIcon = IconButtonTheme(
        data: iconButtonThemeData,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: sufIcons
              .map(
                (icon) => ConstrainedBox(
                  constraints: iconConstraints,
                  child: icon,
                ),
              )
              .toList(),
        ),
      );
    }

    decoration = decoration.copyWith(
      enabled: isEnabled,
      hintText: hintText,
      prefixIconConstraints: decoration.prefixIconConstraints ?? constraints,
      suffixIconConstraints: decoration.suffixIconConstraints ?? constraints,
      prefixIcon: effectivePrefixIcon,
      suffixIcon: suffixIcon,
      errorText: errorText,
      // constraints: const BoxConstraints(minHeight: 48.0),
    );

    final bool bordered =
        widget.bordered ?? fieldTheme.bordered ?? defaults.bordered!;
    if (bordered) {
      InputBorder? border = decoration.border ??
          decoration.enabledBorder ??
          decoration.focusedBorder ??
          decoration.disabledBorder ??
          decoration.errorBorder ??
          decoration.focusedErrorBorder;

      final BorderSide borderSide =
          (border == null || border == InputBorder.none)
              ? inputDecorationTheme.outlineBorder ??
                  defaults.inputDecorationTheme!.outlineBorder!
              : border.borderSide;

      if (border == null || !border.isOutline) {
        border = OutlineInputBorder(
          borderSide: borderSide,
          borderRadius: _kBorderRadius,
        );
      }

      InputBorder resolveBorder([Color? color]) {
        return border!.copyWith(borderSide: borderSide.copyWith(color: color));
      }

      final InputBorder inputBorder = decoration.border ?? resolveBorder();
      final InputBorder focusedBorder =
          decoration.focusedBorder ?? resolveBorder(colorScheme.primary);
      final InputBorder disabledBorder = decoration.disabledBorder ??
          resolveBorder(colorScheme.outline.withValues(alpha: 0.3));
      final InputBorder errorBorder =
          decoration.errorBorder ?? resolveBorder(colorScheme.error);
      decoration = decoration.copyWith(
        border: inputBorder,
        enabledBorder: decoration.enabledBorder ?? inputBorder,
        disabledBorder: disabledBorder,
        focusedBorder: focusedBorder,
        errorBorder: errorBorder,
        focusedErrorBorder: decoration.focusedErrorBorder ?? errorBorder,
        contentPadding: decoration.contentPadding ?? const EdgeInsets.all(12.0),
      );
    }

    return decoration.applyDefaults(inputDecorationTheme);
  }

  /// 选择项变更回调
  @override
  void didChange(T? value) {
    super.didChange(value);
    if (widget.onChanged != null) {
      widget.onChanged!(value);
    }
  }

  @override
  void didUpdateWidget(covariant TxFormField<T> oldWidget) {
    if (value != widget.initialValue) {
      setValue(widget.initialValue);
    }
    super.didUpdateWidget(oldWidget);
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
    required this.onTap,
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

  /// 装饰器区域点击事件
  final VoidCallback? onTap;

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
    final Widget child = Focus(
      focusNode: effectiveFocusNode,
      child: InputDecorator(
        decoration: widget.decoration,
        textAlign: widget.textAlign,
        isFocused: effectiveFocusNode.hasFocus,
        isEmpty: widget.isEmpty,
        child: widget.child,
      ),
    );

    if (widget.onTap == null) {
      return child;
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      excludeFromSemantics: true,
      onTap: widget.onTap,
      child: child,
    );
  }
}

class _TxFieldThemeDefaultsM3 extends TxFormFieldThemeData {
  _TxFieldThemeDefaultsM3(BuildContext context)
      : theme = Theme.of(context),
        super(bordered: true);

  final ThemeData theme;

  @override
  InputDecorationTheme? get inputDecorationTheme =>
      theme.inputDecorationTheme.merge(
        InputDecorationTheme(
          hintStyle: theme.textTheme.bodyLarge!.copyWith(
            color: WidgetStateColor.resolveWith((states) =>
                states.contains(WidgetState.disabled)
                    ? theme.disabledColor
                    : theme.hintColor),
          ),
          outlineBorder: BorderSide(color: theme.colorScheme.outlineVariant),
          enabledBorder: InputBorder.none,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
        ),
      );
}
