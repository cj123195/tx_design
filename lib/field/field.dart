import 'package:flutter/material.dart';

import 'field_theme.dart';

/// 域组件
///
/// 通常用于包装一个输入或者选择组件
abstract class TxField<T> extends StatefulWidget {
  const TxField({
    super.key,
    this.initialValue,
    this.decoration,
    this.focusNode,
    this.enabled,
    this.onChanged,
  });

  /// 初始值
  final T? initialValue;

  /// 值变更回调
  final ValueChanged<T?>? onChanged;

  /// 要在文本字段周围显示的装饰。
  ///
  /// 默认情况下，在文本字段下绘制一条水平线，但可以配置为显示图标、标签、提示文本和错误文本。
  ///
  /// 指定 null 可完全删除修饰（包括修饰引入的额外填充，以节省标签空间）。
  final InputDecoration? decoration;

  /// 定义此小组件的键盘焦点。
  ///
  /// [focusNode] 是一个长期存在的对象，通常由 [StatefulWidget] 父级管理。有关更多信息，
  /// 请参阅 [FocusNode]。
  ///
  /// 要将键盘焦点提供给此小组件，请提供 [focusNode]，然后使用当前的 [FocusScope] 请求焦点：
  ///
  /// ```dart
  /// FocusScope.of(context).requestFocus(myFocusNode);
  /// ```
  ///
  /// 点按小组件时，这会自动发生。
  ///
  /// 要在 widget 获得或失去焦点时收到通知，请向 [focusNode] 添加一个侦听器：
  ///
  /// ```dart
  /// myFocusNode.addListener(() { print(myFocusNode.hasFocus); });
  /// ```
  ///
  /// 如果为 null，则此小部件将创建自己的 [FocusNode]。
  final FocusNode? focusNode;

  /// 如果为 false，则文本字段为 “disabled”：它忽略 taps，并且其 [decoration] 呈现为灰色。
  ///
  /// 如果为非 null，则此属性将覆盖 [decoration] 的 [InputDecoration.enabled] 属性。
  final bool? enabled;

  @override
  State<TxField<T>> createState();
}

abstract class TxFieldState<T> extends State<TxField<T>> {
  T? _value;

  T? get value => _value;

  bool get _isEnabled => widget.enabled ?? widget.decoration?.enabled ?? true;

  /// 默认提示文字
  String? get defaultHintText;

  /// 最终生效的装饰器
  InputDecoration get effectiveDecoration {
    final InputDecorationTheme inputDecorationTheme =
        TxFieldTheme.of(context).inputDecorationTheme ??
            _TxFieldThemeDefaultsM3(context).inputDecorationTheme!;
    final String? hintText = widget.decoration?.hintText ?? defaultHintText;
    final InputDecoration decoration =
        (widget.decoration ?? const InputDecoration())
            .applyDefaults(inputDecorationTheme);
    final BoxConstraints? constraints = decoration.isDense == true
        ? const BoxConstraints(
            maxHeight: kMinInteractiveDimension / 2,
            maxWidth: kMinInteractiveDimension / 2,
          )
        : null;
    return decoration.copyWith(
      enabled: _isEnabled,
      hintText: hintText,
      prefixIconConstraints: decoration.prefixIconConstraints ?? constraints,
      suffixIconConstraints: decoration.suffixIconConstraints ?? constraints,
    );
  }

  /// 选择项变更回调
  @mustCallSuper
  void didChange(T? value) {
    if (value != _value) {
      _value = value;
    }
    if (widget.onChanged != null) {
      widget.onChanged!(_value);
    }
  }

  @override
  void initState() {
    _value = widget.initialValue;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant TxField<T> oldWidget) {
    if (_value != widget.initialValue) {
      _value = widget.initialValue;
    }
    super.didUpdateWidget(oldWidget);
  }
}

class _TxFieldThemeDefaultsM3 extends TxFieldThemeData {
  _TxFieldThemeDefaultsM3(BuildContext context)
      : super(
          inputDecorationTheme: Theme.of(context).inputDecorationTheme.copyWith(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
        );
}
