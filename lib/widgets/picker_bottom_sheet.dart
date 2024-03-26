import 'package:flutter/material.dart';

import '../localizations.dart';
import '../utils/basic_types.dart';
import 'bottom_sheet.dart';

/// 选择项构造方法
typedef PickerItemBuilder<T> = Widget Function(
  BuildContext context,
  T data,
  bool checked,
  ValueChanged<T> onChanged,
);

/// 单选选择容器
class _PickerContent<T> extends StatefulWidget {
  const _PickerContent({
    required this.labelMapper,
    required this.onChanged,
    required this.sources,
    super.key,
    this.enabledMapper,
    this.inputEnabledMapper,
    this.dataMapper,
    this.subtitleMapper,
    this.pickerItemBuilder,
    this.initialData,
    bool? showSearchField,
  }) : showSearchField = showSearchField ?? sources.length > 30;

  final ValueMapper<T, String> labelMapper;
  final ValueMapper<T, String>? subtitleMapper;
  final ValueMapper<T, bool>? enabledMapper;
  final ValueMapper<T, bool>? inputEnabledMapper;
  final ValueMapper<T, bool>? dataMapper;
  final List<T> sources;
  final PickerItemBuilder<T>? pickerItemBuilder;
  final ValueChanged<T> onChanged;
  final T? initialData;
  final bool showSearchField;

  @override
  State<_PickerContent> createState() => _PickerContentState<T>();
}

class _PickerContentState<T> extends State<_PickerContent<T>> {
  late T? initialData;
  String? query;

  List<T> get _filterSource {
    if (query?.isNotEmpty == true) {
      return widget.sources
          .where((e) =>
              widget.labelMapper(e).contains(query!) ||
              widget.subtitleMapper?.call(e).contains(query!) == true)
          .toList();
    }
    return widget.sources;
  }

  @override
  void initState() {
    initialData = widget.initialData;
    super.initState();
  }

  void _onChanged(T data) {
    setState(() {
      initialData = data;
    });
    widget.onChanged.call(data);
  }

  @override
  Widget build(BuildContext context) {
    Widget result;
    if (widget.pickerItemBuilder != null) {
      result = ListView.builder(
        itemBuilder: (context, index) => widget.pickerItemBuilder!(
          context,
          _filterSource[index],
          initialData == _filterSource[index],
          _onChanged,
        ),
        itemCount: _filterSource.length,
      );
    } else {
      result = ListView.separated(
        itemBuilder: (context, index) => RadioListTile<T>(
          title: Text(widget.labelMapper(_filterSource[index])),
          value: _filterSource[index],
          groupValue: initialData,
          onChanged: widget.enabledMapper?.call(_filterSource[index]) == false
              ? null
              : (val) => _onChanged(_filterSource[index]),
        ),
        separatorBuilder: (context, index) => const Divider(height: 0),
        itemCount: _filterSource.length,
      );
    }
    if (widget.showSearchField == true) {
      result = Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: MaterialLocalizations.of(context).searchFieldLabel,
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (val) => setState(() => query = val),
            ),
          ),
          Expanded(child: result)
        ],
      );
    }
    return result;
  }
}

/// 单选选择
Future<T?> showPickerBottomSheet<T, V>(
  BuildContext context, {
  required List<T> sources,
  required ValueMapper<T, String> labelMapper,
  String? title,
  T? initialData,
  V? initialValue,
  ValueMapper<T, V>? valueMapper,
  ValueMapper<T, String>? subtitleMapper,
  ValueMapper<T, bool>? enabledMapper,
  ValueMapper<T, bool>? inputEnabledMapper,
  ValueMapper<T, bool>? dataMapper,
  PickerItemBuilder<T>? pickerItemBuilder,
  bool? isScrollControlled,
  bool? showSearchField,
}) async {
  valueMapper ??= labelMapper as ValueMapper<T, V>;
  isScrollControlled ??= sources.length > 10;
  T? data = initialData ??
      (initialValue == null
          ? null
          : sources.firstWhere((e) => valueMapper!(e) == initialValue));
  final Widget content = _PickerContent<T>(
    labelMapper: labelMapper,
    sources: sources,
    onChanged: (val) => data = val,
    subtitleMapper: subtitleMapper,
    pickerItemBuilder: pickerItemBuilder,
    initialData: data,
    enabledMapper: enabledMapper,
    dataMapper: dataMapper,
    inputEnabledMapper: inputEnabledMapper,
  );
  return await showDefaultBottomSheet<T>(
    context,
    title: title ?? TxLocalizations.of(context).pickerTitle,
    contentBuilder: (context) => content,
    onConfirm: () => Navigator.pop(context, data),
    isScrollControlled: isScrollControlled,
  );
}
