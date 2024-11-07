import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../extensions/time_of_day_extension.dart';
import '../localizations.dart';
import 'bottom_sheet.dart';

const double _kItemExtent = 48.0;
const bool _kUseMagnifier = true;
const double _kMagnification = 2.35 / 2.1;
const double _kDatePickerPadSize = 12.0;

void _animateColumnControllerToItem(
    FixedExtentScrollController controller, int targetItem) {
  controller.animateToItem(
    targetItem,
    curve: Curves.easeInOut,
    duration: const Duration(milliseconds: 200),
  );
}

const TextStyle _kDefaultPickerTextStyle = TextStyle(
  letterSpacing: -0.83,
);

typedef _ColumnBuilder = Widget Function(
  double offAxisFraction,
  TransitionBuilder itemPositioningBuilder,
  Widget selectionOverlay,
);

/// 根据每一列所需的空间布局日期选择器
class _DatePickerLayoutDelegate extends MultiChildLayoutDelegate {
  _DatePickerLayoutDelegate({
    required this.columnWidths,
    required this.textDirectionFactor,
  });

  // 包含所有列宽度的列表
  final List<double> columnWidths;

  // 如果文本从左向右写，textDirectionFactor为1，如果从右向左写，则为-1。
  final int textDirectionFactor;

  @override
  void performLayout(Size size) {
    double remainingWidth = size.width;

    for (int i = 0; i < columnWidths.length; i++) {
      remainingWidth -= columnWidths[i] + _kDatePickerPadSize * 2;
    }

    double currentHorizontalOffset = 0.0;

    for (int i = 0; i < columnWidths.length; i++) {
      final int index =
          textDirectionFactor == 1 ? i : columnWidths.length - i - 1;

      double childWidth = columnWidths[index] + _kDatePickerPadSize * 2;
      if (columnWidths.length == 1) {
        childWidth += remainingWidth;
      } else if (index == 0 || index == columnWidths.length - 1) {
        childWidth += remainingWidth / 2;
      }

      assert(() {
        if (childWidth < 0) {
          FlutterError.reportError(
            FlutterErrorDetails(
              exception: FlutterError(
                'Insufficient horizontal space to render the '
                'CupertinoDatePicker because the parent is too narrow at '
                '${size.width}px.\n'
                'An additional ${-remainingWidth}px is needed to avoid '
                'overlapping columns.',
              ),
            ),
          );
        }
        return true;
      }());
      layoutChild(index,
          BoxConstraints.tight(Size(math.max(0.0, childWidth), size.height)));
      positionChild(index, Offset(currentHorizontalOffset, 0.0));

      currentHorizontalOffset += childWidth;
    }
  }

  @override
  bool shouldRelayout(_DatePickerLayoutDelegate oldDelegate) {
    return columnWidths != oldDelegate.columnWidths ||
        textDirectionFactor != oldDelegate.textDirectionFactor;
  }
}

class YearPicker extends StatefulWidget {
  const YearPicker({
    required this.onChanged,
    super.key,
    this.initialYear,
    this.minimumYear,
    this.maximumYear,
    this.backgroundColor,
  });

  /// 初始年份
  final int? initialYear;

  /// 选择器可以选择的最小可选年份
  final int? minimumYear;

  /// 选择器可以选择的最大可选年份
  final int? maximumYear;

  /// 年份变更回调
  final ValueChanged<int> onChanged;

  /// 选择器的背景颜色。
  final Color? backgroundColor;

  @override
  State<StatefulWidget> createState() => _YearPickerState();
}

class _YearPickerState extends State<YearPicker> {
  // 选择器当前选择的值
  late int selectedYear;

  // 选择器的控制器。在某些情况下，选择器的选定值是无效的(例如2018年2月30日)，这天
  // controller负责跳转到一个有效值。
  late FixedExtentScrollController yearController;

  bool isScrolling = false;

  bool get minCheck =>
      widget.minimumYear == null ? true : widget.minimumYear! <= selectedYear;

  bool get maxCheck =>
      widget.maximumYear == null ? true : widget.maximumYear! >= selectedYear;

  bool get isCurrentYearValid => minCheck && !maxCheck;

  Widget _buildYearPicker(
    double offAxisFraction,
    TransitionBuilder itemPositioningBuilder,
    Widget selectionOverlay,
  ) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification is ScrollStartNotification) {
          isScrolling = true;
        } else if (notification is ScrollEndNotification) {
          isScrolling = false;
          pickerDidStopScrolling();
        }

        return false;
      },
      child: CupertinoPicker.builder(
        scrollController: yearController,
        itemExtent: _kItemExtent,
        offAxisFraction: offAxisFraction,
        useMagnifier: _kUseMagnifier,
        magnification: _kMagnification,
        backgroundColor: widget.backgroundColor,
        onSelectedItemChanged: (int index) {
          selectedYear = index;
          if (isCurrentYearValid) {
            widget.onChanged(selectedYear);
          }
        },
        itemBuilder: (BuildContext context, int year) {
          if (widget.minimumYear != null && year < widget.minimumYear!) {
            return null;
          }

          if (widget.maximumYear != null && year > widget.maximumYear!) {
            return null;
          }

          return itemPositioningBuilder(
            context,
            Text(
              localizations.datePickerYear(year),
              style: themeTextStyle(context),
            ),
          );
        },
        selectionOverlay: selectionOverlay,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    selectedYear = widget.initialYear ?? DateTime.now().year;

    yearController = FixedExtentScrollController(initialItem: selectedYear);
  }

  @override
  void didUpdateWidget(covariant YearPicker oldWidget) {
    if (widget.initialYear != selectedYear) {
      selectedYear = widget.initialYear ?? DateTime.now().year;
      scrollToYear(selectedYear);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final _ColumnBuilder pickerBuilder = _buildYearPicker;

    final List<Widget> pickers = <Widget>[];

    const Widget selectionOverlay = CupertinoPickerDefaultSelectionOverlay();

    pickers.add(LayoutId(
      id: 0,
      child: pickerBuilder(
        0,
        (BuildContext context, Widget? child) => Center(child: child),
        selectionOverlay,
      ),
    ));

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: const TextScaler.linear(1.0),
      ),
      child: DefaultTextStyle.merge(
        style: _kDefaultPickerTextStyle,
        child: CustomMultiChildLayout(
          delegate: _DatePickerLayoutDelegate(
            columnWidths: [_columnWidth],
            textDirectionFactor: textDirectionFactor,
          ),
          children: pickers,
        ),
      ),
    );
  }

  void scrollToYear(int newYear) {
    SchedulerBinding.instance.addPostFrameCallback((Duration timestamp) {
      if (selectedYear != newYear) {
        _animateColumnControllerToItem(yearController, newYear);
      }
    });
  }

  /// 滚动停止
  void pickerDidStopScrolling() {
    setState(() {});

    if (isScrolling) {
      return;
    }

    final bool minCheck = this.minCheck;
    final bool maxCheck = this.maxCheck;
    if (!minCheck || !maxCheck) {
      final int targetYear =
          minCheck ? widget.maximumYear! : widget.minimumYear!;
      scrollToYear(targetYear);
      return;
    }
  }

  late int textDirectionFactor;
  late CupertinoLocalizations localizations;

  /// 列宽
  Map<int, double> estimatedColumnWidths = <int, double>{};

  // 计算列的最小宽度（近似值）
  double get _columnWidth {
    final longestText = localizations.datePickerYear(selectedYear);

    final TextPainter painter = TextPainter(
      text: TextSpan(
        style: themeTextStyle(context),
        text: longestText,
      ),
      textDirection: Directionality.of(context),
    );

    painter.layout();

    return painter.maxIntrinsicWidth;
  }

  /// 文字样式
  TextStyle themeTextStyle(BuildContext context, {bool isValid = true}) {
    final TextStyle style =
        CupertinoTheme.of(context).textTheme.dateTimePickerTextStyle;
    return isValid
        ? style.copyWith(
            color: CupertinoDynamicColor.maybeResolve(style.color, context))
        : style.copyWith(
            color: CupertinoDynamicColor.resolve(
                CupertinoColors.inactiveGray, context),
          );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    textDirectionFactor =
        Directionality.of(context) == TextDirection.ltr ? 1 : -1;
    localizations = CupertinoLocalizations.of(context);
  }

  @override
  void dispose() {
    yearController.dispose();
    super.dispose();
  }
}

/// 显示 iOS 风格的年份选择器
Future<int?> showCupertinoYearPicker(
  BuildContext context, {
  String? titleText,
  int? initialYear,
  int? minimumYear,
  int? maximumYear,
  Color? backgroundColor,
}) async {
  int? result = initialYear ?? DateTime.now().year;
  return await showDefaultBottomSheet(
    context,
    title: titleText ?? TxLocalizations.of(context).yearPickerTitle,
    contentBuilder: (context) => YearPicker(
      onChanged: (year) => result = year,
      initialYear: initialYear,
      minimumYear: minimumYear,
      maximumYear: maximumYear,
      backgroundColor: backgroundColor,
    ),
    onConfirm: () => Navigator.pop(context, result),
  );
}

/// 显示 iOS 风格的月份选择器
Future<DateTime?> showCupertinoMonthPicker(
  BuildContext context, {
  String? titleText,
  DateTime? initialMonth,
  DateTime? minimumMonth,
  DateTime? maximumMonth,
  int? minimumYear,
  int? maximumYear,
  Color? backgroundColor,
  DatePickerDateOrder? dateOrder,
}) async {
  return await _showCupertinoDatetimePicker(
    context,
    mode: CupertinoDatePickerMode.monthYear,
    titleText: titleText ?? TxLocalizations.of(context).monthPickerTitle,
    initialDateTime: initialMonth,
    minimumDate: minimumMonth,
    maximumDate: maximumMonth,
    minimumYear: minimumYear,
    maximumYear: maximumYear,
    backgroundColor: backgroundColor,
    dateOrder: dateOrder,
  );
}

/// 显示 iOS 风格的日期时间选择器
Future<DateTime?> showCupertinoDatetimePicker(
  BuildContext context, {
  String? titleText,
  DateTime? initialDateTime,
  DateTime? minimumDate,
  DateTime? maximumDate,
  int? minimumYear,
  int? maximumYear,
  Color? backgroundColor,
  DatePickerDateOrder? dateOrder,
}) async {
  return await _showCupertinoDatetimePicker(
    context,
    mode: CupertinoDatePickerMode.dateAndTime,
    titleText: titleText ?? TxLocalizations.of(context).datetimePickerTitle,
    initialDateTime: initialDateTime,
    minimumDate: minimumDate,
    maximumDate: maximumDate,
    minimumYear: minimumYear,
    maximumYear: maximumYear,
    backgroundColor: backgroundColor,
    dateOrder: dateOrder,
  );
}

/// 显示 iOS 风格的日期选择器
Future<DateTime?> showCupertinoDatePicker(
  BuildContext context, {
  String? titleText,
  DateTime? initialDate,
  DateTime? minimumDate,
  DateTime? maximumDate,
  int? minimumYear,
  int? maximumYear,
  Color? backgroundColor,
  DatePickerDateOrder? dateOrder,
}) async {
  return _showCupertinoDatetimePicker(
    context,
    mode: CupertinoDatePickerMode.date,
    titleText: titleText ?? TxLocalizations.of(context).datePickerTitle,
    initialDateTime: initialDate,
    minimumDate: minimumDate,
    maximumDate: maximumDate,
    minimumYear: minimumYear,
    maximumYear: maximumYear,
    backgroundColor: backgroundColor,
    dateOrder: dateOrder,
  );
}

/// 显示 iOS 风格的事件选择器
Future<TimeOfDay?> showCupertinoTimePicker(
  BuildContext context, {
  String? titleText,
  TimeOfDay? initialTime,
  TimeOfDay? minimumTime,
  TimeOfDay? maximumTime,
  Color? backgroundColor,
}) async {
  minimumTime ??= const TimeOfDay(hour: 0, minute: 0);
  maximumTime ??= const TimeOfDay(hour: 23, minute: 59);
  final DateTime? time = await _showCupertinoDatetimePicker(
    context,
    titleText: titleText ?? TxLocalizations.of(context).timePickerTitle,
    mode: CupertinoDatePickerMode.time,
    initialDateTime: initialTime?.toDateTime(),
    minimumDate: minimumTime.toDateTime(),
    maximumDate: maximumTime.toDateTime(),
    backgroundColor: backgroundColor,
  );
  return time == null ? null : TimeOfDay.fromDateTime(time);
}

/// 显示 iOS 风格的日期选择器
Future<DateTime?> _showCupertinoDatetimePicker(
  BuildContext context, {
  required CupertinoDatePickerMode mode,
  required String titleText,
  DateTime? initialDateTime,
  DateTime? minimumDate,
  DateTime? maximumDate,
  int? minimumYear,
  int? maximumYear,
  Color? backgroundColor,
  DatePickerDateOrder? dateOrder,
}) async {
  DateTime? result = initialDateTime ?? DateTime.now();
  if (minimumDate != null && result.isBefore(minimumDate)) {
    result = minimumDate;
  }

  if (maximumDate != null && result.isAfter(maximumDate)) {
    result = maximumDate;
  }

  return await showDefaultBottomSheet<DateTime>(
    context,
    title: titleText,
    contentBuilder: (context) => CupertinoDatePicker(
      mode: mode,
      initialDateTime: result,
      minimumDate: minimumDate,
      maximumDate: maximumDate,
      minimumYear:
          minimumYear ?? (minimumDate == null ? 1970 : minimumDate.year),
      maximumYear: maximumYear,
      backgroundColor: backgroundColor,
      dateOrder: dateOrder,
      onDateTimeChanged: (DateTime datetime) => result = datetime,
      use24hFormat: true,
    ),
    onConfirm: () => Navigator.pop(context, result),
  );
}
