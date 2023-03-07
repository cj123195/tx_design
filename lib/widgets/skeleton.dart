import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tx_design/tx_design.dart';

/// 骨架屏组件
class Skeleton extends StatelessWidget {
  const Skeleton({super.key, this.style = const SkeletonStyle()});

  final SkeletonStyle style;

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
class AvatarSkeleton extends StatelessWidget {
  const AvatarSkeleton({super.key, this.style = const SkeletonAvatarStyle()});

  final SkeletonAvatarStyle style;

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
class ParagraphSkeleton extends StatelessWidget {
  const ParagraphSkeleton({
    Key? key,
    this.lines = 3,
    this.padding = const EdgeInsets.symmetric(vertical: 8, horizontal: 13),
    this.spacing = 12,
    this.lineStyle,
    this.imageStyle,
    this.releaseStyle,
    this.hasImage = false,
    this.hasRelease = false,
    this.runSpacing,
  }) : super(key: key);
  final int lines;
  final EdgeInsetsGeometry padding;
  final double spacing;
  final SkeletonStyle? lineStyle;
  final SkeletonStyle? imageStyle;
  final SkeletonStyle? releaseStyle;
  final double? runSpacing;
  final bool hasImage;
  final bool hasRelease;

  @override
  Widget build(BuildContext context) {
    final child = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 1; i <= lines; i++) ...[
          Skeleton(style: lineStyle ?? const SkeletonStyle(height: 14)),
          if (i != lines) SizedBox(height: spacing)
        ],
        if (hasRelease) ...[
          SizedBox(height: spacing),
          Skeleton(
              style: releaseStyle ?? const SkeletonStyle(height: 14, width: 55))
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
          Skeleton(
              style: imageStyle ??
                  const SkeletonStyle(width: 100, height: 80))
        ],
      )
          : child,
    );
  }
}

/// ListTile骨架屏
class ListTileSkeleton extends StatelessWidget {
  const ListTileSkeleton({
    Key? key,
    this.titleStyle = const SkeletonStyle(),
    this.hasLeading = true,
    this.leadingStyle,
    this.hasSubtitle = true,
    this.subtitleStyle,
    this.padding,
    this.contentSpacing = 5,
    this.verticalSpacing = 4,
    this.trailing,
  }) : super(key: key);
  final bool hasLeading;
  final SkeletonAvatarStyle? leadingStyle;
  final SkeletonStyle titleStyle;
  final bool hasSubtitle;
  final SkeletonStyle? subtitleStyle;
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
            AvatarSkeleton(
                style: leadingStyle ?? const SkeletonAvatarStyle(width: 30)),
          SizedBox(width: contentSpacing),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Skeleton(style: titleStyle),
                if (hasSubtitle) ...[
                  SizedBox(height: verticalSpacing),
                  Skeleton(
                    style: subtitleStyle ??
                        const SkeletonStyle(width: 60, height: 14),
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
class TabBarSkeleton extends StatelessWidget {
  const TabBarSkeleton(
      {Key? key,
        this.tabNum = 3,
        this.padding = const EdgeInsets.symmetric(vertical: 16, horizontal: 13),
        this.tabStyle = const SkeletonStyle(
            width: 50, height: 20, padding: EdgeInsets.symmetric(horizontal: 20)),
        this.alignment = MainAxisAlignment.spaceBetween})
      : super(key: key);
  final int tabNum;
  final EdgeInsetsGeometry padding;
  final SkeletonStyle tabStyle;
  final MainAxisAlignment alignment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: alignment,
        children: List.generate(tabNum, (index) => Skeleton(style: tabStyle)),
      ),
    );
  }
}

/// 列表骨架屏
class ListViewSkeleton extends StatelessWidget {
  const ListViewSkeleton({
    Key? key,
    this.padding = const EdgeInsets.symmetric(vertical: 8, horizontal: 13),
    this.item,
    this.itemCount = 5,
    this.scrollable = false,
    this.spacing,
  }) : super(key: key);
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
              item ?? const ListTileSkeleton(),
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
      itemBuilder: (context, index) => item ?? const ListTileSkeleton(),
    );
  }
}

/// 菜单骨架屏
class MenuSkeleton extends StatelessWidget {
  const MenuSkeleton({Key? key, this.style = const SkeletonMenuStyle()})
      : super(key: key);
  final SkeletonMenuStyle style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: style.padding,
      child: style.hasLabel
          ? Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AvatarSkeleton(style: style.iconStyle),
          SizedBox(height: style.spacing),
          Skeleton(
              style: style.labelStyle ?? const SkeletonStyle(width: 45)),
        ],
      )
          : AvatarSkeleton(style: style.iconStyle),
    );
  }
}

/// 菜单组骨架屏
class MenuGroupSkeleton extends StatelessWidget {
  const MenuGroupSkeleton({
    Key? key,
    this.menuStyle = const SkeletonMenuStyle(),
    this.menuNum = 5,
    this.hasTitle = false,
    this.hasLeading = false,
    this.titleStyle,
    this.leadingStyle,
    this.padding = const EdgeInsets.all(0),
  }) : super(key: key);
  final bool hasTitle;
  final bool hasLeading;
  final SkeletonStyle? titleStyle;
  final SkeletonAvatarStyle? leadingStyle;
  final SkeletonMenuStyle menuStyle;
  final int menuNum;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final Widget menuRow = Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children:
      List.generate(menuNum, (index) => MenuSkeleton(style: menuStyle)),
    );

    return Padding(
      padding: padding,
      child: hasTitle
          ? Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTileSkeleton(
            titleStyle:
            titleStyle ?? const SkeletonStyle(width: 70, height: 20),
            leadingStyle: leadingStyle ?? const SkeletonAvatarStyle(),
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

class SkeletonStyle {
  const SkeletonStyle({
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

class SkeletonAvatarStyle extends SkeletonStyle {
  const SkeletonAvatarStyle({
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

class SkeletonMenuStyle {
  const SkeletonMenuStyle({
    Key? key,
    this.labelStyle,
    this.iconStyle = const SkeletonAvatarStyle(shape: BoxShape.rectangle),
    this.spacing = 8,
    this.padding = const EdgeInsets.all(0),
    this.hasLabel = true,
  });

  final SkeletonStyle? labelStyle;
  final SkeletonAvatarStyle iconStyle;
  final double? spacing;
  final EdgeInsetsGeometry padding;
  final bool hasLabel;
}
