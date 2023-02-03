import 'package:flutter/material.dart' show BuildContext;

typedef ValueMapper<T, V> = V Function(T data);

typedef PickerFuture<T> = Future<T?>? Function(
  BuildContext context,
  T? initailValue,
);
