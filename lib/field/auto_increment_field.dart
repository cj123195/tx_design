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

typedef AddCallback<T> = Future<T?> Function(
    BuildContext context, List<T>? data);

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
  TxAutoIncrementField({
    required IndexedFieldWidgetBuilder<T> itemBuilder,
    required AddCallback<T> onAddTap,
    ButtonStyle? addButtonStyle,
    int? maxCount,
    super.key,
    super.initialValue,
    super.decoration,
    super.focusNode,
    super.enabled,
    super.onChanged,
    super.hintText,
    super.textAlign,
  }) : super(
          builder: (field) =>
              _buildField(field, itemBuilder, onAddTap, maxCount),
        );

  /// 创建一个包含操作按钮和序号的 [ListTile] 样式的自增列表框。
  ///
  /// 默认包含一个新增和删除按钮，不可隐藏，如需隐藏请使用默认构造方法。
  TxAutoIncrementField.tile({
    required IndexedFieldWidgetBuilder<T> titleBuilder,
    required AddCallback<T> onAddTap,
    IndexedFieldWidgetBuilder<T>? subtitleBuilder,
    IndexedFieldWidgetBuilder<T>? leadingBuilder,
    IndexedPopupMenuItemsBuilder<T>? actionsBuilder,
    AutoIncrementIndexedStyle indexedStyle = AutoIncrementIndexedStyle.text,
    IconButtonThemeData? iconButtonTheme,
    ButtonStyle? addButtonStyle,
    int? minCount,
    int? maxCount,
    super.key,
    super.initialValue,
    super.decoration,
    super.focusNode,
    super.enabled,
    super.onChanged,
    super.hintText,
    super.textAlign,
  }) : super(
          builder: (field) => _buildTileField(
            field: field,
            titleBuilder: titleBuilder,
            onAddTap: onAddTap,
            subtitleBuilder: subtitleBuilder,
            leadingBuilder: leadingBuilder,
            actionsBuilder: actionsBuilder,
            indexedStyle: indexedStyle,
            iconButtonTheme: iconButtonTheme,
            addButtonStyle: addButtonStyle,
            minCount: minCount,
            maxCount: maxCount,
          ),
        );

  @override
  State<TxField<List<T>>> createState() => _TxAutoIncrementFieldState();
}

class _TxAutoIncrementFieldState<T> extends TxFieldState<List<T>> {
  @override
  bool get isEmpty => value == null || value!.isEmpty;
}

/// [builder] 为 [TxAutoIncrementField] 的 [TxFieldTile]。
class TxAutoIncrementFieldTile<T> extends TxFieldTile<List<T>> {
  TxAutoIncrementFieldTile({
    required IndexedFieldWidgetBuilder<T> itemBuilder,
    required AddCallback<T> onAddTap,
    ButtonStyle? addButtonStyle,
    int? maxCount,
    super.key,
    super.initialValue,
    super.decoration,
    super.focusNode,
    super.onChanged,
    super.labelBuilder,
    super.labelText,
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
    super.enabled,
    super.onTap,
    super.minLeadingWidth,
    super.dense,
    super.minLabelWidth,
    super.minVerticalPadding,
  }) : super(
          fieldBuilder: (field) =>
              _buildField(field, itemBuilder, onAddTap, maxCount),
        );

  TxAutoIncrementFieldTile.tile({
    required IndexedFieldWidgetBuilder<T> itemTitleBuilder,
    required AddCallback<T> onAddTap,
    IndexedFieldWidgetBuilder<T>? itemSubtitleBuilder,
    IndexedFieldWidgetBuilder<T>? itemLeadingBuilder,
    IndexedPopupMenuItemsBuilder<T>? itemActionsBuilder,
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
    super.enabled,
    super.onTap,
    super.minLeadingWidth,
    super.dense,
    super.minLabelWidth,
    super.minVerticalPadding,
  }) : super(
          fieldBuilder: (field) => _buildTileField(
            field: field,
            titleBuilder: itemTitleBuilder,
            onAddTap: onAddTap,
            subtitleBuilder: itemSubtitleBuilder,
            leadingBuilder: itemLeadingBuilder,
            actionsBuilder: itemActionsBuilder,
            indexedStyle: indexedStyle,
            iconButtonTheme: iconButtonTheme,
            addButtonStyle: addButtonStyle,
            minCount: minCount,
            maxCount: maxCount,
          ),
        );
}

Widget _buildField<T>(
  TxFieldState<List<T>> field,
  IndexedFieldWidgetBuilder<T> itemBuilder,
  AddCallback<T> onAddTap,
  int? maxCount,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisSize: MainAxisSize.min,
    children: [
      if (field.value != null)
        ...List.generate(
          field.value!.length,
          (index) => itemBuilder(
            field.context,
            index,
            field.value!,
            field.didChange,
          ),
        ),
      if (field.isEnabled &&
          (maxCount == null ||
              field.value == null ||
              field.value!.length < maxCount))
        OutlinedButton.icon(
          icon: const Icon(Icons.add),
          onPressed: () async {
            final T? newValue = await onAddTap(field.context, field.value);
            if (newValue != null) {
              field.didChange([...?field.value, newValue]);
            }
          },
          label: Text(TxLocalizations.of(field.context).addButtonLabel),
        ),
    ],
  );
}

Widget _buildTileField<T>({
  required TxFieldState<List<T>> field,
  required IndexedFieldWidgetBuilder<T> titleBuilder,
  required AddCallback<T> onAddTap,
  IndexedFieldWidgetBuilder<T>? subtitleBuilder,
  IndexedFieldWidgetBuilder<T>? leadingBuilder,
  IndexedPopupMenuItemsBuilder<T>? actionsBuilder,
  AutoIncrementIndexedStyle indexedStyle = AutoIncrementIndexedStyle.text,
  IconButtonThemeData? iconButtonTheme,
  ButtonStyle? addButtonStyle,
  int? minCount,
  int? maxCount,
}) {
  return _buildField(
    field,
    (context, index, value, didChange) {
      final TxLocalizations localization = TxLocalizations.of(context);
      final ColorScheme colorScheme = Theme.of(context).colorScheme;

      final Widget? subtitle = subtitleBuilder == null
          ? null
          : subtitleBuilder(context, index, value, didChange);

      final Widget? leading = leadingBuilder == null
          ? switch (indexedStyle) {
              AutoIncrementIndexedStyle.text => Text('${index + 1}.'),
              AutoIncrementIndexedStyle.avatar =>
                CircleAvatar(child: Text('${index + 1}')),
              AutoIncrementIndexedStyle.none => null,
            }
          : leadingBuilder(context, index, value, didChange);

      void handlerAdd() async {
        final T? newValue = await onAddTap(field.context, field.value);
        if (newValue != null) {
          value.insert(index + 1, newValue);
          didChange(value);
        }
      }

      void handlerDelete() {
        value.removeAt(index);
        didChange(value);
      }

      final bool addEnabled = maxCount == null || value.length < maxCount;
      final bool deleteEnabled = minCount == null || value.length > minCount;
      Widget trailing;
      if (actionsBuilder != null) {
        trailing = PopupMenuButton<VoidCallback>(
          itemBuilder: (context) {
            return [
              ...actionsBuilder(context, index, value, didChange),
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
        title: titleBuilder(context, index, value, didChange),
        leading: leading,
        subtitle: subtitle,
        trailing: trailing,
      );
    },
    onAddTap,
    maxCount,
  );
}
