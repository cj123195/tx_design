import 'package:flutter/material.dart';

import '../localizations.dart';
import 'loading_theme.dart';
import 'shimmer.dart';

const IconThemeData _kIconTheme = IconThemeData(size: 36.0, weight: 500);
const Duration _kPeriod = Duration(milliseconds: 1500);
const ShimmerDirection _kDirection = ShimmerDirection.ltr;

/// 一个提供加载样式的小部件
class TxLoading extends StatelessWidget {
  /// 创建一个加载组件
  const TxLoading({
    this.child,
    super.key,
    this.textStyle,
    this.iconTheme,
    this.gradient,
    this.period,
    this.direction,
  });

  TxLoading.fromColors({
    required Color baseColor,
    required Color highlightColor,
    this.child,
    super.key,
    this.textStyle,
    this.iconTheme,
    this.period,
    this.direction,
  }) : gradient = LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.centerRight,
            colors: <Color>[
              baseColor,
              baseColor,
              highlightColor,
              baseColor,
              baseColor
            ],
            stops: const <double>[
              0.0,
              0.35,
              0.5,
              0.65,
              1.0
            ]);

  /// 在树中此小部件下方的小部件
  final Widget? child;

  /// 文字样式
  final TextStyle? textStyle;

  /// 图标样式
  final IconThemeData? iconTheme;

  /// 动画时间
  final Duration? period;

  /// 方向
  final ShimmerDirection? direction;

  /// 渐变色
  final Gradient? gradient;

  Gradient _kGradient(Brightness brightness) {
    Color baseColor;
    Color highlightColor;
    if (brightness == Brightness.light) {
      baseColor = Colors.grey;
      highlightColor = Colors.grey.withOpacity(0.5);
    } else {
      baseColor = Colors.white12;
      highlightColor = Colors.white70;
    }
    return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.centerRight,
        colors: <Color>[
          baseColor,
          baseColor,
          highlightColor,
          baseColor,
          baseColor
        ],
        stops: const <double>[
          0.0,
          0.35,
          0.5,
          0.65,
          1.0
        ]);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TxLoadingThemeData loadingTheme = TxLoadingTheme.of(context);

    final Widget child = this.child ??
        loadingTheme.child ??
        Text(TxLocalizations.of(context).loadingLabel);
    final TextStyle textStyle =
        this.textStyle ?? loadingTheme.textStyle ?? theme.textTheme.titleLarge!;
    final IconThemeData iconTheme =
        this.iconTheme ?? loadingTheme.iconTheme ?? _kIconTheme;
    final Duration duration = period ?? loadingTheme.period ?? _kPeriod;
    final ShimmerDirection direction =
        this.direction ?? loadingTheme.direction ?? _kDirection;
    final Gradient gradient = this.gradient ??
        loadingTheme.gradient ??
        _kGradient(theme.colorScheme.brightness);

    return Center(
      child: TxShimmer(
        gradient: gradient,
        period: duration,
        direction: direction,
        child: DefaultTextStyle(
          style: textStyle,
          child: IconTheme(data: iconTheme, child: child),
        ),
      ),
    );
  }
}
