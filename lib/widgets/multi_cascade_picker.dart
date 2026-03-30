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
        EqualityMatcher,
        MultiPickerItemBuilder,
        MultiPickerActionBarBuilder,
        MultiPickerSelectedItemBuilder,
        FilterMatcher;

/// 多选级联选择器
class TxMultiCascadePicker<T> extends TxMultiPickerBase<T> {
  const TxMultiCascadePicker({
    required super.source,
    required super.labelMapper,
    required this.childrenMapper,
    super.onChanged,
    super.equalityMatcher,
    super.initialData,
    super.disabledWhen,
    super.itemBuilder,
    super.listTileTheme,
    super.placeholder,
    super.maxCount,
    super.actionBarBuilder,
    super.selectedItemBuilder,
    super.subtitleBuilder,
    super.filterMatcher,
    super.secondaryBuilder,
    super.showSearchField,
    bool? linkage,
    bool? parentCheckable,
    super.key,
  })  : linkage = linkage ?? true,
        parentCheckable = parentCheckable ?? false;

  /// 从非树型 Map 列表创建多选级联选择器
  TxMultiCascadePicker.fromMapList({
    required List<Map> source,
    ValueChanged<List<Map>?>? onChanged,
    String? labelKey,
    String? idKey,
    String? pidKey,
    String? rootId,
    List<Map>? initialData,
    ValueMapper<Map, bool>? disabledWhen,
    MultiPickerItemBuilder<Map>? itemBuilder,
    DataWidgetBuilder<Map>? subtitleBuilder,
    DataWidgetBuilder<Map>? secondaryBuilder,
    int? maxCount,
    bool? linkage,
    bool? parentCheckable,
    MultiPickerActionBarBuilder<Map>? actionBarBuilder,
    MultiPickerSelectedItemBuilder<Map>? selectedItemBuilder,
    EqualityMatcher<Map>? equalityMatcher,
    FilterMatcher<Map>? filterMatcher,
    ListTileThemeData? listTileTheme,
    Widget? placeholder,
    bool? showSearchField,
    super.key,
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
          labelMapper: (data) =>
              (data as Map)[labelKey ?? kLabelKey] as String?,
          subtitleBuilder: subtitleBuilder as DataWidgetBuilder<T>?,
          itemBuilder: itemBuilder as MultiPickerItemBuilder<T>?,
          disabledWhen: disabledWhen as ValueMapper<T, bool>?,
          onChanged: onChanged as ValueChanged<List<T>?>?,
          actionBarBuilder: actionBarBuilder as MultiPickerActionBarBuilder<T>?,
          selectedItemBuilder:
              selectedItemBuilder as MultiPickerSelectedItemBuilder<T>?,
          secondaryBuilder: secondaryBuilder as DataWidgetBuilder<T>?,
          filterMatcher: filterMatcher as FilterMatcher<T>?,
          listTileTheme: listTileTheme,
          placeholder: placeholder,
          showSearchField: showSearchField,
          maxCount: maxCount,
          equalityMatcher: (equalityMatcher as EqualityMatcher<T>?) ??
              (a, b) =>
                  (a as Map)[idKey ?? kTreeIdKey] ==
                  (b as Map)[idKey ?? kTreeIdKey],
        );

  /// 子节点映射
  final ValueMapper<T, List<T>?> childrenMapper;

  /// 父节点是否可选，默认 false
  final bool parentCheckable;

  /// 父子节点是否联动（选中父节点同时选中/取消所有子节点），默认 true
  final bool linkage;

  @override
  TxMultiPickerBaseState<T> createState() => _TxMultiCascadePickerState<T>();
}

class _TxMultiCascadePickerState<T> extends TxMultiPickerBaseState<T>
    with CascadePickerMixin<T, List<T>> {
  @override
  TxMultiCascadePicker<T> get widget => super.widget as TxMultiCascadePicker<T>;

  @override
  List<T>? getChildren(T parent) => widget.childrenMapper(parent);

  @override
  bool get parentCheckable => widget.parentCheckable;

  // ---- 初始化 ----

  @override
  void initState() {
    super.initState();
    for (final data in selectedData) {
      expandPathToSelected(data);
    }
  }

  // ---- 选中状态判断 ----

  @override
  bool isDataSelected(T data) {
    final children = getChildren(data) ?? [];

    if (children.isEmpty) {
      // 叶子节点：直接检查是否在选中列表
      return selectedData.any((e) => isEquals(e, data));
    }

    if (parentCheckable) {
      // 父节点可选：检查父节点本身是否被选中
      return selectedData.any((e) => isEquals(e, data));
    } else {
      // 父节点不可选：所有叶子后代都选中才算选中
      return _areAllLeafChildrenSelected(data);
    }
  }

  /// 递归检查所有叶子后代是否全部选中
  bool _areAllLeafChildrenSelected(T parent) {
    final children = getChildren(parent) ?? [];
    if (children.isEmpty) return false;

    for (final child in children) {
      final grandChildren = getChildren(child) ?? [];
      if (grandChildren.isEmpty) {
        if (!selectedData.any((e) => isEquals(e, child))) return false;
      } else {
        if (!_areAllLeafChildrenSelected(child)) return false;
      }
    }
    return true;
  }

  /// 父节点的三态复选框状态
  ///
  /// - `true`：所有可选后代均已选中
  /// - `false`：无后代被选中
  /// - `null`：部分后代被选中
  bool? _getParentTristate(T data) {
    if (parentCheckable) {
      // 父节点可选时，直接返回自身是否选中（不使用三态）
      return isDataSelected(data);
    }

    final allLeafNodes = getAllChildren(data)
        .where((e) => (getChildren(e) ?? []).isEmpty)
        .toList();

    if (allLeafNodes.isEmpty) return false;

    final selectedCount = allLeafNodes
        .where((e) => selectedData.any((s) => isEquals(s, e)))
        .length;

    if (selectedCount == 0) return false;
    if (selectedCount == allLeafNodes.length) return true;
    return null; // 部分选中
  }

  // ---- 选中/取消逻辑 ----

  /// 节点选中状态变更入口
  void _onNodeChanged(bool? select, T data) {
    final children = getChildren(data) ?? [];
    final bool hasChildren = children.isNotEmpty;

    if (!hasChildren) {
      // 叶子节点：直接切换
      _toggleLeaf(select, data);
    } else if (parentCheckable) {
      // 父节点可选：切换父节点本身，联动时同步子节点
      _toggleParentSelectable(select, data);
    } else {
      // 父节点不可选：仅操作后代叶子节点
      if (select == true || select == null) {
        _selectAllLeafChildren(data);
      } else {
        _deselectAllChildren(data);
      }
    }

    widget.onChanged?.call(List<T>.from(selectedData));
    setState(() {});
  }

  void _toggleLeaf(bool? select, T data) {
    if (select == true) {
      if (!selectedData.any((e) => isEquals(e, data)) && !_isMaxReached()) {
        selectedData.add(data);
      }
    } else {
      selectedData.removeWhere((e) => isEquals(e, data));
    }
  }

  void _toggleParentSelectable(bool? select, T data) {
    if (select == true) {
      if (!selectedData.any((e) => isEquals(e, data)) && !_isMaxReached()) {
        selectedData.add(data);
      }
      if (widget.linkage) _selectAllLeafChildren(data);
    } else {
      selectedData.removeWhere((e) => isEquals(e, data));
      if (widget.linkage) _deselectAllChildren(data);
    }
  }

  /// 选中所有叶子后代（受 maxCount 限制）
  void _selectAllLeafChildren(T parent) {
    final all = getAllChildren(parent);
    for (final child in all) {
      final grandChildren = getChildren(child) ?? [];
      final bool isLeaf = grandChildren.isEmpty;
      final bool shouldAdd = isLeaf || parentCheckable;
      if (!shouldAdd) continue;

      final bool enabled =
          widget.disabledWhen == null ? true : !widget.disabledWhen!(child);
      if (!enabled) continue;

      if (!selectedData.any((e) => isEquals(e, child)) && !_isMaxReached()) {
        selectedData.add(child);
      }
    }
  }

  /// 取消选中某节点的所有后代
  void _deselectAllChildren(T parent) {
    final all = getAllChildren(parent);
    for (final child in all) {
      selectedData.removeWhere((e) => isEquals(e, child));
    }
  }

  bool _isMaxReached() =>
      widget.maxCount != null && selectedData.length >= widget.maxCount!;

  // ---- 全选 ----

  @override
  void onSelectAll(List<T> data) {
    final allSelectable = getAllSelectableNodes();
    selectedData.clear();
    final count =
        math.min(widget.maxCount ?? allSelectable.length, allSelectable.length);
    selectedData.addAll(allSelectable.take(count));
    widget.onChanged?.call(List<T>.from(selectedData));
    setState(() {});
  }

  // ---- 构建 ----

  /// 构建叶子节点
  @override
  Widget buildCascadeLeafItem(T data) {
    final bool checked = isDataSelected(data);
    final bool enabled = isEnabled(data, checked);

    if (widget.itemBuilder != null) {
      return widget.itemBuilder!(
        context,
        data,
        checked,
        enabled ? (val) => _onNodeChanged(val, data) : null,
      );
    }

    return TxCheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      value: checked,
      dense: true,
      title: TxMatchingText(
        widget.labelMapper(data) ?? '',
        query: query,
      ),
      subtitle: widget.subtitleBuilder != null
          ? widget.subtitleBuilder!(context, data)
          : null,
      secondary: widget.secondaryBuilder != null
          ? widget.secondaryBuilder!(context, data)
          : null,
      onChanged: enabled ? (val) => _onNodeChanged(val, data) : null,
      selected: checked,
      enabled: enabled,
    );
  }

  /// 构建父节点 leading 复选框（三态）
  @override
  Widget? buildParentLeading(T data) {
    final bool? tristate = _getParentTristate(data);
    final bool isTristate = !parentCheckable;
    final bool checked = isDataSelected(data);
    final bool enabled = isEnabled(data, checked);

    // 三态时 null（部分选中）也允许点击
    final bool canTap = enabled || (isTristate && tristate == null);

    return TxCheckbox(
      value: tristate,
      tristate: isTristate,
      onChanged: canTap ? (val) => _onNodeChanged(val, data) : null,
    );
  }
}

/// 弹出多选级联选择器
Future<List<T>?> showMultiCascadePicker<T>({
  required BuildContext context,
  required List<T> source,
  required ValueMapper<T, String?> labelMapper,
  required ValueMapper<T, List<T>?> childrenMapper,
  String? title,
  List<T>? initialData,
  DataWidgetBuilder<T>? subtitleBuilder,
  DataWidgetBuilder<T>? secondaryBuilder,
  MultiPickerItemBuilder<T>? itemBuilder,
  MultiPickerActionBarBuilder<T>? actionBarBuilder,
  MultiPickerSelectedItemBuilder<T>? selectedItemBuilder,
  EqualityMatcher<T>? equalityMatcher,
  FilterMatcher<T>? filterMatcher,
  int? maxCount,
  ValueMapper<T, bool>? disabledWhen,
  bool? showSearchField,
  Widget? placeholder,
  bool? parentCheckable,
  bool? linkage,
  ListTileThemeData? listTileTheme,
}) async {
  List<T> result = List<T>.from(initialData ?? []);

  return showDefaultBottomSheet<List<T>>(
    context,
    title: title ?? '请选择',
    contentBuilder: (context) => TxMultiCascadePicker<T>(
      source: source,
      labelMapper: labelMapper,
      childrenMapper: childrenMapper,
      initialData: initialData,
      subtitleBuilder: subtitleBuilder,
      secondaryBuilder: secondaryBuilder,
      itemBuilder: itemBuilder,
      listTileTheme: listTileTheme,
      placeholder: placeholder,
      parentCheckable: parentCheckable,
      linkage: linkage,
      equalityMatcher: equalityMatcher,
      filterMatcher: filterMatcher,
      maxCount: maxCount,
      actionBarBuilder: actionBarBuilder,
      selectedItemBuilder: selectedItemBuilder,
      disabledWhen: disabledWhen,
      showSearchField: showSearchField,
      onChanged: (val) => result = val ?? [],
    ),
    onConfirm: () => Navigator.pop(context, result),
    actionsPosition: ActionsPosition.header,
    isScrollControlled: true,
    contentPadding: EdgeInsets.zero,
  );
}

/// 弹出 Map 列表类型多选级联选择器
Future<List<Map>?> showMultiMapListCascadePicker<V>({
  required BuildContext context,
  required List<Map> source,
  String? labelKey,
  String? idKey,
  String? pidKey,
  String? rootId,
  String? title,
  List<Map>? initialData,
  DataWidgetBuilder<Map>? subtitleBuilder,
  DataWidgetBuilder<Map>? secondaryBuilder,
  MultiPickerItemBuilder<Map>? itemBuilder,
  MultiPickerActionBarBuilder<Map>? actionBarBuilder,
  MultiPickerSelectedItemBuilder<Map>? selectedItemBuilder,
  EqualityMatcher<Map>? equalityMatcher,
  FilterMatcher<Map>? filterMatcher,
  int? maxCount,
  ValueMapper<Map, bool>? disabledWhen,
  bool? showSearchField,
  Widget? placeholder,
  bool? parentCheckable,
  bool? linkage,
  ListTileThemeData? listTileTheme,
}) async {
  List<Map> result = List<Map>.from(initialData ?? []);

  return showDefaultBottomSheet<List<Map>>(
    context,
    title: title ?? '请选择',
    contentBuilder: (context) => TxMultiCascadePicker<Map>.fromMapList(
      source: source,
      labelKey: labelKey,
      idKey: idKey,
      pidKey: pidKey,
      rootId: rootId,
      initialData: initialData,
      subtitleBuilder: subtitleBuilder,
      secondaryBuilder: secondaryBuilder,
      itemBuilder: itemBuilder,
      listTileTheme: listTileTheme,
      placeholder: placeholder,
      parentCheckable: parentCheckable,
      linkage: linkage,
      equalityMatcher: equalityMatcher,
      filterMatcher: filterMatcher,
      maxCount: maxCount,
      actionBarBuilder: actionBarBuilder,
      selectedItemBuilder: selectedItemBuilder,
      disabledWhen: disabledWhen,
      showSearchField: showSearchField,
      onChanged: (val) => result = val ?? [],
    ),
    onConfirm: () => Navigator.pop(context, result),
    actionsPosition: ActionsPosition.header,
    isScrollControlled: true,
    contentPadding: EdgeInsets.zero,
  );
}
