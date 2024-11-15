import 'package:flutter/material.dart';

import '../tx_design.dart';

const String _kLabelKey = 'label';

/// 级联选择器
class TxCascadePicker<D, V> extends StatefulWidget {
  TxCascadePicker({
    required this.datasource,
    required this.labelMapper,
    required ValueMapper<D, V>? valueMapper,
    required this.childrenMapper,
    required this.onChanged,
    this.initialValue,
    this.initialData,
    super.key,
    this.itemBuilder,
    this.tabItemBuilder,
    this.listTheme,
    this.placeholder,
    bool? isParentNodeSelectable,
  })  : isParentNodeSelectable = isParentNodeSelectable ?? false,
        valueMapper = valueMapper ?? ((data) => data as V);

  /// 通过给定非树型数据数组创建一个级联选择器
  TxCascadePicker.fromMapList({
    required List<Map> datasource,
    required this.onChanged,
    String? valueKey,
    String labelKey = _kLabelKey,
    String idKey = kTreeIdKey,
    String pidKey = kTreePidKey,
    String childrenKey = kTreeChildrenKey,
    super.key,
    this.itemBuilder,
    this.tabItemBuilder,
    this.listTheme,
    this.initialValue,
    this.initialData,
    this.placeholder,
    bool? isParentNodeSelectable,
  })  : datasource = datasource
            .toTree(idKey: idKey, pidKey: pidKey, childrenKey: childrenKey)
            .toList() as List<D>,
        labelMapper = ((data) => (data as Map)[labelKey] as String?),
        valueMapper = ((data) => (data as Map)[valueKey ?? idKey] as V),
        childrenMapper = ((data) =>
            ((data as Map)[childrenKey] as List?)?.cast<Map>() as List<D>?),
        isParentNodeSelectable = isParentNodeSelectable ?? false;

  /// 通过给定树型数据创建一个级联选择器
  TxCascadePicker.fromMapTree({
    required List<Map> datasource,
    required this.onChanged,
    String labelKey = _kLabelKey,
    String valueKey = kTreeIdKey,
    String childrenKey = kTreeChildrenKey,
    super.key,
    this.itemBuilder,
    this.tabItemBuilder,
    this.listTheme,
    this.initialValue,
    this.initialData,
    this.placeholder,
    bool? isParentNodeSelectable,
  })  : datasource = datasource as List<D>,
        labelMapper = ((data) => (data as Map)[labelKey] as String?),
        valueMapper = ((data) => (data as Map)[valueKey] as V),
        childrenMapper = ((data) =>
            ((data as Map)[childrenKey] as List?)?.cast<Map>() as List<D>?),
        isParentNodeSelectable = isParentNodeSelectable ?? false;

  /// 数据源
  final List<D> datasource;

  /// 数据展示给用户的标签
  final ValueMapper<D, String?> labelMapper;

  /// 数据的值
  final ValueMapper<D, V> valueMapper;

  /// 数据的值
  final ValueMapper<D, List<D>?> childrenMapper;

  /// 列表项构造器
  final SelectableWidgetBuilder<D>? itemBuilder;

  /// Tab 项构造器
  final IndexedDataWidgetBuilder<D?>? tabItemBuilder;

  /// 列表项主题
  final ListTileThemeData? listTheme;

  /// 初始值
  final String? initialValue;

  /// 初始选择的数据
  final D? initialData;

  /// 未选择数据时 Tab 栏的文字提示
  final String? placeholder;

  /// 父节点是否可选
  final bool isParentNodeSelectable;

  /// 数据变更回调
  final ValueChanged<D>? onChanged;

  D? get _initialData {
    if (initialData != null) {
      return initialData!;
    }

    if (initialValue == null) {
      return null;
    }

    for (D data in datasource) {
      if (valueMapper(data) == initialValue) {
        return data;
      }
    }
    return null;
  }

  @override
  State<TxCascadePicker> createState() => _TxCascadePickerState<D, V>();
}

class _TxCascadePickerState<D, V> extends State<TxCascadePicker<D, V>> {
  late final List<D?> _nodes; // 当前选择节点列表
  D? _selectedData; // 已选数据
  int _tabIndex = 0;

  /// 循环查找父节点
  List<D?>? _findNodes(List<D> nodes) {
    for (var node in nodes) {
      final List<D>? children = widget.childrenMapper(node);

      if (widget.valueMapper(node) == widget.valueMapper(_selectedData as D)) {
        return [node, if (children?.isNotEmpty == true) null];
      }

      if (children == null || children.isEmpty) {
        return null;
      }

      final childNodes = _findNodes(children);
      if (childNodes != null) {
        return [node, ...childNodes];
      }
    }

    return null;
  }

  /// 数据选择回调
  void _onDataSelect(D data) {
    _nodes[_tabIndex] = data;
    if (_tabIndex != _nodes.length - 1) {
      final tempNodes = _nodes.sublist(0, _tabIndex + 1);
      _nodes.clear();
      _nodes.addAll(tempNodes);
    }

    final List<D>? children = widget.childrenMapper(data);
    if (children == null || children.isEmpty) {
      _selectedData = data;
      if (widget.onChanged != null) {
        widget.onChanged!(data);
      }
    } else {
      _nodes.add(null);
      _tabIndex = _nodes.length - 1;
      if (widget.isParentNodeSelectable) {
        _selectedData = data;
        if (widget.onChanged != null) {
          widget.onChanged!(data);
        }
      }
    }

    setState(() {});
  }

  @override
  void initState() {
    _selectedData = widget._initialData;
    if (_selectedData != null) {
      final nodes = _findNodes(widget.datasource);
      _nodes = nodes ?? [null];
    } else {
      _nodes = [null];
    }
    _tabIndex = _nodes.length - 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<D> children = _tabIndex == 0
        ? widget.datasource
        : widget.childrenMapper(_nodes[_tabIndex - 1] as D)!;
    final List<Widget> tabs = List.generate(
      _nodes.length,
      (index) {
        final node = _nodes[index];
        return widget.tabItemBuilder == null
            ? Tab(
                text: node == null
                    ? widget.placeholder ?? '请选择'
                    : widget.labelMapper(node) ?? '')
            : widget.tabItemBuilder!(context, _nodes.length, node);
      },
    );

    final Widget tabBar = _TabBar(
      tabs.length,
      _tabIndex,
      (controller) => TabBar(
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        tabs: tabs,
        onTap: (index) => setState(() {
          _tabIndex = index;
        }),
        controller: controller,
      ),
    );

    return Column(
      children: [
        tabBar,
        ...List.generate(
          children.length,
          (index) {
            final data = children[index];
            final V value = widget.valueMapper(data);
            final bool selected = _nodes.indexWhere((node) =>
                    node == null ? false : widget.valueMapper(node) == value) !=
                -1;
            if (widget.itemBuilder != null) {
              return widget.itemBuilder!(
                context,
                index,
                data,
                selected,
                selected ? null : () => _onDataSelect(data),
              );
            }
            return ListTile(
              selected: selected,
              trailing: selected
                  ? Icon(
                      Icons.done,
                      color: Theme.of(context).colorScheme.primary,
                    )
                  : null,
              title: Text(widget.labelMapper(data) ?? ''),
              onTap: selected ? null : () => _onDataSelect(data),
            );
          },
        )
      ],
    );
  }
}

class _TabBar extends StatefulWidget {
  const _TabBar(this.length, this.index, this.builder);

  final int length;
  final int index;
  final Widget Function(TabController controller) builder;

  @override
  State<_TabBar> createState() => _TabBarState();
}

class _TabBarState extends State<_TabBar> with TickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    _controller = TabController(
        length: widget.length, vsync: this, initialIndex: widget.index);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant _TabBar oldWidget) {
    if (oldWidget.length != widget.length) {
      _controller.dispose();
      _controller = TabController(
        length: widget.length,
        vsync: this,
        initialIndex: widget.index,
      );
    } else if (widget.index != oldWidget.index) {
      _controller.index = widget.index;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(_controller);
  }
}
