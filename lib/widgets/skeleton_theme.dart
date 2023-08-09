import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'skeleton.dart';

/// 定义后代 [TxSkeleton] 小部件的默认属性值。
///
/// 后代小部件使用 `TxSkeletonTheme.of(context)` 获取当前的
/// [TxSkeletonThemeData] 对象。[TxSkeletonThemeData] 的实例可以使用
/// [TxSkeletonThemeData.copyWith] 进行自定义。
///
/// 默认情况下，所有 [TxSkeletonThemeData] 属性均为“null”。 如果为 null，
/// [TxSkeleton] 将使用来自 [ThemeData] 的值（如果它们存在），否则它将提供自己的默
/// 认值。 有关详细信息，请参阅各个 [TxSkeleton] 属性。
@immutable
class TxSkeletonThemeData extends ThemeExtension<TxSkeletonThemeData>
    with Diagnosticable {
  /// 创建可用于 [ThemeData.extension<TxSkeletonThemeData>()] 的主题。
  const TxSkeletonThemeData({
    this.color,
    this.borderRadius,
  });

  final Color? color;
  final BorderRadius? borderRadius;

  /// 创建此对象的副本，但将给定字段替换为新值。
  @override
  TxSkeletonThemeData copyWith({
    Color? color,
    BorderRadius? borderRadius,
  }) {
    return TxSkeletonThemeData(
      color: color ?? this.color,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }

  @override
  int get hashCode => Object.hash(
        color,
        borderRadius,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is TxSkeletonThemeData &&
        other.color == color &&
        other.borderRadius == borderRadius;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty<Color>('color', color, defaultValue: null));
    properties.add(DiagnosticsProperty<BorderRadius>(
        'borderRadius', borderRadius,
        defaultValue: null));
  }

  @override
  ThemeExtension<TxSkeletonThemeData> lerp(
      ThemeExtension<TxSkeletonThemeData>? other, double t) {
    if (other is! TxSkeletonThemeData) {
      return this;
    }

    return TxSkeletonThemeData(
      color: Color.lerp(color, other.color, t),
      borderRadius: BorderRadius.lerp(borderRadius, other.borderRadius, t),
    );
  }
}

/// 将单选框主题应用于后代 [TxSkeleton] 小部件。
///
/// 后代小部件使用 [TxSkeletonTheme.of] 获取当前主题的 [TxSkeletonThemeData] 对象。
/// 当小部件使用 [TxSkeletonTheme.of] 时，如果主题稍后更改，它会自动重建。

class TxSkeletonTheme extends InheritedWidget {
  /// 构造一个配置所有后代 [TxSkeleton] 小部件的复选框主题。
  const TxSkeletonTheme({
    required this.data,
    required super.child,
    super.key,
  });

  /// 用于所有后代 [TxSkeleton] 小部件的属性。
  final TxSkeletonThemeData data;

  /// 从最近的 [TxSkeletonTheme] 祖先返回配置 [data]。
  ///
  /// 如果没有祖先，则返回 [ThemeData.extension<TxSkeletonThemeData>()]。
  /// 如果它也为null，则返回默认[TxSkeletonThemeData]
  static TxSkeletonThemeData of(BuildContext context) {
    final TxSkeletonTheme? expandableTextTheme =
        context.dependOnInheritedWidgetOfExactType<TxSkeletonTheme>();
    return expandableTextTheme?.data ??
        Theme.of(context).extension<TxSkeletonThemeData>() ??
        const TxSkeletonThemeData();
  }

  @override
  bool updateShouldNotify(TxSkeletonTheme oldWidget) => data != oldWidget.data;
}
