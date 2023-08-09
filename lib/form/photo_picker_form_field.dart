import 'package:flutter/material.dart';

import '../extensions/datetime_extension.dart';
import '../localizations.dart';
import '../widgets/image_picker.dart';
import '../widgets/signature.dart';
import 'form_field.dart';

export '../models/tx_file.dart';

const String _drawingPrefix = 'Drawing';

/// @title 图标选择Form表单组件
/// @updateTime 2023/01/11 9:10 上午
/// @author 曹骏
class PhotoPickerFormField extends TxFormFieldItem<List<TxFile>> {
  PhotoPickerFormField({
    bool drawEnabled = false,
    int? minPickNumber,
    int? maxPickNumber,
    List<PickerMode>? pickerModes,
    bool readonly = false,
    super.key,
    super.onSaved,
    super.required,
    super.enabled,
    super.restorationId,
    super.autovalidateMode,
    super.validator,
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
    super.initialValue,
    InputDecoration? decoration,
    ValueChanged<List<TxFile>?>? onChanged,
  })  : assert(maxPickNumber == null || maxPickNumber > 0),
        super(
          builder: (field) {
            final InputDecoration defaultDecoration = InputDecoration(
              hintText: TxLocalizations.of(field.context).pickerFormFieldHint,
              filled: false,
              border: InputBorder.none,
            );
            final InputDecoration effectiveDecoration =
                TxFormFieldItem.mergeDecoration(
                    field.context, decoration, defaultDecoration);

            void onChangedHandler(List<TxFile>? value) {
              field.didChange(value);
              if (onChanged != null) {
                onChanged(value);
              }
            }

            Widget child;
            if (field.value?.isNotEmpty == true) {
              child = TxImagePickerView(
                initialImages: field.value,
                onChanged: onChangedHandler,
              );
            } else {
              child = TxImagePickerView(onChanged: onChangedHandler);
            }

            return InputDecorator(
              decoration:
                  effectiveDecoration.copyWith(errorText: field.errorText),
              isEmpty: field.value?.isNotEmpty != true,
              child: child,
            );
          },
          actionsBuilder: (field) {
            final bool pickEnabled = (maxPickNumber == null ||
                    (field.value?.length ?? 0) < maxPickNumber) &&
                !readonly;
            if (readonly || !pickEnabled) {
              return actions;
            }
            final TxLocalizations localizations =
                TxLocalizations.of(field.context);
            void onChangedHandler(List<TxFile>? value) {
              field.didChange(value);
              if (onChanged != null) {
                onChanged(value);
              }
            }

            // 绘制
            Future<void> draw() async {
              final MaterialPageRoute route = MaterialPageRoute(
                builder: (context) {
                  return TxSignatureFullScreen(
                    onSave: (data) {
                      final String dateTime =
                          DateTime.now().format('yyyyMMdd_HHmmss');
                      if (data != null) {
                        final TxFile file = TxMemoryFile(
                          data,
                          name: '${_drawingPrefix}_$dateTime.png',
                        );
                        onChangedHandler([...?field.value, file]);
                        Navigator.pop(context);
                      }
                    },
                  );
                },
              );
              Navigator.push(field.context, route);
            }

            final Widget drawButton = IconButton(
              onPressed: draw,
              icon: const Icon(Icons.draw_outlined),
              tooltip: localizations.drawButtonTooltip,
              visualDensity: VisualDensity.compact,
            );
            return [...?actions, if (drawEnabled) drawButton];
          },
          defaultValidator: (context, files) {
            final TxLocalizations localizations = TxLocalizations.of(context);
            final int length = files?.length ?? 0;
            if (required && length == 0) {
              return localizations.pickerFormFieldHint;
            }
            if (minPickNumber != null && minPickNumber > length) {
              return localizations.minimumPhotoLimitLabel(minPickNumber);
            }
            if (maxPickNumber != null && maxPickNumber < length) {
              return localizations.maximumPhotoLimitLabel(maxPickNumber);
            }
            return null;
          },
        );
}
