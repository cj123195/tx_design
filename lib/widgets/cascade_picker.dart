import 'package:flutter/material.dart';

import '../extensions/iterable_extension.dart';
import 'bottom_sheet.dart';
import 'matching_text.dart';
import 'picker.dart';

export 'picker.dart'
    show ValueMapper, DataWidgetBuilder, EqualityMatcher, FilterMatcher;

/// 级联选择器通用逻辑 Mixin
///
/// 混入 [TxPickerBaseState] 子类，为单选和多选级联选择器提供：
/// - 树形节点展开/收起状态管理
/// - 递归节点匹配与路径查找
/// - [ExpansionTile] 构建框架
mixin CascadePickerMixin<T, D> on TxPickerBaseState<T, D> {
  /// 获取子节点数据
  List<T>? getChildren(T parent);

  /// 父节点是否可选
  bool get parentCheckable;

  // 展开状态表，key 直接使用数据对象（依赖 == / hashCode 或 equalityMatcher）
  final Map<T, bool> _expandedStates = {};

  // ---- 搜索覆写 ----

  /// 覆写基类搜索逻辑：树形结构需递归匹配子节点
  @override
  List<T> getFilteredData(String query) {
    if (query.isEmpty) {
      return widget.source;
    }
    return widget.source.where((node) => _isNodeMatched(node, query)).toList();
  }

  // ---- 树形工具方法 ----

  /// 节点（含子孙）是否匹配搜索文字
  bool _isNodeMatched(T node, String query) {
    final String? label = widget.labelMapper(node);
    if (label != null && label.contains(query)) return true;

    final List<T>? children = getChildren(node);
    if (children == null || children.isEmpty) return false;
    return children.any((child) => _isNodeMatched(child, query));
  }

  /// 过滤子节点列表（搜索时只保留匹配的子节点）
  List<T> _filterChildren(List<T> children) {
    final String q = query ?? '';
    if (q.isEmpty) return children;
    return children.where((child) => _isNodeMatched(child, q)).toList();
  }

  /// 递归查找从根到 [targetData] 的路径（不含目标自身）
  List<T>? findPathToSelected(List<T> nodes, T targetData) {
    for (final node in nodes) {
      if (isEquals(node, targetData)) return [];
      final children = getChildren(node) ?? [];
      final path = findPathToSelected(children, targetData);
      if (path != null) return [node, ...path];
    }
    return null;
  }

  /// 获取某节点下所有后代节点（深度优先）
  List<T> getAllChildren(T parent) {
    final result = <T>[];
    final children = getChildren(parent) ?? [];
    for (final child in children) {
      result.add(child);
      result.addAll(getAllChildren(child));
    }
    return result;
  }

  /// 获取树中所有可选节点
  ///
  /// 叶子节点始终可选；父节点仅在 [parentCheckable] 为 true 时可选。
  List<T> getAllSelectableNodes() {
    final result = <T>[];
    void traverse(List<T> nodes) {
      for (final node in nodes) {
        final bool enabled =
            widget.disabledWhen == null ? true : !widget.disabledWhen!(node);
        if (!enabled) continue;
        final children = getChildren(node) ?? [];
        if (children.isEmpty || parentCheckable) result.add(node);
        if (children.isNotEmpty) traverse(children);
      }
    }

    traverse(widget.source);
    return result;
  }

  // ---- 展开状态 ----

  void setExpanded(T node, bool expanded) {
    setState(() => _expandedStates[node] = expanded);
  }

  bool isExpanded(T node) => _expandedStates[node] ?? false;

  /// 根据选中数据自动展开路径（不触发 setState，由调用方决定时机）
  void expandPathToSelected(T? selectedNode) {
    if (selectedNode == null) return;
    final path = findPathToSelected(widget.source, selectedNode);
    if (path == null) return;
    for (final node in path) {
      _expandedStates[node] = true;
    }
  }

  // ---- 子类实现点 ----

  /// 构建叶子节点选择项
  Widget buildCascadeLeafItem(T data);

  /// 构建父节点左侧的选择控件（Radio / Checkbox）
  Widget? buildParentLeading(T data);

  /// 当前数据是否处于选中状态
  bool isDataSelected(T data);

  // ---- ExpansionTile 构建 ----

  /// 递归构建节点 Tile
  Widget buildExpansionTile(T data) {
    final List<T>? rawChildren = getChildren(data);
    final bool hasChildren = rawChildren != null && rawChildren.isNotEmpty;

    // 叶子节点
    if (!hasChildren) {
      return buildCascadeLeafItem(data);
    }

    final List<T> visibleChildren = _filterChildren(rawChildren);
    final bool selected = isDataSelected(data);
    final Widget? leading = buildParentLeading(data);

    return ExpansionTile(
      key: ValueKey(data),
      initiallyExpanded: isExpanded(data),
      onExpansionChanged: (expanded) => setExpanded(data, expanded),
      collapsedBackgroundColor:
          selected ? Theme.of(context).listTileTheme.selectedTileColor : null,
      tilePadding: const EdgeInsets.only(left: 4.0, right: 16.0),
      leading: leading,
      title: TxMatchingText(
        widget.labelMapper(data) ?? '',
        query: query,
      ),
      childrenPadding: const EdgeInsets.only(left: 16.0),
      children: visibleChildren.map(buildExpansionTile).toList(),
    );
  }

  /// 覆写基类内容构建，使用树形 ListView
  @override
  Widget buildPickerContent(List<T> data) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      itemCount: data.length,
      itemBuilder: (context, index) => buildExpansionTile(data[index]),
    );
  }
}

class TxCascadePicker<T> extends TxSinglePickerBase<T> {
  const TxCascadePicker({
    required super.source,
    required super.labelMapper,
    required this.childrenMapper,
    super.onChanged,
    super.initialData,
    super.disabledWhen,
    super.itemBuilder,
    super.subtitleBuilder,
    super.secondaryBuilder,
    super.listTileTheme,
    super.placeholder,
    super.showSearchField,
    super.filterMatcher,
    super.equalityMatcher,
    bool? parentCheckable,
    super.key,
  }) : parentCheckable = parentCheckable ?? false;

  /// 从非树型 Map 列表创建级联选择器
  ///
  /// 内部自动将平铺列表转换为树形结构。
  TxCascadePicker.fromMapList({
    required List<Map> source,
    required ValueChanged<Map?>? onChanged,
    String? labelKey,
    String? idKey,
    String? pidKey,
    String? rootId,
    Map? initialData,
    ValueMapper<Map, bool>? disabledWhen,
    PickerItemBuilder<Map>? itemBuilder,
    DataWidgetBuilder<Map>? subtitleBuilder,
    DataWidgetBuilder<Map>? secondaryBuilder,
    ListTileThemeData? listTileTheme,
    Widget? placeholder,
    bool? showSearchField,
    FilterMatcher<Map>? filterMatcher,
    EqualityMatcher<Map>? equalityMatcher,
    bool? parentCheckable,
    super.key,
  })  : parentCheckable = parentCheckable ?? false,
        childrenMapper = _defaultMapChildrenMapper,
        super(
          source: source
              .toTree(
                idKey: idKey ?? kTreeIdKey,
                pidKey: pidKey ?? kTreePidKey,
                childrenKey: kTreeChildrenKey,
                rootId: rootId,
              )
              .toList() as List<T>,
          initialData: initialData as T?,
          labelMapper: (data) =>
              (data as Map)[labelKey ?? kLabelKey] as String?,
          subtitleBuilder: subtitleBuilder as DataWidgetBuilder<T>?,
          secondaryBuilder: secondaryBuilder as DataWidgetBuilder<T>?,
          itemBuilder: itemBuilder as PickerItemBuilder<T>?,
          disabledWhen: disabledWhen as ValueMapper<T, bool>?,
          onChanged:
              onChanged == null ? null : (T? val) => onChanged(val as Map?),
          listTileTheme: listTileTheme,
          placeholder: placeholder,
          showSearchField: showSearchField,
          filterMatcher: filterMatcher as FilterMatcher<T>?,
          // Map 列表默认用 idKey 做相等判断，避免要求用户实现 ==
          equalityMatcher: (equalityMatcher as EqualityMatcher<T>?) ??
              (a, b) =>
                  (a as Map)[idKey ?? kTreeIdKey] ==
                  (b as Map)[idKey ?? kTreeIdKey],
        );

  /// 子节点映射
  final ValueMapper<T, List<T>?> childrenMapper;

  /// 父节点是否可选，默认 false
  final bool parentCheckable;

  @override
  TxSinglePickerBaseState<T> createState() => _TxCascadePickerState<T>();
}

class _TxCascadePickerState<T> extends TxSinglePickerBaseState<T>
    with CascadePickerMixin<T, T> {
  @override
  TxCascadePicker<T> get widget => super.widget as TxCascadePicker<T>;

  @override
  List<T>? getChildren(T parent) => widget.childrenMapper(parent);

  @override
  bool get parentCheckable => widget.parentCheckable;

  @override
  bool isDataSelected(T data) =>
      selectedData != null && isEquals(data, selectedData as T);

  @override
  void initState() {
    super.initState();
    if (selectedData != null) expandPathToSelected(selectedData);
  }

  @override
  void didUpdateWidget(covariant TxCascadePicker<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialData != null &&
        (selectedData == null ||
            !isEquals(widget.initialData as T, selectedData as T))) {
      selectedData = widget.initialData;
      expandPathToSelected(selectedData);
    }
  }

  @override
  Widget buildCascadeLeafItem(T data) {
    // 优先使用自定义 itemBuilder
    if (widget.itemBuilder != null) {
      return widget.itemBuilder!(context, data, selectedData, onChanged);
    }
    return buildPickerItem(context, data);
  }

  @override
  Widget? buildParentLeading(T data) {
    if (!parentCheckable) {
      return null;
    }
    // 父节点可选时，用 Radio 作为 leading
    return Radio<T>.adaptive(
      value: data,
      onChanged: onChanged,
      groupValue: selectedData,
    );
  }
}

/// 弹出单选级联选择器
Future<T?> showCascadePicker<T>({
  required BuildContext context,
  required List<T> source,
  required ValueMapper<T, String?> labelMapper,
  required ValueMapper<T, List<T>?> childrenMapper,
  String? title,
  T? initialData,
  DataWidgetBuilder<T>? subtitleBuilder,
  DataWidgetBuilder<T>? secondaryBuilder,
  ValueMapper<T, bool>? disabledWhen,
  PickerItemBuilder<T>? itemBuilder,
  EqualityMatcher<T>? equalityMatcher,
  FilterMatcher<T>? filterMatcher,
  bool? showSearchField,
  Widget? placeholder,
  ListTileThemeData? listTileTheme,
  bool? parentCheckable,
}) async {
  T? result = initialData;

  return showDefaultBottomSheet<T>(
    context,
    title: title ?? '请选择',
    contentBuilder: (context) => TxCascadePicker<T>(
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
      equalityMatcher: equalityMatcher,
      filterMatcher: filterMatcher,
      showSearchField: showSearchField,
      disabledWhen: disabledWhen,
      onChanged: (val) => result = val,
    ),
    onConfirm: () => Navigator.pop(context, result),
    actionsPosition: ActionsPosition.header,
    isScrollControlled: true,
    contentPadding: EdgeInsets.zero,
  );
}

/// 弹出 Map 列表类型单选级联选择器
Future<Map?> showMapListCascadePicker<V>({
  required BuildContext context,
  required List<Map> source,
  String? labelKey,
  String? idKey,
  String? pidKey,
  String? rootId,
  String? title,
  Map? initialData,
  DataWidgetBuilder<Map>? subtitleBuilder,
  DataWidgetBuilder<Map>? secondaryBuilder,
  ValueMapper<Map, bool>? disabledWhen,
  PickerItemBuilder<Map>? itemBuilder,
  EqualityMatcher<Map>? equalityMatcher,
  FilterMatcher<Map>? filterMatcher,
  bool? showSearchField,
  Widget? placeholder,
  ListTileThemeData? listTileTheme,
  bool? parentCheckable,
}) async {
  Map? result = initialData;

  return showDefaultBottomSheet<Map>(
    context,
    title: title ?? '请选择',
    contentBuilder: (context) => TxCascadePicker<Map>.fromMapList(
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
      equalityMatcher: equalityMatcher,
      filterMatcher: filterMatcher,
      showSearchField: showSearchField,
      disabledWhen: disabledWhen,
      onChanged: (val) => result = val,
    ),
    onConfirm: () => Navigator.pop(context, result),
    actionsPosition: ActionsPosition.header,
    isScrollControlled: true,
    contentPadding: EdgeInsets.zero,
  );
}

const String kLabelKey = 'label';

List<T>? _defaultMapChildrenMapper<T>(dynamic data) =>
    ((data as Map)[kTreeChildrenKey] as List?)?.cast<Map>() as List<T>?;
