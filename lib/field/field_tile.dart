import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'field_tile_theme.dart';

typedef LabelBuilder = Widget Function(TextStyle style);

/// 一个域组件布局容器
class TxFieldTile extends StatelessWidget {
  const TxFieldTile({
    required this.field,
    super.key,
    this.labelBuilder,
    this.labelText,
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
  })  : assert(
          labelBuilder == null || labelText == null,
          'labelBuilder 和 labelText 最多指定一个',
        ),
        assert(
          actions == null || trailing == null,
          'actions 和 trailing 最多指定一个',
        );

  /// 表单项
  final Widget field;

  /// 描述输入字段的可选文本。
  ///
  /// 如果需要更详细的标签，可以考虑使用 [labelBuilder]。
  /// [labelBuilder] 和 [labelText] 只能指定一个。
  final String? labelText;

  /// 描述输入字段的可选小部件。
  ///
  /// 只能指定 [labelBuilder] 和 [labelText] 之一。
  final LabelBuilder? labelBuilder;

  /// [labelText] 与 [labelBuilder] 文字样式
  ///
  /// 默认值为[TextTheme.labelLarge]
  final TextStyle? labelStyle;

  /// 背景颜色
  final Color? tileColor;

  /// [labelBuilder]与表单框排列的方向
  ///
  /// [Axis.vertical] 纵向
  /// [Axis.horizontal] 横向
  /// 默认为[Axis.vertical]
  final Axis? layoutDirection;

  /// 内边距
  final EdgeInsetsGeometry? padding;

  /// 操作按钮
  ///
  /// 当 [layoutDirection] 为 [Axis.horizontal] 时显示在 [field] 之后；
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

  /// [labelBuilder]、[field]、[trailing] 间距
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

  /// 限制 [labelBuilder] 或 [labelText] 的最小宽度。
  final double? minLabelWidth;

  /// 最小垂直方向内边距。
  final double? minVerticalPadding;

  /// 参考 [ListTile.dense]
  final bool? dense;

  @override
  Widget build(BuildContext context) {
    final TxFieldTileThemeData tileTheme = TxFieldTileTheme.of(context);
    final TxFieldTileThemeData defaults = _FieldTileDefaultsM3(context);

    final Color? effectiveTileColor =
        tileColor ?? tileTheme.tileColor ?? defaults.tileColor;
    final Color? effectiveTextColor =
        textColor ?? tileTheme.textColor ?? defaults.textColor;
    final Color? effectiveIconColor =
        iconColor ?? tileTheme.iconColor ?? defaults.iconColor;
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
      color: textColor,
      fontSize: effectiveDense
          ? effectiveLabelStyle.fontSize == null
              ? 13.0
              : effectiveLabelStyle.fontSize! * 0.9
          : null,
    );
    final Widget? labelWidget = labelBuilder == null && labelText == null
        ? null
        : DefaultTextStyle(
            style: effectiveLabelStyle,
            child: labelBuilder?.call(effectiveLabelStyle) ?? Text(labelText!),
          );

    final IconThemeData iconThemeData =
        IconThemeData(color: effectiveIconColor);
    final IconButtonThemeData iconButtonThemeData = IconButtonThemeData(
      style: IconButton.styleFrom(foregroundColor: effectiveIconColor),
    );

    TextStyle? leadingAndTrailingStyle;
    if (leading != null || trailing != null) {
      leadingAndTrailingStyle = leadingAndTrailingTextStyle ??
          tileTheme.leadingAndTrailingTextStyle ??
          defaults.leadingAndTrailingTextStyle!;
      final Color? leadingAndTrailingTextColor = effectiveTextColor;
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
                  field: field,
                  labelBuilder: labelWidget,
                  trailing: trailingIcon,
                  isDense: effectiveDense,
                  visualDensity: effectiveVisualDensity,
                  titleBaselineType: effectiveLabelStyle.textBaseline ??
                      defaults.labelStyle!.textBaseline!,
                  subtitleBaselineType: effectiveLabelStyle.textBaseline ??
                      defaults.labelStyle!.textBaseline!,
                  horizontalTitleGap: effectiveHorizontalGap,
                  minVerticalPadding: effectiveMinVerticalPadding,
                  minLeadingWidth: effectiveMinLeadingWidth,
                  minLabelWidth: effectiveMinLabelWidth,
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
  labelBuilder,
  field,
  trailing,
}

class _FieldTile
    extends SlottedMultiChildRenderObjectWidget<_FieldTileSlot, RenderBox> {
  const _FieldTile({
    required this.field,
    required this.isVertical,
    required this.isDense,
    required this.visualDensity,
    required this.horizontalTitleGap,
    required this.minLeadingWidth,
    required this.minLabelWidth,
    required this.titleBaselineType,
    required this.minVerticalPadding,
    this.subtitleBaselineType,
    this.leading,
    this.labelBuilder,
    this.trailing,
  });

  final Widget? leading;
  final Widget field;
  final Widget? labelBuilder;
  final Widget? trailing;
  final bool isVertical;
  final bool isDense;
  final VisualDensity visualDensity;
  final double horizontalTitleGap;
  final double minLeadingWidth;
  final double minLabelWidth;
  final TextBaseline titleBaselineType;
  final TextBaseline? subtitleBaselineType;
  final double minVerticalPadding;

  @override
  Iterable<_FieldTileSlot> get slots => _FieldTileSlot.values;

  @override
  Widget? childForSlot(_FieldTileSlot slot) {
    switch (slot) {
      case _FieldTileSlot.leading:
        return leading;
      case _FieldTileSlot.labelBuilder:
        return labelBuilder;
      case _FieldTileSlot.field:
        return field;
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
      titleBaselineType: titleBaselineType,
      subtitleBaselineType: subtitleBaselineType,
      minVerticalPadding: minVerticalPadding,
    );
  }

  @override
  void updateRenderObject(BuildContext context, _RenderFieldTile renderObject) {
    renderObject
      ..isVertical = isVertical
      ..isDense = isDense
      ..visualDensity = visualDensity
      ..titleBaselineType = titleBaselineType
      ..subtitleBaselineType = subtitleBaselineType
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
    required TextBaseline titleBaselineType,
    required double minVerticalPadding,
    TextBaseline? subtitleBaselineType,
  })  : _isDense = isDense,
        _visualDensity = visualDensity,
        _isVertical = isVertical,
        _horizontalTitleGap = horizontalTitleGap,
        _minLeadingWidth = minLeadingWidth,
        _minLabelWidth = minLabelWidth,
        _titleBaselineType = titleBaselineType,
        _minVerticalPadding = minVerticalPadding,
        _subtitleBaselineType = subtitleBaselineType;

  RenderBox? get leading => childForSlot(_FieldTileSlot.leading);

  RenderBox? get labelBuilder => childForSlot(_FieldTileSlot.labelBuilder);

  RenderBox? get field => childForSlot(_FieldTileSlot.field);

  RenderBox? get trailing => childForSlot(_FieldTileSlot.trailing);

  // The returned list is ordered for hit testing.
  @override
  Iterable<RenderBox> get children {
    return <RenderBox>[
      if (leading != null) leading!,
      if (labelBuilder != null) labelBuilder!,
      if (field != null) field!,
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

  TextBaseline get titleBaselineType => _titleBaselineType;
  TextBaseline _titleBaselineType;

  set titleBaselineType(TextBaseline value) {
    if (_titleBaselineType == value) {
      return;
    }
    _titleBaselineType = value;
    markNeedsLayout();
  }

  TextBaseline? get subtitleBaselineType => _subtitleBaselineType;
  TextBaseline? _subtitleBaselineType;

  set subtitleBaselineType(TextBaseline? value) {
    if (_subtitleBaselineType == value) {
      return;
    }
    _subtitleBaselineType = value;
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

  @override
  double computeMinIntrinsicWidth(double height) {
    final double leadingWidth = leading != null
        ? math.max(leading!.getMinIntrinsicWidth(height), _minLeadingWidth) +
            _effectiveHorizontalTitleGap
        : 0.0;

    final double labelWidth = labelBuilder != null
        ? math.max(labelBuilder!.getMinIntrinsicWidth(height), _minLabelWidth)
        : 0.0;

    final double minWith =
        leadingWidth + labelWidth + _maxWidth(trailing, height);

    final double fieldWidth = _minWidth(field, height);

    return isVertical
        ? math.max(minWith, fieldWidth)
        : minWith + fieldWidth + _effectiveHorizontalTitleGap;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    final double leadingWidth = leading != null
        ? math.max(leading!.getMaxIntrinsicWidth(height), _minLeadingWidth) +
            _effectiveHorizontalTitleGap
        : 0.0;

    final double labelWidth = labelBuilder != null
        ? math.max(labelBuilder!.getMaxIntrinsicWidth(height), _minLabelWidth)
        : 0.0;

    final double maxWidth =
        leadingWidth + labelWidth + _maxWidth(trailing, height);

    final double fieldWidth = _maxWidth(field, height);

    return isVertical
        ? math.max(maxWidth, fieldWidth)
        : maxWidth + fieldWidth + _effectiveHorizontalTitleGap;
  }

  double get _defaultTileHeight {
    final bool hasLabel = labelBuilder != null;
    final bool isOneLine = !_isVertical || !hasLabel;

    final Offset baseDensity = visualDensity.baseSizeAdjustment;
    if (isOneLine) {
      return (isDense ? 48.0 : 56.0) + baseDensity.dy;
    }
    return (isDense ? 64.0 : 72.0) + baseDensity.dy;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    final double labelHeight =
        labelBuilder?.getMinIntrinsicHeight(width) ?? 0.0;
    final double fieldHeight = field!.getMinIntrinsicHeight(width);
    return math.max(
      _defaultTileHeight,
      _isVertical
          ? labelHeight + fieldHeight
          : math.max(labelHeight, fieldHeight),
    );
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return computeMinIntrinsicHeight(width);
  }

  @override
  double computeDistanceToActualBaseline(TextBaseline baseline) {
    assert(field != null);
    final BoxParentData parentData = field!.parentData! as BoxParentData;
    return parentData.offset.dy + field!.getDistanceToActualBaseline(baseline)!;
  }

  static double? _boxBaseline(RenderBox box, TextBaseline baseline) {
    return box.getDistanceToBaseline(baseline);
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

  // All of the dimensions below were taken from the Material Design spec:
  // https://material.io/design/components/lists.html#specs
  @override
  void performLayout() {
    final BoxConstraints constraints = this.constraints;
    final bool hasLeading = leading != null;
    final bool hasLabel = labelBuilder != null;
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
    final BoxConstraints fieldConstraints;
    if (isTwoLine) {
      labelConstraints = looseConstraints.tighten(
        width: tileWidth - labelStart - adjustedTrailingWidth,
      );
      fieldConstraints = looseConstraints.tighten(width: tileWidth);
    } else {
      final labelWidth = math.max(
        labelBuilder?.getMaxIntrinsicWidth(maxIconHeightConstraint.maxHeight) ??
            0.0,
        _minLabelWidth,
      );
      labelConstraints = BoxConstraints(maxWidth: labelWidth);
      fieldConstraints = looseConstraints.tighten(
        width: tileWidth -
            labelStart -
            adjustedTrailingWidth -
            labelConstraints.maxWidth,
      );
    }

    final Size fieldSize = _layoutBox(field, fieldConstraints);
    final Size labelSize = _layoutBox(labelBuilder, labelConstraints);

    final double fieldStart = isOneLine
        ? hasLabel
            ? labelStart + labelSize.width + _effectiveHorizontalTitleGap
            : labelStart
        : 0.0;

    double? titleBaseline;
    double? subtitleBaseline;
    if (isTwoLine) {
      titleBaseline = isDense ? 28.0 : 32.0;
      subtitleBaseline = isDense ? 48.0 : 52.0;
    } else {
      assert(isOneLine);
    }

    final double defaultTileHeight = _defaultTileHeight;

    double tileHeight;
    double fieldY;
    double? labelY;
    final double leadingY;
    final double trailingY;
    if (isOneLine) {
      tileHeight = math.max(
          defaultTileHeight, fieldSize.height + 2.0 * _minVerticalPadding);
      fieldY = (tileHeight - fieldSize.height) / 2.0;
      if (tileHeight > 72.0) {
        double maxHeight = labelSize.height > leadingSize.height &&
                labelSize.height > trailingSize.height
            ? labelSize.height
            : leadingSize.height > trailingSize.height
                ? leadingSize.height
                : trailingSize.height;
        maxHeight = math.max(36.0, maxHeight);
        labelY = math.min((maxHeight - labelSize.height) / 2, 16.0) +
            _minVerticalPadding;
        leadingY = math.min((maxHeight - leadingSize.height) / 2, 16.0) +
            _minVerticalPadding;
        trailingY = math.min((maxHeight - trailingSize.height) / 2, 16.0) +
            _minVerticalPadding;
      } else {
        labelY = (tileHeight - labelSize.height) / 2.0;
        leadingY = (tileHeight - leadingSize.height) / 2.0;
        trailingY = (tileHeight - trailingSize.height) / 2.0;
      }
    } else {
      assert(subtitleBaselineType != null);
      fieldY = subtitleBaseline! -
          _boxBaseline(field!, subtitleBaselineType!)! +
          visualDensity.vertical * 2.0;
      double titleY;
      double titleHeight;
      double titleOverlap;
      if (labelSize.height > leadingSize.height &&
          labelSize.height > trailingSize.height) {
        titleHeight = labelSize.height;
        titleY =
            titleBaseline! - _boxBaseline(labelBuilder!, titleBaselineType)!;
        titleOverlap = titleY + labelSize.height - fieldY;
      } else if (leadingSize.height > trailingSize.height) {
        titleHeight = leadingSize.height;
        titleY = titleBaseline! - _boxBaseline(leading!, titleBaselineType)!;
        titleOverlap = titleY + leadingSize.height - fieldY;
      } else {
        titleHeight = trailingSize.height;
        titleY = titleBaseline! - _boxBaseline(trailing!, titleBaselineType)!;
        titleOverlap = titleY + trailingSize.height - fieldY;
      }

      tileHeight = defaultTileHeight;

      if (titleOverlap > 0.0) {
        titleY -= titleOverlap / 2.0;
        fieldY += titleOverlap / 2.0;
      }

      // If the title or subtitle overflow tileHeight then punt: title
      // and subtitle are arranged in a column, tileHeight = column height plus
      // _minVerticalPadding on top and bottom.
      if (titleY < _minVerticalPadding ||
          (fieldY + fieldSize.height + _minVerticalPadding) > tileHeight) {
        tileHeight = titleHeight + fieldSize.height + 2.0 * _minVerticalPadding;
        titleY = _minVerticalPadding;
        fieldY = titleHeight + _minVerticalPadding;
        if (titleHeight == labelSize.height) {
          tileHeight += 4.0;
          fieldY += 4.0;
        }
      }

      labelY = math.min((titleHeight - labelSize.height) / 2, 16.0) + titleY;
      leadingY =
          math.min((titleHeight - leadingSize.height) / 2, 16.0) + titleY;
      trailingY =
          math.min((titleHeight - trailingSize.height) / 2, 16.0) + titleY;
    }

    if (hasLeading) {
      _positionBox(leading!, Offset(0.0, leadingY));
    }
    if (hasLabel) {
      _positionBox(labelBuilder!, Offset(labelStart, labelY));
    }
    _positionBox(field!, Offset(fieldStart, fieldY));
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
    doPaint(labelBuilder);
    doPaint(field);
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

class _FieldTileDefaultsM3 extends TxFieldTileThemeData {
  _FieldTileDefaultsM3(this.context)
      : super(
          padding: EdgeInsets.zero,
          minLeadingWidth: 0,
          shape: const RoundedRectangleBorder(),
          horizontalGap: 8.0,
          layoutDirection: Axis.vertical,
          dense: false,
          visualDensity: VisualDensity.comfortable,
          minVerticalPadding: 0,
          minLabelWidth: 0,
        );

  final BuildContext context;
  late final ThemeData _theme = Theme.of(context);
  late final ColorScheme _colors = _theme.colorScheme;
  late final TextTheme _textTheme = _theme.textTheme;

  @override
  Color? get tileColor => Colors.transparent;

  @override
  TextStyle? get labelStyle =>
      _textTheme.titleMedium!.copyWith(color: _colors.onSurface);

  @override
  TextStyle? get leadingAndTrailingTextStyle =>
      _textTheme.labelSmall!.copyWith(color: _colors.onSurfaceVariant);

  @override
  Color? get iconColor => _colors.onSurfaceVariant;
}
