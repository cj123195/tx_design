import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/basic_types.dart';
import 'form_field.dart';

typedef InputValueChanged<T> = void Function(
  TxCommonTextFormFieldState<T> field,
  String value,
);

typedef ContextValueMapper<T, V> = V Function(BuildContext context, T value);

/// 输入框配置
class EditConfig {
  const EditConfig({
    this.keyboardType,
    this.textCapitalization,
    this.textInputAction,
    this.style,
    this.strutStyle,
    this.textDirection,
    this.textAlign,
    this.textAlignVertical,
    this.autofocus,
    this.showCursor,
    this.obscureText,
    this.obscuringCharacter,
    this.autocorrect,
    this.smartDashesType,
    this.smartQuotesType,
    this.enableSuggestions,
    this.maxLengthEnforcement,
    this.expands,
    this.maxLength,
    this.onTapAlwaysCalled,
    this.onTapOutside,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.inputFormatters,
    this.cursorWidth,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorColor,
    this.cursorErrorColor,
    this.keyboardAppearance,
    this.scrollPadding,
    this.enableInteractiveSelection,
    this.selectionControls,
    this.buildCounter,
    this.scrollPhysics,
    this.autofillHints,
    this.scrollController,
    this.enableIMEPersonalizedLearning,
    this.mouseCursor,
    this.contextMenuBuilder,
    this.spellCheckConfiguration,
    this.magnifierConfiguration,
    this.undoController,
    this.onAppPrivateCommand,
    this.cursorOpacityAnimates,
    this.selectionHeightStyle,
    this.selectionWidthStyle,
    this.dragStartBehavior,
    this.contentInsertionConfiguration,
    this.statesController,
    this.clipBehavior,
    this.scribbleEnabled,
    this.canRequestFocus,
  });

  final TextInputType? keyboardType;
  final TextCapitalization? textCapitalization;
  final TextInputAction? textInputAction;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextDirection? textDirection;
  final TextAlign? textAlign;
  final TextAlignVertical? textAlignVertical;
  final bool? autofocus;
  final bool? showCursor;
  final bool? obscureText;
  final String? obscuringCharacter;
  final bool? autocorrect;
  final SmartDashesType? smartDashesType;
  final SmartQuotesType? smartQuotesType;
  final bool? enableSuggestions;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final bool? expands;
  final int? maxLength;
  final bool? onTapAlwaysCalled;
  final TapRegionCallback? onTapOutside;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onFieldSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final double? cursorWidth;
  final double? cursorHeight;
  final Radius? cursorRadius;
  final Color? cursorColor;
  final Color? cursorErrorColor;
  final Brightness? keyboardAppearance;
  final EdgeInsets? scrollPadding;
  final bool? enableInteractiveSelection;
  final TextSelectionControls? selectionControls;
  final InputCounterWidgetBuilder? buildCounter;
  final ScrollPhysics? scrollPhysics;
  final Iterable<String>? autofillHints;
  final ScrollController? scrollController;
  final bool? enableIMEPersonalizedLearning;
  final MouseCursor? mouseCursor;
  final EditableTextContextMenuBuilder? contextMenuBuilder;
  final SpellCheckConfiguration? spellCheckConfiguration;
  final TextMagnifierConfiguration? magnifierConfiguration;
  final UndoHistoryController? undoController;
  final AppPrivateCommandCallback? onAppPrivateCommand;
  final bool? cursorOpacityAnimates;
  final ui.BoxHeightStyle? selectionHeightStyle;
  final ui.BoxWidthStyle? selectionWidthStyle;
  final DragStartBehavior? dragStartBehavior;
  final ContentInsertionConfiguration? contentInsertionConfiguration;
  final WidgetStatesController? statesController;
  final Clip? clipBehavior;
  final bool? scribbleEnabled;
  final bool? canRequestFocus;

  EditConfig copyWith({
    TextInputType? keyboardType,
    TextCapitalization? textCapitalization,
    TextInputAction? textInputAction,
    TextStyle? style,
    StrutStyle? strutStyle,
    TextDirection? textDirection,
    TextAlign? textAlign,
    TextAlignVertical? textAlignVertical,
    bool? autofocus,
    bool? showCursor,
    bool? obscureText,
    String? obscuringCharacter,
    bool? autocorrect,
    SmartDashesType? smartDashesType,
    SmartQuotesType? smartQuotesType,
    bool? enableSuggestions,
    MaxLengthEnforcement? maxLengthEnforcement,
    bool? expands,
    int? maxLength,
    bool? onTapAlwaysCalled,
    TapRegionCallback? onTapOutside,
    VoidCallback? onEditingComplete,
    ValueChanged<String>? onFieldSubmitted,
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
    WidgetStatesController? statesController,
    Clip? clipBehavior,
    bool? scribbleEnabled,
    bool? canRequestFocus,
  }) {
    return EditConfig(
      keyboardType: keyboardType ?? this.keyboardType,
      textCapitalization: textCapitalization ?? this.textCapitalization,
      textInputAction: textInputAction ?? this.textInputAction,
      style: style ?? this.style,
      strutStyle: strutStyle ?? this.strutStyle,
      textDirection: textDirection ?? this.textDirection,
      textAlign: textAlign ?? this.textAlign,
      textAlignVertical: textAlignVertical ?? this.textAlignVertical,
      autofocus: autofocus ?? this.autofocus,
      showCursor: showCursor ?? this.showCursor,
      obscureText: obscureText ?? this.obscureText,
      obscuringCharacter: obscuringCharacter ?? this.obscuringCharacter,
      autocorrect: autocorrect ?? this.autocorrect,
      smartDashesType: smartDashesType ?? this.smartDashesType,
      smartQuotesType: smartQuotesType ?? this.smartQuotesType,
      enableSuggestions: enableSuggestions ?? this.enableSuggestions,
      maxLengthEnforcement: maxLengthEnforcement ?? this.maxLengthEnforcement,
      expands: expands ?? this.expands,
      maxLength: maxLength ?? this.maxLength,
      onTapAlwaysCalled: onTapAlwaysCalled ?? this.onTapAlwaysCalled,
      onTapOutside: onTapOutside ?? this.onTapOutside,
      onEditingComplete: onEditingComplete ?? this.onEditingComplete,
      onFieldSubmitted: onFieldSubmitted ?? this.onFieldSubmitted,
      inputFormatters: inputFormatters ?? this.inputFormatters,
      cursorWidth: cursorWidth ?? this.cursorWidth,
      cursorHeight: cursorHeight ?? this.cursorHeight,
      cursorRadius: cursorRadius ?? this.cursorRadius,
      cursorColor: cursorColor ?? this.cursorColor,
      cursorErrorColor: cursorErrorColor ?? this.cursorErrorColor,
      keyboardAppearance: keyboardAppearance ?? this.keyboardAppearance,
      scrollPadding: scrollPadding ?? this.scrollPadding,
      enableInteractiveSelection:
          enableInteractiveSelection ?? this.enableInteractiveSelection,
      selectionControls: selectionControls ?? this.selectionControls,
      buildCounter: buildCounter ?? this.buildCounter,
      scrollPhysics: scrollPhysics ?? this.scrollPhysics,
      autofillHints: autofillHints ?? this.autofillHints,
      scrollController: scrollController ?? this.scrollController,
      enableIMEPersonalizedLearning:
          enableIMEPersonalizedLearning ?? this.enableIMEPersonalizedLearning,
      mouseCursor: mouseCursor ?? this.mouseCursor,
      contextMenuBuilder: contextMenuBuilder ?? this.contextMenuBuilder,
      spellCheckConfiguration:
          spellCheckConfiguration ?? this.spellCheckConfiguration,
      magnifierConfiguration:
          magnifierConfiguration ?? this.magnifierConfiguration,
      undoController: undoController ?? this.undoController,
      onAppPrivateCommand: onAppPrivateCommand ?? this.onAppPrivateCommand,
      cursorOpacityAnimates:
          cursorOpacityAnimates ?? this.cursorOpacityAnimates,
      selectionHeightStyle: selectionHeightStyle ?? this.selectionHeightStyle,
      selectionWidthStyle: selectionWidthStyle ?? this.selectionWidthStyle,
      dragStartBehavior: dragStartBehavior ?? this.dragStartBehavior,
      contentInsertionConfiguration:
          contentInsertionConfiguration ?? this.contentInsertionConfiguration,
      statesController: statesController ?? this.statesController,
      clipBehavior: clipBehavior ?? this.clipBehavior,
      scribbleEnabled: scribbleEnabled ?? this.scribbleEnabled,
      canRequestFocus: canRequestFocus ?? this.canRequestFocus,
    );
  }

  EditConfig merge(EditConfig other) {
    return EditConfig(
      keyboardType: other.keyboardType ?? keyboardType,
      textCapitalization: other.textCapitalization ?? textCapitalization,
      textInputAction: other.textInputAction ?? textInputAction,
      style: other.style ?? style,
      strutStyle: other.strutStyle ?? strutStyle,
      textDirection: other.textDirection ?? textDirection,
      textAlign: other.textAlign ?? textAlign,
      textAlignVertical: other.textAlignVertical ?? textAlignVertical,
      autofocus: other.autofocus ?? autofocus,
      showCursor: other.showCursor ?? showCursor,
      obscureText: other.obscureText ?? obscureText,
      obscuringCharacter: other.obscuringCharacter ?? obscuringCharacter,
      autocorrect: other.autocorrect ?? autocorrect,
      smartDashesType: other.smartDashesType ?? smartDashesType,
      smartQuotesType: other.smartQuotesType ?? smartQuotesType,
      enableSuggestions: other.enableSuggestions ?? enableSuggestions,
      maxLengthEnforcement: other.maxLengthEnforcement ?? maxLengthEnforcement,
      expands: other.expands ?? expands,
      maxLength: other.maxLength ?? maxLength,
      onTapAlwaysCalled: other.onTapAlwaysCalled ?? onTapAlwaysCalled,
      onTapOutside: other.onTapOutside ?? onTapOutside,
      onEditingComplete: other.onEditingComplete ?? onEditingComplete,
      onFieldSubmitted: other.onFieldSubmitted ?? onFieldSubmitted,
      inputFormatters: other.inputFormatters ?? inputFormatters,
      cursorWidth: other.cursorWidth ?? cursorWidth,
      cursorHeight: other.cursorHeight ?? cursorHeight,
      cursorRadius: other.cursorRadius ?? cursorRadius,
      cursorColor: other.cursorColor ?? cursorColor,
      cursorErrorColor: other.cursorErrorColor ?? cursorErrorColor,
      keyboardAppearance: other.keyboardAppearance ?? keyboardAppearance,
      scrollPadding: other.scrollPadding ?? scrollPadding,
      enableInteractiveSelection:
          other.enableInteractiveSelection ?? enableInteractiveSelection,
      selectionControls: other.selectionControls ?? selectionControls,
      buildCounter: other.buildCounter ?? buildCounter,
      scrollPhysics: other.scrollPhysics ?? scrollPhysics,
      autofillHints: other.autofillHints ?? autofillHints,
      scrollController: other.scrollController ?? scrollController,
      enableIMEPersonalizedLearning:
          other.enableIMEPersonalizedLearning ?? enableIMEPersonalizedLearning,
      mouseCursor: other.mouseCursor ?? mouseCursor,
      contextMenuBuilder: other.contextMenuBuilder ?? contextMenuBuilder,
      spellCheckConfiguration:
          other.spellCheckConfiguration ?? spellCheckConfiguration,
      magnifierConfiguration:
          other.magnifierConfiguration ?? magnifierConfiguration,
      undoController: other.undoController ?? undoController,
      onAppPrivateCommand: other.onAppPrivateCommand ?? onAppPrivateCommand,
      cursorOpacityAnimates:
          other.cursorOpacityAnimates ?? cursorOpacityAnimates,
      selectionHeightStyle: other.selectionHeightStyle ?? selectionHeightStyle,
      selectionWidthStyle: other.selectionWidthStyle ?? selectionWidthStyle,
      dragStartBehavior: other.dragStartBehavior ?? dragStartBehavior,
      contentInsertionConfiguration:
          other.contentInsertionConfiguration ?? contentInsertionConfiguration,
      statesController: other.statesController ?? statesController,
      clipBehavior: other.clipBehavior ?? clipBehavior,
      scribbleEnabled: other.scribbleEnabled ?? scribbleEnabled,
      canRequestFocus: other.canRequestFocus ?? canRequestFocus,
    );
  }
}

// 文本显示配置
class TextFieldDisplayConfig {
  const TextFieldDisplayConfig({
    this.style,
    this.textAlign = TextAlign.left,
    this.maxLines = 1,
    this.minLines,
  });

  final TextStyle? style;
  final TextAlign textAlign;
  final int maxLines;
  final int? minLines;
}

// 滚动配置
class TextFieldScrollConfig {
  const TextFieldScrollConfig({
    this.physics,
    this.controller,
    this.padding = const EdgeInsets.all(20.0),
  });

  final ScrollPhysics? physics;
  final ScrollController? controller;
  final EdgeInsets padding;
}

/// 输入框样式的 Form 表单组件
class TxCommonTextFormField<T> extends TxFormField<T> {
  TxCommonTextFormField({
    required this.displayTextMapper,
    this.isEmpty,
    this.clearable,
    this.controller,
    this.focusNode,
    ValueChanged<TxCommonTextFormFieldState<T>>? onTap,
    ValueMapper<String, T?>? valueMapper,
    super.key,
    super.onSaved,
    super.validator,
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    super.decoration,
    super.onChanged,
    super.required,
    super.initialValue,
    super.bordered,
    String? hintText,
    bool? readOnly,
    int? maxLines,
    int? minLines,
    EditConfig? editConfig,
    super.label,
    super.labelText,
    super.actionsBuilder,
    super.trailingBuilder,
    super.leading,
    super.tileTheme,
  })  : assert(initialValue == null || controller == null),
        assert(controller == null || T == String),
        assert(editConfig?.obscuringCharacter == null ||
            editConfig!.obscuringCharacter!.length == 1),
        assert(maxLines == null || maxLines > 0),
        assert(minLines == null || minLines > 0),
        assert(
          (maxLines == null) || (minLines == null) || (maxLines >= minLines),
          "minLines can't be greater than maxLines",
        ),
        assert(
          editConfig?.expands != true || (maxLines == null && minLines == null),
          'minLines and maxLines must be null when expands is true.',
        ),
        assert(editConfig?.obscureText != true || maxLines == 1,
            'Obscured fields cannot be multiline.'),
        assert(editConfig?.maxLength == null ||
            editConfig!.maxLength == TextField.noMaxLength ||
            editConfig.maxLength! > 0),
        readOnly = readOnly ?? false,
        obscureText = editConfig?.obscureText,
        super(
          builder: (field) {
            final state = field as TxCommonTextFormFieldState<T>;
            valueMapper ??= (value) => value as T;

            void onTapOutsideHandler(PointerDownEvent event) {
              if (editConfig?.onTapOutside != null) {
                editConfig!.onTapOutside!(event);
              }
              field.focusNode?.unfocus();
            }

            final TextAlign effectiveTextAlign = editConfig?.textAlign ??
                (tileTheme?.layoutDirection == Axis.horizontal
                    ? TextAlign.right
                    : TextAlign.left);

            maxLines ??= minLines != null ? null : 1;

            return UnmanagedRestorationScope(
              bucket: field.bucket,
              child: TextField(
                controller: controller ?? state.controller,
                focusNode: field.focusNode,
                undoController: editConfig?.undoController,
                decoration: field.effectiveDecoration,
                keyboardType: editConfig?.keyboardType ??
                    (maxLines == 1
                        ? TextInputType.text
                        : TextInputType.multiline),
                textInputAction:
                    editConfig?.textInputAction ?? TextInputAction.done,
                textCapitalization:
                    editConfig?.textCapitalization ?? TextCapitalization.none,
                style: editConfig?.style,
                strutStyle: editConfig?.strutStyle,
                textAlign: effectiveTextAlign,
                textAlignVertical:
                    editConfig?.textAlignVertical ?? TextAlignVertical.center,
                textDirection: editConfig?.textDirection,
                readOnly: readOnly ?? false,
                showCursor: editConfig?.showCursor,
                autofocus: editConfig?.autofocus ?? false,
                statesController: editConfig?.statesController,
                obscuringCharacter: editConfig?.obscuringCharacter ?? '•',
                obscureText: field.obscureText ?? false,
                autocorrect: editConfig?.autocorrect ?? true,
                smartDashesType: editConfig?.smartDashesType,
                smartQuotesType: editConfig?.smartQuotesType,
                enableSuggestions: editConfig?.enableSuggestions ?? true,
                maxLines: maxLines,
                minLines: minLines,
                expands: editConfig?.expands ?? false,
                maxLength: editConfig?.maxLength,
                maxLengthEnforcement: editConfig?.maxLengthEnforcement,
                onChanged: (value) => field.didChange(valueMapper!(value)),
                onEditingComplete: editConfig?.onEditingComplete,
                onSubmitted: editConfig?.onFieldSubmitted,
                onAppPrivateCommand: editConfig?.onAppPrivateCommand,
                inputFormatters: editConfig?.inputFormatters,
                enabled: enabled,
                cursorWidth: editConfig?.cursorWidth ?? 2.0,
                cursorHeight: editConfig?.cursorHeight,
                cursorRadius: editConfig?.cursorRadius,
                cursorOpacityAnimates: editConfig?.cursorOpacityAnimates,
                cursorColor: editConfig?.cursorColor,
                cursorErrorColor: editConfig?.cursorErrorColor,
                selectionHeightStyle:
                    editConfig?.selectionHeightStyle ?? ui.BoxHeightStyle.tight,
                selectionWidthStyle:
                    editConfig?.selectionWidthStyle ?? ui.BoxWidthStyle.tight,
                keyboardAppearance: editConfig?.keyboardAppearance,
                scrollPadding:
                    editConfig?.scrollPadding ?? const EdgeInsets.all(20.0),
                dragStartBehavior:
                    editConfig?.dragStartBehavior ?? DragStartBehavior.start,
                enableInteractiveSelection:
                    editConfig?.enableInteractiveSelection,
                selectionControls: editConfig?.selectionControls,
                onTap: onTap == null ? null : () => onTap(field),
                onTapAlwaysCalled: editConfig?.onTapAlwaysCalled ?? false,
                onTapOutside: onTapOutsideHandler,
                mouseCursor: editConfig?.mouseCursor,
                buildCounter: editConfig?.buildCounter,
                scrollController: editConfig?.scrollController,
                scrollPhysics: editConfig?.scrollPhysics,
                autofillHints: editConfig?.autofillHints,
                contentInsertionConfiguration:
                    editConfig?.contentInsertionConfiguration,
                clipBehavior: editConfig?.clipBehavior ?? Clip.hardEdge,
                restorationId: restorationId,
                scribbleEnabled: editConfig?.scribbleEnabled ?? true,
                enableIMEPersonalizedLearning:
                    editConfig?.enableIMEPersonalizedLearning ?? true,
                contextMenuBuilder: editConfig?.contextMenuBuilder ??
                    TxCommonTextFormField._defaultContextMenuBuilder,
                canRequestFocus: editConfig?.canRequestFocus ??
                    (readOnly == true ? false : true),
                spellCheckConfiguration: editConfig?.spellCheckConfiguration,
                magnifierConfiguration: editConfig?.magnifierConfiguration,
              ),
            );
          },
          hintText: hintText,
        );

  TxCommonTextFormField.readonly({
    required this.displayTextMapper,
    this.isEmpty,
    this.clearable,
    this.focusNode,
    ValueChanged<TxCommonTextFormFieldState<T>>? onTap,
    super.key,
    super.onSaved,
    super.validator,
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    super.decoration,
    super.onChanged,
    super.required,
    super.initialValue,
    super.bordered,
    String? hintText,
    bool? readOnly,
    int? maxLines,
    int? minLines,
    TextFieldDisplayConfig? displayConfig,
    TextFieldScrollConfig? scrollConfig,
    super.label,
    super.labelText,
    super.actionsBuilder,
    super.trailingBuilder,
    super.leading,
    super.tileTheme,
  })  : assert(maxLines == null || maxLines > 0),
        assert(minLines == null || minLines > 0),
        assert(
          (maxLines == null) || (minLines == null) || (maxLines >= minLines),
          "minLines can't be greater than maxLines",
        ),
        readOnly = readOnly ?? false,
        obscureText = false,
        controller = null,
        super(
          builder: (field) {
            final state = field as TxCommonTextFormFieldState<T>;

            void onTapOutsideHandler(PointerDownEvent event) {
              FocusScope.of(field.context).requestFocus(FocusNode());
            }

            final TextAlign effectiveTextAlign = displayConfig?.textAlign ??
                (tileTheme?.layoutDirection == Axis.horizontal
                    ? TextAlign.right
                    : TextAlign.left);

            maxLines ??= minLines != null ? null : 1;

            return UnmanagedRestorationScope(
              bucket: field.bucket,
              child: TextField(
                controller: state.controller,
                focusNode: field.focusNode,
                decoration: field.effectiveDecoration,
                textAlign: effectiveTextAlign,
                readOnly: true,
                maxLines: maxLines,
                minLines: minLines,
                enabled: enabled,
                scrollPadding:
                    scrollConfig?.padding ?? const EdgeInsets.all(20.0),
                onTap: onTap == null ? null : () => onTap(field),
                onTapOutside: onTapOutsideHandler,
                scrollController: scrollConfig?.controller,
                scrollPhysics: scrollConfig?.physics,
                restorationId: restorationId,
              ),
            );
          },
          hintText: readOnly == true ? null : (hintText ?? '请选择'),
        );

  /// 参考 [TextFormField.controller]
  final TextEditingController? controller;

  /// 输入框显示的文字生成器
  final ContextValueMapper<T, String> displayTextMapper;

  /// 输入内容是否可清除
  final bool? clearable;

  /// 是否隐藏文字
  final bool? obscureText;

  /// 判断是否为 null 或者空
  final ValueMapper<T, bool>? isEmpty;

  /// 焦点
  final FocusNode? focusNode;

  /// 是否只读
  final bool readOnly;

  static Widget _defaultContextMenuBuilder(
    BuildContext context,
    EditableTextState editableTextState,
  ) {
    return AdaptiveTextSelectionToolbar.editableText(
      editableTextState: editableTextState,
    );
  }

  @override
  TxCommonTextFormFieldState<T> createState() => TxCommonTextFormFieldState();
}

class TxCommonTextFormFieldState<T> extends TxFormFieldState<T> {
  FocusNode? get focusNode => widget.focusNode;

  TextEditingController? _controller;

  TextEditingController? get controller => widget.controller ?? _controller;

  bool? get obscureText => widget.obscureText;

  bool get clearable =>
      !widget.readOnly && isEnabled && widget.clearable != false && !isEmpty;

  @override
  TxCommonTextFormField<T> get widget =>
      super.widget as TxCommonTextFormField<T>;

  String get _displayText =>
      value == null ? '' : widget.displayTextMapper(context, value as T);

  @override
  bool get isEmpty =>
      value == null ||
      (widget.isEmpty == null ? false : widget.isEmpty!(value as T));

  /// 只修改值，不修改输入框文字
  @override
  void setValue(T? value) {
    super.setValue(value);
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
  void didUpdateWidget(covariant TxCommonTextFormField<T> oldWidget) {
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
  List<Widget>? get suffixIcons {
    return [
      ...?super.suffixIcons,
      if (clearable)
        IconButton(
          onPressed: () => didChange(null),
          icon: const Icon(Icons.cancel, size: 16.0),
          style: IconButton.styleFrom(
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
          ),
        ),
    ];
  }
}
