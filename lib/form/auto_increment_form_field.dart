import 'package:flutter/material.dart';

import '../field/auto_increment_field.dart';
import 'form_field.dart';
import 'form_field_tile.dart';

String? _validator<T>(
  List<T>? value,
  bool? required,
  int? minCount,
  int? maxCount,
  FormFieldValidator<List<T>>? validator,
) {
  if (required == true && (value == null || value.isEmpty)) {
    return '请至少添加一项';
  }
  if (maxCount != null && value != null && value.length > maxCount) {
    return '最多可添加$maxCount项';
  }
  if (minCount != null && (value == null || value.length < minCount)) {
    return '请至少添加$minCount项';
  }
  if (validator != null) {
    return validator(value);
  }
  return null;
}

/// [builder]  构造的组件为自增列表 的 [FormField]。
class TxAutoIncrementFormField<T> extends TxFormField<List<T>> {
  TxAutoIncrementFormField({
    required IndexedFieldWidgetBuilder<T> itemBuilder,
    required AddCallback<T> onAddTap,
    super.key,
    super.onSaved,
    FormFieldValidator<List<T>>? validator,
    super.initialValue,
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    super.decoration,
    super.onChanged,
    super.required,
    ButtonStyle? addButtonStyle,
    int? minCount,
    int? maxCount,
    FocusNode? focusNode,
    String? hintText,
    TextAlign? textAlign,
  }) : super(
          builder: (field) {
            return UnmanagedRestorationScope(
              bucket: field.bucket,
              child: TxAutoIncrementField<T>(
                itemBuilder: itemBuilder,
                onAddTap: onAddTap,
                addButtonStyle: addButtonStyle,
                maxCount: maxCount,
                onChanged: field.didChange,
                decoration: field.effectiveDecoration,
                focusNode: focusNode,
                enabled: enabled,
                initialValue: field.value,
                textAlign: textAlign,
                hintText: hintText,
              ),
            );
          },
          validator: (val) => _validator(
            val,
            required,
            minCount,
            maxCount,
            validator,
          ),
        );

  TxAutoIncrementFormField.tile({
    required IndexedFieldWidgetBuilder<T> titleBuilder,
    required AddCallback<T> onAddTap,
    IndexedFieldWidgetBuilder<T>? subtitleBuilder,
    IndexedFieldWidgetBuilder<T>? leadingBuilder,
    IndexedPopupMenuItemsBuilder<T>? actionsBuilder,
    AutoIncrementIndexedStyle indexedStyle = AutoIncrementIndexedStyle.text,
    IconButtonThemeData? iconButtonTheme,
    ButtonStyle? addButtonStyle,
    int? minCount,
    int? maxCount,
    FocusNode? focusNode,
    String? hintText,
    TextAlign? textAlign,
    super.key,
    super.onSaved,
    FormFieldValidator<List<T>>? validator,
    super.initialValue,
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    super.decoration,
    super.onChanged,
    super.required,
  }) : super(
          builder: (field) {
            return UnmanagedRestorationScope(
              bucket: field.bucket,
              child: TxAutoIncrementField<T>.tile(
                titleBuilder: titleBuilder,
                subtitleBuilder: subtitleBuilder,
                leadingBuilder: leadingBuilder,
                actionsBuilder: actionsBuilder,
                indexedStyle: indexedStyle,
                iconButtonTheme: iconButtonTheme,
                onAddTap: onAddTap,
                addButtonStyle: addButtonStyle,
                minCount: minCount,
                maxCount: maxCount,
                initialValue: field.value,
                decoration: field.effectiveDecoration,
                focusNode: focusNode,
                onChanged: field.didChange,
                enabled: enabled,
                hintText: hintText,
                textAlign: textAlign,
              ),
            );
          },
          validator: (val) => _validator(
            val,
            required,
            minCount,
            maxCount,
            validator,
          ),
        );
}

/// field 为 [TxAutoIncrementFormField] 的 [TxFormFieldTile]。
class TxAutoIncrementFormFieldTile<T> extends TxFormFieldTile<List<T>> {
  TxAutoIncrementFormFieldTile({
    required IndexedFieldWidgetBuilder<T> itemBuilder,
    required AddCallback<T> onAddTap,
    super.key,
    super.onSaved,
    FormFieldValidator<List<T>>? validator,
    super.initialValue,
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    super.decoration,
    super.onChanged,
    super.required,
    ButtonStyle? addButtonStyle,
    int? minCount,
    int? maxCount,
    FocusNode? focusNode,
    String? hintText,
    TextAlign? textAlign,
    super.labelBuilder,
    super.labelText,
    super.padding,
    super.actionsBuilder,
    super.labelStyle,
    super.horizontalGap,
    super.tileColor,
    super.layoutDirection,
    super.trailingBuilder,
    super.leading,
    super.visualDensity,
    super.shape,
    super.iconColor,
    super.textColor,
    super.leadingAndTrailingTextStyle,
    super.onTap,
    super.minLeadingWidth,
    super.dense,
    super.minLabelWidth,
    super.minVerticalPadding,
  }) : super(
          fieldBuilder: (field) {
            return TxAutoIncrementField<T>(
              itemBuilder: itemBuilder,
              onAddTap: onAddTap,
              addButtonStyle: addButtonStyle,
              maxCount: maxCount,
              onChanged: field.didChange,
              decoration: field.effectiveDecoration,
              focusNode: focusNode,
              enabled: enabled,
              initialValue: field.value,
              textAlign: textAlign,
              hintText: hintText,
            );
          },
          validator: (val) => _validator(
            val,
            required,
            minCount,
            maxCount,
            validator,
          ),
        );

  TxAutoIncrementFormFieldTile.tile({
    required IndexedFieldWidgetBuilder<T> titleBuilder,
    required AddCallback<T> onAddTap,
    super.key,
    super.onSaved,
    FormFieldValidator<List<T>>? validator,
    super.initialValue,
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    super.decoration,
    super.onChanged,
    super.required,
    IndexedFieldWidgetBuilder<T>? subtitleBuilder,
    IndexedFieldWidgetBuilder<T>? leadingBuilder,
    IndexedPopupMenuItemsBuilder<T>? actionsBuilder,
    AutoIncrementIndexedStyle indexedStyle = AutoIncrementIndexedStyle.text,
    IconButtonThemeData? iconButtonTheme,
    ButtonStyle? addButtonStyle,
    int? minCount,
    int? maxCount,
    FocusNode? focusNode,
    String? hintText,
    TextAlign? textAlign,
    super.labelBuilder,
    super.labelText,
    super.padding,
    super.labelStyle,
    super.horizontalGap,
    super.tileColor,
    super.layoutDirection,
    super.leading,
    super.visualDensity,
    super.shape,
    super.iconColor,
    super.textColor,
    super.leadingAndTrailingTextStyle,
    super.onTap,
    super.minLeadingWidth,
    super.dense,
    super.minLabelWidth,
    super.minVerticalPadding,
  }) : super(
          fieldBuilder: (field) {
            return TxAutoIncrementFormField<T>.tile(
              titleBuilder: titleBuilder,
              subtitleBuilder: subtitleBuilder,
              leadingBuilder: leadingBuilder,
              actionsBuilder: actionsBuilder,
              indexedStyle: indexedStyle,
              iconButtonTheme: iconButtonTheme,
              onAddTap: onAddTap,
              addButtonStyle: addButtonStyle,
              minCount: minCount,
              maxCount: maxCount,
              initialValue: initialValue,
              decoration: decoration,
              focusNode: focusNode,
              onChanged: onChanged,
              enabled: enabled,
              onSaved: onSaved,
              validator: validator,
              restorationId: restorationId,
              required: required,
              autovalidateMode: autovalidateMode,
              textAlign: textAlign,
              hintText: hintText,
            );
          },
          validator: (val) => _validator(
            val,
            required,
            minCount,
            maxCount,
            validator,
          ),
        );
}
