import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

import 'form_item_container.dart';

/// 签名Form组件
class SignatureFormField extends FormField<List<Point>> {
  SignatureFormField({
    InputDecoration decoration = const InputDecoration(),
    this.onChanged,

    // Form参数
    super.key,
    super.onSaved,
    List<Point>? initialValue,
    bool required = true,
    bool? enabled,
    super.restorationId,
    AutovalidateMode? autovalidateMode,
    FormFieldValidator<List<Point>?>? validator,

    // FormItemContainer参数
    Widget? label,
    String? labelText,
    EdgeInsetsGeometry? labelPadding,
    Color? background,
    Axis? direction,
  }) : super(
          initialValue: initialValue,
          validator: validator ??
              (required
                  ? (List<Point>? value) {
                      return value?.isNotEmpty != true ? '请签名' : null;
                    }
                  : null),
          autovalidateMode: autovalidateMode ?? AutovalidateMode.disabled,
          enabled: enabled ?? decoration.enabled,
          builder: (FormFieldState<List<Point>> field) {
            final _SignatureFormFieldState state =
                field as _SignatureFormFieldState;

            final List<Widget> actions = [
              IconButton(
                onPressed: state._switchEditMode,
                icon: Icon(state.editable ? Icons.done : Icons.edit),
                visualDensity: VisualDensity.compact,
              ),
              if (state.editable)
                IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: () {
                    field.didChange(null);
                    state.signatureController.clear();
                    if (onChanged != null) {
                      onChanged(null);
                    }
                  },
                  icon: const Icon(Icons.cleaning_services_rounded),
                  tooltip: '清空',
                )
            ];

            return UnmanagedRestorationScope(
              bucket: field.bucket,
              child: FormItemContainer(
                actions: actions,
                label: label,
                labelText: labelText,
                required: required,
                direction: direction ?? Axis.vertical,
                background: background,
                padding: labelPadding,
                formField: InputDecorator(
                  decoration: decoration.copyWith(
                    errorText: state.errorText,
                    hintText: '请签名',
                    fillColor: Colors.white,
                  ),
                  isEmpty: field.value?.isNotEmpty != true,
                  child: SizedBox(
                    height: 250,
                    child: IgnorePointer(
                      ignoring: !field.editable,
                      child: Signature(
                        width:
                            MediaQuery.of(state.context).size.width - 16.0 * 4,
                        controller: state.signatureController,
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
  final ValueChanged<String?>? onChanged;

  @override
  FormFieldState<List<Point>> createState() => _SignatureFormFieldState();
}

class _SignatureFormFieldState extends FormFieldState<List<Point>> {
  late SignatureController signatureController;
  bool editable = false;

  void _switchEditMode() {
    setState(() {
      editable = !editable;
    });
  }

  void onChangedHandler() async {
    didChange(signatureController.points);
    if (widget.onChanged != null) {
      final res = await signatureController.toPngBytes();
      widget.onChanged!(
          res == null ? null : 'data:image/png;base64,${base64Encode(res)}');
    }
  }

  @override
  void initState() {
    super.initState();
    signatureController = SignatureController(onDrawEnd: onChangedHandler);
  }

  @override
  void dispose() {
    signatureController.dispose();
    super.dispose();
  }

  @override
  SignatureFormField get widget => super.widget as SignatureFormField;

  @override
  void didUpdateWidget(covariant SignatureFormField oldWidget) {
    if (widget.initialValue != value) {
      signatureController.points = widget.initialValue ?? [];
      setValue(widget.initialValue);
    }
    super.didUpdateWidget(oldWidget);
  }
}
