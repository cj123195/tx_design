import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'image_picker.dart';

int? _lerpInt(num? a, num? b, double t) {
  if (a == b || (a?.isNaN ?? false) && (b?.isNaN ?? false)) {
    return a?.toInt();
  }
  a ??= 0.0;
  b ??= 0.0;
  assert(a.isFinite, 'Cannot interpolate between finite and non-finite values');
  assert(b.isFinite, 'Cannot interpolate between finite and non-finite values');
  assert(t.isFinite, 't must be finite when interpolating between values');
  return (a + (b - a) * t).toInt();
}

/// 定义后代 [TxImagePickerView] 小部件的默认属性值。
///
/// 后代小部件使用 `TxImagePickerViewTheme.of(context)` 获取当前的
/// [TxImagePickerViewThemeData]对象。[TxImagePickerViewThemeData] 的实例可以使用
/// [TxImagePickerViewThemeData.copyWith] 进行自定义。
///
/// 默认情况下，所有 [TxImagePickerViewThemeData] 属性均为“null”。 如果为 null，
/// [TxImagePickerView] 将使用 来自 [ThemeData] 的值（如果它们存在），否则它将根据整体
/// [Theme] 的 colorScheme 提供自己的默认值。 有关详细信息，请参阅各个 [TxImagePickerView] 属性。
@immutable
class TxImagePickerViewThemeData
    extends ThemeExtension<TxImagePickerViewThemeData> with Diagnosticable {
  /// 创建可用于 [ThemeData.extension<TxImagePickerViewThemeData>()] 的主题。
  const TxImagePickerViewThemeData({
    this.draggable,
    this.columnNumber,
    this.gap,
    this.contentPadding,
    this.deleteButtonColor,
    this.deleteButtonSize,
    this.pickButtonBackground,
    this.pickButtonForeground,
    this.pickIconSize,
    this.borderRadius,
    this.itemPadding,
    this.emptyButtonTitle,
    this.disabledEmptyTitle,
  });

  /// 如果指定，则覆盖[TxImagePickerView.columnNumber]的默认值。
  final int? columnNumber;

  /// 如果指定，则覆盖[TxImagePickerView.draggable]的默认值。
  final bool? draggable;

  /// 如果指定，则覆盖[TxImagePickerView.gap]的默认值。
  final double? gap;

  /// 如果指定，则覆盖[TxImagePickerView.contentPadding]的默认值。
  final EdgeInsetsGeometry? contentPadding;

  /// 如果指定，则覆盖[TxImagePickerView.deleteButtonColor]的默认值。
  final Color? deleteButtonColor;

  /// 如果指定，则覆盖[TxImagePickerView.deleteButtonSize]的默认值。
  final double? deleteButtonSize;

  /// 如果指定，则覆盖[TxImagePickerView.pickButtonBackground]的默认值。
  final Color? pickButtonBackground;

  /// 如果指定，则覆盖[TxImagePickerView.pickButtonForeground]的默认值。
  final Color? pickButtonForeground;

  /// 如果指定，则覆盖[TxImagePickerView.pickIconSize]的默认值。
  final double? pickIconSize;

  /// 如果指定，则覆盖[TxImagePickerView.borderRadius]的默认值。
  final BorderRadius? borderRadius;

  /// 如果指定，则覆盖[TxImagePickerView.itemPadding]的默认值。
  final EdgeInsetsGeometry? itemPadding;

  /// 如果指定，则覆盖[TxImagePickerView.emptyButtonTitle]的默认值。
  final String? emptyButtonTitle;

  /// 如果指定，则覆盖[TxImagePickerView.disabledEmptyTitle]的默认值。
  final String? disabledEmptyTitle;

  /// 创建此对象的副本，但将给定字段替换为新值。
  @override
  TxImagePickerViewThemeData copyWith({
    int? columnNumber,
    bool? draggable,
    double? gap,
    EdgeInsetsGeometry? contentPadding,
    Color? deleteButtonColor,
    double? deleteButtonSize,
    Color? pickButtonBackground,
    Color? pickButtonForeground,
    double? pickIconSize,
    BorderRadius? borderRadius,
    EdgeInsetsGeometry? itemPadding,
    String? emptyButtonTitle,
    String? disabledEmptyTitle,
  }) {
    return TxImagePickerViewThemeData(
      columnNumber: columnNumber ?? this.columnNumber,
      draggable: draggable,
      gap: gap ?? this.gap,
      contentPadding: contentPadding ?? this.contentPadding,
      deleteButtonColor: deleteButtonColor ?? this.deleteButtonColor,
      deleteButtonSize: deleteButtonSize ?? this.deleteButtonSize,
      pickButtonBackground: pickButtonBackground ?? this.pickButtonBackground,
      pickButtonForeground: pickButtonForeground ?? this.pickButtonForeground,
      pickIconSize: pickIconSize ?? this.pickIconSize,
      borderRadius: borderRadius ?? this.borderRadius,
      itemPadding: itemPadding ?? this.itemPadding,
      emptyButtonTitle: emptyButtonTitle ?? this.emptyButtonTitle,
      disabledEmptyTitle: disabledEmptyTitle ?? this.disabledEmptyTitle,
    );
  }

  @override
  int get hashCode => Object.hash(
        columnNumber,
        draggable,
        gap,
        contentPadding,
        deleteButtonColor,
        deleteButtonSize,
        pickButtonBackground,
        pickButtonForeground,
        pickIconSize,
        borderRadius,
        itemPadding,
        emptyButtonTitle,
        disabledEmptyTitle,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is TxImagePickerViewThemeData &&
        other.columnNumber == columnNumber &&
        other.draggable == draggable &&
        other.gap == gap &&
        other.contentPadding == contentPadding &&
        other.deleteButtonColor == deleteButtonColor &&
        other.deleteButtonSize == deleteButtonSize &&
        other.pickButtonBackground == pickButtonBackground &&
        other.pickButtonForeground == pickButtonForeground &&
        other.pickIconSize == pickIconSize &&
        other.borderRadius == borderRadius &&
        other.itemPadding == itemPadding &&
        other.emptyButtonTitle == emptyButtonTitle &&
        other.disabledEmptyTitle == disabledEmptyTitle;
  }

  @override
  ThemeExtension<TxImagePickerViewThemeData> lerp(
      ThemeExtension<TxImagePickerViewThemeData>? other, double t) {
    if (other is! TxImagePickerViewThemeData) {
      return this;
    }

    return TxImagePickerViewThemeData(
      draggable: t < 0.5 ? draggable : other.draggable,
      emptyButtonTitle: t < 0.5 ? emptyButtonTitle : other.emptyButtonTitle,
      disabledEmptyTitle:
          t < 0.5 ? disabledEmptyTitle : other.disabledEmptyTitle,
      columnNumber: _lerpInt(columnNumber, other.columnNumber, t),
      gap: lerpDouble(gap, other.gap, t),
      contentPadding:
          EdgeInsetsGeometry.lerp(contentPadding, other.contentPadding, t),
      deleteButtonColor:
          Color.lerp(deleteButtonColor, other.deleteButtonColor, t),
      deleteButtonSize: lerpDouble(deleteButtonSize, other.deleteButtonSize, t),
      pickButtonBackground:
          Color.lerp(pickButtonBackground, other.pickButtonBackground, t),
      pickButtonForeground:
          Color.lerp(pickButtonForeground, other.pickButtonForeground, t),
      pickIconSize: lerpDouble(pickIconSize, other.pickIconSize, t),
      borderRadius: BorderRadius.lerp(borderRadius, other.borderRadius, t),
      itemPadding: EdgeInsetsGeometry.lerp(itemPadding, other.itemPadding, t),
    );
  }
}

/// 将单选框主题应用于后代 [TxImagePickerView] 小部件。
///
/// 后代小部件使用 [TxImagePickerViewTheme.of] 获取当前主题的 [TxImagePickerViewTheme] 对象。
/// 当小部件使用 [TxImagePickerViewTheme.of] 时，如果主题稍后更改，它会自动重建。
///
/// 可以使用 [ThemeData.extension<TxImagePickerViewTheme>()!] 将单选框主题指定为整个 Material
/// 主题的一部分。
class TxImagePickerViewTheme extends InheritedWidget {
  /// 构造一个配置所有后代 [TxImagePickerView] 小部件的图片集主题。
  const TxImagePickerViewTheme({
    required this.data,
    required super.child,
    super.key,
  });

  /// 用于所有后代 [TxImagePickerView] 小部件的属性。
  final TxImagePickerViewThemeData data;

  /// 从最近的 [TxImagePickerViewTheme] 祖先返回配置 [data]。
  ///
  /// 如果没有祖先，则返回 [ThemeData.extension<TxImagePickerViewThemeData>()]；
  /// 如果它也为null，则返回默认[TxImagePickerViewThemeData]
  static TxImagePickerViewThemeData of(BuildContext context) {
    final TxImagePickerViewTheme? radioTheme =
        context.dependOnInheritedWidgetOfExactType<TxImagePickerViewTheme>();
    return radioTheme?.data ??
        Theme.of(context).extension<TxImagePickerViewThemeData>() ??
        const TxImagePickerViewThemeData();
  }

  @override
  bool updateShouldNotify(TxImagePickerViewTheme oldWidget) =>
      data != oldWidget.data;
}
