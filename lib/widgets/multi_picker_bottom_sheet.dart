import 'package:flutter/material.dart';

import '../localizations.dart';
import '../utils/basic_types.dart';
import 'bottom_sheet.dart';

/// 标签编辑回调
typedef LabelEditCallback = void Function(int index, String value);

/// 多选项构造方法
typedef MultiPickerItemBuilder<T> = Widget Function(
  BuildContext context,
  T data,
  bool checked,
  void Function(bool? val, T data) onChanged,
);

/// 多选选择容器
class _MultiSelectContent<T, V> extends StatefulWidget {
  const _MultiSelectContent({
    required this.labelMapper,
    required this.valueMapper,
    required this.onChanged,
    required this.sources,
    Key? key,
    this.editableMapper,
    this.editableItemMapper,
    this.subtitleMapper,
    this.pickerItemBuilder,
    this.initialData,
    this.max,
    this.onLabelChanged,
  }) : super(key: key);

  /// 标题
  final ValueMapper<T, String> labelMapper;

  /// 值
  final ValueMapper<T, V> valueMapper;

  /// 副标题
  final ValueMapper<T, String>? subtitleMapper;

  /// 是否可编辑
  final ValueMapper<T, bool>? editableMapper;

  /// 编辑后数据
  final ValueMapper<String, T>? editableItemMapper;

  /// 标题编辑回调
  final LabelEditCallback? onLabelChanged;

  /// 数据源
  final List<T> sources;

  /// 选择项构造方法
  final MultiPickerItemBuilder<T>? pickerItemBuilder;

  /// 选择回调
  final ValueChanged<List<V>> onChanged;

  /// 初始值
  final List<V>? initialData;

  /// 最大选择个数
  final int? max;

  @override
  State<_MultiSelectContent> createState() => _MultiSelectContentState<T, V>();
}

class _MultiSelectContentState<T, V> extends State<_MultiSelectContent<T, V>> {
  late List<V> initialData;
  late List<T> source;

  @override
  void initState() {
    initialData = widget.initialData ?? [];
    source = [...widget.sources];
    super.initState();
  }

  void _onChanged(bool? value, T data) {
    if (value == true) {
      initialData.add(widget.valueMapper(data));
    } else {
      initialData.remove(widget.valueMapper(data));
    }
    widget.onChanged.call(initialData);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (widget.pickerItemBuilder != null) {
      return ListView.builder(
        itemBuilder: (context, index) => widget.pickerItemBuilder!(
          context,
          source[index],
          initialData.contains(widget.valueMapper(source[index])),
          _onChanged,
        ),
        itemCount: source.length,
      );
    }

    final List<Widget> tiles = List.generate(source.length, (index) {
      final T data = source[index];

      final int i =
          initialData.indexWhere((e) => e == widget.valueMapper(data));
      final bool value = i != -1;
      final bool enable =
          widget.max == null || initialData.length < widget.max! || value;

      Widget title;
      if (widget.editableMapper?.call(data) == true && value) {
        title = TextFormField(
          onChanged: (val) {
            if (widget.editableItemMapper != null) {
              source[index] = widget.editableItemMapper!(val);
              final V data = widget.valueMapper(source[index]);
              if (data != initialData[i]) {
                initialData[i] = data;
                widget.onChanged.call(initialData);
              }
            }
            widget.onLabelChanged?.call(index, val);
          },
          initialValue: widget.labelMapper(data),
        );
      } else {
        title = Text(widget.labelMapper(data));
      }

      return CheckboxListTile(
        title: title,
        value: value,
        subtitle: widget.subtitleMapper == null
            ? null
            : Text(widget.subtitleMapper!(data)),
        enabled: enable,
        onChanged: (val) => _onChanged(val, data),
      );
    });
    if (widget.max == null || source.length < widget.max!) {
      final Widget all = CheckboxListTile(
        title: Text(MaterialLocalizations.of(context).selectAllButtonLabel),
        value: source.every((e) => initialData.contains(widget.valueMapper(e))),
        onChanged: (val) {
          if (val == true) {
            initialData = source.map<V>((e) => widget.valueMapper(e)).toList();
          } else {
            initialData.clear();
          }
          widget.onChanged.call(initialData);
          setState(() {});
        },
      );
      tiles.insert(0, all);
    }

    return ListView.separated(
      itemBuilder: (context, index) => tiles[index],
      separatorBuilder: (context, index) => const Divider(height: 0),
      itemCount: tiles.length,
    );
  }
}

/// 多选选择
Future<List<V>?> showMultiPickerBottomSheet<T, V>(
  BuildContext context, {
  required List<T> sources,
  required ValueMapper<T, String> labelMapper,
  String? title,
  List<V>? initialValue,
  ValueMapper<T, V>? valueMapper,
  ValueMapper<T, String>? subtitleMapper,
  MultiPickerItemBuilder<T>? pickerItemBuilder,
  bool? isScrollControlled,
  int? max,
  ValueMapper<T, bool>? editableMapper,
  ValueMapper<String, T>? editableItemMapper,
  LabelEditCallback? onLabelChanged,
}) async {
  valueMapper ??= (T data) => data as V;
  isScrollControlled ??= sources.length > 10;
  List<V>? data = initialValue == null ? null : [...initialValue];
  final Widget content = _MultiSelectContent<T, V>(
    valueMapper: valueMapper,
    labelMapper: labelMapper,
    sources: sources,
    onChanged: (val) => data = val,
    subtitleMapper: subtitleMapper,
    pickerItemBuilder: pickerItemBuilder,
    editableMapper: editableMapper,
    editableItemMapper: editableItemMapper,
    onLabelChanged: onLabelChanged,
    initialData: data,
    max: max,
  );
  return await showDefaultBottomSheet<List<V>>(
    context,
    title: title ?? TxLocalizations.of(context).pickerTitle,
    content: content,
    onConfirm: () => Navigator.pop(context, data),
    isScrollControlled: isScrollControlled,
  );
}
