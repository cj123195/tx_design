import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'tile_theme.dart';

class _IndividualOverrides extends WidgetStateProperty<Color?> {
  _IndividualOverrides({
    this.explicitColor,
    this.enabledColor,
    this.focusColor,
    this.disabledColor,
  });

  final Color? explicitColor;
  final Color? enabledColor;
  final Color? focusColor;
  final Color? disabledColor;

  @override
  Color? resolve(Set<WidgetState> states) {
    if (explicitColor is WidgetStateColor) {
      return WidgetStateProperty.resolveAs<Color?>(explicitColor, states);
    }
    if (states.contains(WidgetState.disabled)) {
      return disabledColor;
    }
    if (states.contains(WidgetState.focused)) {
      return focusColor;
    }
    return enabledColor;
  }
}

/// 一个域组件布局容器
class TxTile extends StatelessWidget {
  TxTile({
    required this.content,
    super.key,
    Widget? label,
    String? labelText,
    this.labelTextAlign,
    this.labelOverflow,
    this.padding,
    this.actions,
    this.labelStyle,
    this.horizontalGap,
    this.tileColor,
    this.layoutDirection,
    this.trailing,
    this.leading,
    this.visualDensity,
    this.shape,
    this.iconColor,
    this.textColor,
    this.leadingAndTrailingTextStyle,
    this.enabled = true,
    this.onTap,
    this.minLeadingWidth,
    this.dense,
    this.minLabelWidth,
    this.minVerticalPadding,
    this.colon,
    this.focused = false,
    this.focusColor,
  })  : assert(
          label == null || labelText == null,
          'label 和 labelText 最多指定一个',
        ),
        assert(
          actions == null || trailing == null,
          'actions 和 trailing 最多指定一个',
        ),
        label = label ?? (labelText == null ? null : Text(labelText));

  /// 内容
  final Widget content;

  /// 描述输入字段的可选小部件。
  final Widget? label;

  /// [label] 文字样式
  ///
  /// 默认值为[TextTheme.labelLarge]
  final TextStyle? labelStyle;

  /// [label] 文字的对齐方式
  final TextAlign? labelTextAlign;

  /// [label] 文字溢出处理方式
  final TextOverflow? labelOverflow;

  /// 背景颜色
  final Color? tileColor;

  /// [label]与表单框排列的方向
  ///
  /// [Axis.vertical] 纵向
  /// [Axis.horizontal] 横向
  /// 默认为[Axis.vertical]
  final Axis? layoutDirection;

  /// 内边距
  final EdgeInsetsGeometry? padding;

  /// 操作按钮
  ///
  /// 当 [layoutDirection] 为 [Axis.horizontal] 时显示在 [content] 之后；
  /// 当 [layoutDirection] 为 [Axis.vertical] 时显示在标题栏尾部，
  /// 参考 [ListTile.trailing] 的位置。
  ///
  /// [actions] 和 [trailing] 只能指定一个。
  final List<Widget>? actions;

  /// 操作按钮
  ///
  /// 参考 [ListTile.trailing] 的位置
  ///
  /// [actions] 和 [trailing] 只能指定一个。
  final Widget? trailing;

  /// 参考 [ListTile.leading]
  final Widget? leading;

  /// [label]、[content]、[trailing] 间距
  ///
  /// 仅当[layoutDirection]为[Axis.horizontal]时生效
  final double? horizontalGap;

  /// 参考 [ListTile.visualDensity]。
  final VisualDensity? visualDensity;

  /// 参考 [ListTile.shape]
  final ShapeBorder? shape;

  /// 参考 [ListTile.iconColor]
  final Color? iconColor;

  /// 参考 [ListTile.textColor]
  final Color? textColor;

  /// 参考 [ListTile.leadingAndTrailingTextStyle]
  final TextStyle? leadingAndTrailingTextStyle;

  /// 参考 [ListTile.enabled]
  final bool enabled;

  /// 参考 [ListTile.onTap]
  final GestureTapCallback? onTap;

  /// 参考 [ListTile.minLeadingWidth]
  final double? minLeadingWidth;

  /// 限制 [label] 的最小宽度。
  final double? minLabelWidth;

  /// 最小纵向内边距。
  final double? minVerticalPadding;

  /// 参考 [ListTile.dense]
  final bool? dense;

  /// 是否显示冒号
  final bool? colon;

  /// 是否选中
  final bool focused;

  /// 选中的文字和图标颜色
  final Color? focusColor;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TxTileThemeData tileTheme = TxTileTheme.of(context);
    final TxTileThemeData defaults = _FieldTileDefaultsM3(context);

    final Set<WidgetState> states = <WidgetState>{
      if (!enabled) WidgetState.disabled,
      if (focused) WidgetState.focused,
    };

    Color? resolveColor(
      Color? explicitColor,
      Color? focusColor,
      Color? enabledColor, [
      Color? disabledColor,
    ]) {
      return _IndividualOverrides(
        explicitColor: explicitColor,
        focusColor: focusColor,
        enabledColor: enabledColor,
        disabledColor: disabledColor,
      ).resolve(states);
    }

    final Color? effectiveIconColor = resolveColor(
            iconColor, focusColor, iconColor) ??
        resolveColor(
            tileTheme.iconColor, tileTheme.focusColor, tileTheme.iconColor) ??
        resolveColor(defaults.iconColor, defaults.focusColor,
            defaults.iconColor, theme.disabledColor);
    final Color? effectiveColor = resolveColor(
            textColor, focusColor, textColor) ??
        resolveColor(
            tileTheme.textColor, tileTheme.focusColor, tileTheme.textColor) ??
        resolveColor(defaults.textColor, defaults.focusColor,
            defaults.textColor, theme.disabledColor);

    final Color? effectiveTileColor =
        tileColor ?? tileTheme.tileColor ?? defaults.tileColor;
    final EdgeInsetsGeometry effectivePadding =
        padding ?? tileTheme.padding ?? defaults.padding!;
    final double effectiveHorizontalGap =
        horizontalGap ?? tileTheme.horizontalGap ?? defaults.horizontalGap!;
    final VisualDensity effectiveVisualDensity =
        visualDensity ?? tileTheme.visualDensity ?? defaults.visualDensity!;
    final bool effectiveDense = dense ?? tileTheme.dense ?? defaults.dense!;
    final double effectiveMinLeadingWidth = minLeadingWidth ??
        tileTheme.minLeadingWidth ??
        defaults.minLeadingWidth!;
    final double effectiveMinLabelWidth =
        minLabelWidth ?? tileTheme.minLabelWidth ?? defaults.minLabelWidth!;
    final double effectiveMinVerticalPadding = minVerticalPadding ??
        tileTheme.minVerticalPadding ??
        defaults.minVerticalPadding!;
    final ShapeBorder effectiveShape =
        shape ?? tileTheme.shape ?? defaults.shape!;
    final Axis effectiveDirection = layoutDirection ??
        tileTheme.layoutDirection ??
        defaults.layoutDirection!;
    final bool isVertical = effectiveDirection == Axis.vertical;

    TextStyle effectiveLabelStyle =
        labelStyle ?? tileTheme.labelStyle ?? defaults.labelStyle!;

    effectiveLabelStyle = effectiveLabelStyle.copyWith(
      color: effectiveColor,
      fontSize: effectiveDense
          ? effectiveLabelStyle.fontSize == null
              ? 13.0
              : effectiveLabelStyle.fontSize! * 0.9
          : null,
    );
    final TextAlign? effectiveLabelTextAlign =
        labelTextAlign ?? tileTheme.labelTextAlign ?? defaults.labelTextAlign;
    final TextOverflow effectiveLabelOverflow =
        labelOverflow ?? tileTheme.labelOverflow ?? defaults.labelOverflow!;
    final Widget? labelWidget = label == null
        ? null
        : DefaultTextStyle(
            style: effectiveLabelStyle,
            textAlign: effectiveLabelTextAlign,
            overflow: effectiveLabelOverflow,
            child: label!,
          );

    final IconThemeData iconThemeData =
        IconThemeData(color: effectiveIconColor, size: 20.0);
    final IconButtonThemeData iconButtonThemeData = IconButtonThemeData(
      style: IconButton.styleFrom(foregroundColor: effectiveIconColor),
    );

    TextStyle? leadingAndTrailingStyle;
    if (leading != null || trailing != null || actions?.isNotEmpty == true) {
      leadingAndTrailingStyle = leadingAndTrailingTextStyle ??
          tileTheme.leadingAndTrailingTextStyle ??
          defaults.leadingAndTrailingTextStyle!;
      final Color? leadingAndTrailingTextColor = effectiveColor;
      leadingAndTrailingStyle = leadingAndTrailingStyle.copyWith(
        color: leadingAndTrailingTextColor,
        fontSize: effectiveDense
            ? leadingAndTrailingStyle.fontSize == null
                ? 12.0
                : leadingAndTrailingStyle.fontSize! * 0.9
            : null,
      );
    }

    Widget? leadingIcon;
    if (leading != null) {
      leadingIcon = AnimatedDefaultTextStyle(
        style: leadingAndTrailingStyle!,
        duration: kThemeChangeDuration,
        child: leading!,
      );
    }

    Widget? trailingIcon;
    if (trailing != null || actions?.isNotEmpty == true) {
      trailingIcon = AnimatedDefaultTextStyle(
        style: leadingAndTrailingStyle!,
        duration: kThemeChangeDuration,
        child:
            trailing ?? Row(mainAxisSize: MainAxisSize.min, children: actions!),
      );
    }

    return InkWell(
      customBorder: shape ?? tileTheme.shape,
      onTap: enabled ? onTap : null,
      canRequestFocus: enabled,
      child: Semantics(
        enabled: enabled,
        child: Ink(
          decoration: ShapeDecoration(
            shape: effectiveShape,
            color: effectiveTileColor,
          ),
          child: SafeArea(
            top: false,
            bottom: false,
            minimum: effectivePadding.resolve(TextDirection.ltr),
            child: IconTheme.merge(
              data: iconThemeData,
              child: IconButtonTheme(
                data: iconButtonThemeData,
                child: _FieldTile(
                  isVertical: isVertical,
                  leading: leadingIcon,
                  content: content,
                  label: labelWidget,
                  trailing: trailingIcon,
                  isDense: effectiveDense,
                  visualDensity: effectiveVisualDensity,
                  horizontalTitleGap: effectiveHorizontalGap,
                  minLeadingWidth: effectiveMinLeadingWidth,
                  minLabelWidth: effectiveMinLabelWidth,
                  minVerticalPadding: effectiveMinVerticalPadding,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 标识_FieldTileElement的子项。
enum _FieldTileSlot {
  leading,
  label,
  content,
  trailing,
}

class _FieldTile
    extends SlottedMultiChildRenderObjectWidget<_FieldTileSlot, RenderBox> {
  const _FieldTile({
    required this.content,
    required this.isVertical,
    required this.isDense,
    required this.visualDensity,
    required this.horizontalTitleGap,
    required this.minLeadingWidth,
    required this.minLabelWidth,
    required this.minVerticalPadding,
    this.leading,
    this.label,
    this.trailing,
  });

  final Widget? leading;
  final Widget content;
  final Widget? label;
  final Widget? trailing;
  final bool isVertical;
  final bool isDense;
  final VisualDensity visualDensity;
  final double horizontalTitleGap;
  final double minLeadingWidth;
  final double minLabelWidth;
  final double minVerticalPadding;

  @override
  Iterable<_FieldTileSlot> get slots => _FieldTileSlot.values;

  @override
  Widget? childForSlot(_FieldTileSlot slot) {
    switch (slot) {
      case _FieldTileSlot.leading:
        return leading;
      case _FieldTileSlot.label:
        return label;
      case _FieldTileSlot.content:
        return content;
      case _FieldTileSlot.trailing:
        return trailing;
    }
  }

  @override
  _RenderFieldTile createRenderObject(BuildContext context) {
    return _RenderFieldTile(
      isVertical: isVertical,
      isDense: isDense,
      visualDensity: visualDensity,
      horizontalTitleGap: horizontalTitleGap,
      minLeadingWidth: minLeadingWidth,
      minLabelWidth: minLabelWidth,
      minVerticalPadding: minVerticalPadding,
    );
  }

  @override
  void updateRenderObject(BuildContext context, _RenderFieldTile renderObject) {
    renderObject
      ..isVertical = isVertical
      ..isDense = isDense
      ..visualDensity = visualDensity
      ..horizontalTitleGap = horizontalTitleGap
      ..minLeadingWidth = minLeadingWidth
      ..minLabelWidth = minLabelWidth
      ..minVerticalPadding = minVerticalPadding;
  }
}

class _RenderFieldTile extends RenderBox
    with SlottedContainerRenderObjectMixin<_FieldTileSlot, RenderBox> {
  _RenderFieldTile({
    required bool isDense,
    required VisualDensity visualDensity,
    required bool isVertical,
    required double horizontalTitleGap,
    required double minLeadingWidth,
    required double minLabelWidth,
    required double minVerticalPadding,
  })  : _isDense = isDense,
        _visualDensity = visualDensity,
        _isVertical = isVertical,
        _horizontalTitleGap = horizontalTitleGap,
        _minLeadingWidth = minLeadingWidth,
        _minLabelWidth = minLabelWidth,
        _minVerticalPadding = minVerticalPadding;

  RenderBox? get leading => childForSlot(_FieldTileSlot.leading);

  RenderBox? get label => childForSlot(_FieldTileSlot.label);

  RenderBox? get content => childForSlot(_FieldTileSlot.content);

  RenderBox? get trailing => childForSlot(_FieldTileSlot.trailing);

// The returned list is ordered for hit testing.
  @override
  Iterable<RenderBox> get children {
    return <RenderBox>[
      if (leading != null) leading!,
      if (label != null) label!,
      if (content != null) content!,
      if (trailing != null) trailing!,
    ];
  }

  bool get isDense => _isDense;
  bool _isDense;

  set isDense(bool value) {
    if (_isDense == value) {
      return;
    }
    _isDense = value;
    markNeedsLayout();
  }

  VisualDensity get visualDensity => _visualDensity;
  VisualDensity _visualDensity;

  set visualDensity(VisualDensity value) {
    if (_visualDensity == value) {
      return;
    }
    _visualDensity = value;
    markNeedsLayout();
  }

  bool get isVertical => _isVertical;
  bool _isVertical;

  set isVertical(bool value) {
    if (_isVertical == value) {
      return;
    }
    _isVertical = value;
    markNeedsLayout();
  }

  double get horizontalTitleGap => _horizontalTitleGap;
  double _horizontalTitleGap;

  double get _effectiveHorizontalTitleGap =>
      _horizontalTitleGap + visualDensity.horizontal * 2.0;

  set horizontalTitleGap(double value) {
    if (_horizontalTitleGap == value) {
      return;
    }
    _horizontalTitleGap = value;
    markNeedsLayout();
  }

  double get minLeadingWidth => _minLeadingWidth;
  double _minLeadingWidth;

  set minLeadingWidth(double value) {
    if (_minLeadingWidth == value) {
      return;
    }
    _minLeadingWidth = value;
    markNeedsLayout();
  }

  double get minLabelWidth => _minLabelWidth;
  double _minLabelWidth;

  set minLabelWidth(double value) {
    if (_minLabelWidth == value) {
      return;
    }
    _minLabelWidth = value;
    markNeedsLayout();
  }

  double get minVerticalPadding => _minVerticalPadding;
  double _minVerticalPadding;

  set minVerticalPadding(double value) {
    if (_minVerticalPadding == value) {
      return;
    }
    _minVerticalPadding = value;
    markNeedsLayout();
  }

  @override
  bool get sizedByParent => false;

  static double _minWidth(RenderBox? box, double height) {
    return box == null ? 0.0 : box.getMinIntrinsicWidth(height);
  }

  static double _maxWidth(RenderBox? box, double height) {
    return box == null ? 0.0 : box.getMaxIntrinsicWidth(height);
  }

  static const double _verticalGap = 4.0;

  @override
  double computeMinIntrinsicWidth(double height) {
    final double leadingWidth = leading != null
        ? math.max(leading!.getMinIntrinsicWidth(height), _minLeadingWidth) +
            _effectiveHorizontalTitleGap
        : 0.0;

    final double labelWidth = label != null
        ? math.max(label!.getMinIntrinsicWidth(height), _minLabelWidth)
        : 0.0;

    final double minWith =
        leadingWidth + labelWidth + _maxWidth(trailing, height);

    final double contentWidth = _minWidth(content, height);

    return isVertical
        ? math.max(minWith, contentWidth)
        : minWith + contentWidth + _effectiveHorizontalTitleGap;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    final double leadingWidth = leading != null
        ? math.max(leading!.getMaxIntrinsicWidth(height), _minLeadingWidth) +
            _effectiveHorizontalTitleGap
        : 0.0;

    final double labelWidth = label != null
        ? math.max(label!.getMaxIntrinsicWidth(height), _minLabelWidth)
        : 0.0;

    final double maxWidth =
        leadingWidth + labelWidth + _maxWidth(trailing, height);

    final double contentWidth = _maxWidth(content, height);

    return isVertical
        ? math.max(maxWidth, contentWidth)
        : maxWidth + contentWidth + _effectiveHorizontalTitleGap;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    final double labelHeight = label?.getMinIntrinsicHeight(width) ?? 0.0;
    final double contentHeight = content!.getMinIntrinsicHeight(width);
    return _isVertical
        ? labelHeight + contentHeight
        : math.max(labelHeight, contentHeight);
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return computeMinIntrinsicHeight(width);
  }

  @override
  double computeDistanceToActualBaseline(TextBaseline baseline) {
    assert(content != null);
    final BoxParentData parentData = content!.parentData! as BoxParentData;
    return parentData.offset.dy +
        content!.getDistanceToActualBaseline(baseline)!;
  }

  static Size _layoutBox(RenderBox? box, BoxConstraints constraints) {
    if (box == null) {
      return Size.zero;
    }
    box.layout(constraints, parentUsesSize: true);
    return box.size;
  }

  static void _positionBox(RenderBox box, Offset offset) {
    final BoxParentData parentData = box.parentData! as BoxParentData;
    parentData.offset = offset;
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    assert(
      debugCannotComputeDryLayout(
        reason:
            'Layout requires baseline metrics, which are only available after '
            'a full layout.',
      ),
    );
    return Size.zero;
  }

  double _computeY(double maxHeight, double height) {
    final double diff = (maxHeight - height) / 2;
    return math.min(16.0, diff);
  }

  @override
  void performLayout() {
    final BoxConstraints constraints = this.constraints;
    final bool hasLeading = leading != null;
    final bool hasLabel = label != null;
    final bool hasTrailing = trailing != null;
    final bool isTwoLine = hasLabel && _isVertical;
    final bool isOneLine = !_isVertical || !hasLabel;
    final Offset densityAdjustment = visualDensity.baseSizeAdjustment;

    final BoxConstraints maxIconHeightConstraint = BoxConstraints(
// One-line trailing and leading widget heights do not follow
// Material specifications, but this sizing is required to adhere
// to accessibility requirements for smallest tappable widget.
// Two- and three-line trailing widget heights are constrained
// properly according to the Material spec.
      maxHeight: (isDense ? 48.0 : 56.0) + densityAdjustment.dy,
    );
    final BoxConstraints looseConstraints = constraints.loosen();
    final BoxConstraints iconConstraints =
        looseConstraints.enforce(maxIconHeightConstraint);

    final double tileWidth = looseConstraints.maxWidth;
    final Size leadingSize = _layoutBox(leading, iconConstraints);
    final Size trailingSize = _layoutBox(trailing, iconConstraints);
    assert(
      tileWidth != leadingSize.width || tileWidth == 0.0,
      'Leading widget consumes entire tile width. Please use a sized widget, '
      'or consider replacing TxFieldTile with a custom widget ',
    );
    assert(
      tileWidth != trailingSize.width || tileWidth == 0.0,
      'Trailing widget consumes entire tile width. Please use a sized widget, '
      'or consider replacing TxFieldTile with a custom widget ',
    );

    final double labelStart = hasLeading
        ? math.max(_minLeadingWidth, leadingSize.width) +
            _effectiveHorizontalTitleGap
        : 0.0;
    final double adjustedTrailingWidth = hasTrailing
        ? math.max(trailingSize.width + _effectiveHorizontalTitleGap, 32.0)
        : 0.0;

    final BoxConstraints labelConstraints;
    final BoxConstraints contentConstraints;
    if (isTwoLine) {
      labelConstraints = looseConstraints.tighten(
        width: tileWidth - labelStart - adjustedTrailingWidth,
      );
      contentConstraints = looseConstraints.tighten(width: tileWidth);
    } else {
      final labelWidth = math.max(
        label?.getMaxIntrinsicWidth(maxIconHeightConstraint.maxHeight) ?? 0.0,
        _minLabelWidth,
      );
      labelConstraints = BoxConstraints(maxWidth: labelWidth);
      contentConstraints = looseConstraints.tighten(
        width: tileWidth -
            labelStart -
            adjustedTrailingWidth -
            labelConstraints.maxWidth,
      );
    }

    final Size contentSize = _layoutBox(content, contentConstraints);
    final Size labelSize = _layoutBox(label, labelConstraints);

    final double contentStart = isOneLine
        ? hasLabel
            ? labelStart + labelSize.width + _effectiveHorizontalTitleGap
            : labelStart
        : 0.0;

    double tileHeight = math.max(
        math.max(labelSize.height, leadingSize.height), trailingSize.height);

    double contentY;
    double? labelY;
    final double leadingY;
    final double trailingY;
    if (isOneLine) {
      tileHeight = math.max(tileHeight, contentSize.height);
      contentY = _computeY(tileHeight, contentSize.height);
      labelY = _computeY(tileHeight, labelSize.height);
      leadingY = _computeY(tileHeight, leadingSize.height);
      trailingY = _computeY(tileHeight, trailingSize.height);
    } else {
      labelY = _computeY(tileHeight, labelSize.height);
      leadingY = _computeY(tileHeight, leadingSize.height);
      trailingY = _computeY(tileHeight, trailingSize.height);
      contentY = tileHeight + _verticalGap + visualDensity.vertical * 2.0;
      tileHeight = contentY + contentSize.height;
    }

    if (hasLeading) {
      _positionBox(leading!, Offset(0.0, leadingY));
    }
    if (hasLabel) {
      _positionBox(label!, Offset(labelStart, labelY));
    }
    _positionBox(content!, Offset(contentStart, contentY));
    if (hasTrailing) {
      _positionBox(
          trailing!, Offset(tileWidth - trailingSize.width, trailingY));
    }

    size = constraints.constrain(Size(tileWidth, tileHeight));
    assert(size.width == constraints.constrainWidth(tileWidth));
    assert(size.height == constraints.constrainHeight(tileHeight));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    void doPaint(RenderBox? child) {
      if (child != null) {
        final BoxParentData parentData = child.parentData! as BoxParentData;
        context.paintChild(child, parentData.offset + offset);
      }
    }

    doPaint(leading);
    doPaint(label);
    doPaint(content);
    doPaint(trailing);
  }

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    for (final RenderBox child in children) {
      final BoxParentData parentData = child.parentData! as BoxParentData;
      final bool isHit = result.addWithPaintOffset(
        offset: parentData.offset,
        position: position,
        hitTest: (BoxHitTestResult result, Offset transformed) {
          assert(transformed == position - parentData.offset);
          return child.hitTest(result, position: transformed);
        },
      );
      if (isHit) {
        return true;
      }
    }
    return false;
  }
}

class _FieldTileDefaultsM3 extends TxTileThemeData {
  _FieldTileDefaultsM3(this.context)
      : super(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          minLeadingWidth: 0,
          shape: const RoundedRectangleBorder(),
          horizontalGap: 8.0,
          layoutDirection: Axis.vertical,
          dense: false,
          visualDensity: VisualDensity.comfortable,
          minLabelWidth: 0,
          labelOverflow: TextOverflow.ellipsis,
          minVerticalPadding: 0,
        );

  final BuildContext context;
  late final ThemeData _theme = Theme.of(context);
  late final ColorScheme _colors = _theme.colorScheme;
  late final TextTheme _textTheme = _theme.textTheme;

  @override
  Color? get textColor => _colors.onSurface;

  @override
  Color? get tileColor => Colors.transparent;

  @override
  TextStyle? get labelStyle => _textTheme.titleMedium;

  @override
  TextStyle? get leadingAndTrailingTextStyle =>
      _textTheme.labelSmall!.copyWith(color: _colors.onSurfaceVariant);

  @override
  Color? get iconColor => _colors.onSurfaceVariant;
}
