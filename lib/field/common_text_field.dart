import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/basic_types.dart';
import 'field.dart';

typedef InputValueChanged<T> = void Function(
  TxFieldState<T> field,
  String value,
);

typedef ContextValueMapper<T, V> = V Function(BuildContext context, T value);

/// 通用输入框
///
/// 统一封装提供给所有需要输入框样式的 field 组件使用，如 textField, pickerField等
class TxCommonTextField<T> extends TxField<T> {
  /// 创建一个普通的文本框
  TxCommonTextField({
    required this.displayTextMapper,
    this.isEmpty,
    this.clearable,
    this.controller,
    super.key,
    super.initialValue,
    super.decoration,
    super.onChanged,
    super.enabled,
    super.hintText,
    super.textAlign,
    super.bordered,
    TextInputType? keyboardType,
    TextCapitalization? textCapitalization,
    TextInputAction? textInputAction,
    TextStyle? style,
    StrutStyle? strutStyle,
    TextDirection? textDirection,
    TextAlignVertical? textAlignVertical,
    this.focusNode,
    bool? autofocus,
    bool? readOnly,
    bool? showCursor,
    String? obscuringCharacter,
    this.obscureText,
    bool? autocorrect,
    SmartDashesType? smartDashesType,
    SmartQuotesType? smartQuotesType,
    bool? enableSuggestions,
    MaxLengthEnforcement? maxLengthEnforcement,
    int? maxLines,
    int? minLines,
    bool? expands,
    int? maxLength,
    bool? onTapAlwaysCalled,
    TapRegionCallback? onTapOutside,
    VoidCallback? onEditingComplete,
    ValueChanged<String>? onSubmitted,
    List<TextInputFormatter>? inputFormatters,
    double? cursorWidth,
    double? cursorHeight,
    Radius? cursorRadius,
    Color? cursorColor,
    Color? cursorErrorColor,
    Brightness? keyboardAppearance,
    EdgeInsets? scrollPadding,
    bool? enableInteractiveSelection,
    TextSelectionControls? selectionControls,
    ValueChanged<TxFieldState<T>>? onTap,
    InputCounterWidgetBuilder? buildCounter,
    ScrollPhysics? scrollPhysics,
    Iterable<String>? autofillHints,
    ScrollController? scrollController,
    bool? enableIMEPersonalizedLearning,
    MouseCursor? mouseCursor,
    EditableTextContextMenuBuilder? contextMenuBuilder,
    SpellCheckConfiguration? spellCheckConfiguration,
    TextMagnifierConfiguration? magnifierConfiguration,
    UndoHistoryController? undoController,
    AppPrivateCommandCallback? onAppPrivateCommand,
    bool? cursorOpacityAnimates,
    ui.BoxHeightStyle? selectionHeightStyle,
    ui.BoxWidthStyle? selectionWidthStyle,
    DragStartBehavior? dragStartBehavior,
    ContentInsertionConfiguration? contentInsertionConfiguration,
    MaterialStatesController? statesController,
    Clip? clipBehavior,
    String? restorationId,
    bool? scribbleEnabled,
    bool? canRequestFocus,
    InputValueChanged<T>? onInputChanged,
    super.label,
    super.labelText,
    super.labelTextAlign,
    super.labelOverflow,
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
    super.minLeadingWidth,
    super.minLabelWidth,
    super.minVerticalPadding,
    super.dense,
    super.colon,
    super.focusColor,
  })  : assert(controller == null || initialValue == null),
        assert(T == String || readOnly == true || onInputChanged != null),
        super(builder: (field) {
          final state = field as TxCommonTextFieldState<T>;

          void onTapOutsideHandler(PointerDownEvent event) {
            if (onTapOutside != null) {
              onTapOutside(event);
            }
            FocusScope.of(state.context).unfocus();
          }

          return TextField(
            controller: controller ?? state.controller,
            focusNode: field.focusNode,
            undoController: undoController,
            decoration: field.effectiveDecoration,
            keyboardType: keyboardType ??
                (maxLines == 1 ? TextInputType.text : TextInputType.multiline),
            textInputAction: textInputAction,
            textCapitalization: textCapitalization ?? TextCapitalization.none,
            style: style,
            strutStyle: strutStyle,
            textAlign: textAlign ?? TextAlign.start,
            textAlignVertical: textAlignVertical,
            textDirection: textDirection,
            readOnly: readOnly ?? false,
            showCursor: showCursor,
            autofocus: autofocus ?? false,
            statesController: statesController,
            obscuringCharacter: obscuringCharacter ?? '•',
            obscureText: field.obscureText ?? false,
            autocorrect: autocorrect ?? true,
            smartDashesType: smartDashesType,
            smartQuotesType: smartQuotesType,
            enableSuggestions: enableSuggestions ?? true,
            maxLines: maxLines ?? (minLines != null ? null : 1),
            minLines: minLines,
            expands: expands ?? false,
            maxLength: maxLength,
            maxLengthEnforcement: maxLengthEnforcement,
            onChanged: onInputChanged == null
                ? (value) => field.didChange(value as T)
                : (value) => onInputChanged(state, value),
            onEditingComplete: onEditingComplete,
            onSubmitted: onSubmitted,
            onAppPrivateCommand: onAppPrivateCommand,
            inputFormatters: inputFormatters,
            enabled: enabled,
            cursorWidth: cursorWidth ?? 2.0,
            cursorHeight: cursorHeight,
            cursorRadius: cursorRadius,
            cursorOpacityAnimates: cursorOpacityAnimates,
            cursorColor: cursorColor,
            cursorErrorColor: cursorErrorColor,
            selectionHeightStyle:
                selectionHeightStyle ?? ui.BoxHeightStyle.tight,
            selectionWidthStyle: selectionWidthStyle ?? ui.BoxWidthStyle.tight,
            keyboardAppearance: keyboardAppearance,
            scrollPadding: scrollPadding ?? const EdgeInsets.all(20.0),
            dragStartBehavior: dragStartBehavior ?? DragStartBehavior.start,
            enableInteractiveSelection: enableInteractiveSelection,
            selectionControls: selectionControls,
            onTap: onTap == null ? null : () => onTap(field),
            onTapAlwaysCalled: onTapAlwaysCalled ?? false,
            onTapOutside: onTapOutsideHandler,
            mouseCursor: mouseCursor,
            buildCounter: buildCounter,
            scrollController: scrollController,
            scrollPhysics: scrollPhysics,
            autofillHints: autofillHints,
            contentInsertionConfiguration: contentInsertionConfiguration,
            clipBehavior: clipBehavior ?? Clip.hardEdge,
            restorationId: restorationId,
            scribbleEnabled: scribbleEnabled ?? true,
            enableIMEPersonalizedLearning:
                enableIMEPersonalizedLearning ?? true,
            contextMenuBuilder: contextMenuBuilder ??
                TxCommonTextField._defaultContextMenuBuilder,
            canRequestFocus: canRequestFocus ?? true,
            spellCheckConfiguration: spellCheckConfiguration,
            magnifierConfiguration: magnifierConfiguration,
          );
        });

  /// 参考 [TextField.controller]
  final TextEditingController? controller;

  /// 输入框显示的文字生成器
  final ContextValueMapper<T, String> displayTextMapper;

  /// 输入内容是否可清除
  final bool? clearable;

  /// 输入内容是否可清除
  final bool? obscureText;

  /// 判断是否为 null 或者空
  final ValueMapper<T, bool>? isEmpty;

  /// 焦点
  final FocusNode? focusNode;

  static Widget _defaultContextMenuBuilder(
    BuildContext context,
    EditableTextState editableTextState,
  ) {
    return AdaptiveTextSelectionToolbar.editableText(
      editableTextState: editableTextState,
    );
  }

  @override
  TxCommonTextFieldState<T> createState() => TxCommonTextFieldState<T>();
}

class TxCommonTextFieldState<T> extends TxFieldState<T> {
  FocusNode? get focusNode => widget.focusNode;

  TextEditingController? _controller;

  TextEditingController? get controller => widget.controller ?? _controller;

  bool? get obscureText => widget.obscureText;

  @override
  TxCommonTextField<T> get widget => super.widget as TxCommonTextField<T>;

  String get _displayText =>
      value == null ? '' : widget.displayTextMapper(context, value as T);

  @override
  bool get isEmpty =>
      value == null ||
      (widget.isEmpty == null ? false : widget.isEmpty!(value as T));

  /// 只修改值，不修改输入框文字
  void setValue(T? value) {
    super.didChange(value);
  }

  @override
  void didChange(T? value) {
    super.didChange(value);

    final String text = _displayText;
    if (text != controller?.text) {
      controller?.text = text;
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = TextEditingController(text: _displayText);
    }
  }

  @override
  void didUpdateWidget(covariant TxCommonTextField<T> oldWidget) {
    if (widget.controller == null) {
      if (oldWidget.controller != null) {
        _controller =
            TextEditingController.fromValue(oldWidget.controller!.value);
      } else {
        if (widget.initialValue == null && _controller!.text.isNotEmpty) {
          _controller!.clear();
        } else {
          if (value != widget.initialValue) {
            _controller!.text =
                widget.displayTextMapper(context, widget.initialValue as T);
          }
        }
      }
    } else if (oldWidget.controller == null) {
      _controller!.dispose();
      _controller = null;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(this);
  }

  @override
  List<Widget>? get suffixIcons {
    return [
      ...?super.suffixIcons,
      if (widget.clearable != false && !isEmpty)
        IconButton(
          onPressed: () => didChange(null),
          icon: const Icon(Icons.clear, size: 16.0),
          style: IconButton.styleFrom(
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
          ),
        ),
    ];
  }
}
