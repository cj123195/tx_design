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

/// 输入框样式的 Form 表单组件
class TxCommonTextFormField<T> extends TxFormField<T> {
  TxCommonTextFormField({
    required this.displayTextMapper,
    this.isEmpty,
    this.clearable,
    this.controller,
    this.focusNode,
    this.obscureText,
    InputValueChanged<T>? onInputChanged,
    ValueChanged<TxFormFieldState<T>>? onFieldTap, // 新增 onFieldTap
    super.onTap, // 继承自 TxFormField 的 onTap
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
    super.hintText,
    TextInputType? keyboardType,
    TextCapitalization? textCapitalization,
    TextInputAction? textInputAction,
    TextStyle? style,
    StrutStyle? strutStyle,
    TextDirection? textDirection,
    TextAlign? textAlign,
    TextAlignVertical? textAlignVertical,
    bool? autofocus,
    bool? readOnly,
    bool? showCursor,
    String? obscuringCharacter,
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
    MaterialStatesController? statesController,
    Clip? clipBehavior,
    bool? scribbleEnabled,
    bool? canRequestFocus,
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
  })  : assert(initialValue == null || controller == null),
        assert(controller == null || T == String),
        assert(obscuringCharacter == null || obscuringCharacter.length == 1),
        assert(maxLines == null || maxLines > 0),
        assert(minLines == null || minLines > 0),
        assert(
          (maxLines == null) || (minLines == null) || (maxLines >= minLines),
          "minLines can't be greater than maxLines",
        ),
        assert(
          expands != true || (maxLines == null && minLines == null),
          'minLines and maxLines must be null when expands is true.',
        ),
        assert(obscureText != true || maxLines == 1,
            'Obscured fields cannot be multiline.'),
        assert(maxLength == null ||
            maxLength == TextField.noMaxLength ||
            maxLength > 0),
        super(
          builder: (field) {
            final state = field as TxCommonTextFormFieldState<T>;

            void onTapOutsideHandler(PointerDownEvent event) {
              if (onTapOutside != null) {
                onTapOutside(event);
              }
              field.focusNode?.unfocus();
            }

            final TextAlign effectiveTextAlign = textAlign ??
                (layoutDirection == Axis.horizontal
                    ? TextAlign.right
                    : TextAlign.left);

            return UnmanagedRestorationScope(
              bucket: field.bucket,
              child: TextField(
                controller: controller ?? state.controller,
                focusNode: field.focusNode,
                undoController: undoController,
                decoration: field.effectiveDecoration,
                keyboardType: keyboardType ??
                    (maxLines == 1
                        ? TextInputType.text
                        : TextInputType.multiline),
                textInputAction: textInputAction,
                textCapitalization:
                    textCapitalization ?? TextCapitalization.none,
                style: style,
                strutStyle: strutStyle,
                textAlign: effectiveTextAlign,
                textAlignVertical:
                    textAlignVertical ?? TextAlignVertical.center,
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
                onSubmitted: onFieldSubmitted,
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
                selectionWidthStyle:
                    selectionWidthStyle ?? ui.BoxWidthStyle.tight,
                keyboardAppearance: keyboardAppearance,
                scrollPadding: scrollPadding ?? const EdgeInsets.all(20.0),
                dragStartBehavior: dragStartBehavior ?? DragStartBehavior.start,
                enableInteractiveSelection: enableInteractiveSelection,
                selectionControls: selectionControls,
                onTap: onFieldTap == null
                    ? null
                    : () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        onFieldTap(field);
                      },
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
                    TxCommonTextFormField._defaultContextMenuBuilder,
                canRequestFocus:
                    canRequestFocus ?? (readOnly == true ? false : true),
                spellCheckConfiguration: spellCheckConfiguration,
                magnifierConfiguration: magnifierConfiguration,
              ),
            );
          },
        );

  /// 参考 [TextFormField.controller]
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
  TxCommonTextFormFieldState<T> createState() => TxCommonTextFormFieldState();
}

class TxCommonTextFormFieldState<T> extends TxFormFieldState<T> {
  FocusNode? get focusNode => widget.focusNode;

  TextEditingController? _controller;

  TextEditingController? get controller => widget.controller ?? _controller;

  bool? get obscureText => widget.obscureText;

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
      if (isEnabled && widget.clearable != false && !isEmpty)
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
