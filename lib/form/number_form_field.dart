import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'form_item_container.dart';

/// 数字输入Form组件
class NumberFormField extends FormField<num> {
  NumberFormField({
    this.controller,
    num? max, // 最大值
    num? min = 0, // 最小值
    bool showOperateButton = true, // 是否显示操作按钮
    num? difference, // 自增或自减时的差值，showOperateButton为true时生效
    // Form相关参数
    super.key,
    bool required = false,
    bool? enabled,
    super.restorationId,
    AutovalidateMode? autovalidateMode,
    num? initialValue,
    FormFieldValidator<num>? validator,
    // FormContainer 参数
    Widget? label,
    String? labelText,
    EdgeInsetsGeometry? padding,
    Color? backgroundColor,
    TextStyle? labelStyle,
    TextStyle? starStyle,
    double? horizontalGap,
    double? minLabelWidth,
    Axis? direction,
    FocusNode? focusNode,
    InputDecoration decoration = const InputDecoration(),
    TextCapitalization textCapitalization = TextCapitalization.none,
    TextInputAction? textInputAction,
    TextStyle? style,
    StrutStyle? strutStyle,
    TextDirection? textDirection,
    TextAlign? textAlign,
    TextAlignVertical? textAlignVertical,
    bool autofocus = false,
    bool readOnly = false,
    EditableTextContextMenuBuilder? contextMenuBuilder,
    int? maxLines = 1,
    int? minLines,
    int? maxLength,
    ValueChanged<num?>? onChanged,
    GestureTapCallback? onTap,
    VoidCallback? onEditingComplete,
    List<TextInputFormatter>? inputFormatters,
  })  : assert(initialValue == null || controller == null),
        assert(maxLines == null || maxLines > 0),
        assert(minLines == null || minLines > 0),
        assert(
          (maxLines == null) || (minLines == null) || (maxLines >= minLines),
          "minLines can't be greater than maxLines",
        ),
        assert(min == null || max == null || min < max),
        assert(maxLength == null ||
            maxLength == TextField.noMaxLength ||
            maxLength > 0),
        super(
          initialValue:
              controller != null ? num.tryParse(controller.text) : initialValue,
          validator: validator ??
              (num? value) {
                if (value == null && required) {
                  return '请输入${labelText ?? ''}';
                }
                if (min != null && (value == null || value < min)) {
                  return '请输入大于$min的数字';
                }
                if (max != null && (value == null || value > max)) {
                  return '请输入小于$max的数字';
                }
                return null;
              },
          enabled: enabled ?? decoration.enabled,
          autovalidateMode: autovalidateMode ?? AutovalidateMode.disabled,
          builder: (FormFieldState<num> field) {
            inputFormatters ??= [IntegerFormatter(max, min)];
            final _NumberFormFieldState state = field as _NumberFormFieldState;

            void onChangedHandler(num? value) {
              field.didChange(value);
              if (onChanged != null) {
                onChanged(value);
              }
            }

            Widget? prefixIcon;
            Widget? suffixIcon;
            if (showOperateButton) {
              final num value = field.value ?? 0;
              final bool canAdd = max == null || value < max;
              suffixIcon = IconButton(
                onPressed: canAdd ? () => onChangedHandler(value + 1) : null,
                icon: const Icon(Icons.add),
                visualDensity: VisualDensity.compact,
              );

              final bool canRemove = min == null || value > min;
              prefixIcon = IconButton(
                onPressed: canRemove ? () => onChangedHandler(value - 1) : null,
                icon: const Icon(Icons.remove),
                visualDensity: VisualDensity.compact,
              );
            }

            final InputDecoration effectiveDecoration =
                FormItemContainer.createDecoration(
              state.context,
              decoration,
              hintText: '请输入',
              errorText: state.errorText,
              suffixIcon: suffixIcon,
              prefixIcon: prefixIcon,
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
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  textInputAction: textInputAction,
                  style: style,
                  strutStyle: strutStyle,
                  textAlign: textAlign ??
                      (showOperateButton ? TextAlign.center : TextAlign.start),
                  textAlignVertical: textAlignVertical,
                  textDirection: textDirection,
                  textCapitalization: textCapitalization,
                  autofocus: autofocus,
                  contextMenuBuilder: contextMenuBuilder,
                  readOnly: readOnly,
                  maxLines: maxLines,
                  minLines: minLines,
                  maxLength: maxLength,
                  onChanged: (val) => onChangedHandler(num.tryParse(val)),
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
  FormFieldState<num> createState() => _NumberFormFieldState();
}

class _NumberFormFieldState extends FormFieldState<num> {
  RestorableTextEditingController? _controller;

  TextEditingController get _effectiveController =>
      _textFormField.controller ?? _controller!.value;

  NumberFormField get _textFormField => super.widget as NumberFormField;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(oldBucket, initialRestore);
    if (_controller != null) {
      _registerController();
    }
    // 确保更新内部 [FormFieldState] 值以与文本编辑控制器值同步
    setValue(num.tryParse(_effectiveController.text));
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
          ? TextEditingValue(text: widget.initialValue!.toString())
          : null);
    } else {
      _textFormField.controller!.addListener(_handleControllerChanged);
    }
  }

  @override
  void didUpdateWidget(NumberFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_textFormField.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      _textFormField.controller?.addListener(_handleControllerChanged);

      if (oldWidget.controller != null && _textFormField.controller == null) {
        _createLocalController(oldWidget.controller!.value);
      }

      if (_textFormField.controller != null) {
        setValue(num.tryParse(_textFormField.controller!.text));
        if (oldWidget.controller == null) {
          unregisterFromRestoration(_controller!);
          _controller!.dispose();
          _controller = null;
        }
      }
    }
  }

  @override
  void dispose() {
    _textFormField.controller?.removeListener(_handleControllerChanged);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChange(num? value) {
    super.didChange(value);

    if (num.tryParse(_effectiveController.text) != value) {
      _effectiveController.text = value?.toString() ?? '';
    }
  }

  @override
  void reset() {
    _effectiveController.text = widget.initialValue?.toString() ?? '';
    super.reset();
  }

  /// 输入文字改变
  void _handleControllerChanged() {
    if (num.tryParse(_effectiveController.text) != value) {
      didChange(num.tryParse(_effectiveController.text));
    }
  }
}

abstract class NumberInputFormatter<T> extends TextInputFormatter {
  NumberInputFormatter(this.maxValue, this.minValue);

  NumberInputFormatter.positive()
      : minValue = 0,
        maxValue = null;
  final num? maxValue;
  final num? minValue;

  T? parse(TextEditingValue value);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }
    final num? newNum = num.tryParse(newValue.text);
    if (minValue != null && newNum != null && newNum < minValue!) {
      return newValue.copyWith(
        text: minValue.toString(),
        selection: TextSelection.fromPosition(
          TextPosition(offset: minValue.toString().length),
        ),
      );
    } else if (maxValue != null && newNum != null && newNum > maxValue!) {
      return newValue.copyWith(
        text: maxValue.toString(),
        selection: TextSelection.fromPosition(
          TextPosition(offset: maxValue.toString().length),
        ),
      );
    }
    return newValue;
  }
}

class IntegerFormatter extends NumberInputFormatter {
  IntegerFormatter(super.maxValue, super.minValue);

  IntegerFormatter.positive() : super.positive();

  @override
  int? parse(TextEditingValue value) {
    return int.tryParse(value.text);
  }
}
