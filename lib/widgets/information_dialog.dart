import 'package:flutter/material.dart';

import '../localizations.dart';
import 'cell.dart';

/// @title 信息弹框
/// @description 一般用于展示列表数据详情
/// @updateTime 2022/10/26 5:21 下午
/// @author 曹骏
///
/// @param detailData 详情数据
/// @param slots 插槽,key为出入位置，value为插入组件
/// @param title 标题
/// @param icon 展示在标题上方的图标
Future<void> showInformationDialog(
  BuildContext context, {
  required Map<String, dynamic> data,
  Map<int?, TxCell>? slots,
  String? title,
  bool showTitle = true,
  Widget? icon,
}) {
  final List<TxCell> cells = List.generate(data.length, (index) {
    final String key = data.keys.toList()[index];
    final dynamic value = data[key];

    return TxCell(labelText: key, contentText: value?.toString());
  });
  if (slots != null) {
    slots.forEach((index, cell) {
      if (index == null || index > cells.length) {
        cells.add(cell);
      } else if (index < 0) {
        cells.insert(0, cell);
      } else {
        cells.insert(index, cell);
      }
    });
  }

  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: showTitle
              ? Text(
                  title ?? TxLocalizations.of(context).informationDialogTitle,
                  textAlign: TextAlign.center,
                )
              : null,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: cells,
          ),
        );
      });
}
