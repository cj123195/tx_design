import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'form_item_container.dart';

/// 输入框Form组件
class InputFormField extends FormField<String> {
  InputFormField({
    this.controller,
    // Form相关参数
    bool required = false,
    bool? enabled,
    super.restorationId,
    AutovalidateMode? autovalidateMode,
    String? initialValue,
    FormFieldValidator<String>? validator,
    // FormItemContainer参数
    Widget? label,
    String? labelText,
    EdgeInsetsGeometry? padding,
    Color? backgroundColor,
    TextStyle? labelStyle,
    TextStyle? starStyle,
    double? horizontalGap,
    double? minLabelWidth,
    Axis? direction,
    // TextField参数
    super.key,
    FocusNode? focusNode,
    InputDecoration decoration = const InputDecoration(),
    TextInputType? keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
    TextInputAction? textInputAction,
    TextStyle? style,
    StrutStyle? strutStyle,
    TextDirection? textDirection,
    TextAlign? textAlign,
    TextAlignVertical? textAlignVertical,
    bool autofocus = false,
    bool readonly = false,
    EditableTextContextMenuBuilder? contextMenuBuilder,
    int? maxLines = 1,
    int? minLines,
    int? maxLength,
    ValueChanged<String>? onChanged,
    GestureTapCallback? onTap,
    VoidCallback? onEditingComplete,
    List<TextInputFormatter>? inputFormatters,
    bool enableSpeech = true,
  })  : assert(initialValue == null || controller == null),
        assert(maxLines == null || maxLines > 0),
        assert(minLines == null || minLines > 0),
        assert(
          (maxLines == null) || (minLines == null) || (maxLines >= minLines),
          "最小行数不能大于最大行数",
        ),
        assert(maxLength == null ||
            maxLength == TextField.noMaxLength ||
            maxLength > 0),
        super(
          initialValue:
              controller != null ? controller.text : (initialValue ?? ''),
          validator: validator ??
              (required
                  ? (String? val) =>
                      val?.isNotEmpty == true ? null : '请输入${labelText ?? ''}'
                  : null),
          enabled: enabled ?? decoration.enabled,
          autovalidateMode: autovalidateMode ?? AutovalidateMode.disabled,
          builder: (FormFieldState<String> field) {
            final _InputFormFieldState state = field as _InputFormFieldState;

            void onChangedHandler(String value) {
              field.didChange(value);
              if (onChanged != null) {
                onChanged(value);
              }
            }

            Widget? suffixIcon;
            if (!readonly && state.value?.isNotEmpty == true) {
              suffixIcon = IconButton(
                onPressed: () => onChangedHandler(''),
                color: Colors.grey.withOpacity(0.5),
                icon: const Icon(Icons.cancel, size: 20.0),
              );
            }
            final InputDecoration effectiveDecoration =
                FormItemContainer.createDecoration(
              state.context,
              decoration,
              hintText: '请输入',
              errorText: state.errorText,
              suffixIcon: suffixIcon,
            );
            final TextAlign effectiveTextAlign = FormItemContainer.getTextAlign(
              state.context,
              textAlign,
              direction,
            );

            return UnmanagedRestorationScope(
              bucket: field.bucket,
              child: FormItemContainer(
                label: label,
                labelText: labelText,
                required: required,
                direction: direction,
                backgroundColor: backgroundColor,
                labelStyle: labelStyle,
                starStyle: starStyle,
                horizontalGap: horizontalGap,
                minLabelWidth: minLabelWidth,
                padding: padding,
                formField: TextField(
                  restorationId: restorationId,
                  controller: state._effectiveController,
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
                  textCapitalization: textCapitalization,
                  autofocus: autofocus,
                  contextMenuBuilder: contextMenuBuilder,
                  readOnly: readonly,
                  maxLines: maxLines,
                  minLines: minLines,
                  maxLength: maxLength,
                  onChanged: onChangedHandler,
                  onTap: onTap,
                  onEditingComplete: onEditingComplete,
                  inputFormatters: inputFormatters,
                  enabled: enabled ?? decoration.enabled,
                ),
              ),
            );
          },
        );

  final TextEditingController? controller;

  @override
  FormFieldState<String> createState() => _InputFormFieldState();
}

class _InputFormFieldState extends FormFieldState<String> {
  RestorableTextEditingController? _controller;

  TextEditingController get _effectiveController =>
      _textFormField.controller ?? _controller!.value;

  InputFormField get _textFormField => super.widget as InputFormField;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(oldBucket, initialRestore);
    if (_controller != null) {
      _registerController();
    }
    // 确保更新内部 [FormFieldState] 值以与文本编辑控制器值同步
    setValue(_effectiveController.text);
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
          ? TextEditingValue(text: widget.initialValue!)
          : null);
    } else {
      _textFormField.controller!.addListener(_handleControllerChanged);
    }
  }

  @override
  void didUpdateWidget(InputFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_textFormField.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      _textFormField.controller?.addListener(_handleControllerChanged);

      if (oldWidget.controller != null && _textFormField.controller == null) {
        _createLocalController(oldWidget.controller!.value);
      }

      if (_textFormField.controller != null) {
        setValue(_textFormField.controller!.text);
        if (oldWidget.controller == null) {
          unregisterFromRestoration(_controller!);
          _controller!.dispose();
          _controller = null;
        }
      }
    } else if (_textFormField.initialValue != _effectiveController.text) {
      setValue(widget.initialValue ?? '');
      _effectiveController.text = widget.initialValue ?? '';
    }
  }

  @override
  void dispose() {
    _textFormField.controller?.removeListener(_handleControllerChanged);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChange(String? value) {
    super.didChange(value);

    if (_effectiveController.text != value) {
      _effectiveController.text = value ?? '';
    }
  }

  @override
  void reset() {
    _effectiveController.text = widget.initialValue ?? '';
    super.reset();
  }

  /// 输入文字改变
  void _handleControllerChanged() {
    if (_effectiveController.text != value) {
      didChange(_effectiveController.text);
    }
  }
}
