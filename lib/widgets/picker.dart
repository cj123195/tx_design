import 'package:flutter/material.dart';

import '../localizations.dart';
import '../utils/basic_types.dart' show ValueMapper, DataWidgetBuilder;
import 'bottom_sheet.dart';
import 'matching_text.dart';

export '../utils/basic_types.dart' show ValueMapper, DataWidgetBuilder;

/// 选择项构造方法
typedef PickerItemBuilder<T> = Widget Function(
  BuildContext context,
  T data,
  T? selectedData,
  ValueChanged<T?> onChanged,
);

/// 两个数据是否相等的判断方法
///
/// 如果不传，默认使用 == 判断。
/// 当 T 为自定义对象时，建议传入此参数或确保 T 正确实现了 == 和 hashCode。
typedef EqualityMatcher<T> = bool Function(T a, T b);

/// 数据筛选匹配的方法
typedef FilterMatcher<T> = bool Function(T data, String query);

/// 选择器基础配置
abstract class TxPickerBase<T, D> extends StatefulWidget {
  const TxPickerBase({
    required this.source,
    required this.labelMapper,
    this.initialData,
    this.onChanged,
    this.disabledWhen,
    this.placeholder,
    this.filterMatcher,
    bool? showSearchField,
    this.listTileTheme,
    super.key,
    this.equalityMatcher,
  }) : showSearchField = showSearchField ?? source.length > 30;

  /// 数据源
  final List<T> source;

  /// 数据展示给用户的标签
  final ValueMapper<T, String?> labelMapper;

  /// 初始值
  final D? initialData;

  /// 选择变更回调
  final ValueChanged<D?>? onChanged;

  /// 数据是否可选
  final ValueMapper<T, bool>? disabledWhen;

  /// 列表项主题
  final ListTileThemeData? listTileTheme;

  /// 未选择数据时的提示组件
  final Widget? placeholder;

  /// 是否显示搜索栏
  final bool showSearchField;

  /// 自定义搜索筛选逻辑
  ///
  /// 不传时默认使用 [labelMapper] 的结果做 contains 匹配。
  final FilterMatcher<T>? filterMatcher;

  /// 自定义相等性判断，默认使用 ==
  ///
  /// 当 T 为自定义对象且未实现 == / hashCode 时，请传入此参数。
  final EqualityMatcher<T>? equalityMatcher;

  @override
  TxPickerBaseState<T, D> createState();
}

/// 选择器基础状态管理
abstract class TxPickerBaseState<T, D> extends State<TxPickerBase<T, D>> {
  TextEditingController? _searchController;

  // 查询文字
  String? get query => _searchController?.text;

  // 搜索结果缓存
  String _lastQuery = '';
  List<T>? _cachedFilterResult;

  /// 根据 query 筛选数据，带缓存
  List<T> getFilteredData(String query) {
    if (query == _lastQuery && _cachedFilterResult != null) {
      return _cachedFilterResult!;
    }
    _lastQuery = query;
    if (query.isEmpty) {
      _cachedFilterResult = widget.source;
    } else {
      final matcher = widget.filterMatcher;
      _cachedFilterResult = widget.source.where((data) {
        if (matcher != null) {
          return matcher(data, query);
        }
        return widget.labelMapper(data)?.contains(query) == true;
      }).toList();
    }
    return _cachedFilterResult!;
  }

  /// 构建选择项列表
  Widget buildPickerContent(List<T> data);

  /// 构建操作栏（可选）
  Widget? buildActionBar(List<T> data) => null;

  /// 判断两个数据是否相等
  bool isEquals(T a, T b) {
    return widget.equalityMatcher != null
        ? widget.equalityMatcher!(a, b)
        : a == b;
  }

  @override
  void initState() {
    super.initState();
    if (widget.showSearchField) {
      _searchController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _searchController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String query = _searchController?.text ?? '';
    final List<T> data =
        _searchController == null ? widget.source : getFilteredData(query);

    Widget content;
    if (data.isEmpty) {
      content = Center(
        child: widget.placeholder ?? const Text('暂无可选择的数据'),
      );
    } else {
      content = buildPickerContent(data);
      if (widget.listTileTheme != null) {
        content = ListTileTheme(data: widget.listTileTheme!, child: content);
      }
    }

    final Widget? actionBar = buildActionBar(data);

    return Column(
      children: [
        if (_searchController != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: TextField(
              controller: _searchController,
              onChanged: (val) {
                // 清除缓存，触发重建
                _cachedFilterResult = null;
                setState(() {});
              },
              decoration: const InputDecoration(
                hintText: '请输入搜索关键字',
                prefixIcon: Icon(Icons.search),
                border: InputBorder.none,
                filled: true,
              ),
            ),
          ),
        Expanded(child: content),
        if (actionBar != null) actionBar,
      ],
    );
  }
}

/// 单选选择器基础配置
abstract class TxSinglePickerBase<T> extends TxPickerBase<T, T> {
  const TxSinglePickerBase({
    required super.source,
    required super.labelMapper,
    this.itemBuilder,
    this.subtitleBuilder,
    this.secondaryBuilder,
    super.initialData,
    super.onChanged,
    super.disabledWhen,
    super.placeholder,
    super.showSearchField,
    super.filterMatcher,
    super.listTileTheme,
    super.equalityMatcher,
    super.key,
  });

  /// 选择项构造器
  final PickerItemBuilder<T>? itemBuilder;

  /// 副标题
  final DataWidgetBuilder<T>? subtitleBuilder;

  /// [RadioListTile.secondary] 构造方法
  final DataWidgetBuilder<T>? secondaryBuilder;

  @override
  TxSinglePickerBaseState<T> createState();
}

/// 单选选择器基础状态管理
abstract class TxSinglePickerBaseState<T> extends TxPickerBaseState<T, T> {
  late T? selectedData;

  @override
  TxSinglePickerBase<T> get widget => super.widget as TxSinglePickerBase<T>;

  /// 选项变更回调
  void onChanged(T? data) {
    setState(() {
      selectedData = data;
    });
    widget.onChanged?.call(selectedData);
  }

  /// 构建默认单选列表项（使用 RadioGroup + RadioListTile）
  Widget buildPickerItem(BuildContext context, T data) {
    if (widget.itemBuilder != null) {
      return widget.itemBuilder!(context, data, selectedData, onChanged);
    }

    final bool selected =
        selectedData != null && isEquals(data, selectedData as T);
    final bool enabled =
        widget.disabledWhen == null ? true : !widget.disabledWhen!(data);

    return RadioListTile<T?>(
      value: data,
      groupValue: selectedData,
      title: TxMatchingText(widget.labelMapper(data) ?? '', query: _lastQuery),
      onChanged: enabled ? (value) => onChanged(data) : null,
      subtitle: widget.subtitleBuilder == null
          ? null
          : widget.subtitleBuilder!(context, data),
      dense: true,
      selected: selected,
      contentPadding: EdgeInsets.zero,
    );
  }

  @override
  void initState() {
    selectedData = widget.initialData;
    super.initState();
  }
}

/// 单选选择器
class TxPicker<T> extends TxSinglePickerBase<T> {
  const TxPicker({
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
    super.equalityMatcher,
    super.listTileTheme,
    super.key,
  });

  @override
  TxSinglePickerBaseState<T> createState() => _TxPickerState<T>();
}

class _TxPickerState<T> extends TxSinglePickerBaseState<T> {
  @override
  TxPicker<T> get widget => super.widget as TxPicker<T>;

  @override
  Widget buildPickerContent(List<T> data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) => buildPickerItem(context, data[index]),
    );
  }

  @override
  void didUpdateWidget(covariant TxPicker<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialData != null &&
        (selectedData == null ||
            !isEquals(widget.initialData as T, selectedData as T))) {
      selectedData = widget.initialData;
    }
  }
}

/// 单选 BottomSheet
Future<T?> showPickerBottomSheet<T>(
  BuildContext context, {
  required List<T> source,
  required ValueMapper<T, String?> labelMapper,
  String? title,
  T? initialData,
  DataWidgetBuilder<T>? subtitleBuilder,
  ValueMapper<T, bool>? disabledWhen,
  PickerItemBuilder<T>? itemBuilder,
  DataWidgetBuilder<T>? secondaryBuilder,
  EqualityMatcher<T>? equalityMatcher,
  FilterMatcher<T>? filterMatcher,
  bool? isScrollControlled,
  bool? showSearchField,
  Widget? placeholder,
  ListTileThemeData? listTileTheme,
}) async {
  isScrollControlled ??= source.length > 10;
  T? data = initialData;

  final Widget content = TxPicker<T>(
    labelMapper: labelMapper,
    source: source,
    onChanged: (val) => data = val,
    subtitleBuilder: subtitleBuilder,
    itemBuilder: itemBuilder,
    secondaryBuilder: secondaryBuilder,
    initialData: data,
    disabledWhen: disabledWhen,
    showSearchField: showSearchField,
    filterMatcher: filterMatcher,
    placeholder: placeholder,
    equalityMatcher: equalityMatcher,
    listTileTheme: listTileTheme,
  );

  return showDefaultBottomSheet<T>(
    context,
    title: title ?? TxLocalizations.of(context).pickerTitle,
    contentBuilder: (context) => content,
    onConfirm: () => Navigator.pop(context, data),
    isScrollControlled: isScrollControlled,
  );
}
