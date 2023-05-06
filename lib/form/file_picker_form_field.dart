import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:share_plus/share_plus.dart';

import '../widgets/file_list_tile.dart';
import '../widgets/signature.dart';
import 'form_item_container.dart';

export 'package:file_picker/file_picker.dart' show PlatformFile;

/// 文件选择Form表单组件
///
/// otherFiles用于传入其他非选择选择组件，如服务器文件等
class FilePickerFormField extends FormField<List<PlatformFile>> {
  FilePickerFormField({
    InputDecoration decoration = const InputDecoration(),
    ValueChanged<List<PlatformFile>?>? onChanged,
    List<String>? allowedExtensions,
    int? maxPickNumber,
    bool drawEnabled = false,
    bool readonly = false,

    // Form参数
    super.key,
    super.onSaved,
    List<PlatformFile>? initialData,
    List<TxFileListTile>? otherFiles,
    bool required = true,
    bool? enabled,
    super.restorationId,
    AutovalidateMode? autovalidateMode,
    FormFieldValidator<List<PlatformFile>?>? validator,

    // FormItemContainer参数
    Widget? label,
    String? labelText,
    EdgeInsetsGeometry? padding,
    Color? backgroundColor,
    TextStyle? labelStyle,
    TextStyle? starStyle,
    double? horizontalGap,
    double? minLabelWidth,
    Axis? direction,
  })  : assert(maxPickNumber == null || maxPickNumber > 0),
        super(
          initialValue: initialData,
          validator: validator ??
              (List<PlatformFile>? value) {
                final int length =
                    (value?.length ?? 0) + (otherFiles?.length ?? 0);
                if (required && length == 0) {
                  return '请选择$label';
                } else if (maxPickNumber != null && length > maxPickNumber) {
                  return '最多可选择$maxPickNumber个文件';
                }
                return null;
              },
          builder: (FormFieldState<List<PlatformFile>> field) {
            void onChangedHandler(List<PlatformFile>? value) {
              field.didChange(value);
              if (onChanged != null) {
                onChanged(value);
              }
            }

            /// 选择文件
            Future<void> pickFile() async {
              final FilePickerResult? result = await FilePicker.platform
                  .pickFiles(
                      allowedExtensions: allowedExtensions,
                      type: allowedExtensions == null
                          ? FileType.any
                          : FileType.custom);

              if (result != null) {
                onChangedHandler([...?field.value, ...result.files]);
              }
            }

            /// 绘制
            Future<void> draw() async {
              Navigator.push(
                field.context,
                MaterialPageRoute(
                  builder: (context) {
                    return TxSignatureFullScreen(
                      onSave: (data) {
                        if (data != null) {
                          final int size = data.length;
                          final PlatformFile file = PlatformFile(
                            name: 'signature_${DateTime.now().millisecond}.png',
                            size: size,
                            bytes: data,
                          );
                          onChangedHandler([...?field.value, file]);
                        }
                      },
                    );
                  },
                ),
              );
            }

            List<Widget>? actions;
            final int length =
                (field.value?.length ?? 0) + (otherFiles?.length ?? 0);
            if ((maxPickNumber == null || length < maxPickNumber) &&
                !readonly) {
              final Widget attachButton = IconButton(
                onPressed: pickFile,
                icon: const Icon(Icons.attachment),
                tooltip: '选择文件',
                visualDensity:
                    const VisualDensity(horizontal: -4.0, vertical: -4.0),
              );
              final Widget drawButton = IconButton(
                onPressed: draw,
                icon: const Icon(Icons.draw_outlined),
                tooltip: '绘制',
                visualDensity:
                    const VisualDensity(horizontal: -4.0, vertical: -4.0),
              );
              actions = [attachButton, if (drawEnabled) drawButton];
            }

            Widget? child;
            if (length != 0) {
              child = Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...?otherFiles,
                  ...?field.value?.map((e) {
                    return TxFileListTile(
                      name: e.name,
                      size: e.size,
                      onShareTap: () {
                        Share.shareXFiles(
                            [XFile(e.path!, name: e.name, length: e.size)]);
                      },
                      onPreviewTap: () => OpenFilex.open(e.path),
                      onDeleteTap: readonly
                          ? null
                          : () {
                              final List<PlatformFile> list = [...field.value!];
                              list.remove(e);
                              onChangedHandler(list);
                              return true;
                            },
                    );
                  }).toList(),
                ],
              );
            }

            return UnmanagedRestorationScope(
              bucket: field.bucket,
              child: FormItemContainer(
                actions: actions,
                label: label,
                labelText: labelText,
                required: required,
                direction: direction,
                backgroundColor: backgroundColor,
                labelStyle: labelStyle,
                starStyle: starStyle,
                horizontalGap: horizontalGap,
                minLabelWidth: minLabelWidth,
                padding: padding,
                formField: InputDecorator(
                  decoration: decoration.copyWith(
                    errorText: field.errorText,
                    hintText: length == 0 ? '请选择文件' : null,
                    filled: false,
                    border: InputBorder.none,
                  ),
                  isEmpty: field.value?.isNotEmpty != true,
                  child: child,
                ),
              ),
            );
          },
        );

  @override
  FormFieldState<List<PlatformFile>> createState() =>
      _FilePickerFormFieldState();
}

class _FilePickerFormFieldState extends FormFieldState<List<PlatformFile>> {
  @override
  FilePickerFormField get widget => super.widget as FilePickerFormField;

  @override
  void didUpdateWidget(covariant FilePickerFormField oldWidget) {
    if (widget.initialValue != value) {
      setValue(widget.initialValue);
    }
    super.didUpdateWidget(oldWidget);
  }
}
