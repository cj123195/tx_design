import 'package:flutter/material.dart' show BuildContext, VoidCallback, Widget;

typedef ValueMapper<T, V> = V Function(T data);

typedef PickerFuture<T> = Future<T?>? Function(
  BuildContext context,
  T? initailValue,
);

typedef ValueChangedForResult<T> = bool Function(T value);

typedef VoidCallbackForResult = bool Function();

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

typedef SelectableWidgetBuilder<T> = Widget Function(
  BuildContext context,
  int index,
  T data,
  bool selected,
  VoidCallback? onSelect,
);
