import 'package:flutter/material.dart';

import '../theme_extensions/spacing.dart';
import 'status_indicator_theme.dart';

/// 状态指示器组件
///
/// 通常用于显示某种状态
class TxStatusIndicator extends StatelessWidget {
  const TxStatusIndicator({
    this.indicatorColor,
    super.key,
    this.indicatorSize,
    this.label,
    this.labelColor,
    this.labelStyle,
  });

  /// 指示器颜色
  final Color? indicatorColor;

  /// 指示器大小
  final double? indicatorSize;

  /// 指示器描述
  final Widget? label;

  /// 指示器描述文字颜色
  final Color? labelColor;

  ///指示器描述文字样式
  final TextStyle? labelStyle;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TxStatusIndicatorThemeData indicatorTheme =
        TxStatusIndicatorTheme.of(context);

    final Color effectiveIndicatorColor = indicatorColor ??
        indicatorTheme.indicatorColor ??
        theme.colorScheme.primary;
    final double effectiveIndicatorSize =
        indicatorSize ?? indicatorTheme.indicatorSize ?? 4.0;
    final Widget indicator = DecoratedBox(
      decoration: BoxDecoration(
        color: effectiveIndicatorColor,
        shape: BoxShape.circle,
      ),
      child: SizedBox.square(dimension: effectiveIndicatorSize),
    );

    if (label == null) {
      return indicator;
    }

    final TextStyle textStyle = labelStyle ??
        indicatorTheme.labelStyle ??
        Theme.of(context).textTheme.labelSmall!;
    final Color? effectiveLabelColor = labelColor ?? indicatorTheme.labelColor;
    final Widget effectiveLabel = Container(
      margin: EdgeInsets.only(left: SpacingTheme.of(context).mini),
      child: DefaultTextStyle(
        style: textStyle.copyWith(color: effectiveLabelColor),
        child: label!,
      ),
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[indicator, effectiveLabel],
    );
  }
}
