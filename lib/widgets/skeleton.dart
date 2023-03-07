import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tx_design/tx_design.dart';

/// 骨架屏组件
class TxSkeleton extends StatelessWidget {
  const TxSkeleton({super.key, this.style = const TxSkeletonStyle()});

  final TxSkeletonStyle style;

  @override
  Widget build(BuildContext context) {
    final bool isLightMode =
        Theme.of(context).colorScheme.brightness == Brightness.light;

    final baseColor = style.baseColor ??
        (isLightMode ? const Color(0xFFEBEBF4) : const Color(0xFF222222));
    final highlightColor = style.highlightColor ??
        (isLightMode ? const Color(0xFFD1D1DF) : const Color(0xFF2B2B2B));

    return TxShimmer.fromColors(
      highlightColor: highlightColor,
      baseColor: baseColor,
      child: Padding(
        padding: style.padding,
        child: LayoutBuilder(
          builder: (context, constraints) {
            double? width = style.width;
            if (style.randomWidth) {
              final double max = style.maxWidth ?? constraints.maxWidth;
              final double min = style.minWidth ?? max / 3;
              width = Random().nextDouble() * (max - min) + min;
            }
            return Container(
              width: width,
              height: style.height,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: style.borderRadius,
              ),
            );
          },
        ),
      ),
      // gradient: gradient,
    );
  }
}

/// 头像骨架屏
class TxAvatarSkeleton extends StatelessWidget {
  const TxAvatarSkeleton(
      {super.key, this.style = const TxSkeletonAvatarStyle()});

  final TxSkeletonAvatarStyle style;

  @override
  Widget build(BuildContext context) {
    final bool isLightMode = Theme.of(context).brightness == Brightness.light;

    final baseColor = style.baseColor ??
        (isLightMode ? const Color(0xFFEBEBF4) : const Color(0xFF222222));
    final highlightColor = style.highlightColor ??
        (isLightMode ? const Color(0xFFD1D1DF) : const Color(0xFF2B2B2B));

    return TxShimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Padding(
        padding: style.padding,
        child: LayoutBuilder(
          builder: (context, constraints) {
            double? width = style.width;
            double? height = style.height;
            if (style.randomWidth) {
              final double max = style.maxWidth ?? constraints.maxWidth;
              final double min = style.minWidth ?? max / 3;
              width = Random().nextDouble() * (max - min) + min;
            }
            if (style.randomHeight) {
              final double max = style.maxHeight ?? constraints.maxWidth;
              final double min = style.minHeight ?? max / 3;
              height = Random().nextDouble() * (max - min) + min;
            }
            return Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                shape: style.shape,
                borderRadius:
                    style.shape != BoxShape.circle ? style.borderRadius : null,
              ),
            );
          },
        ),
      ),
    );
  }
}

/// 文章段落骨架屏
class TxParagraphSkeleton extends StatelessWidget {
  const TxParagraphSkeleton({
    super.key,
    this.lines = 3,
    this.padding = const EdgeInsets.symmetric(vertical: 8, horizontal: 13),
    this.spacing = 12,
    this.lineStyle,
    this.imageStyle,
    this.releaseStyle,
    this.hasImage = false,
    this.hasRelease = false,
    this.runSpacing,
  });

  final int lines;
  final EdgeInsetsGeometry padding;
  final double spacing;
  final TxSkeletonStyle? lineStyle;
  final TxSkeletonStyle? imageStyle;
  final TxSkeletonStyle? releaseStyle;
  final double? runSpacing;
  final bool hasImage;
  final bool hasRelease;

  @override
  Widget build(BuildContext context) {
    final child = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 1; i <= lines; i++) ...[
          TxSkeleton(style: lineStyle ?? const TxSkeletonStyle(height: 14)),
          if (i != lines) SizedBox(height: spacing)
        ],
        if (hasRelease) ...[
          SizedBox(height: spacing),
          TxSkeleton(
              style:
                  releaseStyle ?? const TxSkeletonStyle(height: 14, width: 55))
        ],
      ],
    );
    return Padding(
      padding: padding,
      child: hasImage
          ? Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: child),
                SizedBox(width: runSpacing ?? 12),
                TxSkeleton(
                    style: imageStyle ??
                        const TxSkeletonStyle(width: 100, height: 80))
              ],
            )
          : child,
    );
  }
}

/// ListTile骨架屏
class TxListTileSkeleton extends StatelessWidget {
  const TxListTileSkeleton({
    super.key,
    this.titleStyle = const TxSkeletonStyle(),
    this.hasLeading = true,
    this.leadingStyle,
    this.hasSubtitle = true,
    this.subtitleStyle,
    this.padding,
    this.contentSpacing = 5,
    this.verticalSpacing = 4,
    this.trailing,
  });

  final bool hasLeading;
  final TxSkeletonAvatarStyle? leadingStyle;
  final TxSkeletonStyle titleStyle;
  final bool hasSubtitle;
  final TxSkeletonStyle? subtitleStyle;
  final EdgeInsetsGeometry? padding;
  final double? contentSpacing;
  final double? verticalSpacing;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasLeading)
            TxAvatarSkeleton(
                style: leadingStyle ?? const TxSkeletonAvatarStyle(width: 30)),
          SizedBox(width: contentSpacing),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TxSkeleton(style: titleStyle),
                if (hasSubtitle) ...[
                  SizedBox(height: verticalSpacing),
                  TxSkeleton(
                    style: subtitleStyle ??
                        const TxSkeletonStyle(width: 60, height: 14),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) trailing!
        ],
      ),
    );
  }
}

/// TabBar骨架屏
class TxTabBarSkeleton extends StatelessWidget {
  const TxTabBarSkeleton(
      {Key? key,
      this.tabNum = 3,
      this.padding = const EdgeInsets.symmetric(vertical: 16, horizontal: 13),
      this.tabStyle = const TxSkeletonStyle(
          width: 50, height: 20, padding: EdgeInsets.symmetric(horizontal: 20)),
      this.alignment = MainAxisAlignment.spaceBetween})
      : super(key: key);
  final int tabNum;
  final EdgeInsetsGeometry padding;
  final TxSkeletonStyle tabStyle;
  final MainAxisAlignment alignment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: alignment,
        children: List.generate(tabNum, (index) => TxSkeleton(style: tabStyle)),
      ),
    );
  }
}

/// 列表骨架屏
class TxListViewSkeleton extends StatelessWidget {
  const TxListViewSkeleton({
    super.key,
    this.padding = const EdgeInsets.symmetric(vertical: 8, horizontal: 13),
    this.item,
    this.itemCount = 5,
    this.scrollable = false,
    this.spacing,
  });

  final Widget? item;
  final int itemCount;
  final bool scrollable;
  final EdgeInsets? padding;
  final double? spacing;

  @override
  Widget build(BuildContext context) {
    if (!scrollable) {
      return Padding(
        padding: padding ?? EdgeInsets.zero,
        child: Column(
          children: [
            for (var i = 1; i <= itemCount; i++) ...[
              item ?? const TxListTileSkeleton(),
              if (i != itemCount) SizedBox(height: spacing)
            ]
          ],
        ),
      );
    }
    return ListView.builder(
      padding: padding,
      itemCount: itemCount,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) => item ?? const TxListTileSkeleton(),
    );
  }
}

/// 菜单骨架屏
class TxMenuSkeleton extends StatelessWidget {
  const TxMenuSkeleton({super.key, this.style = const TxSkeletonMenuStyle()});

  final TxSkeletonMenuStyle style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: style.padding,
      child: style.hasLabel
          ? Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TxAvatarSkeleton(style: style.iconStyle),
                SizedBox(height: style.spacing),
                TxSkeleton(
                  style: style.labelStyle ?? const TxSkeletonStyle(width: 45),
                ),
              ],
            )
          : TxAvatarSkeleton(style: style.iconStyle),
    );
  }
}

/// 菜单组骨架屏
class TxMenuGroupSkeleton extends StatelessWidget {
  const TxMenuGroupSkeleton({
    super.key,
    this.menuStyle = const TxSkeletonMenuStyle(),
    this.menuNum = 5,
    this.hasTitle = false,
    this.hasLeading = false,
    this.titleStyle,
    this.leadingStyle,
    this.padding = const EdgeInsets.all(0),
  });

  final bool hasTitle;
  final bool hasLeading;
  final TxSkeletonStyle? titleStyle;
  final TxSkeletonAvatarStyle? leadingStyle;
  final TxSkeletonMenuStyle menuStyle;
  final int menuNum;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final Widget menuRow = Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children:
          List.generate(menuNum, (index) => TxMenuSkeleton(style: menuStyle)),
    );

    return Padding(
      padding: padding,
      child: hasTitle
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TxListTileSkeleton(
                  titleStyle: titleStyle ??
                      const TxSkeletonStyle(width: 70, height: 20),
                  leadingStyle: leadingStyle ?? const TxSkeletonAvatarStyle(),
                  hasSubtitle: false,
                  hasLeading: hasLeading,
                  padding: const EdgeInsets.only(bottom: 13),
                ),
                menuRow
              ],
            )
          : menuRow,
    );
  }
}

class TxSkeletonStyle {
  const TxSkeletonStyle({
    this.width = double.infinity,
    this.height = 18,
    this.padding = const EdgeInsets.all(0),
    bool? randomWidth,
    this.minWidth,
    this.maxWidth,
    this.alignment = AlignmentDirectional.centerStart,
    this.borderRadius = const BorderRadius.all(Radius.circular(2)),
    this.baseColor,
    this.highlightColor,
  })  : randomWidth = randomWidth ?? (minWidth != null || maxWidth != null),
        assert(minWidth == null ||
            (minWidth > 0 && (maxWidth == null || maxWidth > minWidth))),
        assert(maxWidth == null ||
            (maxWidth > 0 && (minWidth == null || minWidth < maxWidth)));
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final bool randomWidth;
  final double? minWidth;
  final double? maxWidth;
  final AlignmentGeometry alignment;
  final BorderRadiusGeometry? borderRadius;
  final Color? baseColor;
  final Color? highlightColor;
}

class TxSkeletonAvatarStyle extends TxSkeletonStyle {
  const TxSkeletonAvatarStyle({
    double? width = 48,
    double? height = 48,
    EdgeInsetsGeometry padding = const EdgeInsets.all(0),
    bool? randomWidth,
    double? minWidth,
    double? maxWidth,
    bool? randomHeight,
    Color? baseColor,
    Color? highlightColor,
    this.maxHeight,
    this.minHeight,
    this.shape = BoxShape.circle,
    BorderRadiusGeometry? borderRadius =
        const BorderRadius.all(Radius.circular(4)),
  })  : randomHeight = randomHeight ?? (minHeight != null || maxHeight != null),
        assert(minWidth == null ||
            (minWidth > 0 && (maxWidth == null || maxWidth > minWidth))),
        assert(maxWidth == null ||
            (maxWidth > 0 && (minWidth == null || minWidth < maxWidth))),
        assert(minHeight == null ||
            (minHeight > 0 && (maxHeight == null || maxHeight > minHeight))),
        assert(maxHeight == null ||
            (maxHeight > 0 && (minHeight == null || minHeight < maxHeight))),
        super(
          randomWidth: randomWidth,
          width: width,
          height: height,
          padding: padding,
          borderRadius: borderRadius,
          minWidth: minWidth,
          maxWidth: maxWidth,
          highlightColor: highlightColor,
          baseColor: baseColor,
        );
  final bool randomHeight;
  final double? maxHeight;
  final double? minHeight;
  final BoxShape shape;
}

class TxSkeletonMenuStyle {
  const TxSkeletonMenuStyle({
    Key? key,
    this.labelStyle,
    this.iconStyle = const TxSkeletonAvatarStyle(shape: BoxShape.rectangle),
    this.spacing = 8,
    this.padding = const EdgeInsets.all(0),
    this.hasLabel = true,
  });

  final TxSkeletonStyle? labelStyle;
  final TxSkeletonAvatarStyle iconStyle;
  final double? spacing;
  final EdgeInsetsGeometry padding;
  final bool hasLabel;
}
