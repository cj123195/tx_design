import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../extensions/iterable_extension.dart';
import '../localizations.dart';
import '../utils/basic_types.dart';
import 'form_item_container.dart';
import 'form_item_theme.dart';

typedef TxFormFieldBuilder<T> = Widget Function(TxFormFieldState<T> field);

// @Deprecated('This feature was deprecated after v0.3.0.')
// class TxFormField<T> extends FormField<T> {
//   @Deprecated('This feature was deprecated after v0.3.0.')
//   const TxFormField({
//     required super.builder,
//     super.key,
//     super.onSaved,
//     super.validator,
//     super.initialValue,
//     bool? enabled,
//     super.autovalidateMode,
//     super.restorationId,
//     this.defaultValidator,
//   }) : super(enabled: enabled ?? true);
//
//   final String? Function(BuildContext context, T? value)? defaultValidator;
//
//   @override
//   TxFormFieldState<T> createState() => TxFormFieldState<T>();
// }

// @Deprecated('This feature was deprecated after v0.3.0.')
// class TxFormFieldState<T> extends FormFieldState<T> {
//   @override
//   TxFormField<T> get widget => super.widget as TxFormField<T>;
//
//   final RestorableStringN _defaultErrorText = RestorableStringN(null);
//
//   @override
//   String? get errorText => _defaultErrorText.value ?? super.errorText;
//
//   @override
//   bool get hasError => _defaultErrorText.value != null || super.hasError;
//
//   @override
//   void initState() {
//     if (widget.initialValue != null) {
//       setValue(widget.initialValue);
//     }
//     super.initState();
//   }
//
//   @override
//   bool validate() {
//     _validate();
//     return super.validate();
//   }
//
//   void _validate() {
//     if (widget.defaultValidator != null) {
//       _defaultErrorText.value = widget.defaultValidator!(context, value);
//     }
//   }
//
//   @override
//   void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
//     registerForRestoration(_defaultErrorText, 'default_error_text');
//     super.restoreState(oldBucket, initialRestore);
//   }
//
//   @override
//   void didUpdateWidget(covariant TxFormField<T> oldWidget) {
//     if (widget.initialValue != value) {
//       setValue(widget.initialValue);
//     }
//     super.didUpdateWidget(oldWidget);
//   }
// }
class TxFormField<T> extends FormField<T> {
  TxFormField({
    required TxFormFieldBuilder<T> builder,
    super.key,
    super.onSaved,
    super.validator,
    super.initialValue,
    bool? enabled,
    super.autovalidateMode,
    super.restorationId,
    this.decoration,
    this.onChanged,
    bool? required,
    @Deprecated('This feature was deprecated after v0.3.0.')
    this.defaultValidator,
  }) : super(
          enabled: enabled ?? decoration?.enabled ?? true,
          builder: (field) => builder(field as TxFormFieldState<T>),
        );

  /// 值变更回调
  final ValueChanged<T?>? onChanged;

  /// 要在文本字段周围显示的装饰。
  ///
  /// 默认情况下，在文本字段下绘制一条水平线，但可以配置为显示图标、标签、提示文本和错误文本。
  ///
  /// 指定 null 可完全删除修饰（包括修饰引入的额外填充，以节省标签空间）。
  final InputDecoration? decoration;

  @Deprecated('This feature was deprecated after v0.3.0.')
  final String? Function(BuildContext context, T? value)? defaultValidator;

  @override
  TxFormFieldState<T> createState() => TxFormFieldState<T>();
}

class TxFormFieldState<T> extends FormFieldState<T> {
  @override
  TxFormField<T> get widget => super.widget as TxFormField<T>;

  /// 最终生效的装饰器
  InputDecoration get effectiveDecoration {
    return (widget.decoration ?? const InputDecoration())
        .copyWith(errorText: errorText);
  }

  /// 选择项变更回调
  @override
  @mustCallSuper
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
    bool? required,
    Widget? label,
    String? labelText,
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
    super.label,
    super.labelText,
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
