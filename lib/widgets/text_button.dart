import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// 图标位置
enum TextButtonIconPosition {
  /// 图标在左
  left,

  /// 图标在右
  right,

  /// 图标在上
  top,

  /// 图标在下
  bottom
}

/// 一个Material风格的文本按钮。
///
/// 继承自[TextButton]，主要是为了在[TxTextButton.icon]构造方法中增加图标位置
/// [TextButtonIconPosition]的配置，具体属性请参考[TextButton]
class TxTextButton extends TextButton {
  TxTextButton.icon({
    required Widget label,
    required Widget icon,
    super.key,
    super.onPressed,
    super.onLongPress,
    super.style,
    TextButtonIconPosition iconPosition = TextButtonIconPosition.right,
    double? gap,
  }) : super(
          child: _TextButtonWithIconChild(
            label: label,
            icon: icon,
            iconPosition: iconPosition,
            gap: gap,
          ),
        );

  @override
  ButtonStyle defaultStyleOf(BuildContext context) {
    final EdgeInsetsGeometry scaledPadding = ButtonStyleButton.scaledPadding(
      const EdgeInsets.all(8),
      const EdgeInsets.symmetric(horizontal: 4),
      const EdgeInsets.symmetric(horizontal: 4),
      MediaQuery.maybeOf(context)?.textScaleFactor ?? 1,
    );
    final TextStyle? textStyle =
        Theme.of(context).textTheme.labelLarge?.copyWith(height: 1.2);

    return super.defaultStyleOf(context).copyWith(
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(scaledPadding),
          textStyle: MaterialStateProperty.all(textStyle),
        );
  }
}

class _TextButtonWithIconChild extends StatelessWidget {
  const _TextButtonWithIconChild({
    required this.label,
    required this.icon,
    required this.iconPosition,
    this.gap,
  });

  final Widget label;
  final Widget icon;
  final TextButtonIconPosition iconPosition;
  final double? gap;

  @override
  Widget build(BuildContext context) {
    final bool isVerticalAlign =
        iconPosition == TextButtonIconPosition.bottom ||
            iconPosition == TextButtonIconPosition.top;
    final double scale = MediaQuery.maybeOf(context)?.textScaleFactor ?? 1;
    final double gap = this.gap ??
        (scale <= 1 ? 4.0 : ui.lerpDouble(6, 4, math.min(scale - 1, 1))!);

    final List<Widget> children = [
      icon,
      SizedBox(height: gap, width: gap),
      Flexible(child: label)
    ];

    if (isVerticalAlign) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: iconPosition == TextButtonIconPosition.bottom
            ? children.reversed.toList()
            : children,
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: iconPosition == TextButtonIconPosition.right
          ? children.reversed.toList()
          : children,
    );
  }
}
