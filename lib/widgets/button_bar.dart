import 'package:flutter/material.dart';

import 'button_bar_theme.dart';
import 'popup_menu.dart';

const double _kButtonHeight = 36.0;
const double _kMinButtonWidth = 64.0;

typedef ButtonBuilder = Widget Function(ButtonStyle buttonStyle);

/// 一排横置排列的操作按钮
///
/// 提供了主按钮与辅按钮的构造方法，主按钮一般为[ElevatedButton]，辅按钮一般为
/// [OutlinedButton]，[actions]一般为一组[IconButton]
class TxButtonBar extends StatelessWidget {
  /// 创建一个操作按钮栏。
  const TxButtonBar({
    required this.mainButtonBuilder,
    Key? key,
    this.secondaryButtonBuilder,
    this.actions,
    this.buttonPadding,
    this.buttonTextTheme,
    this.buttonHeight,
    this.buttonMinWidth,
    this.layoutBehavior,
    this.buttonAlignedDropdown,
  }) : super(key: key);

  /// 创建一个包含[TxPopupMenuButton]的操作按钮栏，一般用于操作比较多的情况
  TxButtonBar.more({
    required this.mainButtonBuilder,
    required List<PopupMenuEntry> menus,
    super.key,
    this.secondaryButtonBuilder,
    List<Widget>? actions,
    this.buttonPadding,
    this.buttonTextTheme,
    this.buttonHeight,
    this.buttonMinWidth,
    this.layoutBehavior,
    this.buttonAlignedDropdown,
  })  : assert(menus.isNotEmpty),
        actions = [
          TxPopupMenuButton(
            itemBuilder: (context) {
              return <PopupMenuEntry>[
                for (int i = 0; i < menus.length; i++) ...[
                  menus[i],
                  if (i != menus.length - 1) const PopupMenuDivider(),
                ]
              ];
            },
            icon: const Icon(Icons.more_horiz),
          ),
          ...?actions,
        ];

  /// 主按钮
  ///
  /// 一般为[ElevatedButton]
  final ButtonBuilder mainButtonBuilder;

  /// 辅按钮
  ///
  /// /// 一般为[OutlinedButton]
  final ButtonBuilder? secondaryButtonBuilder;

  /// icon按钮的集合
  final List<Widget>? actions;

  /// 覆盖周围的 [ButtonThemeData.padding] 以定义按钮子项（通常是按钮的标签）的填充。
  ///
  /// 如果为 null，则它将使用周围的 [ButtonBarThemeData.buttonPadding]。
  /// 如果为 null，它将默认为左侧和右侧的 8.0 个逻辑像素。
  final EdgeInsetsGeometry? buttonPadding;

  /// 覆盖周围的 [ButtonBarThemeData.buttonTextTheme] 以定义按钮的基色、大小、内部填充
  /// 和形状。
  final ButtonTextTheme? buttonTextTheme;

  /// 覆盖周围的 [ButtonThemeData.height] 以定义按钮的最小高度。
  ///
  /// 如果为 null，则它将使用周围的 [ButtonBarThemeData.buttonHeight]。
  /// 如果为空，它将默认为 36.0 个逻辑像素。
  final double? buttonHeight;

  /// 覆盖周围的 [ButtonThemeData.minWidth] 以定义按钮的最小宽度。
  ///
  /// 如果为 null，则它将使用周围的 [ButtonBarThemeData.buttonMinWidth]。
  /// 如果为空，它将默认为 64.0 个逻辑像素。
  final double? buttonMinWidth;

  /// 定义 [ButtonBar] 是否应使用最小大小约束或填充来调整自身大小。
  ///
  /// 覆盖周围的 [ButtonThemeData.layoutBehavior]。
  ///
  /// 如果为 null，则它将使用周围的 [ButtonBarThemeData.layoutBehavior]。
  /// 如果它也为为 null，它将默认为 [ButtonBarLayoutBehavior.padded]。
  final ButtonBarLayoutBehavior? layoutBehavior;

  /// 覆盖周围的 [ButtonThemeData.alignedDropdown] 以定义 [DropdownButton] 菜单的
  /// 宽度是否与按钮的宽度匹配。
  ///
  /// 如果为 null，则它将使用周围的 [ButtonBarThemeData.buttonAlignedDropdown]。
  /// 如果它也为 null，则默认为 false。
  final bool? buttonAlignedDropdown;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ButtonThemeData parentButtonTheme = ButtonTheme.of(context);
    final TxButtonBarThemeData barTheme = TxButtonBarTheme.of(context);

    final ButtonThemeData buttonTheme = parentButtonTheme.copyWith(
      textTheme: buttonTextTheme ??
          barTheme.buttonTextTheme ??
          ButtonTextTheme.primary,
      minWidth: buttonMinWidth ?? barTheme.buttonMinWidth ?? _kMinButtonWidth,
      height: buttonHeight ?? barTheme.buttonHeight ?? _kButtonHeight,
      padding: buttonPadding ??
          barTheme.buttonPadding ??
          const EdgeInsets.symmetric(horizontal: 8.0),
      alignedDropdown:
          buttonAlignedDropdown ?? barTheme.buttonAlignedDropdown ?? false,
      layoutBehavior: layoutBehavior ??
          barTheme.layoutBehavior ??
          ButtonBarLayoutBehavior.padded,
    );
    const OutlinedBorder shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(4)),
    );
    // 我们除以 4.0 因为我们想要左右填充平均值的一半。
    final double paddingUnit = buttonTheme.padding.horizontal / 4.0;

    final List<Widget> children = [];
    if (actions?.isNotEmpty == true) {
      children.addAll(actions!.map(
        (child) => Padding(
          padding: EdgeInsets.symmetric(horizontal: paddingUnit),
          child: child,
        ),
      ));
    }

    if (secondaryButtonBuilder != null) {
      final ButtonStyle style = barTheme.secondaryButtonStyle ??
          OutlinedButton.styleFrom(shape: shape);
      final Widget secondaryBtn = Expanded(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: paddingUnit),
          child: secondaryButtonBuilder!(style),
        ),
      );
      children.add(secondaryBtn);
    }

    final ButtonStyle style = barTheme.mainButtonStyle ??
        FilledButton.styleFrom(
          foregroundColor: theme.colorScheme.onPrimary,
          backgroundColor: theme.colorScheme.primary,
          shape: shape,
        );
    final Widget mainBtn = Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: paddingUnit),
        child: mainButtonBuilder(style),
      ),
    );
    children.add(mainBtn);

    final Widget child = ButtonTheme.fromButtonThemeData(
      data: buttonTheme,
      child: Row(children: children),
    );
    switch (buttonTheme.layoutBehavior) {
      case ButtonBarLayoutBehavior.padded:
        return Padding(
          padding: EdgeInsets.symmetric(
            vertical: 2.0 * paddingUnit,
            horizontal: paddingUnit,
          ),
          child: child,
        );
      case ButtonBarLayoutBehavior.constrained:
        return Container(
          padding: EdgeInsets.symmetric(horizontal: paddingUnit),
          constraints: const BoxConstraints(minHeight: 52.0),
          alignment: Alignment.center,
          child: child,
        );
    }
  }
}

/// 包含一个确定按钮与重置按钮的[TxButtonBar]
class TxFilterButtonBar extends TxButtonBar {
  TxFilterButtonBar({
    super.key,
    ButtonBuilder? confirmButtonBuilder,
    ButtonBuilder? resetButtonBuilder,
    VoidCallback? onConfirm,
    VoidCallback? onReset,
    super.actions,
  }) : super(
          mainButtonBuilder: confirmButtonBuilder ??
              (style) {
                return ElevatedButton(
                  onPressed: onConfirm,
                  style: style,
                  child: const Text('确定'),
                );
              },
          secondaryButtonBuilder: resetButtonBuilder ??
              (style) {
                return OutlinedButton(
                  onPressed: onReset,
                  style: style,
                  child: const Text('重置'),
                );
              },
        );
}
