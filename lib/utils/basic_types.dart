import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show BuildContext;

/// 为给定 [T] 类型数据 生成 [V] 类型值的函数的签名。
typedef ValueMapper<T, V> = V Function(T data);

/// 为给定索引 [T] 类型数据 生成 [V] 类型值的函数的签名。
typedef IndexedValueMapper<T, V> = V Function(int index, T data);

/// 数据选择的函数的签名
typedef PickerFuture<T> = Future<T?>? Function(
  BuildContext context,
  T? initailValue,
);

typedef ValueChangedForResult<T> = bool Function(T value);

typedef VoidCallbackForResult = bool Function();
