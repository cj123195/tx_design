import 'package:flutter/material.dart';

/// 帮助提示按钮图标
class TxHelpTooltipIcon extends Tooltip {
  TxHelpTooltipIcon({
    required super.message,
    EdgeInsetsGeometry? iconPadding,
    bool solid = false,
    super.key,
    super.richMessage,
    super.height,
    super.padding,
    super.margin = const EdgeInsets.symmetric(horizontal: 12.0),
    super.verticalOffset,
    super.preferBelow,
    super.excludeFromSemantics,
    super.decoration,
    super.textStyle,
    super.textAlign,
    super.waitDuration,
    super.showDuration,
    super.triggerMode,
    super.enableFeedback,
    super.onTriggered,
  }) : super(
          child: Padding(
            padding: padding ?? const EdgeInsets.all(12.0),
            child: Icon(solid ? Icons.help : Icons.help_outline),
          ),
        );
}
