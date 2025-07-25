import 'package:flutter/material.dart';

import '../localizations.dart';
import '../utils/basic_types.dart' show ValueMapper, DataWidgetBuilder;
import 'bottom_sheet.dart';
import 'matching_text.dart';

export '../utils/basic_types.dart' show ValueMapper, DataWidgetBuilder;

/// 选择项构造方法x
typedef PickerItemBuilder<T> = Widget Function(
  BuildContext context,
  T data,
  T? selectedData,
  ValueChanged<T?> onChanged,
);

/// 选择器基础配置
abstract class TxPickerBase<T, D, V> extends StatefulWidget {
  TxPickerBase({
    required this.source,
    required this.labelMapper,
    this.initialData,
    this.onChanged,
    ValueMapper<T, V?>? valueMapper,
    this.subtitleBuilder,
    this.disabledWhen,
    this.placeholder,
    bool? showSearchField,
    this.listTileTheme,
    super.key,
  })  : showSearchField = showSearchField ?? source.length > 30,
        valueMapper = valueMapper ?? ((data) => data as V);

  /// 数据源
  final List<T> source;

  /// 初始值
  final D? initialData;

  /// 选择变更回调
  final ValueChanged<D?>? onChanged;

  /// 数据展示给用户的标签
  final ValueMapper<T, String?> labelMapper;

  /// 数据的值
  final ValueMapper<T, V?> valueMapper;

  /// 副标题构造器
  final DataWidgetBuilder<T>? subtitleBuilder;

  /// 数据是否可选
  final ValueMapper<T, bool>? disabledWhen;

  /// 列表项主题
  final ListTileThemeData? listTileTheme;

  /// 未选择数据时的提示组件
  final Widget? placeholder;

  /// 是否显示搜索栏
  final bool showSearchField;

  @override
  TxPickerBaseState<T, D, V> createState();
}

/// 选择器基础状态管理
abstract class TxPickerBaseState<T, D, V> extends State<TxPickerBase<T, D, V>> {
  TextEditingController? controller; // 搜索文字

  /// 筛选数据
  List<T> filterData(String query);

  /// 构建选择项
  Widget buildPickerContent(List<T> data);

  /// 构建操作栏
  Widget? buildActionBar(List<T> data) => null;

  @override
  void initState() {
    if (widget.showSearchField) {
      controller = TextEditingController();
    }
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<T> data =
        controller == null ? widget.source : filterData(controller!.text);
    Widget content;
    if (data.isEmpty) {
      content = widget.placeholder ?? const Text('暂无可选择的数据');
    } else {
      content = buildPickerContent(data);
      if (widget.listTileTheme != null) {
        content = ListTileTheme(data: widget.listTileTheme, child: content);
      }
    }

    // 操作栏
    final Widget? actionBar = buildActionBar(data);

    return Column(
      children: [
        if (controller != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: TextField(
              controller: controller,
              onChanged: (val) {
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

/// 单项选择器基础配置
abstract class TxSinglePickerBase<T, V> extends TxPickerBase<T, T, V> {
  TxSinglePickerBase({
    required super.source,
    required super.labelMapper,
    super.initialData,
    super.onChanged,
    super.valueMapper,
    super.subtitleBuilder,
    super.disabledWhen,
    super.placeholder,
    super.showSearchField,
    super.listTileTheme,
    this.itemBuilder,
    super.key,
  });

  /// 选择项构造器
  final PickerItemBuilder<T>? itemBuilder;

  @override
  TxSinglePickerBaseState<T, V> createState();
}

/// 选择器基础状态管理
abstract class TxSinglePickerBaseState<T, V>
    extends TxPickerBaseState<T, T, V> {
  late T? selectedData;

  @override
  TxSinglePickerBase<T, V> get widget =>
      super.widget as TxSinglePickerBase<T, V>;

  /// 值选择回调
  void onChanged(T? data) {
    setState(() {
      selectedData = data;
    });
    widget.onChanged?.call(selectedData);
  }

  /// 构建选择项
  Widget buildPickerItem(T data) {
    if (widget.itemBuilder != null) {
      return widget.itemBuilder!(context, data, selectedData, onChanged);
    }

    final String? label = widget.labelMapper(data);
    final V? value = widget.valueMapper(data);
    final V? selectedValue =
        selectedData == null ? null : widget.valueMapper(selectedData as T);
    final bool selected =
        selectedData != null && widget.valueMapper(selectedData as T) == value;
    final bool enabled =
        widget.disabledWhen == null ? true : !widget.disabledWhen!(data);

    return RadioListTile<V?>(
      value: value,
      groupValue: selectedValue,
      subtitle: widget.subtitleBuilder == null
          ? null
          : widget.subtitleBuilder!(context, data),
      dense: true,
      title: TxMatchingText(label ?? '', query: controller?.text),
      onChanged: enabled ? (value) => onChanged(data) : null,
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

/// 单选选择容器
class TxPicker<T, V> extends TxSinglePickerBase<T, V> {
  TxPicker({
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
    super.listTileTheme,
    super.key,
  });

  @override
  TxSinglePickerBaseState<T, V> createState() => _TxPickerState<T, V>();
}

class _TxPickerState<T, V> extends TxSinglePickerBaseState<T, V> {
  @override
  Widget buildPickerContent(List<T> data) {
    return ListView.builder(
      itemBuilder: (context, index) => buildPickerItem(data[index]),
      itemCount: data.length,
    );
  }

  @override
  List<T> filterData(String query) => widget.source
      .where((data) => widget.labelMapper(data)?.contains(query) == true)
      .toList();

  @override
  void didUpdateWidget(covariant TxPickerBase<T, T, V> oldWidget) {
    if (widget.initialData != selectedData) {
      selectedData = widget.initialData;
    }
    super.didUpdateWidget(oldWidget);
  }
}

/// 单选选择
Future<T?> showPickerBottomSheet<T, V>(
  BuildContext context, {
  required List<T> source,
  required ValueMapper<T, String?> labelMapper,
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
}) async {
  valueMapper ??= (T data) => data as V;
  isScrollControlled ??= source.length > 10;
  T? data = initialData ??
      (initialValue == null
          ? null
          : source.firstWhere((e) => valueMapper!(e) == initialValue));
  final Widget content = TxPicker<T, V>(
    labelMapper: labelMapper,
    source: source,
    onChanged: (val) => data = val,
    valueMapper: valueMapper,
    subtitleBuilder: subtitleBuilder,
    itemBuilder: itemBuilder,
    initialData: data,
    disabledWhen: disabledWhen,
    showSearchField: showSearchField,
    placeholder: placeholder,
    listTileTheme: listTileTheme,
  );
  return await showDefaultBottomSheet<T>(
    context,
    title: title ?? TxLocalizations.of(context).pickerTitle,
    contentBuilder: (context) => content,
    onConfirm: () => Navigator.pop(context, data),
    isScrollControlled: isScrollControlled,
  );
}
