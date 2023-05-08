import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'form_item_theme.dart';

/// 表单项容器组件
class FormItemContainer extends StatelessWidget {
  const FormItemContainer({
    required this.formField,
    super.key,
    this.required = false,
    this.label,
    this.labelText,
    this.backgroundColor,
    this.direction,
    this.padding,
    this.actions,
    this.labelStyle,
    this.starStyle,
    this.horizontalGap,
    this.minLabelWidth,
  });

  /// 表单项
  final Widget formField;

  /// 描述输入字段的可选文本。
  ///
  /// 如果需要更详细的标签，可以考虑使用[label]。
  /// [label]和[labelText]只能指定一个。
  final String? labelText;

  /// 描述输入字段的可选小部件。
  ///
  /// 只能指定[label]和[labelText]之一。
  final Widget? label;

  /// [label]文字样式
  ///
  /// 默认值为[TextTheme.labelLarge]
  final TextStyle? labelStyle;

  /// 必填标识*号文字样式
  ///
  /// 默认值为使用[ColorScheme.error]的颜色的[TextTheme.labelLarge]。
  final TextStyle? starStyle;

  /// 是否为必填项
  ///
  /// 如果为true，则在[labelText]或[label]会显示一个红色'*'标。
  /// 默认值为false
  final bool required;

  /// 背景颜色
  final Color? backgroundColor;

  /// [label]与表单框排列的方向
  ///
  /// [Axis.vertical] 纵向
  /// [Axis.horizontal] 横向
  /// 默认为[Axis.vertical]
  final Axis? direction;

  /// 内边距
  final EdgeInsetsGeometry? padding;

  /// 操作按钮
  ///
  /// 显示在标题栏最右侧的操作按钮
  /// [label]与[labelText]为null时不显示；
  /// 当[direction]为[Axis.vertical]时生效。
  final List<Widget>? actions;

  /// [label]与[formField]间距
  ///
  /// 仅当[direction]为[Axis.horizontal]时生效
  final double? horizontalGap;

  /// [label]最小宽度
  ///
  /// 仅当[direction]为[Axis.horizontal]时生效
  final double? minLabelWidth;

  static InputDecoration createDecoration(
    BuildContext context,
    InputDecoration decoration, {
    String? hintText,
    String? errorText,
    Widget? suffixIcon,
    Widget? prefixIcon,
  }) {
    final ThemeData theme = Theme.of(context);
    final FormItemThemeData formItemTheme = FormItemTheme.of(context);

    final InputDecorationTheme decorationTheme =
        formItemTheme.inputDecorationTheme ?? theme.inputDecorationTheme;

    if (suffixIcon != null && decoration.suffixIcon != null) {
      suffixIcon = Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [decoration.suffixIcon!, suffixIcon],
      );
    }
    if (prefixIcon != null && decoration.prefixIcon != null) {
      prefixIcon = Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [decoration.prefixIcon!, prefixIcon],
      );
    }

    return decoration
        .copyWith(
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            errorText: errorText,
            hintText: decoration.hintText ?? hintText,
            suffixIconConstraints: const BoxConstraints(),
            suffixIconColor:
                decoration.suffixIconColor ?? decorationTheme.suffixIconColor)
        .applyDefaults(decorationTheme);
  }

  static TextAlign getTextAlign(
    BuildContext context,
    TextAlign? textAlign,
    Axis? direction,
  ) {
    if (textAlign != null) {
      return textAlign;
    }

    final Axis effectiveDirection =
        direction ?? FormItemTheme.of(context).direction ?? Axis.vertical;
    return effectiveDirection == Axis.vertical
        ? TextAlign.start
        : TextAlign.end;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final FormItemThemeData formItemTheme = FormItemTheme.of(context);
    final TextTheme textTheme = theme.textTheme;

    final TextStyle effectiveStarStyle = starStyle ??
        formItemTheme.starStyle ??
        textTheme.titleMedium!.copyWith(color: theme.colorScheme.error);
    final TextStyle effectiveLabelStyle =
        labelStyle ?? formItemTheme.labelStyle ?? textTheme.titleMedium!;
    final Color? effectiveBackgroundColor =
        backgroundColor ?? formItemTheme.backgroundColor;
    final EdgeInsetsGeometry? effectivePadding =
        padding ?? formItemTheme.padding;
    final Axis effectiveDirection =
        direction ?? formItemTheme.direction ?? Axis.vertical;
    final double effectiveHorizontalGap =
        horizontalGap ?? formItemTheme.horizontalGap ?? 8.0;
    final double? effectiveMinLabelWidth =
        minLabelWidth ?? formItemTheme.minLabelWidth;

    Widget? label;
    if (this.label != null) {
      label = DefaultTextStyle(style: effectiveLabelStyle, child: this.label!);
      if (required) {
        label = Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('* ', style: effectiveStarStyle),
            Expanded(child: label),
          ],
        );
      }
    } else if (labelText != null) {
      TextSpan span = TextSpan(text: labelText, style: effectiveLabelStyle);
      if (required) {
        span =
            TextSpan(text: '* ', style: effectiveStarStyle, children: [span]);
      }
      label = RichText(text: span);
    }

    Widget result = formField;
    if (label != null) {
      if (effectiveDirection == Axis.horizontal) {
        result = _FormItem(
          label: label,
          formField: formField,
          horizontalGap: effectiveHorizontalGap,
          minLabelWidth: effectiveMinLabelWidth ?? 0.0,
        );
      } else {
        if (actions?.isNotEmpty == true) {
          label = Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: label),
              ...actions!,
            ],
          );
        }
        result = Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [label, result],
        );
      }
    }

    if (effectivePadding != null) {
      result = Padding(padding: effectivePadding, child: result);
    }

    if (effectiveBackgroundColor != null) {
      result = ColoredBox(color: effectiveBackgroundColor, child: result);
    }

    return result;
  }
}

enum _FormItemSlot {
  label,
  formField,
}

class _FormItem extends RenderObjectWidget
    with SlottedMultiChildRenderObjectWidgetMixin<_FormItemSlot> {
  const _FormItem({
    required this.formField,
    required this.horizontalGap,
    required this.minLabelWidth,
    this.label,
  });

  final Widget? label;
  final Widget formField;
  final double horizontalGap;
  final double minLabelWidth;

  @override
  Iterable<_FormItemSlot> get slots => _FormItemSlot.values;

  @override
  Widget? childForSlot(_FormItemSlot slot) {
    switch (slot) {
      case _FormItemSlot.label:
        return label;
      case _FormItemSlot.formField:
        return formField;
    }
  }

  @override
  _RenderFormItem createRenderObject(BuildContext context) {
    return _RenderFormItem(
      horizontalGap: horizontalGap,
      minLabelWidth: minLabelWidth,
    );
  }

  @override
  void updateRenderObject(BuildContext context, _RenderFormItem renderObject) {
    renderObject
      ..horizontalGap = horizontalGap
      ..minLabelWidth = minLabelWidth;
  }
}

class _RenderFormItem extends RenderBox
    with SlottedContainerRenderObjectMixin<_FormItemSlot> {
  _RenderFormItem({
    required double horizontalGap,
    required double minLabelWidth,
  })  : _horizontalGap = horizontalGap,
        _minLabelWidth = minLabelWidth;

  RenderBox? get label => childForSlot(_FormItemSlot.label);

  RenderBox? get formField => childForSlot(_FormItemSlot.formField);

  @override
  Iterable<RenderBox> get children {
    return <RenderBox>[
      if (label != null) label!,
      if (formField != null) formField!,
    ];
  }

  double get horizontalGap => _horizontalGap;
  double _horizontalGap;

  set horizontalGap(double value) {
    if (_horizontalGap == value) {
      return;
    }
    _horizontalGap = value;
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
    final double labelWidth = label != null
        ? math.max(label!.getMinIntrinsicWidth(height), _minLabelWidth) +
            horizontalGap
        : 0.0;
    return labelWidth + _minWidth(formField, height);
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    final double labelWidth = label != null
        ? math.max(label!.getMaxIntrinsicWidth(height), _minLabelWidth) +
            horizontalGap
        : 0.0;
    return labelWidth + _maxWidth(formField, height);
  }

  // double get _defaultTileHeight {
  //   final bool hasSubformField = subformField != null;
  //   final bool isTwoLine = !isThreeLine && hasSubformField;
  //   final bool isOneLine = !isThreeLine && !hasSubformField;
  //
  //   final Offset baseDensity = visualDensity.baseSizeAdjustment;
  //   if (isOneLine) {
  //     return (isDense ? 48.0 : 56.0) + baseDensity.dy;
  //   }
  //   if (isTwoLine) {
  //     return (isDense ? 64.0 : 72.0) + baseDensity.dy;
  //   }
  //   return (isDense ? 76.0 : 88.0) + baseDensity.dy;
  // }

  @override
  double computeMinIntrinsicHeight(double width) {
    return formField!.getMinIntrinsicHeight(width);
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return computeMinIntrinsicHeight(width);
  }

  @override
  double computeDistanceToActualBaseline(TextBaseline baseline) {
    assert(formField != null);
    final BoxParentData parentData = formField!.parentData! as BoxParentData;
    return parentData.offset.dy +
        formField!.getDistanceToActualBaseline(baseline)!;
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
          'Layout requires baseline metrics, which are only available after '
          'a full layout.',
    ));
    return Size.zero;
  }

  @override
  void performLayout() {
    final BoxConstraints constraints = this.constraints;
    final bool hasLabel = label != null;

    const BoxConstraints maxIconHeightConstraint = BoxConstraints(
      maxHeight: 48.0,
    );
    final BoxConstraints looseConstraints = constraints.loosen();
    final BoxConstraints iconConstraints =
        looseConstraints.enforce(maxIconHeightConstraint);

    final double tileWidth = looseConstraints.maxWidth;
    final Size labelSize = _layoutBox(label, iconConstraints);
    assert(
      tileWidth != labelSize.width || tileWidth == 0.0,
      'Label widget consumes entire tile width. Please use a sized widget, '
      'or consider replacing FormItem with a custom widget '
      '(see https://api.flutter.dev/flutter/material/FormItem-class.html#material.FormItem.4)',
    );

    final double formFieldStart = hasLabel
        ? math.max(_minLabelWidth, labelSize.width) + horizontalGap
        : 0.0;
    final BoxConstraints textConstraints = looseConstraints.tighten(
      width: tileWidth - formFieldStart,
    );
    final Size formFieldSize = _layoutBox(formField, textConstraints);

    final double defaultTileHeight = formFieldSize.height;

    final double tileHeight = math.max(defaultTileHeight, formFieldSize.height);
    final double formFieldY = (tileHeight - formFieldSize.height) / 2.0;

    final double labelY;
    if (tileHeight > 72.0) {
      labelY = 16.0;
    } else {
      labelY = math.min((tileHeight - labelSize.height) / 2.0, 16.0);
    }

    if (hasLabel) {
      _positionBox(label!, Offset(0.0, labelY));
    }
    _positionBox(formField!, Offset(formFieldStart, formFieldY));

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

    doPaint(label);
    doPaint(formField);
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
