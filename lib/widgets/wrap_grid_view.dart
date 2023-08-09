import 'package:flutter/material.dart';

/// 在多个水平或垂直运行中显示其固定大小子级的小部件。
class WrapGridView extends StatelessWidget {
  const WrapGridView({
    required List<Widget> this.children,
    required this.crossAxisCount,
    super.key,
    this.direction = Axis.horizontal,
    this.alignment = WrapAlignment.start,
    this.spacing = 0.0,
    this.runAlignment = WrapAlignment.start,
    this.runSpacing = 0.0,
    this.crossAxisAlignment = WrapCrossAlignment.start,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.clipBehavior = Clip.none,
  })  : itemCount = children.length,
        itemBuilder = null;

  const WrapGridView.builder({
    required this.itemCount,
    required IndexedWidgetBuilder this.itemBuilder,
    required this.crossAxisCount,
    super.key,
    this.direction = Axis.horizontal,
    this.alignment = WrapAlignment.start,
    this.spacing = 0.0,
    this.runAlignment = WrapAlignment.start,
    this.runSpacing = 0.0,
    this.crossAxisAlignment = WrapCrossAlignment.start,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.clipBehavior = Clip.none,
  }) : children = null;

  final List<Widget>? children;

  final int itemCount;

  final IndexedWidgetBuilder? itemBuilder;

  /// 参阅[Wrap.direction]
  final Axis direction;

  /// 参阅[Wrap.alignment]
  final WrapAlignment alignment;

  /// 参阅[Wrap.spacing]
  final double spacing;

  /// 参阅[Wrap.runAlignment]
  final WrapAlignment runAlignment;

  /// 参阅[Wrap.runSpacing]
  final double runSpacing;

  /// 参阅[Wrap.crossAxisAlignment]
  final WrapCrossAlignment crossAxisAlignment;

  /// 参阅[Wrap.textDirection]
  final TextDirection? textDirection;

  /// 参阅[Wrap.verticalDirection]
  final VerticalDirection verticalDirection;

  /// 参阅[Wrap.clipBehavior]
  final Clip clipBehavior;

  /// 参阅[SliverGridDelegateWithFixedCrossAxisCount.crossAxisCount]
  final int crossAxisCount;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        List<Widget> children;
        if (direction == Axis.horizontal) {
          assert(constraints.maxWidth != double.infinity);
          final double width =
              (constraints.maxWidth - spacing * (crossAxisCount - 1)) /
                  crossAxisCount;
          children = List.generate(itemCount, (index) {
            return SizedBox(
              width: width,
              child: this.children?[index] ?? itemBuilder!(context, index),
            );
          });
        } else {
          assert(constraints.maxHeight != double.infinity);

          final double height =
              (constraints.maxHeight - (spacing * crossAxisCount - 1)) /
                  crossAxisCount;
          children = List.generate(itemCount, (index) {
            return SizedBox(
              height: height,
              child: this.children?[index] ?? itemBuilder!(context, index),
            );
          });
        }

        return Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          direction: direction,
          alignment: alignment,
          runAlignment: runAlignment,
          crossAxisAlignment: crossAxisAlignment,
          verticalDirection: verticalDirection,
          textDirection: textDirection,
          clipBehavior: clipBehavior,
          children: children,
        );
      },
    );
  }
}