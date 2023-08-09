import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

import '../extensions/datetime_extension.dart';
import '../extensions/string_extension.dart';
import '../localizations.dart';
import '../models/tx_file.dart';
import '../widgets/file_list_tile.dart';
import '../widgets/image_viewer.dart';
import '../widgets/signature.dart';
import 'form_field.dart';

export '../models/tx_file.dart';

const String _drawingPrefix = 'Drawing';

/// 文件选择Form表单组件
class FilePickerFormField extends TxFormFieldItem<List<TxFile>> {
  FilePickerFormField({
    List<String>? allowedExtensions,
    int? minPickNumber,
    int? maxPickNumber,
    bool drawEnabled = false,
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
  })  : assert(
          minPickNumber == null || minPickNumber > 0,
          'minPickNumber must be null or greater than 0',
        ),
        assert(
          maxPickNumber == null || maxPickNumber > 0,
          'maxPickNumber must be null or greater than 0',
        ),
        assert(
          maxPickNumber == null ||
              minPickNumber == null ||
              maxPickNumber > minPickNumber,
          'maxPickNumber must be  greater than minPickNumber',
        ),
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

            Widget? child;
            if (field.value?.isNotEmpty == true) {
              child = Column(
                mainAxisSize: MainAxisSize.min,
                children: field.value!.map((e) {
                  return _FileTile(
                    e,
                    readonly
                        ? null
                        : (file) {
                            final List<TxFile> list = [...field.value!];
                            list.remove(file);
                            field.didChange(list);
                            if (onChanged != null) {
                              onChanged(list);
                            }
                            return true;
                          },
                  );
                }).toList(),
              );
            }

            return InputDecorator(
              decoration:
                  effectiveDecoration.copyWith(errorText: field.errorText),
              isEmpty: field.value?.isNotEmpty != true,
              child: child,
            );
          },
          actionsBuilder: (field) {
            if (readonly) {
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

            // 选择文件
            Future<void> pickFile() async {
              final FilePickerResult? result =
                  await FilePicker.platform.pickFiles(
                allowedExtensions: allowedExtensions,
                type:
                    allowedExtensions == null ? FileType.any : FileType.custom,
              );

              if (result != null) {
                onChangedHandler([
                  ...?field.value,
                  ...result.files.map((e) => e.toTxFile()),
                ]);
              }
            }

            final Widget attachButton = IconButton(
              onPressed: pickFile,
              icon: const Icon(Icons.attachment),
              tooltip: localizations.selectFileButtonTooltip,
              visualDensity: VisualDensity.compact,
            );

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
            return [...?actions, attachButton, if (drawEnabled) drawButton];
          },
          defaultValidator: (context, files) {
            final TxLocalizations localizations = TxLocalizations.of(context);
            final int length = files?.length ?? 0;
            if (required && length == 0) {
              return localizations.pickerFormFieldHint;
            }
            if (minPickNumber != null && minPickNumber > length) {
              return localizations.minimumFileLimitLabel(minPickNumber);
            }
            if (maxPickNumber != null && maxPickNumber < length) {
              return localizations.maximumFileLimitLabel(maxPickNumber);
            }
            return null;
          },
        );
}

class _FileTile extends StatelessWidget {
  const _FileTile(this.file, this.onDeleteTap);

  final TxFile file;
  final bool Function(TxFile file)? onDeleteTap;

  Future<void> onPreviewTap(BuildContext context, TxFile file) async {
    if (file.name.isImageFileName) {
      ImageProvider image;
      if (file is TxNetworkFile) {
        image = NetworkImage(file.url);
      } else if (file is TxMemoryFile) {
        final Uint8List bytes = file.bytes!;
        image = MemoryImage(bytes);
      } else {
        image = FileImage(File(file.path));
      }
      if (context.mounted) {
        final Color? background =
            file.name.startsWith(_drawingPrefix) ? Colors.white : null;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return TxImageViewer(image, backgroundColor: background);
            },
          ),
        );
      }
    } else {
      if (file.path.isEmpty) {
        final Directory dic = await getTemporaryDirectory();
        await file.saveTo(dic.path + Platform.pathSeparator + file.name);
      }
      OpenFilex.open(file.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      builder: (context, snapshot) {
        return TxFileListTile(
          name: file.name,
          size: snapshot.data,
          onShareTap: file.share,
          onPreviewTap: () => onPreviewTap(context, file),
          onDeleteTap: () => onDeleteTap?.call(file) ?? false,
        );
      },
      future: file.length(),
    );
  }
}
