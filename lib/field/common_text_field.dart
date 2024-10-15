import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'field.dart';
import 'field_tile.dart';

/// 通用输入框
///
/// 统一封装提供给所有需要输入框样式的 field 组件使用，如 textField, pickerField等
abstract class TxCommonTextField<T> extends TxField<T> {
  const TxCommonTextField({
    super.key,
    this.controller,
    super.initialValue,
    super.focusNode,
    this.undoController,
    super.decoration,
    TextInputType? keyboardType,
    this.textInputAction,
    TextCapitalization? textCapitalization,
    this.style,
    this.strutStyle,
    TextAlign? textAlign,
    this.textAlignVertical,
    this.textDirection,
    bool? readOnly,
    this.showCursor,
    bool? autofocus,
    this.statesController,
    String? obscuringCharacter,
    bool? obscureText,
    bool? autocorrect,
    SmartDashesType? smartDashesType,
    SmartQuotesType? smartQuotesType,
    bool? enableSuggestions,
    int? maxLines,
    this.minLines,
    bool? expands,
    this.maxLength,
    this.maxLengthEnforcement,
    super.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.onAppPrivateCommand,
    this.inputFormatters,
    super.enabled,
    double? cursorWidth,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorOpacityAnimates,
    this.cursorColor,
    this.cursorErrorColor,
    ui.BoxHeightStyle? selectionHeightStyle,
    ui.BoxWidthStyle? selectionWidthStyle,
    this.keyboardAppearance,
    EdgeInsets? scrollPadding,
    DragStartBehavior? dragStartBehavior,
    bool? enableInteractiveSelection,
    this.selectionControls,
    this.onTap,
    bool? onTapAlwaysCalled,
    this.onTapOutside,
    this.mouseCursor,
    this.buildCounter,
    this.scrollController,
    this.scrollPhysics,
    this.autofillHints,
    this.contentInsertionConfiguration,
    Clip? clipBehavior,
    this.restorationId,
    bool? scribbleEnabled,
    bool? enableIMEPersonalizedLearning,
    this.contextMenuBuilder,
    bool? canRequestFocus,
    this.spellCheckConfiguration,
    this.magnifierConfiguration,
  })  : assert(controller == null || initialValue == null),
        textCapitalization = textCapitalization ?? TextCapitalization.none,
        textAlign = textAlign ?? TextAlign.start,
        readOnly = readOnly ?? false,
        autofocus = autofocus ?? false,
        obscuringCharacter = obscuringCharacter ?? '•',
        obscureText = obscureText ?? false,
        autocorrect = autocorrect ?? true,
        enableSuggestions = enableSuggestions ?? true,
        maxLines = maxLines ?? (minLines != null ? null : 1),
        expands = expands ?? false,
        cursorWidth = cursorWidth ?? 2.0,
        selectionHeightStyle = selectionHeightStyle ?? ui.BoxHeightStyle.tight,
        selectionWidthStyle = selectionWidthStyle ?? ui.BoxWidthStyle.tight,
        scrollPadding = scrollPadding ?? const EdgeInsets.all(20.0),
        dragStartBehavior = dragStartBehavior ?? DragStartBehavior.start,
        onTapAlwaysCalled = onTapAlwaysCalled ?? false,
        clipBehavior = clipBehavior ?? Clip.hardEdge,
        scribbleEnabled = scribbleEnabled ?? true,
        enableIMEPersonalizedLearning = enableIMEPersonalizedLearning ?? true,
        canRequestFocus = canRequestFocus ?? true,
        smartDashesType = smartDashesType ??
            (obscureText == true
                ? SmartDashesType.disabled
                : SmartDashesType.enabled),
        smartQuotesType = smartQuotesType ??
            (obscureText == true
                ? SmartQuotesType.disabled
                : SmartQuotesType.enabled),
        keyboardType = keyboardType ??
            (maxLines == 1 ? TextInputType.text : TextInputType.multiline),
        enableInteractiveSelection = enableInteractiveSelection ??
            (readOnly != true || obscureText != true);

  /// 参考 [TextField.magnifierConfiguration]
  final TextMagnifierConfiguration? magnifierConfiguration;

  /// 参考 [TextField.controller]
  final TextEditingController? controller;

  /// 参考 [TextField.keyboardType]
  final TextInputType keyboardType;

  /// 参考 [TextField.textInputAction]
  final TextInputAction? textInputAction;

  /// 参考 [TextField.textCapitalization]
  final TextCapitalization textCapitalization;

  /// 参考 [TextField.style]
  final TextStyle? style;

  /// 参考 [TextField.strutStyle]
  final StrutStyle? strutStyle;

  /// 参考 [TextField.textAlign]
  final TextAlign textAlign;

  /// 参考 [TextField.textAlignVertical]
  final TextAlignVertical? textAlignVertical;

  /// 参考 [TextField.textDirection]
  final TextDirection? textDirection;

  /// 参考 [TextField.autofocus]
  final bool autofocus;

  /// 参考 [TextField.statesController]
  final MaterialStatesController? statesController;

  /// 参考 [TextField.obscuringCharacter]
  final String obscuringCharacter;

  /// 参考 [TextField.obscureText]
  final bool obscureText;

  /// 参考 [TextField.autocorrect]
  final bool autocorrect;

  /// 参考 [TextField.smartDashesType]
  final SmartDashesType smartDashesType;

  /// 参考 [TextField.smartQuotesType]
  final SmartQuotesType smartQuotesType;

  /// 参考 [TextField.enableSuggestions]
  final bool enableSuggestions;

  /// 参考 [TextField.maxLines]
  final int? maxLines;

  /// 参考 [TextField.minLines]
  final int? minLines;

  /// 参考 [TextField.expands]
  final bool expands;

  /// 参考 [TextField.readOnly]
  final bool readOnly;

  /// 参考 [TextField.showCursor]
  final bool? showCursor;

  /// 参考 [TextField.maxLength]
  final int? maxLength;

  /// 参考 [TextField.maxLengthEnforcement]
  final MaxLengthEnforcement? maxLengthEnforcement;

  /// 参考 [TextField.onEditingComplete]
  final VoidCallback? onEditingComplete;

  /// 参考 [TextField.onSubmitted]
  final ValueChanged<String>? onSubmitted;

  /// 参考 [TextField.onAppPrivateCommand]
  final AppPrivateCommandCallback? onAppPrivateCommand;

  /// 参考 [TextField.inputFormatters]
  final List<TextInputFormatter>? inputFormatters;

  /// 参考 [TextField.cursorWidth]
  final double cursorWidth;

  /// 参考 [TextField.cursorHeight]
  final double? cursorHeight;

  /// 参考 [TextField.cursorRadius]
  final Radius? cursorRadius;

  /// 参考 [TextField.cursorOpacityAnimates]
  final bool? cursorOpacityAnimates;

  /// 参考 [TextField.cursorColor]
  final Color? cursorColor;

  /// 参考 [TextField.cursorErrorColor]
  final Color? cursorErrorColor;

  /// 参考 [TextField.selectionHeightStyle]
  final ui.BoxHeightStyle selectionHeightStyle;

  /// 参考 [TextField.selectionWidthStyle]
  final ui.BoxWidthStyle selectionWidthStyle;

  /// 参考 [TextField.keyboardAppearance]
  final Brightness? keyboardAppearance;

  /// 参考 [TextField.scrollPadding]
  final EdgeInsets scrollPadding;

  /// 参考 [TextField.enableInteractiveSelection]
  final bool enableInteractiveSelection;

  /// 参考 [TextField.selectionControls]
  final TextSelectionControls? selectionControls;

  /// 参考 [TextField.dragStartBehavior]
  final DragStartBehavior dragStartBehavior;

  /// 参考 [TextField.selectionEnabled]
  bool get selectionEnabled => enableInteractiveSelection;

  /// 参考 [TextField.onTap]
  final GestureTapCallback? onTap;

  /// 参考 [TextField.onTapAlwaysCalled]
  final bool onTapAlwaysCalled;

  /// 参考 [TextField.onTapOutside]
  final TapRegionCallback? onTapOutside;

  /// 参考 [TextField.mouseCursor]
  final MouseCursor? mouseCursor;

  /// 参考 [TextField.buildCounter]
  final InputCounterWidgetBuilder? buildCounter;

  /// 参考 [TextField.scrollPhysics]
  final ScrollPhysics? scrollPhysics;

  /// 参考 [TextField.scrollController]
  final ScrollController? scrollController;

  /// 参考 [TextField.autofillHints]
  final Iterable<String>? autofillHints;

  /// 参考 [TextField.clipBehavior]
  final Clip clipBehavior;

  /// 参考 [TextField.restorationId]
  final String? restorationId;

  /// 参考 [TextField.scribbleEnabled]
  final bool scribbleEnabled;

  /// 参考 [TextField.enableIMEPersonalizedLearning]
  final bool enableIMEPersonalizedLearning;

  /// 参考 [TextField.contentInsertionConfiguration]
  final ContentInsertionConfiguration? contentInsertionConfiguration;

  /// 参考 [TextField.contextMenuBuilder]
  final EditableTextContextMenuBuilder? contextMenuBuilder;

  /// 参考 [TextField.canRequestFocus]
  final bool canRequestFocus;

  /// 参考 [TextField.undoController]
  final UndoHistoryController? undoController;

  static Widget _defaultContextMenuBuilder(
      BuildContext context, EditableTextState editableTextState) {
    return AdaptiveTextSelectionToolbar.editableText(
      editableTextState: editableTextState,
    );
  }

  /// 参考 [TextField.spellCheckConfiguration]
  final SpellCheckConfiguration? spellCheckConfiguration;

  @override
  TxCommonTextFieldState<T> createState();
}

abstract class TxCommonTextFieldState<T> extends TxFieldState<T> {
  TextEditingController? _controller;

  TextEditingController? get controller => widget.controller ?? _controller;

  /// 输入框显示的文字
  String? get displayText;

  /// 组件外部点击事件处理
  @mustCallSuper
  void onTapOutsideHandler(PointerDownEvent event) {
    if (widget.onTapOutside != null) {
      widget.onTapOutside!(event);
    }
    FocusScope.of(context).unfocus();
  }

  /// 编辑完成事件处理
  @mustCallSuper
  void onEditingCompleteHandler() {
    if (widget.onEditingComplete != null) {
      widget.onEditingComplete!();
    }
  }

  /// 点击事件处理
  @mustCallSuper
  void onTapHandler() {
    if (widget.onTap != null) {
      widget.onTap!();
    }
  }

  /// 输入框输入值变化回调
  void onChangedHandler(String? value);

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
      } else if (displayText != _controller!.text) {
        _controller!.text = displayText ?? '';
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
    return TextField(
      controller: widget.controller ?? _controller,
      focusNode: widget.focusNode,
      undoController: widget.undoController,
      decoration: effectiveDecoration,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      textCapitalization: widget.textCapitalization,
      style: widget.style,
      strutStyle: widget.strutStyle,
      textAlign: widget.textAlign,
      textAlignVertical: widget.textAlignVertical,
      textDirection: widget.textDirection,
      readOnly: widget.readOnly,
      showCursor: widget.showCursor,
      autofocus: widget.autofocus,
      statesController: widget.statesController,
      obscuringCharacter: widget.obscuringCharacter,
      obscureText: widget.obscureText,
      autocorrect: widget.autocorrect,
      smartDashesType: widget.smartDashesType,
      smartQuotesType: widget.smartQuotesType,
      enableSuggestions: widget.enableSuggestions,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      expands: widget.expands,
      maxLength: widget.maxLength,
      maxLengthEnforcement: widget.maxLengthEnforcement,
      onChanged: onChangedHandler,
      onEditingComplete: onEditingCompleteHandler,
      onSubmitted: widget.onSubmitted,
      onAppPrivateCommand: widget.onAppPrivateCommand,
      inputFormatters: widget.inputFormatters,
      enabled: widget.enabled,
      cursorWidth: widget.cursorWidth,
      cursorHeight: widget.cursorHeight,
      cursorRadius: widget.cursorRadius,
      cursorOpacityAnimates: widget.cursorOpacityAnimates,
      cursorColor: widget.cursorColor,
      cursorErrorColor: widget.cursorErrorColor,
      selectionHeightStyle: widget.selectionHeightStyle,
      selectionWidthStyle: widget.selectionWidthStyle,
      keyboardAppearance: widget.keyboardAppearance,
      scrollPadding: widget.scrollPadding,
      dragStartBehavior: widget.dragStartBehavior,
      enableInteractiveSelection: widget.enableInteractiveSelection,
      selectionControls: widget.selectionControls,
      onTap: onTapHandler,
      onTapAlwaysCalled: widget.onTapAlwaysCalled,
      onTapOutside: onTapOutsideHandler,
      mouseCursor: widget.mouseCursor,
      buildCounter: widget.buildCounter,
      scrollController: widget.scrollController,
      scrollPhysics: widget.scrollPhysics,
      autofillHints: widget.autofillHints,
      contentInsertionConfiguration: widget.contentInsertionConfiguration,
      clipBehavior: widget.clipBehavior,
      restorationId: widget.restorationId,
      scribbleEnabled: widget.scribbleEnabled,
      enableIMEPersonalizedLearning: widget.enableIMEPersonalizedLearning,
      contextMenuBuilder: widget.contextMenuBuilder ??
          TxCommonTextField._defaultContextMenuBuilder,
      canRequestFocus: widget.canRequestFocus,
      spellCheckConfiguration: widget.spellCheckConfiguration,
      magnifierConfiguration: widget.magnifierConfiguration,
    );
  }
}

/// 通用 [field] 为输入框样式的 [TxFieldTile]
class TxCommonTextFieldTile<T> extends TxFieldTile {
  const TxCommonTextFieldTile({
    required super.field,
    super.key,
    super.labelBuilder,
    super.labelText,
    super.padding,
    super.actions,
    super.labelStyle,
    super.horizontalGap,
    super.tileColor,
    super.layoutDirection,
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
    super.minLabelWidth,
    super.minVerticalPadding,
    super.dense,
    TextEditingController? controller,
    T? initialValue,
    FocusNode? focusNode,
    UndoHistoryController? undoController,
    InputDecoration? decoration,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    TextCapitalization? textCapitalization,
    TextStyle? style,
    StrutStyle? strutStyle,
    TextAlign? textAlign,
    TextAlignVertical? textAlignVertical,
    TextDirection? textDirection,
    bool? readOnly,
    bool? showCursor,
    bool? autofocus,
    MaterialStatesController? statesController,
    String? obscuringCharacter,
    bool? obscureText,
    bool? autocorrect,
    SmartDashesType? smartDashesType,
    SmartQuotesType? smartQuotesType,
    bool? enableSuggestions,
    int? maxLines,
    int? minLines,
    bool? expands,
    int? maxLength,
    MaxLengthEnforcement? maxLengthEnforcement,
    ValueChanged<T?>? onChanged,
    VoidCallback? onEditingComplete,
    ValueChanged<String>? onSubmitted,
    AppPrivateCommandCallback? onAppPrivateCommand,
    List<TextInputFormatter>? inputFormatters,
    double? cursorWidth,
    double? cursorHeight,
    Radius? cursorRadius,
    bool? cursorOpacityAnimates,
    Color? cursorColor,
    Color? cursorErrorColor,
    ui.BoxHeightStyle? selectionHeightStyle,
    ui.BoxWidthStyle? selectionWidthStyle,
    Brightness? keyboardAppearance,
    EdgeInsets? scrollPadding,
    DragStartBehavior? dragStartBehavior,
    bool? enableInteractiveSelection,
    TextSelectionControls? selectionControls,
    bool? onTapAlwaysCalled,
    TapRegionCallback? onTapOutside,
    MouseCursor? mouseCursor,
    InputCounterWidgetBuilder? buildCounter,
    ScrollController? scrollController,
    ScrollPhysics? scrollPhysics,
    Iterable<String>? autofillHints,
    ContentInsertionConfiguration? contentInsertionConfiguration,
    Clip? clipBehavior,
    String? restorationId,
    bool? scribbleEnabled,
    bool? enableIMEPersonalizedLearning,
    EditableTextContextMenuBuilder? contextMenuBuilder,
    bool? canRequestFocus,
    SpellCheckConfiguration? spellCheckConfiguration,
    TextMagnifierConfiguration? magnifierConfiguration,
  }) : assert(controller == null || initialValue == null);
}
