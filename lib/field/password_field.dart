import 'package:flutter/material.dart';

import 'common_text_field.dart';

/// 密码输入框
class TxPasswordField extends TxCommonTextField<String> {
  TxPasswordField({
    this.switchEnabled,
    super.clearable,
    super.key,
    super.initialValue,
    super.focusNode,
    super.decoration,
    super.onChanged,
    String? hintText,
    super.textAlign,
    super.bordered,
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
    super.enabled,
    super.minLeadingWidth,
    super.minLabelWidth,
    super.minVerticalPadding,
    super.dense,
    super.colon,
    super.focusColor,
    super.controller,
    super.undoController,
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
    super.onSubmitted,
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
    super.onTapAlwaysCalled,
    super.onTapOutside,
    super.mouseCursor,
    super.buildCounter,
    super.scrollController,
    super.scrollPhysics,
    super.autofillHints,
    super.contentInsertionConfiguration,
    super.clipBehavior,
    super.restorationId,
    super.scribbleEnabled,
    super.enableIMEPersonalizedLearning,
    super.contextMenuBuilder,
    super.canRequestFocus,
    super.spellCheckConfiguration,
    super.magnifierConfiguration,
  }) : super(
          hintText: hintText ?? '请输入',
          displayTextMapper: (context, value) => value,
          keyboardType: keyboardType ?? TextInputType.visiblePassword,
        );

  /// 是否允许切换
  final bool? switchEnabled;

  @override
  TxCommonTextFieldState<String> createState() => _TxPasswordFieldState();
}

class _TxPasswordFieldState extends TxCommonTextFieldState<String> {
  @override
  TxPasswordField get widget => super.widget as TxPasswordField;

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
