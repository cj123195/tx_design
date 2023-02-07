import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'expandable_text.dart';

int? _lerpInt(int? a, int? b, double t) {
  if (a == null && b == null) {
    return null;
  }
  if (a == null) {
    return b;
  }
  if (b == null) {
    return a;
  }
  return a + (b - a) * t.toInt();
}

/// 定义后代 [TxExpandableText] 小部件的默认属性值。
///
/// 后代小部件使用 `TxExpandableTextTheme.of(context)` 获取当前的
/// [TxExpandableTextThemeData] 对象。[TxExpandableTextThemeData] 的实例可以使用
/// [TxExpandableTextThemeData.copyWith] 进行自定义。
///
/// 默认情况下，所有 [TxExpandableTextThemeData] 属性均为“null”。 如果为 null，
/// [TxExpandableText] 将使用来自 [ThemeData] 的值（如果它们存在），否则它将提供自己的默
/// 认值。 有关详细信息，请参阅各个 [TxExpandableText] 属性。
@immutable
class TxExpandableTextThemeData
    extends ThemeExtension<TxExpandableTextThemeData> with Diagnosticable {
  /// 创建可用于 [ThemeData.extension<TxRadioThemeData>()] 的主题。
  const TxExpandableTextThemeData({
    this.collapsedLines,
    this.toggleButtonTextStyle,
  }) : assert(collapsedLines == null || collapsedLines > 0);

  final int? collapsedLines;

  final TextStyle? toggleButtonTextStyle;

  /// 创建此对象的副本，但将给定字段替换为新值。
  @override
  TxExpandableTextThemeData copyWith({
    int? collapsedLines,
    TextStyle? toggleButtonTextStyle,
  }) {
    assert(collapsedLines == null || collapsedLines > 0);

    return TxExpandableTextThemeData(
      collapsedLines: collapsedLines ?? this.collapsedLines,
      toggleButtonTextStyle:
          toggleButtonTextStyle ?? this.toggleButtonTextStyle,
    );
  }

  @override
  int get hashCode => Object.hash(
        collapsedLines,
        toggleButtonTextStyle,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is TxExpandableTextThemeData &&
        other.collapsedLines == collapsedLines &&
        other.toggleButtonTextStyle == toggleButtonTextStyle;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(IntProperty('collapsedLines', collapsedLines, defaultValue: null));
    properties.add(DiagnosticsProperty<TextStyle>(
        'toggleButtonTextStyle', toggleButtonTextStyle,
        defaultValue: null));
  }

  @override
  ThemeExtension<TxExpandableTextThemeData> lerp(
      ThemeExtension<TxExpandableTextThemeData>? other, double t) {
    if (other is! TxExpandableTextThemeData) {
      return this;
    }

    return TxExpandableTextThemeData(
      collapsedLines: _lerpInt(collapsedLines, other.collapsedLines, t),
      toggleButtonTextStyle:
          TextStyle.lerp(toggleButtonTextStyle, other.toggleButtonTextStyle, t),
    );
  }
}

/// 将单选框主题应用于后代 [TxExpandableText] 小部件。
///
/// 后代小部件使用 [TxExpandableTextTheme.of] 获取当前主题的 [TxExpandableTextThemeData] 对象。
/// 当小部件使用 [TxExpandableTextTheme.of] 时，如果主题稍后更改，它会自动重建。
///
/// 可以使用 [ThemeData.extension<TxExpandableTextTheme>()!] 将可展开文字主题指定为
/// 整个 Material主题的一部分。
class TxExpandableTextTheme extends InheritedWidget {
  /// 构造一个配置所有后代 [TxExpandableText] 小部件的复选框主题。
  const TxExpandableTextTheme({
    required this.data,
    required super.child,
    super.key,
  });

  /// 用于所有后代 [TxExpandableText] 小部件的属性。
  final TxExpandableTextThemeData data;

  /// 从最近的 [TxExpandableTextTheme] 祖先返回配置 [data]。
  ///
  /// 如果没有祖先，则返回 [ThemeData.extension<TxExpandableTextThemeData>()]。
  /// 如果它也为null，则返回默认[TxExpandableTextThemeData]
  static TxExpandableTextThemeData of(BuildContext context) {
    final TxExpandableTextTheme? expandableTextTheme =
        context.dependOnInheritedWidgetOfExactType<TxExpandableTextTheme>();
    return expandableTextTheme?.data ??
        Theme.of(context).extension<TxExpandableTextThemeData>() ??
        const TxExpandableTextThemeData();
  }

  @override
  bool updateShouldNotify(TxExpandableTextTheme oldWidget) =>
      data != oldWidget.data;
}
