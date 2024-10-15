import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'field.dart';
import 'field_tile.dart';

typedef InputValueChanged<T> = void Function(
  TxFieldState<T> field,
  String value,
);

typedef ContextValueMapper<T, V> = V Function(BuildContext context, T value);

/// 通用输入框
///
/// 统一封装提供给所有需要输入框样式的 field 组件使用，如 textField, pickerField等
class TxCommonTextField<T> extends TxField<T> {
  TxCommonTextField({
    required this.displayTextMapper,
    this.controller,
    super.key,
    super.initialValue,
    super.focusNode,
    super.decoration,
    super.onChanged,
    super.enabled,
    super.hintText,
    super.textAlign,
    TextInputType? keyboardType,
    TextCapitalization? textCapitalization,
    TextInputAction? textInputAction,
    TextStyle? style,
    StrutStyle? strutStyle,
    TextDirection? textDirection,
    TextAlignVertical? textAlignVertical,
    bool? autofocus,
    bool? readOnly,
    bool? showCursor,
    String? obscuringCharacter,
    bool? obscureText,
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
  })  : assert(controller == null || initialValue == null),
        super(builder: (field) {
          final state = field as TxCommonTextFieldState<T>;

          void onChangedHandler(String value) {
            field.didChange(value as T);
            if (onChanged != null) {
              onChanged(value as T);
            }
          }

          void onTapOutsideHandler(PointerDownEvent event) {
            if (onTapOutside != null) {
              onTapOutside(event);
            }
            FocusScope.of(state.context).unfocus();
          }

          return TextField(
            controller: controller ?? state.controller,
            focusNode: focusNode,
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
            obscureText: obscureText ?? false,
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
                ? onChangedHandler
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
  TextEditingController? _controller;

  TextEditingController? get controller => widget.controller ?? _controller;

  String get displayText {
    if (value == null) {
      return '';
    }
    return widget.displayTextMapper(context, value as T);
  }

  @override
  TxCommonTextField<T> get widget => super.widget as TxCommonTextField<T>;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = TextEditingController(text: displayText);
    }
  }

  @override
  void didUpdateWidget(covariant TxCommonTextField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller == null) {
      if (oldWidget.controller != null) {
        _controller =
            TextEditingController.fromValue(oldWidget.controller!.value);
      } else {
        if (widget.initialValue == null && _controller!.text.isNotEmpty) {
          _controller!.clear();
        } else {
          final String text = displayText;
          if (text != _controller!.text) {
            _controller!.text = text;
          }
        }
      }
    } else if (oldWidget.controller == null) {
      _controller!.dispose();
      _controller = null;
    }
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
}

/// 输入框样式的 [TxFieldTile]
class TxCommonTextFieldTile<T> extends TxFieldTile<T> {
  TxCommonTextFieldTile({
    required this.displayTextMapper,
    super.key,
    super.initialValue,
    super.focusNode,
    super.decoration,
    super.onChanged,
    super.hintText,
    super.textAlign,
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
    super.enabled,
    super.minLeadingWidth,
    super.minLabelWidth,
    super.minVerticalPadding,
    super.dense,
    this.controller,
    TextInputType? keyboardType,
    TextCapitalization? textCapitalization,
    TextInputAction? textInputAction,
    TextStyle? style,
    StrutStyle? strutStyle,
    TextDirection? textDirection,
    TextAlignVertical? textAlignVertical,
    bool? autofocus,
    bool? readOnly,
    bool? showCursor,
    String? obscuringCharacter,
    bool? obscureText,
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
    ValueChanged<TxFieldState<T>>? onTap,
  })  : assert(controller == null || initialValue == null),
        super(fieldBuilder: (field) {
          final state = field as TxCommonTextFieldTileState<T>;

          void onChangedHandler(String value) {
            field.didChange(value as T);
            if (onChanged != null) {
              onChanged(value as T);
            }
          }

          void onTapOutsideHandler(PointerDownEvent event) {
            if (onTapOutside != null) {
              onTapOutside(event);
            }
            FocusScope.of(state.context).unfocus();
          }

          return TextField(
            controller: controller ?? state.controller,
            focusNode: focusNode,
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
            obscureText: obscureText ?? false,
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
                ? onChangedHandler
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

  @override
  TxCommonTextFieldTileState<T> createState() =>
      TxCommonTextFieldTileState<T>();
}

class TxCommonTextFieldTileState<T> extends TxFieldState<T> {
  TextEditingController? _controller;

  TextEditingController? get controller => widget.controller ?? _controller;

  String get displayText {
    if (value == null) {
      return '';
    }
    return widget.displayTextMapper(context, value as T);
  }

  @override
  void didChange(T? value) {
    super.didChange(value);
    if (displayText != controller?.text) {
      controller?.text = displayText;
    }
  }

  @override
  TxCommonTextFieldTile<T> get widget =>
      super.widget as TxCommonTextFieldTile<T>;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = TextEditingController(text: displayText);
    }
  }

  @override
  void didUpdateWidget(covariant TxCommonTextField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller == null) {
      if (oldWidget.controller != null) {
        _controller =
            TextEditingController.fromValue(oldWidget.controller!.value);
      } else {
        if (widget.initialValue == null && _controller!.text.isNotEmpty) {
          _controller!.clear();
        } else {
          final String text = displayText;
          if (text != _controller!.text) {
            _controller!.text = text;
          }
        }
      }
    } else if (oldWidget.controller == null) {
      _controller!.dispose();
      _controller = null;
    }
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
}
