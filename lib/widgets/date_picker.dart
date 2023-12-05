import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';

import '../localizations.dart';
import 'bottom_sheet.dart';

const double _kItemExtent = 48.0;
const bool _kUseMagnifier = true;
const double _kMagnification = 2.35 / 2.1;
const double _kDatePickerPadSize = 12.0;
const double _kSqueeze = 1.25;

const Widget _startSelectionOverlay =
    CupertinoPickerDefaultSelectionOverlay(capEndEdge: false);
const Widget _centerSelectionOverlay = CupertinoPickerDefaultSelectionOverlay(
    capStartEdge: false, capEndEdge: false);
const Widget _endSelectionOverlay =
    CupertinoPickerDefaultSelectionOverlay(capStartEdge: false);

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

typedef _ColumnBuilder = Widget Function(double offAxisFraction,
    TransitionBuilder itemPositioningBuilder, Widget selectionOverlay);

abstract class _CommonPicker extends StatefulWidget {
  _CommonPicker({
    required this.onChanged,
    super.key,
    DateTime? initialDateTime,
    this.minimumDate,
    this.maximumDate,
    int? minimumYear,
    this.maximumYear,
    this.dateOrder,
    this.backgroundColor,
  })  : initialDateTime = initialDateTime ?? DateTime.now(),
        minimumYear = minimumYear ?? 1;

  /// 初始时间
  final DateTime initialDateTime;

  /// 选择器可以选择的最小可选日期。
  final DateTime? minimumDate;

  /// 选择器可以选择的最大可选日期。
  final DateTime? maximumDate;

  /// 选择器可以选择的最小可选年份
  final int minimumYear;

  /// 选择器可以选择的最大可选年份
  final int? maximumYear;

  /// 确定日期模式下[CupertinoDatePicker]内列的顺序。默认为区域设置的默认日期格式顺序。
  final DatePickerDateOrder? dateOrder;

  /// 当所选日期和或时间更改时调用回调。如果新选择的[DateTime]无效，
  /// 或者不在[minimumDate]到[maximumDate]范围内，则不会调用此回调函数。
  final ValueChanged<DateTime> onChanged;

  /// 选择器的背景颜色。
  final Color? backgroundColor;

  @override
  State<StatefulWidget> createState();
}

abstract class _CommonPickerState extends State<_CommonPicker> {
  late DatePickerDateOrder? dateOrder;
  late int textDirectionFactor;
  late CupertinoLocalizations localizations;

  /// 基于文本方向的对齐，当文本方向为rtl时，对齐方式是相反的。
  late Alignment alignCenterLeft;
  late Alignment alignCenterRight;

  /// 列宽
  Map<int, double> estimatedColumnWidths = <int, double>{};

  bool get isCurrentDateValid {
    final bool minCheck = widget.minimumDate?.isBefore(maxSelectDate) ?? true;
    final bool maxCheck = widget.maximumDate?.isBefore(minSelectDate) ?? false;

    return minCheck && !maxCheck;
  }

  DatePickerDateOrder get datePickerDateOrder =>
      dateOrder ?? localizations.datePickerDateOrder;

  /// 选择的最小日期
  DateTime get minSelectDate;

  /// 选择的最大日期
  DateTime get maxSelectDate;

  /// 是否正在滚动
  bool get isScrolling;

  /// 列构造方法
  List<_ColumnBuilder> get pickerBuilders;

  /// 列宽
  List<double> get columnWidths;

  /// 刷新列宽
  void refreshEstimatedColumnWidths();

  /// 滚动到指定日期
  void scrollToDate(DateTime newDate);

  /// 获取月的最后一天
  DateTime lastDayInMonth(int year, int month) => DateTime(year, month + 1, 0);

  // 计算列的最小宽度（近似值）
  double getColumnWidth(
    _PickerColumnType columnType,
    CupertinoLocalizations localizations,
    BuildContext context,
  ) {
    String longestText = '';

    switch (columnType) {
      case _PickerColumnType.date:
        for (int i = 1; i <= 12; i++) {
          final String date =
              localizations.datePickerMediumDate(DateTime(2018, i, 25));
          if (longestText.length < date.length) {
            longestText = date;
          }
        }
        break;
      case _PickerColumnType.hour:
        for (int i = 0; i < 24; i++) {
          final String hour = localizations.datePickerHour(i);
          if (longestText.length < hour.length) {
            longestText = hour;
          }
        }
        break;
      case _PickerColumnType.minute:
        for (int i = 0; i < 60; i++) {
          final String minute = localizations.datePickerMinute(i);
          if (longestText.length < minute.length) {
            longestText = minute;
          }
        }
        break;
      case _PickerColumnType.dayPeriod:
        longestText = localizations.anteMeridiemAbbreviation.length >
                localizations.postMeridiemAbbreviation.length
            ? localizations.anteMeridiemAbbreviation
            : localizations.postMeridiemAbbreviation;
        break;
      case _PickerColumnType.dayOfMonth:
        for (int i = 1; i <= 31; i++) {
          final String dayOfMonth = localizations.datePickerDayOfMonth(i);
          if (longestText.length < dayOfMonth.length) {
            longestText = dayOfMonth;
          }
        }
        break;
      case _PickerColumnType.month:
        for (int i = 1; i <= 12; i++) {
          final String month = localizations.datePickerMonth(i);
          if (longestText.length < month.length) {
            longestText = month;
          }
        }
        break;
      case _PickerColumnType.year:
        longestText = localizations.datePickerYear(2018);
        break;
    }

    assert(longestText != '', 'column type is not appropriate');

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
                CupertinoColors.inactiveGray, context));
  }

  /// 处理系统字体改变
  void _handleSystemFontsChange() {
    setState(refreshEstimatedColumnWidths);
  }

  /// 滚动停止
  void pickerDidStopScrolling() {
    setState(() {});

    if (isScrolling) {
      return;
    }

    final bool minCheck = widget.minimumDate?.isBefore(maxSelectDate) ?? true;
    final bool maxCheck = widget.maximumDate?.isBefore(minSelectDate) ?? false;

    if (!minCheck || maxCheck) {
      final DateTime targetDate =
          minCheck ? widget.maximumDate! : widget.minimumDate!;
      scrollToDate(targetDate);
      return;
    }
  }

  @override
  void initState() {
    dateOrder = widget.dateOrder;
    PaintingBinding.instance.systemFonts.addListener(_handleSystemFontsChange);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    textDirectionFactor =
        Directionality.of(context) == TextDirection.ltr ? 1 : -1;
    localizations = CupertinoLocalizations.of(context);

    alignCenterLeft =
        textDirectionFactor == 1 ? Alignment.centerLeft : Alignment.centerRight;
    alignCenterRight =
        textDirectionFactor == 1 ? Alignment.centerRight : Alignment.centerLeft;

    refreshEstimatedColumnWidths();
  }

  @override
  void dispose() {
    PaintingBinding.instance.systemFonts
        .removeListener(_handleSystemFontsChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pickers = <Widget>[];

    for (int i = 0; i < columnWidths.length; i++) {
      final double offAxisFraction = (i - 1) * 0.3 * textDirectionFactor;

      EdgeInsets padding = const EdgeInsets.only(right: _kDatePickerPadSize);
      if (textDirectionFactor == -1) {
        padding = const EdgeInsets.only(left: _kDatePickerPadSize);
      }

      Widget selectionOverlay = _centerSelectionOverlay;
      if (i == 0) {
        selectionOverlay = _startSelectionOverlay;
      } else if (i == columnWidths.length - 1) {
        selectionOverlay = _endSelectionOverlay;
      }

      pickers.add(LayoutId(
        id: i,
        child: pickerBuilders[i](
          offAxisFraction,
          (BuildContext context, Widget? child) {
            return Container(
              alignment: i == columnWidths.length - 1
                  ? alignCenterLeft
                  : alignCenterRight,
              padding: i == 0 ? null : padding,
              child: Container(
                alignment: i == 0 ? alignCenterLeft : alignCenterRight,
                width: columnWidths[i] + _kDatePickerPadSize,
                child: child,
              ),
            );
          },
          selectionOverlay,
        ),
      ));
    }

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: const TextScaler.linear(1.0),
      ),
      child: DefaultTextStyle.merge(
        style: _kDefaultPickerTextStyle,
        child: CustomMultiChildLayout(
          delegate: _DatePickerLayoutDelegate(
            columnWidths: columnWidths,
            textDirectionFactor: textDirectionFactor,
          ),
          children: pickers,
        ),
      ),
    );
  }
}

/// 选择器列的类型
enum _PickerColumnType {
  // 日期模式中的日列。
  dayOfMonth,
  // 日期模式中的月列。
  month,
  // 日期模式中的年份列
  year,
  // dateAndTime模式中的中间日期列。
  date,
  // 在time和dateAndTime模式下的小时列。
  hour,
  // 在time和dateAndTime模式下的分钟列。
  minute,
  // AM/PM列在时间和日期和时间模式。
  dayPeriod,
}

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

/// @title 日期选择组件
/// @updateTime 2022/11/02 1:41 下午
/// @author 曹骏
class DatePicker extends _CommonPicker {
  DatePicker({
    required super.onChanged,
    super.key,
    super.initialDateTime,
    super.minimumDate,
    super.maximumDate,
    super.minimumYear = 1970,
    super.maximumYear,
    super.backgroundColor,
    super.dateOrder,
  });

  @override
  State<StatefulWidget> createState() => _DatePickerState();
}

class _DatePickerState extends _CommonPickerState {
  // 选择器的当前选定值
  late int selectedDay;
  late int selectedMonth;
  late int selectedYear;

  // 选择器的控制器。在某些情况下，选择器的选定值是无效的(例如2018年2月30日)，这天controller
  // 负责跳转到一个有效值。
  late FixedExtentScrollController dayController;
  late FixedExtentScrollController monthController;
  late FixedExtentScrollController yearController;

  bool isDayPickerScrolling = false;
  bool isMonthPickerScrolling = false;
  bool isYearPickerScrolling = false;

  @override
  List<double> get columnWidths {
    switch (datePickerDateOrder) {
      case DatePickerDateOrder.mdy:
        return <double>[
          estimatedColumnWidths[_PickerColumnType.month.index]!,
          estimatedColumnWidths[_PickerColumnType.dayOfMonth.index]!,
          estimatedColumnWidths[_PickerColumnType.year.index]!,
        ];
      case DatePickerDateOrder.dmy:
        return <double>[
          estimatedColumnWidths[_PickerColumnType.dayOfMonth.index]!,
          estimatedColumnWidths[_PickerColumnType.month.index]!,
          estimatedColumnWidths[_PickerColumnType.year.index]!,
        ];
      case DatePickerDateOrder.ymd:
        return <double>[
          estimatedColumnWidths[_PickerColumnType.year.index]!,
          estimatedColumnWidths[_PickerColumnType.month.index]!,
          estimatedColumnWidths[_PickerColumnType.dayOfMonth.index]!,
        ];
      case DatePickerDateOrder.ydm:
        return <double>[
          estimatedColumnWidths[_PickerColumnType.year.index]!,
          estimatedColumnWidths[_PickerColumnType.dayOfMonth.index]!,
          estimatedColumnWidths[_PickerColumnType.month.index]!,
        ];
    }
  }

  @override
  bool get isScrolling =>
      isDayPickerScrolling || isMonthPickerScrolling || isYearPickerScrolling;

  @override
  DateTime get maxSelectDate =>
      DateTime(selectedYear, selectedMonth, selectedDay + 1);

  @override
  DateTime get minSelectDate =>
      DateTime(selectedYear, selectedMonth, selectedDay);

  @override
  bool get isCurrentDateValid =>
      super.isCurrentDateValid && minSelectDate.day == selectedDay;

  @override
  List<_ColumnBuilder> get pickerBuilders {
    switch (datePickerDateOrder) {
      case DatePickerDateOrder.mdy:
        return <_ColumnBuilder>[
          _buildMonthPicker,
          _buildDayPicker,
          _buildYearPicker
        ];
      case DatePickerDateOrder.dmy:
        return <_ColumnBuilder>[
          _buildDayPicker,
          _buildMonthPicker,
          _buildYearPicker
        ];
      case DatePickerDateOrder.ymd:
        return <_ColumnBuilder>[
          _buildYearPicker,
          _buildMonthPicker,
          _buildDayPicker
        ];
      case DatePickerDateOrder.ydm:
        return <_ColumnBuilder>[
          _buildYearPicker,
          _buildDayPicker,
          _buildMonthPicker
        ];
    }
  }

  Widget _buildDayPicker(double offAxisFraction,
      TransitionBuilder itemPositioningBuilder, Widget selectionOverlay) {
    final int daysInCurrentMonth =
        lastDayInMonth(selectedYear, selectedMonth).day;
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification is ScrollStartNotification) {
          isDayPickerScrolling = true;
        } else if (notification is ScrollEndNotification) {
          isDayPickerScrolling = false;
          pickerDidStopScrolling();
        }

        return false;
      },
      child: CupertinoPicker(
        scrollController: dayController,
        offAxisFraction: offAxisFraction,
        itemExtent: _kItemExtent,
        useMagnifier: _kUseMagnifier,
        magnification: _kMagnification,
        backgroundColor: widget.backgroundColor,
        squeeze: _kSqueeze,
        onSelectedItemChanged: (int index) {
          selectedDay = index + 1;
          if (isCurrentDateValid) {
            widget
                .onChanged(DateTime(selectedYear, selectedMonth, selectedDay));
          }
        },
        looping: true,
        selectionOverlay: selectionOverlay,
        children: List<Widget>.generate(31, (int index) {
          final int day = index + 1;
          return itemPositioningBuilder(
            context,
            Text(
              localizations.datePickerDayOfMonth(day),
              style:
                  themeTextStyle(context, isValid: day <= daysInCurrentMonth),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildMonthPicker(double offAxisFraction,
      TransitionBuilder itemPositioningBuilder, Widget selectionOverlay) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification is ScrollStartNotification) {
          isMonthPickerScrolling = true;
        } else if (notification is ScrollEndNotification) {
          isMonthPickerScrolling = false;
          pickerDidStopScrolling();
        }

        return false;
      },
      child: CupertinoPicker(
        scrollController: monthController,
        offAxisFraction: offAxisFraction,
        itemExtent: _kItemExtent,
        useMagnifier: _kUseMagnifier,
        magnification: _kMagnification,
        backgroundColor: widget.backgroundColor,
        squeeze: _kSqueeze,
        onSelectedItemChanged: (int index) {
          selectedMonth = index + 1;
          if (isCurrentDateValid) {
            widget
                .onChanged(DateTime(selectedYear, selectedMonth, selectedDay));
          }
        },
        looping: true,
        selectionOverlay: selectionOverlay,
        children: List<Widget>.generate(12, (int index) {
          final int month = index + 1;
          final bool isInvalidMonth =
              (widget.minimumDate?.year == selectedYear &&
                      widget.minimumDate!.month > month) ||
                  (widget.maximumDate?.year == selectedYear &&
                      widget.maximumDate!.month < month);

          return itemPositioningBuilder(
            context,
            Text(
              localizations.datePickerMonth(month),
              style: themeTextStyle(context, isValid: !isInvalidMonth),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildYearPicker(double offAxisFraction,
      TransitionBuilder itemPositioningBuilder, Widget selectionOverlay) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification is ScrollStartNotification) {
          isYearPickerScrolling = true;
        } else if (notification is ScrollEndNotification) {
          isYearPickerScrolling = false;
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
          if (isCurrentDateValid) {
            widget
                .onChanged(DateTime(selectedYear, selectedMonth, selectedDay));
          }
        },
        itemBuilder: (BuildContext context, int year) {
          if (year < widget.minimumYear) {
            return null;
          }

          if (widget.maximumYear != null && year > widget.maximumYear!) {
            return null;
          }

          final bool isValidYear = (widget.minimumDate == null ||
                  widget.minimumDate!.year <= year) &&
              (widget.maximumDate == null || widget.maximumDate!.year >= year);

          return itemPositioningBuilder(
            context,
            Text(
              localizations.datePickerYear(year),
              style: themeTextStyle(context, isValid: isValidYear),
            ),
          );
        },
        selectionOverlay: selectionOverlay,
      ),
    );
  }

  @override
  void refreshEstimatedColumnWidths() {
    estimatedColumnWidths[_PickerColumnType.dayOfMonth.index] =
        getColumnWidth(_PickerColumnType.dayOfMonth, localizations, context);
    estimatedColumnWidths[_PickerColumnType.month.index] =
        getColumnWidth(_PickerColumnType.month, localizations, context);
    estimatedColumnWidths[_PickerColumnType.year.index] =
        getColumnWidth(_PickerColumnType.year, localizations, context);
  }

  @override
  void scrollToDate(DateTime newDate) {
    SchedulerBinding.instance.addPostFrameCallback((Duration timestamp) {
      if (selectedYear != newDate.year) {
        _animateColumnControllerToItem(yearController, newDate.year);
      }

      if (selectedMonth != newDate.month) {
        _animateColumnControllerToItem(monthController, newDate.month - 1);
      }

      if (selectedDay != newDate.day) {
        _animateColumnControllerToItem(dayController, newDate.day - 1);
      }
    });
  }

  @override
  void pickerDidStopScrolling() {
    super.pickerDidStopScrolling();
    if (minSelectDate.day != selectedDay) {
      final DateTime lastDay = lastDayInMonth(selectedYear, selectedMonth);
      scrollToDate(lastDay);
    }
  }

  @override
  void didUpdateWidget(covariant _CommonPicker oldWidget) {
    scrollToDate(widget.initialDateTime);
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    selectedDay = widget.initialDateTime.day;
    selectedMonth = widget.initialDateTime.month;
    selectedYear = widget.initialDateTime.year;

    dayController = FixedExtentScrollController(initialItem: selectedDay - 1);
    monthController =
        FixedExtentScrollController(initialItem: selectedMonth - 1);
    yearController = FixedExtentScrollController(initialItem: selectedYear);
    super.initState();
  }
}

/// @title 月份选择组件
/// @updateTime 2022/11/01 4:09 下午
/// @author 曹骏
class MonthPicker extends _CommonPicker {
  MonthPicker({
    required super.onChanged,
    super.key,
    super.initialDateTime,
    super.minimumDate,
    super.maximumDate,
    super.minimumYear = 1970,
    super.maximumYear,
    super.backgroundColor,
    super.dateOrder,
  });

  @override
  State<StatefulWidget> createState() => _MonthPickerState();
}

class _MonthPickerState extends _CommonPickerState {
  // 选择器当前选择的值
  late int selectedMonth;
  late int selectedYear;

  // 选择器的控制器。在某些情况下，选择器的选定值是无效的(例如2018年2月30日)，这天
  // controller负责跳转到一个有效值。
  late FixedExtentScrollController monthController;
  late FixedExtentScrollController yearController;

  bool isMonthPickerScrolling = false;
  bool isYearPickerScrolling = false;

  @override
  bool get isScrolling => isMonthPickerScrolling || isYearPickerScrolling;

  Widget _buildMonthPicker(double offAxisFraction,
      TransitionBuilder itemPositioningBuilder, Widget selectionOverlay) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification is ScrollStartNotification) {
          isMonthPickerScrolling = true;
        } else if (notification is ScrollEndNotification) {
          isMonthPickerScrolling = false;
          pickerDidStopScrolling();
        }

        return false;
      },
      child: CupertinoPicker(
        scrollController: monthController,
        offAxisFraction: offAxisFraction,
        itemExtent: _kItemExtent,
        useMagnifier: _kUseMagnifier,
        magnification: _kMagnification,
        backgroundColor: widget.backgroundColor,
        squeeze: _kSqueeze,
        onSelectedItemChanged: (int index) {
          selectedMonth = index + 1;
          if (isCurrentDateValid) {
            widget.onChanged(DateTime(selectedYear, selectedMonth));
          }
        },
        looping: true,
        selectionOverlay: selectionOverlay,
        children: List<Widget>.generate(12, (int index) {
          final int month = index + 1;
          final bool isInvalidMonth =
              (widget.minimumDate?.year == selectedYear &&
                      widget.minimumDate!.month > month) ||
                  (widget.maximumDate?.year == selectedYear &&
                      widget.maximumDate!.month < month);

          return itemPositioningBuilder(
            context,
            Text(
              localizations.datePickerMonth(month),
              style: themeTextStyle(context, isValid: !isInvalidMonth),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildYearPicker(double offAxisFraction,
      TransitionBuilder itemPositioningBuilder, Widget selectionOverlay) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification is ScrollStartNotification) {
          isYearPickerScrolling = true;
        } else if (notification is ScrollEndNotification) {
          isYearPickerScrolling = false;
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
          if (isCurrentDateValid) {
            widget.onChanged(DateTime(selectedYear, selectedMonth));
          }
        },
        itemBuilder: (BuildContext context, int year) {
          if (year < widget.minimumYear) {
            return null;
          }

          if (widget.maximumYear != null && year > widget.maximumYear!) {
            return null;
          }

          final bool isValidYear = (widget.minimumDate == null ||
                  widget.minimumDate!.year <= year) &&
              (widget.maximumDate == null || widget.maximumDate!.year >= year);

          return itemPositioningBuilder(
            context,
            Text(
              localizations.datePickerYear(year),
              style: themeTextStyle(context, isValid: isValidYear),
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
    selectedMonth = widget.initialDateTime.month;
    selectedYear = widget.initialDateTime.year;

    monthController =
        FixedExtentScrollController(initialItem: selectedMonth - 1);
    yearController = FixedExtentScrollController(initialItem: selectedYear);
  }

  @override
  void didUpdateWidget(covariant _CommonPicker oldWidget) {
    scrollToDate(widget.initialDateTime);
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    monthController.dispose();
    yearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<_ColumnBuilder> pickerBuilders = <_ColumnBuilder>[];
    List<double> columnWidths = <double>[];

    pickerBuilders = <_ColumnBuilder>[_buildYearPicker, _buildMonthPicker];
    columnWidths = <double>[
      estimatedColumnWidths[_PickerColumnType.year.index]!,
      estimatedColumnWidths[_PickerColumnType.month.index]!,
    ];

    final List<Widget> pickers = <Widget>[];

    for (int i = 0; i < columnWidths.length; i++) {
      final double offAxisFraction = (i - 1) * 0.3 * textDirectionFactor;

      EdgeInsets padding = const EdgeInsets.only(right: _kDatePickerPadSize);
      if (textDirectionFactor == -1) {
        padding = const EdgeInsets.only(left: _kDatePickerPadSize);
      }

      Widget selectionOverlay = _centerSelectionOverlay;
      if (i == 0) {
        selectionOverlay = _startSelectionOverlay;
      } else if (i == columnWidths.length - 1) {
        selectionOverlay = _endSelectionOverlay;
      }

      pickers.add(LayoutId(
        id: i,
        child: pickerBuilders[i](
          offAxisFraction,
          (BuildContext context, Widget? child) {
            return Container(
              alignment: i == columnWidths.length - 1
                  ? alignCenterLeft
                  : alignCenterRight,
              padding: i == 0 ? null : padding,
              child: Container(
                alignment: i == 0 ? alignCenterLeft : alignCenterRight,
                width: columnWidths[i] + _kDatePickerPadSize,
                child: child,
              ),
            );
          },
          selectionOverlay,
        ),
      ));
    }

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: const TextScaler.linear(1.0),
      ),
      child: DefaultTextStyle.merge(
        style: _kDefaultPickerTextStyle,
        child: CustomMultiChildLayout(
          delegate: _DatePickerLayoutDelegate(
            columnWidths: columnWidths,
            textDirectionFactor: textDirectionFactor,
          ),
          children: pickers,
        ),
      ),
    );
  }

  @override
  List<double> get columnWidths {
    switch (datePickerDateOrder) {
      case DatePickerDateOrder.mdy:
      case DatePickerDateOrder.dmy:
        return <double>[
          estimatedColumnWidths[_PickerColumnType.month.index]!,
          estimatedColumnWidths[_PickerColumnType.year.index]!,
        ];
      case DatePickerDateOrder.ymd:
      case DatePickerDateOrder.ydm:
        return <double>[
          estimatedColumnWidths[_PickerColumnType.year.index]!,
          estimatedColumnWidths[_PickerColumnType.month.index]!,
        ];
    }
  }

  @override
  DateTime get maxSelectDate => DateTime(selectedYear, selectedMonth, 2);

  @override
  DateTime get minSelectDate => DateTime(selectedYear, selectedMonth);

  @override
  List<_ColumnBuilder> get pickerBuilders {
    switch (datePickerDateOrder) {
      case DatePickerDateOrder.mdy:
      case DatePickerDateOrder.dmy:
        return <_ColumnBuilder>[_buildMonthPicker, _buildYearPicker];
      case DatePickerDateOrder.ymd:
      case DatePickerDateOrder.ydm:
        return <_ColumnBuilder>[
          _buildYearPicker,
          _buildMonthPicker,
        ];
    }
  }

  @override
  void refreshEstimatedColumnWidths() {
    estimatedColumnWidths[_PickerColumnType.month.index] =
        getColumnWidth(_PickerColumnType.month, localizations, context);
    estimatedColumnWidths[_PickerColumnType.year.index] =
        getColumnWidth(_PickerColumnType.year, localizations, context);
  }

  @override
  void scrollToDate(DateTime newDate) {
    SchedulerBinding.instance.addPostFrameCallback((Duration timestamp) {
      if (selectedYear != newDate.year) {
        _animateColumnControllerToItem(yearController, newDate.year);
      }

      if (selectedMonth != newDate.month) {
        _animateColumnControllerToItem(monthController, newDate.month - 1);
      }
    });
  }
}

/// @title 年份选择组件
/// @updateTime 2022/11/01 4:09 下午
/// @author 曹骏
class YearPicker extends _CommonPicker {
  YearPicker({
    required super.onChanged,
    super.key,
    super.initialDateTime,
    super.minimumYear = 1970,
    super.maximumYear,
    super.backgroundColor,
  });

  @override
  State<StatefulWidget> createState() => _YearPickerState();
}

class _YearPickerState extends _CommonPickerState {
  // 选择器当前选择的值
  late int selectedYear;

  // 选择器的控制器。在某些情况下，选择器的选定值是无效的(例如2018年2月30日)，这天
  // controller负责跳转到一个有效值。
  late FixedExtentScrollController yearController;

  bool isYearPickerScrolling = false;

  @override
  bool get isScrolling => isYearPickerScrolling;

  Widget _buildYearPicker(double offAxisFraction,
      TransitionBuilder itemPositioningBuilder, Widget selectionOverlay) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification is ScrollStartNotification) {
          isYearPickerScrolling = true;
        } else if (notification is ScrollEndNotification) {
          isYearPickerScrolling = false;
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
          if (isCurrentDateValid) {
            widget.onChanged(DateTime(selectedYear));
          }
        },
        itemBuilder: (BuildContext context, int year) {
          if (year < widget.minimumYear) {
            return null;
          }

          if (widget.maximumYear != null && year > widget.maximumYear!) {
            return null;
          }

          final bool isValidYear = (widget.minimumDate == null ||
                  widget.minimumDate!.year <= year) &&
              (widget.maximumDate == null || widget.maximumDate!.year >= year);

          return itemPositioningBuilder(
            context,
            Text(
              localizations.datePickerYear(year),
              style: themeTextStyle(context, isValid: isValidYear),
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
    selectedYear = widget.initialDateTime.year;

    yearController = FixedExtentScrollController(initialItem: selectedYear);
  }

  @override
  void didUpdateWidget(covariant _CommonPicker oldWidget) {
    scrollToDate(widget.initialDateTime);
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    yearController.dispose();
    super.dispose();
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
            columnWidths: columnWidths,
            textDirectionFactor: textDirectionFactor,
          ),
          children: pickers,
        ),
      ),
    );
  }

  @override
  List<double> get columnWidths =>
      [estimatedColumnWidths[_PickerColumnType.year.index]!];

  @override
  DateTime get maxSelectDate => DateTime(selectedYear);

  @override
  DateTime get minSelectDate => DateTime(selectedYear);

  @override
  List<_ColumnBuilder> get pickerBuilders => [_buildYearPicker];

  @override
  void refreshEstimatedColumnWidths() {
    estimatedColumnWidths[_PickerColumnType.year.index] =
        getColumnWidth(_PickerColumnType.year, localizations, context);
  }

  @override
  void scrollToDate(DateTime newDate) {
    SchedulerBinding.instance.addPostFrameCallback((Duration timestamp) {
      if (selectedYear != newDate.year) {
        _animateColumnControllerToItem(yearController, newDate.year);
      }
    });
  }
}

/// 显示月份选择器
Future<DateTime?> showMonthPicker(
  BuildContext context, {
  String? titleText,
  DateTime? initialDateTime,
  DateTime? minimumDate,
  DateTime? maximumDate,
  int minimumYear = 1970,
  int? maximumYear,
  Color? backgroundColor,
  DatePickerDateOrder? dateOrder,
}) async {
  DateTime? result;
  return await showDefaultBottomSheet(
    context,
    title: titleText ?? TxLocalizations.of(context).monthPickerTitle,
    content: MonthPicker(
      onChanged: (month) => result = month,
      initialDateTime: initialDateTime,
      minimumDate: minimumDate,
      maximumDate: maximumDate,
      minimumYear: minimumYear,
      maximumYear: maximumYear,
      backgroundColor: backgroundColor,
      dateOrder: dateOrder,
    ),
    onConfirm: () => Navigator.pop(context, result),
  );
}

/// 显示年份选择器
Future<DateTime?> showYearPicker(
  BuildContext context, {
  String? titleText,
  DateTime? initialDateTime,
  int minimumYear = 1970,
  int? maximumYear,
  Color? backgroundColor,
}) async {
  DateTime? result;
  return await showDefaultBottomSheet(
    context,
    title: titleText ?? TxLocalizations.of(context).yearPickerTitle,
    content: YearPicker(
      onChanged: (month) => result = month,
      initialDateTime: initialDateTime,
      minimumYear: minimumYear,
      maximumYear: maximumYear,
      backgroundColor: backgroundColor,
    ),
    onConfirm: () => Navigator.pop(context, result),
  );
}

/// 显示时间选择器
Future<DateTime?> showDatetimePicker(
  BuildContext context, {
  String? titleText,
  DateTime? initialDateTime,
  DateTime? minimumDate,
  DateTime? maximumDate,
  int minimumYear = 1970,
  int? maximumYear,
  Color? backgroundColor,
  DatePickerDateOrder? dateOrder,
}) async {
  DateTime? result;
  return await showDefaultBottomSheet(
    context,
    title: titleText ?? TxLocalizations.of(context).datetimePickerTitle,
    content: CupertinoDatePicker(
      mode: CupertinoDatePickerMode.dateAndTime,
      initialDateTime: initialDateTime,
      minimumDate: minimumDate,
      maximumDate: maximumDate,
      minimumYear: minimumYear,
      maximumYear: maximumYear,
      backgroundColor: backgroundColor,
      dateOrder: dateOrder,
      onDateTimeChanged: (DateTime datetime) => result = datetime,
      use24hFormat: true,
    ),
    onConfirm: () => Navigator.pop(context, result),
  );
}
