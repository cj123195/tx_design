import 'package:flutter/material.dart';

import '../field/field_tile.dart';

/// 一个域组件布局容器
class TxFormFieldTile<T> extends TxFieldTile {
  TxFormFieldTile({
    required super.field,
    bool? required,
    super.key,
    LabelBuilder? labelBuilder,
    String? labelText,
    super.padding,
    super.actions,
    super.labelStyle,
    super.horizontalGap,
    super.tileColor,
    super.layoutDirection,
    super.trailing,
    super.leading,
    super.visualDensity,
    super.shape,
    super.iconColor,
    super.textColor,
    super.leadingAndTrailingTextStyle,
    super.enabled,
    super.onTap,
    super.minLeadingWidth,
    super.dense,
    super.minLabelWidth,
    super.minVerticalPadding,
    FormFieldSetter<T>? onSaved,
    FormFieldValidator<T>? validator,
    T? initialValue,
    AutovalidateMode? autovalidateMode,
    String? restorationId,
  })  : assert(
          labelBuilder == null || labelText == null,
          'labelBuilder 和 labelText 最多指定一个',
        ),
        assert(
          actions == null || trailing == null,
          'actions 和 trailing 最多指定一个',
        ),
        super(
          labelBuilder: required == true
              ? (style) {
                  final InlineSpan? labelSpan = labelBuilder != null
                      ? WidgetSpan(
                          child: labelBuilder(style),
                          style: style,
                          alignment: PlaceholderAlignment.top,
                        )
                      : labelText != null
                          ? TextSpan(text: labelText, style: style)
                          : null;
                  return RichText(
                    text: TextSpan(
                      text: '*\t',
                      style: style.copyWith(color: Colors.red),
                      children: labelSpan == null ? null : [labelSpan],
                    ),
                  );
                }
              : labelBuilder,
          labelText: required == true ? null : labelText,
        );
}
