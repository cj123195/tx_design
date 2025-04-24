import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../extensions/time_of_day_extension.dart';
import '../localizations.dart';
import 'bottom_sheet.dart';

// Values derived from https://developer.apple.com/design/resources/ and on iOS
// simulators with "Debug View Hierarchy".
const double _kItemExtent = 48.0;
const double _kPickerWidth = 320.0;
const bool _kUseMagnifier = true;
const double _kMagnification = 2.35 / 2.1;
const double _kDatePickerPadSize = 12.0;
const double _kDiameterRatio = math.pi;
// The density of a date picker is different from a generic picker.
// Eyeballed from iOS.
const double _kSqueeze = 1.25;

const TextStyle _kDefaultPickerTextStyle = TextStyle(
  letterSpacing: -0.83,
);

void _animateColumnControllerToItem(
    FixedExtentScrollController controller, int targetItem) {
  controller.animateToItem(
    targetItem,
    curve: Curves.easeInOut,
    duration: const Duration(milliseconds: 200),
  );
}

const Widget _startSelectionOverlay = DecoratedBox(
  decoration: BoxDecoration(
    border: Border.symmetric(
      horizontal: BorderSide(color: CupertinoColors.tertiarySystemFill),
    ),
  ),
);
const Widget _centerSelectionOverlay = DecoratedBox(
  decoration: BoxDecoration(
    border: Border.symmetric(
      horizontal: BorderSide(color: CupertinoColors.tertiarySystemFill),
    ),
  ),
);
const Widget _endSelectionOverlay = DecoratedBox(
  decoration: BoxDecoration(
    border: Border.symmetric(
      horizontal: BorderSide(color: CupertinoColors.tertiarySystemFill),
    ),
  ),
);

typedef _ColumnBuilder = Widget Function(
  double offAxisFraction,
  TransitionBuilder itemPositioningBuilder,
  Widget selectionOverlay,
);

// Different types of column in CupertinoDatePicker.
enum _PickerColumnType {
  // Day of month column in date mode.
  dayOfMonth,
  // Month column in date mode.
  month,
  // Year column in date mode.
  year,
  // Medium date column in dateAndTime mode.
  date,
  // Hour column in time and dateAndTime mode.
  hour,
  // minute column in time and dateAndTime mode.
  minute,
  // AM/PM column in time and dateAndTime mode.
  dayPeriod,
}

/// 根据每一列所需的空间布局日期选择器
class _DatePickerLayoutDelegate extends MultiChildLayoutDelegate {
  _DatePickerLayoutDelegate({
    required this.columnWidths,
    required this.textDirectionFactor,
    required this.maxWidth,
  });

  // The list containing widths of all columns.
  final List<double> columnWidths;

  // textDirectionFactor is 1 if text is written left to right, and -1 if right
  // to left.
  final int textDirectionFactor;

  // The max width the children should reach to avoid bending outwards.
  final double maxWidth;

  @override
  void performLayout(Size size) {
    double remainingWidth = maxWidth < size.width ? maxWidth : size.width;

    double currentHorizontalOffset = (size.width - remainingWidth) / 2;

    for (int i = 0; i < columnWidths.length; i++) {
      remainingWidth -= columnWidths[i] + _kDatePickerPadSize * 2;
    }

    for (int i = 0; i < columnWidths.length; i++) {
      final int index =
          textDirectionFactor == 1 ? i : columnWidths.length - i - 1;

      double childWidth = columnWidths[index] + _kDatePickerPadSize * 2;
      if (index == 0 || index == columnWidths.length - 1) {
        childWidth += remainingWidth / 2;
      }

      // We can't actually assert here because it would break things badly for
      // semantics, which will expect that we laid things out here.
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

/// 布局年份选择器
class _YearPickerLayoutDelegate extends MultiChildLayoutDelegate {
  _YearPickerLayoutDelegate();

  @override
  void performLayout(Size size) {
    final double childWidth = size.width - _kDatePickerPadSize * 2;
    assert(() {
      if (childWidth < 0) {
        FlutterError.reportError(
          FlutterErrorDetails(
            exception: FlutterError(
              'Insufficient horizontal space to render the '
              'CupertinoDatePicker because the parent is too narrow at '
              '${size.width}px.\n'
              'An additional ${-childWidth}px is needed to avoid '
              'overlapping columns.',
            ),
          ),
        );
      }
      return true;
    }());
    layoutChild(
        0, BoxConstraints.tight(Size(math.max(0.0, childWidth), size.height)));
    positionChild(0, const Offset(_kDatePickerPadSize, 0.0));
  }

  @override
  bool shouldRelayout(_YearPickerLayoutDelegate oldDelegate) => false;
}

abstract class TxCupertinoPicker extends StatefulWidget {
  /// Constructs an iOS style date picker.
  TxCupertinoPicker({
    required this.onChanged,
    this.minimumValue,
    this.maximumValue,
    super.key,
    this.backgroundColor,
    double? itemExtent = _kItemExtent,
    bool? useMagnifier = _kUseMagnifier,
    double? magnification = _kMagnification,
    double? squeeze = _kSqueeze,
    double? diameterRatio = _kDiameterRatio,
    this.textStyle,
    this.unselectedTextStyle,
    this.unselectedColor,
    this.initialValue,
  })  : itemExtent = itemExtent ?? _kItemExtent,
        useMagnifier = useMagnifier ?? _kUseMagnifier,
        magnification = magnification ?? _kMagnification,
        squeeze = squeeze ?? _kSqueeze,
        diameterRatio = diameterRatio ?? _kDiameterRatio {
    {
      assert(
        minimumValue == null ||
            maximumValue == null ||
            minimumValue!.isBefore(maximumValue!),
        'minimumValue must before than maximumValue',
      );
      assert(
        this.itemExtent > 0,
        'item extent should be greater than 0',
      );
    }
  }

  /// The initial date and/or time of the picker. Defaults to the present date
  /// and time. The present must conform to the intervals set in [minimumValue],
  /// [maximumValue].
  ///
  /// Changing this value after the initial build will not affect the currently
  /// selected date time.
  final DateTime? initialValue;

  /// The minimum selectable date that the picker can settle on.
  ///
  /// When non-null, the user can still scroll the picker to [DateTime]s earlier
  /// than [minimumValue], but the [onChanged] will not be called on
  /// these [DateTime]s. Once let go, the picker will scroll back to
  /// [minimumValue].
  ///
  /// In [CupertinoDatePickerMode.time] mode, a time becomes unselectable if the
  /// [DateTime] produced by combining that particular time and the date part of
  /// [initialValue] is earlier than [minimumValue]. So typically [minimumValue]
  /// needs to be set to a [DateTime] that is on the same date as
  /// [initialValue].
  ///
  /// Defaults to null. When set to null, the picker does not impose a limit on
  /// the earliest [DateTime] the user can select.
  final DateTime? minimumValue;

  /// The maximum selectable date that the picker can settle on.
  ///
  /// When non-null, the user can still scroll the picker to [DateTime]s later
  /// than [maximumValue], but the [onChanged] will not be called on these
  /// [DateTime]s. Once let go, the picker will scroll back to [maximumValue].
  ///
  /// In [CupertinoDatePickerMode.time] mode, a time becomes unselectable if the
  /// [DateTime] produced by combining that particular time and the date part of
  /// [initialValue] is later than [maximumValue]. So typically [maximumValue]
  /// needs to be set to a [DateTime] that is on the same date as
  /// [initialValue].
  ///
  /// Defaults to null. When set to null, the picker does not impose a limit on
  /// the latest [DateTime] the user can select.
  final DateTime? maximumValue;

  /// Background color of date picker.
  ///
  /// Defaults to null, which disables background painting entirely.
  final Color? backgroundColor;

  /// {@macro flutter.cupertino.picker.itemExtent}
  ///
  /// Defaults to a value that matches the default iOS date picker wheel.
  final double itemExtent;

  /// {@macro flutter.rendering.RenderListWheelViewport.useMagnifier}
  final bool useMagnifier;

  /// {@macro flutter.rendering.RenderListWheelViewport.magnification}
  final double magnification;

  final double diameterRatio;

  final TextStyle? textStyle;

  final TextStyle? unselectedTextStyle;

  final Color? unselectedColor;

  /// {@macro flutter.rendering.RenderListWheelViewport.squeeze}
  ///
  /// Defaults to 1.
  final double squeeze;

  /// Callback called when the selected date and/or time changes. If the new
  /// selected [DateTime] is not valid, or is not in the [minimumValue] through
  /// [maximumValue] range, this callback will not be called.
  final ValueChanged<DateTime> onChanged;
}

abstract class _CupertinoPickerState extends State<TxCupertinoPicker> {
  DateTime get _initialDate {
    final DateTime now = DateTime.now();
    if (widget.minimumValue != null && now.isBefore(widget.minimumValue!)) {
      return widget.minimumValue!;
    }
    if (widget.maximumValue != null && now.isAfter(widget.maximumValue!)) {
      return widget.maximumValue!;
    }
    return now;
  }

  late int textDirectionFactor;
  late CupertinoLocalizations localizations;

  // Alignment based on text direction. The variable name is self descriptive,
  // however, when text direction is rtl, alignment is reversed.
  late Alignment alignCenterLeft;
  late Alignment alignCenterRight;

  // 计算透明度的函数，使用二次函数实现平滑过渡
  double calculateTransparency(int index, int total) {
    // 计算中间位置的索引
    final int middleIndex = total ~/ 2;
    // 计算当前索引与中间位置的距离，归一化到0到1之间
    final double normalizedDistance =
        ((index - middleIndex).abs() / middleIndex).clamp(0.0, 1.0);
    // 使用二次函数计算透明度，实现平滑过渡
    final double transparency = 1 - normalizedDistance * normalizedDistance;
    return transparency;
  }

  TextStyle _themeTextStyle([bool isValid = true]) {
    final TextStyle style = widget.textStyle ??
        CupertinoTheme.of(context).textTheme.dateTimePickerTextStyle;
    final TextStyle unselectedStyle = widget.unselectedTextStyle ?? style;
    return isValid
        ? style.copyWith(
            color: CupertinoDynamicColor.maybeResolve(style.color, context))
        : unselectedStyle.copyWith(
            color: CupertinoDynamicColor.resolve(
                widget.unselectedColor ?? CupertinoColors.inactiveGray,
                context));
  }

  Widget _buildPicker(
    double offAxisFraction,
    TransitionBuilder itemPositioningBuilder,
    Widget selectionOverlay,
    ValueChanged<bool> onScrollingChanged,
    FixedExtentScrollController controller,
    ValueChanged<int> onSelectedItemChanged,
    List<Widget> children,
  ) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification is ScrollStartNotification) {
          onScrollingChanged(true);
        } else if (notification is ScrollEndNotification) {
          onScrollingChanged(false);
          _pickerDidStopScrolling();
        }
        return false;
      },
      child: CupertinoPicker(
        scrollController: controller,
        offAxisFraction: offAxisFraction,
        itemExtent: widget.itemExtent,
        useMagnifier: widget.useMagnifier,
        magnification: widget.magnification,
        backgroundColor: widget.backgroundColor,
        squeeze: widget.squeeze,
        diameterRatio: widget.diameterRatio,
        onSelectedItemChanged: onSelectedItemChanged,
        looping: true,
        selectionOverlay: selectionOverlay,
        children: children,
      ),
    );
  }

  double _getColumnWidth(
    _PickerColumnType columnType,
    CupertinoLocalizations localizations,
    BuildContext context,
    bool showDayOfWeek, {
    bool standaloneMonth = false,
  }) {
    String longestText = '';

    switch (columnType) {
      case _PickerColumnType.date:
        // Measuring the length of all possible date is impossible, so here
        // just some dates are measured.
        for (int i = 1; i <= 12; i++) {
          // An arbitrary date.
          final String date =
              localizations.datePickerMediumDate(DateTime(2018, i, 25));
          if (longestText.length < date.length) {
            longestText = date;
          }
        }
      case _PickerColumnType.hour:
        for (int i = 0; i < 24; i++) {
          final String hour = localizations.datePickerHour(i);
          if (longestText.length < hour.length) {
            longestText = hour;
          }
        }
      case _PickerColumnType.minute:
        for (int i = 0; i < 60; i++) {
          final String minute = localizations.datePickerMinute(i);
          if (longestText.length < minute.length) {
            longestText = minute;
          }
        }
      case _PickerColumnType.dayPeriod:
        longestText = localizations.anteMeridiemAbbreviation.length >
                localizations.postMeridiemAbbreviation.length
            ? localizations.anteMeridiemAbbreviation
            : localizations.postMeridiemAbbreviation;
      case _PickerColumnType.dayOfMonth:
        int longestDayOfMonth = 1;
        for (int i = 1; i <= 31; i++) {
          final String dayOfMonth = localizations.datePickerDayOfMonth(i);
          if (longestText.length < dayOfMonth.length) {
            longestText = dayOfMonth;
            longestDayOfMonth = i;
          }
        }
        if (showDayOfWeek) {
          for (int wd = 1; wd < DateTime.daysPerWeek; wd++) {
            final String dayOfMonth =
                localizations.datePickerDayOfMonth(longestDayOfMonth, wd);
            if (longestText.length < dayOfMonth.length) {
              longestText = dayOfMonth;
            }
          }
        }
      case _PickerColumnType.month:
        for (int i = 1; i <= 12; i++) {
          final String month = standaloneMonth
              ? localizations.datePickerStandaloneMonth(i)
              : localizations.datePickerMonth(i);
          if (longestText.length < month.length) {
            longestText = month;
          }
        }
      case _PickerColumnType.year:
        longestText = localizations.datePickerYear(2018);
    }

    assert(longestText != '', 'column type is not appropriate');

    return TextPainter.computeMaxIntrinsicWidth(
      text: TextSpan(
        style: _themeTextStyle(),
        text: longestText,
      ),
      textDirection: Directionality.of(context),
    );
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
  }

  (List<Widget>, List<double>, double) get pickerConfig;

  @override
  Widget build(BuildContext context) {
    final (pickers, columnWidths, maxPickerWidth) = pickerConfig;

    return MediaQuery.withNoTextScaling(
      child: DefaultTextStyle.merge(
        style: _kDefaultPickerTextStyle,
        child: CustomMultiChildLayout(
          delegate: _DatePickerLayoutDelegate(
            columnWidths: columnWidths,
            textDirectionFactor: textDirectionFactor,
            maxWidth: maxPickerWidth,
          ),
          children: pickers,
        ),
      ),
    );
  }

  // One or more pickers have just stopped scrolling.
  void _pickerDidStopScrolling();
}

/// 月份选择器
class TxCupertinoMonthPicker extends TxCupertinoPicker {
  /// Constructs an iOS style date picker.
  ///
  /// [onMonthChanged] is the callback called when the selected date or time
  /// changes. When in [CupertinoDatePickerMode.time] mode, the year, month and
  /// day will be the same as [initialMonth]. When in
  /// [CupertinoDatePickerMode.date] mode, this callback will always report the
  /// start time of the currently selected day. When in
  /// [CupertinoDatePickerMode.monthYear] mode, the day and time will be the
  /// start time of the first day of the month.
  ///
  /// [initialMonth] is the initial date time of the picker. Defaults to the
  /// present date and time. The present must conform to the intervals set in
  /// [minimumDate], [maximumDate], [minimumYear], and [maximumYear].
  ///
  /// [minimumDate] is the minimum selectable [DateTime] of the picker. When set
  /// to null, the picker does not limit the minimum [DateTime] the user can
  /// pick.
  /// In [CupertinoDatePickerMode.time] mode, [minimumDate] should typically be
  /// on the same date as [initialMonth], as the picker will not limit the
  /// minimum time the user can pick if it's set to a date earlier than that.
  ///
  /// [maximumDate] is the maximum selectable [DateTime] of the picker. When set
  /// to null, the picker does not limit the maximum [DateTime] the user can
  /// pick.
  /// In [CupertinoDatePickerMode.time] mode, [maximumDate] should typically be
  /// on the same date as [initialMonth], as the picker will not limit the
  /// maximum time the user can pick if it's set to a date later than that.
  ///
  /// [minimumYear] is the minimum year that the picker can be scrolled to in
  /// [CupertinoDatePickerMode.date] mode. Defaults to 1.
  ///
  /// [maximumYear] is the maximum year that the picker can be scrolled to in
  /// [CupertinoDatePickerMode.date] mode. Null if there's no limit.
  ///
  /// [dateOrder] determines the order of the columns inside
  /// [CupertinoDatePicker] in [CupertinoDatePickerMode.date] and
  /// [CupertinoDatePickerMode.monthYear] mode. When using monthYear mode,
  /// both [DatePickerDateOrder.dmy] and [DatePickerDateOrder.mdy] will result
  /// in the month|year order. Defaults to the locale's default date format/order.
  TxCupertinoMonthPicker({
    required ValueChanged<DateTime> onMonthChanged,
    super.key,
    DateTime? initialMonth,
    DateTime? minimumDate,
    DateTime? maximumDate,
    int? minimumYear,
    this.maximumYear,
    this.dateOrder,
    super.backgroundColor,
    super.itemExtent,
    super.useMagnifier,
    super.magnification,
    super.squeeze,
    super.diameterRatio,
    super.textStyle,
    super.unselectedTextStyle,
    super.unselectedColor,
    this.showDayOfWeek = false,
  })  : minimumYear = minimumYear ?? 1,
        super(
          onChanged: onMonthChanged,
          initialValue: initialMonth,
          minimumValue: minimumDate,
          maximumValue: maximumDate,
        );

  /// Minimum year that the picker can be scrolled to in
  /// [CupertinoDatePickerMode.date] mode. Defaults to 1.
  final int minimumYear;

  /// Maximum year that the picker can be scrolled to in
  /// [CupertinoDatePickerMode.date] mode. Null if there's no limit.
  final int? maximumYear;

  /// Determines the order of the columns inside [CupertinoDatePicker] in
  /// [CupertinoDatePickerMode.date] and [CupertinoDatePickerMode.monthYear]
  /// mode. When using monthYear mode, both [DatePickerDateOrder.dmy] and
  /// [DatePickerDateOrder.mdy] will result in the month|year order.
  /// Defaults to the locale's default date format/order.
  final DatePickerDateOrder? dateOrder;

  final bool showDayOfWeek;

  @override
  State<StatefulWidget> createState() => _CupertinoMonthPickerState();
}

class _CupertinoMonthPickerState extends _CupertinoPickerState {
  @override
  TxCupertinoMonthPicker get widget => super.widget as TxCupertinoMonthPicker;

  DatePickerDateOrder? get dateOrder => widget.dateOrder;

  DateTime get minSelectDate => DateTime(selectedYear, selectedMonth);

  DateTime get maxSelectDate =>
      DateTime(selectedYear, selectedMonth, _initialDate.day + 1);

  DateTime get currentSelectedDate => DateTime(selectedYear, selectedMonth);

  String _formatMonth(int month) =>
      localizations.datePickerStandaloneMonth(month);

  // The currently selected values of the picker.
  late int selectedYear;
  late int selectedMonth;

  // The controller of the day picker. There are cases where the selected value
  // of the picker is invalid (e.g. February 30th 2018), and this
  // monthController is responsible for jumping to a valid value.
  late FixedExtentScrollController monthController;
  late FixedExtentScrollController yearController;

  bool isMonthPickerScrolling = false;
  bool isYearPickerScrolling = false;

  bool get isScrolling => isMonthPickerScrolling || isYearPickerScrolling;

  // Estimated width of columns.
  Map<int, double> estimatedColumnWidths = <int, double>{};

  @override
  void initState() {
    super.initState();
    final DateTime initialDate = _initialDate;
    selectedMonth = initialDate.month;
    selectedYear = initialDate.year;

    monthController =
        FixedExtentScrollController(initialItem: selectedMonth - 1);
    yearController = FixedExtentScrollController(initialItem: selectedYear);

    PaintingBinding.instance.systemFonts.addListener(_handleSystemFontsChange);
  }

  void _handleSystemFontsChange() {
    setState(_refreshEstimatedColumnWidths);
  }

  @override
  void dispose() {
    monthController.dispose();
    yearController.dispose();

    PaintingBinding.instance.systemFonts
        .removeListener(_handleSystemFontsChange);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _refreshEstimatedColumnWidths();
  }

  void _refreshEstimatedColumnWidths() {
    estimatedColumnWidths[_PickerColumnType.month.index] = _getColumnWidth(
        _PickerColumnType.month, localizations, context, widget.showDayOfWeek);
    estimatedColumnWidths[_PickerColumnType.year.index] = _getColumnWidth(
        _PickerColumnType.year, localizations, context, widget.showDayOfWeek);
  }

  Widget _buildMonthPicker(double offAxisFraction,
      TransitionBuilder itemPositioningBuilder, Widget selectionOverlay) {
    void onSelectedChanged(int index) {
      selectedMonth = index + 1;
      if (_isCurrentDateValid) {
        widget.onChanged(currentSelectedDate);
      }
    }

    final List<Widget> children = List<Widget>.generate(12, (int index) {
      final int month = index + 1;
      final bool isInvalidMonth = (widget.minimumValue?.year == selectedYear &&
              widget.minimumValue!.month > month) ||
          (widget.maximumValue?.year == selectedYear &&
              widget.maximumValue!.month < month);
      final String monthName = _formatMonth(month);

      return itemPositioningBuilder(
        context,
        Text(monthName, style: _themeTextStyle(!isInvalidMonth)),
      );
    });

    return _buildPicker(
      offAxisFraction,
      itemPositioningBuilder,
      selectionOverlay,
      (val) => isMonthPickerScrolling = val,
      monthController,
      onSelectedChanged,
      children,
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
          _pickerDidStopScrolling();
        }

        return false;
      },
      child: CupertinoPicker.builder(
        scrollController: yearController,
        itemExtent: widget.itemExtent,
        offAxisFraction: offAxisFraction,
        useMagnifier: widget.useMagnifier,
        magnification: widget.magnification,
        squeeze: widget.squeeze,
        backgroundColor: widget.backgroundColor,
        diameterRatio: widget.diameterRatio,
        onSelectedItemChanged: (int index) {
          selectedYear = index;
          if (_isCurrentDateValid) {
            widget.onChanged(currentSelectedDate);
          }
        },
        itemBuilder: (BuildContext context, int year) {
          if (year < widget.minimumYear) {
            return null;
          }

          if (widget.maximumYear != null && year > widget.maximumYear!) {
            return null;
          }

          final bool isValidYear = (widget.minimumValue == null ||
                  widget.minimumValue!.year <= year) &&
              (widget.maximumValue == null ||
                  widget.maximumValue!.year >= year);

          return itemPositioningBuilder(
            context,
            Text(
              localizations.datePickerYear(year),
              style: _themeTextStyle(isValidYear),
            ),
          );
        },
        selectionOverlay: selectionOverlay,
      ),
    );
  }

  bool get _isCurrentDateValid {
    final bool minCheck = widget.minimumValue?.isBefore(maxSelectDate) ?? true;
    final bool maxCheck = widget.maximumValue?.isBefore(minSelectDate) ?? false;

    return minCheck && !maxCheck;
  }

  // One or more pickers have just stopped scrolling.
  @override
  void _pickerDidStopScrolling() {
    // Call setState to update the greyed out days/months/years, as the currently
    // selected year/month may have changed.
    setState(() {});

    if (isScrolling) {
      return;
    }

    final bool minCheck = widget.minimumValue?.isBefore(maxSelectDate) ?? true;
    final bool maxCheck = widget.maximumValue?.isBefore(minSelectDate) ?? false;

    if (!minCheck || maxCheck) {
      // We have minCheck === !maxCheck.
      final DateTime targetDate =
          minCheck ? widget.maximumValue! : widget.minimumValue!;
      _scrollToDate(targetDate);
      return;
    }
  }

  void _scrollToDate(DateTime newDate) {
    SchedulerBinding.instance.addPostFrameCallback((Duration timestamp) {
      if (selectedYear != newDate.year) {
        _animateColumnControllerToItem(yearController, newDate.year);
      }

      if (selectedMonth != newDate.month) {
        _animateColumnControllerToItem(monthController, newDate.month - 1);
      }
    }, debugLabel: 'DatePicker.scrollToDate');
  }

  @override
  (List<Widget>, List<double>, double) get pickerConfig {
    List<_ColumnBuilder> pickerBuilders = <_ColumnBuilder>[];
    List<double> columnWidths = <double>[];

    final DatePickerDateOrder datePickerDateOrder =
        dateOrder ?? localizations.datePickerDateOrder;

    switch (datePickerDateOrder) {
      case DatePickerDateOrder.mdy:
      case DatePickerDateOrder.dmy:
        pickerBuilders = <_ColumnBuilder>[_buildMonthPicker, _buildYearPicker];
        columnWidths = <double>[
          estimatedColumnWidths[_PickerColumnType.month.index]!,
          estimatedColumnWidths[_PickerColumnType.year.index]!,
        ];
      case DatePickerDateOrder.ymd:
      case DatePickerDateOrder.ydm:
        pickerBuilders = <_ColumnBuilder>[_buildYearPicker, _buildMonthPicker];
        columnWidths = <double>[
          estimatedColumnWidths[_PickerColumnType.year.index]!,
          estimatedColumnWidths[_PickerColumnType.month.index]!,
        ];
    }

    final List<Widget> pickers = <Widget>[];
    double totalColumnWidths = 3 * _kDatePickerPadSize;

    for (int i = 0; i < columnWidths.length; i++) {
      late final double offAxisFraction;
      switch (i) {
        case 0:
          offAxisFraction = -0.3 * textDirectionFactor;
        default:
          offAxisFraction = 0.5 * textDirectionFactor;
      }

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

      totalColumnWidths += columnWidths[i] + (2 * _kDatePickerPadSize);

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

    final double maxPickerWidth =
        totalColumnWidths > _kPickerWidth ? totalColumnWidths : _kPickerWidth;

    return (pickers, columnWidths, maxPickerWidth);
  }
}

/// 日期选择器
class TxCupertinoDatePicker extends TxCupertinoMonthPicker {
  /// Constructs an iOS style date picker.
  ///
  /// [onChanged] is the callback called when the selected date or time
  /// changes. When in [CupertinoDatePickerMode.time] mode, the year, month and
  /// day will be the same as [initialDate]. When in
  /// [CupertinoDatePickerMode.date] mode, this callback will always report the
  /// start time of the currently selected day. When in
  /// [CupertinoDatePickerMode.monthYear] mode, the day and time will be the
  /// start time of the first day of the month.
  ///
  /// [initialDate] is the initial date time of the picker. Defaults to the
  /// present date and time. The present must conform to the intervals set in
  /// [minimumDate], [maximumDate], [minimumYear], and [maximumYear].
  ///
  /// [minimumDate] is the minimum selectable [DateTime] of the picker. When set
  /// to null, the picker does not limit the minimum [DateTime] the user can
  /// pick.
  /// In [CupertinoDatePickerMode.time] mode, [minimumDate] should typically be
  /// on the same date as [initialDate], as the picker will not limit the
  /// minimum time the user can pick if it's set to a date earlier than that.
  ///
  /// [maximumDate] is the maximum selectable [DateTime] of the picker. When set
  /// to null, the picker does not limit the maximum [DateTime] the user can
  /// pick.
  /// In [CupertinoDatePickerMode.time] mode, [maximumDate] should typically be
  /// on the same date as [initialDate], as the picker will not limit the
  /// maximum time the user can pick if it's set to a date later than that.
  ///
  /// [minimumYear] is the minimum year that the picker can be scrolled to in
  /// [CupertinoDatePickerMode.date] mode. Defaults to 1.
  ///
  /// [maximumYear] is the maximum year that the picker can be scrolled to in
  /// [CupertinoDatePickerMode.date] mode. Null if there's no limit.
  ///
  /// [dateOrder] determines the order of the columns inside
  /// [CupertinoDatePicker] in [CupertinoDatePickerMode.date] and
  /// [CupertinoDatePickerMode.monthYear] mode. When using monthYear mode,
  /// both [DatePickerDateOrder.dmy] and [DatePickerDateOrder.mdy] will result
  /// in the month|year order. Defaults to the locale's default date format/order.
  TxCupertinoDatePicker({
    required ValueChanged<DateTime> onDateChanged,
    super.key,
    DateTime? initialDate,
    super.minimumDate,
    super.maximumDate,
    super.minimumYear,
    super.maximumYear,
    super.dateOrder,
    super.backgroundColor,
    super.showDayOfWeek,
    super.itemExtent,
    super.useMagnifier,
    super.magnification,
    super.squeeze,
    super.diameterRatio,
    super.textStyle,
    super.unselectedTextStyle,
    super.unselectedColor,
  }) : super(initialMonth: initialDate, onMonthChanged: onDateChanged);

  @override
  State<StatefulWidget> createState() => _CupertinoDatePickerState();
}

class _CupertinoDatePickerState extends _CupertinoMonthPickerState {
  @override
  TxCupertinoDatePicker get widget => super.widget as TxCupertinoDatePicker;

  @override
  DateTime get minSelectDate =>
      DateTime(selectedYear, selectedMonth, selectedDay);

  @override
  DateTime get maxSelectDate =>
      DateTime(selectedYear, selectedMonth, selectedDay + 1);

  @override
  DateTime get currentSelectedDate =>
      DateTime(selectedYear, selectedMonth, selectedDay);

  @override
  String _formatMonth(int month) => localizations.datePickerMonth(month);

  // The currently selected values of the picker.
  late int selectedDay;

  // The controller of the day picker. There are cases where the selected value
  // of the picker is invalid (e.g. February 30th 2018), and this dayController
  // is responsible for jumping to a valid value.
  late FixedExtentScrollController dayController;

  bool isDayPickerScrolling = false;

  @override
  bool get isScrolling => isDayPickerScrolling || super.isScrolling;

  @override
  void initState() {
    super.initState();
    selectedDay = _initialDate.day;

    dayController = FixedExtentScrollController(initialItem: selectedDay - 1);
  }

  @override
  void dispose() {
    dayController.dispose();

    super.dispose();
  }

  @override
  void _refreshEstimatedColumnWidths() {
    super._refreshEstimatedColumnWidths();
    estimatedColumnWidths[_PickerColumnType.dayOfMonth.index] = _getColumnWidth(
      _PickerColumnType.dayOfMonth,
      localizations,
      context,
      widget.showDayOfWeek,
    );
  }

  // The DateTime of the last day of a given month in a given year.
  // Let `DateTime` handle the year/month overflow.
  DateTime _lastDayInMonth(int year, int month) => DateTime(year, month + 1, 0);

  Widget _buildDayPicker(double offAxisFraction,
      TransitionBuilder itemPositioningBuilder, Widget selectionOverlay) {
    final int daysInCurrentMonth =
        _lastDayInMonth(selectedYear, selectedMonth).day;

    void onSelectedItemChanged(int index) {
      selectedDay = index + 1;
      if (_isCurrentDateValid) {
        widget.onChanged(currentSelectedDate);
      }
    }

    final List<Widget> children = List<Widget>.generate(31, (int index) {
      final int day = index + 1;
      final int? dayOfWeek = widget.showDayOfWeek
          ? DateTime(selectedYear, selectedMonth, day).weekday
          : null;
      return itemPositioningBuilder(
        context,
        Text(
          localizations.datePickerDayOfMonth(day, dayOfWeek),
          style: _themeTextStyle(day <= daysInCurrentMonth),
        ),
      );
    });

    return _buildPicker(
      offAxisFraction,
      itemPositioningBuilder,
      selectionOverlay,
      (val) => isDayPickerScrolling = val,
      dayController,
      onSelectedItemChanged,
      children,
    );
  }

  @override
  bool get _isCurrentDateValid =>
      super._isCurrentDateValid && minSelectDate.day == selectedDay;

  // One or more pickers have just stopped scrolling.
  @override
  void _pickerDidStopScrolling() {
    // Call setState to update the greyed out days/months/years, as the currently
    // selected year/month may have changed.
    setState(() {});

    if (isScrolling) {
      return;
    }

    // Whenever scrolling lands on an invalid entry, the picker
    // automatically scrolls to a valid one.
    final DateTime minSelectDate =
        DateTime(selectedYear, selectedMonth, selectedDay);
    final DateTime maxSelectDate =
        DateTime(selectedYear, selectedMonth, selectedDay + 1);

    final bool minCheck = widget.minimumValue?.isBefore(maxSelectDate) ?? true;
    final bool maxCheck = widget.maximumValue?.isBefore(minSelectDate) ?? false;

    if (!minCheck || maxCheck) {
      // We have minCheck === !maxCheck.
      final DateTime targetDate =
          minCheck ? widget.maximumValue! : widget.minimumValue!;
      _scrollToDate(targetDate);
      return;
    }

    // Some months have less days (e.g. February). Go to the last day of that
    // month if the selectedDay exceeds the maximum.
    if (minSelectDate.day != selectedDay) {
      final DateTime lastDay = _lastDayInMonth(selectedYear, selectedMonth);
      _scrollToDate(lastDay);
    }
  }

  @override
  void _scrollToDate(DateTime newDate) {
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
    }, debugLabel: 'DatePicker.scrollToDate');
  }

  @override
  (List<Widget>, List<double>, double) get pickerConfig {
    List<_ColumnBuilder> pickerBuilders = <_ColumnBuilder>[];
    List<double> columnWidths = <double>[];

    final DatePickerDateOrder datePickerDateOrder =
        dateOrder ?? localizations.datePickerDateOrder;

    switch (datePickerDateOrder) {
      case DatePickerDateOrder.mdy:
        pickerBuilders = <_ColumnBuilder>[
          _buildMonthPicker,
          _buildDayPicker,
          _buildYearPicker
        ];
        columnWidths = <double>[
          estimatedColumnWidths[_PickerColumnType.month.index]!,
          estimatedColumnWidths[_PickerColumnType.dayOfMonth.index]!,
          estimatedColumnWidths[_PickerColumnType.year.index]!,
        ];
      case DatePickerDateOrder.dmy:
        pickerBuilders = <_ColumnBuilder>[
          _buildDayPicker,
          _buildMonthPicker,
          _buildYearPicker
        ];
        columnWidths = <double>[
          estimatedColumnWidths[_PickerColumnType.dayOfMonth.index]!,
          estimatedColumnWidths[_PickerColumnType.month.index]!,
          estimatedColumnWidths[_PickerColumnType.year.index]!,
        ];
      case DatePickerDateOrder.ymd:
        pickerBuilders = <_ColumnBuilder>[
          _buildYearPicker,
          _buildMonthPicker,
          _buildDayPicker
        ];
        columnWidths = <double>[
          estimatedColumnWidths[_PickerColumnType.year.index]!,
          estimatedColumnWidths[_PickerColumnType.month.index]!,
          estimatedColumnWidths[_PickerColumnType.dayOfMonth.index]!,
        ];
      case DatePickerDateOrder.ydm:
        pickerBuilders = <_ColumnBuilder>[
          _buildYearPicker,
          _buildDayPicker,
          _buildMonthPicker
        ];
        columnWidths = <double>[
          estimatedColumnWidths[_PickerColumnType.year.index]!,
          estimatedColumnWidths[_PickerColumnType.dayOfMonth.index]!,
          estimatedColumnWidths[_PickerColumnType.month.index]!,
        ];
    }

    final List<Widget> pickers = <Widget>[];
    double totalColumnWidths = 4 * _kDatePickerPadSize;

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

      totalColumnWidths += columnWidths[i] + (2 * _kDatePickerPadSize);

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

    final double maxPickerWidth =
        totalColumnWidths > _kPickerWidth ? totalColumnWidths : _kPickerWidth;
    return (pickers, columnWidths, maxPickerWidth);
  }
}

/// 时间选择器
class TxCupertinoTimePicker extends TxCupertinoPicker {
  TxCupertinoTimePicker({
    required ValueChanged<DateTime> onTimeChanged,
    DateTime? initialTime,
    TimeOfDay? minimumTime,
    TimeOfDay? maximumTime,
    this.minuteInterval = 1,
    this.use24hFormat = true,
    super.key,
    super.backgroundColor,
    super.itemExtent,
    super.useMagnifier,
    super.magnification,
    super.squeeze,
    super.diameterRatio,
    super.textStyle,
    super.unselectedTextStyle,
    super.unselectedColor,
  })  : showDayOfWeek = false,
        super(
          initialValue: initialTime,
          onChanged: onTimeChanged,
          minimumValue: minimumTime?.toDateTime(initialTime),
          maximumValue: maximumTime?.toDateTime(initialTime),
        ) {
    assert(
      initialValue == null || initialValue!.minute % minuteInterval == 0,
      'initial minute is not divisible by minute interval',
    );
  }

  TxCupertinoTimePicker._datetime({
    required ValueChanged<DateTime> onDatetimeChanged,
    DateTime? initialDatetime,
    super.minimumValue,
    super.maximumValue,
    this.minuteInterval = 1,
    this.use24hFormat = true,
    super.key,
    super.backgroundColor,
    super.itemExtent,
    super.useMagnifier,
    super.magnification,
    super.squeeze,
    super.diameterRatio,
    super.textStyle,
    super.unselectedTextStyle,
    super.unselectedColor,
    this.showDayOfWeek = false,
  }) : super(
          initialValue: initialDatetime,
          onChanged: onDatetimeChanged,
        ) {
    assert(
      initialValue == null || initialValue!.minute % minuteInterval == 0,
      'initial minute is not divisible by minute interval',
    );
  }

  /// The granularity of the minutes spinner, if it is shown in the current
  /// mode. Must be an integer factor of 60.
  final int minuteInterval;

  /// Whether to use 24 hour format. Defaults to false.
  final bool use24hFormat;

  /// Whether to to show day of week alongside day. Defaults to false.
  final bool showDayOfWeek;

  @override
  State<StatefulWidget> createState() => _CupertinoTimePickerState();
}

class _CupertinoTimePickerState extends _CupertinoPickerState {
  @override
  TxCupertinoTimePicker get widget => super.widget as TxCupertinoTimePicker;

  // Fraction of the farthest column's vanishing point vs its width. Eyeballed
  // vs iOS.
  static const double _kMaximumOffAxisFraction = 0.45;

  // Read this out when the state is initially created. Changes in
  // initialDateTime in the widget after first build is ignored.
  late DateTime initialDateTime;

  // The current selection of the hour picker. Values range from 0 to 23.
  int get selectedHour => _selectedHour(selectedAmPm, _selectedHourIndex);

  int get _selectedHourIndex => hourController.hasClients
      ? hourController.selectedItem % 24
      : initialDateTime.hour;

  // Calculates the selected hour given the selected indices of the hour picker
  // and the meridiem picker.
  int _selectedHour(int selectedAmPm, int selectedHour) {
    return _isHourRegionFlipped(selectedAmPm)
        ? (selectedHour + 12) % 24
        : selectedHour;
  }

  // The controller of the hour column.
  late FixedExtentScrollController hourController;

  // The current selection of the minute picker. Values range from 0 to 59.
  int get selectedMinute {
    return minuteController.hasClients
        ? minuteController.selectedItem * widget.minuteInterval % 60
        : initialDateTime.minute;
  }

  // The controller of the minute column.
  late FixedExtentScrollController minuteController;

  // Whether the current meridiem selection is AM or PM.
  //
  // We can't use the selectedItem of meridiemController as the source of truth
  // because the meridiem picker can be scrolled **animatedly** by the hour
  // picker (e.g. if you scroll from 12 to 1 in 12h format), but the meridiem
  // change should take effect immediately, **before** the animation finishes.
  late int selectedAmPm;

  // Whether the physical-region-to-meridiem mapping is flipped.
  bool get isHourRegionFlipped => _isHourRegionFlipped(selectedAmPm);

  bool _isHourRegionFlipped(int selectedAmPm) => selectedAmPm != meridiemRegion;

  // The index of the 12-hour region the hour picker is currently in.
  //
  // Used to determine whether the meridiemController should start animating.
  // Valid values are 0 and 1.
  //
  // The AM/PM correspondence of the two regions flips when the meridiem picker
  // scrolls. This variable is to keep track of the selected "physical"
  // (meridiem picker invariant) region of the hour picker. The "physical"
  // region of an item of index `i` is `i ~/ 12`.
  late int meridiemRegion;

  // The current selection of the AM/PM picker.
  //
  // - 0 means AM
  // - 1 means PM
  late FixedExtentScrollController meridiemController;

  bool isHourPickerScrolling = false;
  bool isMinutePickerScrolling = false;
  bool isMeridiemPickerScrolling = false;

  bool get isScrolling {
    return isHourPickerScrolling ||
        isMinutePickerScrolling ||
        isMeridiemPickerScrolling;
  }

  int get selectedDate => initialDateTime.day;

  // The estimated width of columns.
  final Map<int, double> estimatedColumnWidths = <int, double>{};

  @override
  void initState() {
    super.initState();
    initialDateTime = _initialDate;

    // Initially each of the "physical" regions is mapped to the meridiem region
    // with the same number, e.g., the first 12 items are mapped to the first 12
    // hours of a day. Such mapping is flipped when the meridiem picker is
    // scrolled by the user, the first 12 items are mapped to the last 12 hours
    // of a day.
    selectedAmPm = initialDateTime.hour ~/ 12;
    meridiemRegion = selectedAmPm;

    meridiemController = FixedExtentScrollController(initialItem: selectedAmPm);
    hourController =
        FixedExtentScrollController(initialItem: initialDateTime.hour);
    minuteController = FixedExtentScrollController(
        initialItem: initialDateTime.minute ~/ widget.minuteInterval);

    PaintingBinding.instance.systemFonts.addListener(_handleSystemFontsChange);
  }

  void _handleSystemFontsChange() {
    setState(estimatedColumnWidths.clear);
  }

  @override
  void dispose() {
    hourController.dispose();
    minuteController.dispose();
    meridiemController.dispose();

    PaintingBinding.instance.systemFonts
        .removeListener(_handleSystemFontsChange);
    super.dispose();
  }

  @override
  void didUpdateWidget(TxCupertinoTimePicker oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!widget.use24hFormat && oldWidget.use24hFormat) {
      // Thanks to the physical and meridiem region mapping, the only thing we
      // need to update is the meridiem controller, if it's not previously
      // attached.
      meridiemController.dispose();
      meridiemController =
          FixedExtentScrollController(initialItem: selectedAmPm);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    estimatedColumnWidths.clear();
  }

  // Lazily calculate the column width of the column being displayed only.
  double _getEstimatedColumnWidth(_PickerColumnType columnType) {
    if (estimatedColumnWidths[columnType.index] == null) {
      estimatedColumnWidths[columnType.index] = _getColumnWidth(
          columnType, localizations, context, widget.showDayOfWeek);
    }

    return estimatedColumnWidths[columnType.index]!;
  }

  // Gets the current date time of the picker.
  DateTime get selectedDateTime {
    return DateTime(
      initialDateTime.year,
      initialDateTime.month,
      selectedDate,
      selectedHour,
      selectedMinute,
    );
  }

  // Only reports datetime change when the date time is valid.
  void _onSelectedItemChange(int index) {
    final DateTime selected = selectedDateTime;

    final bool isDateInvalid =
        (widget.minimumValue?.isAfter(selected) ?? false) ||
            (widget.maximumValue?.isBefore(selected) ?? false);

    if (isDateInvalid) {
      return;
    }

    widget.onChanged(selected);
  }

  // With the meridiem picker set to `meridiemIndex`, and the hour picker set to
  // `hourIndex`, is it possible to change the value of the minute picker, so
  // that the resulting date stays in the valid range.
  bool _isValidHour(int meridiemIndex, int hourIndex) {
    final DateTime rangeStart = DateTime(
      initialDateTime.year,
      initialDateTime.month,
      selectedDate,
      _selectedHour(meridiemIndex, hourIndex),
    );

    // The end value of the range is exclusive, i.e. [rangeStart, rangeEnd).
    final DateTime rangeEnd = rangeStart.add(const Duration(hours: 1));

    return (widget.minimumValue?.isBefore(rangeEnd) ?? true) &&
        !(widget.maximumValue?.isBefore(rangeStart) ?? false);
  }

  Widget _buildHourPicker(
    double offAxisFraction,
    TransitionBuilder itemPositioningBuilder,
    Widget selectionOverlay,
  ) {
    void onChanged(int index) {
      final bool regionChanged = meridiemRegion != index ~/ 12;
      final bool debugIsFlipped = isHourRegionFlipped;

      if (regionChanged) {
        meridiemRegion = index ~/ 12;
        selectedAmPm = 1 - selectedAmPm;
      }

      if (!widget.use24hFormat && regionChanged) {
        // Scroll the meridiem column to adjust AM/PM.
        //
        // _onSelectedItemChanged will be called when the animation finishes.
        //
        // Animation values obtained by comparing with iOS version.
        meridiemController.animateToItem(
          selectedAmPm,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      } else {
        _onSelectedItemChange(index);
      }

      assert(debugIsFlipped == isHourRegionFlipped);
    }

    final List<Widget> children = List<Widget>.generate(24, (int index) {
      final int hour = isHourRegionFlipped ? (index + 12) % 24 : index;
      final int displayHour = widget.use24hFormat ? hour : (hour + 11) % 12 + 1;

      return itemPositioningBuilder(
        context,
        Text(
          localizations.datePickerHour(displayHour),
          semanticsLabel:
              localizations.datePickerHourSemanticsLabel(displayHour),
          style: _themeTextStyle(_isValidHour(selectedAmPm, index)),
        ),
      );
    });

    return _buildPicker(
      offAxisFraction,
      itemPositioningBuilder,
      selectionOverlay,
      (val) => isHourPickerScrolling = val,
      hourController,
      onChanged,
      children,
    );
  }

  Widget _buildMinutePicker(double offAxisFraction,
      TransitionBuilder itemPositioningBuilder, Widget selectionOverlay) {
    final List<Widget> children =
        List<Widget>.generate(60 ~/ widget.minuteInterval, (int index) {
      final int minute = index * widget.minuteInterval;

      final DateTime date = DateTime(
        initialDateTime.year,
        initialDateTime.month,
        selectedDate,
        selectedHour,
        minute,
      );

      final bool isInvalidMinute =
          (widget.minimumValue?.isAfter(date) ?? false) ||
              (widget.maximumValue?.isBefore(date) ?? false);

      return itemPositioningBuilder(
        context,
        Text(
          localizations.datePickerMinute(minute),
          semanticsLabel: localizations.datePickerMinuteSemanticsLabel(minute),
          style: _themeTextStyle(!isInvalidMinute),
        ),
      );
    });

    return _buildPicker(
      offAxisFraction,
      itemPositioningBuilder,
      selectionOverlay,
      (val) => isMinutePickerScrolling = val,
      minuteController,
      _onSelectedItemChange,
      children,
    );
  }

  Widget _buildAmPmPicker(double offAxisFraction,
      TransitionBuilder itemPositioningBuilder, Widget selectionOverlay) {
    void onChanged(int index) {
      selectedAmPm = index;
      assert(selectedAmPm == 0 || selectedAmPm == 1);
      _onSelectedItemChange(index);
    }

    final List<Widget> children = List<Widget>.generate(2, (int index) {
      return itemPositioningBuilder(
        context,
        Text(
          index == 0
              ? localizations.anteMeridiemAbbreviation
              : localizations.postMeridiemAbbreviation,
          style: _themeTextStyle(_isValidHour(index, _selectedHourIndex)),
        ),
      );
    });

    return _buildPicker(
      offAxisFraction,
      itemPositioningBuilder,
      selectionOverlay,
      (val) => isMeridiemPickerScrolling = val,
      meridiemController,
      onChanged,
      children,
    );
  }

  // One or more pickers have just stopped scrolling.
  @override
  void _pickerDidStopScrolling() {
    // Call setState to update the greyed out date/hour/minute/meridiem.
    setState(() {});

    if (isScrolling) {
      return;
    }

    // Whenever scrolling lands on an invalid entry, the picker
    // automatically scrolls to a valid one.
    final DateTime selectedDate = selectedDateTime;

    final bool minCheck = widget.minimumValue?.isAfter(selectedDate) ?? false;
    final bool maxCheck = widget.maximumValue?.isBefore(selectedDate) ?? false;

    if (minCheck || maxCheck) {
      // We have minCheck === !maxCheck.
      final DateTime targetDate =
          minCheck ? widget.minimumValue! : widget.maximumValue!;
      _scrollToDate(targetDate, selectedDate, minCheck);
    }
  }

  void _scrollToDate(DateTime newDate, DateTime fromDate, bool minCheck) {
    SchedulerBinding.instance.addPostFrameCallback((Duration timestamp) {
      if (fromDate.hour != newDate.hour) {
        final bool needsMeridiemChange =
            !widget.use24hFormat && fromDate.hour ~/ 12 != newDate.hour ~/ 12;
        // In AM/PM mode, the pickers should not scroll all the way to the other hour region.
        if (needsMeridiemChange) {
          _animateColumnControllerToItem(
              meridiemController, 1 - meridiemController.selectedItem);

          // Keep the target item index in the current 12-h region.
          final int newItem = (hourController.selectedItem ~/ 12) * 12 +
              (hourController.selectedItem + newDate.hour - fromDate.hour) % 12;
          _animateColumnControllerToItem(hourController, newItem);
        } else {
          _animateColumnControllerToItem(
            hourController,
            hourController.selectedItem + newDate.hour - fromDate.hour,
          );
        }
      }

      if (fromDate.minute != newDate.minute) {
        final double positionDouble = newDate.minute / widget.minuteInterval;
        final int position =
            minCheck ? positionDouble.ceil() : positionDouble.floor();
        _animateColumnControllerToItem(minuteController, position);
      }
    }, debugLabel: 'DatePicker.scrollToDate');
  }

  (List<_ColumnBuilder>, List<double>) get columns {
    // Widths of the columns in this picker, ordered from left to right.
    final List<double> columnWidths = <double>[
      _getEstimatedColumnWidth(_PickerColumnType.hour),
      _getEstimatedColumnWidth(_PickerColumnType.minute),
    ];

    // Swap the hours and minutes if RTL to ensure they are in the correct
    // position.
    final List<_ColumnBuilder> pickerBuilders =
        Directionality.of(context) == TextDirection.rtl
            ? <_ColumnBuilder>[_buildMinutePicker, _buildHourPicker]
            : <_ColumnBuilder>[_buildHourPicker, _buildMinutePicker];

    // Adds am/pm column if the picker is not using 24h format.
    if (!widget.use24hFormat) {
      if (localizations.datePickerDateTimeOrder ==
              DatePickerDateTimeOrder.date_time_dayPeriod ||
          localizations.datePickerDateTimeOrder ==
              DatePickerDateTimeOrder.time_dayPeriod_date) {
        pickerBuilders.add(_buildAmPmPicker);
        columnWidths.add(_getEstimatedColumnWidth(_PickerColumnType.dayPeriod));
      } else {
        pickerBuilders.insert(0, _buildAmPmPicker);
        columnWidths.insert(
            0, _getEstimatedColumnWidth(_PickerColumnType.dayPeriod));
      }
    }

    return (pickerBuilders, columnWidths);
  }

  @override
  (List<Widget>, List<double>, double) get pickerConfig {
    final (pickerBuilders, columnWidths) = columns;

    final List<Widget> pickers = <Widget>[];
    double totalColumnWidths = 4 * _kDatePickerPadSize;

    for (int i = 0; i < columnWidths.length; i++) {
      double offAxisFraction = 0.0;
      Widget selectionOverlay = _centerSelectionOverlay;
      if (i == 0) {
        offAxisFraction = -_kMaximumOffAxisFraction * textDirectionFactor;
        selectionOverlay = _startSelectionOverlay;
      } else if (i >= 2 || columnWidths.length == 2) {
        offAxisFraction = _kMaximumOffAxisFraction * textDirectionFactor;
      }

      EdgeInsets padding = const EdgeInsets.only(right: _kDatePickerPadSize);
      if (i == columnWidths.length - 1) {
        padding = padding.flipped;
        selectionOverlay = _endSelectionOverlay;
      }
      if (textDirectionFactor == -1) {
        padding = padding.flipped;
      }

      totalColumnWidths += columnWidths[i] + (2 * _kDatePickerPadSize);

      pickers.add(LayoutId(
        id: i,
        child: pickerBuilders[i](
          offAxisFraction,
          (BuildContext context, Widget? child) {
            return Container(
              alignment: i == columnWidths.length - 1
                  ? alignCenterLeft
                  : alignCenterRight,
              padding: padding,
              child: Container(
                alignment: i == columnWidths.length - 1
                    ? alignCenterLeft
                    : alignCenterRight,
                width: i == 0 || i == columnWidths.length - 1
                    ? null
                    : columnWidths[i] + _kDatePickerPadSize,
                child: child,
              ),
            );
          },
          selectionOverlay,
        ),
      ));
    }

    final double maxPickerWidth =
        totalColumnWidths > _kPickerWidth ? totalColumnWidths : _kPickerWidth;

    return (pickers, columnWidths, maxPickerWidth);
  }
}

/// 日期时间选择器
class TxCupertinoDatetimePicker extends TxCupertinoTimePicker {
  TxCupertinoDatetimePicker({
    required super.onDatetimeChanged,
    super.initialDatetime,
    DateTime? minimumDatetime,
    DateTime? maximumDatetime,
    super.minuteInterval,
    super.use24hFormat,
    super.key,
    super.backgroundColor,
    super.itemExtent,
    super.useMagnifier,
    super.magnification,
    super.squeeze,
    super.diameterRatio,
    super.textStyle,
    super.unselectedTextStyle,
    super.unselectedColor,
    super.showDayOfWeek = false,
  }) : super._datetime(
          minimumValue: minimumDatetime,
          maximumValue: maximumDatetime,
        );

  @override
  State<StatefulWidget> createState() => _CupertinoDatetimePickerState();
}

class _CupertinoDatetimePickerState extends _CupertinoTimePickerState {
  // The difference in days between the initial date and the currently selected
  // date.
  // 0 if the current mode does not involve a date.
  int get selectedDayFromInitial =>
      dateController.hasClients ? dateController.selectedItem : 0;

  // The controller of the date column.
  late FixedExtentScrollController dateController;

  bool isDatePickerScrolling = false;

  @override
  int get selectedDate => initialDateTime.day + selectedDayFromInitial;

  @override
  bool get isScrolling {
    return isDatePickerScrolling || super.isScrolling;
  }

  @override
  TxCupertinoDatetimePicker get widget =>
      super.widget as TxCupertinoDatetimePicker;

  @override
  void initState() {
    super.initState();
    dateController = FixedExtentScrollController();
  }

  @override
  void dispose() {
    dateController.dispose();
    super.dispose();
  }

  // Builds the date column. The date is displayed in medium date format
  // (e.g. Fri Aug 31).
  Widget _buildMediumDatePicker(double offAxisFraction,
      TransitionBuilder itemPositioningBuilder, Widget selectionOverlay) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification is ScrollStartNotification) {
          isDatePickerScrolling = true;
        } else if (notification is ScrollEndNotification) {
          isDatePickerScrolling = false;
          _pickerDidStopScrolling();
        }

        return false;
      },
      child: CupertinoPicker.builder(
        scrollController: dateController,
        offAxisFraction: offAxisFraction,
        itemExtent: widget.itemExtent,
        useMagnifier: widget.useMagnifier,
        magnification: widget.magnification,
        backgroundColor: widget.backgroundColor,
        diameterRatio: widget.diameterRatio,
        squeeze: widget.squeeze,
        onSelectedItemChanged: _onSelectedItemChange,
        itemBuilder: (BuildContext context, int index) {
          final DateTime rangeStart = DateTime(
            initialDateTime.year,
            initialDateTime.month,
            initialDateTime.day + index,
          );

          // Exclusive.
          final DateTime rangeEnd = DateTime(
            initialDateTime.year,
            initialDateTime.month,
            initialDateTime.day + index + 1,
          );

          final DateTime now = DateTime.now();

          if (widget.minimumValue?.isBefore(rangeEnd) == false) {
            return null;
          }
          if (widget.maximumValue?.isAfter(rangeStart) == false) {
            return null;
          }

          final String dateText =
              rangeStart == DateTime(now.year, now.month, now.day)
                  ? localizations.todayLabel
                  : localizations.datePickerMediumDate(rangeStart);

          return itemPositioningBuilder(
            context,
            Text(dateText, style: _themeTextStyle()),
          );
        },
        selectionOverlay: selectionOverlay,
      ),
    );
  }

  @override
  void _scrollToDate(DateTime newDate, DateTime fromDate, bool minCheck) {
    SchedulerBinding.instance.addPostFrameCallback((Duration timestamp) {
      if (fromDate.year != newDate.year ||
          fromDate.month != newDate.month ||
          fromDate.day != newDate.day) {
        _animateColumnControllerToItem(dateController, selectedDayFromInitial);
      }

      if (fromDate.hour != newDate.hour) {
        final bool needsMeridiemChange =
            !widget.use24hFormat && fromDate.hour ~/ 12 != newDate.hour ~/ 12;
        // In AM/PM mode, the pickers should not scroll all the way to the other hour region.
        if (needsMeridiemChange) {
          _animateColumnControllerToItem(
              meridiemController, 1 - meridiemController.selectedItem);

          // Keep the target item index in the current 12-h region.
          final int newItem = (hourController.selectedItem ~/ 12) * 12 +
              (hourController.selectedItem + newDate.hour - fromDate.hour) % 12;
          _animateColumnControllerToItem(hourController, newItem);
        } else {
          _animateColumnControllerToItem(
            hourController,
            hourController.selectedItem + newDate.hour - fromDate.hour,
          );
        }
      }

      if (fromDate.minute != newDate.minute) {
        final double positionDouble = newDate.minute / widget.minuteInterval;
        final int position =
            minCheck ? positionDouble.ceil() : positionDouble.floor();
        _animateColumnControllerToItem(minuteController, position);
      }
    }, debugLabel: 'DatePicker.scrollToDate');
  }

  @override
  (List<_ColumnBuilder>, List<double>) get columns {
    final (pickerBuilders, columnWidths) = super.columns;

    if (localizations.datePickerDateTimeOrder ==
            DatePickerDateTimeOrder.time_dayPeriod_date ||
        localizations.datePickerDateTimeOrder ==
            DatePickerDateTimeOrder.dayPeriod_time_date) {
      pickerBuilders.add(_buildMediumDatePicker);
      columnWidths.add(_getEstimatedColumnWidth(_PickerColumnType.date));
    } else {
      pickerBuilders.insert(0, _buildMediumDatePicker);
      columnWidths.insert(0, _getEstimatedColumnWidth(_PickerColumnType.date));
    }

    return (pickerBuilders, columnWidths);
  }
}

/// 年份选择器
class TxCupertinoYearPicker extends StatefulWidget {
  const TxCupertinoYearPicker({
    required this.onChanged,
    super.key,
    this.initialYear,
    this.minimumYear,
    this.maximumYear,
    this.backgroundColor,
    double? itemExtent,
    bool? useMagnifier,
    double? magnification,
    double? squeeze,
    double? diameterRatio,
    this.textStyle,
    this.unselectedTextStyle,
    this.unselectedColor,
  })  : itemExtent = itemExtent ?? _kItemExtent,
        useMagnifier = useMagnifier ?? _kUseMagnifier,
        magnification = magnification ?? _kMagnification,
        squeeze = squeeze ?? _kSqueeze,
        diameterRatio = diameterRatio ?? _kDiameterRatio;

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

  /// {@macro flutter.cupertino.picker.itemExtent}
  ///
  /// Defaults to a value that matches the default iOS date picker wheel.
  final double itemExtent;

  /// {@macro flutter.rendering.RenderListWheelViewport.useMagnifier}
  final bool useMagnifier;

  /// {@macro flutter.rendering.RenderListWheelViewport.magnification}
  final double magnification;

  final double diameterRatio;

  final TextStyle? textStyle;

  final TextStyle? unselectedTextStyle;

  final Color? unselectedColor;

  /// {@macro flutter.rendering.RenderListWheelViewport.squeeze}
  ///
  /// Defaults to 1.
  final double squeeze;

  @override
  State<StatefulWidget> createState() => _TxCupertinoYearPickerState();
}

class _TxCupertinoYearPickerState extends State<TxCupertinoYearPicker> {
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
        itemExtent: widget.itemExtent,
        offAxisFraction: offAxisFraction,
        useMagnifier: widget.useMagnifier,
        magnification: widget.magnification,
        backgroundColor: widget.backgroundColor,
        diameterRatio: widget.diameterRatio,
        squeeze: widget.squeeze,
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
    if (widget.minimumYear != null && selectedYear < widget.minimumYear!) {
      selectedYear = widget.minimumYear!;
    } else if (widget.maximumYear != null &&
        selectedYear > widget.maximumYear!) {
      selectedYear = widget.maximumYear!;
    }

    yearController = FixedExtentScrollController(initialItem: selectedYear);
  }

  @override
  void didUpdateWidget(covariant TxCupertinoYearPicker oldWidget) {
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
          delegate: _YearPickerLayoutDelegate(),
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
    contentBuilder: (context) => TxCupertinoYearPicker(
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
  double? itemExtent,
  bool? useMagnifier,
  double? magnification,
  double? diameterRatio,
  TextStyle? textStyle,
  TextStyle? unselectedTextStyle,
  Color? unselectedColor,
  double? squeeze,
}) async {
  DateTime? result = initialMonth ?? DateTime.now();
  if (minimumMonth != null && result.isBefore(minimumMonth)) {
    result = minimumMonth;
  }

  if (maximumMonth != null && result.isAfter(maximumMonth)) {
    result = maximumMonth;
  }

  return await showDefaultBottomSheet<DateTime>(
    context,
    title: titleText ?? TxLocalizations.of(context).monthPickerTitle,
    elevation: 0,
    backgroundColor: Theme.of(context).colorScheme.surface,
    contentBuilder: (context) => TxCupertinoMonthPicker(
      initialMonth: result,
      minimumYear: minimumYear,
      maximumYear: maximumYear,
      minimumDate: minimumMonth,
      maximumDate: maximumMonth,
      backgroundColor: backgroundColor,
      onMonthChanged: (DateTime date) => result = date,
      dateOrder: dateOrder,
      itemExtent: itemExtent,
      useMagnifier: useMagnifier,
      magnification: magnification,
      diameterRatio: diameterRatio,
      textStyle: textStyle,
      unselectedColor: unselectedColor,
      unselectedTextStyle: unselectedTextStyle,
    ),
    onConfirm: () => Navigator.pop(context, result),
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
  double? itemExtent,
  bool? useMagnifier,
  double? magnification,
  double? diameterRatio,
  TextStyle? textStyle,
  TextStyle? unselectedTextStyle,
  Color? unselectedColor,
  double? squeeze,
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
    title: titleText ?? TxLocalizations.of(context).datetimePickerTitle,
    elevation: 0,
    backgroundColor: Theme.of(context).colorScheme.surface,
    contentBuilder: (context) => TxCupertinoDatetimePicker(
      initialDatetime: result,
      minimumDatetime: minimumDate,
      maximumDatetime: maximumDate,
      backgroundColor: backgroundColor,
      onDatetimeChanged: (DateTime datetime) => result = datetime,
      use24hFormat: true,
      itemExtent: itemExtent,
      useMagnifier: useMagnifier,
      magnification: magnification,
      diameterRatio: diameterRatio,
      textStyle: textStyle,
      unselectedColor: unselectedColor,
      unselectedTextStyle: unselectedTextStyle,
    ),
    onConfirm: () => Navigator.pop(context, result),
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
  double? itemExtent,
  bool? useMagnifier,
  double? magnification,
  double? diameterRatio,
  TextStyle? textStyle,
  TextStyle? unselectedTextStyle,
  Color? unselectedColor,
  double? squeeze,
}) async {
  DateTime? result = initialDate ?? DateTime.now();
  if (minimumDate != null && result.isBefore(minimumDate)) {
    result = minimumDate;
  }

  if (maximumDate != null && result.isAfter(maximumDate)) {
    result = maximumDate;
  }

  return await showDefaultBottomSheet<DateTime>(
    context,
    title: titleText ?? TxLocalizations.of(context).datePickerTitle,
    elevation: 0,
    backgroundColor: Theme.of(context).colorScheme.surface,
    contentBuilder: (context) => TxCupertinoDatePicker(
      initialDate: result,
      minimumYear: minimumYear,
      maximumYear: maximumYear,
      minimumDate: minimumDate,
      maximumDate: maximumDate,
      backgroundColor: backgroundColor,
      onDateChanged: (DateTime date) => result = date,
      dateOrder: dateOrder,
      itemExtent: itemExtent,
      useMagnifier: useMagnifier,
      magnification: magnification,
      diameterRatio: diameterRatio,
      textStyle: textStyle,
      unselectedColor: unselectedColor,
      unselectedTextStyle: unselectedTextStyle,
    ),
    onConfirm: () => Navigator.pop(context, result),
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
  double? itemExtent,
  bool? useMagnifier,
  double? magnification,
  double? diameterRatio,
  TextStyle? textStyle,
  TextStyle? unselectedTextStyle,
  Color? unselectedColor,
  double? squeeze,
}) async {
  minimumTime ??= const TimeOfDay(hour: 0, minute: 0);
  maximumTime ??= const TimeOfDay(hour: 23, minute: 59);
  TimeOfDay result = initialTime ?? TimeOfDay.now();
  return await showDefaultBottomSheet<TimeOfDay>(
    context,
    title: titleText ?? TxLocalizations.of(context).timePickerTitle,
    elevation: 0,
    backgroundColor: Theme.of(context).colorScheme.surface,
    contentBuilder: (context) => TxCupertinoTimePicker(
      initialTime: result.toDateTime(),
      minimumTime: minimumTime,
      maximumTime: maximumTime,
      backgroundColor: backgroundColor,
      onTimeChanged: (DateTime time) => result = TimeOfDay.fromDateTime(time),
      use24hFormat: true,
      itemExtent: itemExtent,
      useMagnifier: useMagnifier,
      magnification: magnification,
      diameterRatio: diameterRatio,
      textStyle: textStyle,
      unselectedColor: unselectedColor,
      unselectedTextStyle: unselectedTextStyle,
    ),
    onConfirm: () => Navigator.pop(context, result),
  );
}
