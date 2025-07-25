import 'dart:math' as math;

import 'package:flutter/material.dart';

// import '../form/multi_picker_form_field.dart';
import '../form/multi_picker_form_field.dart';
import '../localizations.dart';
import 'bottom_sheet.dart';
import 'checkbox_list_tile.dart';
import 'matching_text.dart';
import 'picker.dart';

export 'picker.dart' show ValueMapper, DataWidgetBuilder;

/// 多选项构造方法
typedef MultiPickerItemBuilder<T> = Widget Function(
  BuildContext context,
  T data,
  bool checked,
  void Function(bool? val)? onChanged,
);

/// 多选组件操作栏构造放
typedef MultiPickerActionBarBuilder<T> = Widget Function(
  BuildContext context,
  List<T> selectedItems,
  VoidCallback onSelectAll,
  ValueChanged<List<T>> updateSelectedData,
);

/// 多选组件已选择项构造组件
typedef MultiPickerSelectedItemBuilder<T> = Widget Function(
  BuildContext context,
  int index,
  T data,
  VoidCallback onRemove,
);

/// 多选组件已选择的数据容器
class MultiPickerSelectedSheet<T> extends StatefulWidget {
  const MultiPickerSelectedSheet({
    required this.selectedData,
    required this.labelMapper,
    this.itemBuilder,
    super.key,
  });

  final List<T> selectedData;
  final ValueMapper<T, String?> labelMapper;
  final MultiPickerSelectedItemBuilder<T>? itemBuilder;

  @override
  State<MultiPickerSelectedSheet<T>> createState() =>
      _MultiPickerSelectedSheetState<T>();
}

class _MultiPickerSelectedSheetState<D>
    extends State<MultiPickerSelectedSheet<D>> {
  late final List<D> _selectedData;

  void _removeSelectedItem(int index) {
    setState(() {
      _selectedData.removeAt(index);
    });
  }

  @override
  void initState() {
    _selectedData = widget.selectedData;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // 顶部操作栏
    final Widget topBar = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '已选择：${_selectedData.length}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const CloseButton(),
      ],
    );

    final Widget content = _selectedData.isEmpty
        ? Center(
            child: Text(
              '暂无选择项',
              style: Theme.of(context).textTheme.labelMedium,
            ),
          )
        : Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            alignment: WrapAlignment.start,
            runAlignment: WrapAlignment.start,
            children: widget.itemBuilder != null
                ? List.generate(
                    _selectedData.length,
                    (index) => widget.itemBuilder!(
                      context,
                      index,
                      _selectedData[index],
                      () => _removeSelectedItem(index),
                    ),
                  )
                : List.generate(
                    _selectedData.length,
                    (index) => Chip(
                      label: Text(
                        widget.labelMapper(_selectedData[index]) ?? '',
                      ),
                      onDeleted: () => _removeSelectedItem(index),
                      deleteIcon: const Icon(Icons.close, size: 18),
                      side: const BorderSide(color: Colors.transparent),
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer,
                    ),
                  ),
          );

    /// 底部操作栏
    final Widget bottomBar = Row(
      children: [
        TextButton(
          onPressed: _selectedData.isEmpty
              ? null
              : () {
                  setState(() {
                    _selectedData.clear();
                  });
                },
          child: const Text('清空'),
        ),
        Expanded(
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context, _selectedData),
            child: const Text('确定'),
          ),
        ),
      ],
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [topBar, Expanded(child: content), bottomBar],
      ),
    );
  }
}

/// 多选组件操作栏
class MultiPickerActionBar extends StatelessWidget {
  const MultiPickerActionBar({
    required this.selectedCount,
    required this.onSelectAll,
    required this.onClearAll,
    required this.onShowSelectedData,
    this.maxCount,
    super.key,
  });

  final int selectedCount;
  final int? maxCount;
  final VoidCallback onSelectAll;
  final VoidCallback onClearAll;
  final VoidCallback onShowSelectedData;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Row(
        children: [
          TextButton.icon(
            onPressed: selectedCount == 0 ? null : onShowSelectedData,
            icon: Text(
              '已选择: $selectedCount${maxCount != null ? '/$maxCount' : ''}',
            ),
            label: const Icon(Icons.keyboard_arrow_up),
          ),
          const Spacer(),
          TextButton(
            onPressed: selectedCount == 0 ? null : onClearAll,
            child: const Text('清空'),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: maxCount != null && selectedCount >= maxCount!
                ? null
                : onSelectAll,
            child: const Text('全选'),
          ),
        ],
      ),
    );
  }
}

/// 多选组件基础封装
abstract class TxMultiPickerBase<T, V> extends TxPickerBase<T, List<T>, V> {
  TxMultiPickerBase({
    required super.source,
    required super.labelMapper,
    this.itemBuilder,
    this.maxCount,
    this.actionBarBuilder,
    this.selectedItemBuilder,
    super.onChanged,
    super.disabledWhen,
    super.subtitleBuilder,
    super.valueMapper,
    super.initialData,
    super.placeholder,
    super.showSearchField,
    super.listTileTheme,
    super.key,
  });

  /// 选择项构造器
  final MultiPickerItemBuilder<T>? itemBuilder;

  /// 最大选择个数
  final int? maxCount;

  /// 操作栏构造器
  final MultiPickerActionBarBuilder<T>? actionBarBuilder;

  /// 已选择项构造器
  final MultiPickerSelectedItemBuilder<T>? selectedItemBuilder;

  @override
  TxMultiPickerBaseState<T, V> createState();
}

abstract class TxMultiPickerBaseState<T, V>
    extends TxPickerBaseState<T, List<T>, V> {
  late List<T> selectedData;

  @override
  TxMultiPickerBase<T, V> get widget => super.widget as TxMultiPickerBase<T, V>;

  /// 全选
  void onSelectAll(List<T> data);

  /// 选项变更回调
  void onChanged(bool? value, T data) {
    if (value == true) {
      selectedData.add(data);
    } else {
      selectedData.remove(data);
    }
    widget.onChanged?.call(selectedData);
    setState(() {});
  }

  /// 展示已选择的数据
  Future<void> _showSelectedData() async {
    final res = await showModalBottomSheet(
      context: context,
      builder: (context) => MultiPickerSelectedSheet<T>(
        selectedData: selectedData,
        labelMapper: widget.labelMapper,
      ),
    );
    if (res != null) {
      setState(() {
        selectedData = res;
      });
    }
  }

  /// 两个数据是否相等
  bool isEquals(T data1, T data2) {
    return widget.valueMapper(data1) == widget.valueMapper(data2);
  }

  /// 判断传入数据是否可操作
  bool isEnabled(T data, bool selected) {
    bool enabled = true;
    if (widget.disabledWhen != null) {
      enabled = !widget.disabledWhen!(data);
    }
    if (widget.maxCount != null) {
      enabled = enabled && (selectedData.length < widget.maxCount! || selected);
    }
    return enabled;
  }

  /// 构建选择项
  Widget buildPickerItem(T data) {
    final int i = selectedData.indexWhere((e) => isEquals(e, data));
    final bool value = i != -1;

    final bool enabled = isEnabled(data, value);

    return TxCheckboxListTile(
      title: TxMatchingText(
        widget.labelMapper(data) ?? '',
        query: controller?.text,
      ),
      value: value,
      subtitle: widget.subtitleBuilder == null
          ? null
          : widget.subtitleBuilder!(context, data),
      controlAffinity: ListTileControlAffinity.leading,
      enabled: enabled,
      onChanged: (val) => onChanged(val, data),
      dense: true,
    );
  }

  @override
  void initState() {
    selectedData = [...?widget.initialData];
    super.initState();
  }

  @override
  Widget? buildActionBar(List<T> data) {
    if (widget.actionBarBuilder != null) {
      return widget.actionBarBuilder!(
        context,
        data,
        () => onSelectAll(data),
        (data) {
          setState(() {
            selectedData = data;
          });
        },
      );
    }

    return MultiPickerActionBar(
      maxCount: widget.maxCount,
      selectedCount: selectedData.length,
      onSelectAll: () => onSelectAll(data),
      onClearAll: () {
        setState(() {
          selectedData.clear();
        });
        widget.onChanged?.call(null);
      },
      onShowSelectedData: _showSelectedData,
    );
  }
}

/// 多选选择器
class TxMultiPicker<T, V> extends TxMultiPickerBase<T, V> {
  TxMultiPicker({
    required super.labelMapper,
    required super.source,
    super.onChanged,
    super.disabledWhen,
    super.subtitleBuilder,
    super.valueMapper,
    super.initialData,
    super.placeholder,
    super.showSearchField,
    super.itemBuilder,
    super.maxCount,
    super.actionBarBuilder,
    super.selectedItemBuilder,
    super.listTileTheme,
    super.key,
  });

  @override
  TxMultiPickerBaseState<T, V> createState() => _TxMultiPickerState<T, V>();
}

class _TxMultiPickerState<T, V> extends TxMultiPickerBaseState<T, V> {
  @override
  TxMultiPicker<T, V> get widget => super.widget as TxMultiPicker<T, V>;

  @override
  Widget buildPickerContent(List<T> data) {
    return ListView.builder(
      itemBuilder: (context, index) {
        final T d = data[index];
        final bool selected = selectedData.any((e) => isEquals(e, d));

        return widget.itemBuilder == null
            ? buildPickerItem(d)
            : widget.itemBuilder!(
                context,
                d,
                selected,
                (val) => onChanged(val, d),
              );
      },
      itemCount: data.length,
    );
  }

  @override
  List<T> filterData(String query) => widget.source
      .where((data) => widget.labelMapper(data)?.contains(query) == true)
      .toList();

  @override
  void onSelectAll(List<T> data) {
    selectedData.clear();

    final maxCount = widget.maxCount ?? data.length;
    final countToAdd = math.min(maxCount, data.length);

    selectedData.addAll(data.take(countToAdd));

    widget.onChanged?.call(selectedData);

    setState(() {});
  }
}

/// 多选选择
///
/// 点击取消将返回 null，开发者可根据返回值是否为 null 判断用户是否取消选择。
Future<List<T>?> showMultiPickerBottomSheet<T, V>(
  BuildContext context, {
  required List<T> source,
  required ValueMapper<T, String?> labelMapper,
  String? title,
  List<T>? initialData,
  List<V>? initialValue,
  ValueMapper<T, V?>? valueMapper,
  DataWidgetBuilder<T>? subtitleBuilder,
  MultiPickerItemBuilder<T>? itemBuilder,
  MultiPickerActionBarBuilder<T>? actionBarBuilder,
  MultiPickerSelectedItemBuilder<T>? selectedItemBuilder,
  bool? isScrollControlled,
  int? maxCount,
  ValueMapper<T, bool>? disabledWhen,
  bool? showSearchField,
  Widget? placeholder,
  ListTileThemeData? listTileTheme,
}) async {
  valueMapper ??= (T data) => data as V;
  isScrollControlled ??= true;
  List<T> data = TxMultiPickerFormField.initData(
        source,
        initialData,
        initialValue,
        valueMapper,
      ) ??
      [];
  final Widget content = TxMultiPicker<T, V>(
    valueMapper: valueMapper,
    labelMapper: labelMapper,
    source: source,
    onChanged: (val) => data = val ?? [],
    subtitleBuilder: subtitleBuilder,
    itemBuilder: itemBuilder,
    initialData: data,
    maxCount: maxCount,
    disabledWhen: disabledWhen,
    showSearchField: showSearchField,
    placeholder: placeholder,
    actionBarBuilder: actionBarBuilder,
    selectedItemBuilder: selectedItemBuilder,
    listTileTheme: listTileTheme,
  );
  return await showDefaultBottomSheet<List<T>>(
    context,
    title: title ?? TxLocalizations.of(context).pickerTitle,
    contentBuilder: (context) => content,
    onConfirm: () => Navigator.pop(context, data),
    isScrollControlled: isScrollControlled,
    contentPadding: EdgeInsets.zero,
  );
}
