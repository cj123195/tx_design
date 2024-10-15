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
    super.key,
    this.enabledMapper,
    this.editableMapper,
    this.editableItemMapper,
    this.subtitleMapper,
    this.pickerItemBuilder,
    this.initialData,
    this.maxCount,
    this.minCount,
    this.onLabelChanged,
  });

  /// 标题
  final ValueMapper<T, String?> labelMapper;

  /// 值
  final ValueMapper<T, V> valueMapper;

  /// 副标题
  final ValueMapper<T, String>? subtitleMapper;

  /// 是否可操作
  final bool Function(int index, T data)? enabledMapper;

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
  final int? maxCount;

  /// 最小选择个数
  final int? minCount;

  @override
  State<_MultiSelectContent> createState() => _MultiSelectContentState<T, V>();
}

class _MultiSelectContentState<T, V> extends State<_MultiSelectContent<T, V>> {
  late List<V> _data;
  late List<T> source;

  @override
  void initState() {
    _data = widget.initialData ?? [];
    source = [...widget.sources];
    super.initState();
  }

  void _onChanged(bool? value, T data) {
    if (value == true) {
      _data.add(widget.valueMapper(data));
    } else {
      _data.remove(widget.valueMapper(data));
    }
    widget.onChanged.call(_data);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (widget.pickerItemBuilder != null) {
      return ListView.builder(
        itemBuilder: (context, index) => widget.pickerItemBuilder!(
          context,
          source[index],
          _data.contains(widget.valueMapper(source[index])),
          _onChanged,
        ),
        itemCount: source.length,
      );
    }

    final List<Widget> tiles = List.generate(source.length, (index) {
      final T data = source[index];

      final int i = _data.indexWhere((e) => e == widget.valueMapper(data));
      final bool value = i != -1;

      bool enable = true;
      if (widget.enabledMapper != null) {
        enable = enable && widget.enabledMapper!(index, data);
      }
      if (widget.maxCount != null) {
        enable = enable && (_data.length < widget.maxCount! || value);
      }
      if (widget.minCount != null) {
        enable = enable && (_data.length > widget.minCount! || !value);
      }

      Widget title;
      if (widget.editableMapper?.call(data) == true && value) {
        title = TextFormField(
          onChanged: (val) {
            if (widget.editableItemMapper != null) {
              source[index] = widget.editableItemMapper!(val);
              final V data = widget.valueMapper(source[index]);
              if (data != _data[i]) {
                _data[i] = data;
                widget.onChanged.call(_data);
              }
            }
            widget.onLabelChanged?.call(index, val);
          },
          initialValue: widget.labelMapper(data),
        );
      } else {
        title = Text(widget.labelMapper(data) ?? '');
      }

      return CheckboxListTile(
        title: title,
        value: value,
        subtitle: widget.subtitleMapper == null
            ? null
            : Text(widget.subtitleMapper!(data)),
        enabled: enable,
        onChanged: (val) => _onChanged(val, data),
        contentPadding: EdgeInsets.zero,
      );
    });
    if (widget.maxCount == null || source.length < widget.maxCount!) {
      final Widget all = CheckboxListTile(
        title: Text(MaterialLocalizations.of(context).selectAllButtonLabel),
        value: source.every((e) => _data.contains(widget.valueMapper(e))),
        onChanged: (val) {
          if (val == true) {
            _data = source.map<V>((e) => widget.valueMapper(e)).toList();
          } else {
            _data.clear();
          }
          widget.onChanged.call(_data);
          setState(() {});
        },
        contentPadding: EdgeInsets.zero,
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
///
/// 点击取消将返回 null，开发者可根据返回值是否为 null 判断用户是否取消选择。
Future<List<V>?> showMultiPickerBottomSheet<T, V>(
  BuildContext context, {
  required List<T> sources,
  required ValueMapper<T, String?> labelMapper,
  String? title,
  List<V>? initialValue,
  ValueMapper<T, V>? valueMapper,
  ValueMapper<T, String>? subtitleMapper,
  MultiPickerItemBuilder<T>? pickerItemBuilder,
  bool? isScrollControlled,
  int? maxCount,
  int? minCount,
  ValueMapper<T, bool>? editableMapper,
  ValueMapper<String, T>? editableItemMapper,
  LabelEditCallback? onLabelChanged,
  bool Function(int index, T data)? enabledMapper,
}) async {
  valueMapper ??= (T data) => data as V;
  isScrollControlled ??= sources.length > 10;
  List<V> data = [...?initialValue];
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
    maxCount: maxCount,
    enabledMapper: enabledMapper,
  );
  return await showDefaultBottomSheet<List<V>>(
    context,
    title: title ?? TxLocalizations.of(context).pickerTitle,
    contentBuilder: (context) => content,
    onConfirm: () => Navigator.pop(context, data),
    isScrollControlled: isScrollControlled,
  );
}
