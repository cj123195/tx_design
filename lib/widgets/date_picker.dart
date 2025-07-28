import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

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

abstract class TxCupertinoPicker<T> extends StatefulWidget {
  /// Constructs an iOS style date picker.
  const TxCupertinoPicker({
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
        diameterRatio = diameterRatio ?? _kDiameterRatio;

  /// The initial date and/or time of the picker. Defaults to the present date
  /// and time. The present must conform to the intervals set in [minimumValue],
  /// [maximumValue].
  ///
  /// Changing this value after the initial build will not affect the currently
  /// selected date time.
  final T? initialValue;

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
  final T? minimumValue;

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
  final T? maximumValue;

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
  final ValueChanged<T> onChanged;

  @override
  State<TxCupertinoPicker<T>> createState();
}

abstract class _CupertinoPickerState<T> extends State<TxCupertinoPicker<T>> {
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
class TxCupertinoMonthPicker extends TxCupertinoPicker<DateTime> {
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
        ) {
    {
      assert(
        minimumValue == null ||
            maximumValue == null ||
            minimumValue!.isBefore(maximumValue!),
        'minimumValue must before than maximumValue',
      );
      assert(
        itemExtent > 0,
        'item extent should be greater than 0',
      );
    }
  }

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
  State<TxCupertinoPicker<DateTime>> createState() =>
      _CupertinoMonthPickerState();
}

class _CupertinoMonthPickerState extends _CupertinoPickerState<DateTime> {
  DateTime get _initialDate {
    final DateTime now = widget.initialValue ?? DateTime.now();
    if (widget.minimumValue != null && now.isBefore(widget.minimumValue!)) {
      return widget.minimumValue!;
    }
    if (widget.maximumValue != null && now.isAfter(widget.maximumValue!)) {
      return widget.maximumValue!;
    }
    return now;
  }

  @override
  TxCupertinoMonthPicker get widget => super.widget as TxCupertinoMonthPicker;

  DatePickerDateOrder? get dateOrder => widget.dateOrder;

  DateTime get minSelectedDate => DateTime(selectedYear, selectedMonth);

  DateTime get maxSelectedDate =>
      DateTime(selectedYear, selectedMonth, _initialDate.day + 1);

  bool get minCheck => widget.minimumValue?.isBefore(minSelectedDate) ?? true;

  bool get maxCheck => widget.maximumValue?.isBefore(maxSelectedDate) ?? false;

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

  @override
  void didUpdateWidget(covariant TxCupertinoPicker<DateTime> oldWidget) {
    if (widget.initialValue != currentSelectedDate) {}
    super.didUpdateWidget(oldWidget);
  }

  void _refreshEstimatedColumnWidths() {
    estimatedColumnWidths[_PickerColumnType.month.index] = _getColumnWidth(
        _PickerColumnType.month, localizations, context, widget.showDayOfWeek);
    estimatedColumnWidths[_PickerColumnType.year.index] = _getColumnWidth(
        _PickerColumnType.year, localizations, context, widget.showDayOfWeek);
  }

  Widget _buildMonthPicker(
    double offAxisFraction,
    TransitionBuilder itemPositioningBuilder,
    Widget selectionOverlay,
  ) {
    void onSelectedChanged(int index) {
      selectedMonth = index + 1;
      if (_isCurrentDateValid) {
        widget.onChanged(currentSelectedDate);
      }
    }

    final List<Widget> children = List<Widget>.generate(12, (int index) {
      final int month = index + 1;
      final bool isInvalidMonth = _isMonthInvalid(month);
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

          final bool isValidYear = _isYearValid(year);

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

  bool _isYearValid(int year) {
    return (widget.minimumValue == null || widget.minimumValue!.year <= year) &&
        (widget.maximumValue == null || widget.maximumValue!.year >= year);
  }

  bool _isMonthInvalid(int month) {
    if (widget.minimumValue == null && widget.maximumValue == null) {
      return false;
    }

    if (!_isYearValid(selectedYear)) {
      return month != selectedMonth;
    }

    return (widget.minimumValue?.year == selectedYear &&
            widget.minimumValue!.month > month) ||
        (widget.maximumValue?.year == selectedYear &&
            widget.maximumValue!.month < month);
  }

  bool get _isCurrentDateValid => minCheck && !maxCheck;

  // One or more pickers have just stopped scrolling.
  @override
  void _pickerDidStopScrolling() {
    // Call setState to update the greyed out days/months/years, as the currently
    // selected year/month may have changed.
    setState(() {});

    if (isScrolling) {
      return;
    }

    final bool minCheck = this.minCheck;
    final bool maxCheck = this.maxCheck;

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
  State<TxCupertinoPicker<DateTime>> createState() =>
      _CupertinoDatePickerState();
}

class _CupertinoDatePickerState extends _CupertinoMonthPickerState {
  @override
  TxCupertinoDatePicker get widget => super.widget as TxCupertinoDatePicker;

  @override
  DateTime get minSelectedDate =>
      DateTime(selectedYear, selectedMonth, selectedDay);

  @override
  DateTime get maxSelectedDate =>
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
      final bool isInvalidDay = _isDayInvalid(day);

      return itemPositioningBuilder(
        context,
        Text(
          localizations.datePickerDayOfMonth(day, dayOfWeek),
          style: _themeTextStyle(!isInvalidDay && day <= daysInCurrentMonth),
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

  bool _isDayInvalid(int day) {
    if (widget.minimumValue == null && widget.maximumValue == null) {
      return false;
    }

    if (!_isYearValid(selectedYear) || _isMonthInvalid(selectedMonth)) {
      return day != selectedDay;
    }

    return (widget.minimumValue?.year == selectedYear &&
            widget.minimumValue!.month == selectedMonth &&
            widget.minimumValue!.day > day) ||
        (widget.maximumValue?.year == selectedYear &&
            widget.maximumValue!.month == selectedMonth &&
            widget.maximumValue!.day < day);
  }

  @override
  bool get _isCurrentDateValid =>
      super._isCurrentDateValid && minSelectedDate.day == selectedDay;

  // One or more pickers have just stopped scrolling.
  @override
  void _pickerDidStopScrolling() {
    // Call setState to update the greyed out days/months/years, as the currently
    // selected year/month may have changed.
    setState(() {});

    if (isScrolling) {
      return;
    }

    final bool minCheck = this.minCheck;
    final bool maxCheck = this.maxCheck;

    if (!minCheck || maxCheck) {
      // We have minCheck === !maxCheck.
      final DateTime targetDate =
          minCheck ? widget.maximumValue! : widget.minimumValue!;
      _scrollToDate(targetDate);
      return;
    }

    // Some months have less days (e.g. February). Go to the last day of that
    // month if the selectedDay exceeds the maximum.
    if (minSelectedDate.day != selectedDay) {
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

/// 日期时间选择器
/// 日期时间选择器
class TxCupertinoDatetimePicker extends TxCupertinoDatePicker {
  /// Constructs an iOS style date time picker.
  ///
  /// [onDatetimeChanged] is the callback called when the selected date or time
  /// changes. This callback will always report the complete DateTime including
  /// date and time components.
  ///
  /// [initialDatetime] is the initial date time of the picker. Defaults to the
  /// present date and time. The present must conform to the intervals set in
  /// [minimumDatetime], [maximumDatetime], [minimumYear], and [maximumYear].
  ///
  /// [showSeconds] determines whether the seconds picker is shown. Defaults to
  /// true.
  ///
  /// [minuteInterval] is the granularity of the minute picker. Must be a
  /// positive integer and a factor of 60. Defaults to 1.
  ///
  /// [secondInterval] is the granularity of the second picker. Must be a
  /// positive integer and a factor of 60. Defaults to 1.
  TxCupertinoDatetimePicker({
    required ValueChanged<DateTime> onDatetimeChanged,
    super.key,
    DateTime? initialDatetime,
    DateTime? minimumDatetime,
    DateTime? maximumDatetime,
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
    bool? showSeconds,
    int? minuteInterval,
    int? secondInterval,
  })  : showSeconds = showSeconds ?? false,
        minuteInterval = minuteInterval ?? 1,
        secondInterval = secondInterval ?? 1,
        assert(
            minuteInterval == null ||
                (minuteInterval > 0 && 60 % minuteInterval == 0),
            'minuteInterval must be a positive integer and a factor of 60'),
        assert(
            secondInterval == null ||
                (secondInterval > 0 && 60 % secondInterval == 0),
            'secondInterval must be a positive integer and a factor of 60'),
        super(
          initialDate: initialDatetime,
          onDateChanged: onDatetimeChanged,
          minimumDate: minimumDatetime,
          maximumDate: maximumDatetime,
        );

  /// Whether to show the seconds picker. Defaults to true.
  final bool showSeconds;

  /// The granularity of the minute picker. Must be a positive integer and a
  /// factor of 60. Defaults to 1.
  final int minuteInterval;

  /// The granularity of the second picker. Must be a positive integer and a
  /// factor of 60. Defaults to 1.
  final int secondInterval;

  @override
  State<TxCupertinoPicker<DateTime>> createState() =>
      _CupertinoDatetimePickerState();
}

class _CupertinoDatetimePickerState extends _CupertinoDatePickerState {
  @override
  TxCupertinoDatetimePicker get widget =>
      super.widget as TxCupertinoDatetimePicker;

  @override
  DateTime get minSelectedDate => DateTime(
        selectedYear,
        selectedMonth,
        selectedDay,
        selectedHour,
        selectedMinute,
        selectedSecond,
      );

  @override
  DateTime get maxSelectedDate => DateTime(
        selectedYear,
        selectedMonth,
        selectedDay,
        selectedHour,
        selectedMinute,
        selectedSecond + 1,
      );

  @override
  DateTime get currentSelectedDate => DateTime(
        selectedYear,
        selectedMonth,
        selectedDay,
        selectedHour,
        selectedMinute,
        selectedSecond,
      );

  // The currently selected values of the time picker.
  late int selectedHour;
  late int selectedMinute;
  late int selectedSecond;

  // The controllers of the time pickers.
  late FixedExtentScrollController hourController;
  late FixedExtentScrollController minuteController;
  late FixedExtentScrollController secondController;

  bool isHourPickerScrolling = false;
  bool isMinutePickerScrolling = false;
  bool isSecondPickerScrolling = false;

  @override
  bool get isScrolling =>
      isHourPickerScrolling ||
      isMinutePickerScrolling ||
      isSecondPickerScrolling ||
      super.isScrolling;

  @override
  void initState() {
    super.initState();
    final DateTime initialDate = _initialDate;
    selectedHour = initialDate.hour;
    selectedMinute = initialDate.minute;
    selectedSecond = initialDate.second;

    hourController = FixedExtentScrollController(
      initialItem: selectedHour,
    );
    minuteController = FixedExtentScrollController(
      initialItem: selectedMinute ~/ widget.minuteInterval,
    );
    secondController = FixedExtentScrollController(
      initialItem: selectedSecond ~/ widget.secondInterval,
    );
  }

  @override
  void dispose() {
    hourController.dispose();
    minuteController.dispose();
    secondController.dispose();
    super.dispose();
  }

  @override
  void _refreshEstimatedColumnWidths() {
    super._refreshEstimatedColumnWidths();
    estimatedColumnWidths[_PickerColumnType.hour.index] = _getColumnWidth(
      _PickerColumnType.hour,
      localizations,
      context,
      widget.showDayOfWeek,
    );
    estimatedColumnWidths[_PickerColumnType.minute.index] = _getColumnWidth(
      _PickerColumnType.minute,
      localizations,
      context,
      widget.showDayOfWeek,
    );
    if (widget.showSeconds) {
      estimatedColumnWidths[_PickerColumnType.minute.index] = _getColumnWidth(
        _PickerColumnType.minute,
        localizations,
        context,
        widget.showDayOfWeek,
      );
    }
  }

  Widget _buildHourPicker(double offAxisFraction,
      TransitionBuilder itemPositioningBuilder, Widget selectionOverlay) {
    void onSelectedChanged(int index) {
      selectedHour = index;
      if (_isCurrentDateValid) {
        widget.onChanged(currentSelectedDate);
      }
    }

    final List<Widget> children = List<Widget>.generate(24, (int index) {
      final bool isInvalid = _isHourInvalid(index);

      return itemPositioningBuilder(
        context,
        Text(
          localizations.datePickerHour(index),
          style: _themeTextStyle(!isInvalid),
        ),
      );
    });

    return _buildPicker(
      offAxisFraction,
      itemPositioningBuilder,
      selectionOverlay,
      (val) => isHourPickerScrolling = val,
      hourController,
      onSelectedChanged,
      children,
    );
  }

  Widget _buildMinutePicker(double offAxisFraction,
      TransitionBuilder itemPositioningBuilder, Widget selectionOverlay) {
    final int minuteCount = 60 ~/ widget.minuteInterval;

    void onSelectedChanged(int index) {
      selectedMinute = index * widget.minuteInterval;
      if (_isCurrentDateValid) {
        widget.onChanged(currentSelectedDate);
      }
    }

    final List<Widget> children =
        List<Widget>.generate(minuteCount, (int index) {
      final int minute = index * widget.minuteInterval;
      final bool isInvalid = _isMinuteInvalid(minute);

      return itemPositioningBuilder(
        context,
        Text(
          localizations.datePickerMinute(minute),
          style: _themeTextStyle(!isInvalid),
        ),
      );
    });

    return _buildPicker(
      offAxisFraction,
      itemPositioningBuilder,
      selectionOverlay,
      (val) => isMinutePickerScrolling = val,
      minuteController,
      onSelectedChanged,
      children,
    );
  }

  Widget _buildSecondPicker(double offAxisFraction,
      TransitionBuilder itemPositioningBuilder, Widget selectionOverlay) {
    final int secondCount = 60 ~/ widget.secondInterval;

    void onSelectedChanged(int index) {
      selectedSecond = index * widget.secondInterval;
      if (_isCurrentDateValid) {
        widget.onChanged(currentSelectedDate);
      }
    }

    final List<Widget> children =
        List<Widget>.generate(secondCount, (int index) {
      final int second = index * widget.secondInterval;

      final bool isInvalid = _isSecondInvalid(second);

      return itemPositioningBuilder(
        context,
        Text(
          localizations.datePickerMinute(second), // 使用 minute 格式化函数，因为秒的格式和分钟相同
          style: _themeTextStyle(!isInvalid),
        ),
      );
    });

    return _buildPicker(
      offAxisFraction,
      itemPositioningBuilder,
      selectionOverlay,
      (val) => isSecondPickerScrolling = val,
      secondController,
      onSelectedChanged,
      children,
    );
  }

  bool _isHourInvalid(int hour) {
    if (widget.minimumValue == null && widget.maximumValue == null) {
      return false;
    }

    if (!_isYearValid(selectedYear) ||
        _isMonthInvalid(selectedMonth) ||
        _isDayInvalid(selectedDay)) {
      return hour != selectedHour;
    }

    return (widget.minimumValue?.year == selectedYear &&
            widget.minimumValue!.month == selectedMonth &&
            widget.minimumValue!.day == selectedDay &&
            widget.minimumValue!.hour > hour) ||
        (widget.maximumValue?.year == selectedYear &&
            widget.maximumValue!.month == selectedMonth &&
            widget.maximumValue!.day == selectedDay &&
            widget.maximumValue!.hour < hour);
  }

  bool _isMinuteInvalid(int minute) {
    if (widget.minimumValue == null && widget.maximumValue == null) {
      return false;
    }

    if (!_isYearValid(selectedYear) ||
        _isMonthInvalid(selectedMonth) ||
        _isDayInvalid(selectedDay) ||
        _isHourInvalid(selectedHour)) {
      return minute != selectedMinute;
    }

    return (widget.minimumValue?.year == selectedYear &&
            widget.minimumValue!.month == selectedMonth &&
            widget.minimumValue!.day == selectedDay &&
            widget.minimumValue!.hour == selectedHour &&
            widget.minimumValue!.minute > minute) ||
        (widget.maximumValue?.year == selectedYear &&
            widget.maximumValue!.month == selectedMonth &&
            widget.maximumValue!.day == selectedDay &&
            widget.maximumValue!.hour == selectedHour &&
            widget.maximumValue!.minute < minute);
  }

  bool _isSecondInvalid(int second) {
    if (widget.minimumValue == null && widget.maximumValue == null) {
      return false;
    }

    if (!_isYearValid(selectedYear) ||
        _isMonthInvalid(selectedMonth) ||
        _isDayInvalid(selectedDay) ||
        _isHourInvalid(selectedHour) ||
        _isMinuteInvalid(selectedMinute)) {
      return second != selectedSecond;
    }

    return (widget.minimumValue?.year == selectedYear &&
            widget.minimumValue!.month == selectedMonth &&
            widget.minimumValue!.day == selectedDay &&
            widget.minimumValue!.hour == selectedHour &&
            widget.minimumValue!.minute == selectedMinute &&
            widget.minimumValue!.second > second) ||
        (widget.maximumValue?.year == selectedYear &&
            widget.maximumValue!.month == selectedMonth &&
            widget.maximumValue!.day == selectedDay &&
            widget.maximumValue!.hour == selectedHour &&
            widget.maximumValue!.minute == selectedMinute &&
            widget.maximumValue!.second < second);
  }

  @override
  bool get _isCurrentDateValid =>
      super._isCurrentDateValid &&
      minSelectedDate.hour == selectedHour &&
      minSelectedDate.minute == selectedMinute &&
      minSelectedDate.second == selectedSecond;

  @override
  void _scrollToDate(DateTime newDate) {
    super._scrollToDate(newDate);
    SchedulerBinding.instance.addPostFrameCallback((Duration timestamp) {
      if (selectedHour != newDate.hour) {
        final int targetHour = newDate.hour;
        _animateColumnControllerToItem(hourController, targetHour);
      }

      if (selectedMinute != newDate.minute) {
        _animateColumnControllerToItem(
            minuteController, newDate.minute ~/ widget.minuteInterval);
      }

      if (selectedSecond != newDate.second) {
        _animateColumnControllerToItem(
            secondController, newDate.second ~/ widget.secondInterval);
      }
    }, debugLabel: 'DateTimePicker.scrollToDate');
  }

  @override
  (List<Widget>, List<double>, double) get pickerConfig {
    List<_ColumnBuilder> pickerBuilders = <_ColumnBuilder>[];
    List<double> columnWidths = <double>[];

    // 添加日期选择器
    final DatePickerDateOrder datePickerDateOrder =
        dateOrder ?? localizations.datePickerDateOrder;

    switch (datePickerDateOrder) {
      case DatePickerDateOrder.mdy:
        pickerBuilders = <_ColumnBuilder>[
          _buildMonthPicker,
          _buildDayPicker,
          _buildYearPicker,
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
          _buildYearPicker,
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
          _buildDayPicker,
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
          _buildMonthPicker,
        ];
        columnWidths = <double>[
          estimatedColumnWidths[_PickerColumnType.year.index]!,
          estimatedColumnWidths[_PickerColumnType.dayOfMonth.index]!,
          estimatedColumnWidths[_PickerColumnType.month.index]!,
        ];
    }

    // 添加时间选择器
    pickerBuilders.add(_buildHourPicker);
    columnWidths.add(estimatedColumnWidths[_PickerColumnType.hour.index]!);

    pickerBuilders.add(_buildMinutePicker);
    columnWidths.add(estimatedColumnWidths[_PickerColumnType.minute.index]!);

    if (widget.showSeconds) {
      pickerBuilders.add(_buildSecondPicker);
      columnWidths.add(estimatedColumnWidths[_PickerColumnType.minute.index]!);
    }

    final List<Widget> pickers = <Widget>[];
    double totalColumnWidths = (columnWidths.length + 1) * _kDatePickerPadSize;

    for (int i = 0; i < columnWidths.length; i++) {
      final double offAxisFraction =
          (i - (columnWidths.length - 1) / 2) * 0.1 * textDirectionFactor;

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
class TxCupertinoTimePicker extends TxCupertinoPicker<TimeOfDay> {
  TxCupertinoTimePicker({
    required ValueChanged<TimeOfDay> onTimeChanged,
    TimeOfDay? initialTime,
    TimeOfDay? minimumTime,
    TimeOfDay? maximumTime,
    this.minuteInterval = 1,
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
  }) : super(
          initialValue: initialTime,
          onChanged: onTimeChanged,
          minimumValue: minimumTime,
          maximumValue: maximumTime,
        ) {
    assert(
      initialValue == null || initialValue!.minute % minuteInterval == 0,
      'initial minute is not divisible by minute interval',
    );
  }

  /// The granularity of the minutes spinner, if it is shown in the current
  /// mode. Must be an integer factor of 60.
  final int minuteInterval;

  @override
  State<TxCupertinoPicker<TimeOfDay>> createState() =>
      _CupertinoTimePickerState();
}

class _CupertinoTimePickerState extends _CupertinoPickerState<TimeOfDay> {
  TimeOfDay get _initialTime {
    final TimeOfDay now = widget.initialValue ?? TimeOfDay.now();
    if (widget.minimumValue != null && now.isBefore(widget.minimumValue!)) {
      return widget.minimumValue!;
    }
    if (widget.maximumValue != null && now.isAfter(widget.maximumValue!)) {
      return widget.maximumValue!;
    }
    return now;
  }

  @override
  TxCupertinoTimePicker get widget => super.widget as TxCupertinoTimePicker;

  // Fraction of the farthest column's vanishing point vs its width. Eyeballed
  // vs iOS.
  static const double _kMaximumOffAxisFraction = 0.45;

  // Read this out when the state is initially created. Changes in
  // initialTime in the widget after first build is ignored.
  late TimeOfDay initialTime;

  int get selectedHour => hourController.hasClients
      ? hourController.selectedItem % 24
      : initialTime.hour;

  // The controller of the hour column.
  late FixedExtentScrollController hourController;

  // The current selection of the minute picker. Values range from 0 to 59.
  int get selectedMinute {
    return minuteController.hasClients
        ? minuteController.selectedItem * widget.minuteInterval % 60
        : initialTime.minute;
  }

  // The controller of the minute column.
  late FixedExtentScrollController minuteController;

  bool isHourPickerScrolling = false;
  bool isMinutePickerScrolling = false;
  bool isMeridiemPickerScrolling = false;

  bool get isScrolling {
    return isHourPickerScrolling ||
        isMinutePickerScrolling ||
        isMeridiemPickerScrolling;
  }

  // The estimated width of columns.
  final Map<int, double> estimatedColumnWidths = <int, double>{};

  @override
  void initState() {
    super.initState();
    initialTime = _initialTime;

    // Initially each of the "physical" regions is mapped to the meridiem region
    // with the same number, e.g., the first 12 items are mapped to the first 12
    // hours of a day. Such mapping is flipped when the meridiem picker is
    // scrolled by the user, the first 12 items are mapped to the last 12 hours
    // of a day.

    hourController = FixedExtentScrollController(initialItem: initialTime.hour);
    minuteController = FixedExtentScrollController(
        initialItem: initialTime.minute ~/ widget.minuteInterval);

    PaintingBinding.instance.systemFonts.addListener(_handleSystemFontsChange);
  }

  void _handleSystemFontsChange() {
    setState(estimatedColumnWidths.clear);
  }

  @override
  void dispose() {
    hourController.dispose();
    minuteController.dispose();

    PaintingBinding.instance.systemFonts
        .removeListener(_handleSystemFontsChange);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    estimatedColumnWidths.clear();
  }

  // Lazily calculate the column width of the column being displayed only.
  double _getEstimatedColumnWidth(_PickerColumnType columnType) {
    if (estimatedColumnWidths[columnType.index] == null) {
      estimatedColumnWidths[columnType.index] =
          _getColumnWidth(columnType, localizations, context, false);
    }

    return estimatedColumnWidths[columnType.index]!;
  }

  // Gets the current date time of the picker.
  TimeOfDay get selectedTime {
    return TimeOfDay(
      hour: selectedHour,
      minute: selectedMinute,
    );
  }

  // Only reports datetime change when the date time is valid.
  void _onSelectedItemChange(int index) {
    final TimeOfDay selected = selectedTime;

    final bool isTimeInvalid =
        _isInvalidHour(selected.hour) || _isInvalidMinute(selected.minute);

    if (isTimeInvalid) {
      return;
    }

    widget.onChanged(selected);
  }

  // With the meridiem picker set to `meridiemIndex`, and the hour picker set to
  // `hourIndex`, is it possible to change the value of the minute picker, so
  // that the resulting date stays in the valid range.
  bool _isInvalidHour(int hour) {
    return (widget.minimumValue != null && widget.minimumValue!.hour > hour) ||
        (widget.maximumValue != null && widget.maximumValue!.hour < hour);
  }

  bool _isInvalidMinute(int minute) {
    if (widget.minimumValue == null && widget.maximumValue == null) {
      return false;
    }

    if (_isInvalidHour(selectedHour)) {
      return minute != selectedMinute;
    }

    return (widget.minimumValue?.hour == selectedHour &&
            widget.minimumValue!.minute > minute) ||
        (widget.maximumValue!.hour == selectedHour &&
            widget.maximumValue!.minute < minute);
  }

  Widget _buildHourPicker(
    double offAxisFraction,
    TransitionBuilder itemPositioningBuilder,
    Widget selectionOverlay,
  ) {
    final List<Widget> children = List<Widget>.generate(24, (int index) {
      return itemPositioningBuilder(
        context,
        Text(
          localizations.datePickerHour(index),
          semanticsLabel: localizations.datePickerHourSemanticsLabel(index),
          style: _themeTextStyle(!_isInvalidHour(index)),
        ),
      );
    });

    return _buildPicker(
      offAxisFraction,
      itemPositioningBuilder,
      selectionOverlay,
      (val) => isHourPickerScrolling = val,
      hourController,
      _onSelectedItemChange,
      children,
    );
  }

  Widget _buildMinutePicker(double offAxisFraction,
      TransitionBuilder itemPositioningBuilder, Widget selectionOverlay) {
    final List<Widget> children =
        List<Widget>.generate(60 ~/ widget.minuteInterval, (int index) {
      final int minute = index * widget.minuteInterval;

      final bool isInvalidMinute = _isInvalidMinute(minute);

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
    final TimeOfDay selectedTime =
        TimeOfDay(hour: selectedHour, minute: selectedMinute);

    final bool minCheck = widget.minimumValue?.isAfter(selectedTime) ?? false;
    final bool maxCheck = widget.maximumValue?.isBefore(selectedTime) ?? false;

    if (minCheck || maxCheck) {
      // We have minCheck === !maxCheck.
      final TimeOfDay targetTime =
          minCheck ? widget.minimumValue! : widget.maximumValue!;
      _scrollToTime(targetTime, selectedTime, minCheck);
    }
  }

  void _scrollToTime(TimeOfDay newTime, TimeOfDay fromTime, bool minCheck) {
    SchedulerBinding.instance.addPostFrameCallback((Duration timestamp) {
      if (fromTime.hour != newTime.hour) {
        _animateColumnControllerToItem(
          hourController,
          hourController.selectedItem + newTime.hour - fromTime.hour,
        );
      }

      if (fromTime.minute != newTime.minute) {
        final double positionDouble = newTime.minute / widget.minuteInterval;
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

  bool get isCurrentYearValid => minCheck && maxCheck;

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
  bool? showSeconds,
  int? minuteInterval,
  int? secondInterval,
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
      itemExtent: itemExtent,
      useMagnifier: useMagnifier,
      magnification: magnification,
      diameterRatio: diameterRatio,
      textStyle: textStyle,
      unselectedColor: unselectedColor,
      unselectedTextStyle: unselectedTextStyle,
      showSeconds: showSeconds,
      minuteInterval: minuteInterval,
      secondInterval: secondInterval,
      minimumYear: minimumYear,
      maximumYear: maximumYear,
      squeeze: squeeze,
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
      initialTime: result,
      minimumTime: minimumTime,
      maximumTime: maximumTime,
      backgroundColor: backgroundColor,
      onTimeChanged: (TimeOfDay time) => result = time,
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
