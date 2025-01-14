import 'package:flutter/material.dart';

import '../form.dart';
import '../localizations.dart';
import 'field.dart';

/// 自增组件构造器
typedef ArrayFieldBuilder<T> = Widget? Function(
  TxFieldState<List<T>> field,
  ValueMapper<int, List<Widget>?> actionsBuilder,
);

/// 自增组件子项构造器
typedef ArrayFieldItemBuilder<T> = Widget Function(
  TxFieldState<List<T>> field,
  int index,
  T data,
  List<Widget>? actions,
);

/// 自增列表框
class TxArrayField<T> extends TxField<List<T>> {
  TxArrayField({
    required ArrayFieldBuilder<T> builder,
    required ValueMapper<int, T> defaultValue,
    ButtonStyle? addButtonStyle,
    ButtonStyle? actionsButtonStyle,
    int? limit,
    bool? sortable,
    bool? insertable,
    super.key,
    super.initialValue,
    super.decoration,
    super.focusNode,
    super.enabled,
    super.onChanged,
    super.hintText,
    super.textAlign,
    super.bordered,
    super.canRequestFocus,
    super.label,
    super.labelText,
    super.labelTextAlign,
    super.labelOverflow,
    super.padding,
    super.actionsBuilder,
    super.labelStyle,
    super.horizontalGap,
    super.tileColor,
    super.layoutDirection,
    super.trailingBuilder,
    super.leading,
    super.visualDensity,
    super.shape,
    super.iconColor,
    super.textColor,
    super.leadingAndTrailingTextStyle,
    super.onTap,
    super.minLeadingWidth,
    super.dense,
    super.colon,
    super.focusColor,
    super.minLabelWidth,
    super.minVerticalPadding,
  }) : super.decorated(
          builder: (field) => _buildField<T>(
            field,
            builder,
            defaultValue,
            addButtonStyle,
            actionsButtonStyle,
            limit,
            sortable,
            insertable,
          ),
        );

  /// 创建一个自增列表框组件
  TxArrayField.builder(
      {required ArrayFieldItemBuilder<T> itemBuilder,
      required ValueMapper<int, T> defaultValue,
      ButtonStyle? addButtonStyle,
      ButtonStyle? actionsButtonStyle,
      int? limit,
      bool? sortable,
      bool? insertable,
      super.key,
      super.initialValue,
      super.decoration,
      super.focusNode,
      super.enabled,
      super.onChanged,
      super.hintText,
      super.textAlign,
      super.bordered,
      super.canRequestFocus,
      super.label,
      super.labelText,
      super.labelTextAlign,
      super.labelOverflow,
      super.padding,
      super.actionsBuilder,
      super.labelStyle,
      super.horizontalGap,
      super.tileColor,
      super.layoutDirection,
      super.trailingBuilder,
      super.leading,
      super.visualDensity,
      super.shape,
      super.iconColor,
      super.textColor,
      super.leadingAndTrailingTextStyle,
      super.onTap,
      super.minLeadingWidth,
      super.dense,
      super.colon,
      super.focusColor,
      super.minLabelWidth,
      super.minVerticalPadding})
      : super.decorated(
          builder: (field) => _buildFieldByItem(
            field,
            itemBuilder,
            defaultValue,
            addButtonStyle,
            actionsButtonStyle,
            limit,
            sortable,
            insertable,
          ),
        );

  @override
  State<TxField<List<T>>> createState() => _TxArrayFieldState();
}

class _TxArrayFieldState<T> extends TxFieldState<List<T>> {
  @override
  bool get isEmpty => value == null || value!.isEmpty;
}

/// 构造自增组件
Widget _buildField<T>(
  TxFieldState<List<T>> field,
  ArrayFieldBuilder<T> builder,
  ValueMapper<int, T> defaultValue,
  ButtonStyle? addButtonStyle,
  ButtonStyle? actionsButtonStyle,
  int? limit,
  bool? sortable,
  bool? insertable,
) {
  final bool enabled = field.isEnabled;

  final List<T> data = field.value ?? [];
  final int count = data.length;

  // 操作按钮构造方法
  List<Widget>? buildActions(int index) {
    if (!enabled) {
      return null;
    }

    final ButtonStyle buttonStyle = IconButton.styleFrom(
            iconSize: 18.0,
            visualDensity: VisualDensity.compact,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap)
        .merge(actionsButtonStyle);

    // 删除按钮
    final Widget removeButton = IconButton(
      onPressed: () => field.didChange(data..removeAt(index)),
      icon: const Icon(Icons.delete_outline),
      style: buttonStyle,
    );

    // 插入按钮
    final Widget insertButton = IconButton(
      onPressed: () =>
          field.didChange(data..insert(index, defaultValue(index))),
      icon: const Icon(Icons.add),
      style: buttonStyle,
    );

    // 上移按钮
    final Widget moveUpButton = IconButton(
      onPressed: () {
        final item = data.removeAt(index);
        data.insert(index - 1, item);
        field.didChange(data);
      },
      icon: const Icon(Icons.move_up),
      style: buttonStyle,
    );

    // 下移按钮
    final Widget moveDownButton = IconButton(
      onPressed: () {
        final item = data.removeAt(index);
        data.insert(index + 1, item);
        field.didChange(data);
      },
      icon: const Icon(Icons.move_down),
      style: buttonStyle,
    );

    return [
      if (insertable != false) insertButton,
      removeButton,
      if (sortable != false) ...[
        if (index != 0) moveUpButton,
        if (index != field.value!.length - 1) moveDownButton,
      ],
    ];
  }

  final Widget? content = builder(field, buildActions);

  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisSize: MainAxisSize.min,
    children: [
      if (content != null) content,
      if (enabled && (limit == null || count < limit))
        OutlinedButton.icon(
          icon: const Icon(Icons.add),
          onPressed: () async {
            field.didChange([...?field.value, defaultValue(count)]);
          },
          style: addButtonStyle,
          label: Text(TxLocalizations.of(field.context).addButtonLabel),
        ),
    ],
  );
}

/// 通过自定义子项构造自增组件
Widget _buildFieldByItem<T>(
  TxFieldState<List<T>> field,
  ArrayFieldItemBuilder<T> itemBuilder,
  ValueMapper<int, T> defaultValue,
  ButtonStyle? addButtonStyle,
  ButtonStyle? actionsButtonStyle,
  int? limit,
  bool? sortable,
  bool? insertable,
) {
  return _buildField(
    field,
    (field, actionsBuilder) {
      if (field.value == null || field.value!.isEmpty) {
        return null;
      }
      return Column(
        children: List.generate(
          field.value!.length,
          (index) => itemBuilder(
            field,
            index,
            field.value![index],
            actionsBuilder(index),
          ),
        ),
      );
    },
    defaultValue,
    addButtonStyle,
    actionsButtonStyle,
    limit,
    sortable,
    insertable,
  );
}
