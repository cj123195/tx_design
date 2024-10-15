import 'package:flutter/material.dart';

import 'field.dart';
import 'field_tile.dart';

typedef WrapWidgetBuilder<T> = Widget Function(
  BuildContext context,
  int index,
  T? initialValue,
  ValueChanged<T> onChanged,
);

/// Wrap 包裹的 [TxField] 组件
///
/// 通常用于多个选择组件，如 Checkbox、Radio、Chip 等。
class TxWrapField<T> extends TxField<T> {
  const TxWrapField({
    required this.itemBuilder,
    required this.itemCount,
    this.spacing,
    this.runSpacing,
    this.alignment,
    this.runAlignment,
    this.crossAxisAlignment,
    super.key,
    super.initialValue,
    super.decoration,
    super.focusNode,
    super.enabled,
    super.onChanged,
  });

  /// 选择项组件构造方法
  final WrapWidgetBuilder<T> itemBuilder;

  /// 选择项数量
  final int itemCount;

  /// 主轴 children 之间的间距。
  final double? spacing;

  /// 交叉轴中 children 之间的间距。
  final double? runSpacing;

  /// 行中的子项应如何放置在主轴中。
  ///
  /// 例如，如果 [alignment] 为 [WrapAlignment.center]，则每个行中的子项将分组到主轴
  /// 中其运行中心。
  ///
  /// 默认为 [WrapAlignment.start]。
  ///
  /// 另请参阅：
  ///
  ///  * [runAlignment]，它控制行在交叉轴中相对于彼此的放置方式。
  ///  * [crossAxisAlignment]，它控制每个行中的子项在交叉轴中相对于彼此的放置方式。
  final WrapAlignment? alignment;

  /// 行本身应如何放置在交叉轴中。
  ///
  /// 例如，如果 [runAlignment] 为 [WrapAlignment.center]，则行将一起分组到交叉轴中
  /// 整个 [TxWrapField] 的中心。
  ///
  /// 默认为 [WrapAlignment.start]。
  ///
  /// 另请参阅：
  ///
  ///  * [alignment]，它控制每个行中的子项在主轴中相对于彼此的放置方式。
  ///  * [crossAxisAlignment]，它控制每个行中的子项在交叉轴中相对于彼此的放置方式。
  final WrapAlignment? runAlignment;

  /// 行中的子项在交叉轴上应如何相对于彼此对齐。
  ///
  /// 例如，如果将其设置为 [WrapCrossAlignment.end]，则每个运行中的子项的下边缘将与运行中
  /// 的下边缘对齐。
  ///
  /// 默认为 [WrapCrossAlignment.start]。
  ///
  /// 另请参阅：
  ///
  ///  * [alignment]，它控制每个行中的子项在主轴中相对于彼此的放置方式。
  ///  * [runAlignment]，它控制每个行中的子项在交叉轴中相对于彼此的放置方式。
  final WrapCrossAlignment? crossAxisAlignment;

  @override
  TxWrapFieldState<T> createState() => TxWrapFieldState<T>();
}

class TxWrapFieldState<T> extends TxFieldState<T> {
  bool get isEmpty => value == null;

  FocusNode? _focusNode;

  FocusNode get _effectiveFocusNode =>
      widget.focusNode ?? (_focusNode ??= FocusNode());

  TextAlign get _effectiveTextAlign => widget.alignment == WrapAlignment.center
      ? TextAlign.center
      : widget.alignment == WrapAlignment.end
          ? TextAlign.right
          : widget.alignment == WrapAlignment.start || widget.alignment == null
              ? TextAlign.left
              : TextAlign.justify;

  @override
  TxWrapField<T> get widget => super.widget as TxWrapField<T>;

  /// 选择项变更回调
  @override
  void didChange(T? value) {
    if ((widget.focusNode ?? _focusNode)?.hasFocus != true) {
      (widget.focusNode ?? _focusNode)?.requestFocus();
    }

    super.didChange(value);
  }

  void _handleFocusChanged() {
    setState(() {
      // Rebuild the widget on focus change to show/hide the text selection
      // highlight.
    });
  }

  @override
  void didUpdateWidget(covariant TxWrapField<T> oldWidget) {
    if (widget.focusNode != oldWidget.focusNode) {
      (oldWidget.focusNode ?? _focusNode)?.removeListener(_handleFocusChanged);
      (widget.focusNode ?? _focusNode)?.addListener(_handleFocusChanged);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _focusNode?.unfocus();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final FocusNode focusNode = _effectiveFocusNode;

    Widget child = Wrap(
      spacing: widget.spacing ?? 0.0,
      runSpacing: widget.spacing ?? 0.0,
      alignment: widget.alignment ?? WrapAlignment.start,
      runAlignment: widget.runAlignment ?? WrapAlignment.start,
      crossAxisAlignment: widget.crossAxisAlignment ?? WrapCrossAlignment.start,
      children: List.generate(
        widget.itemCount,
        (index) => widget.itemBuilder(
          context,
          index,
          value,
          didChange,
        ),
      ),
    );

    if (widget.decoration != null) {
      child = InputDecorator(
        decoration: effectiveDecoration,
        textAlign: _effectiveTextAlign,
        isFocused: focusNode.hasFocus,
        isEmpty: isEmpty,
        child: child,
      );
    }

    return Focus(focusNode: focusNode, child: child);
  }

  @override
  String? get defaultHintText => null;
}

/// [field] 为 [TxWrapField] 的 [TxFieldTile]。
///
/// 通常用于多个选择组件，如 Checkbox、Radio、Chip 等。
class TxWrapFieldTile<T> extends TxFieldTile {
  const TxWrapFieldTile({
    required super.field,
    T? initialValue,
    ValueChanged<T?>? onChanged,
    double? runSpacing,
    double? spacing,
    WrapAlignment? alignment,
    WrapAlignment? runAlignment,
    WrapCrossAlignment? crossAxisAlignment,
    InputDecoration? decoration,
    FocusNode? focusNode,
    super.key,
    super.labelBuilder,
    super.labelText,
    super.padding,
    super.actions,
    super.labelStyle,
    super.horizontalGap,
    super.tileColor,
    super.layoutDirection,
    super.trailing,
    super.leading,
    super.visualDensity,
    super.shape,
    super.iconColor,
    super.textColor,
    super.leadingAndTrailingTextStyle,
    super.enabled,
    super.onTap,
    super.minLeadingWidth,
    super.minLabelWidth,
    super.minVerticalPadding,
    super.dense,
  });
}
