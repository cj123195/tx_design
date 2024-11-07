import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'common_text_field.dart';
import 'field.dart';

/// 密码输入框
class TxPasswordField extends TxCommonTextField<String> {
  TxPasswordField({
    this.switchEnabled,
    super.key,
    super.focusNode,
    super.decoration,
    super.onChanged,
    super.enabled,
    super.hintText,
    super.textAlign,
    super.controller,
    super.initialValue,
    super.undoController,
    super.keyboardType,
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
  })  : obscureText = obscureText ?? true,
        super.custom(
          displayTextMapper: (context, value) => value,
          builder: (field) {
            final state = field as _TxPasswordFieldState;

            void onTapOutsideHandler(PointerDownEvent event) {
              if (onTapOutside != null) {
                onTapOutside(event);
              }
              FocusScope.of(state.context).unfocus();
            }

            return TextField(
              controller: controller ?? state.controller,
              focusNode: focusNode,
              undoController: undoController,
              decoration: field.effectiveDecoration,
              keyboardType: keyboardType ?? TextInputType.visiblePassword,
              textInputAction: textInputAction,
              textCapitalization: textCapitalization ?? TextCapitalization.none,
              style: style,
              strutStyle: strutStyle,
              textAlign: textAlign ?? TextAlign.start,
              textAlignVertical: textAlignVertical,
              textDirection: textDirection,
              readOnly: readOnly ?? false,
              showCursor: showCursor,
              autofocus: autofocus ?? false,
              statesController: statesController,
              obscuringCharacter: obscuringCharacter ?? '•',
              obscureText: field.obscureText,
              autocorrect: autocorrect ?? true,
              smartDashesType: smartDashesType,
              smartQuotesType: smartQuotesType,
              enableSuggestions: enableSuggestions ?? true,
              maxLines: maxLines ?? (minLines != null ? null : 1),
              minLines: minLines,
              expands: expands ?? false,
              maxLength: maxLength,
              maxLengthEnforcement: maxLengthEnforcement,
              onChanged: field.didChange,
              onEditingComplete: onEditingComplete,
              onSubmitted: onSubmitted,
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
              onTap: onTap == null ? null : () => onTap(field),
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
              contextMenuBuilder: contextMenuBuilder,
              canRequestFocus: canRequestFocus ?? true,
              spellCheckConfiguration: spellCheckConfiguration,
              magnifierConfiguration: magnifierConfiguration,
            );
          },
        );

  /// 是否隐藏密码
  final bool obscureText;

  /// 是否允许切换
  final bool? switchEnabled;

  @override
  TxCommonTextFieldState<String> createState() => _TxPasswordFieldState();
}

class _TxPasswordFieldState extends TxCommonTextFieldState<String>
    with _ObscureMixin {
  @override
  TxPasswordField get widget => super.widget as TxPasswordField;

  @override
  void initState() {
    _obscureText = widget.obscureText;
    super.initState();
  }

  @override
  bool? get switchEnabled => widget.switchEnabled;
}

/// field 为密码输入框的 [TxCommonTextFieldTile]
class TxPasswordFieldTile extends TxCommonTextFieldTile<String> {
  TxPasswordFieldTile({
    this.switchEnabled,
    super.key,
    super.initialValue,
    super.focusNode,
    super.decoration,
    super.onChanged,
    super.hintText,
    super.textAlign,
    super.labelBuilder,
    super.labelText,
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
    super.controller,
    super.undoController,
    super.keyboardType,
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
  })  : obscureText = obscureText ?? true,
        super.custom(
          fieldBuilder: (field) {
            final state = field as _TxPasswordFieldTileState;

            void onTapOutsideHandler(PointerDownEvent event) {
              if (onTapOutside != null) {
                onTapOutside(event);
              }
              FocusScope.of(state.context).unfocus();
            }

            return TextField(
              controller: controller ?? state.controller,
              focusNode: focusNode,
              undoController: undoController,
              decoration: field.effectiveDecoration,
              keyboardType: keyboardType ?? TextInputType.visiblePassword,
              textInputAction: textInputAction,
              textCapitalization: textCapitalization ?? TextCapitalization.none,
              style: style,
              strutStyle: strutStyle,
              textAlign: textAlign ?? TextAlign.start,
              textAlignVertical: textAlignVertical,
              textDirection: textDirection,
              readOnly: readOnly ?? false,
              showCursor: showCursor,
              autofocus: autofocus ?? false,
              statesController: statesController,
              obscuringCharacter: obscuringCharacter ?? '•',
              obscureText: field.obscureText,
              autocorrect: autocorrect ?? true,
              smartDashesType: smartDashesType,
              smartQuotesType: smartQuotesType,
              enableSuggestions: enableSuggestions ?? true,
              maxLines: maxLines ?? (minLines != null ? null : 1),
              minLines: minLines,
              expands: expands ?? false,
              maxLength: maxLength,
              maxLengthEnforcement: maxLengthEnforcement,
              onChanged: field.didChange,
              onEditingComplete: onEditingComplete,
              onSubmitted: onSubmitted,
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
              onTap: onTap == null ? null : () => onTap(field),
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
              contextMenuBuilder: contextMenuBuilder,
              canRequestFocus: canRequestFocus ?? true,
              spellCheckConfiguration: spellCheckConfiguration,
              magnifierConfiguration: magnifierConfiguration,
            );
          },
          displayTextMapper: (context, value) => value,
        );

  /// 是否隐藏密码
  final bool obscureText;

  /// 是否允许切换
  final bool? switchEnabled;

  @override
  TxCommonTextFieldTileState<String> createState() =>
      _TxPasswordFieldTileState();
}

class _TxPasswordFieldTileState extends TxCommonTextFieldTileState<String>
    with _ObscureMixin {
  @override
  TxPasswordFieldTile get widget => super.widget as TxPasswordFieldTile;

  @override
  void initState() {
    _obscureText = widget.obscureText;
    super.initState();
  }

  @override
  bool? get switchEnabled => widget.switchEnabled;
}

mixin _ObscureMixin on TxFieldState<String> {
  late bool _obscureText;

  bool get obscureText => _obscureText;

  bool? get switchEnabled;

  void switchObscure() {
    setState(() {
      _obscureText = !obscureText;
    });
  }

  @override
  InputDecoration get effectiveDecoration {
    InputDecoration decoration = super.effectiveDecoration;
    if (switchEnabled != false) {
      final Widget switchButton = IconButton(
        onPressed: switchObscure,
        icon: Icon(obscureText
            ? Icons.visibility_outlined
            : Icons.visibility_off_outlined),
      );
      decoration = decoration.copyWith(
        suffixIcon: decoration.suffixIcon == null
            ? switchButton
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [decoration.suffixIcon!, switchButton],
              ),
      );
    }

    return decoration;
  }
}
