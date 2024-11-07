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
    final ThemeData theme = Theme.of(context);
    final Color? buttonColor =
        theme.useMaterial3 || theme.brightness == Brightness.dark
            ? null
            : theme.colorScheme.onPrimary;
    final TxLocalizations localizations = TxLocalizations.of(context);

    final Widget beforeButton = IconButton(
      onPressed: () => _onDateSelected(_date.subtract(const Duration(days: 1))),
      icon: const Icon(Icons.keyboard_arrow_left),
      color: buttonColor,
      tooltip: localizations.theDayBeforeLabel,
    );
    final Widget dateButton = TextButton.icon(
      onPressed: _showDatePicker,
      icon: const Icon(Icons.calendar_month),
      label: Text(_date.format(widget.format ?? 'yyyy-MM-dd')),
      style: TextButton.styleFrom(foregroundColor: buttonColor),
    );
    final Widget afterButton = IconButton(
      color: buttonColor,
      tooltip: localizations.theNextDayLabel,
      icon: const Icon(Icons.keyboard_arrow_right),
      onPressed: () => _onDateSelected(_date.add(const Duration(days: 1))),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [beforeButton, dateButton, afterButton],
    );
  }
}
