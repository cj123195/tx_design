import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../localizations.dart';
import 'bottom_sheet.dart';
import 'checkbox_list_tile.dart';
import 'matching_text.dart';
import 'picker.dart';

export 'picker.dart'
    show ValueMapper, DataWidgetBuilder, EqualityMatcher, FilterMatcher;

/// 多选项构造方法
typedef MultiPickerItemBuilder<T> = Widget Function(
  BuildContext context,
  T data,
  bool checked,
  void Function(bool? val)? onChanged,
);

/// 多选组件操作栏构造方法
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

class _MultiPickerSelectedSheetState<T>
    extends State<MultiPickerSelectedSheet<T>> {
  late final List<T> _selectedData;

  void _removeSelectedItem(int index) {
    setState(() {
      _selectedData.removeAt(index);
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedData = List<T>.from(widget.selectedData);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final Widget topBar = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '已选择：${_selectedData.length}',
          style: theme.textTheme.titleMedium,
        ),
        const CloseButton(),
      ],
    );

    final Widget content = _selectedData.isEmpty
        ? Center(
            child: Text(
              '暂无选择项',
              style: theme.textTheme.labelMedium,
            ),
          )
        : Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
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
                      backgroundColor: theme.colorScheme.primaryContainer,
                    ),
                  ),
          );

    final Widget bottomBar = Row(
      children: [
        TextButton(
          onPressed: _selectedData.isEmpty
              ? null
              : () => setState(() => _selectedData.clear()),
          child: const Text('清空'),
        ),
        Expanded(
          child: FilledButton(
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
        children: [
          topBar,
          Expanded(child: SingleChildScrollView(child: content)),
          bottomBar,
        ],
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
abstract class TxMultiPickerBase<T> extends TxPickerBase<T, List<T>> {
  const TxMultiPickerBase({
    required super.source,
    required super.labelMapper,
    this.itemBuilder,
    this.subtitleBuilder,
    this.maxCount,
    this.actionBarBuilder,
    this.selectedItemBuilder,
    this.secondaryBuilder,
    super.onChanged,
    super.disabledWhen,
    super.initialData,
    super.placeholder,
    super.showSearchField,
    super.filterMatcher,
    super.listTileTheme,
    super.equalityMatcher,
    super.key,
  });

  /// 选择项构造器
  final MultiPickerItemBuilder<T>? itemBuilder;

  /// 副标题
  final DataWidgetBuilder<T>? subtitleBuilder;

  /// 最大选择个数
  final int? maxCount;

  /// 操作栏构造器
  final MultiPickerActionBarBuilder<T>? actionBarBuilder;

  /// 已选择项构造器
  final MultiPickerSelectedItemBuilder<T>? selectedItemBuilder;

  /// [CheckboxListTile.secondary] 构造方法
  final DataWidgetBuilder<T>? secondaryBuilder;

  @override
  TxMultiPickerBaseState<T> createState();
}

abstract class TxMultiPickerBaseState<T> extends TxPickerBaseState<T, List<T>> {
  late List<T> selectedData;

  @override
  TxMultiPickerBase<T> get widget => super.widget as TxMultiPickerBase<T>;

  /// 全选（由子类实现以支持不同的数据结构）
  void onSelectAll(List<T> data);

  /// 选项变更回调
  void onItemChanged(bool? value, T data) {
    setState(() {
      if (value == true) {
        if (!selectedData.any((e) => isEquals(e, data))) {
          selectedData.add(data);
        }
      } else {
        selectedData.removeWhere((e) => isEquals(e, data));
      }
    });
    widget.onChanged?.call(selectedData);
  }

  /// 展示已选择的数据
  Future<void> _showSelectedData() async {
    final res = await showTxModalBottomSheet<List<T>>(
      context,
      builder: (context) => MultiPickerSelectedSheet<T>(
        selectedData: selectedData,
        labelMapper: widget.labelMapper,
        itemBuilder: widget.selectedItemBuilder,
      ),
      isScrollControlled: true,
    );
    if (res != null) {
      setState(() => selectedData = res);
      widget.onChanged?.call(selectedData);
    }
  }

  /// 判断传入数据是否可操作
  bool isEnabled(T data, bool selected) {
    if (widget.disabledWhen != null && widget.disabledWhen!(data)) {
      return false;
    }
    if (widget.maxCount != null) {
      return selectedData.length < widget.maxCount! || selected;
    }
    return true;
  }

  /// 构建默认多选列表项
  Widget buildPickerItem(T data) {
    final bool checked = selectedData.any((e) => isEquals(e, data));
    final bool enabled = isEnabled(data, checked);

    if (widget.itemBuilder != null) {
      return widget.itemBuilder!(
        context,
        data,
        checked,
        enabled ? (val) => onItemChanged(val, data) : null,
      );
    }

    final Widget? subtitle = widget.subtitleBuilder != null
        ? widget.subtitleBuilder!(context, data)
        : null;

    final Widget? secondary = widget.secondaryBuilder != null
        ? widget.secondaryBuilder!(context, data)
        : null;

    return TxCheckboxListTile(
      title: TxMatchingText(widget.labelMapper(data) ?? '', query: query),
      value: checked,
      subtitle: subtitle,
      secondary: secondary,
      enabled: enabled,
      onChanged: (val) => onItemChanged(val, data),
      dense: true,
    );
  }

  @override
  void initState() {
    selectedData = List<T>.from(widget.initialData ?? []);
    super.initState();
  }

  @override
  Widget? buildActionBar(List<T> data) {
    if (widget.actionBarBuilder != null) {
      return widget.actionBarBuilder!(
        context,
        selectedData,
        () => onSelectAll(data),
        (updated) => setState(() => selectedData = updated),
      );
    }

    return MultiPickerActionBar(
      maxCount: widget.maxCount,
      selectedCount: selectedData.length,
      onSelectAll: () => onSelectAll(data),
      onClearAll: () {
        setState(() => selectedData.clear());
        widget.onChanged?.call(null);
      },
      onShowSelectedData: _showSelectedData,
    );
  }
}

/// 多选选择器
class TxMultiPicker<T> extends TxMultiPickerBase<T> {
  const TxMultiPicker({
    required super.labelMapper,
    required super.source,
    super.onChanged,
    super.disabledWhen,
    super.subtitleBuilder,
    super.initialData,
    super.placeholder,
    super.showSearchField,
    super.filterMatcher,
    super.itemBuilder,
    super.secondaryBuilder,
    super.maxCount,
    super.actionBarBuilder,
    super.selectedItemBuilder,
    super.equalityMatcher,
    super.listTileTheme,
    super.key,
  });

  @override
  TxMultiPickerBaseState<T> createState() => _TxMultiPickerState<T>();
}

class _TxMultiPickerState<T> extends TxMultiPickerBaseState<T> {
  @override
  TxMultiPicker<T> get widget => super.widget as TxMultiPicker<T>;

  @override
  Widget buildPickerContent(List<T> data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) => buildPickerItem(data[index]),
    );
  }

  @override
  void onSelectAll(List<T> data) {
    setState(() {
      selectedData.clear();
      final maxCount = widget.maxCount ?? data.length;
      selectedData.addAll(data.take(math.min(maxCount, data.length)));
    });
    widget.onChanged?.call(selectedData);
  }
}

/// 多选 BottomSheet
///
/// 点击取消将返回 null，可据此判断用户是否取消选择。
Future<List<T>?> showMultiPickerBottomSheet<T>(
  BuildContext context, {
  required List<T> source,
  required ValueMapper<T, String?> labelMapper,
  String? title,
  List<T>? initialData,
  DataWidgetBuilder<T>? subtitleBuilder,
  MultiPickerItemBuilder<T>? itemBuilder,
  DataWidgetBuilder<T>? secondaryBuilder,
  MultiPickerActionBarBuilder<T>? actionBarBuilder,
  MultiPickerSelectedItemBuilder<T>? selectedItemBuilder,
  EqualityMatcher<T>? equalityMatcher,
  bool Function(T data, String query)? filterMatcher,
  bool? isScrollControlled,
  int? maxCount,
  ValueMapper<T, bool>? disabledWhen,
  bool? showSearchField,
  Widget? placeholder,
  ListTileThemeData? listTileTheme,
}) async {
  isScrollControlled ??= true;
  List<T> data = List<T>.from(initialData ?? []);

  final Widget content = TxMultiPicker<T>(
    labelMapper: labelMapper,
    source: source,
    onChanged: (val) => data = val ?? [],
    subtitleBuilder: subtitleBuilder,
    itemBuilder: itemBuilder,
    secondaryBuilder: secondaryBuilder,
    initialData: data,
    maxCount: maxCount,
    disabledWhen: disabledWhen,
    showSearchField: showSearchField,
    filterMatcher: filterMatcher,
    placeholder: placeholder,
    actionBarBuilder: actionBarBuilder,
    selectedItemBuilder: selectedItemBuilder,
    equalityMatcher: equalityMatcher,
    listTileTheme: listTileTheme,
  );

  return showDefaultBottomSheet<List<T>>(
    context,
    title: title ?? TxLocalizations.of(context).pickerTitle,
    contentBuilder: (context) => content,
    onConfirm: () => Navigator.pop(context, data),
    isScrollControlled: isScrollControlled,
    contentPadding: EdgeInsets.zero,
  );
}
