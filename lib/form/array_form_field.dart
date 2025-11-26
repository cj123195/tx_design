import 'package:flutter/material.dart';

import '../localizations.dart';
import '../utils/basic_types.dart';
import 'form_field.dart';

/// 自增组件子项构造器
typedef ArrayFormFieldItemBuilder<T> = Widget Function(
  TxFormFieldState<List<T>> field,
  int index,
  T data,
  List<Widget>? actions,
);

String? _validator<T>(
  List<T>? value,
  bool? required,
  int? limit,
  FormFieldValidator<List<T>>? validator,
) {
  if (required == true && (value == null || value.isEmpty)) {
    return '请至少添加一项';
  }
  if (limit != null && value != null && value.length > limit) {
    return '最多可添加$limit项';
  }
  if (validator != null) {
    return validator(value);
  }
  return null;
}

/// 自增组件构造器
typedef ArrayFormFieldBuilder<T> = Widget? Function(
  TxFormFieldState<List<T>> field,
  ValueMapper<int, List<Widget>?> actionsBuilder,
);

/// [builder]  构造的组件为自增列表 的 [FormField]。
class TxArrayFormField<T> extends TxFormField<List<T>> {
  TxArrayFormField({
    required ArrayFormFieldBuilder<T> builder,
    required ValueMapper<int, T> defaultValue,
    ButtonStyle? addButtonStyle,
    ButtonStyle? actionsButtonStyle,
    int? limit,
    bool? sortable,
    bool? insertable,
    super.key,
    super.onSaved,
    FormFieldValidator<List<T>>? validator,
    super.initialValue,
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    super.decoration,
    super.onChanged,
    super.required,
    super.bordered,
    FocusNode? focusNode,
    String? hintText,
    TextAlign? textAlign,
    super.label,
    super.labelText,
    super.labelTextAlign,
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
    super.minLeadingWidth,
    super.dense,
    super.colon,
    super.minLabelWidth,
    super.focusColor,
    super.minVerticalPadding,
  }) : super(
          builder: (field) => _buildFormField<T>(
            field,
            builder,
            defaultValue,
            addButtonStyle,
            actionsButtonStyle,
            limit,
            sortable,
            insertable,
          ),
          validator: (val) => _validator(val, required, limit, validator),
        );

  /// 通过自增子项构造一个自增 Form 组件
  TxArrayFormField.builder({
    required ArrayFormFieldItemBuilder<T> itemBuilder,
    required ValueMapper<int, T> defaultValue,
    ButtonStyle? addButtonStyle,
    ButtonStyle? actionsButtonStyle,
    int? limit,
    bool? sortable,
    bool? insertable,
    FocusNode? focusNode,
    String? hintText,
    TextAlign? textAlign,
    super.key,
    super.onSaved,
    FormFieldValidator<List<T>>? validator,
    super.initialValue,
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    super.decoration,
    super.onChanged,
    super.required,
    super.label,
    super.labelText,
    super.labelTextAlign,
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
    super.minLeadingWidth,
    super.dense,
    super.colon,
    super.minLabelWidth,
    super.focusColor,
    super.minVerticalPadding,
  }) : super(
          builder: (field) => _buildFormFieldByItem(
            field,
            itemBuilder,
            defaultValue,
            addButtonStyle,
            actionsButtonStyle,
            limit,
            sortable,
            insertable,
          ),
          validator: (val) => _validator(val, required, limit, validator),
        );
}

/// 构造自增组件
Widget _buildFormField<T>(
  TxFormFieldState<List<T>> field,
  ArrayFormFieldBuilder<T> builder,
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
Widget _buildFormFieldByItem<T>(
  TxFormFieldState<List<T>> field,
  ArrayFormFieldItemBuilder<T> itemBuilder,
  ValueMapper<int, T> defaultValue,
  ButtonStyle? addButtonStyle,
  ButtonStyle? actionsButtonStyle,
  int? limit,
  bool? sortable,
  bool? insertable,
) {
  return _buildFormField(
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
