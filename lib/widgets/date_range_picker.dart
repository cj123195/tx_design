import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../extensions/datetime_extension.dart';
import '../extensions/time_of_day_extension.dart';
import '../localizations.dart';
import 'bottom_sheet.dart';

const double _kMediumGap = 12.0;
const Duration _dialogSizeAnimationDuration = Duration(milliseconds: 200);
const Size _inputPortraitDialogSize = Size(330.0, 400.0);

/// 带快捷选择的时间范围选择器
class CupertinoDateRangePicker extends StatefulWidget {
  const CupertinoDateRangePicker({
    required this.onChanged,
    required this.mode,
    this.minimumDate,
    this.maximumDate,
    super.key,
    this.initialDatetimeRange,
    this.helpText,
    this.fieldStartHintText,
    this.fieldEndHintText,
    this.quickChoices = const [
      DateRangeMonthQuickChoice(),
      DateRangeMonthQuickChoice(value: 6),
      DateRangeYearQuickChoice(),
    ],
    this.format,
    this.dateOrder,
  });

  /// 日期范围选择器打开时开始的日期范围。
  ///
  /// 如果提供了初始日期范围，则“initialDateRange.start”和“initialDateRange.end”必须
  /// 介于 [minimumDate] 和 [maximumDate] 之间或之间。对于所有这些 [DateTime] 值，仅考虑其日期。
  /// 它们的时间字段将被忽略。
  ///
  /// 如果 [initialDatetimeRange] 为非空，则它将用作初始选择的日期范围。如果提供，
  /// 则“initialDateRange.start”必须在“initialDateRange.end”之前或之后。
  final DateTimeRange? initialDatetimeRange;

  /// 日期范围内允许的最早日期。
  final DateTime? minimumDate;

  /// 日期范围内允许的最晚日期。
  final DateTime? maximumDate;

  /// 显示在输入框日期显示输入框底部的帮助文字。
  final String? helpText;

  /// 用于在开始字段中未输入任何文本时提示用户的文本。
  ///
  /// 如果为 null，则使用 [MaterialLocalizations.dateRangeStartLabel] 的本地化值。
  final String? fieldStartHintText;

  /// 用于在结束字段中未输入任何文本时提示用户的文本。
  ///
  /// 如果为 null，则使用 [MaterialLocalizations.dateRangeStartLabel] 的本地化值。
  final String? fieldEndHintText;

  /// 选择器值变动回调
  final ValueChanged<DateTimeRange?> onChanged;

  /// 快捷选择项
  final List<DateRangeQuickChoice>? quickChoices;

  /// 选择模式
  final CupertinoDatePickerMode mode;

  /// 格式化方法
  final String? format;

  /// 参考 [CupertinoDatePicker.dateOrder]
  final DatePickerDateOrder? dateOrder;

  @override
  State<CupertinoDateRangePicker> createState() =>
      _CupertinoDateRangePickerState();
}

class _CupertinoDateRangePickerState extends State<CupertinoDateRangePicker>
    with SingleTickerProviderStateMixin {
  /// 输入控制器
  late TextEditingController _startController;
  late TextEditingController _endController;

  /// 输入框焦点
  late FocusNode _startNode;
  late FocusNode _endNode;

  /// 当前时间
  late DateTime? _start;
  late DateTime? _end;

  String get _format =>
      widget.format ??
      switch (widget.mode) {
        CupertinoDatePickerMode.time => 'HH:mm',
        CupertinoDatePickerMode.date => 'yyyy-MM-dd',
        CupertinoDatePickerMode.dateAndTime => 'yyyy/MM/dd HH:mm',
        CupertinoDatePickerMode.monthYear => 'yyyy-MM',
      };

  /// 清除选择的日期
  void _onRangePicked(DateTimeRange range) {
    setState(() {
      if (widget.minimumDate == null ||
          range.start.isAfter(widget.minimumDate!)) {
        _start = range.start;
      } else {
        _start = widget.minimumDate!;
      }
      if (widget.maximumDate == null ||
          range.end.isBefore(widget.maximumDate!)) {
        _end = range.end;
      } else {
        _end = widget.maximumDate!;
      }
    });
    _callChange();
  }

  /// 清除选择的日期
  void _clear() {
    setState(() {
      _start = null;
      _end = null;
    });
    widget.onChanged(null);
  }

  /// 触发变更回调
  void _callChange() {
    final String? startText = _start?.format(_format);
    if (_startController.text != startText) {
      _startController.text = startText ?? '';
    }
    final String? endText = _end?.format(_format);
    if (_endController.text != endText) {
      _endController.text = endText ?? '';
    }
    DateTimeRange? result;
    if (_start == null && _end != null) {
      result = DateTimeRange(start: _end!, end: _end!);
    } else if (_start != null && _end == null) {
      result = DateTimeRange(start: _start!, end: _start!);
    } else if (_start != null && _end != null) {
      result = DateTimeRange(start: _start!, end: _end!);
    }
    widget.onChanged(result);
  }

  /// 开始时间改变
  void _onStartChanged(DateTime? start) {
    if (_start != start) {
      _start = start;
      _startController.text = start?.format(_format) ?? '';
    }
    setState(() {});
  }

  /// 结束时间改变
  void _onEndChanged(DateTime? end) {
    if (_end != end) {
      _end = end;
      _endController.text = end?.format(_format) ?? '';
    }
    setState(() {});
    _callChange();
  }

  /// 焦点改变
  void _onFocusChanged() {
    setState(() {});
  }

  @override
  void initState() {
    _start = widget.initialDatetimeRange?.start ?? DateTime.now();
    _end = widget.initialDatetimeRange?.end;
    _startController = TextEditingController(text: _start?.format(_format));
    _endController = TextEditingController(text: _end?.format(_format));
    _startNode = FocusNode();
    _endNode = FocusNode();
    _startNode.addListener(_onFocusChanged);
    super.initState();
  }

  @override
  void dispose() {
    _startController.dispose();
    _endController.dispose();
    _startNode.removeListener(_onFocusChanged);
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
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final Orientation orientation = mediaQuery.orientation;
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final TxLocalizations txLocalizations = TxLocalizations.of(context);

    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    const VisualDensity visualDensity = VisualDensity(
      vertical: VisualDensity.minimumDensity,
      horizontal: VisualDensity.minimumDensity,
    );

    final List<Widget> contents = [];

    // 快捷选择
    if (widget.quickChoices?.isNotEmpty == true) {
      final Widget quickPickTitle = ListTile(
        dense: true,
        visualDensity: visualDensity,
        contentPadding: EdgeInsets.zero,
        title: Text(
          txLocalizations.quickChoiceTitle,
          style: textTheme.bodySmall,
        ),
      );
      final Widget quickPicker = SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(widget.quickChoices!.length, (index) {
            final DateRangeQuickChoice choice = widget.quickChoices![index];
            final DateTimeRange range = choice.datetimeRange;
            return Container(
              margin: const EdgeInsets.only(right: _kMediumGap),
              child: _QuickChoiceChip(
                item: choice,
                onSelect: _onRangePicked,
                selected: _start == range.start && _end == range.end,
              ),
            );
          }),
        ),
      );
      contents.addAll([quickPickTitle, quickPicker]);
    }

    // 自定义
    final Widget customTitle = ListTile(
      dense: true,
      visualDensity: visualDensity,
      contentPadding: EdgeInsets.zero,
      title: Text(txLocalizations.customTitle, style: textTheme.bodySmall),
      trailing: IconButton(
        visualDensity: visualDensity,
        onPressed: (_start == null && _end == null) ? null : _clear,
        icon: const Icon(Icons.delete_outline, size: 20),
        tooltip: localizations.deleteButtonTooltip,
      ),
    );
    contents.add(customTitle);

    final String fieldStartHintText =
        widget.fieldStartHintText ?? localizations.dateRangeStartLabel;
    final Widget fieldStart = _DateTextField(
      hintText: fieldStartHintText,
      controller: _startController,
      focusNode: _startNode,
      autofocus: true,
    );

    final String fieldEndHintText =
        widget.fieldEndHintText ?? localizations.dateRangeEndLabel;
    final Widget fieldEnd = _DateTextField(
      hintText: fieldEndHintText,
      controller: _endController,
      focusNode: _endNode,
    );
    final Widget textFields = Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(child: fieldStart),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: _kMediumGap),
          child: Text(
            txLocalizations.dateRangeDateSeparator,
            style: textTheme.bodyMedium,
          ),
        ),
        Expanded(child: fieldEnd),
      ],
    );
    contents.add(textFields);

    // 帮助文字
    if (widget.helpText != null) {
      final Widget helpText = Text(
        widget.helpText!,
        textAlign: TextAlign.center,
        style: textTheme.bodySmall?.copyWith(color: Colors.orange),
      );
      contents.addAll([const SizedBox(height: _kMediumGap), helpText]);
    }

    // 时间选择器
    final Widget picker = _startNode.hasFocus
        ? CupertinoDatePicker(
            onDateTimeChanged: _onStartChanged,
            maximumDate: _end ?? widget.maximumDate,
            minimumDate: widget.minimumDate,
            initialDateTime: _start,
            dateOrder: DatePickerDateOrder.ymd,
            mode: widget.mode,
            use24hFormat: true,
          )
        : CupertinoDatePicker(
            onDateTimeChanged: _onEndChanged,
            maximumDate: widget.maximumDate,
            minimumDate: _start ?? widget.minimumDate,
            initialDateTime: _end,
            dateOrder: DatePickerDateOrder.ymd,
            mode: widget.mode,
            use24hFormat: true,
          );

    Size size;
    Widget content;
    if (orientation == Orientation.portrait) {
      size = _inputPortraitDialogSize;
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [...contents, Expanded(child: picker)],
      );
    } else {
      size = mediaQuery.size;
      content = Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: contents,
            ),
          ),
          Expanded(child: picker),
        ],
      );
    }

    return AnimatedContainer(
      width: size.width,
      height: size.height,
      duration: _dialogSizeAnimationDuration,
      curve: Curves.easeIn,
      child: MediaQuery.withNoTextScaling(
        child: Builder(builder: (BuildContext context) {
          return content;
        }),
      ),
    );
  }
}

class _DateTextField extends StatelessWidget {
  const _DateTextField({
    required this.hintText,
    required this.controller,
    required this.focusNode,
    this.autofocus = false,
  });

  final String hintText;
  final bool autofocus;
  final TextEditingController controller;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
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

class _QuickChoiceChip extends StatelessWidget {
  const _QuickChoiceChip({
    required this.item,
    this.onSelect,
    this.selected = false,
  });

  final DateRangeQuickChoice item;
  final ValueChanged<DateTimeRange>? onSelect;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    Color background;
    Color? foreground;
    BorderSide borderSide;
    if (selected) {
      background = theme.colorScheme.primary;
      borderSide = BorderSide.none;
      foreground = theme.colorScheme.onPrimary;
    } else {
      background = theme.colorScheme.surface;
      borderSide = Divider.createBorderSide(context);
    }

    return RawChip(
      label: Text(item.getLabelText(context)),
      labelStyle: textTheme.bodySmall?.copyWith(color: foreground),
      backgroundColor: background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
      selectedColor: background,
      side: borderSide,
      onSelected: selected ? null : (val) => onSelect?.call(item.datetimeRange),
    );
  }
}

abstract class DateRangeQuickChoice {
  const DateRangeQuickChoice({required this.value});

  final int value;

  DateTimeRange get datetimeRange;

  String getLabelText(BuildContext context);

  DateTime get now {
    final DateTime timeNow = DateTime.now();
    return DateTime(timeNow.year, timeNow.month, timeNow.day);
  }
}

class DateRangeYearQuickChoice extends DateRangeQuickChoice {
  const DateRangeYearQuickChoice({super.value = 1});

  @override
  String getLabelText(BuildContext context) {
    final TxLocalizations localizations = TxLocalizations.of(context);
    return localizations.recentYearsLabel(value);
  }

  @override
  DateTimeRange get datetimeRange {
    final DateTime end = now;
    final DateTime start = DateTime(end.year - 1, end.month, end.day + 1);
    return DateTimeRange(start: start, end: end);
  }
}

class DateRangeMonthQuickChoice extends DateRangeQuickChoice {
  const DateRangeMonthQuickChoice({super.value = 1});

  @override
  String getLabelText(BuildContext context) {
    final TxLocalizations localizations = TxLocalizations.of(context);
    return localizations.recentMonthsLabel(value);
  }

  @override
  DateTimeRange get datetimeRange {
    final DateTime end = now;
    final int endMonth = end.month;

    int startMonth = endMonth - value;
    DateTime start;
    if (startMonth > 0) {
      start = DateTime(end.year, startMonth, end.day + 1);
    } else {
      startMonth = 12 + startMonth;
      start = DateTime(end.year - 1, startMonth, end.day + 1);
    }
    return DateTimeRange(start: start, end: end);
  }
}

class DateRangeWeekQuickChoice extends DateRangeQuickChoice {
  const DateRangeWeekQuickChoice({super.value = 1});

  @override
  String getLabelText(BuildContext context) {
    final TxLocalizations localizations = TxLocalizations.of(context);
    return localizations.recentWeeksLabel(value);
  }

  @override
  DateTimeRange get datetimeRange {
    final DateTime end = now;
    final DateTime start = end.subtract(Duration(days: value * 7));
    return DateTimeRange(start: start, end: end);
  }
}

class DateRangeDayQuickChoice extends DateRangeQuickChoice {
  const DateRangeDayQuickChoice({super.value = 10});

  @override
  String getLabelText(BuildContext context) {
    final TxLocalizations localizations = TxLocalizations.of(context);
    return localizations.recentYearsLabel(value);
  }

  @override
  DateTimeRange get datetimeRange {
    final DateTime end = now;
    final DateTime start = end.subtract(Duration(days: value));
    return DateTimeRange(start: start, end: end);
  }
}

@immutable
class TimeRange {
  /// Creates a date range for the given start and end [TimeOfDay].
  TimeRange({
    required this.start,
    required this.end,
  }) : assert(!start.isAfter(end));

  TimeRange.fromDateRange(DateTimeRange dateRange)
      : assert(
          dateRange.start.year == dateRange.end.year &&
              dateRange.start.month == dateRange.end.month &&
              dateRange.start.day == dateRange.end.day,
          'When converting a date range to a time range, the year, month, and '
          'day of the date range must be the same',
        ),
        start = TimeOfDay.fromDateTime(dateRange.start),
        end = TimeOfDay.fromDateTime(dateRange.end);

  /// The start of the range of dates.
  final TimeOfDay start;

  /// The end of the range of dates.
  final TimeOfDay end;

  /// Returns a [Duration] of the time between [start] and [end].
  ///
  /// See [DateTime.difference] for more details.
  Duration get duration => end.difference(start);

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is TimeRange && other.start == start && other.end == end;
  }

  @override
  int get hashCode => Object.hash(start, end);

  @override
  String toString() => '$start - $end';

  DateTimeRange toDateRange([DateTime? date]) {
    return DateTimeRange(
      start: start.toDateTime(date),
      end: end.toDateTime(date),
    );
  }
}

/// 时间区间选择
Future<TimeRange?> showCupertinoTimeRangePicker(
  BuildContext context, {
  String? titleText,
  TimeRange? initialTimeRange,
  TimeOfDay? minimumTime,
  TimeOfDay? maximumTime,
  String? helpText,
  String? fieldStartHintText,
  String? fieldEndHintText,
  String? textConfirm,
  String? textCancel,
  Color? backgroundColor,
  double? elevation,
  EdgeInsetsGeometry? contentPadding,
  DatePickerDateOrder? dateOrder,
  String? format,
}) async {
  final MaterialLocalizations localizations = MaterialLocalizations.of(context);
  final dateRange = await _showCupertinoRangePicker(
    context,
    titleText: titleText ?? localizations.timePickerInputHelpText,
    mode: CupertinoDatePickerMode.time,
    initialRange: initialTimeRange == null
        ? null
        : DateTimeRange(
            start: initialTimeRange.start.toDateTime(),
            end: initialTimeRange.end.toDateTime(),
          ),
    minimumDate: minimumTime?.toDateTime(),
    maximumDate: maximumTime?.toDateTime(),
    helpText: helpText,
    fieldEndHintText: fieldEndHintText,
    fieldStartHintText: fieldStartHintText,
    format: format,
    contentPadding: contentPadding,
    backgroundColor: backgroundColor,
    dateOrder: dateOrder,
    textCancel: textCancel,
    textConfirm: textConfirm,
    elevation: elevation,
  );
  return dateRange == null ? null : TimeRange.fromDateRange(dateRange);
}

/// 月份区间选择
Future<DateTimeRange?> showCupertinoMonthRangePicker(
  BuildContext context, {
  String? titleText,
  DateTimeRange? initialMonthRange,
  DateTime? minimumDate,
  DateTime? maximumDate,
  String? helpText,
  String? fieldStartHintText,
  String? fieldEndHintText,
  List<DateRangeQuickChoice>? quickChoices,
  String? textConfirm,
  String? textCancel,
  Color? backgroundColor,
  double? elevation,
  EdgeInsetsGeometry? contentPadding,
  DatePickerDateOrder? dateOrder,
  String? format,
}) async {
  final TxLocalizations localizations = TxLocalizations.of(context);
  return _showCupertinoRangePicker(
    context,
    titleText: titleText ?? localizations.monthPickerTitle,
    mode: CupertinoDatePickerMode.monthYear,
    initialRange: initialMonthRange,
    minimumDate: minimumDate,
    maximumDate: maximumDate,
    helpText: helpText,
    fieldEndHintText: fieldEndHintText,
    fieldStartHintText: fieldStartHintText,
    quickChoices: quickChoices,
    format: format,
    contentPadding: contentPadding,
    backgroundColor: backgroundColor,
    dateOrder: dateOrder,
    textCancel: textCancel,
    textConfirm: textConfirm,
    elevation: elevation,
  );
}

/// 日期区间选择
Future<DateTimeRange?> showCupertinoDateRangePicker(
  BuildContext context, {
  String? titleText,
  DateTimeRange? initialDateRange,
  DateTime? minimumDate,
  DateTime? maximumDate,
  String? helpText,
  String? fieldStartHintText,
  String? fieldEndHintText,
  List<DateRangeQuickChoice>? quickChoices,
  String? textConfirm,
  String? textCancel,
  Color? backgroundColor,
  double? elevation,
  EdgeInsetsGeometry? contentPadding,
  DatePickerDateOrder? dateOrder,
  String? format,
}) async {
  final MaterialLocalizations localizations = MaterialLocalizations.of(context);
  return _showCupertinoRangePicker(
    context,
    titleText: titleText ?? localizations.dateRangePickerHelpText,
    mode: CupertinoDatePickerMode.date,
    initialRange: initialDateRange,
    minimumDate: minimumDate,
    maximumDate: maximumDate,
    helpText: helpText,
    fieldEndHintText: fieldEndHintText,
    fieldStartHintText: fieldStartHintText,
    quickChoices: quickChoices,
    format: format,
    contentPadding: contentPadding,
    backgroundColor: backgroundColor,
    dateOrder: dateOrder,
    textCancel: textCancel,
    textConfirm: textConfirm,
    elevation: elevation,
  );
}

/// 日期时间段选择
Future<DateTimeRange?> showCupertinoDatetimeRangePicker(
  BuildContext context, {
  String? titleText,
  DateTimeRange? initialDatetimeRange,
  DateTime? minimumDate,
  DateTime? maximumDate,
  String? helpText,
  String? fieldStartHintText,
  String? fieldEndHintText,
  List<DateRangeQuickChoice>? quickChoices,
  String? textConfirm,
  String? textCancel,
  Color? backgroundColor,
  double? elevation,
  EdgeInsetsGeometry? contentPadding,
  DatePickerDateOrder? dateOrder,
  String? format,
}) async {
  final MaterialLocalizations localizations = MaterialLocalizations.of(context);
  return _showCupertinoRangePicker(
    context,
    titleText: titleText ?? localizations.dateRangePickerHelpText,
    mode: CupertinoDatePickerMode.dateAndTime,
    initialRange: initialDatetimeRange,
    minimumDate: minimumDate,
    maximumDate: maximumDate,
    helpText: helpText,
    fieldEndHintText: fieldEndHintText,
    fieldStartHintText: fieldStartHintText,
    quickChoices: quickChoices,
    format: format,
    contentPadding: contentPadding,
    backgroundColor: backgroundColor,
    dateOrder: dateOrder,
    textCancel: textCancel,
    textConfirm: textConfirm,
    elevation: elevation,
  );
}

/// 显示 iOS 风格的日期选择器
Future<DateTimeRange?> _showCupertinoRangePicker(
  BuildContext context, {
  required CupertinoDatePickerMode mode,
  required String titleText,
  DateTimeRange? initialRange,
  DateTime? minimumDate,
  DateTime? maximumDate,
  String? helpText,
  String? fieldStartHintText,
  String? fieldEndHintText,
  List<DateRangeQuickChoice>? quickChoices,
  String? textConfirm,
  String? textCancel,
  Color? backgroundColor,
  double? elevation,
  EdgeInsetsGeometry? contentPadding,
  DatePickerDateOrder? dateOrder,
  String? format,
}) async {
  DateTimeRange? result = initialRange;

  return await showDefaultBottomSheet<DateTimeRange>(
    context,
    title: titleText,
    contentBuilder: (context) => CupertinoDateRangePicker(
      mode: mode,
      initialDatetimeRange: result,
      minimumDate: minimumDate,
      maximumDate: maximumDate,
      dateOrder: dateOrder,
      onChanged: (range) => result = range,
      fieldEndHintText: fieldEndHintText,
      fieldStartHintText: fieldStartHintText,
      helpText: helpText,
      quickChoices: quickChoices,
      format: format,
    ),
    textConfirm: textConfirm,
    textCancel: textCancel,
    backgroundColor: backgroundColor,
    contentPadding:
        contentPadding ?? const EdgeInsets.symmetric(horizontal: 12.0),
    elevation: elevation,
    onConfirm: () => Navigator.pop(context, result),
  );
}
