import 'package:flutter/material.dart';

import '../extensions/datetime_extension.dart';
import 'date_picker_button_theme.dart';

const String _kFormat = 'yyyy-M-d';
const bool _kShowWeekday = false;

/// 一个用于选择日期的按钮小部件
class TxDatePickerButton extends StatefulWidget {
  /// 创建一个日期选择按钮
  const TxDatePickerButton({
    super.key,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.onDateSelect,
    this.showWeekday,
    this.buttonStyle,
    this.prefixIcon,
    this.suffixIcon,
    this.format,
  });

  /// 初始时间
  final DateTime? initialDate;

  /// 可选择的最早时间
  final DateTime? firstDate;

  /// 可选择的最晚时间
  final DateTime? lastDate;

  /// 日期选择回调
  final ValueChanged<DateTime>? onDateSelect;

  /// 是否显示周工作日
  final bool? showWeekday;

  /// 展示在日期前的组件，一般为一个日历小图标
  final Widget? prefixIcon;

  /// 展示在日期后的组件吗，一般为一个向下的图标
  final Widget? suffixIcon;

  /// 按钮样式
  final ButtonStyle? buttonStyle;

  /// 时间格式化方式
  final String? format;

  @override
  State<TxDatePickerButton> createState() => _TxDatePickerButtonState();
}

class _TxDatePickerButtonState extends State<TxDatePickerButton> {
  late DateTime _selectDate;

  Future<void> _showDateSelect() async {
    final TxDatePickerButtonThemeData buttonTheme =
        TxDatePickerButtonTheme.of(context);
    final DateTime firstDate =
        widget.firstDate ?? buttonTheme.firstDate ?? DateTime(1970);
    final DateTime lastDate =
        widget.lastDate ?? buttonTheme.lastDate ?? DateTime.now();

    final res = await showDatePicker(
      context: context,
      initialDate: _selectDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (res != null) {
      setState(() {
        _selectDate = res;
      });
      widget.onDateSelect?.call(res);
    }
  }

  @override
  void initState() {
    _selectDate = widget.initialDate ?? DateTime.now();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant TxDatePickerButton oldWidget) {
    if (widget.initialDate != null && widget.initialDate != _selectDate) {
      _selectDate = widget.initialDate!;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final TxDatePickerButtonThemeData buttonTheme =
        TxDatePickerButtonTheme.of(context);

    String format = widget.format ?? buttonTheme.format ?? _kFormat;
    if (_selectDate.isThisYear) {
      format = format.substring(format.indexOf('M'));
    }
    final ButtonStyle buttonStyle = widget.buttonStyle ??
        buttonTheme.buttonStyle ??
        ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          minimumSize: Size.zero,
          textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontSize: 13,
                height: 1.3,
                fontWeight: FontWeight.w500,
              ),
        );
    final bool showWeekday =
        widget.showWeekday ?? buttonTheme.showWeekDay ?? _kShowWeekday;
    final Widget? prefix = widget.prefixIcon ?? buttonTheme.prefixIcon;
    final Widget? suffix = widget.suffixIcon ?? buttonTheme.suffixIcon;

    final String date = _selectDate.format(format);
    final String weekday = _selectDate.formattedWeekday(short: true);
    Widget child = Text(showWeekday ? '$date $weekday' : date);

    if (suffix != null) {
      child = Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [child, const SizedBox(width: 4), widget.suffixIcon!],
      );
    }

    if (prefix != null) {
      return ElevatedButton.icon(
        onPressed: _showDateSelect,
        icon: prefix,
        label: child,
        style: buttonStyle,
      );
    }

    return ElevatedButton(
      onPressed: _showDateSelect,
      style: buttonStyle,
      child: child,
    );
  }
}
