import 'package:flutter/material.dart';

import '../localizations.dart';
import '../utils/basic_types.dart';
import '../widgets/multi_picker_bottom_sheet.dart';
import 'form_field.dart';

export '../utils/basic_types.dart' show ValueMapper;
export '../widgets/multi_picker_bottom_sheet.dart' show MultiPickerItemBuilder;

/// 多选Form组件
class MultiPickerFormField<T, V> extends TxTextFormFieldItem<Set<T>> {
  MultiPickerFormField({
    required List<T> sources,
    required ValueMapper<T, String> labelMapper,
    MultiPickerItemBuilder<T>? pickerItemBuilder,
    PickerFuture<Set<T>?>? onPickTap,
    ValueMapper<T, String>? subtitleMapper,
    super.dataMapper, // 根据输入文字生成对应实体
    bool inputEnabled = false,
    ValueMapper<T, V>? valueMapper,
    ValueMapper<T, bool>? enabledMapper,
    ValueMapper<T, bool>? inputEnabledMapper,
    int? minPickNumber,
    int? maxPickNumber,
    Set<V>? initialValue,
    Set<T>? initialData,
    super.key,
    super.onSaved,
    super.validator,
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
    super.controller,
    super.prefixIconMergeMode,
    super.suffixIconMergeMode,
    super.focusNode,
    super.decoration,
    super.keyboardType,
    super.textCapitalization,
    super.textInputAction,
    super.style,
    super.strutStyle,
    super.textDirection,
    super.textAlign,
    super.textAlignVertical,
    super.autofocus,
    bool readonly = false,
    super.maxLines,
    super.minLines,
    super.maxLength,
    super.onChanged,
    super.onEditingComplete,
    super.inputFormatters,
    super.showCursor,
    super.obscuringCharacter,
    super.obscureText,
    super.autocorrect,
    super.smartDashesType,
    super.smartQuotesType,
    super.enableSuggestions,
    super.maxLengthEnforcement,
    super.expands,
    super.onTapOutside,
    super.onFieldSubmitted,
    super.cursorWidth,
    super.cursorHeight,
    super.cursorRadius,
    super.cursorColor,
    super.keyboardAppearance,
    super.scrollPadding,
    super.enableInteractiveSelection,
    super.selectionControls,
    super.buildCounter,
    super.scrollPhysics,
    super.autofillHints,
    super.scrollController,
    super.enableIMEPersonalizedLearning,
    super.mouseCursor,
    super.contextMenuBuilder,
  })  : assert(minPickNumber == null || minPickNumber > 0),
        assert(!inputEnabled || dataMapper != null),
        assert(maxPickNumber == null || maxPickNumber > (minPickNumber ?? 0)),
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
            readonly: !inputEnabled,
            labelMapper: (value) => value.map((e) => labelMapper(e)).join(''),
            initialValue: initialData ??
                sources.where((e) {
                  final V value = (valueMapper?.call(e) ?? labelMapper(e)) as V;
                  return initialValue?.contains(value) == true;
                }).toSet(),
            defaultValidator: (context, value) {
              if (value == null) {
                return required
                    ? TxLocalizations.of(context).textFormFieldHint
                    : null;
              }
              if (minPickNumber != null && value.length < minPickNumber) {
                return TxLocalizations.of(context)
                    .minimumSelectableQuantityLimitLabel(minPickNumber);
              }
              if (maxPickNumber != null && value.length > maxPickNumber) {
                return TxLocalizations.of(context)
                    .maximumSelectableQuantityLimitLabel(maxPickNumber);
              }
              return null;
            },
            defaultDecorationBuilder: (field) {
              return InputDecoration(
                hintText: TxLocalizations.of(field.context).pickerFormFieldHint,
              );
            },
            builder: (FormFieldState<Set<T>> field) {
              if (field.value?.isNotEmpty != true) {
                return null;
              }

              void onChangedHandler(Set<T>? value) {
                field.didChange(value);
                if (onChanged != null) {
                  onChanged(value);
                }
              }

              final List<Widget> children = field.value!
                  .map(
                    (e) => _PickedRawChip(
                      labelMapper(e),
                      readonly
                          ? null
                          : () {
                              final Set<T> list = {...field.value!};
                              list.remove(e);
                              onChangedHandler(list);
                            },
                    ),
                  )
                  .toList();
              return Wrap(
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.start,
                runSpacing: 4.0,
                spacing: 4.0,
                children: children,
              );
            },
            actionsBuilder: (field) {
              if (readonly) {
                return actions;
              }
              void onChangedHandler(Set<T>? value) {
                field.didChange(value);
                if (onChanged != null) {
                  onChanged(value);
                }
              }

              Future<void> onTap() async {
                final FocusScopeNode currentFocus =
                    FocusScope.of(field.context);
                if (!currentFocus.hasPrimaryFocus &&
                    currentFocus.focusedChild != null) {
                  FocusManager.instance.primaryFocus?.unfocus();
                }
                final Set<T>? res = (await (onPickTap?.call(
                            field.context, field.value?.toSet()) ??
                        showMultiPickerBottomSheet<T, T>(
                          field.context,
                          title: labelText,
                          labelMapper: labelMapper,
                          sources: sources,
                          subtitleMapper: subtitleMapper,
                          valueMapper: (val) => val,
                          pickerItemBuilder: pickerItemBuilder,
                          initialValue: field.value?.toList(),
                          max: maxPickNumber,
                          editableMapper: inputEnabledMapper,
                        )))
                    ?.toSet();
                if (res == null) {
                  return;
                }
                if (res != field.value) {
                  onChangedHandler(res);
                }
              }

              final Widget suffixIcon = IconButton(
                onPressed: onTap,
                icon: const Icon(Icons.add),
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                style: const ButtonStyle(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              );
              return [...?actions, suffixIcon];
            });
}

/// 已选项Chip
class _PickedRawChip extends StatelessWidget {
  const _PickedRawChip(this.label, [this.onDeleteTap]);

  final String label;

  final VoidCallback? onDeleteTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final TextStyle? style =
        theme.primaryTextTheme.labelMedium?.copyWith(color: scheme.primary);

    return Tooltip(
      message: label,
      child: RawChip(
        label: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 0.0, maxWidth: 80.0),
          child: Text(label),
        ),
        backgroundColor: scheme.primaryContainer,
        deleteIcon:
            onDeleteTap == null ? null : const Icon(Icons.cancel, size: 18.0),
        visualDensity: VisualDensity.compact,
        deleteButtonTooltipMessage: '删除',
        deleteIconColor: scheme.primary,
        labelStyle: style,
        onDeleted: onDeleteTap,
      ),
    );
  }
}
