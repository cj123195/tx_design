import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/basic_types.dart';
import '../widgets/multi_picker_bottom_sheet.dart';
import 'form_item_container.dart';

/// 多选Form组件
class MultiPickerFormField<T, V> extends FormField<Set<T>> {
  MultiPickerFormField({
    required this.sources,
    required this.labelMapper,
    ValueMapper<T, V>? valueMapper,
    ValueMapper<T, String>? subtitleMapper,
    ValueMapper<String?, T>? editableItemMapper, // 根据输入文字生成对应实体
    ValueMapper<T, bool>? editableMapper, // 判断该选项是否可编辑
    LabelEditCallback? onLabelChanged, // 输入标签值改变回调
    this.inputEnabled = false,

    /// FormItemContainer参数
    Widget? label,
    String? labelText,
    EdgeInsetsGeometry? labelPadding,
    Color? background,
    Axis? direction,

    /// Form参数
    Set<V>? initialValue,
    Set<T>? initialData,
    super.key,
    super.onSaved,
    super.restorationId,
    bool? enabled,
    AutovalidateMode? autovalidateMode,
    bool required = false,
    FormFieldValidator<Set<T>>? validator,
    int? minPickNumber, // 最小可选数量
    int? maxPickNumber, // 最大可选数量

    /// TextField参数
    FocusNode? focusNode,
    InputDecoration decoration = const InputDecoration(),
    MultiPickerItemBuilder<T>? pickerItemBuilder,
    ValueChanged<Set<T>?>? onChanged,
    bool readonly = false,
    TextInputType? keyboardType,
    PickerFuture<List<T>>? onPickTap,
    TextStyle? style,
    TextInputAction? textInputAction,
    StrutStyle? strutStyle,
    TextDirection? textDirection,
    TextAlign textAlign = TextAlign.start,
    TextAlignVertical? textAlignVertical,
    bool? autofocus = false,
    EditableTextContextMenuBuilder? contextMenuBuilder,
    TextCapitalization textCapitalization = TextCapitalization.none,
    int? maxLines,
    int? minLines,
    int? maxLength,
    VoidCallback? onTap,
    List<TextInputFormatter>? inputFormatters,
    bool enableSpeech = true,
  })  : assert(minPickNumber == null || minPickNumber > 0),
        assert(!inputEnabled || editableItemMapper != null),
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
          initialValue: initialData ??
              initialValue?.fold<Set<T>>(<T>{}, (list, value) {
                final int index = sources.indexWhere((source) =>
                    (valueMapper ?? labelMapper).call(source) == value);
                if (index != -1) {
                  list.add(sources[index]);
                } else if (value is String && editableItemMapper != null) {
                  list.add(editableItemMapper(value));
                }
                return list;
              }),
          validator: validator ??
              (required
                  ? (Set<T>? value) {
                      return value == null ? '请选择${labelText ?? ''}' : null;
                    }
                  : null),
          enabled: enabled ?? decoration.enabled,
          autovalidateMode: autovalidateMode ?? AutovalidateMode.disabled,
          builder: (FormFieldState<Set<T>> field) {
            final _MultiPickerFormFieldState<T, V> state =
                field as _MultiPickerFormFieldState<T, V>;

            Widget child;
            List<Widget>? actions;
            if (readonly) {
              final List<Widget>? children = state.value
                  ?.map((e) => _PickedRawChip(labelMapper(e)))
                  .toList();
              child = children == null
                  ? const SizedBox()
                  : Wrap(
                      alignment: WrapAlignment.start,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      runSpacing: 4.0,
                      spacing: 4.0,
                      children: children,
                    );
            } else {
              void onChangedHandler(Set<T>? value) {
                field.didChange(value);
                if (onChanged != null) {
                  onChanged(value);
                }
              }

              Future<void> onTap() async {
                final FocusScopeNode currentFocus =
                    FocusScope.of(state.context);
                if (!currentFocus.hasPrimaryFocus &&
                    currentFocus.focusedChild != null) {
                  FocusManager.instance.primaryFocus?.unfocus();
                }
                final Set<T>? res = (await (onPickTap?.call(
                            state.context, state.value?.toList()) ??
                        showMultiPickerBottomSheet<T, T>(
                          state.context,
                          title: labelText,
                          labelMapper: labelMapper,
                          sources: sources,
                          subtitleMapper: subtitleMapper,
                          valueMapper: (val) => val,
                          pickerItemBuilder: pickerItemBuilder,
                          initialValue: state.value?.toList(),
                          max: maxPickNumber,
                          editableMapper: editableMapper,
                          editableItemMapper: editableItemMapper,
                          onLabelChanged: onLabelChanged,
                        )))
                    ?.toSet();
                if (res == null) {
                  return;
                }
                if (res != state.value) {
                  onChangedHandler(res);
                }
              }

              VoidCallback? onAdd;
              String hintText;
              Widget suffixIcon;
              if (inputEnabled) {
                onAdd = () {
                  if (state._effectiveController!.text.isNotEmpty) {
                    final T source =
                        editableItemMapper!(state._effectiveController!.text);
                    onChangedHandler({...?state.value, source});
                    state.sources.add(source);
                    state._effectiveController!.clear();
                  }
                };
                hintText = '请输入';
                suffixIcon = TextButton(
                  onPressed: state._effectiveController!.text.isNotEmpty == true
                      ? onAdd
                      : null,
                  style: TextButton.styleFrom(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    visualDensity: VisualDensity.compact,
                  ),
                  child: const Text('确定'),
                );
                actions = [
                  IconButton(
                    onPressed: onTap,
                    icon: const Icon(Icons.add),
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    style: const ButtonStyle(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  )
                ];
              } else {
                hintText = '请选择';
                suffixIcon = const Icon(Icons.keyboard_arrow_right);
              }
              final InputDecoration effectiveDecoration =
                  FormItemContainer.createDecoration(
                state.context,
                decoration,
                hintText: hintText,
                errorText: state.errorText,
                suffixIcon: suffixIcon,
              );

              child = TextField(
                restorationId: restorationId,
                controller: state._effectiveController,
                focusNode: focusNode,
                decoration: effectiveDecoration,
                keyboardType: keyboardType,
                textInputAction: textInputAction,
                style: style,
                strutStyle: strutStyle,
                textAlign: textAlign,
                textAlignVertical: textAlignVertical,
                textDirection: textDirection,
                textCapitalization: textCapitalization,
                autofocus: autofocus ?? false,
                contextMenuBuilder: contextMenuBuilder,
                readOnly: !inputEnabled,
                maxLines: maxLines,
                minLines: minLines,
                maxLength: maxLength,
                onTap: (readonly || inputEnabled) ? null : onTap,
                onEditingComplete: onAdd,
                inputFormatters: inputFormatters,
                enabled: enabled ?? decoration.enabled,
              );
              if (state.value?.isNotEmpty == true) {
                final List<Widget> children = state.value!
                    .map((e) => _PickedRawChip(labelMapper(e), () {
                          state.value!.remove(e);
                          onChangedHandler(state.value);
                        }))
                    .toList();
                child = Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    child,
                    Wrap(
                      alignment: WrapAlignment.start,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      runSpacing: 4.0,
                      spacing: 4.0,
                      children: children,
                    ),
                  ],
                );
              }
            }

            return UnmanagedRestorationScope(
              bucket: field.bucket,
              child: FormItemContainer(
                label: label,
                labelText: labelText,
                required: required,
                direction: direction ?? Axis.vertical,
                background: background,
                padding: labelPadding,
                formField: child,
                actions: actions,
              ),
            );
          },
        );

  /// 数据源
  final List<T> sources;

  /// 是否允许输入
  final bool inputEnabled;

  /// 描述选择项的文本。
  final ValueMapper<T, String> labelMapper;

  @override
  FormFieldState<Set<T>> createState() => _MultiPickerFormFieldState<T, V>();
}

class _MultiPickerFormFieldState<T, V> extends FormFieldState<Set<T>> {
  late Set<T> sources;
  RestorableTextEditingController? _controller;

  TextEditingController? get _effectiveController => _controller?.value;

  @override
  MultiPickerFormField<T, V> get widget =>
      super.widget as MultiPickerFormField<T, V>;

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

  void _createLocalController() {
    assert(_controller == null);
    _controller = RestorableTextEditingController();
    if (!restorePending) {
      _registerController();
    }
  }

  @override
  void initState() {
    super.initState();
    sources = widget.sources.toSet();
    if (widget.inputEnabled) {
      _createLocalController();
    }
  }

  @override
  void didUpdateWidget(MultiPickerFormField<T, V> oldWidget) {
    super.didUpdateWidget(oldWidget);
    sources = {...sources, ...widget.sources.toSet()};
    if (widget.initialValue != value) {
      setValue(widget.initialValue);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
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
