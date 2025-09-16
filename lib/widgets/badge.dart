import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'badge_theme.dart';

/// 材料设计“徽章”。
///
/// 徽章的 [label] 传达有关其 [child] 的少量信息，例如计数或状态。如果标签为 null，则这是一
/// 个“小”徽章，显示为 [smallSize] 直径填充圆圈。否则，这是一个 [StadiumBorder] 形状的“大”徽章，
/// 高度为 [largeSize]。
///
/// 徽章通常用于装饰 [BottomNavigationBarItem] 或 [NavigationRailDestination] 或按钮
/// 图标中的图标，如 [TextButton.icon]。徽章的默认配置旨在与默认大小(24)的 [Icon] 配合使用。
@Deprecated(
  '请使用 TxTag 替代。 '
  'This will be removed in the next major version.',
)
class TxBadge extends StatelessWidget {
  /// 创建一个徽章，将 [label] 堆叠在 [child] 之上。
  ///
  /// 如果 [label] 为 null，则仅显示一个实心圆圈。否则，[label] 将显示在 [shape] 形状的区域内。
  @Deprecated(
    '请使用 TxTag 替代。 '
    'This will be removed in the next major version.',
  )
  const TxBadge({
    super.key,
    this.backgroundColor,
    this.textColor,
    this.smallSize,
    this.largeSize,
    this.textStyle,
    this.padding,
    this.alignment,
    this.offset,
    this.label,
    this.isLabelVisible = true,
    this.child,
    this.shape,
  });

  /// 方便的构造函数，用于创建带有基于 [count] 的 1-3 位数字标签的徽章。
  ///
  /// 使用包含 [count] 的 [Text] 小部件初始化 [label]。如果 [count] 大于 999，
  /// 则标签为“999+”。
  @Deprecated(
    '请使用 TxTag 替代。 '
    'This will be removed in the next major version.',
  )
  TxBadge.count({
    required int count,
    super.key,
    this.backgroundColor,
    this.textColor,
    this.smallSize,
    this.largeSize,
    this.textStyle,
    this.padding,
    this.alignment,
    this.offset,
    this.isLabelVisible = true,
    this.child,
    this.shape,
  }) : label = Text(count > 999 ? '999+' : '$count');

  /// 徽章的填充颜色。
  ///
  /// 默认为 [BadgeTheme] 的背景色，如果主题值为 null，则默认为 [ColorScheme.error]。
  final Color? backgroundColor;

  /// 徽章的 [label] 文本的颜色。
  ///
  /// 此颜色将覆盖标签的 [textStyle] 的颜色。
  ///
  /// 默认为 [BadgeTheme] 的前景色，如果主题值为 null，则默认为 [ColorScheme.onError]。
  final Color? textColor;

  /// 如果 [label] 为 null，则徽章的直径。
  ///
  /// 默认为 [BadgeTheme] 的小大小，如果主题值为 null，则默认为 6。
  final double? smallSize;

  /// 如果 [label] 为非空，则徽章的高度。
  ///
  /// 默认为 [BadgeTheme] 的大尺寸，如果主题值为 null，则默认为 16。如果默认值被覆盖，
  /// 则覆盖 [padding] 和 [alignment] 也可能很有用。
  final double? largeSize;

  /// 锁屏提醒标签的 [DefaultTextStyle]。
  ///
  /// 文本样式的颜色被 [textColor] 覆盖。
  ///
  /// 仅当 [label] 为非 null 时才使用此值。
  ///
  /// 默认为 [BadgeTheme] 的文本样式，如果锁屏提醒主题的值为 null，则默认为 [TextTheme.labelSmall]。
  /// 如果默认文本样式被覆盖，则覆盖 [largeSize]、[padding] 和 [alignment] 也可能很有用。
  final TextStyle? textStyle;

  /// 添加到徽章标签的填充。
  ///
  /// 仅当 [label] 为非 null 时才使用此值。
  ///
  /// 默认为 [BadgeTheme] 的填充，如果主题的值为 null，则左右各为 4 像素。
  final EdgeInsetsGeometry? padding;

  /// 结合 [offset] 以确定 [label] 相对于 [child] 的位置。
  ///
  /// 对齐方式对标注的位置与 [Align] 构件的子项的定位方式相同，不同之处在于，对齐方式的解析方式
  /// 就好像标签是 [largeSize] 正方形，并将 [offset] 添加到结果中。
  ///
  /// 仅当 [label] 为非 null 时才使用此值。
  ///
  /// 默认为 [BadgeTheme] 的对齐方式，如果主题的值为 null，则默认为 [AlignmentDirectional.topEnd]。
  final AlignmentGeometry? alignment;

  /// 结合 [alignment] 以确定 [label] 相对于 [child] 的位置。
  ///
  /// 仅当 [label] 为非 null 时才使用此值。
  ///
  /// 默认为 [BadgeTheme] 的偏移量，或者如果主题的值为 null，则 [TextDirection.ltr] 的
  /// 'Offset(4， -4)' 或 [TextDirection.rtl] 的 'Offset(-4， -4)'。
  final Offset? offset;

  /// 徽章的内容，通常是包含 1 到 4 个字符的 [Text] 小组件。
  ///
  /// 如果标签为 null，则这是一个“小”徽章，显示为 [smallSize] 直径填充圆圈。否则，这是一个
  /// [shape] 形状的“大”徽章，高度为 [largeSize]。
  final Widget? label;

  /// 如果为 false，则不包括徽章的 [label]。
  ///
  /// 默认情况下，此标志为 true。它旨在方便地创建仅在特定条件下显示的徽章。
  final bool isLabelVisible;

  /// 徽章堆叠在顶部的小组件。
  ///
  /// 通常，这是一个默认大小的 [Icon]，它是 [BottomNavigationBarItem] 或
  /// [NavigationRailDestination] 的一部分。
  final Widget? child;

  /// 徽章的形状
  ///
  /// 默认为圆角为 4.0 的[RoundedRectangleBorder]。
  final ShapeBorder? shape;

  @override
  Widget build(BuildContext context) {
    if (!isLabelVisible) {
      return child ?? const SizedBox();
    }

    final TxBadgeThemeData txBadgeTheme = TxBadgeTheme.of(context);
    final BadgeThemeData badgeTheme =
        txBadgeTheme.badgeTheme ?? BadgeTheme.of(context);
    final _BadgeDefaultsM3 defaultsBadgeTheme = _BadgeDefaultsM3(context);
    final BadgeThemeData defaults = defaultsBadgeTheme.badgeTheme!;
    final double effectiveSmallSize =
        smallSize ?? badgeTheme.smallSize ?? defaults.smallSize!;
    final double effectiveLargeSize =
        largeSize ?? badgeTheme.largeSize ?? defaults.largeSize!;

    final Widget badge = DefaultTextStyle(
      style:
          (textStyle ?? badgeTheme.textStyle ?? defaults.textStyle!).copyWith(
        color: textColor ?? badgeTheme.textColor ?? defaults.textColor!,
      ),
      child: IntrinsicWidth(
        child: Container(
          height: label == null ? effectiveSmallSize : effectiveLargeSize,
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: backgroundColor ??
                badgeTheme.backgroundColor ??
                defaults.backgroundColor!,
            shape: shape ?? txBadgeTheme.shape ?? defaultsBadgeTheme.shape!,
          ),
          padding: label == null
              ? null
              : (padding ?? badgeTheme.padding ?? defaults.padding!),
          alignment: label == null ? null : Alignment.center,
          child: label ??
              SizedBox(width: effectiveSmallSize, height: effectiveSmallSize),
        ),
      ),
    );

    if (child == null) {
      return badge;
    }

    final AlignmentGeometry effectiveAlignment =
        alignment ?? badgeTheme.alignment ?? defaults.alignment!;
    final TextDirection textDirection = Directionality.of(context);
    final Offset defaultOffset = textDirection == TextDirection.ltr
        ? const Offset(4, -4)
        : const Offset(-4, -4);
    final Offset effectiveOffset = offset ?? badgeTheme.offset ?? defaultOffset;

    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        child!,
        Positioned.fill(
          child: _Badge(
            alignment: effectiveAlignment,
            offset: label == null ? Offset.zero : effectiveOffset,
            textDirection: textDirection,
            child: badge,
          ),
        ),
      ],
    );
  }
}

class _Badge extends SingleChildRenderObjectWidget {
  const _Badge({
    required this.alignment,
    required this.offset,
    required this.textDirection,
    super.child, // the badge
  });

  final AlignmentGeometry alignment;
  final Offset offset;
  final TextDirection textDirection;

  @override
  _RenderBadge createRenderObject(BuildContext context) {
    return _RenderBadge(
      alignment: alignment,
      offset: offset,
      textDirection: Directionality.maybeOf(context),
    );
  }

  @override
  void updateRenderObject(BuildContext context, _RenderBadge renderObject) {
    renderObject
      ..alignment = alignment
      ..offset = offset
      ..textDirection = Directionality.maybeOf(context);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty<AlignmentGeometry>('alignment', alignment));
    properties.add(DiagnosticsProperty<Offset>('offset', offset));
  }
}

class _RenderBadge extends RenderAligningShiftedBox {
  _RenderBadge({
    required Offset offset,
    super.textDirection,
    super.alignment,
  }) : _offset = offset;

  Offset get offset => _offset;
  Offset _offset;

  set offset(Offset value) {
    if (_offset == value) {
      return;
    }
    _offset = value;
    markNeedsLayout();
  }

  @override
  void performLayout() {
    final BoxConstraints constraints = this.constraints;
    assert(constraints.hasBoundedWidth);
    assert(constraints.hasBoundedHeight);
    size = constraints.biggest;

    child!.layout(const BoxConstraints(), parentUsesSize: true);
    final double badgeSize = child!.size.height;
    final Alignment resolvedAlignment = alignment.resolve(textDirection);
    final BoxParentData childParentData = child!.parentData! as BoxParentData;
    childParentData.offset = offset +
        resolvedAlignment.alongOffset(
          Offset(size.width - badgeSize, size.height - badgeSize),
        );
  }
}

@Deprecated('This will be removed in the next major version.')
class _BadgeDefaultsM3 extends TxBadgeThemeData {
  _BadgeDefaultsM3(this.context)
      : super(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
          ),
        );

  final BuildContext context;
  late final ThemeData _theme = Theme.of(context);
  late final ColorScheme _colors = _theme.colorScheme;

  @override
  BadgeThemeData? get badgeTheme => BadgeThemeData(
        smallSize: 6.0,
        largeSize: 20.0,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        alignment: AlignmentDirectional.topEnd,
        textColor: _colors.onPrimary,
        textStyle: Theme.of(context).textTheme.labelSmall,
        backgroundColor: _colors.primary,
      );
}
