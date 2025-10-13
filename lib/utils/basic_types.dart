import 'package:flutter/material.dart' show BuildContext, Widget;

/// 为给定 [T] 类型数据 生成 [V] 类型值的函数的签名。
typedef ValueMapper<T, V> = V Function(T data);

/// 为给定索引 [T] 类型数据 生成 [V] 类型值的函数的签名。
typedef IndexedValueMapper<T, V> = V Function(int index, T data);

typedef IndexedDataWidgetBuilder<T> = Widget Function(
  BuildContext context,
  int index,
  T data,
);

typedef NullableIndexedDataWidgetBuilder<T> = Widget? Function(
  BuildContext context,
  int index,
  T data,
);

typedef DataWidgetBuilder<T> = Widget Function(BuildContext context, T data);

typedef NullableDataWidgetBuilder<T> = Widget? Function(
  BuildContext context,
  T data,
);

typedef WidgetsBuilder<T> = List<Widget> Function(BuildContext context);

typedef NullableWidgetsBuilder<T> = List<Widget>? Function(
    BuildContext context);
