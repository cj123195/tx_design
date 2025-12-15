import 'package:flutter/material.dart';

import '../extensions/iterable_extension.dart';
import '../form/picker_form_field.dart';
import 'bottom_sheet.dart';
import 'matching_text.dart';
import 'picker.dart';

export 'picker.dart' show ValueMapper, DataWidgetBuilder;

const String kLabelKey = 'label';

List<T>? _kMapChildrenMapper<T>(data) =>
    ((data as Map)[kTreeChildrenKey] as List?)?.cast<Map>() as List<T>?;

mixin CascadePickerMixin<T, D, V> on TxPickerBaseState<T, D, V> {
  /// 获取子节点数据
  List<T>? getChildren(T parent);

  /// 父节点是否可选
  bool get parentCheckable;

  // ExpansionTileController controller;

  @override
  List<T> filterData(String query) {
    if (query.isEmpty) {
      return widget.source;
    }
    return widget.source.where(_isNodeMatched).toList();
  }

  // 记录展开状态的Map，key为节点的值，value为是否展开
  final Map<V?, bool> _expandedStates = {};

  /// 判断节点是否匹配查询文字
  bool _isNodeMatched(T node) {
    final String? label = widget.labelMapper(node);
    bool matched = false;
    if (label != null && label.isNotEmpty) {
      matched = label.contains(controller!.text);
    }
    if (matched) {
      return true;
    }

    final List<T>? children = getChildren(node);
    if (children == null || children.isEmpty) {
      return false;
    }

    return children.any(_isNodeMatched);
  }

  /// 递归查找当前节点路径
  List<T>? findPathToSelected(List<T> nodes, V? targetValue) {
    for (var node in nodes) {
      if (widget.valueMapper(node) == targetValue) {
        return [];
      }

      final children = getChildren(node) ?? [];
      final path = findPathToSelected(children, targetValue);
      if (path != null) {
        return [node, ...path];
      }
    }
    return null;
  }

  /// 获取所有子节点
  List<T> getAllChildren(T parent) {
    final List<T> result = [];
    final children = getChildren(parent) ?? [];

    for (final child in children) {
      result.add(child);
      result.addAll(getAllChildren(child));
    }

    return result;
  }

  /// 获取所有可选择的节点
  List<T> getAllSelectableNodes() {
    final List<T> result = [];

    void traverse(List<T> nodes) {
      for (final node in nodes) {
        final enabled =
            widget.disabledWhen == null ? true : !widget.disabledWhen!(node);
        if (enabled) {
          final children = getChildren(node) ?? [];
          if (children.isEmpty || parentCheckable) {
            result.add(node);
          }
          if (children.isNotEmpty) {
            traverse(children);
          }
        }
      }
    }

    traverse(widget.source);
    return result;
  }

  /// 设置节点展开状态
  void setExpanded(V? nodeValue, bool expanded) {
    setState(() {
      _expandedStates[nodeValue] = expanded;
    });
  }

  /// 获取节点展开状态
  bool isExpanded(V? nodeValue) {
    return _expandedStates[nodeValue] ?? false;
  }

  /// 根据选中状态自动展开路径
  void expandPathToSelected(T? selectedData) {
    if (selectedData == null) {
      return;
    }

    final path =
        findPathToSelected(widget.source, widget.valueMapper(selectedData));
    if (path != null) {
      for (final node in path) {
        if (node != null) {
          final nodeValue = widget.valueMapper(node);
          _expandedStates[nodeValue] = true;
        }
      }
    }
  }

  /// 构建选择项
  Widget buildCascadePickerItem(T data);

  /// 构建父节点选择器
  Widget buildParentChecker(T data);

  /// 构建单个节点的ExpansionTile
  Widget buildExpansionTile(T data) {
    final V? nodeValue = widget.valueMapper(data);
    final String? label = widget.labelMapper(data);
    final List<T>? children = getChildren(data);
    final bool hasChildren = children != null && children.isNotEmpty;
    final bool selected = isDataSelected(data);

    // 如果是叶子节点或者使用了自定义构建器
    if (!hasChildren) {
      return buildCascadePickerItem(data);
    }

    List<T> filterChildren = [...children];
    if (controller != null) {
      filterChildren = filterChildren.where(_isNodeMatched).toList();
    }

    // 父节点使用ExpansionTile
    return ExpansionTile(
      collapsedBackgroundColor:
          selected ? Theme.of(context).listTileTheme.selectedTileColor : null,
      tilePadding: const EdgeInsets.only(left: 4.0, right: 16.0),
      key: ValueKey(nodeValue),
      initiallyExpanded: isExpanded(nodeValue),
      onExpansionChanged: (expanded) => setExpanded(nodeValue, expanded),
      leading: parentCheckable ? buildParentChecker(data) : null,
      title: TxMatchingText(label ?? '', query: controller?.text),
      childrenPadding: const EdgeInsets.only(left: 16),
      children: filterChildren.map(buildExpansionTile).toList(),
    );
  }

  /// 构建树形内容
  @override
  Widget buildPickerContent(List<T> data) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      itemBuilder: (context, index) => buildExpansionTile(data[index]),
      itemCount: data.length,
    );
  }

  /// 数据是否选中
  bool isDataSelected(T data);
}

class TxCascadePicker<T, V> extends TxSinglePickerBase<T, V> {
  TxCascadePicker({
    required super.source,
    required super.labelMapper,
    required this.childrenMapper,
    required super.onChanged,
    super.valueMapper,
    super.initialData,
    super.disabledWhen,
    super.key,
    super.itemBuilder,
    super.subtitleBuilder,
    super.listTileTheme,
    super.placeholder,
    bool? parentCheckable,
    super.showSearchField,
  }) : parentCheckable = parentCheckable ?? false;

  /// 通过给定非树型数据数组创建一个级联选择器
  TxCascadePicker.fromMapList({
    required List<Map> source,
    required ValueChanged<Map?>? onChanged,
    String? valueKey,
    String? labelKey,
    String? idKey,
    String? pidKey,
    String? rootId,
    ValueMapper<Map, bool>? disabledWhen,
    super.key,
    PickerItemBuilder<Map>? itemBuilder,
    super.listTileTheme,
    Map? initialData,
    V? initialValue,
    super.placeholder,
    super.showSearchField,
    bool? parentCheckable,
    DataWidgetBuilder<Map>? subtitleBuilder,
  })  : parentCheckable = parentCheckable ?? false,
        childrenMapper = _kMapChildrenMapper,
        super(
          initialData: TxPickerFormField.initData<Map, V>(
            source,
            initialData,
            initialValue,
            (data) => data[valueKey ?? idKey ?? kTreeIdKey],
          ) as T,
          source: source
              .toTree(
                idKey: idKey ?? kTreeIdKey,
                pidKey: pidKey ?? kTreePidKey,
                childrenKey: kTreeChildrenKey,
                rootId: rootId,
              )
              .toList() as List<T>,
          subtitleBuilder: subtitleBuilder as DataWidgetBuilder<T>?,
          itemBuilder: itemBuilder as PickerItemBuilder<T>?,
          disabledWhen: disabledWhen as ValueMapper<T, bool>?,
          onChanged:
              onChanged == null ? null : (T? val) => onChanged(val as Map?),
          labelMapper: (data) =>
              (data as Map)[labelKey ?? kLabelKey] as String?,
          valueMapper: (data) =>
              (data as Map)[valueKey ?? idKey ?? kTreeIdKey] as V,
        );

  /// 数据的子节点
  final ValueMapper<T, List<T>?> childrenMapper;

  /// 父节点是否可选
  final bool parentCheckable;

  @override
  TxSinglePickerBaseState<T, V> createState() => _TxCascadePickerState<T, V>();
}

class _TxCascadePickerState<T, V> extends TxSinglePickerBaseState<T, V>
    with CascadePickerMixin<T, T, V> {
  @override
  TxCascadePicker<T, V> get widget => super.widget as TxCascadePicker<T, V>;

  @override
  void initState() {
    super.initState();
    // 如果有初始选中数据，自动展开到该路径
    if (selectedData != null) {
      expandPathToSelected(selectedData);
    }
  }

  @override
  bool isDataSelected(T data) {
    return selectedData != null &&
        widget.valueMapper(selectedData as T) == widget.valueMapper(data);
  }

  @override
  void didUpdateWidget(covariant TxCascadePicker<T, V> oldWidget) {
    if (widget.initialData != selectedData) {
      selectedData = widget.initialData;
      // 重新展开路径
      if (selectedData != null) {
        expandPathToSelected(selectedData);
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget buildCascadePickerItem(T data) {
    if (widget.itemBuilder != null) {
      return widget.itemBuilder!(context, data, selectedData, onChanged);
    }
    return buildPickerItem(data);
  }

  @override
  Widget buildParentChecker(T data) {
    return Radio<V?>(
      value: widget.valueMapper(data),
      groupValue:
          selectedData == null ? null : widget.valueMapper(selectedData as T),
      onChanged: (V? value) => onChanged(data),
    );
  }

  @override
  List<T>? getChildren(T parent) => widget.childrenMapper(parent);

  @override
  bool get parentCheckable => widget.parentCheckable;
}

/// 弹出级联选择器
Future<T?> showCascadePicker<T, V>({
  required BuildContext context,
  required List<T> source,
  required ValueMapper<T, String?> labelMapper,
  required ValueMapper<T, List<T>?> childrenMapper,
  String? title,
  T? initialData,
  V? initialValue,
  ValueMapper<T, V?>? valueMapper,
  DataWidgetBuilder<T>? subtitleBuilder,
  ValueMapper<T, bool>? disabledWhen,
  PickerItemBuilder<T>? itemBuilder,
  bool? isScrollControlled,
  bool? showSearchField,
  Widget? placeholder,
  ListTileThemeData? listTileTheme,
  bool? parentCheckable,
}) async {
  T? result = source.getInitialData<V>(
    initialValue: initialValue,
    initialData: initialData,
    valueMapper: valueMapper,
    childrenMapper: childrenMapper,
  );
  return showDefaultBottomSheet<T>(
    context,
    title: title ?? '请选择',
    contentBuilder: (context) {
      return TxCascadePicker<T, V>(
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
        disabledWhen: disabledWhen,
        showSearchField: showSearchField,
        subtitleBuilder: subtitleBuilder,
      );
    },
    onConfirm: () => Navigator.pop(context, result),
    actionsPosition: ActionsPosition.header,
    isScrollControlled: true,
    contentPadding: EdgeInsets.zero,
  );
}

/// 弹出数据为 Map 列表类型级联选择器
Future<Map?> showMapListCascadePicker<V>({
  required BuildContext context,
  required List<Map> source,
  String? valueKey,
  String? labelKey,
  String? idKey,
  String? pidKey,
  String? rootId,
  String? title,
  Map? initialData,
  V? initialValue,
  DataWidgetBuilder<Map>? subtitleBuilder,
  ValueMapper<Map, bool>? disabledWhen,
  PickerItemBuilder<Map>? itemBuilder,
  bool? isScrollControlled,
  bool? showSearchField,
  Widget? placeholder,
  ListTileThemeData? listTileTheme,
  bool? parentCheckable,
}) async {
  Map? result = source.getInitialData<V>(
    initialValue: initialValue,
    initialData: initialData,
    valueMapper: (data) => data[valueKey ?? idKey],
  );
  return showDefaultBottomSheet<Map>(
    context,
    title: title ?? '请选择',
    contentBuilder: (context) {
      return TxCascadePicker<Map, V>.fromMapList(
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
        disabledWhen: disabledWhen,
        showSearchField: showSearchField,
      );
    },
    onConfirm: () => Navigator.pop(context, result),
    actionsPosition: ActionsPosition.header,
    isScrollControlled: true,
    contentPadding: EdgeInsets.zero,
  );
}
