import 'package:flutter/material.dart';

import '../extensions/datetime_extension.dart';
import '../utils/basic_types.dart';
import '../widgets/date_range_picker.dart';
import 'form_item_container.dart';

const EdgeInsetsGeometry _kFieldsPadding =
    EdgeInsets.symmetric(horizontal: 12.0);

/// 日期范围选择组件
class DateRangePickerFormField extends FormField<DateTimeRange> {
  DateRangePickerFormField({
    this.format = 'yyyy-MM-dd',
    ValueChanged<DateTimeRange?>? onChanged,
    InputDecoration decoration = const InputDecoration(),
    DateTime? firstDate,
    DateTime? lastDate,

    /// Form 参数
    FormFieldValidator<DateTimeRange>? validator,
    super.key,
    super.onSaved,
    DateTimeRange? initialDateRange,
    bool required = false,
    bool? enabled,
    super.restorationId,
    AutovalidateMode? autovalidateMode,

    // FormItemContainer参数
    Widget? label,
    String? labelText,
    EdgeInsetsGeometry? labelPadding,
    Color? background,
    Axis? direction,

    /// TextField参数
    TextStyle? style,
    StrutStyle? strutStyle,
    TextDirection? textDirection,
    TextAlign textAlign = TextAlign.center,
    TextAlignVertical? textAlignVertical,
    EditableTextContextMenuBuilder? contextMenuBuilder,
    PickerFuture<DateTimeRange?>? onTap,
  }) : super(
          initialValue: initialDateRange,
          validator: validator ??
              (required
                  ? (DateTimeRange? value) {
                      if (value == null) {
                        return '请选择${labelText ?? ''}';
                      }
                      return null;
                    }
                  : null),
          enabled: enabled ?? decoration.enabled,
          autovalidateMode: autovalidateMode ?? AutovalidateMode.disabled,
          builder: (FormFieldState<DateTimeRange> field) {
            final _DateRangePickerFormFieldState state =
                field as _DateRangePickerFormFieldState;

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
                range = await showDateRangeDialog(
                  state.context,
                  firstDate: firstDate,
                  lastDate: lastDate,
                  initialDateRange: state.value,
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
              hintText: '开始时间',
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
              enabled: enabled ?? decoration.enabled,
            );

            final InputDecoration effectiveEndDecoration =
                FormItemContainer.createDecoration(
              field.context,
              decoration,
              hintText: '结束时间',
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
              enabled: enabled ?? effectiveEndDecoration.enabled,
            );

            final Widget formField = Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(child: startField),
                Padding(
                  padding:
                      effectiveEndDecoration.contentPadding ?? _kFieldsPadding,
                  child: const Text('至'),
                ),
                Expanded(child: endField),
              ],
            );

            return UnmanagedRestorationScope(
              bucket: field.bucket,
              child: FormItemContainer(
                label: label,
                labelText: labelText,
                required: required,
                direction: direction ?? Axis.vertical,
                background: background,
                padding: labelPadding,
                formField: formField,
              ),
            );
          },
        );

  final String? format;

  @override
  FormFieldState<DateTimeRange> createState() =>
      _DateRangePickerFormFieldState();
}

class _DateRangePickerFormFieldState extends FormFieldState<DateTimeRange> {
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

  @override
  void initState() {
    super.initState();
    if (widget.initialValue == null) {
      _createLocalStartController();
      _createLocalEndController();
    } else {
      _createLocalStartController(TextEditingValue(
          text: widget.initialValue!.start.format(widget.format)));
      _createLocalEndController(
          TextEditingValue(text: widget.initialValue!.end.format()));
    }
  }

  @override
  void didUpdateWidget(DateRangePickerFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != value) {
      setValue(widget.initialValue);
      if (widget.initialValue == null) {
        _effectiveStartController.clear();
        _effectiveEndController.clear();
      } else {
        _effectiveStartController.text = widget.initialValue!.start.format();
        _effectiveEndController.text = widget.initialValue!.end.format();
      }
    }
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
    final String? start = widget.initialValue?.start.format();
    final String? end = widget.initialValue?.end.format();
    if (_effectiveStartController.text != start) {
      _effectiveStartController.text = start ?? '';
    }
    if (_effectiveEndController.text != end) {
      _effectiveEndController.text = end ?? '';
    }
  }

  @override
  void reset() {
    final String? start = widget.initialValue?.start.format();
    final String? end = widget.initialValue?.end.format();
    _effectiveStartController.text = start ?? '';
    _effectiveEndController.text = end ?? '';
    super.reset();
  }
}
