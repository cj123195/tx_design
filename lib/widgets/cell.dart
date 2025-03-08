import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'cell_theme.dart';

/// 一个用于展示数据及其描述的组件。
///
/// 主要用于展示label：value形式的数据
/// 纯展示组件，如需更多功能请使用[ListTile]
class TxCell extends StatelessWidget {
  /// 创建一个TxCell组件
  const TxCell({
    super.key,
    this.label,
    this.labelText,
    this.labelTextStyle,
    this.leading,
    this.leadingTextStyle,
    this.iconColor,
    this.content,
    this.contentText,
    this.contentTextStyle,
    this.padding,
    this.minLabelWidth,
    this.dense,
    this.visualDensity,
    this.contentTextColor,
    this.horizontalGap,
    this.minLeadingWidth,
    this.minVerticalPadding,
    this.contentTextAlign,
    this.contentMaxLines = 1,
  }) : assert(label != null || labelText != null);

  static List<Widget> fromMap(
    Map<String, dynamic> data, {
    Map<int, Widget>? slots,
    bool? dense,
    VisualDensity? visualDensity,
    double? minLabelWidth,
    double? minLeadingWidth,
    double? minVerticalPadding,
    double? horizontalGap,
    TextStyle? contentTextStyle,
    TextStyle? labelTextStyle,
    TextAlign? contentTextAlign,
    EdgeInsetsGeometry? padding,
    int? contentMaxLines = 1,
  }) {
    final List<Widget> cells = List.generate(
      data.length,
      (index) {
        final String key = data.keys.toList()[index];
        return TxCell(
          labelText: key,
          contentText: '${data[key] ?? ''}',
          dense: dense,
          visualDensity: visualDensity,
          minLeadingWidth: minLeadingWidth,
          minLabelWidth: minLabelWidth,
          minVerticalPadding: minVerticalPadding,
          horizontalGap: horizontalGap,
          labelTextStyle: labelTextStyle,
          contentTextStyle: contentTextStyle,
          contentTextAlign: contentTextAlign,
          padding: padding,
          contentMaxLines: contentMaxLines,
        );
      },
    );
    if (slots?.isNotEmpty == true) {
      for (int i = 0; i < slots!.length; i++) {
        final int index = slots.keys.toList()[i];
        if (index >= cells.length) {
          cells.add(slots[index]!);
        } else {
          cells.insert(index, slots[index]!);
        }
      }
    }

    return cells;
  }

  /// 在标题前显示的小部件。
  ///
  /// 通常是 [Icon] 或 [CircleAvatar] 小部件。
  final Widget? leading;

  /// [leading] 的文字样式
  ///
  /// 如果为null，则使用[TxCellThemeData.leadingTextStyle]；如果它也为null，则使用
  /// [TextTheme.bodySmall]。
  final TextStyle? leadingTextStyle;

  /// 描述展示内容的可选小部件。
  ///
  /// 这可以用于，例如，将多个 [TextStyle] 添加到一个标签，否则将使用 [labelText] 指定，
  /// 它只需要一个 [TextStyle]。
  ///
  /// 只能指定 [label] 和 [labelText] 之一。
  final Widget? label;

  /// 描述展示内容的可选文本。
  ///
  /// 如果需要更详细的标签，请考虑改用 [label]。
  /// 只能指定 [label] 和 [labelText] 之一。
  final String? labelText;

  /// [label]或[labelText]的文字样式
  ///
  /// 如果为null，则使用[TxCellThemeData.labelTextStyle]；如果它也为null，则使用
  /// [TextTheme.labelMedium]。
  final TextStyle? labelTextStyle;

  /// 展示的主体内容小部件
  ///
  /// 只能指定 [content] 和 [contentText] 之一。
  final Widget? content;

  /// 展示的主体内容文字
  ///
  /// 如果需要更详细的内容，请考虑改用 [content]。
  /// 只能指定 [content] 和 [contentText] 之一。
  final String? contentText;

  /// 定义 [content] 的默认颜色。
  final Color? contentTextColor;

  /// [content]或[contentText]的文字样式
  ///
  /// 如果为null，则使用[TxCellThemeData.contentTextStyle]；如果它也为null，则使用
  /// [TextTheme.bodyMedium]。
  final TextStyle? contentTextStyle;

  /// 此cell是否是垂直密集列表的一部分。
  ///
  /// 如果此属性为空，则其值基于 [TxCellThemeData.dense]。
  ///
  /// 密集cell默认为较小的高度及较小的字体。
  final bool? dense;

  /// 定义cell的紧凑程度。
  final VisualDensity? visualDensity;

  /// 定义 [leading]图标的默认颜色。
  ///
  /// 如果此属性为空，则使用 [TxCellThemeData.iconColor]。
  final Color? iconColor;

  /// cell的内部填充。
  ///
  /// 如果为空，则使用[TxCellThemeData.padding]，如果它也为空，则使用
  /// “EdgeInsets.symmetric(horizontal: 12.0)”。
  final EdgeInsetsGeometry? padding;

  /// [label]和[leading]/[content]小部件之间的水平间隙。
  ///
  /// 如果为 null，则使用 [TxCellThemeData.gap] 的值。 如果它也为 null，
  /// 则使用默认值 12.0。
  final double? horizontalGap;

  /// 分配给 [leading] 小部件的最小宽度。
  ///
  /// 如果为 null，则使用 [TxCellThemeData.minLeadingWidth] 的值。
  /// 如果它也为 null，则使用默认值 32.0。
  final double? minLeadingWidth;

  /// 分配给 [label] 小部件的最小宽度。
  ///
  /// 如果为 null，则使用 [TxCellThemeData.minLabelWidth] 的值。
  /// 如果它也为 null，则使用默认值 84.0。
  final double? minLabelWidth;

  /// 最小垂直间距
  ///
  /// 值为null时使用 [TxCellThemeData.minVerticalPadding]。
  final double? minVerticalPadding;

  /// [content] 内容的对齐方式
  ///
  /// 值为null时使用[TxCellThemeData.contentTextAlign]， 如果那也为null，
  /// 则使用[TextAlign.right]。
  final TextAlign? contentTextAlign;

  /// [content] 文字最多显示行数
  ///
  /// 默认值为 1。
  final int? contentMaxLines;

  @override
  Widget build(BuildContext context) {
    final TxCellThemeData cellTheme = TxCellTheme.of(context);
    final _DefaultCellTheme defaults = _DefaultCellTheme(context);

    final bool isDense = dense ?? cellTheme.dense ?? defaults.dense!;
    final Color effectiveIconColor =
        iconColor ?? cellTheme.iconColor ?? defaults.iconColor;
    final IconThemeData iconThemeData = IconThemeData(
      color: effectiveIconColor,
      size: isDense ? 18.0 : 20.0,
    );
    final IconButtonThemeData iconButtonThemeData = IconButtonThemeData(
      style: IconButton.styleFrom(foregroundColor: effectiveIconColor),
    );

    TextStyle resolveTextStyle(
      TextStyle? textStyle,
      TextStyle? themeStyle,
      TextStyle defaultStyle,
    ) {
      final Color color =
          textStyle?.color ?? themeStyle?.color ?? defaultStyle.color!;
      final double fontSize =
          textStyle?.fontSize ?? themeStyle?.fontSize ?? defaultStyle.fontSize!;
      final TextStyle style = textStyle ?? themeStyle ?? defaultStyle;
      return style.copyWith(
        color: color,
        fontSize: isDense ? fontSize * 0.9 : null,
      );
    }

    Widget? leadingIcon;
    if (leading != null) {
      final TextStyle leadingStyle = resolveTextStyle(
        leadingTextStyle,
        cellTheme.leadingTextStyle,
        defaults.leadingTextStyle,
      );
      leadingIcon = DefaultTextStyle(style: leadingStyle, child: leading!);
    }

    final TextStyle labelStyle = resolveTextStyle(
      labelTextStyle,
      cellTheme.labelTextStyle,
      defaults.labelTextStyle,
    );
    final Widget labelText = DefaultTextStyle(
      style: labelStyle,
      child: label ?? Text('${this.labelText!}：'),
    );

    Widget? contentWidget;
    TextStyle? contentStyle;
    if (content != null || contentText != null) {
      contentStyle = resolveTextStyle(
        contentTextStyle,
        cellTheme.contentTextStyle,
        defaults.contentTextStyle,
      );
      if (contentTextColor != null) {
        contentStyle = contentStyle.copyWith(color: contentTextColor);
      }
      final TextAlign textAlign = contentTextAlign ??
          cellTheme.contentTextAlign ??
          defaults.contentTextAlign!;

      contentWidget = DefaultTextStyle(
        style: contentStyle,
        textAlign: textAlign,
        maxLines: contentMaxLines,
        overflow: contentMaxLines == null
            ? TextOverflow.visible
            : TextOverflow.ellipsis,
        child: content ?? Text(contentText!),
      );
    }

    final TextDirection textDirection = Directionality.of(context);
    final EdgeInsets resolvedContentPadding = padding?.resolve(textDirection) ??
        cellTheme.padding?.resolve(textDirection) ??
        defaults.padding!.resolve(textDirection);

    return SafeArea(
      top: false,
      bottom: false,
      minimum: resolvedContentPadding,
      child: IconTheme.merge(
        data: iconThemeData,
        child: IconButtonTheme(
          data: iconButtonThemeData,
          child: _Cell(
            leading: leadingIcon,
            label: labelText,
            content: contentWidget,
            isDense: isDense,
            visualDensity: visualDensity ??
                cellTheme.visualDensity ??
                defaults.visualDensity!,
            textDirection: textDirection,
            horizontalGap: horizontalGap ?? cellTheme.gap ?? 12.0,
            minVerticalPadding: minVerticalPadding ??
                cellTheme.minVerticalPadding ??
                defaults.minVerticalPadding!,
            minLeadingWidth: minLeadingWidth ??
                cellTheme.minLeadingWidth ??
                defaults.minLeadingWidth!,
            minLabelWidth: minLabelWidth ??
                cellTheme.minLabelWidth ??
                defaults.minLabelWidth!,
            fontSizeRatio: contentStyle == null
                ? null
                : contentStyle.fontSize! / labelStyle.fontSize!,
          ),
        ),
      ),
    );
  }
}

enum _CellSlot {
  leading,
  label,
  content,
}

class _Cell extends SlottedMultiChildRenderObjectWidget<_CellSlot, RenderBox> {
  const _Cell({
    required this.label,
    required this.isDense,
    required this.visualDensity,
    required this.textDirection,
    required this.horizontalGap,
    required this.minLeadingWidth,
    required this.minVerticalPadding,
    required this.minLabelWidth,
    required this.fontSizeRatio,
    this.leading,
    this.content,
  }) : assert(content == null || fontSizeRatio != null);

  final Widget? leading;
  final Widget label;
  final Widget? content;
  final bool isDense;
  final VisualDensity visualDensity;
  final TextDirection textDirection;
  final double horizontalGap;
  final double minLeadingWidth;
  final double minLabelWidth;
  final double minVerticalPadding;
  final double? fontSizeRatio;

  @override
  Iterable<_CellSlot> get slots => _CellSlot.values;

  @override
  Widget? childForSlot(_CellSlot slot) {
    switch (slot) {
      case _CellSlot.leading:
        return leading;
      case _CellSlot.label:
        return label;
      case _CellSlot.content:
        return content;
    }
  }

  @override
  _RenderCell createRenderObject(BuildContext context) {
    return _RenderCell(
      isDense: isDense,
      visualDensity: visualDensity,
      textDirection: textDirection,
      horizontalGap: horizontalGap,
      minLeadingWidth: minLeadingWidth,
      minVerticalPadding: minVerticalPadding,
      minLabelWidth: minLabelWidth,
      fontSizeRatio: fontSizeRatio,
    );
  }

  @override
  void updateRenderObject(BuildContext context, _RenderCell renderObject) {
    renderObject
      ..isDense = isDense
      ..visualDensity = visualDensity
      ..textDirection = textDirection
      ..horizontalGap = horizontalGap
      ..minLeadingWidth = minLeadingWidth
      ..minVerticalPadding = minVerticalPadding
      ..minLabelWidth = minLabelWidth
      ..fontSizeRatio = fontSizeRatio;
  }
}

class _RenderCell extends RenderBox
    with SlottedContainerRenderObjectMixin<_CellSlot, RenderBox> {
  _RenderCell({
    required bool isDense,
    required VisualDensity visualDensity,
    required TextDirection textDirection,
    required double horizontalGap,
    required double minLeadingWidth,
    required double minLabelWidth,
    required double minVerticalPadding,
    required double? fontSizeRatio,
  })  : _isDense = isDense,
        _visualDensity = visualDensity,
        _textDirection = textDirection,
        _horizontalGap = horizontalGap,
        _minLeadingWidth = minLeadingWidth,
        _minVerticalPadding = minVerticalPadding,
        _minLabelWidth = minLabelWidth,
        _fontSizeRatio = fontSizeRatio;

  RenderBox? get leading => childForSlot(_CellSlot.leading);

  RenderBox? get label => childForSlot(_CellSlot.label);

  RenderBox? get content => childForSlot(_CellSlot.content);

  @override
  Iterable<RenderBox> get children {
    return <RenderBox>[
      if (leading != null) leading!,
      if (label != null) label!,
      if (content != null) content!,
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

  TextDirection get textDirection => _textDirection;
  TextDirection _textDirection;

  set textDirection(TextDirection value) {
    if (_textDirection == value) {
      return;
    }
    _textDirection = value;
    markNeedsLayout();
  }

  double get horizontalGap => _horizontalGap;
  double _horizontalGap;

  double get _effectiveHorizontalGap =>
      _horizontalGap + visualDensity.horizontal * 2.0;

  set horizontalGap(double value) {
    if (_horizontalGap == value) {
      return;
    }
    _horizontalGap = value;
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

  double? get fontSizeRatio => _fontSizeRatio;
  double? _fontSizeRatio;

  set fontSizeRatio(double? value) {
    if (_fontSizeRatio == value) {
      return;
    }
    _fontSizeRatio = value;
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
            _effectiveHorizontalGap
        : 0.0;
    return leadingWidth + _minWidth(label, height) + _minWidth(content, height);
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    final double leadingWidth = leading != null
        ? math.max(leading!.getMaxIntrinsicWidth(height), _minLeadingWidth) +
            _effectiveHorizontalGap
        : 0.0;
    return leadingWidth + _maxWidth(label, height) + _maxWidth(content, height);
  }

  double get _defaultCellHeight {
    final Offset baseDensity = visualDensity.baseSizeAdjustment;
    return (isDense ? 28.0 : 32.0) + baseDensity.dy;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    final double result = math.max(
      _defaultCellHeight,
      label!.getMinIntrinsicHeight(width),
    );
    if (content == null) {
      return result;
    }
    final labelWidth = label!.getMinIntrinsicWidth(result);
    return math.max(result, content!.getMinIntrinsicHeight(width - labelWidth));
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return computeMinIntrinsicHeight(width);
  }

  @override
  double computeDistanceToActualBaseline(TextBaseline baseline) {
    assert(label != null);
    final BoxParentData parentData = label!.parentData! as BoxParentData;
    return parentData.offset.dy + label!.getDistanceToActualBaseline(baseline)!;
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
    assert(debugCannotComputeDryLayout(
      reason:
          'Layout requires baseline metrics, which are only available after a '
          'full layout.',
    ));
    return Size.zero;
  }

  // All of the dimensions below were taken from the Material Design spec:
  // https://material.io/design/components/lists.html#specs
  @override
  void performLayout() {
    final BoxConstraints constraints = this.constraints;
    final bool hasLeading = leading != null;
    final bool hasContent = content != null;
    final double defaultCellHeight = _defaultCellHeight;

    final BoxConstraints maxIconHeightConstraint =
        BoxConstraints(maxHeight: defaultCellHeight);
    final BoxConstraints looseConstraints = constraints.loosen();
    final BoxConstraints iconConstraints =
        looseConstraints.enforce(maxIconHeightConstraint);

    final double cellWidth = looseConstraints.maxWidth;
    final Size leadingSize = _layoutBox(leading, iconConstraints);
    assert(
      cellWidth != leadingSize.width || cellWidth == 0.0,
      'Leading widget consumes entire tile width. Please use a sized widget, '
      'or consider replacing ListTile with a custom widget '
      '(see https://api.flutter.dev/flutter/material/ListTile-class.html#material.ListTile.4)',
    );

    final double labelStart = hasLeading
        ? math.max(_minLeadingWidth, leadingSize.width) +
            _effectiveHorizontalGap
        : 0.0;

    final BoxConstraints labelConstraints =
        BoxConstraints(minWidth: _minLabelWidth);
    final Size labelSize = _layoutBox(label!, labelConstraints);

    double cellHeight = math.max(
        defaultCellHeight, labelSize.height + 2.0 * _minVerticalPadding);
    double labelY;
    double? contentY;
    double? contentStart;
    double leadingY;
    if (!hasContent) {
      labelY = (cellHeight - labelSize.height) / 2.0;
      leadingY = (cellHeight - leadingSize.height) / 2.0;
    } else {
      contentStart = labelStart + labelSize.width + _effectiveHorizontalGap;
      final BoxConstraints textConstraints =
          looseConstraints.tighten(width: cellWidth - contentStart);
      final Size contentSize = _layoutBox(content!, textConstraints);
      cellHeight = math.max(
        cellHeight,
        contentSize.height + 2.0 * _minVerticalPadding,
      );
      final double lineHeight = labelSize.height * fontSizeRatio!;
      final int lines = (contentSize.height / lineHeight).round();
      if (lines >= 2) {
        labelY = minVerticalPadding;
        contentY = minVerticalPadding;
        leadingY =
            minVerticalPadding + (labelSize.height - leadingSize.height) / 2.0;
        if (leadingY < minVerticalPadding) {
          leadingY = minVerticalPadding;
        }
      } else {
        labelY = (cellHeight - labelSize.height) / 2.0;
        contentY = (cellHeight - contentSize.height) / 2.0;
        leadingY = (cellHeight - leadingSize.height) / 2.0;
      }
    }

    switch (textDirection) {
      case TextDirection.rtl:
        {
          double labelStart = cellWidth - labelSize.width;
          if (hasLeading) {
            labelStart =
                labelStart - leadingSize.width - _effectiveHorizontalGap;
            _positionBox(
                leading!, Offset(cellWidth - leadingSize.width, leadingY));
          }
          _positionBox(label!, Offset(labelStart, labelY));
          if (hasContent) {
            _positionBox(content!, Offset(0.0, contentY!));
          }
          break;
        }
      case TextDirection.ltr:
        {
          if (hasLeading) {
            _positionBox(leading!, Offset(0.0, leadingY));
          }
          _positionBox(label!, Offset(labelStart, labelY));
          if (hasContent) {
            _positionBox(content!, Offset(contentStart!, contentY!));
          }
          break;
        }
    }

    size = constraints.constrain(Size(cellWidth, cellHeight));
    assert(size.width == constraints.constrainWidth(cellWidth));
    assert(size.height == constraints.constrainHeight(cellHeight));
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

/// 一个用于展示数据及其描述的组件。
///
/// 主要用于展示label：value形式的数据
/// 与 [TxCell] 不同的是，[TxVerticalCell] 为垂直排列
class TxVerticalCell extends StatelessWidget {
  /// 创建一个TxCell组件
  const TxVerticalCell({
    super.key,
    this.label,
    this.labelText,
    this.labelTextStyle,
    this.leading,
    this.leadingTextStyle,
    this.iconColor,
    this.content,
    this.contentText,
    this.contentTextStyle,
    this.padding,
    this.minLeadingWidth,
    this.dense,
    this.visualDensity,
    this.contentTextColor,
    this.verticalGap,
    this.minVerticalPadding,
  }) : assert(label != null || labelText != null);

  /// 在标题前显示的小部件。
  ///
  /// 通常是 [Icon] 或 [CircleAvatar] 小部件。
  final Widget? leading;

  /// [leading] 的文字样式
  ///
  /// 如果为null，则使用[TxCellThemeData.leadingTextStyle]；如果它也为null，则使用
  /// [TextTheme.bodySmall]。
  final TextStyle? leadingTextStyle;

  /// 描述展示内容的可选小部件。
  ///
  /// 这可以用于，例如，将多个 [TextStyle] 添加到一个标签，否则将使用 [labelText] 指定，
  /// 它只需要一个 [TextStyle]。
  ///
  /// 只能指定 [label] 和 [labelText] 之一。
  final Widget? label;

  /// 描述展示内容的可选文本。
  ///
  /// 如果需要更详细的标签，请考虑改用 [label]。
  /// 只能指定 [label] 和 [labelText] 之一。
  final String? labelText;

  /// [label]或[labelText]的文字样式
  ///
  /// 如果为null，则使用[TxCellThemeData.labelTextStyle]；如果它也为null，则使用
  /// [TextTheme.labelLarge]。
  final TextStyle? labelTextStyle;

  /// 展示的主体内容小部件
  ///
  /// 只能指定 [content] 和 [contentText] 之一。
  final Widget? content;

  /// 展示的主体内容文字
  ///
  /// 如果需要更详细的内容，请考虑改用 [content]。
  /// 只能指定 [content] 和 [contentText] 之一。
  final String? contentText;

  /// 定义 [content] 的默认颜色。
  final Color? contentTextColor;

  /// [content]或[contentText]的文字样式
  ///
  /// 如果为null，则使用[TxCellThemeData.contentTextStyle]；如果它也为null，则使用
  /// [TextTheme.bodyMedium]。
  final TextStyle? contentTextStyle;

  /// 此cell是否是垂直密集列表的一部分。
  ///
  /// 如果此属性为空，则其值基于 [TxCellThemeData.dense]。
  ///
  /// 密集cell默认为较小的高度及较小的字体。
  final bool? dense;

  /// 定义cell的紧凑程度。
  final VisualDensity? visualDensity;

  /// 定义 [leading]图标的默认颜色。
  ///
  /// 如果此属性为空，则使用 [TxCellThemeData.iconColor]。
  final Color? iconColor;

  /// cell的内部填充。
  ///
  /// 如果为空，则使用[TxCellThemeData.padding]，如果它也为空，则使用
  /// “EdgeInsets.symmetric(horizontal: 12.0)”。
  final EdgeInsetsGeometry? padding;

  /// [label]和[leading]/[content]小部件之间的水平间隙。
  ///
  /// 如果为 null，则使用 [TxCellThemeData.gap] 的值。 如果它也为 null，
  /// 则使用默认值 12.0。
  final double? verticalGap;

  /// 分配给 [label] 小部件的最小宽度。
  ///
  /// 如果为 null，则使用 [TxCellThemeData.minLabelWidth] 的值。
  /// 如果它也为 null，则使用默认值 84.0。
  final double? minLeadingWidth;

  /// 最小垂直间距
  ///
  /// 值为null时使用 [TxCellThemeData.minVerticalPadding]。
  final double? minVerticalPadding;

  @override
  Widget build(BuildContext context) {
    final TxCellThemeData cellTheme = TxCellTheme.of(context);
    final _DefaultCellTheme defaults = _DefaultCellTheme(context);

    final bool isDense = dense ?? cellTheme.dense ?? defaults.dense!;
    final Color effectiveIconColor =
        iconColor ?? cellTheme.iconColor ?? defaults.iconColor;
    final IconThemeData iconThemeData = IconThemeData(
      color: effectiveIconColor,
      size: isDense ? 18.0 : 20.0,
    );
    final IconButtonThemeData iconButtonThemeData = IconButtonThemeData(
      style: IconButton.styleFrom(foregroundColor: effectiveIconColor),
    );

    TextStyle resolveTextStyle(
      TextStyle? textStyle,
      TextStyle? themeStyle,
      TextStyle defaultStyle,
    ) {
      final Color color =
          textStyle?.color ?? themeStyle?.color ?? defaultStyle.color!;
      final double fontSize =
          textStyle?.fontSize ?? themeStyle?.fontSize ?? defaultStyle.fontSize!;
      final TextStyle style = textStyle ?? themeStyle ?? defaultStyle;
      return style.copyWith(
        color: color,
        fontSize: isDense ? fontSize * 0.9 : null,
      );
    }

    Widget? leadingIcon;
    if (leading != null) {
      final TextStyle leadingStyle = resolveTextStyle(
        leadingTextStyle,
        cellTheme.leadingTextStyle,
        defaults.leadingTextStyle,
      );
      leadingIcon = DefaultTextStyle(style: leadingStyle, child: leading!);
    }

    final TextStyle labelStyle = resolveTextStyle(
      labelTextStyle,
      cellTheme.labelTextStyle,
      defaults.labelTextStyle,
    );
    final Widget labelText = DefaultTextStyle(
      style: labelStyle,
      child: label ?? Text('${this.labelText!}：'),
    );

    Widget? contentWidget;
    TextStyle? contentStyle;
    if (content != null || contentText != null) {
      contentStyle = resolveTextStyle(
        contentTextStyle,
        cellTheme.contentTextStyle,
        defaults.contentTextStyle,
      );
      if (contentTextColor != null) {
        contentStyle = contentStyle.copyWith(color: contentTextColor);
      }
      contentWidget = DefaultTextStyle(
        style: contentStyle,
        child: content ?? Text(contentText!),
      );
    }

    final TextDirection textDirection = Directionality.of(context);
    final EdgeInsets resolvedContentPadding = padding?.resolve(textDirection) ??
        cellTheme.padding?.resolve(textDirection) ??
        defaults.padding!.resolve(textDirection);

    return SafeArea(
      top: false,
      bottom: false,
      minimum: resolvedContentPadding,
      child: IconTheme.merge(
        data: iconThemeData,
        child: IconButtonTheme(
          data: iconButtonThemeData,
          child: _VerticalCell(
            leading: leadingIcon,
            label: labelText,
            content: contentWidget,
            isDense: isDense,
            visualDensity: visualDensity ??
                cellTheme.visualDensity ??
                defaults.visualDensity!,
            textDirection: textDirection,
            verticalGap: verticalGap ?? cellTheme.gap ?? 12.0,
            minVerticalPadding: minVerticalPadding ??
                cellTheme.minVerticalPadding ??
                defaults.minVerticalPadding!,
            minLeadingWidth: minLeadingWidth ??
                cellTheme.minLeadingWidth ??
                defaults.minLeadingWidth!,
          ),
        ),
      ),
    );
  }
}

class _VerticalCell
    extends SlottedMultiChildRenderObjectWidget<_CellSlot, RenderBox> {
  const _VerticalCell({
    required this.label,
    required this.isDense,
    required this.visualDensity,
    required this.textDirection,
    required this.verticalGap,
    required this.minVerticalPadding,
    required this.minLeadingWidth,
    this.leading,
    this.content,
  });

  final Widget? leading;
  final Widget label;
  final Widget? content;
  final bool isDense;
  final VisualDensity visualDensity;
  final TextDirection textDirection;
  final double verticalGap;
  final double minLeadingWidth;
  final double minVerticalPadding;

  @override
  Iterable<_CellSlot> get slots => _CellSlot.values;

  @override
  Widget? childForSlot(_CellSlot slot) {
    switch (slot) {
      case _CellSlot.leading:
        return leading;
      case _CellSlot.label:
        return label;
      case _CellSlot.content:
        return content;
    }
  }

  @override
  _RenderVerticalCell createRenderObject(BuildContext context) {
    return _RenderVerticalCell(
      isDense: isDense,
      visualDensity: visualDensity,
      textDirection: textDirection,
      verticalGap: verticalGap,
      minLeadingWidth: minLeadingWidth,
      minVerticalPadding: minVerticalPadding,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderVerticalCell renderObject,
  ) {
    renderObject
      ..isDense = isDense
      ..visualDensity = visualDensity
      ..textDirection = textDirection
      ..verticalGap = verticalGap
      ..minLeadingWidth = minLeadingWidth
      ..minVerticalPadding = minVerticalPadding;
  }
}

class _RenderVerticalCell extends RenderBox
    with SlottedContainerRenderObjectMixin<_CellSlot, RenderBox> {
  _RenderVerticalCell({
    required bool isDense,
    required VisualDensity visualDensity,
    required TextDirection textDirection,
    required double verticalGap,
    required double minLeadingWidth,
    required double minVerticalPadding,
  })  : _isDense = isDense,
        _visualDensity = visualDensity,
        _textDirection = textDirection,
        _verticalGap = verticalGap,
        _minLeadingWidth = minLeadingWidth,
        _minVerticalPadding = minVerticalPadding;

  RenderBox? get leading => childForSlot(_CellSlot.leading);

  RenderBox? get label => childForSlot(_CellSlot.label);

  RenderBox? get content => childForSlot(_CellSlot.content);

  @override
  Iterable<RenderBox> get children {
    return <RenderBox>[
      if (leading != null) leading!,
      if (label != null) label!,
      if (content != null) content!,
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

  TextDirection get textDirection => _textDirection;
  TextDirection _textDirection;

  set textDirection(TextDirection value) {
    if (_textDirection == value) {
      return;
    }
    _textDirection = value;
    markNeedsLayout();
  }

  double get verticalGap => _verticalGap;
  double _verticalGap;

  double get _effectiveVerticalGap =>
      _verticalGap + visualDensity.vertical * 2.0;

  set verticalGap(double value) {
    if (_verticalGap == value) {
      return;
    }
    _verticalGap = value;
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

  double get minLeadingWidth => _minLeadingWidth;
  double _minLeadingWidth;

  set minLeadingWidth(double value) {
    if (_minLeadingWidth == value) {
      return;
    }
    _minLeadingWidth = value;
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
            _effectiveVerticalGap
        : 0.0;
    return math.max(
      leadingWidth + _minWidth(label, height),
      _minWidth(content, height),
    );
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    final double leadingWidth = leading != null
        ? math.max(leading!.getMaxIntrinsicWidth(height), _minLeadingWidth) +
            _effectiveVerticalGap
        : 0.0;
    return math.max(
      _maxWidth(label, height) + leadingWidth,
      _maxWidth(content, height),
    );
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    final double height = label!.getMinIntrinsicHeight(width);
    if (content == null) {
      return height;
    }

    return height + content!.getMinIntrinsicHeight(width) + verticalGap;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return computeMinIntrinsicHeight(width);
  }

  @override
  double computeDistanceToActualBaseline(TextBaseline baseline) {
    assert(label != null);
    final BoxParentData parentData = label!.parentData! as BoxParentData;
    return parentData.offset.dy + label!.getDistanceToActualBaseline(baseline)!;
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
    assert(debugCannotComputeDryLayout(
      reason:
          'Layout requires baseline metrics, which are only available after a '
          'full layout.',
    ));
    return Size.zero;
  }

  // All of the dimensions below were taken from the Material Design spec:
  // https://material.io/design/components/lists.html#specs
  @override
  void performLayout() {
    final BoxConstraints constraints = this.constraints;
    final bool hasLeading = leading != null;
    final bool hasContent = content != null;

    final BoxConstraints maxIconHeightConstraint =
        BoxConstraints(maxHeight: label!.size.height);
    final BoxConstraints looseConstraints = constraints.loosen();
    final BoxConstraints iconConstraints =
        looseConstraints.enforce(maxIconHeightConstraint);

    final double cellWidth = looseConstraints.maxWidth;
    final Size leadingSize = _layoutBox(leading, iconConstraints);
    assert(
      cellWidth != leadingSize.width || cellWidth == 0.0,
      'Leading widget consumes entire tile width. Please use a sized widget, '
      'or consider replacing ListTile with a custom widget '
      '(see https://api.flutter.dev/flutter/material/ListTile-class.html#material.ListTile.4)',
    );

    final double labelStart = hasLeading
        ? math.max(_minLeadingWidth, leadingSize.width) + _effectiveVerticalGap
        : 0.0;

    final Size labelSize = _layoutBox(label!, looseConstraints);

    double cellHeight = labelSize.height + 2.0 * _minVerticalPadding;
    final double labelY = (cellHeight - labelSize.height) / 2.0;
    final double leadingY = (cellHeight - leadingSize.height) / 2.0;

    double? contentY;
    double? contentStart;
    if (hasContent) {
      contentStart = 0.0;
      final Size contentSize = _layoutBox(content!, looseConstraints);
      cellHeight = cellHeight + contentSize.height + _effectiveVerticalGap;
      contentY = labelY + labelSize.height + _minVerticalPadding;
    }

    switch (textDirection) {
      case TextDirection.rtl:
        {
          double labelStart = cellWidth - labelSize.width;
          if (hasLeading) {
            labelStart = labelStart - leadingSize.width - _effectiveVerticalGap;
            _positionBox(
                leading!, Offset(cellWidth - leadingSize.width, leadingY));
          }
          _positionBox(label!, Offset(labelStart, labelY));
          if (hasContent) {
            _positionBox(content!, Offset(0.0, contentY!));
          }
          break;
        }
      case TextDirection.ltr:
        {
          if (hasLeading) {
            _positionBox(leading!, Offset(0.0, leadingY));
          }
          _positionBox(label!, Offset(labelStart, labelY));
          if (hasContent) {
            _positionBox(content!, Offset(contentStart!, contentY!));
          }
          break;
        }
    }

    size = constraints.constrain(Size(cellWidth, cellHeight));
    assert(size.width == constraints.constrainWidth(cellWidth));
    assert(size.height == constraints.constrainHeight(cellHeight));
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

/// 默认主题
class _DefaultCellTheme extends TxCellThemeData {
  _DefaultCellTheme(this.context)
      : super(
          dense: false,
          contentTextAlign: TextAlign.right,
          padding: EdgeInsets.zero,
          minVerticalPadding: 4.0,
          minLeadingWidth: 24.0,
          minLabelWidth: 0.0,
          visualDensity: const VisualDensity(
            vertical: VisualDensity.minimumDensity,
            horizontal: VisualDensity.minimumDensity,
          ),
        );

  final BuildContext context;
  late final ThemeData _theme = Theme.of(context);
  late final ColorScheme _colors = _theme.colorScheme;
  late final TextTheme _textTheme = _theme.textTheme;

  @override
  TextStyle get labelTextStyle =>
      _textTheme.labelMedium!.copyWith(fontWeight: FontWeight.w500);

  @override
  TextStyle get contentTextStyle => _textTheme.bodyMedium!.copyWith(
        color: _colors.onSurface.withOpacity(0.7),
        fontSize: labelTextStyle.fontSize,
      );

  @override
  TextStyle get leadingTextStyle => _textTheme.bodySmall!;

  @override
  Color get iconColor => _colors.onSurfaceVariant;
}
