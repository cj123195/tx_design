import 'package:flutter/material.dart';

import 'panel.dart';
import 'skeleton_theme.dart';

/// 骨架屏
class TxSkeleton extends StatelessWidget {
  const TxSkeleton({
    super.key,
    this.color,
    this.width,
    this.height,
    this.borderRadius,
    this.alignment,
    this.widthFactor,
    this.heightFactor,
  });

  TxSkeleton.text({
    required TextStyle style,
    super.key,
    this.color,
    this.width = 84.0,
    this.borderRadius,
    this.alignment,
    this.widthFactor,
    this.heightFactor,
  }) : height = style.fontSize;

  const TxSkeleton.square({
    required double dimension,
    super.key,
    this.color,
    this.borderRadius,
    this.alignment,
    this.widthFactor,
    this.heightFactor,
  })  : width = dimension,
        height = dimension;

  /// 骨架屏颜色
  final Color? color;

  /// 骨架屏宽度
  final double? width;

  /// 骨架屏高度
  final double? height;

  /// 骨架屏圆角
  final BorderRadius? borderRadius;

  /// 骨架屏对齐方式
  final AlignmentGeometry? alignment;

  /// 相对于父组件宽度比例
  final double? widthFactor;

  /// 相对于父组件的高度比例
  final double? heightFactor;

  @override
  Widget build(BuildContext context) {
    final TxSkeletonThemeData skeletonTheme = TxSkeletonTheme.of(context);

    final Color effectiveColor = color ??
        skeletonTheme.color ??
        Theme.of(context).colorScheme.outline.withValues(alpha: 0.1);
    final BorderRadius effectiveBorderRadius = borderRadius ??
        skeletonTheme.borderRadius ??
        const BorderRadius.all(Radius.circular(4));

    Widget result = DecoratedBox(
      decoration: BoxDecoration(
        color: effectiveColor,
        borderRadius: effectiveBorderRadius,
      ),
    );

    if (width != null || height != null) {
      result = SizedBox(height: height, width: width, child: result);
    }

    return FractionallySizedBox(
      widthFactor: widthFactor,
      heightFactor: heightFactor,
      alignment: alignment ?? Alignment.centerLeft,
      child: result,
    );
  }
}

/// ListTile骨架屏
class TxListTileSkeleton extends StatelessWidget {
  const TxListTileSkeleton({
    super.key,
    this.showLeading = false,
    this.showTrailing = true,
    this.circleLeading = false,
    this.squareTrailing = true,
    this.longSubtitle = false,
  });

  final bool showLeading;
  final bool showTrailing;
  final bool circleLeading;
  final bool squareTrailing;
  final bool longSubtitle;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    Widget? trailing;
    if (showTrailing) {
      trailing = squareTrailing
          ? const TxSkeleton.square(dimension: 24.0)
          : TxSkeleton.text(width: 60.0, style: textTheme.bodySmall!);
    }

    Widget? leading;
    if (showLeading) {
      leading = TxSkeleton.square(
        dimension: 40.0,
        borderRadius: circleLeading ? BorderRadius.circular(40.0) : null,
      );
    }

    return ListTile(
      title: RichText(
        text: WidgetSpan(
          child:
              TxSkeleton.text(style: textTheme.titleMedium!, widthFactor: 0.3),
          style: textTheme.bodyMedium,
        ),
      ),
      subtitle: RichText(
        text: WidgetSpan(
          child:
              TxSkeleton.text(style: textTheme.bodyMedium!, widthFactor: 0.7),
          style: textTheme.bodyMedium,
        ),
      ),
      trailing: trailing,
      leading: leading,
    );
  }
}

/// Panel骨架屏
class TxPanelSkeleton extends StatelessWidget {
  const TxPanelSkeleton({
    super.key,
    this.titleWidthFactor = 0.3,
    this.hasSubtitle = false,
    this.subtitleWidthFactor = 0.5,
    this.hasTrailing = true,
    this.trailingWidth = 48.0,
    this.contentColumnNumber = 2,
  });

  final bool hasSubtitle;
  final bool hasTrailing;
  final int contentColumnNumber;
  final double trailingWidth;
  final double subtitleWidthFactor;
  final double titleWidthFactor;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    Widget? subtitle;
    if (hasSubtitle) {
      subtitle = TxSkeleton.text(
        style: textTheme.bodyMedium!,
        widthFactor: subtitleWidthFactor,
      );
    }

    Widget? trailing;
    if (hasTrailing) {
      trailing = TxSkeleton.text(
        style: textTheme.bodyMedium!,
        width: trailingWidth,
      );
    }

    final Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (int i = 0; i < contentColumnNumber; i++) ...[
          TxSkeleton.text(style: textTheme.labelMedium!),
          if (i != contentColumnNumber - 1) const SizedBox(height: 8),
        ]
      ],
    );

    return TxPanel(
      title: TxSkeleton.text(
        style: textTheme.titleMedium!,
        widthFactor: titleWidthFactor,
      ),
      subtitle: subtitle,
      trailing: trailing,
      content: content,
    );
  }
}

/// TabBar 骨架屏
class TxTabBarSkeleton extends StatelessWidget {
  const TxTabBarSkeleton({super.key, this.length = 2});

  final int length;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(
        length,
        (index) => const TxSkeleton(height: 24.0, width: 80.0),
      ),
    );
  }
}
