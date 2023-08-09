import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

import '../localizations.dart';
import 'form_field.dart';

/// 签名Form组件
class SignatureFormField extends TxFormFieldItem<List<Point>> {
  SignatureFormField({
    this.onChanged,
    super.key,
    super.onSaved,
    super.validator,
    super.initialValue,
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    super.required,
    super.label,
    super.labelText,
    super.backgroundColor,
    super.direction,
    super.padding,
    List<Widget>? actions,
    super.labelStyle,
    super.starStyle,
    super.horizontalGap,
    super.minLabelWidth,
    InputDecoration? decoration,
  }) : super(
          defaultValidator: required
              ? (context, value) {
                  return value?.isNotEmpty != true
                      ? TxLocalizations.of(context).signatureFormFieldHint
                      : null;
                }
              : null,
          builder: (FormFieldState<List<Point>> field) {
            final _SignatureFormFieldState state =
                field as _SignatureFormFieldState;

            final TxLocalizations localizations =
                TxLocalizations.of(field.context);

            final List<Widget> actions = [
              IconButton(
                onPressed: state._switchEditMode,
                icon: Icon(state.editable ? Icons.done : Icons.edit),
                visualDensity: VisualDensity.compact,
                tooltip: state.editable
                    ? localizations.doneButtonTooltip
                    : localizations.editButtonTooltip,
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
                  tooltip: localizations.clearButtonLabel,
                )
            ];
            final InputDecoration defaultDecoration = InputDecoration(
              hintText: localizations.signatureFormFieldHint,
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: actions,
              ),
            );

            return UnmanagedRestorationScope(
              bucket: field.bucket,
              child: InputDecorator(
                decoration: TxFormFieldItem.mergeDecoration(
                  field.context,
                  decoration,
                  defaultDecoration,
                ),
                isEmpty: field.value?.isNotEmpty != true,
                child: SizedBox(
                  height: 250,
                  child: IgnorePointer(
                    ignoring: !field.editable,
                    child: Signature(
                      width: MediaQuery.of(state.context).size.width - 16.0 * 4,
                      controller: state.signatureController,
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ),
              ),
            );
          },
        );
  final ValueChanged<String?>? onChanged;

  @override
  TxFormFieldState<List<Point>> createState() => _SignatureFormFieldState();
}

class _SignatureFormFieldState extends TxFormFieldState<List<Point>> {
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
    }
    super.didUpdateWidget(oldWidget);
  }
}
