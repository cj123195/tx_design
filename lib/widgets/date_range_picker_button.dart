import 'package:flutter/material.dart';

import '../extensions/datetime_extension.dart';
import '../localizations.dart';
import 'date_range_picker_button_theme.dart';

const String _defaultFormat = 'yyyy/MM/dd';

/// 时间区间选择按钮
class TxDateRangePickerButton extends StatefulWidget {
  const TxDateRangePickerButton({
    super.key,
    this.initialDateRange,
    this.onChanged,
    this.style,
    this.format,
    this.icon = const Icon(Icons.calendar_month, size: 16.0),
    this.firstDate,
    this.lastDate,
  });

  /// 初始选择时间区间
  final DateTimeRange? initialDateRange;

  /// 选择回调
  final ValueChanged<DateTimeRange>? onChanged;

  /// 按钮样式
  final ButtonStyle? style;

  /// 时间格式化方式
  final String? format;

  /// 图标
  final Widget? icon;

  /// 最早可选择时间
  final DateTime? firstDate;

  /// 最早可选择时间
  final DateTime? lastDate;

  @override
  State<TxDateRangePickerButton> createState() =>
      _TxDateRangePickerButtonState();
}

class _TxDateRangePickerButtonState extends State<TxDateRangePickerButton> {
  DateTimeRange? _range;

  /// 选择时间区间
  Future<void> _pickDateRange(BuildContext context) async {
    final TxDateRangePickerButtonThemeData buttonTheme =
        TxDateRangePickerButtonTheme.of(context);

    final res = await showDateRangePicker(
      context: context,
      firstDate: widget.firstDate ?? buttonTheme.firstDate ?? DateTime(1970),
      lastDate: widget.lastDate ?? buttonTheme.lastDate ?? DateTime.now(),
      initialDateRange: _range,
    );
    if (res != null && res != _range) {
      if (widget.onChanged != null) {
        widget.onChanged!(res);
      }
      setState(() {
        _range = res;
      });
    }
  }

  @override
  void initState() {
    _range = widget.initialDateRange;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant TxDateRangePickerButton oldWidget) {
    if (widget.initialDateRange != oldWidget.initialDateRange) {
      _range = widget.initialDateRange;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final TxLocalizations localizations = TxLocalizations.of(context);
    final TxDateRangePickerButtonThemeData buttonTheme =
        TxDateRangePickerButtonTheme.of(context);

    final String effectiveFormat =
        widget.format ?? buttonTheme.format ?? _defaultFormat;
    String buttonText;
    if (_range == null) {
      buttonText = localizations.pickerFormFieldHint;
    } else {
      final String startText = _range!.start.format(effectiveFormat);
      final String endText = _range!.end.format(effectiveFormat);
      buttonText = '$startText — $endText';
    }

    final ButtonStyle defaults = OutlinedButton.styleFrom(
      minimumSize: const Size(0.0, 32.0),
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4.0),
      visualDensity: VisualDensity.compact,
      textStyle: Theme.of(context).textTheme.labelSmall,
    );
    final ButtonStyle buttonStyle =
        (widget.style ?? buttonTheme.buttonStyle ?? const ButtonStyle())
            .merge(defaults);

    if (widget.icon == null) {
      return OutlinedButton(
        onPressed: () => _pickDateRange(context),
        style: buttonStyle,
        child: Text(buttonText),
      );
    }

    return OutlinedButton.icon(
      onPressed: () => _pickDateRange(context),
      label: Text(buttonText),
      style: buttonStyle,
      icon: widget.icon!,
    );
  }
}
