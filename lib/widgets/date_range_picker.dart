import 'package:flutter/material.dart';

import '../extensions/datetime_extension.dart';
import '../localizations.dart';
import 'date_picker.dart';

const String _format = 'yyyy-MM-dd';
const double _kMediumGap = 12.0;
const Duration _dialogSizeAnimationDuration = Duration(milliseconds: 200);
const Size _inputPortraitDialogSize = Size(330.0, 400.0);

/// 时间段选择
Future<DateTimeRange?> showDateRangePickerDialog(
  BuildContext context, {
  DateTimeRange? initialDateRange,
  DateTime? firstDate,
  DateTime? lastDate,
  String? helpText,
  String? fieldStartHintText,
  String? fieldEndHintText,
  List<DateRangeQuickChoice>? quickChoices = const [
    DateRangeMonthQuickChoice(),
    DateRangeMonthQuickChoice(value: 6),
    DateRangeYearQuickChoice(),
  ],
  EdgeInsetsGeometry? buttonPadding,
  String? confirmText,
  ButtonStyle? confirmButtonStyle,
  String? cancelText,
  ButtonStyle? cancelButtonStyle,
  Color? backgroundColor,
  double? elevation,
  EdgeInsets insetPadding = const EdgeInsets.symmetric(horizontal: 12.0),
}) async {
  final MaterialLocalizations localizations = MaterialLocalizations.of(context);

  DateTimeRange? result = initialDateRange;
  final Widget picker = TxDateRangePickerDialog(
    initialDateRange: initialDateRange,
    firstDate: firstDate,
    lastDate: lastDate,
    onChanged: (dateRange) => result = dateRange,
    helpText: helpText,
    fieldEndHintText: fieldEndHintText,
    fieldStartHintText: fieldStartHintText,
    quickChoices: quickChoices,
  );
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        buttonPadding: buttonPadding,
        backgroundColor: backgroundColor,
        elevation: elevation,
        insetPadding: insetPadding,
        content: picker,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: cancelButtonStyle,
            child: Text(cancelText ?? localizations.cancelButtonLabel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, result),
            style: confirmButtonStyle,
            child: Text(confirmText ?? localizations.okButtonLabel),
          ),
        ],
      );
    },
  );
}

/// 带快捷选择的时间范围选择器
class TxDateRangePickerDialog extends StatefulWidget {
  const TxDateRangePickerDialog({
    required this.firstDate,
    required this.lastDate,
    super.key,
    this.initialDateRange,
    this.helpText,
    this.fieldStartHintText,
    this.fieldEndHintText,
    this.onChanged,
    this.quickChoices = const [
      DateRangeMonthQuickChoice(),
      DateRangeMonthQuickChoice(value: 6),
      DateRangeYearQuickChoice(),
    ],
  });

  /// 日期范围选择器打开时开始的日期范围。
  ///
  /// 如果提供了初始日期范围，则“initialDateRange.start”和“initialDateRange.end”必须
  /// 介于 [firstDate] 和 [lastDate] 之间或之间。对于所有这些 [DateTime] 值，仅考虑其日期。
  /// 它们的时间字段将被忽略。
  ///
  /// 如果 [initialDateRange] 为非空，则它将用作初始选择的日期范围。如果提供，
  /// 则“initialDateRange.start”必须在“initialDateRange.end”之前或之后。
  final DateTimeRange? initialDateRange;

  /// 日期范围内允许的最早日期。
  final DateTime? firstDate;

  /// 日期范围内允许的最晚日期。
  final DateTime? lastDate;

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
  final ValueChanged<DateTimeRange?>? onChanged;

  /// 快捷选择项
  final List<DateRangeQuickChoice>? quickChoices;

  @override
  State<TxDateRangePickerDialog> createState() =>
      _TxDateRangePickerDialogState();
}

class _TxDateRangePickerDialogState extends State<TxDateRangePickerDialog>
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
    return widget.firstDate;
  }

  DateTime? get _maximumDate {
    if (_startNode.hasFocus) {
      return _endDate ?? widget.lastDate;
    }
    return widget.lastDate;
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
    _startDate = widget.initialDateRange?.start ?? DateTime.now();
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
        if (_endDate == null && _startDate != null) {
          _onDateChanged(
            _startDate,
            _startDate?.add(const Duration(days: 1)),
          );
        } else {
          setState(() {});
        }
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
                onSelect: (range) => _onDateChanged(range.start, range.end),
                selected: _startDate == range.start && _endDate == range.end,
              ),
            );
          }),
        ),
      );
      contents.addAll([quickPickTitle, quickPicker]);
    }

    // 自定义
    final Widget customTitle = ListTile(
      visualDensity: visualDensity,
      contentPadding: EdgeInsets.zero,
      title: Text(txLocalizations.customTitle, style: textTheme.bodySmall),
      trailing: IconButton(
        visualDensity: visualDensity,
        onPressed: (_startDate == null && _endDate == null)
            ? null
            : () => _onDateChanged(null, null),
        icon: const Icon(Icons.delete_forever_outlined, size: 20),
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
    final Widget datePicker = DatePicker(
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
      minimumYear: _minimumDate?.year ?? 1,
      initialDateTime: _startNode.hasFocus ? _startDate : _endDate,
    );

    Size size;
    Widget content;
    if (orientation == Orientation.portrait) {
      size = _inputPortraitDialogSize;
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...contents,
          Expanded(child: datePicker),
        ],
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
          Expanded(child: datePicker),
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
