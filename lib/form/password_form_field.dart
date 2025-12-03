import 'package:flutter/material.dart';

import 'common_text_form_field.dart';

/// 密码输入框表单
class TxPasswordFormField extends TxCommonTextFormField<String> {
  TxPasswordFormField({
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
    super.clearable,
    this.switchEnabled,
    String? hintText,
    super.controller,
    super.focusNode,
    EditConfig? editConfig,
    super.readOnly,
    super.onTap,
    super.label,
    super.labelText,
    super.actionsBuilder,
    super.trailingBuilder,
    super.leading,
    super.tileTheme,
  })  : assert(initialValue == null || controller == null),
        super(
          hintText: hintText ?? '请输入',
          displayTextMapper: (context, value) => value,
          editConfig: (editConfig ?? const EditConfig()).copyWith(
            keyboardType: TextInputType.visiblePassword,
          ),
        );

  /// 是否允许切换
  final bool? switchEnabled;

  @override
  TxCommonTextFormFieldState<String> createState() =>
      _TxPasswordFormFieldState();
}

class _TxPasswordFormFieldState extends TxCommonTextFormFieldState<String> {
  @override
  TxPasswordFormField get widget => super.widget as TxPasswordFormField;

  @override
  void initState() {
    _obscureText = widget.obscureText ?? true;
    super.initState();
  }

  late bool _obscureText;

  @override
  bool get obscureText => _obscureText;

  void switchObscure() {
    setState(() {
      _obscureText = !obscureText;
    });
  }

  @override
  List<Widget>? get suffixIcons => [
        ...?super.suffixIcons,
        if (widget.switchEnabled != false && !isEmpty)
          IconButton(
            onPressed: switchObscure,
            icon: Icon(obscureText
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined),
          ),
      ];
}
