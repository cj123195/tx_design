import 'package:flutter/material.dart';

import '../extensions/datetime_extension.dart';
import '../localizations.dart';
import 'date_picker.dart';

/// 日期选择栏
class TxDatePickerBar extends StatefulWidget implements PreferredSizeWidget {
  const TxDatePickerBar({
    super.key,
    this.initialDate,
    this.onDateChange,
    this.format,
    this.minimumDate,
    this.maximumDate,
    this.buttonStyle,
    this.beforeIcon = const Icon(Icons.keyboard_arrow_left),
    this.middleIcon = const Icon(Icons.calendar_month),
    this.afterIcon = const Icon(Icons.keyboard_arrow_right),
  });

  /// 初始日期
  final DateTime? initialDate;

  /// 日期改变回调
  final ValueChanged<DateTime>? onDateChange;

  /// 格式化
  final String? format;

  /// 最早可选日期
  final DateTime? minimumDate;

  /// 最晚可选日期
  final DateTime? maximumDate;

  /// 前一天图标
  final Widget beforeIcon;

  /// 中间图标
  final Widget middleIcon;

  /// 后一天图标
  final Widget afterIcon;

  /// 按钮样式
  final ButtonStyle? buttonStyle;

  @override
  State<TxDatePickerBar> createState() => _TxDatePickerBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _TxDatePickerBar extends State<TxDatePickerBar> {
  late DateTime _date;

  void _onDateSelected(DateTime date) {
    setState(() {
      _date = date;
    });
    widget.onDateChange?.call(date);
  }

  /// 选择日期
  Future<void> _showDatePicker() async {
    final DateTime? date = await showCupertinoDatePicker(
      context,
      initialDate: _date,
      minimumDate: widget.minimumDate ?? DateTime(1970),
      maximumDate: widget.maximumDate ?? DateTime.now().addYears(3),
    );
    if (date != null) {
      _onDateSelected(date);
    }
  }

  @override
  void initState() {
    _date = widget.initialDate ?? DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(context).colorScheme.onSurface;
    final TxLocalizations localizations = TxLocalizations.of(context);

    final ButtonStyle iconButtonStyle =
        (widget.buttonStyle ?? const ButtonStyle())
            .merge(IconButton.styleFrom(foregroundColor: color));

    final ButtonStyle textButtonStyle = (widget.buttonStyle ??
            const ButtonStyle())
        .merge(TextButton.styleFrom(foregroundColor: color, iconColor: color));

    final Widget leading = IconButton(
      onPressed: () => _onDateSelected(_date.subtract(const Duration(days: 1))),
      icon: widget.beforeIcon,
      style: iconButtonStyle,
      tooltip: localizations.theDayBeforeLabel,
    );
    final Widget middle = TextButton.icon(
      onPressed: _showDatePicker,
      icon: widget.middleIcon,
      label: Text(_date.format(widget.format ?? 'yyyy-MM-dd')),
      style: textButtonStyle,
    );
    final Widget trailing = IconButton(
      style: iconButtonStyle,
      tooltip: localizations.theNextDayLabel,
      icon: widget.afterIcon,
      onPressed: () => _onDateSelected(_date.add(const Duration(days: 1))),
    );

    return SizedBox(
      height: kToolbarHeight,
      child: NavigationToolbar(
        leading: leading,
        trailing: trailing,
        middle: middle,
        centerMiddle: true,
      ),
    );
  }
}
