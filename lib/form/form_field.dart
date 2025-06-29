import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../extensions/iterable_extension.dart';
import '../localizations.dart';
import '../utils/basic_types.dart';
import '../widgets/tile.dart';
import 'form_field_theme.dart';
import 'form_item_container.dart';
import 'form_item_theme.dart';

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
    @Deprecated('This feature was deprecated after v0.3.0.')
    this.defaultValidator,
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
    @Deprecated('This feature was deprecated after v0.3.0.')
    this.defaultValidator,
    bool? required,
    TextStyle? labelStyle,
    TextAlign? labelTextAlign,
    TextOverflow? labelOverflow,
    Color? tileColor,
    Axis layoutDirection = Axis.horizontal,
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

  @Deprecated('This feature was deprecated after v0.3.0.')
  final String? Function(BuildContext context, T? value)? defaultValidator;

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
  List<Widget>? get prefixIcons => null;

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

    final IconThemeData iconThemeData = IconThemeData(color: theme.hintColor);
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
          child: Row(mainAxisSize: MainAxisSize.min, children: preIcons),
        ),
      );
      if (decoration.prefixIconConstraints == null) {
        prefixIcon = Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: prefixIcon,
        );
      }
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
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: sufIcons,
          ),
        ),
      );
    }

    decoration = decoration.copyWith(
      enabled: isEnabled,
      hintText: hintText,
      prefixIconConstraints: decoration.prefixIconConstraints ??
          (constraints ?? const BoxConstraints()).copyWith(minWidth: 0),
      suffixIconConstraints: decoration.suffixIconConstraints ?? constraints,
      prefixIcon: prefixIcon,
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
              ? inputDecorationTheme.outlineBorder!
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
          resolveBorder(colorScheme.outline.withOpacity(0.3));
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

class _TxFieldThemeDefaultsM3 extends TxFormFieldThemeData {
  _TxFieldThemeDefaultsM3(BuildContext context)
      : theme = Theme.of(context),
        super(bordered: false);

  final ThemeData theme;

  @override
  InputDecorationTheme? get inputDecorationTheme =>
      theme.inputDecorationTheme.copyWith(
        // isDense: true,
        outlineBorder: BorderSide(color: theme.colorScheme.outlineVariant),
        hintStyle: theme.textTheme.bodyMedium!.copyWith(
          color: MaterialStateColor.resolveWith((states) =>
              states.contains(MaterialState.disabled)
                  ? theme.disabledColor
                  : theme.hintColor),
        ),
        enabledBorder: InputBorder.none,
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
      );
}

@Deprecated('This feature was deprecated after v0.3.0.')
class TxFormFieldItem<T> extends TxFormField<T> {
  @Deprecated('This feature was deprecated after v0.3.0.')
  TxFormFieldItem({
    required FormFieldBuilder<T> builder,
    super.key,
    super.onSaved,
    super.validator,
    super.initialValue,
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    super.defaultValidator,
    super.bordered,
    bool? required,
    Widget? label,
    String? labelText,
    TextAlign? labelTextAlign,
    TextOverflow? labelOverflow,
    Color? backgroundColor,
    Axis? direction,
    EdgeInsetsGeometry? padding,
    List<Widget>? Function(FormFieldState<T> field)? actionsBuilder,
    TextStyle? labelStyle,
    TextStyle? starStyle,
    double? horizontalGap,
    double? minLabelWidth,
  }) : super(
          builder: (TxFormFieldState<T> field) {
            return UnmanagedRestorationScope(
              bucket: field.bucket,
              child: FormItemContainer(
                formField: builder(field),
                required: required,
                label: label,
                labelText: labelText,
                backgroundColor: backgroundColor,
                direction: direction,
                padding: padding,
                actions: actionsBuilder?.call(field),
                labelStyle: labelStyle,
                starStyle: starStyle,
                horizontalGap: horizontalGap,
                minLabelWidth: minLabelWidth,
              ),
            );
          },
        );

  @Deprecated('This feature was deprecated after v0.3.0.')
  static InputDecoration mergeDecoration(
    BuildContext context,
    InputDecoration? decoration,
    InputDecoration defaultDecoration, [
    IconMergeMode? prefixIconMergeMode,
    IconMergeMode? suffixIconMergeMode,
  ]) {
    final ThemeData theme = Theme.of(context);
    final FormItemThemeData formItemTheme = FormItemTheme.of(context);
    final InputDecorationTheme decorationTheme =
        formItemTheme.inputDecorationTheme ?? theme.inputDecorationTheme;
    return defaultDecoration
        .merge(
          decoration,
          suffixMergeMode: suffixIconMergeMode,
          prefixMergeMode: prefixIconMergeMode,
        )
        .applyDefaults(decorationTheme);
  }
}

/// 通用选择Form组件
@Deprecated('This feature was deprecated after v0.3.0.')
class TxPickerFormFieldItem<T, V> extends TxFormFieldItem<T> {
  /// 创建一个通用选择Form组件
  /// [labelMapper] 标签，用于展示
  /// [sources] 数据源
  /// [valueMapper] 数据值，主要用于比较赋值
  /// [enabledMapper] 数据是否可被选择
  /// [inputEnabledMapper] 数据是否支持修改，该值不为null时，[dataMapper]必传
  /// [dataMapper] 根据输入值生成[T]类型数据
  @Deprecated('This feature was deprecated after v0.3.0.')
  TxPickerFormFieldItem({
    required FormFieldBuilder<T> builder,
    required ValueMapper<T, String> labelMapper,
    required List<T>? sources,
    ValueMapper<T, V>? valueMapper,
    ValueMapper<T, bool>? enabledMapper,
    ValueMapper<T, bool>? inputEnabledMapper,
    ValueMapper<T, bool>? dataMapper,
    ValueChanged<T?>? onChanged,
    InputDecoration? decoration,
    super.key,
    super.onSaved,
    super.validator,
    V? initialValue,
    T? initialData,
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    super.required,
    super.label,
    super.labelText,
    super.labelTextAlign,
    super.labelOverflow,
    super.backgroundColor,
    super.direction,
    super.padding,
    super.actionsBuilder,
    super.labelStyle,
    super.starStyle,
    super.horizontalGap,
    super.minLabelWidth,
  })  : assert(inputEnabledMapper == null || dataMapper != null),
        super(
          builder: (field) {
            final InputDecoration defaultDecoration = InputDecoration(
              hintText: TxLocalizations.of(field.context).pickerFormFieldHint,
            );
            final InputDecoration effectiveDecoration =
                TxFormFieldItem.mergeDecoration(
              field.context,
              decoration,
              defaultDecoration,
            );
            return InputDecorator(
              decoration:
                  effectiveDecoration.copyWith(errorText: field.errorText),
              child: builder(field),
            );
          },
          defaultValidator: required == true
              ? (context, value) => value == null
                  ? TxLocalizations.of(context).pickerFormFieldHint
                  : null
              : null,
          initialValue: initialData ??
              sources?.tryFind((e) {
                final V value = (valueMapper?.call(e) ?? labelMapper(e)) as V;
                return initialValue == value;
              }),
        );
}

/// 通用多项选择Form组件
@Deprecated('This feature was deprecated after v0.3.0.')
class TxMultiPickerFormFieldItem<T, V> extends TxFormFieldItem<Set<T>> {
  /// 创建一个通用选择Form组件
  /// [labelMapper] 标签，用于展示
  /// [sources] 数据源
  /// [valueMapper] 数据值，主要用于比较赋值
  /// [enabledMapper] 数据是否可被选择
  /// [inputEnabledMapper] 数据是否支持修改，该值不为null时，[dataMapper]必传
  /// [dataMapper] 根据输入值生成[T]类型数据
  /// [minPickNumber] 最小可选择数量
  /// [maxPickNumber] 最大可选择数量
  @Deprecated('This feature was deprecated after v0.3.0.')
  TxMultiPickerFormFieldItem({
    required FormFieldBuilder<Set<T>> builder,
    required ValueMapper<T, String> labelMapper,
    required List<T>? sources,
    ValueMapper<T, V>? valueMapper,
    ValueMapper<T, bool>? enabledMapper,
    ValueMapper<T, bool>? inputEnabledMapper,
    ValueMapper<String, T>? dataMapper,
    int? minPickNumber,
    int? maxPickNumber,
    ValueChanged<Set<T>?>? onChanged,
    InputDecoration? decoration,
    Set<V>? initialValue,
    Set<T>? initialData,
    super.key,
    super.onSaved,
    super.validator,
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    super.required,
    super.label,
    super.labelText,
    super.labelTextAlign,
    super.labelOverflow,
    super.backgroundColor,
    super.direction,
    super.padding,
    super.actionsBuilder,
    super.labelStyle,
    super.starStyle,
    super.horizontalGap,
    super.minLabelWidth,
  })  : assert(inputEnabledMapper == null || dataMapper != null),
        super(
          builder: (field) {
            final InputDecoration defaultDecoration = InputDecoration(
              hintText: TxLocalizations.of(field.context).pickerFormFieldHint,
            );
            final InputDecoration effectiveDecoration =
                TxFormFieldItem.mergeDecoration(
              field.context,
              decoration,
              defaultDecoration,
            );
            return InputDecorator(
              decoration:
                  effectiveDecoration.copyWith(errorText: field.errorText),
              child: builder(field),
            );
          },
          defaultValidator: (context, value) {
            if (value == null) {
              return required == true
                  ? TxLocalizations.of(context).textFormFieldHint
                  : null;
            }
            if (minPickNumber != null && value.length < minPickNumber) {
              return TxLocalizations.of(context)
                  .minimumSelectableQuantityLimitLabel(minPickNumber);
            }
            if (maxPickNumber != null && value.length > maxPickNumber) {
              return TxLocalizations.of(context)
                  .maximumSelectableQuantityLimitLabel(maxPickNumber);
            }
            return null;
          },
          initialValue: initialData ??
              sources?.where((e) {
                final V value = (valueMapper?.call(e) ?? labelMapper(e)) as V;
                return initialValue?.contains(value) == true;
              }).toSet(),
        );
}

@Deprecated('This feature was deprecated after v0.3.0.')
typedef FormFieldDecorationBuilder<T> = InputDecoration Function(
    TxTextFormFieldItemState<T> filed);

/// 文字输入Form组件
@Deprecated('This feature was deprecated after v0.3.0.')
class TxTextFormFieldItem<T> extends TxFormFieldItem<T> {
  @Deprecated('This feature was deprecated after v0.3.0.')
  TxTextFormFieldItem({
    required this.labelMapper,
    Widget? Function(FormFieldState<T> field)? builder,
    FormFieldDecorationBuilder<T>? defaultDecorationBuilder,
    this.dataMapper,
    this.controller,
    super.key,
    super.onSaved,
    super.validator,
    super.initialValue,
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    super.defaultValidator,
    super.required,
    super.bordered,
    super.label,
    super.labelText,
    super.labelTextAlign,
    super.labelOverflow,
    super.backgroundColor,
    super.direction,
    super.padding,
    super.actionsBuilder,
    super.labelStyle,
    super.starStyle,
    super.horizontalGap,
    super.minLabelWidth,
    IconMergeMode? prefixIconMergeMode,
    IconMergeMode? suffixIconMergeMode,
    FocusNode? focusNode,
    InputDecoration? decoration = const InputDecoration(),
    TextInputType? keyboardType,
    TextCapitalization? textCapitalization,
    TextInputAction? textInputAction,
    TextStyle? style,
    StrutStyle? strutStyle,
    TextDirection? textDirection,
    TextAlign? textAlign,
    TextAlignVertical? textAlignVertical,
    bool? autofocus,
    bool? readonly,
    int? maxLines,
    int? minLines,
    int? maxLength,
    ValueChanged<T?>? onChanged,
    GestureTapCallback? onTap,
    ValueChanged<FormFieldState<T>>? onFieldTap,
    VoidCallback? onEditingComplete,
    List<TextInputFormatter>? inputFormatters,
    bool? showCursor,
    String? obscuringCharacter,
    bool? obscureText,
    bool? autocorrect,
    SmartDashesType? smartDashesType,
    SmartQuotesType? smartQuotesType,
    bool? enableSuggestions,
    MaxLengthEnforcement? maxLengthEnforcement,
    bool? expands,
    TapRegionCallback? onTapOutside,
    ValueChanged<String>? onFieldSubmitted,
    double? cursorWidth,
    double? cursorHeight,
    Radius? cursorRadius,
    Color? cursorColor,
    Brightness? keyboardAppearance,
    EdgeInsets? scrollPadding,
    bool? enableInteractiveSelection,
    TextSelectionControls? selectionControls,
    InputCounterWidgetBuilder? buildCounter,
    ScrollPhysics? scrollPhysics,
    Iterable<String>? autofillHints,
    ScrollController? scrollController,
    bool? enableIMEPersonalizedLearning,
    MouseCursor? mouseCursor,
    EditableTextContextMenuBuilder? contextMenuBuilder,
  })  : assert((controller == null && readonly == true) || dataMapper != null),
        super(
          builder: (FormFieldState<T> field) {
            assert(field is TxTextFormFieldItemState<T>);

            final Widget? result = builder?.call(field);
            if (result != null) {
              return result;
            }

            void onChangedHandler(String? value) {
              field.didChange(dataMapper!(value));
              if (onChanged != null) {
                onChanged(dataMapper(value));
              }
            }

            final InputDecoration defaultDecoration;
            if (defaultDecorationBuilder != null) {
              defaultDecoration = defaultDecorationBuilder(
                  field as TxTextFormFieldItemState<T>);
            } else {
              Widget? suffixIcon;
              if (readonly != true && field.value != null) {
                suffixIcon = IconButton(
                  onPressed: () => onChangedHandler(''),
                  icon: const Icon(Icons.cancel, size: 20.0),
                );
              }
              defaultDecoration = InputDecoration(
                suffixIcon: suffixIcon,
                hintText: TxLocalizations.of(field.context).textFormFieldHint,
              );
            }
            final InputDecoration effectiveDecoration =
                TxFormFieldItem.mergeDecoration(
              field.context,
              decoration,
              defaultDecoration,
              prefixIconMergeMode,
              suffixIconMergeMode,
            );
            final TextAlign effectiveTextAlign = textAlign ??
                (direction == Axis.horizontal
                    ? TextAlign.end
                    : TextAlign.start);

            onTap ??= onFieldTap == null ? null : () => onFieldTap(field);

            return TextField(
              restorationId: restorationId,
              controller:
                  (field as TxTextFormFieldItemState<T>)._effectiveController,
              focusNode: focusNode,
              decoration:
                  effectiveDecoration.copyWith(errorText: field.errorText),
              keyboardType: keyboardType,
              textInputAction: textInputAction,
              style: style,
              strutStyle: strutStyle,
              textAlign: effectiveTextAlign,
              textAlignVertical: textAlignVertical,
              textDirection: textDirection,
              textCapitalization: textCapitalization ?? TextCapitalization.none,
              autofocus: autofocus ?? false,
              readOnly: readonly ?? false,
              showCursor: showCursor,
              obscuringCharacter: obscuringCharacter ?? '•',
              obscureText: obscureText ?? false,
              autocorrect: autocorrect ?? true,
              smartDashesType: smartDashesType,
              smartQuotesType: smartQuotesType,
              enableSuggestions: enableSuggestions ?? true,
              maxLengthEnforcement: maxLengthEnforcement,
              maxLines: maxLines ?? (minLines == null ? 1 : null),
              minLines: minLines,
              expands: expands ?? false,
              maxLength: maxLength,
              onChanged: onChangedHandler,
              onTap: onTap,
              onTapOutside: onTapOutside,
              onEditingComplete: onEditingComplete,
              onSubmitted: onFieldSubmitted,
              inputFormatters: inputFormatters,
              enabled: enabled,
              cursorWidth: cursorWidth ?? 2.0,
              cursorHeight: cursorHeight,
              cursorRadius: cursorRadius,
              cursorColor: cursorColor,
              scrollPadding: scrollPadding ?? const EdgeInsets.all(20.0),
              scrollPhysics: scrollPhysics,
              keyboardAppearance: keyboardAppearance,
              enableInteractiveSelection: enableInteractiveSelection ??
                  (obscureText != true || readonly != true),
              selectionControls: selectionControls,
              buildCounter: buildCounter,
              autofillHints: autofillHints,
              scrollController: scrollController,
              enableIMEPersonalizedLearning:
                  enableIMEPersonalizedLearning ?? true,
              mouseCursor: mouseCursor,
              contextMenuBuilder:
                  contextMenuBuilder ?? _defaultContextMenuBuilder,
            );
          },
        );

  final TextEditingController? controller;

  /// 根据数据生成可以展示的文字
  final String Function(T data) labelMapper;

  /// 根据输入的文字生成对应类型的数据
  final ValueMapper<String?, T?>? dataMapper;

  static Widget _defaultContextMenuBuilder(
      BuildContext context, EditableTextState editableTextState) {
    return AdaptiveTextSelectionToolbar.editableText(
      editableTextState: editableTextState,
    );
  }

  @override
  TxTextFormFieldItemState<T> createState() => TxTextFormFieldItemState<T>();
}

@Deprecated('This feature was deprecated after v0.3.0.')
class TxTextFormFieldItemState<T> extends TxFormFieldState<T> {
  RestorableTextEditingController? _controller;

  TextEditingController get _effectiveController =>
      _textFormField.controller ?? _controller!.value;

  TxTextFormFieldItem<T> get _textFormField =>
      super.widget as TxTextFormFieldItem<T>;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(oldBucket, initialRestore);
    if (_controller != null) {
      _registerController();
    }
  }

  void _registerController() {
    assert(_controller != null);
    registerForRestoration(_controller!, 'controller');
  }

  void _createLocalController([TextEditingValue? value]) {
    assert(_controller == null);
    _controller = value == null
        ? RestorableTextEditingController()
        : RestorableTextEditingController.fromValue(value);
    if (!restorePending) {
      _registerController();
    }
  }

  @override
  void initState() {
    super.initState();
    if (_textFormField.controller == null) {
      _createLocalController(widget.initialValue != null
          ? TextEditingValue(
              text: _textFormField.labelMapper(widget.initialValue as T),
            )
          : null);
    } else {
      _textFormField.controller!.addListener(_handleControllerChanged);
    }
  }

  @override
  void didUpdateWidget(TxTextFormFieldItem<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_textFormField.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      _textFormField.controller?.addListener(_handleControllerChanged);

      if (oldWidget.controller != null && _textFormField.controller == null) {
        _createLocalController(oldWidget.controller!.value);
      }

      if (_textFormField.controller != null) {
        setValue(_textFormField.dataMapper!(_textFormField.controller!.text));
        if (oldWidget.controller == null) {
          unregisterFromRestoration(_controller!);
          _controller!.dispose();
          _controller = null;
        }
      }
    } else if (_textFormField.initialValue != _effectiveController.text) {
      _setControllerValue(widget.initialValue);
    }
  }

  void _setControllerValue(T? value) {
    final String text = value == null ? '' : _textFormField.labelMapper(value);
    if (text == _effectiveController.text) {
      return;
    }
    if (value == null) {
      _effectiveController.text = '';
    } else {
      final TextEditingValue editingValue = TextEditingValue(
          text: text, selection: TextSelection.collapsed(offset: text.length));
      _effectiveController.value = editingValue;
    }
  }

  @override
  void dispose() {
    _textFormField.controller?.removeListener(_handleControllerChanged);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChange(T? value) {
    super.didChange(value);

    _setControllerValue(value);
  }

  @override
  void reset() {
    _effectiveController.text = widget.initialValue == null
        ? ''
        : _textFormField.labelMapper(widget.initialValue as T);
    super.reset();
  }

  void _handleControllerChanged() {
    final String text =
        value == null ? '' : _textFormField.labelMapper(value as T);
    if (_effectiveController.text != text) {
      didChange(_textFormField.dataMapper!(_effectiveController.text));
    }
  }
}

/// 单项选择Form组件
@Deprecated('This feature was deprecated after v0.3.0.')
class TxPickerTextFormField<T, V> extends TxTextFormFieldItem<T> {
  @Deprecated('This feature was deprecated after v0.3.0.')
  TxPickerTextFormField({
    required super.labelMapper,
    required PickerFuture<T> onPickTap,
    ValueMapper<T, V>? valueMapper,
    super.dataMapper,
    super.initialValue,
    bool? inputEnabled,
    super.key,
    super.onSaved,
    super.validator,
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    super.required,
    super.label,
    super.labelText,
    super.labelTextAlign,
    super.labelOverflow,
    super.backgroundColor,
    super.direction,
    super.padding,
    super.actionsBuilder,
    super.labelStyle,
    super.starStyle,
    super.horizontalGap,
    super.minLabelWidth,
    super.controller,
    super.prefixIconMergeMode,
    super.suffixIconMergeMode,
    super.focusNode,
    super.decoration,
    super.keyboardType,
    super.textCapitalization,
    super.textInputAction,
    super.style,
    super.strutStyle,
    super.textDirection,
    super.textAlign,
    super.bordered,
    super.textAlignVertical,
    super.autofocus,
    bool? readonly,
    super.maxLines,
    super.minLines,
    super.maxLength,
    super.onChanged,
    super.onEditingComplete,
    super.inputFormatters,
    super.showCursor,
    super.obscuringCharacter,
    super.obscureText,
    super.autocorrect,
    super.smartDashesType,
    super.smartQuotesType,
    super.enableSuggestions,
    super.maxLengthEnforcement,
    super.expands,
    super.onTapOutside,
    super.onFieldSubmitted,
    super.cursorWidth,
    super.cursorHeight,
    super.cursorRadius,
    super.cursorColor,
    super.keyboardAppearance,
    super.scrollPadding,
    super.enableInteractiveSelection,
    super.selectionControls,
    super.buildCounter,
    super.scrollPhysics,
    super.autofillHints,
    super.scrollController,
    super.enableIMEPersonalizedLearning,
    super.mouseCursor,
    super.contextMenuBuilder,
    super.onTap,
  })  : assert(inputEnabled != true || dataMapper != null),
        super(
          readonly: inputEnabled != true,
          onFieldTap: readonly == true
              ? null
              : (field) async {
                  final FocusScopeNode currentFocus =
                      FocusScope.of(field.context);
                  if (!currentFocus.hasPrimaryFocus &&
                      currentFocus.focusedChild != null) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  }
                  final T? res = await onPickTap(field.context, field.value);
                  if (res == null || res == field.value) {
                    return;
                  }
                  field.didChange(res);
                  if (onChanged != null) {
                    onChanged(res);
                  }
                },
          defaultDecorationBuilder: (field) {
            void onChangedHandler(T? value) {
              field.didChange(value);
              if (onChanged != null) {
                onChanged(value);
              }
            }

            Widget suffixIcon = const Icon(Icons.keyboard_arrow_right);
            if (readonly != true && field.value != null) {
              suffixIcon = Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => onChangedHandler(null),
                    icon: const Icon(Icons.cancel, size: 20.0),
                  ),
                  suffixIcon
                ],
              );
            }

            return InputDecoration(
              suffixIcon: suffixIcon,
              hintText: TxLocalizations.of(field.context).pickerFormFieldHint,
            );
          },
          defaultValidator: required == true
              ? (context, value) => value == null
                  ? TxLocalizations.of(context).pickerFormFieldHint
                  : null
              : null,
        );
}

@Deprecated('This feature was deprecated after v0.3.0.')
enum IconMergeMode {
  replace,
  appendEnd,
  appendStart,
}

@Deprecated('This feature was deprecated after v0.3.0.')
extension InputDecorationExtension on InputDecoration {
  InputDecoration merge(
    InputDecoration? other, {
    IconMergeMode? prefixMergeMode,
    IconMergeMode? suffixMergeMode,
  }) {
    if (other == null) {
      return this;
    }
    final Widget? effectiveSuffixIcon = _mergeIcon(
      suffixIcon,
      other.suffixIcon,
      suffixMergeMode,
    );
    final Widget? effectivePrefixIcon = _mergeIcon(
      prefixIcon,
      other.prefixIcon,
      prefixMergeMode,
    );
    return copyWith(
      icon: other.icon,
      iconColor: other.iconColor,
      label: other.label,
      labelText: other.labelText,
      labelStyle: other.labelStyle,
      floatingLabelStyle: other.floatingLabelStyle,
      helperText: other.helperText,
      helperStyle: other.helperStyle,
      helperMaxLines: other.helperMaxLines,
      hintText: other.hintText,
      hintStyle: other.hintStyle,
      hintTextDirection: other.hintTextDirection,
      hintMaxLines: other.hintMaxLines,
      errorText: other.errorText,
      errorStyle: other.errorStyle,
      errorMaxLines: other.errorMaxLines,
      floatingLabelBehavior: other.floatingLabelBehavior,
      floatingLabelAlignment: other.floatingLabelAlignment,
      isCollapsed: other.isCollapsed,
      isDense: other.isDense,
      contentPadding: other.contentPadding,
      prefixIcon: effectivePrefixIcon,
      prefix: other.prefix,
      prefixText: other.prefixText,
      prefixIconConstraints:
          other.prefixIconConstraints ?? const BoxConstraints(),
      prefixStyle: other.prefixStyle,
      prefixIconColor: other.prefixIconColor,
      suffixIcon: effectiveSuffixIcon,
      suffix: other.suffix,
      suffixText: other.suffixText,
      suffixStyle: other.suffixStyle,
      suffixIconColor: other.suffixIconColor,
      suffixIconConstraints:
          other.suffixIconConstraints ?? const BoxConstraints(),
      counter: other.counter,
      counterText: other.counterText,
      counterStyle: other.counterStyle,
      filled: other.filled,
      fillColor: other.fillColor,
      focusColor: other.focusColor,
      hoverColor: other.hoverColor,
      errorBorder: other.errorBorder,
      focusedBorder: other.focusedBorder,
      focusedErrorBorder: other.focusedErrorBorder,
      disabledBorder: other.disabledBorder,
      enabledBorder: other.enabledBorder,
      border: other.border,
      enabled: other.enabled,
      semanticCounterText: other.semanticCounterText,
      alignLabelWithHint: other.alignLabelWithHint,
      constraints: other.constraints,
    );
  }

  Widget? _mergeIcon(Widget? icon, Widget? otherIcon, IconMergeMode? mode) {
    if (mode == IconMergeMode.replace || icon == null) {
      return otherIcon;
    }
    if (otherIcon != null) {
      final List<Widget> children = mode == IconMergeMode.appendEnd
          ? [icon, otherIcon]
          : [otherIcon, icon];

      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: children,
      );
    }
    return icon;
  }
}
