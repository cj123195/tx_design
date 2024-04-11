import 'package:flutter/material.dart';

import 'top_sheet.dart';

/// 与 [TopSheetTheme] 一起使用来定义后代 [TopSheet] 小部件的默认属性值。
///
/// 有关详细信息，请参阅各个 [TopSheet] 属性。
class TopSheetThemeData extends ThemeExtension<TopSheetThemeData> {
  const TopSheetThemeData({this.data});

  /// 覆盖 [TopSheet] 其它属性默认值
  final BottomSheetThemeData? data;

  @override
  ThemeExtension<TopSheetThemeData> copyWith({
    BottomSheetThemeData? data,
  }) {
    return TopSheetThemeData(data: data ?? this.data);
  }

  @override
  ThemeExtension<TopSheetThemeData> lerp(
    covariant ThemeExtension<TopSheetThemeData>? other,
    double t,
  ) {
    if (other is! TopSheetThemeData) {
      return this;
    }

    return TopSheetThemeData(
      data: BottomSheetThemeData.lerp(data, other.data, t),
    );
  }
}

/// 一个继承的小部件，它在此小部件的子树中定义 [TopSheet] 的颜色和样式参数。
///
/// 此处指定的值用于未指定显式非空值的 [TopSheet] 属性。
class TopSheetTheme extends InheritedWidget {
  /// 创建一个操作按钮栏主题，该主题定义后代 [TopSheet] 的颜色和样式参数。
  const TopSheetTheme({
    required super.child,
    required this.data,
    super.key,
  });

  final TopSheetThemeData data;

  /// 包含给定上下文的此类的最近实例的 [data] 属性。
  ///
  /// 如果没有祖先，则返回 [ThemeData.extension<TopSheetThemeData>()]。
  /// 如果它也为null，则返回默认[TopSheetThemeData]
  static TopSheetThemeData of(BuildContext context) {
    final TopSheetTheme? topSheetTheme =
        context.dependOnInheritedWidgetOfExactType<TopSheetTheme>();
    return topSheetTheme?.data ??
        Theme.of(context).extension<TopSheetThemeData>() ??
        const TopSheetThemeData();
  }

  @override
  bool updateShouldNotify(TopSheetTheme oldWidget) => data != oldWidget.data;
}
