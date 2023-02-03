import 'package:flutter/material.dart';

import '../paintings/border.dart';
import '../paintings/border_side.dart';

/// 一条细水平线，两边都有填充。
///
/// 相比于[Divider]增加了虚线配置。
///
/// 详细信息参考[Divider]
class TxDivider extends Divider {
  /// 创建一个 Material Design 水平分隔线。
  ///
  /// [height]、[thickness]、[indent] 和 [endIndent] 必须为 null 或非负数。
  const TxDivider({
    super.key,
    super.height,
    super.thickness,
    super.indent,
    super.endIndent,
    super.color,
    this.dashPattern,
    this.gradient,
  });

  /// 虚线格式
  ///
  /// 参考[TxBorderSide.dashPattern]
  final List<double>? dashPattern;

  /// 渐变色
  ///
  /// 参考[TxBorderSide.gradient]
  final LinearGradient? gradient;

  /// 计算表示分隔线的 [TxBorderSide]。
  ///
  /// 如果 [color] 为空，则使用 [DividerThemeData.color]。 如果它也为 null，则使用
  /// [ThemeData.dividerColor]。
  ///
  /// 如果 [width] 为 null，则使用 [DividerThemeData.thickness]。 如果它也为 null，
  /// 则默认为 0.0（细线边框）。
  ///
  /// /// 如果[context] 为null，则使用[BorderSide] 的默认颜色，并使用0.0 的默认宽度。
  static TxBorderSide createBorderSide(
    BuildContext? context, {
    Color? color,
    double? width,
    List<double>? dashPattern,
    LinearGradient? gradient,
  }) {
    Color? effectiveColor;
    if (gradient == null) {
      effectiveColor = color ??
          (context != null
              ? (DividerTheme.of(context).color ??
                  Theme.of(context).dividerColor)
              : null);
    }
    final double effectiveWidth = width ??
        (context != null ? DividerTheme.of(context).thickness : null) ??
        0.0;

    // 防止断言，因为上下文可能为空且未指定颜色。
    if (effectiveColor == null) {
      return TxBorderSide(
        gradient: gradient,
        dashPattern: dashPattern,
        width: effectiveWidth,
      );
    }
    return TxBorderSide(
      color: effectiveColor,
      width: effectiveWidth,
      gradient: gradient,
      dashPattern: dashPattern,
    );
  }

  @override
  Widget build(BuildContext context) {
    final DividerThemeData dividerTheme = DividerTheme.of(context);
    final double height = this.height ?? dividerTheme.space ?? 16.0;
    final double thickness = this.thickness ?? dividerTheme.thickness ?? 0.0;
    final double indent = this.indent ?? dividerTheme.indent ?? 0.0;
    final double endIndent = this.endIndent ?? dividerTheme.endIndent ?? 0.0;

    return SizedBox(
      height: height,
      child: Center(
        child: Container(
          height: thickness,
          margin: EdgeInsetsDirectional.only(start: indent, end: endIndent),
          decoration: BoxDecoration(
            border: TxBorder(
              bottom: createBorderSide(
                context,
                color: color,
                width: thickness,
                dashPattern: dashPattern,
                gradient: gradient,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 一条细垂直线，两边都有填充。
///
/// 相比于[VerticalDivider]增加了虚线配置。
///
/// 详细信息参考[VerticalDivider]
class TxVerticalDivider extends VerticalDivider {
  /// 创建一个 Material Design 垂直分隔线。
  ///
  /// [width]、[thickness]、[indent] 和 [endIndent] 必须为 null 或非负数。
  const TxVerticalDivider({
    super.key,
    super.width,
    super.thickness,
    super.indent,
    super.endIndent,
    super.color,
    this.dashPattern,
    this.gradient,
  });

  /// 虚线格式
  ///
  /// 参考[TxBorderSide.dashPattern]
  final List<double>? dashPattern;

  /// 渐变色
  ///
  /// 参考[TxBorderSide.gradient]
  final LinearGradient? gradient;

  @override
  Widget build(BuildContext context) {
    final DividerThemeData dividerTheme = DividerTheme.of(context);
    final double width = this.width ?? dividerTheme.space ?? 16.0;
    final double thickness = this.thickness ?? dividerTheme.thickness ?? 0.0;
    final double indent = this.indent ?? dividerTheme.indent ?? 0.0;
    final double endIndent = this.endIndent ?? dividerTheme.endIndent ?? 0.0;

    return SizedBox(
      width: width,
      child: Center(
        child: Container(
          width: thickness,
          margin: EdgeInsetsDirectional.only(top: indent, bottom: endIndent),
          decoration: BoxDecoration(
            border: TxBorder(
              left: TxDivider.createBorderSide(
                context,
                color: color,
                width: thickness,
                dashPattern: dashPattern,
                gradient: gradient,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
