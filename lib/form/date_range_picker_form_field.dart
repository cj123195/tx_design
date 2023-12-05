import 'package:flutter/material.dart';

import '../extensions/datetime_extension.dart';
import '../localizations.dart';
import '../utils/basic_types.dart';
import '../widgets/date_range_picker.dart';
import 'form_field.dart';
import 'form_item_container.dart';

const EdgeInsetsGeometry _kFieldsPadding =
    EdgeInsets.symmetric(horizontal: 12.0);

/// 日期范围选择组件
class DateRangePickerFormField extends TxFormFieldItem<DateTimeRange> {
  DateRangePickerFormField({
    this.format = 'yyyy-MM-dd',
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
    super.key,
    super.onSaved,
    super.validator,
    super.initialValue,
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    super.defaultValidator,
    super.required,
    super.label,
    super.labelText,
    super.backgroundColor,
    super.direction,
    super.padding,
    List<Widget>? actions,
    super.labelStyle,
    super.starStyle,
    super.horizontalGap,
    super.minLabelWidth,
    InputDecoration decoration = const InputDecoration(),
    TextStyle? style,
    StrutStyle? strutStyle,
    TextDirection? textDirection,
    TextAlign textAlign = TextAlign.center,
    TextAlignVertical? textAlignVertical,
    EditableTextContextMenuBuilder? contextMenuBuilder,
    ValueChanged<DateTimeRange?>? onChanged,
    PickerFuture<DateTimeRange?>? onTap,
  }) : super(
          builder: (FormFieldState<DateTimeRange> field) {
            final _DateRangePickerFormFieldState state =
                field as _DateRangePickerFormFieldState;
            final MaterialLocalizations localizations =
                MaterialLocalizations.of(field.context);
            final TxLocalizations txLocalizations =
                TxLocalizations.of(field.context);

            void onChangedHandler(DateTimeRange? value) {
              field.didChange(value);
              if (onChanged != null) {
                onChanged(value);
              }
            }

            Future<void> onPick() async {
              final FocusScopeNode currentFocus = FocusScope.of(state.context);
              if (!currentFocus.hasPrimaryFocus &&
                  currentFocus.focusedChild != null) {
                FocusManager.instance.primaryFocus?.unfocus();
              }
              DateTimeRange? range;
              if (onTap != null) {
                range = await onTap(state.context, state.value);
              } else {
                range = await showDateRangePickerDialog(
                  state.context,
                  firstDate: firstDate,
                  lastDate: lastDate,
                  initialDateRange: state.value,
                  helpText: helpText,
                  quickChoices: quickChoices,
                  fieldEndHintText: fieldEndHintText,
                  fieldStartHintText: fieldStartHintText,
                );
              }
              if (range == null || range == state.value) {
                return;
              }
              onChangedHandler.call(range);
            }

            final InputDecoration effectiveStartDecoration =
                FormItemContainer.createDecoration(
              field.context,
              decoration,
              hintText: fieldStartHintText ?? localizations.dateRangeStartLabel,
              errorText: field.errorText,
            );

            final Widget startField = TextField(
              restorationId: restorationId,
              controller: state._effectiveStartController,
              decoration: effectiveStartDecoration,
              style: style,
              strutStyle: strutStyle,
              textAlign: textAlign,
              textAlignVertical: textAlignVertical,
              textDirection: textDirection,
              contextMenuBuilder: contextMenuBuilder,
              readOnly: true,
              onTap: onPick,
              enabled: enabled,
            );

            final InputDecoration effectiveEndDecoration =
                FormItemContainer.createDecoration(
              field.context,
              decoration,
              hintText: fieldEndHintText ?? localizations.dateRangeEndLabel,
            );
            final Widget endField = TextField(
              restorationId: restorationId,
              controller: state._effectiveEndController,
              decoration: effectiveEndDecoration,
              style: style,
              strutStyle: strutStyle,
              textAlign: textAlign,
              textAlignVertical: textAlignVertical,
              textDirection: textDirection,
              contextMenuBuilder: contextMenuBuilder,
              readOnly: true,
              onTap: onPick,
              enabled: enabled,
            );

            final Widget formField = Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(child: startField),
                Padding(
                  padding:
                      effectiveEndDecoration.contentPadding ?? _kFieldsPadding,
                  child: Text(txLocalizations.dateRangeDateSeparator),
                ),
                Expanded(child: endField),
              ],
            );

            return formField;
          },
          actionsBuilder: (field) => actions,
        );

  final String? format;

  @override
  TxFormFieldState<DateTimeRange> createState() =>
      _DateRangePickerFormFieldState();
}

class _DateRangePickerFormFieldState extends TxFormFieldState<DateTimeRange> {
  RestorableTextEditingController? _startController;
  RestorableTextEditingController? _endController;

  TextEditingController get _effectiveStartController =>
      _startController!.value;

  TextEditingController get _effectiveEndController => _endController!.value;

  @override
  DateRangePickerFormField get widget =>
      super.widget as DateRangePickerFormField;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(oldBucket, initialRestore);
    if (_startController != null) {
      _registerStartController();
    }
    if (_endController != null) {
      _registerEndController();
    }
    // 确保更新内部 [FormFieldState] 值以与文本编辑控制器值同步
    // setValue(_effectiveController.text);
  }

  void _registerStartController() {
    assert(_startController != null);
    registerForRestoration(_startController!, 'startController');
  }

  void _registerEndController() {
    assert(_endController != null);
    registerForRestoration(_endController!, 'endController');
  }

  void _createLocalStartController([TextEditingValue? value]) {
    assert(_startController == null);
    _startController = value == null
        ? RestorableTextEditingController()
        : RestorableTextEditingController.fromValue(value);
    if (!restorePending) {
      _registerStartController();
    }
  }

  void _createLocalEndController([TextEditingValue? value]) {
    assert(_endController == null);
    _endController = value == null
        ? RestorableTextEditingController()
        : RestorableTextEditingController.fromValue(value);
    if (!restorePending) {
      _registerEndController();
    }
  }

  String _formatDate(DateTime? dateTime) {
    if (dateTime == null) {
      return '';
    }
    return dateTime.format(widget.format);
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      _createLocalStartController(
        TextEditingValue(text: _formatDate(widget.initialValue!.start)),
      );
      _createLocalEndController(
        TextEditingValue(text: _formatDate(widget.initialValue!.end)),
      );
    } else {
      _createLocalStartController();
      _createLocalEndController();
    }
  }

  @override
  void didUpdateWidget(DateRangePickerFormField oldWidget) {
    if (widget.initialValue != value) {
      if (widget.initialValue == null) {
        _effectiveStartController.clear();
        _effectiveEndController.clear();
      } else {
        _effectiveStartController.text =
            _formatDate(widget.initialValue!.start);
        _effectiveEndController.text = _formatDate(widget.initialValue!.end);
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _startController!.dispose();
    _endController!.dispose();
    super.dispose();
  }

  @override
  void didChange(DateTimeRange? value) {
    super.didChange(value);
    final String start = _formatDate(value?.start);
    final String end = _formatDate(value?.end);
    if (_effectiveStartController.text != start) {
      _effectiveStartController.text = start;
    }
    if (_effectiveEndController.text != end) {
      _effectiveEndController.text = end;
    }
  }

  @override
  void reset() {
    final String start = _formatDate(widget.initialValue?.start);
    final String end = _formatDate(widget.initialValue?.end);
    _effectiveStartController.text = start;
    _effectiveEndController.text = end;
    super.reset();
  }
}
