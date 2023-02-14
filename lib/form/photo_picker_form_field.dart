import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../widget.dart';
import '../widgets/image_picker.dart';
import 'form_item_container.dart';

/// @title 图标选择Form表单组件
/// @updateTime 2023/01/11 9:10 上午
/// @author 曹骏
class PhotoPickerFormField extends FormField<List<ByteData>> {
  PhotoPickerFormField({
    InputDecoration decoration = const InputDecoration(),
    ValueChanged<List<ByteData>?>? onChanged,
    int? maxPickNumber,
    bool drawEnabled = false,
    List<PickerMode>? pickerModes,
    bool readonly = false,

    // Form参数
    super.key,
    super.onSaved,
    List<ByteData>? initialData,
    bool required = false,
    bool? enabled,
    super.restorationId,
    AutovalidateMode? autovalidateMode,
    FormFieldValidator<List<ByteData>?>? validator,

    // FormItemContainer参数
    Widget? label,
    String? labelText,
    EdgeInsetsGeometry? padding,
    Color? background,
    Axis? direction,
  })  : assert(maxPickNumber == null || maxPickNumber > 0),
        super(
          initialValue: initialData,
          validator: validator ??
              (List<ByteData>? value) {
                final int length = value?.length ?? 0;
                if (required && length == 0) {
                  return '请选择';
                } else if (maxPickNumber != null && length > maxPickNumber) {
                  return '最多可选择$maxPickNumber个';
                }
                return null;
              },
          builder: (FormFieldState<List<ByteData>> field) {
            final _PhotoPickerFormFieldState state =
                field as _PhotoPickerFormFieldState;

            void onChangedHandler(List<ByteData>? value) {
              field.didChange(value);
              if (onChanged != null) {
                onChanged(value);
              }
            }

            /// 绘制
            Future<void> draw() async {
              final res = await Navigator.push(state.context,
                  MaterialPageRoute(builder: (context) {
                return const TxSignature();
              }));
              if (res != null) {
                onChangedHandler([...?field.value, ByteData.view(res.buffer)]);
              }
            }

            final bool pickEnabled = (maxPickNumber == null ||
                    (field.value?.length ?? 0) < maxPickNumber) &&
                !readonly;
            List<Widget>? actions;
            if (pickEnabled && drawEnabled) {
              actions = [
                IconButton(
                  onPressed: draw,
                  icon: const Icon(Icons.draw_outlined),
                  tooltip: '绘制',
                  visualDensity:
                      const VisualDensity(horizontal: -4.0, vertical: -4.0),
                )
              ];
            }

            return UnmanagedRestorationScope(
              bucket: field.bucket,
              child: FormItemContainer(
                actions: actions,
                label: label,
                labelText: labelText,
                required: required,
                direction: direction ?? Axis.vertical,
                background: background,
                padding: padding,
                formField: InputDecorator(
                  decoration: decoration.copyWith(
                    errorText: field.errorText,
                    filled: false,
                    border: InputBorder.none,
                  ),
                  isEmpty: field.value?.isNotEmpty != true,
                  child: TxImagePickerView(
                    initialImages: state.value,
                    onChanged: onChangedHandler,
                  ),
                ),
              ),
            );
          },
        );

  @override
  FormFieldState<List<ByteData>> createState() => _PhotoPickerFormFieldState();
}

class _PhotoPickerFormFieldState extends FormFieldState<List<ByteData>> {
  @override
  PhotoPickerFormField get widget => super.widget as PhotoPickerFormField;
}
