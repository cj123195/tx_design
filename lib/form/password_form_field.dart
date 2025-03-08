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
    super.undoController,
    super.focusNode,
    TextInputType? keyboardType,
    super.textInputAction,
    super.textCapitalization,
    super.style,
    super.strutStyle,
    super.textAlignVertical,
    super.textDirection,
    super.readOnly,
    super.showCursor,
    super.autofocus,
    super.statesController,
    super.obscuringCharacter,
    super.obscureText,
    super.autocorrect,
    super.smartDashesType,
    super.smartQuotesType,
    super.enableSuggestions,
    super.maxLines,
    super.minLines,
    super.expands,
    super.maxLength,
    super.maxLengthEnforcement,
    super.onEditingComplete,
    super.onFieldSubmitted,
    super.onAppPrivateCommand,
    super.inputFormatters,
    super.cursorWidth,
    super.cursorHeight,
    super.cursorRadius,
    super.cursorOpacityAnimates,
    super.cursorColor,
    super.cursorErrorColor,
    super.selectionHeightStyle,
    super.selectionWidthStyle,
    super.keyboardAppearance,
    super.scrollPadding,
    super.dragStartBehavior,
    super.enableInteractiveSelection,
    super.selectionControls,
    super.onTap,
    super.onFieldTap,
    super.onTapAlwaysCalled,
    super.onTapOutside,
    super.mouseCursor,
    super.buildCounter,
    super.scrollController,
    super.scrollPhysics,
    super.autofillHints,
    super.contentInsertionConfiguration,
    super.clipBehavior,
    super.scribbleEnabled,
    super.enableIMEPersonalizedLearning,
    super.contextMenuBuilder,
    super.canRequestFocus,
    super.spellCheckConfiguration,
    super.magnifierConfiguration,
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
        super(
          hintText: hintText ?? '请输入',
          displayTextMapper: (context, value) => value,
          keyboardType: keyboardType ?? TextInputType.visiblePassword,
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
