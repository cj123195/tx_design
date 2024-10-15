import '../extensions/datetime_extension.dart';
import '../widgets/date_picker.dart';
import 'field_tile.dart';
import 'picker_field.dart';

const String _defaultFormat = 'yyyy-MM';

/// 月份选择框
class TxMonthPickerField extends TxPickerField<DateTime, String> {
  TxMonthPickerField({
    super.key,
    super.focusNode,
    super.decoration,
    super.onChanged,
    super.enabled,
    super.hintText,
    super.textAlign,
    String? initialMonthStr,
    DateTime? initialMonth,
    DateTime? minimumMonth,
    DateTime? maximumMonth,
    int? minimumYear,
    int? maximumYear,
    String? format,
    String? titleText,
    super.controller,
    super.undoController,
    super.keyboardType,
    super.textInputAction,
    super.textCapitalization,
    super.style,
    super.strutStyle,
    super.textAlignVertical,
    super.textDirection,
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
  }) : super.custom(
          initialValue: initialMonth ??
              (initialMonthStr == null
                  ? null
                  : DateTime.tryParse(initialMonthStr)),
          onPickTap: (context, month) => showCupertinoMonthPicker(
            context,
            initialMonth: month,
            titleText: titleText,
            minimumMonth: minimumMonth,
            maximumMonth: maximumMonth,
            minimumYear: minimumYear,
            maximumYear: maximumYear,
          ),
          displayTextMapper: (context, month) =>
              month.format(format ?? _defaultFormat),
        );
}

/// field 为月份选择框的 [TxFieldTile]
class TxMonthPickerFieldTile extends TxPickerFieldTile<DateTime, String> {
  TxMonthPickerFieldTile({
    super.key,
    super.focusNode,
    super.decoration,
    super.onChanged,
    super.enabled,
    super.hintText,
    super.textAlign,
    String? initialMonthStr,
    DateTime? initialMonth,
    DateTime? minimumMonth,
    DateTime? maximumMonth,
    int? minimumYear,
    int? maximumYear,
    String? format,
    String? titleText,
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
  }) : super.custom(
          initialValue: initialMonth ??
              (initialMonthStr == null
                  ? null
                  : DateTime.tryParse(initialMonthStr)),
          onPickTap: (context, month) => showCupertinoMonthPicker(
            context,
            initialMonth: month,
            titleText: titleText ?? labelText,
            minimumMonth: minimumMonth,
            maximumMonth: maximumMonth,
            minimumYear: minimumYear,
            maximumYear: maximumYear,
          ),
          displayTextMapper: (context, month) =>
              month.format(format ?? _defaultFormat),
        );
}
