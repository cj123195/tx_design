import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../extensions/iterable_extension.dart';
import 'bottom_sheet.dart';
import 'cascade_picker.dart';
import 'checkbox.dart';
import 'checkbox_list_tile.dart';
import 'matching_text.dart';
import 'multi_picker.dart';

export 'multi_picker.dart'
    show
        ValueMapper,
        DataWidgetBuilder,
        MultiPickerItemBuilder,
        MultiPickerActionBarBuilder,
        MultiPickerSelectedItemBuilder;

/// 多选级联选择器
class TxMultiCascadePicker<T, V> extends TxMultiPickerBase<T, V> {
  TxMultiCascadePicker({
    required super.source,
    required super.labelMapper,
    required super.valueMapper,
    required this.childrenMapper,
    required super.onChanged,
    super.initialData,
    super.disabledWhen,
    super.key,
    super.itemBuilder,
    super.listTileTheme,
    super.placeholder,
    super.maxCount,
    bool? linkage,
    super.actionBarBuilder,
    super.selectedItemBuilder,
    bool? parentCheckable,
    super.subtitleBuilder,
    super.showSearchField,
  })  : linkage = linkage ?? true,
        parentCheckable = parentCheckable ?? false;

  /// 通过给定非树型数据数组创建一个级联选择器
  TxMultiCascadePicker.fromMapList({
    required List<Map> source,
    ValueChanged<List<Map>?>? onChanged,
    String? valueKey,
    String? labelKey,
    String? idKey,
    String? pidKey,
    String? rootId,
    super.key,
    MultiPickerItemBuilder<Map>? itemBuilder,
    ValueMapper<Map, bool>? disabledWhen,
    List<Map>? initialData,
    super.maxCount,
    bool? linkage,
    MultiPickerActionBarBuilder<Map>? actionBarBuilder,
    MultiPickerSelectedItemBuilder<Map>? selectedItemBuilder,
    DataWidgetBuilder<Map>? subtitleBuilder,
    super.listTileTheme,
    super.placeholder,
    bool? parentCheckable,
    super.showSearchField,
  })  : linkage = linkage ?? true,
        parentCheckable = parentCheckable ?? false,
        childrenMapper = ((data) => ((data as Map)[kTreeChildrenKey] as List?)
            ?.cast<Map>() as List<T>?),
        super(
          source: source
              .toTree(
                idKey: idKey ?? kTreeIdKey,
                pidKey: pidKey ?? kTreePidKey,
                childrenKey: kTreeChildrenKey,
                rootId: rootId,
              )
              .toList() as List<T>,
          initialData: initialData as List<T>?,
          subtitleBuilder: subtitleBuilder as DataWidgetBuilder<T>?,
          itemBuilder: itemBuilder as MultiPickerItemBuilder<T>?,
          disabledWhen: disabledWhen as ValueMapper<T, bool>?,
          onChanged: onChanged as ValueChanged<List<T>?>?,
          actionBarBuilder: actionBarBuilder as MultiPickerActionBarBuilder<T>?,
          selectedItemBuilder:
              selectedItemBuilder as MultiPickerSelectedItemBuilder<T>?,
          labelMapper: (data) =>
              (data as Map)[labelKey ?? kLabelKey] as String?,
          valueMapper: (data) =>
              (data as Map)[valueKey ?? idKey ?? kTreeIdKey] as V,
        );

  /// 数据的子节点
  final ValueMapper<T, List<T>?> childrenMapper;

  /// 父节点是否可选
  final bool parentCheckable;

  /// 父节点是否与子节点关联
  ///
  /// 当值为 true 时，选中父节点也会同时选中子节点
  final bool linkage;

  @override
  TxMultiPickerBaseState<T, V> createState() =>
      _TxMultiCascadePickerState<T, V>();
}

class _TxMultiCascadePickerState<T, V> extends TxMultiPickerBaseState<T, V>
    with CascadePickerMixin<T, List<T>, V> {
  @override
  TxMultiCascadePicker<T, V> get widget =>
      super.widget as TxMultiCascadePicker<T, V>;

  @override
  void initState() {
    super.initState();

    // 根据选中数据自动展开路径
    for (final data in selectedData) {
      expandPathToSelected(data);
    }
  }

  @override
  bool isDataSelected(T data) {
    final children = widget.childrenMapper(data) ?? [];
    final bool hasChildren = children.isNotEmpty;

    if (hasChildren) {
      if (widget.parentCheckable) {
        // 父节点可选择的情况下，直接检查父节点是否在选中列表中
        final V? value = widget.valueMapper(data);
        return selectedData.any((item) => widget.valueMapper(item) == value);
      } else {
        // 父节点不可选择的情况下，检查所有子节点是否全部选中
        return _areAllChildrenSelected(data);
      }
    } else {
      // 叶子节点，直接检查是否在选中列表中
      final V? value = widget.valueMapper(data);
      return selectedData.any((item) => widget.valueMapper(item) == value);
    }
  }

  /// 检查所有子节点是否全部选中
  bool _areAllChildrenSelected(T parent) {
    final children = widget.childrenMapper(parent) ?? [];
    if (children.isEmpty) {
      return false;
    }

    for (final child in children) {
      final childChildren = widget.childrenMapper(child) ?? [];
      if (childChildren.isEmpty) {
        // 叶子节点，检查是否选中
        final childValue = widget.valueMapper(child);
        if (!selectedData
            .any((item) => widget.valueMapper(item) == childValue)) {
          return false;
        }
      } else {
        // 非叶子节点，递归检查
        if (!_areAllChildrenSelected(child)) {
          return false;
        }
      }
    }
    return true;
  }

  /// 获取父节点的选中状态（用于三态）
  bool? _getParentCheckState(T data) {
    final children = widget.childrenMapper(data) ?? [];
    if (children.isEmpty) {
      return null;
    }

    if (widget.parentCheckable) {
      // 父节点可选择的情况下，返回父节点的选中状态
      return isDataSelected(data);
    } else {
      // 父节点不可选择的情况下，返回三态状态
      final selectedChildren = children.where(isDataSelected).toList();
      if (selectedChildren.isEmpty) {
        return false;
      } else if (selectedChildren.length == children.length) {
        return true;
      } else {
        return null; // 部分选中
      }
    }
  }

  void onItemSelect(bool? select, T data) {
    final V? value = widget.valueMapper(data);
    final children = widget.childrenMapper(data) ?? [];
    final bool hasChildren = children.isNotEmpty;

    if (hasChildren) {
      if (widget.parentCheckable) {
        // 父节点可选择的情况
        if (select == true) {
          // 选中父节点
          if (!selectedData.any((item) => widget.valueMapper(item) == value)) {
            if (!_isMaxSelectedReached()) {
              selectedData.add(data);
            }
          }

          // 如果linkage为true，同时选中所有子节点
          if (widget.linkage) {
            _selectAllChildren(data);
          }
        } else {
          // 取消选中父节点
          selectedData.removeWhere((item) => widget.valueMapper(item) == value);

          // 如果linkage为true，同时取消选中所有子节点
          if (widget.linkage) {
            _deselectAllChildren(data);
          }
        }
      } else {
        // 父节点不可选择的情况
        if (select == true) {
          // 选中所有子节点
          _selectAllChildren(data);
        } else {
          // 取消选中所有子节点
          _deselectAllChildren(data);
        }
      }
    } else {
      // 叶子节点
      if (select == true) {
        if (!selectedData.any((item) => widget.valueMapper(item) == value)) {
          if (!_isMaxSelectedReached()) {
            selectedData.add(data);
          }
        }
      } else {
        selectedData.removeWhere((item) => widget.valueMapper(item) == value);
      }
    }

    if (widget.onChanged != null) {
      widget.onChanged!(List.from(selectedData));
    }

    setState(() {});
  }

  /// 选中所有子节点
  void _selectAllChildren(T parent) {
    final children = getAllChildren(parent);
    for (final child in children) {
      final childChildren = widget.childrenMapper(child) ?? [];
      final enabled =
          widget.disabledWhen == null ? true : !widget.disabledWhen!(child);

      if (enabled) {
        if (childChildren.isEmpty) {
          // 叶子节点，直接添加
          final childValue = widget.valueMapper(child);
          if (!selectedData
              .any((item) => widget.valueMapper(item) == childValue)) {
            if (!_isMaxSelectedReached()) {
              selectedData.add(child);
            }
          }
        } else if (widget.parentCheckable) {
          // 父节点可选择的情况下，也添加父节点
          final childValue = widget.valueMapper(child);
          if (!selectedData
              .any((item) => widget.valueMapper(item) == childValue)) {
            if (!_isMaxSelectedReached()) {
              selectedData.add(child);
            }
          }
        }
      }
    }
  }

  /// 取消选中所有子节点
  void _deselectAllChildren(T parent) {
    final children = getAllChildren(parent);
    for (final child in children) {
      final childValue = widget.valueMapper(child);
      selectedData
          .removeWhere((item) => widget.valueMapper(item) == childValue);
    }
  }

  /// 检查是否达到最大选择数量
  bool _isMaxSelectedReached() {
    return widget.maxCount != null && selectedData.length >= widget.maxCount!;
  }

  @override
  void onSelectAll(List<T> data) {
    final allNodes = getAllSelectableNodes();
    selectedData.clear();

    final maxCount = widget.maxCount ?? allNodes.length;
    final countToAdd = math.min(maxCount, allNodes.length);

    selectedData.addAll(allNodes.take(countToAdd));

    if (widget.onChanged != null) {
      widget.onChanged!(List.from(selectedData));
    }

    setState(() {});
  }

  void onClearAll() {
    selectedData.clear();

    if (widget.onChanged != null) {
      widget.onChanged!(List.from(selectedData));
    }

    setState(() {});
  }

  /// 重写构建单个节点的ExpansionTile方法，支持多选逻辑
  @override
  Widget buildExpansionTile(T data, {int level = 0}) {
    final V? nodeValue = widget.valueMapper(data);
    final String? label = widget.labelMapper(data);
    final List<T>? children = widget.childrenMapper(data);
    final bool hasChildren = children != null && children.isNotEmpty;
    final bool selected = isDataSelected(data);
    final bool enabled = isEnabled(data, selected);

    // 如果是叶子节点或者使用了自定义构建器
    if (!hasChildren || widget.itemBuilder != null) {
      if (widget.itemBuilder != null) {
        return widget.itemBuilder!(
          context,
          data,
          isDataSelected(data),
          enabled ? (select) => onItemSelect(select, data) : null,
        );
      }

      // 叶子节点直接显示为CheckboxListTile
      return Padding(
        padding: EdgeInsets.only(left: level * 16.0),
        child: TxCheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          value: isDataSelected(data),
          dense: true,
          title: TxMatchingText(label ?? '', query: controller?.text),
          onChanged: enabled ? (value) => onItemSelect(value, data) : null,
          selected: isDataSelected(data),
          enabled: enabled,
        ),
      );
    }

    // 父节点使用ExpansionTile，所有父节点都显示checkbox
    final bool? checkState = _getParentCheckState(data);

    return ExpansionTile(
      key: ValueKey(nodeValue),
      initiallyExpanded: isExpanded(nodeValue),
      onExpansionChanged: (expanded) => setExpanded(nodeValue, expanded),
      leading: TxCheckbox(
        value: checkState,
        tristate: !widget.parentCheckable, // 父节点不可选择时启用三态
        onChanged: (enabled || (!widget.parentCheckable && checkState == null))
            ? (value) => onItemSelect(value, data)
            : null,
      ),
      title: TxMatchingText(label ?? '', query: controller?.text),
      childrenPadding: const EdgeInsets.only(left: 16.0),
      tilePadding: const EdgeInsets.only(left: 4.0, right: 16.0),
      children: children
          .map((child) => buildExpansionTile(child, level: level + 1))
          .toList(),
    );
  }

  void removeSelectedItem(T data) {
    final V? value = widget.valueMapper(data);
    selectedData.removeWhere((item) => widget.valueMapper(item) == value);

    if (widget.onChanged != null) {
      widget.onChanged!(List.from(selectedData));
    }

    setState(() {});
  }

  @override
  Widget buildCascadePickerItem(T data) {
    // TODO: implement buildCascadePickerItem
    throw UnimplementedError();
  }

  @override
  Widget buildParentChecker(T data) {
    final bool? checkState = _getParentCheckState(data);

    final enabled = isEnabled(data, data == true);

    return TxCheckbox(
      value: checkState,
      tristate: !widget.parentCheckable,
      onChanged: enabled ? (value) => onItemSelect(value, data) : null,
    );
  }

  @override
  List<T>? getChildren(T parent) => widget.childrenMapper(parent);

  @override
  bool get parentCheckable => widget.parentCheckable;
}

/// 弹出多选级联选择器
Future<List<T>?> showMultiCascadePicker<T, V>({
  required BuildContext context,
  required List<T> source,
  required ValueMapper<T, String?> labelMapper,
  required ValueMapper<T, List<T>?> childrenMapper,
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
  bool? parentCheckable,
  bool? linkage,
  ListTileThemeData? listTileTheme,
}) async {
  List<T>? result = source.getInitialList<V>(
    initialValue: initialValue,
    initialData: initialData,
    valueMapper: valueMapper,
    childrenMapper: childrenMapper,
  );
  return showDefaultBottomSheet<List<T>>(
    context,
    title: title ?? '请选择部门',
    contentBuilder: (context) {
      return TxMultiCascadePicker<T, V>(
        source: source,
        labelMapper: labelMapper,
        valueMapper: valueMapper,
        childrenMapper: childrenMapper,
        initialData: initialData,
        itemBuilder: itemBuilder,
        listTileTheme: listTileTheme,
        placeholder: placeholder,
        parentCheckable: parentCheckable,
        onChanged: (val) {
          if (parentCheckable == true) {
            result = val;
          } else {
            result = val;
          }
        },
        maxCount: maxCount,
        linkage: linkage,
        actionBarBuilder: actionBarBuilder,
        selectedItemBuilder: selectedItemBuilder,
        disabledWhen: disabledWhen,
        subtitleBuilder: subtitleBuilder,
        showSearchField: showSearchField,
      );
    },
    onConfirm: () => Navigator.pop(context, result),
    actionsPosition: ActionsPosition.header,
    isScrollControlled: true,
    contentPadding: EdgeInsets.zero,
  );
}

/// 弹出数据为 Map 列表类型多选级联选择器
Future<List<Map>?> showMultiMapListCascadePicker<V>({
  required BuildContext context,
  required List<Map> source,
  String? valueKey,
  String? labelKey,
  String? idKey,
  String? pidKey,
  String? rootId,
  String? title,
  List<Map>? initialData,
  List<V>? initialValue,
  DataWidgetBuilder<Map>? subtitleBuilder,
  MultiPickerItemBuilder<Map>? itemBuilder,
  MultiPickerActionBarBuilder<Map>? actionBarBuilder,
  MultiPickerSelectedItemBuilder<Map>? selectedItemBuilder,
  bool? isScrollControlled,
  int? maxCount,
  ValueMapper<Map, bool>? disabledWhen,
  bool? showSearchField,
  Widget? placeholder,
  bool? parentCheckable,
  bool? linkage,
  ListTileThemeData? listTileTheme,
}) async {
  List<Map>? result = source.getInitialList<V>(
    initialValue: initialValue,
    initialData: initialData,
    valueMapper: (data) => data[valueKey ?? idKey],
  );
  return showDefaultBottomSheet<List<Map>>(
    context,
    title: title ?? '请选择',
    contentBuilder: (context) {
      return TxMultiCascadePicker<Map, V>.fromMapList(
        source: source,
        labelKey: labelKey,
        valueKey: valueKey,
        idKey: idKey,
        pidKey: pidKey,
        rootId: rootId,
        initialData: initialData,
        itemBuilder: itemBuilder,
        subtitleBuilder: subtitleBuilder,
        listTileTheme: listTileTheme,
        placeholder: placeholder,
        parentCheckable: parentCheckable,
        onChanged: (val) {
          if (parentCheckable == true) {
            result = val;
          } else {
            result = val;
          }
        },
        maxCount: maxCount,
        disabledWhen: disabledWhen,
        linkage: linkage,
        actionBarBuilder: actionBarBuilder,
        selectedItemBuilder: selectedItemBuilder,
        showSearchField: showSearchField,
      );
    },
    onConfirm: () => Navigator.pop(context, result),
    actionsPosition: ActionsPosition.header,
    isScrollControlled: true,
    contentPadding: EdgeInsets.zero,
  );
}
