import 'package:flutter/material.dart';

import '../extensions/datetime_extension.dart';
import 'date_picker.dart';

const String _format = 'yyyy-MM-dd';
const double _kMediumGap = 12.0;

/// 时间段选择
Future<DateTimeRange?> showDateRangeDialog(
  BuildContext context, {
  Color? backgroundColor,
  DateTimeRange? initialDateRange,
  DateTime? firstDate,
  DateTime? lastDate,
  bool showNavigationArrow = true,
}) async {
  return showDialog<DateTimeRange>(
    context: context,
    builder: (context) {
      final Widget picker = DateRangePicker(
        initialDateRange: initialDateRange,
        firstDate: firstDate,
        lastDate: lastDate,
        onChanged: (dateRange) {
          Navigator.pop(context, dateRange);
        },
      );
      return Center(child: Card(child: SizedBox(height: 400.0, child: picker)));
    },
  );
}

/// @title 时间段选择器
/// @updateTime 2022/11/01 3:56 下午
/// @author 曹骏
class DateRangePicker extends StatefulWidget {
  const DateRangePicker({
    Key? key,
    this.initialDateRange,
    this.onChanged,
    this.firstDate,
    this.lastDate,
  }) : super(key: key);

  final DateTimeRange? initialDateRange;
  final ValueChanged<DateTimeRange?>? onChanged;
  final DateTime? firstDate;
  final DateTime? lastDate;

  @override
  State<DateRangePicker> createState() => _DateRangePickerPickerState();
}

class _DateRangePickerPickerState extends State<DateRangePicker>
    with SingleTickerProviderStateMixin {
  /// 输入控制器
  late TextEditingController _startController;
  late TextEditingController _endController;

  /// 输入框焦点
  late FocusNode _startNode;
  late FocusNode _endNode;

  /// 当前时间
  late DateTime? _startDate;
  late DateTime? _endDate;

  DateTime? get _minimumDate {
    if (_endNode.hasFocus) {
      return _startDate ?? widget.firstDate;
    }
    if (_endDate != null) {
      final DateTime oneYear =
          DateTime(_endDate!.year - 1, _endDate!.month, _endDate!.day + 1);
      if (widget.firstDate == null) {
        return oneYear;
      }
      return oneYear.isAfter(widget.firstDate!) ? oneYear : widget.firstDate;
    }
    return widget.firstDate;
  }

  DateTime? get _maximumDate {
    if (_startNode.hasFocus) {
      return _endDate ?? widget.lastDate;
    }
    if (_startDate != null) {
      final DateTime oneYear = DateTime(
          _startDate!.year + 1, _startDate!.month, _startDate!.day - 1);
      if (widget.lastDate == null) {
        return oneYear;
      }
      return oneYear.isBefore(widget.lastDate!) ? oneYear : widget.lastDate;
    }
    return widget.lastDate;
  }

  /// 计算快捷选择的开始时间
  DateTime _compareStartDate(int month) {
    final DateTime now = DateTime.now();
    final int currentMonth = now.month;
    int startMonth = currentMonth - month;
    if (startMonth > 0) {
      return DateTime(now.year, startMonth, now.day + 1);
    } else {
      startMonth = 12 + startMonth;
      return DateTime(now.year - 1, startMonth, now.day + 1);
    }
  }

  /// 时间改变
  void _onDateChanged(DateTime? start, DateTime? end) {
    if (_startDate != start) {
      _startDate = start;
      _startController.text = start?.format(_format) ?? '';
    }
    if (_endDate != end) {
      _endDate = end;
      _endController.text = end?.format(_format) ?? '';
    }
    setState(() {});
    DateTimeRange? result;
    if (start == null && end != null) {
      result = DateTimeRange(start: end, end: end);
    } else if (start != null && end == null) {
      result = DateTimeRange(start: start, end: start);
    } else if (start != null && end != null) {
      result = DateTimeRange(start: start, end: end);
    }
    widget.onChanged?.call(result);
  }

  @override
  void initState() {
    _startDate = widget.initialDateRange?.start;
    _endDate = widget.initialDateRange?.end;
    _startController = TextEditingController(text: _startDate?.format(_format));
    _endController = TextEditingController(text: _endDate?.format(_format));
    _startNode = FocusNode();
    _endNode = FocusNode();
    _startNode.addListener(() {
      if (_startNode.hasFocus) {
        setState(() {});
      }
    });
    _endNode.addListener(() {
      if (_endNode.hasFocus) {
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _startController.dispose();
    _endController.dispose();
    if (_startNode.hasFocus) {
      _startNode.unfocus();
    }
    if (_endNode.hasFocus) {
      _endNode.unfocus();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    const VisualDensity visualDensity = VisualDensity(
      vertical: VisualDensity.minimumDensity,
      horizontal: VisualDensity.minimumDensity,
    );

    // 自定义
    final Widget customTitle = ListTile(
      visualDensity: visualDensity,
      contentPadding: EdgeInsets.zero,
      title: Text('自定义', style: textTheme.bodySmall),
      trailing: IconButton(
        visualDensity: visualDensity,
        onPressed: (_startDate == null && _endDate == null)
            ? null
            : () => _onDateChanged(null, null),
        icon: const Icon(Icons.delete_forever_outlined, size: 20),
        tooltip: '清空',
      ),
    );
    final Widget textFields = Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: _buildTextField(_startController, _startNode, '开始时间', true),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: _kMediumGap),
          child: Text('至', style: textTheme.bodyMedium),
        ),
        Expanded(
          child: _buildTextField(_endController, _endNode, '结束时间'),
        ),
      ],
    );

    // 快捷选择
    final Widget fastChoiceTitle = ListTile(
      visualDensity: visualDensity,
      contentPadding: EdgeInsets.zero,
      title: Text('快捷选择', style: textTheme.bodySmall),
    );
    final Widget fastChoices = Row(
      children: [
        _buildFastChoiceChip('近三月', 3),
        const SizedBox(width: _kMediumGap),
        _buildFastChoiceChip('近半年', 6),
        const SizedBox(width: _kMediumGap),
        _buildFastChoiceChip('近一年', 12),
      ],
    );

    /// 提示文字
    final Widget noticeText = Text(
      '最长可查询时间跨度一年的数据',
      textAlign: TextAlign.center,
      style: textTheme.bodySmall?.copyWith(color: Colors.orange),
    );

    // 时间选择器
    final Widget datePicker = Padding(
      padding: const EdgeInsets.symmetric(horizontal: _kMediumGap * 2),
      child: DatePicker(
        onChanged: (date) {
          if (_startNode.hasFocus) {
            _onDateChanged(date, _endDate);
          } else if (_endNode.hasFocus) {
            _onDateChanged(_startDate, date);
          }
        },
        maximumDate: _maximumDate,
        minimumDate: _minimumDate,
        maximumYear: _maximumDate?.year,
        minimumYear: _minimumDate?.year,
        initialDateTime: _startNode.hasFocus ? _startDate : _endDate,
      ),
    );

    return AbsorbPointer(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: _kMediumGap),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            fastChoiceTitle,
            fastChoices,
            customTitle,
            textFields,
            const SizedBox(height: _kMediumGap),
            noticeText,
            Expanded(child: datePicker),
          ],
        ),
      ),
    );
  }

  /// 快捷选择Chip
  Widget _buildFastChoiceChip(String label, int month) {
    final DateTime start = _compareStartDate(month);
    final DateTime now = DateTime.now();
    final DateTime end = DateTime(now.year, now.month, now.day);
    final bool selected = _startDate == start && _endDate == end;

    Color background;
    Color? foreground;
    BorderSide borderSide;
    if (selected) {
      background = Theme.of(context).colorScheme.primary;
      borderSide = BorderSide.none;
      foreground = Theme.of(context).colorScheme.onPrimary;
    } else {
      background = Theme.of(context).colorScheme.background;
      borderSide = Divider.createBorderSide(context);
    }

    return RawChip(
      label: Text(label),
      labelStyle:
          Theme.of(context).textTheme.bodySmall?.copyWith(color: foreground),
      backgroundColor: background,
      shape: RoundedRectangleBorder(
        side: borderSide,
        borderRadius: const BorderRadius.all(Radius.circular(4.0)),
      ),
      onSelected: (val) {
        _onDateChanged(start, end);
      },
    );
  }

  /// 输入框
  Widget _buildTextField(
    TextEditingController controller,
    FocusNode focusNode,
    String hintText, [
    bool autofocus = false,
  ]) {
    final Color activeColor = Theme.of(context).colorScheme.primary;
    final UnderlineInputBorder border = UnderlineInputBorder(
        borderSide: Divider.createBorderSide(context, width: 2.0));
    final UnderlineInputBorder focusBorder = UnderlineInputBorder(
        borderSide: BorderSide(width: 2.0, color: activeColor));
    final InputDecoration decoration = InputDecoration(
      hintText: hintText,
      border: border,
      filled: false,
      enabledBorder: border,
      focusedBorder: focusBorder,
    );

    return TextField(
      controller: controller,
      focusNode: focusNode,
      readOnly: true,
      autofocus: autofocus,
      textAlign: TextAlign.center,
      decoration: decoration,
    );
  }
}
