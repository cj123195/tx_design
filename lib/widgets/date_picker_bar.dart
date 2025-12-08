import 'package:flutter/material.dart';

import '../extensions/datetime_extension.dart';
import '../localizations.dart';
import 'date_picker.dart';

/// 日期选择栏
class TxDatePickerBar extends StatefulWidget implements PreferredSizeWidget {
  TxDatePickerBar({
    super.key,
    this.initialDate,
    this.onDateChange,
    this.format,
    DateTime? minimumDate,
    DateTime? maximumDate,
  })  : minimumDate = minimumDate == null
            ? null
            : DateTime(minimumDate.year, minimumDate.month, minimumDate.day),
        maximumDate = maximumDate == null
            ? null
            : DateTime(maximumDate.year, maximumDate.month, maximumDate.day),
        assert(
          minimumDate == null ||
              maximumDate == null ||
              maximumDate.isAfter(minimumDate),
          '最晚时间必须晚于最早时间',
        );

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
      _date = DateTime(date.year, date.month, date.day);
    });
    widget.onDateChange?.call(_date);
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
    final now = DateTime.now();
    final nowDate = DateTime(now.year, now.month, now.day);
    final firstDate = widget.minimumDate;
    final lastDate = widget.maximumDate;
    _date = widget.initialDate ??
        (firstDate != null && nowDate.isBefore(firstDate)
            ? firstDate
            : lastDate != null && nowDate.isAfter(lastDate)
                ? lastDate
                : nowDate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color buttonColor = theme.colorScheme.onSurface;
    final TxLocalizations localizations = TxLocalizations.of(context);

    final Widget beforeButton = IconButton(
      onPressed: _date != widget.minimumDate
          ? () => _onDateSelected(_date.subtract(const Duration(days: 1)))
          : null,
      icon: const Icon(Icons.keyboard_arrow_left),
      color: buttonColor,
      tooltip: localizations.theDayBeforeLabel,
    );
    final Widget dateButton = TextButton.icon(
      onPressed: _showDatePicker,
      icon: const Icon(Icons.calendar_month, size: 20),
      label: Text(_date.format(widget.format ?? 'yyyy-MM-dd')),
      style: TextButton.styleFrom(foregroundColor: buttonColor),
    );
    final Widget afterButton = IconButton(
      color: buttonColor,
      tooltip: localizations.theNextDayLabel,
      icon: const Icon(Icons.keyboard_arrow_right),
      onPressed: _date != widget.maximumDate
          ? () => _onDateSelected(_date.add(const Duration(days: 1)))
          : null,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [beforeButton, dateButton, afterButton],
    );
  }
}
