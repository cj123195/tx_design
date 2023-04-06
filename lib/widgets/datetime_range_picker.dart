import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../extensions/datetime_extension.dart';
import '../theme_extensions/spacing.dart';
import 'bottom_sheet.dart';

const String _format = 'yyyy-MM-dd HH:mm';

/// @title 时间区间选择器
/// @description 包活日期与时间选择
/// @updateTime 2022/11/09 1:40 下午
/// @author 曹骏
class DatetimeRangePicker extends StatefulWidget {
  DatetimeRangePicker({
    super.key,
    this.initialDatetimeRange,
    this.onDatetimeRangeChanged,
    this.firstDate,
    this.lastDate,
    this.actions,
    this.maximumTimeDifference,
    this.minimumTimeDifference,
    this.noticeText,
  })  : assert(
            minimumTimeDifference == null ||
                minimumTimeDifference.inMinutes >= 1,
            '时间差应大于一分钟'),
        assert(
            maximumTimeDifference == null ||
                maximumTimeDifference.inMinutes >= 1,
            '时间差应大于一分钟'),
        assert(
            firstDate == null ||
                lastDate == null ||
                minimumTimeDifference == null ||
                (lastDate.isAfter(firstDate) &&
                    lastDate.difference(firstDate) > minimumTimeDifference),
            '结束时间应遭遇开始时间且最小时间差应小于开始时间与结束时间差');

  /// 初始时间段
  final DateTimeRange? initialDatetimeRange;

  /// 开始时间，最小可选择时间
  final DateTime? firstDate;

  /// 结束时间，最大可选择时间
  final DateTime? lastDate;

  /// 按钮，展示在标题后的组件
  final List<Widget>? actions;

  /// 最大时间差
  final Duration? maximumTimeDifference;

  /// 最小时间差
  final Duration? minimumTimeDifference;

  /// 提示文字
  final String? noticeText;

  /// 时间变化回调
  final ValueChanged<DateTimeRange?>? onDatetimeRangeChanged;

  @override
  State<DatetimeRangePicker> createState() => _DatetimeRangePickerState();
}

class _DatetimeRangePickerState extends State<DatetimeRangePicker> {
  /// 输入控制器
  late TextEditingController _startController;
  late TextEditingController _endController;

  /// 输入框焦点
  late FocusNode _startNode;
  late FocusNode _endNode;

  /// 当前时间
  late DateTime? _startDate;
  late DateTime? _endDate;

  /// 计算结束时间最小可选择时间
  DateTime? get _minimumEndDatetime {
    DateTime? result = _startDate ?? widget.firstDate;
    if (widget.minimumTimeDifference != null) {
      result = result?.add(widget.minimumTimeDifference!);
    }
    return result;
  }

  /// 计算开始时间最小可选择时间
  DateTime? get _minimumStartDatetime {
    if (_endDate != null && widget.maximumTimeDifference != null) {
      final DateTime result = _endDate!.subtract(widget.maximumTimeDifference!);
      if (widget.firstDate == null) {
        return result;
      }
      return result.isAfter(widget.firstDate!) ? result : widget.firstDate;
    }
    return widget.firstDate;
  }

  /// 计算结束时间最大可选择时间
  DateTime? get _maximumEndDatetime {
    if (_startDate != null && widget.maximumTimeDifference != null) {
      final DateTime result = _startDate!.add(widget.maximumTimeDifference!);
      if (widget.lastDate == null) {
        return result;
      }
      return result.isBefore(widget.lastDate!) ? result : widget.lastDate;
    }
    return widget.lastDate;
  }

  /// 计算开始时间最大可选择时间
  DateTime? get _maximumStartDatetime {
    DateTime? result = _endDate ?? widget.lastDate;
    if (widget.minimumTimeDifference != null) {
      result = result?.subtract(widget.minimumTimeDifference!);
    }
    return result;
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
      DateTime start = end;
      if (widget.minimumTimeDifference != null) {
        start = end.subtract(widget.minimumTimeDifference!);
      }
      result = DateTimeRange(start: start, end: end);
    } else if (start != null && end == null) {
      DateTime end = start;
      if (widget.minimumTimeDifference != null) {
        end = start.add(widget.minimumTimeDifference!);
      }
      result = DateTimeRange(start: start, end: end);
    } else if (start != null && end != null) {
      result = DateTimeRange(start: start, end: end);
    }
    widget.onDatetimeRangeChanged?.call(result);
  }

  /// 提示文字
  String? get _noticeText {
    if (widget.noticeText != null) {
      return widget.noticeText;
    }
    if (widget.minimumTimeDifference == null &&
        widget.maximumTimeDifference == null) {
      return null;
    }
    String notice = '开始时间与结束时间差需';
    if (widget.minimumTimeDifference != null) {
      notice = '$notice大于${_durationText(widget.minimumTimeDifference!)}';
    }
    if (widget.maximumTimeDifference != null) {
      notice = '$notice小于${_durationText(widget.maximumTimeDifference!)}';
    }
    return notice;
  }

  /// 生成时间差对应的文字
  String _durationText(Duration duration) {
    if (duration.inDays >= 1) {
      return '${duration.inDays}日';
    } else if (duration.inHours >= 1) {
      return '${duration.inHours}小时';
    }
    return '${duration.inHours}分钟';
  }

  @override
  void initState() {
    _startDate = widget.initialDatetimeRange?.start;
    _endDate = widget.initialDatetimeRange?.end;
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
    final SpacingThemeData spacingTheme = theme.extension<SpacingThemeData>()!;
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
          padding: spacingTheme.horizontalMedium,
          child: Text('至', style: textTheme.bodyMedium),
        ),
        Expanded(
          child: _buildTextField(_endController, _endNode, '结束时间'),
        ),
      ],
    );

    /// 提示文字
    final String? noticeText = _noticeText;

    /// 时间选择器
    DateTime? minimum;
    DateTime? maximum;
    DateTime? initialDatetime;
    if (_endNode.hasFocus) {
      minimum = _minimumEndDatetime;
      maximum = _maximumEndDatetime;
      initialDatetime = _endDate ?? maximum ?? minimum;
    } else {
      minimum = _minimumStartDatetime;
      maximum = _maximumStartDatetime;
      initialDatetime = _startDate ?? maximum ?? minimum;
    }
    final Widget datePicker = Padding(
      padding: spacingTheme.verticalLargest,
      child: CupertinoDatePicker(
        onDateTimeChanged: (date) {
          if (_startNode.hasFocus) {
            _onDateChanged(date, _endDate);
          } else if (_endNode.hasFocus) {
            _onDateChanged(_startDate, date);
          }
        },
        use24hFormat: true,
        mode: CupertinoDatePickerMode.dateAndTime,
        maximumDate: maximum,
        minimumDate: minimum,
        maximumYear: maximum?.year,
        minimumYear: minimum?.year ?? 1970,
        initialDateTime: initialDatetime,
      ),
    );

    return Padding(
      padding: spacingTheme.horizontalMedium,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          customTitle,
          textFields,
          SizedBox(height: spacingTheme.medium),
          if (noticeText != null)
            Text(
              noticeText,
              textAlign: TextAlign.center,
              style: textTheme.bodySmall?.copyWith(color: Colors.orange),
            ),
          Expanded(child: datePicker),
        ],
      ),
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

Future<DateTimeRange?> showDatetimeRangePicker(
  BuildContext context, {
  DateTimeRange? initialDatetimeRange,
  DateTime? firstDate,
  DateTime? lastDate,
  Duration? maximumTimeDifference,
  Duration? minimumTimeDifference,
  String? noticeText,
  String? title,
}) async {
  return await Navigator.of(context).push(
    TxModalBottomSheetRoute(
      context,
      builder: (_) {
        DateTimeRange? result;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              title: Text(title ?? '时间段选择'),
              trailing: const CloseButton(),
              contentPadding: const EdgeInsets.only(left: 12.0),
            ),
            Expanded(
              child: DatetimeRangePicker(
                onDatetimeRangeChanged: (dateRange) => result = dateRange,
                firstDate: firstDate,
                lastDate: lastDate,
                initialDatetimeRange: initialDatetimeRange,
                minimumTimeDifference: minimumTimeDifference,
                maximumTimeDifference: maximumTimeDifference,
                noticeText: noticeText,
              ),
            ),
            Padding(
              padding: Theme.of(context)
                  .extension<SpacingThemeData>()!
                  .edgeInsetsMedium,
              child: FilledButton(
                onPressed: () => Navigator.pop(context, result),
                child: const Text('确定'),
              ),
            )
          ],
        );
      },
    ),
  );
}
