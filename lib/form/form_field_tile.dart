import 'package:flutter/material.dart';

import '../field/field.dart';
import '../field/field_tile.dart';
import 'form_field.dart';

// /// 一个域组件布局容器
// class TxFormFieldTile<T> extends TxFormField {
//   TxFormFieldTile({
//     required super.fieldBuilder,
//     bool? required,
//     super.key,
//     LabelBuilder? labelBuilder,
//     String? labelText,
//     super.padding,
//     super.actionsBuilder,
//     super.labelStyle,
//     super.horizontalGap,
//     super.tileColor,
//     super.layoutDirection,
//     super.trailingBuilder,
//     super.leading,
//     super.visualDensity,
//     super.shape,
//     super.iconColor,
//     super.textColor,
//     super.leadingAndTrailingTextStyle,
//     super.enabled,
//     super.onTap,
//     super.minLeadingWidth,
//     super.dense,
//     super.minLabelWidth,
//     super.minVerticalPadding,
//     FormFieldSetter<T>? onSaved,
//     FormFieldValidator<T>? validator,
//     T? initialValue,
//     AutovalidateMode? autovalidateMode,
//     String? restorationId,
//   })  : assert(
//           labelBuilder == null || labelText == null,
//           'labelBuilder 和 labelText 最多指定一个',
//         ),
//         assert(
//           actionsBuilder == null || trailingBuilder == null,
//           'actions 和 trailing 最多指定一个',
//         ),
//         super(
//           labelBuilder: required == true
//               ? (style) {
//                   final InlineSpan? labelSpan = labelBuilder != null
//                       ? WidgetSpan(
//                           child: labelBuilder(style),
//                           style: style,
//                           alignment: PlaceholderAlignment.top,
//                         )
//                       : labelText != null
//                           ? TextSpan(text: labelText, style: style)
//                           : null;
//                   return RichText(
//                     text: TextSpan(
//                       text: '*\t',
//                       style: style.copyWith(color: Colors.red),
//                       children: labelSpan == null ? null : [labelSpan],
//                     ),
//                   );
//                 }
//               : labelBuilder,
//           labelText: required == true ? null : labelText,
//         );
// }

class TxFormFieldTile<T> extends TxFormField<T> {
  TxFormFieldTile({
    required FieldBuilder<T> fieldBuilder,
    super.key,
    super.initialValue,
    super.decoration,
    super.enabled,
    super.onChanged,
    super.required,
    super.onSaved,
    super.validator,
    super.autovalidateMode,
    super.restorationId,
    String? labelText,
    LabelBuilder? labelBuilder,
    TextStyle? labelStyle,
    Color? tileColor,
    Axis? layoutDirection,
    EdgeInsetsGeometry? padding,
    FieldTileActionsBuilder<T>? actionsBuilder,
    FieldBuilder<T>? trailingBuilder,
    Widget? leading,
    double? horizontalGap,
    VisualDensity? visualDensity,
    ShapeBorder? shape,
    Color? iconColor,
    Color? textColor,
    TextStyle? leadingAndTrailingTextStyle,
    VoidCallback? onTap,
    double? minLeadingWidth,
    double? minLabelWidth,
    double? minVerticalPadding,
    bool? dense,
  }) : super(
          builder: (field) {
            return UnmanagedRestorationScope(
              bucket: field.bucket,
              child: TxFieldTile(
                decoration: field.effectiveDecoration,
                onChanged: field.didChange,
                initialValue: field.value,
                fieldBuilder: fieldBuilder,
                labelBuilder: required == true
                    ? ((style) {
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
                      })
                    : labelBuilder,
                labelText: required == true ? null : labelText,
                padding: padding,
                actionsBuilder: actionsBuilder,
                trailingBuilder: trailingBuilder,
                labelStyle: labelStyle,
                horizontalGap: horizontalGap,
                tileColor: tileColor,
                layoutDirection: layoutDirection,
                leading: leading,
                visualDensity: visualDensity,
                shape: shape,
                iconColor: iconColor,
                textColor: textColor,
                leadingAndTrailingTextStyle: leadingAndTrailingTextStyle,
                enabled: enabled,
                onTap: onTap,
                minLeadingWidth: minLeadingWidth,
                minLabelWidth: minLabelWidth,
                dense: dense,
                minVerticalPadding: minVerticalPadding,
              ),
            );
          },
        );
}
