import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/basic_types.dart';
import 'form_item_container.dart';

/// 通用选择器
class CommonPickerFormField<T, V> extends FormField<T> {
  CommonPickerFormField({
    required this.labelMapper,
    required this.valueMapper,
    required PickerFuture<T> onPickTap,
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
    // Form参数
    super.key,
    super.onSaved,
    T? initialValue,
    bool required = false,
    bool? enabled,
    super.restorationId,
    AutovalidateMode? autovalidateMode,
    FormFieldValidator<T>? validator,
    // TextField参数
    FocusNode? focusNode,
    InputDecoration decoration = const InputDecoration(),
    ValueChanged<T?>? onChanged,
    bool readonly = false,
    TextInputType? keyboardType,
    TextStyle? style,
    TextCapitalization textCapitalization = TextCapitalization.none,
    TextInputAction? textInputAction,
    StrutStyle? strutStyle,
    TextDirection? textDirection,
    TextAlign? textAlign,
    TextAlignVertical? textAlignVertical,
    bool autofocus = false,
    EditableTextContextMenuBuilder? contextMenuBuilder,
    int? maxLines = 1,
    int? minLines,
    int? maxLength,
    GestureTapCallback? onTap,
    VoidCallback? onEditingComplete,
    List<TextInputFormatter>? inputFormatters,
    bool enableSpeech = true,
  })  : assert(maxLines == null || maxLines > 0),
        assert(minLines == null || minLines > 0),
        assert(
          (maxLines == null) || (minLines == null) || (maxLines >= minLines),
          "最小行数不能大于最大行数",
        ),
        assert(maxLength == null ||
            maxLength == TextField.noMaxLength ||
            maxLength > 0),
        super(
          initialValue: initialValue,
          validator: validator ??
              (required
                  ? (T? value) {
                      return value == null ? '请选择${labelText ?? ''}' : null;
                    }
                  : null),
          enabled: enabled ?? decoration.enabled,
          autovalidateMode: autovalidateMode ?? AutovalidateMode.disabled,
          builder: (FormFieldState<T> field) {
            final _CommonPickerFormFieldState state =
                field as _CommonPickerFormFieldState;

            void onChangedHandler(T? value) {
              field.didChange(value);
              if (onChanged != null) {
                onChanged(value);
              }
            }

            Future<void> onTap() async {
              final FocusScopeNode currentFocus = FocusScope.of(state.context);
              if (!currentFocus.hasPrimaryFocus &&
                  currentFocus.focusedChild != null) {
                FocusManager.instance.primaryFocus?.unfocus();
              }
              final T? res = await onPickTap.call(field.context, state.value);
              if (res == null) {
                return;
              }
              if (res != initialValue) {
                onChangedHandler(res);
              }
            }

            Widget suffixIcon = const Icon(Icons.keyboard_arrow_right);
            if (!readonly && state.value != null) {
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
            final InputDecoration effectiveDecoration =
                FormItemContainer.createDecoration(
              state.context,
              decoration,
              hintText: '请选择',
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
                  readOnly: true,
                  maxLines: maxLines,
                  minLines: minLines,
                  maxLength: maxLength,
                  // onChanged: onCh,
                  onTap: readonly ? null : onTap,
                  onEditingComplete: onEditingComplete,
                  inputFormatters: inputFormatters,
                  enabled: enabled ?? decoration.enabled,
                ),
              ),
            );
          },
        );

  /// 描述选择项的文本。
  final ValueMapper<T, String> labelMapper;

  /// 选择项的值，主要用于判断选择项是否被选中。
  final ValueMapper<T, V?> valueMapper;

  @override
  FormFieldState<T> createState() => _CommonPickerFormFieldState<T, V>();
}

class _CommonPickerFormFieldState<T, V> extends FormFieldState<T> {
  RestorableTextEditingController? _controller;

  TextEditingController get _effectiveController => _controller!.value;

  @override
  CommonPickerFormField<T, V> get widget =>
      super.widget as CommonPickerFormField<T, V>;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(oldBucket, initialRestore);
    if (_controller != null) {
      _registerController();
    }
    // 确保更新内部 [FormFieldState] 值以与文本编辑控制器值同步
    // setValue(_effectiveController.text);
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
    _createLocalController(widget.initialValue != null
        ? TextEditingValue(text: widget.labelMapper(widget.initialValue as T))
        : null);
  }

  @override
  void didUpdateWidget(CommonPickerFormField<T, V> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final V? newValue = widget.initialValue == null
        ? null
        : widget.valueMapper(widget.initialValue as T);
    final V? oldValue = value == null ? null : widget.valueMapper(value as T);
    if (newValue != oldValue) {
      setValue(widget.initialValue);
      if (newValue == null) {
        _effectiveController.clear();
      } else {
        _effectiveController.text =
            widget.labelMapper(widget.initialValue as T);
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChange(T? value) {
    super.didChange(value);
    final String? label = value == null ? null : widget.labelMapper(value);
    if (_effectiveController.text != label) {
      _effectiveController.text = label ?? '';
    }
  }

  @override
  void reset() {
    _effectiveController.text = widget.initialValue == null
        ? ''
        : widget.labelMapper(widget.initialValue as T);
    super.reset();
  }

// /// 输入文字改变
// void _handleControllerChanged() {
//   if (_effectiveController.text != value) {
//     didChange(_effectiveController.text);
//   }
// }
}
