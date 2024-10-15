import 'package:flutter/material.dart';

import '../localizations.dart';
import 'field.dart';
import 'field_tile.dart';

typedef IndexedFieldWidgetBuilder<T> = Widget Function(
  BuildContext context,
  int index,
  List<T> dataList,
  ValueChanged<List<T>?> didChange,
);

typedef IndexedPopupMenuItemsBuilder<T> = List<PopupMenuItem<VoidCallback>>
    Function(
  BuildContext context,
  int index,
  List<T> dataList,
  ValueChanged<List<T>?> didChange,
);

/// 自增序号样式
enum AutoIncrementIndexedStyle {
  /// 文字样式
  text,

  /// 序号展示为一个头像样式
  avatar,

  /// 不显示自增序号
  none,
}

/// 自增列表框
class TxAutoIncrementField<T> extends TxField<List<T>> {
  /// 创建一个自增列表框组件
  const TxAutoIncrementField({
    required this.itemBuilder,
    required this.defaultValue,
    this.addButtonStyle,
    this.maxCount,
    super.key,
    super.initialValue,
    super.decoration,
    super.focusNode,
    super.enabled,
    super.onChanged,
  });

  /// 创建一个包含操作按钮和序号的 [ListTile] 样式的自增列表框。
  ///
  /// 默认包含一个新增和删除按钮，不可隐藏，如需隐藏请使用默认构造方法自定义 [itemBuilder]。
  TxAutoIncrementField.tile({
    required IndexedFieldWidgetBuilder<T> titleBuilder,
    required this.defaultValue,
    IndexedFieldWidgetBuilder<T>? subtitleBuilder,
    IndexedFieldWidgetBuilder<T>? leadingBuilder,
    IndexedPopupMenuItemsBuilder<T>? actionsBuilder,
    AutoIncrementIndexedStyle indexedStyle = AutoIncrementIndexedStyle.text,
    IconButtonThemeData? iconButtonTheme,
    this.addButtonStyle,
    int? minCount,
    this.maxCount,
    super.key,
    super.initialValue,
    super.decoration,
    super.focusNode,
    super.enabled,
    super.onChanged,
  }) : itemBuilder = ((context, index, list, change) {
          final TxLocalizations localization = TxLocalizations.of(context);
          final ColorScheme colorScheme = Theme.of(context).colorScheme;

          final Widget? subtitle = subtitleBuilder == null
              ? null
              : subtitleBuilder(context, index, list, change);

          final Widget? leading = leadingBuilder == null
              ? switch (indexedStyle) {
                  AutoIncrementIndexedStyle.text => Text('${index + 1}.'),
                  AutoIncrementIndexedStyle.avatar =>
                    CircleAvatar(child: Text('${index + 1}')),
                  AutoIncrementIndexedStyle.none => null,
                }
              : leadingBuilder(context, index, list, change);

          void handlerAdd() {
            list.insert(index + 1, defaultValue);
            change(list);
          }

          void handlerDelete() {
            list.removeAt(index);
            change(list);
          }

          final bool addEnabled = maxCount == null || list.length < maxCount;
          final bool deleteEnabled = minCount == null || list.length > minCount;
          Widget trailing;
          if (actionsBuilder != null) {
            trailing = PopupMenuButton<VoidCallback>(
              itemBuilder: (context) {
                return [
                  ...actionsBuilder(context, index, list, change),
                  if (addEnabled)
                    PopupMenuItem(
                      value: handlerAdd,
                      child: Text(localization.addButtonLabel),
                    ),
                  if (deleteEnabled)
                    PopupMenuItem(
                      value: handlerDelete,
                      child: Text(localization.removeButtonLabel),
                    )
                ];
              },
            );
          } else {
            iconButtonTheme ??= IconButtonThemeData(
              style: IconButton.styleFrom(
                visualDensity: const VisualDensity(
                  horizontal: VisualDensity.minimumDensity,
                  vertical: VisualDensity.maximumDensity,
                ),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            );
            trailing = IconButtonTheme(
              data: iconButtonTheme!,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: deleteEnabled ? handlerDelete : null,
                    icon: const Icon(Icons.remove),
                    tooltip: localization.removeButtonLabel,
                    color: colorScheme.error,
                  ),
                  IconButton(
                    onPressed: addEnabled ? handlerAdd : null,
                    icon: const Icon(Icons.add),
                    tooltip: localization.addButtonLabel,
                    color: colorScheme.primary,
                  ),
                ],
              ),
            );
          }

          return ListTile(
            contentPadding: EdgeInsets.zero,
            title: titleBuilder(context, index, list, change),
            leading: leading,
            subtitle: subtitle,
            trailing: trailing,
          );
        });

  /// 自增列表项构造方法
  final IndexedFieldWidgetBuilder<T> itemBuilder;

  /// 数据默认值
  final T defaultValue;

  /// 新增按钮组件样式
  ///
  /// 默认值为 OutlinedButton.styleForm
  final ButtonStyle? addButtonStyle;

  /// 最大数量
  final int? maxCount;

  @override
  State<TxField<List<T>>> createState() => _TxAutoIncrementFieldState();
}

class _TxAutoIncrementFieldState<T> extends TxFieldState<List<T>> {
  List<T> get _value => value ?? <T>[];

  bool get isEmpty => value == null;

  FocusNode? _focusNode;

  FocusNode get _effectiveFocusNode =>
      widget.focusNode ?? (_focusNode ??= FocusNode());

  bool get _isAddButtonVisible =>
      widget.enabled != false &&
      (widget.maxCount == null || _value.length < widget.maxCount!);

  /// 选择项变更回调
  @override
  void didChange(List<T>? value) {
    if ((widget.focusNode ?? _focusNode)?.hasFocus != true) {
      (widget.focusNode ?? _focusNode)?.requestFocus();
    }

    super.didChange(value);

    setState(() {});
  }

  void _handleFocusChanged() {
    setState(() {
      // Rebuild the widget on focus change to show/hide the text selection
      // highlight.
    });
  }

  @override
  void didUpdateWidget(covariant TxAutoIncrementField<T> oldWidget) {
    if (widget.focusNode != oldWidget.focusNode) {
      (oldWidget.focusNode ?? _focusNode)?.removeListener(_handleFocusChanged);
      (widget.focusNode ?? _focusNode)?.addListener(_handleFocusChanged);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _focusNode?.unfocus();
    super.dispose();
  }

  @override
  TxAutoIncrementField<T> get widget => super.widget as TxAutoIncrementField<T>;

  @override
  Widget build(BuildContext context) {
    final FocusNode focusNode = _effectiveFocusNode;

    Widget child = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(
          _value.length,
          (index) => widget.itemBuilder(context, index, _value, didChange),
        ),
        if (_isAddButtonVisible)
          OutlinedButton.icon(
            icon: const Icon(Icons.add),
            onPressed: () => didChange([..._value, widget.defaultValue]),
            label: Text(TxLocalizations.of(context).addButtonLabel),
          ),
      ],
    );

    if (widget.decoration != null) {
      child = InputDecorator(
        decoration: effectiveDecoration,
        isFocused: focusNode.hasFocus,
        isEmpty: isEmpty,
        child: child,
      );
    }

    return Focus(focusNode: focusNode, child: child);
  }

  @override
  String? get defaultHintText => null;
}

/// [field] 为 [TxAutoIncrementField] 的 [TxFieldTile]。
class TxAutoIncrementFieldTile<T> extends TxFieldTile {
  TxAutoIncrementFieldTile({
    required IndexedFieldWidgetBuilder<T> itemBuilder,
    required T defaultValue,
    ButtonStyle? addButtonStyle,
    int? maxCount,
    super.key,
    List<T>? initialValue,
    InputDecoration? decoration,
    FocusNode? focusNode,
    ValueChanged<List<T>?>? onChanged,
    super.labelBuilder,
    super.labelText,
    super.padding,
    super.actions,
    super.labelStyle,
    super.horizontalGap,
    super.tileColor,
    super.layoutDirection,
    super.trailing,
    super.leading,
    super.visualDensity,
    super.shape,
    super.iconColor,
    super.textColor,
    super.leadingAndTrailingTextStyle,
    super.enabled,
    super.onTap,
    super.minLeadingWidth,
    super.dense,
    super.minLabelWidth,
    super.minVerticalPadding,
  }) : super(
          field: TxAutoIncrementField<T>(
            itemBuilder: itemBuilder,
            defaultValue: defaultValue,
            addButtonStyle: addButtonStyle,
            maxCount: maxCount,
            initialValue: initialValue,
            decoration: decoration,
            focusNode: focusNode,
            onChanged: onChanged,
            enabled: enabled,
          ),
        );

  TxAutoIncrementFieldTile.tile({
    required IndexedFieldWidgetBuilder<T> titleBuilder,
    required T defaultValue,
    IndexedFieldWidgetBuilder<T>? subtitleBuilder,
    IndexedFieldWidgetBuilder<T>? leadingBuilder,
    IndexedPopupMenuItemsBuilder<T>? actionsBuilder,
    AutoIncrementIndexedStyle indexedStyle = AutoIncrementIndexedStyle.text,
    IconButtonThemeData? iconButtonTheme,
    ButtonStyle? addButtonStyle,
    int? minCount,
    int? maxCount,
    super.key,
    List<T>? initialValue,
    InputDecoration? decoration,
    FocusNode? focusNode,
    ValueChanged<List<T?>?>? onChanged,
    super.labelBuilder,
    super.labelText,
    super.padding,
    super.actions,
    super.labelStyle,
    super.horizontalGap,
    super.tileColor,
    super.layoutDirection,
    super.trailing,
    super.leading,
    super.visualDensity,
    super.shape,
    super.iconColor,
    super.textColor,
    super.leadingAndTrailingTextStyle,
    super.enabled,
    super.onTap,
    super.minLeadingWidth,
    super.dense,
    super.minLabelWidth,
    super.minVerticalPadding,
  }) : super(
          field: TxAutoIncrementField<T>.tile(
            titleBuilder: titleBuilder,
            subtitleBuilder: subtitleBuilder,
            leadingBuilder: leadingBuilder,
            actionsBuilder: actionsBuilder,
            indexedStyle: indexedStyle,
            iconButtonTheme: iconButtonTheme,
            defaultValue: defaultValue,
            addButtonStyle: addButtonStyle,
            minCount: minCount,
            maxCount: maxCount,
            initialValue: initialValue,
            decoration: decoration,
            focusNode: focusNode,
            onChanged: onChanged,
            enabled: enabled,
          ),
        );
}
