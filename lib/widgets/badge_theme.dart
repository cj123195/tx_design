import 'package:flutter/material.dart';

import 'badge.dart';

/// 与 [TxBadgeTheme] 一起使用来定义后代 [TxBadge] 小部件的默认属性值。
///
/// 有关详细信息，请参阅各个 [TxBadge] 属性。
@Deprecated(
  '请使用 TxTagThemeData 替代。 '
  'This will be removed in the next major version.',
)
class TxBadgeThemeData extends ThemeExtension<TxBadgeThemeData> {
  @Deprecated(
    '请使用 TxTagThemeData 替代。 '
    'This will be removed in the next major version.',
  )
  const TxBadgeThemeData({this.shape, this.badgeTheme});

  /// 覆盖 [TxBadge.shape] 的默认值。
  final ShapeBorder? shape;

  /// 覆盖 [TxBadge] 其它属性默认值
  final BadgeThemeData? badgeTheme;

  @override
  ThemeExtension<TxBadgeThemeData> copyWith({
    ShapeBorder? shape,
    BadgeThemeData? badgeTheme,
  }) {
    return TxBadgeThemeData(
      shape: shape ?? this.shape,
      badgeTheme: badgeTheme ?? this.badgeTheme,
    );
  }

  @override
  ThemeExtension<TxBadgeThemeData> lerp(
    covariant ThemeExtension<TxBadgeThemeData>? other,
    double t,
  ) {
    if (other is! TxBadgeThemeData) {
      return this;
    }

    return TxBadgeThemeData(
      shape: ShapeBorder.lerp(shape, other.shape, t),
      badgeTheme: BadgeThemeData.lerp(badgeTheme, other.badgeTheme, t),
    );
  }
}

/// 一个继承的小部件，它在此小部件的子树中定义 [TxBadge] 的颜色和样式参数。
///
/// 此处指定的值用于未指定显式非空值的 [TxBadge] 属性。
@Deprecated(
  '请使用 TxTagTheme 替代。 '
  'This will be removed in the next major version.',
)
class TxBadgeTheme extends InheritedWidget {
  /// 创建一个操作按钮栏主题，该主题定义后代 [TxBadge] 的颜色和样式参数。
  @Deprecated(
    '请使用 TxTagTheme 替代。 '
    'This will be removed in the next major version.',
  )
  const TxBadgeTheme({
    required super.child,
    required this.data,
    super.key,
  });

  final TxBadgeThemeData data;

  /// 包含给定上下文的此类的最近实例的 [data] 属性。
  ///
  /// 如果没有祖先，则返回 [ThemeData.extension<TxBadgeThemeData>()]。
  /// 如果它也为null，则返回默认[TxBadgeThemeData]
  static TxBadgeThemeData of(BuildContext context) {
    final TxBadgeTheme? badgeTheme =
        context.dependOnInheritedWidgetOfExactType<TxBadgeTheme>();
    return badgeTheme?.data ??
        Theme.of(context).extension<TxBadgeThemeData>() ??
        const TxBadgeThemeData();
  }

  @override
  bool updateShouldNotify(TxBadgeTheme oldWidget) => data != oldWidget.data;
}
