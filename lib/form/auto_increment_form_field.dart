import 'package:flutter/material.dart';

import '../field/auto_increment_field.dart';
import 'form_field_tile.dart';

/// [builder]  构造的组件为自增列表 的 [FormField]。
class TxAutoIncrementFormField<T> extends FormField<List<T>> {
  TxAutoIncrementFormField({
    required IndexedFieldWidgetBuilder<T> itemBuilder,
    required T defaultValue,
    ButtonStyle? addButtonStyle,
    int? minCount,
    int? maxCount,
    super.key,
    InputDecoration? decoration,
    FocusNode? focusNode,
    ValueChanged<List<T>?>? onChanged,
    super.onSaved,
    FormFieldValidator<List<T>>? validator,
    super.initialValue,
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    bool? required,
  }) : super(
          builder: (field) {
            void onChangedHandler(List<T>? value) {
              field.didChange(value);
              onChanged?.call(value);
            }

            final InputDecoration effectiveDecoration =
                (decoration ?? const InputDecoration())
                    .copyWith(errorText: field.errorText);

            return UnmanagedRestorationScope(
              bucket: field.bucket,
              child: TxAutoIncrementField<T>(
                itemBuilder: itemBuilder,
                defaultValue: defaultValue,
                addButtonStyle: addButtonStyle,
                maxCount: maxCount,
                onChanged: onChangedHandler,
                decoration: effectiveDecoration,
                focusNode: focusNode,
                enabled: enabled,
                initialValue: field.value,
              ),
            );
          },
          validator: (val) {
            if (required == true && (val == null || val.isEmpty)) {
              return '请至少添加一项';
            }
            if (maxCount != null && val != null && val.length > maxCount) {
              return '最多可添加$maxCount项';
            }
            if (minCount != null && (val == null || val.length < minCount)) {
              return '请至少添加$minCount项';
            }
            if (validator != null) {
              return validator(val);
            }
            return null;
          },
        );

  TxAutoIncrementFormField.tile({
    required IndexedFieldWidgetBuilder<T> titleBuilder,
    required T defaultValue,
    IndexedFieldWidgetBuilder<T>? subtitleBuilder,
    IndexedFieldWidgetBuilder<T>? leadingBuilder,
    IndexedPopupMenuItemsBuilder<T>? actionsBuilder,
    AutoIncrementIndexedStyle indexedStyle = AutoIncrementIndexedStyle.text,
    IconButtonThemeData? iconButtonTheme,
    ButtonStyle? addButtonStyle,
    int? minCount,
    int? maxCount,
    super.key,
    InputDecoration? decoration,
    FocusNode? focusNode,
    ValueChanged<List<T?>?>? onChanged,
    super.onSaved,
    FormFieldValidator<List<T>>? validator,
    super.initialValue,
    super.enabled,
    super.autovalidateMode,
    super.restorationId,
    bool? required,
  }) : super(
          builder: (field) {
            void onChangedHandler(List<T>? value) {
              field.didChange(value);
              onChanged?.call(value);
            }

            final InputDecoration effectiveDecoration =
                (decoration ?? const InputDecoration())
                    .copyWith(errorText: field.errorText);

            return UnmanagedRestorationScope(
              bucket: field.bucket,
              child: TxAutoIncrementField<T>.tile(
                titleBuilder: titleBuilder,
                subtitleBuilder: subtitleBuilder,
                leadingBuilder: leadingBuilder,
                actionsBuilder: actionsBuilder,
                indexedStyle: indexedStyle,
                iconButtonTheme: iconButtonTheme,
                defaultValue: defaultValue,
                addButtonStyle: addButtonStyle,
                minCount: minCount,
                maxCount: maxCount,
                initialValue: field.value,
                decoration: effectiveDecoration,
                focusNode: focusNode,
                onChanged: onChangedHandler,
                enabled: enabled,
              ),
            );
          },
          validator: (val) {
            if (required == true && (val == null || val.isEmpty)) {
              return '请至少添加一项';
            }
            if (maxCount != null && val != null && val.length > maxCount) {
              return '最多可添加$maxCount}项';
            }
            if (minCount != null && (val == null || val.length < minCount)) {
              return '请至少添加$minCount}项';
            }
            if (validator != null) {
              return validator(val);
            }
            return null;
          },
        );
}

/// [field] 为 [TxAutoIncrementFormField] 的 [TxFormFieldTile]。
class TxAutoIncrementFormFieldTile<T> extends TxFormFieldTile<List<T>> {
  TxAutoIncrementFormFieldTile({
    required IndexedFieldWidgetBuilder<T> itemBuilder,
    required T defaultValue,
    ButtonStyle? addButtonStyle,
    int? maxCount,
    InputDecoration? decoration,
    FocusNode? focusNode,
    ValueChanged<List<T>?>? onChanged,
    super.required,
    super.key,
    super.labelBuilder,
    super.labelText,
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
    super.onSaved,
    super.validator,
    super.initialValue,
    super.autovalidateMode,
    super.restorationId,
  }) : super(
          field: TxAutoIncrementFormField<T>(
            itemBuilder: itemBuilder,
            defaultValue: defaultValue,
            initialValue: initialValue,
            addButtonStyle: addButtonStyle,
            maxCount: maxCount,
            decoration: decoration,
            focusNode: focusNode,
            onChanged: onChanged,
            onSaved: onSaved,
            validator: validator,
            restorationId: restorationId,
            required: required,
            enabled: enabled,
            autovalidateMode: autovalidateMode,
          ),
        );

  TxAutoIncrementFormFieldTile.tile({
    required IndexedFieldWidgetBuilder<T> titleBuilder,
    required T defaultValue,
    IndexedFieldWidgetBuilder<T>? subtitleBuilder,
    IndexedFieldWidgetBuilder<T>? leadingBuilder,
    IndexedPopupMenuItemsBuilder<T>? actionsBuilder,
    AutoIncrementIndexedStyle indexedStyle = AutoIncrementIndexedStyle.text,
    IconButtonThemeData? iconButtonTheme,
    ButtonStyle? addButtonStyle,
    int? minCount,
    int? maxCount,
    InputDecoration? decoration,
    FocusNode? focusNode,
    ValueChanged<List<T?>?>? onChanged,
    super.required,
    super.key,
    super.labelBuilder,
    super.labelText,
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
    super.onSaved,
    super.validator,
    super.initialValue,
    super.autovalidateMode,
    super.restorationId,
  }) : super(
          field: TxAutoIncrementFormField<T>.tile(
            titleBuilder: titleBuilder,
            subtitleBuilder: subtitleBuilder,
            leadingBuilder: leadingBuilder,
            actionsBuilder: actionsBuilder,
            indexedStyle: indexedStyle,
            iconButtonTheme: iconButtonTheme,
            defaultValue: defaultValue,
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
          ),
        );
}
