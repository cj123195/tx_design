import 'package:flutter/material.dart';

/// 表单项容器组件
class FormItemContainer extends StatelessWidget {
  const FormItemContainer({
    required this.formField,
    super.key,
    this.required = false,
    this.label,
    this.labelText,
    this.background,
    this.direction = Axis.vertical,
    this.padding,
    this.actions,
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

  /// 是否为必填项
  ///
  /// 如果为true，则在[labelText]或[label]会显示一个红色'*'标。
  /// 默认值为false
  final bool required;

  /// 背景颜色
  final Color? background;

  /// [label]与表单框排列的方向
  ///
  /// [Axis.vertical] 纵向
  /// [Axis.horizontal] 横向
  /// 默认为[Axis.vertical]
  final Axis direction;

  /// 内边距
  final EdgeInsetsGeometry? padding;

  /// 操作按钮
  ///
  /// 显示在标题栏最右侧的操作按钮
  /// [label]与[labelText]为null时不显示；
  /// 当[direction]为[Axis.vertical]时生效。
  final List<Widget>? actions;

  static InputDecoration createDecoration(
    BuildContext context,
    InputDecoration decoration, {
    String? hintText,
    String? errorText,
    Widget? suffixIcon,
    Widget? prefixIcon,
  }) {
    final ThemeData theme = Theme.of(context);

    final InputBorder border = UnderlineInputBorder(
      borderSide: BorderSide(color: theme.dividerColor),
    );
    final InputBorder focusedBorder = UnderlineInputBorder(
      borderSide: BorderSide(color: theme.colorScheme.primary),
    );
    final InputBorder errorBorder = UnderlineInputBorder(
      borderSide: BorderSide(color: theme.colorScheme.error),
    );
    final InputDecorationTheme decorationTheme =
        theme.inputDecorationTheme.copyWith(
      filled: false,
      border: border,
      focusedBorder: focusedBorder,
      disabledBorder: InputBorder.none,
      enabledBorder: border,
      errorBorder: errorBorder,
      focusedErrorBorder: errorBorder,
    );

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
        )
        .applyDefaults(decorationTheme);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final TextStyle starStyle =
        textTheme.labelSmall!.copyWith(color: theme.colorScheme.error);
    final TextStyle labelStyle = textTheme.labelLarge!;

    Widget? label;
    if (this.label != null) {
      label = DefaultTextStyle(style: labelStyle, child: this.label!);
      if (required) {
        label = Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('* ', style: starStyle),
            Expanded(child: label),
          ],
        );
      }
    } else if (labelText != null) {
      TextSpan span = TextSpan(text: labelText, style: labelStyle);
      if (required) {
        span = TextSpan(text: '* ', style: starStyle, children: [span]);
      }
      label = RichText(text: span);
    }

    Widget result = formField;
    if (label != null) {
      if (direction == Axis.horizontal) {
        result = Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [label, const SizedBox(width: 8), Expanded(child: result)],
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

    if (padding != null) {
      result = Padding(padding: padding!, child: result);
    }

    if (background != null) {
      result = ColoredBox(color: background!, child: result);
    }

    return result;
  }
}
