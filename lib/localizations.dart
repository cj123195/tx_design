import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

bool debugCheckHasTxLocalizations(BuildContext context) {
  assert(() {
    if (Localizations.of<TxLocalizations>(context, TxLocalizations) == null) {
      throw FlutterError.fromParts(<DiagnosticsNode>[
        ErrorSummary('No TxLocalizations found.'),
        ErrorDescription(
          '${context.widget.runtimeType} widgets require TxLocalizations '
          'to be provided by a Localizations widget ancestor.',
        ),
        ErrorDescription(
          'The material library uses Localizations to generate messages, '
          'labels, and abbreviations.',
        ),
        ErrorHint(
          'To introduce a TxLocalizations, either use a '
          'MaterialApp at the root of your application to include them '
          'automatically, or add a Localization widget with a '
          'TxLocalizations delegate.',
        ),
        ...context.describeMissingAncestor(
            expectedAncestorType: TxLocalizations),
      ]);
    }
    return true;
  }());
  return true;
}

abstract class TxLocalizations {
  /// Title for custom items.
  String get customTitle;

  /// Title for quick choices.
  String get quickChoiceTitle;

  /// Title for default dialog.
  String get dialogTitle;

  /// Title for information dialog.
  String get informationDialogTitle;

  /// Title for picker.
  String get pickerTitle;

  /// Title text for default dialog;
  String get dialogContent;

  /// Title for datetime picker bottom sheet;
  String get datetimePickerTitle;

  /// Title for month picker bottom sheet;
  String get monthPickerTitle;

  /// Title for year picker bottom sheet;
  String get yearPickerTitle;

  /// Title for datetime range picker bottom sheet;
  String get datetimeRangePickerTitle;

  /// Label for recent days choice on quick choices.
  String recentDaysLabel(int count);

  /// Label for recent weeks choice on quick choices.
  String recentWeeksLabel(int count);

  /// Label for recent months choice on quick choices.
  String recentMonthsLabel(int count);

  /// Label for recent years choice on quick choices.
  String recentYearsLabel(int count);

  /// Label for Clear buttons and menu items.
  String get clearButtonLabel;

  /// Label for Collapsed buttons.
  String get collapsedButtonLabel;

  /// Label for More buttons.
  String get moreButtonLabel;

  /// Label for Preview buttons and menu items.
  String get previewButtonLabel;

  /// Label for Share buttons and menu items.
  String get shareButtonLabel;

  /// Label for select photo buttons.
  String get selectPhotoButtonLabel;

  /// Label for undo buttons.
  String get undoButtonTooltip;

  /// Label for redo buttons.
  String get redoButtonTooltip;

  /// Label for full screen buttons.
  String get fullScreenButtonTooltip;

  /// Label for exit full screen buttons.
  String get fullScreenExitButtonTooltip;

  /// Label for edit buttons.
  String get editButtonTooltip;

  /// Label for done buttons.
  String get doneButtonTooltip;

  /// Label for draw buttons.
  String get drawButtonTooltip;

  /// Label for select file buttons.
  String get selectFileButtonTooltip;

  /// Label for unknown file size on file list tile.
  String get unknownFileSizeLabel;

  /// Formats the time of the given [Duration].
  String formatDuration(Duration duration);

  /// The label used for the minimum time limit in the date range picker.
  String dateRangeMinimumDateLimitLabel(Duration duration);

  /// The label used for the maximum time limit in the date range picker.
  String dateRangeMaximumDateLimitLabel(Duration duration);

  /// The character string used to separate the start time and end time of
  /// datetime range picker.
  String get dateRangeDateSeparator;

  /// Label for take photo choice on image picker.
  String get photographTileLabel;

  /// Label for make video choice on image picker.
  String get captureTileLabel;

  /// Label for select photo choice on image picker.
  String get selectPhotoTileLabel;

  /// Label for select video choice on image picker.
  String get selectVideoTileLabel;

  /// Label for loading to describe a state of loading.
  String get loadingLabel;

  /// Message for shown when no camera permission.
  String get noCameraPermissionMessage;

  /// Label for video speed.
  String get videoSpeedLabel;

  /// The default hint for the input form fields.
  String get textFormFieldHint;

  /// The default hint for the picker form fields.
  String get pickerFormFieldHint;

  /// The default hint for the signature form fields.
  String get signatureFormFieldHint;

  /// The label used for the minimum quantity limit in the multi pickers.
  String minimumSelectableQuantityLimitLabel(int number);

  /// The label used for the maximum quantity limit in the multi pickers.
  String maximumSelectableQuantityLimitLabel(int number);

  /// The label used for the minimum quantity limit in the file pickers.
  String minimumFileLimitLabel(int number);

  /// The label used for the maximum quantity limit in the file pickers.
  String maximumFileLimitLabel(int number);

  /// The label used for the minimum quantity limit in the photo pickers.
  String maximumPhotoLimitLabel(int number);

  /// The label used for the maximum quantity limit in the photo pickers.
  String minimumPhotoLimitLabel(int number);

  /// The label used to limit the maximum value of digital input.
  String maximumNumberLimitLabel(num number);

  /// The label used to limit the minimum value of digital input.
  String minimumNumberLimitLabel(num number);

  static TxLocalizations of(BuildContext context) {
    assert(() {
      if (Localizations.of<TxLocalizations>(context, TxLocalizations) == null) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary('No TxLocalizations found.'),
          ErrorDescription(
            '${context.widget.runtimeType} widgets require TxLocalizations '
            'to be provided by a Localizations widget ancestor.',
          ),
          ErrorDescription(
            'The material library uses Localizations to generate messages, '
            'labels, and abbreviations.',
          ),
          ErrorHint(
            'To introduce a TxLocalizations, either use a '
            'MaterialApp at the root of your application to include them '
            'automatically, or add a Localization widget with a '
            'TxLocalizations delegate.',
          ),
          ...context.describeMissingAncestor(
              expectedAncestorType: TxLocalizations),
        ]);
      }
      return true;
    }());
    return Localizations.of<TxLocalizations>(context, TxLocalizations)!;
  }

  static const LocalizationsDelegate<TxLocalizations> delegate =
      _TxLocalizationsDelegate();
}

class _TxLocalizationsDelegate extends LocalizationsDelegate<TxLocalizations> {
  const _TxLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      locale.languageCode == 'en' || locale.languageCode == 'zh';

  @override
  Future<TxLocalizations> load(Locale locale) =>
      DefaultTxLocalizations.load(locale);

  @override
  bool shouldReload(_TxLocalizationsDelegate old) => false;

  @override
  String toString() => 'DefaultTxLocalizations.delegate(en_US)';
}

class DefaultTxLocalizations implements TxLocalizations {
  const DefaultTxLocalizations();

  static Future<TxLocalizations> load(Locale locale) {
    if (locale.languageCode == 'zh') {
      return SynchronousFuture<TxLocalizations>(const ZhTxLocalizations());
    }
    return SynchronousFuture<TxLocalizations>(const DefaultTxLocalizations());
  }

  @override
  String get customTitle => 'Custom';

  @override
  String get quickChoiceTitle => 'Quick Choices';

  @override
  String recentDaysLabel(int count) {
    assert(count > 0);
    return 'Last $count ${count == 1 ? 'day' : 'days'}';
  }

  @override
  String recentMonthsLabel(int count) {
    assert(count > 0);
    return 'Last $count ${count == 1 ? 'month' : 'months'}';
  }

  @override
  String recentWeeksLabel(int count) {
    assert(count > 0);
    return 'Last $count ${count == 1 ? 'week' : 'weeks'}';
  }

  @override
  String recentYearsLabel(int count) {
    assert(count > 0);
    return 'Last $count ${count == 1 ? 'year' : 'years'}';
  }

  @override
  String get dialogContent => 'Are you sure to continue?';

  @override
  String get dialogTitle => 'Operating Tips';

  @override
  String get informationDialogTitle => 'Information';

  @override
  String get pickerTitle => 'Select';

  @override
  String get datetimePickerTitle => 'Select Datetime';

  @override
  String get monthPickerTitle => 'Select Month';

  @override
  String get yearPickerTitle => 'Select Year';

  @override
  String get clearButtonLabel => 'Clear';

  @override
  String get collapsedButtonLabel => 'Collapsed';

  @override
  String get moreButtonLabel => 'More';

  @override
  String get previewButtonLabel => 'Preview';

  @override
  String get shareButtonLabel => 'Share';

  @override
  String get selectPhotoButtonLabel => 'Select Photo';

  @override
  String get fullScreenButtonTooltip => 'Full screen';

  @override
  String get fullScreenExitButtonTooltip => 'Exit full screen';

  @override
  String get redoButtonTooltip => 'Redo';

  @override
  String get undoButtonTooltip => 'Undo';

  @override
  String get doneButtonTooltip => 'Edit';

  @override
  String get editButtonTooltip => 'Done';

  @override
  String get drawButtonTooltip => 'Draw';

  @override
  String get selectFileButtonTooltip => 'Select file';

  @override
  String get unknownFileSizeLabel => 'Unknown size';

  @override
  String dateRangeMaximumDateLimitLabel(Duration duration) {
    final String time = formatDuration(duration);
    return 'The difference between the start time and end time must be less '
        'than $time';
  }

  @override
  String dateRangeMinimumDateLimitLabel(Duration duration) {
    final String time = formatDuration(duration);
    return 'The difference between the start time and end time must be greater '
        'than $time';
  }

  @override
  String get datetimeRangePickerTitle => 'Select Time Range';

  @override
  String formatDuration(Duration duration) {
    if (duration.inDays >= 1) {
      return '${duration.inDays} days';
    } else if (duration.inHours >= 1) {
      return '${duration.inHours} hours';
    }
    return '${duration.inMinutes} minutes';
  }

  @override
  String get dateRangeDateSeparator => '-';

  @override
  String get captureTileLabel => 'Capture';

  @override
  String get photographTileLabel => 'Photograph';

  @override
  String get selectPhotoTileLabel => 'Select Photo';

  @override
  String get selectVideoTileLabel => 'Select Video';

  @override
  String get loadingLabel => 'Loading';

  @override
  String get noCameraPermissionMessage => 'No camera permission';

  @override
  String get videoSpeedLabel => 'Speed';

  String _formatUnit(int number, String unit) {
    return '$number ${number > 1 ? '${unit}s' : unit}';
  }

  @override
  String maximumSelectableQuantityLimitLabel(int number) =>
      'Select up to ${_formatUnit(number, 'item')}';

  @override
  String minimumSelectableQuantityLimitLabel(int number) =>
      'Select at least ${_formatUnit(number, 'item')}';

  @override
  String get pickerFormFieldHint => 'Please select';

  @override
  String get textFormFieldHint => 'Please enter';

  @override
  String get signatureFormFieldHint => 'Please sign your name';

  @override
  String maximumFileLimitLabel(int number) =>
      'Select up to ${_formatUnit(number, 'file')}';

  @override
  String minimumFileLimitLabel(int number) =>
      'Select at least ${_formatUnit(number, 'file')}';

  @override
  String maximumPhotoLimitLabel(int number) =>
      'Select up to ${_formatUnit(number, 'photo')}';

  @override
  String minimumPhotoLimitLabel(int number) =>
      'Select at least ${_formatUnit(number, 'photo')}';

  @override
  String maximumNumberLimitLabel(num number) =>
      'The input value should be less than $number';

  @override
  String minimumNumberLimitLabel(num number) =>
      'The input value should be greater than $number';
}

class ZhTxLocalizations implements TxLocalizations {
  const ZhTxLocalizations();

  @override
  String get customTitle => '自定义';

  @override
  String get quickChoiceTitle => '快捷选择';

  @override
  String recentDaysLabel(int count) {
    assert(count > 0);
    return '近$count日';
  }

  @override
  String recentMonthsLabel(int count) {
    assert(count > 0);
    return '近$count月';
  }

  @override
  String recentWeeksLabel(int count) {
    assert(count > 0);
    return '近$count周';
  }

  @override
  String recentYearsLabel(int count) {
    assert(count > 0);
    return '近$count年';
  }

  @override
  String get dialogContent => '确认执行此操作吗？';

  @override
  String get dialogTitle => '操作提示';

  @override
  String get informationDialogTitle => '信息';

  @override
  String get pickerTitle => '请选择';

  @override
  String get datetimePickerTitle => '选择时间';

  @override
  String get monthPickerTitle => '选择月份';

  @override
  String get yearPickerTitle => '选择年份';

  @override
  String get clearButtonLabel => '清除';

  @override
  String get collapsedButtonLabel => '收起';

  @override
  String get moreButtonLabel => '更多';

  @override
  String get previewButtonLabel => '预览';

  @override
  String get shareButtonLabel => '分享';

  @override
  String get selectPhotoButtonLabel => '选择照片';

  @override
  String get fullScreenButtonTooltip => '全屏';

  @override
  String get fullScreenExitButtonTooltip => '退出全屏';

  @override
  String get redoButtonTooltip => '还原';

  @override
  String get undoButtonTooltip => '撤销';

  @override
  String get doneButtonTooltip => '编辑';

  @override
  String get editButtonTooltip => '完成';

  @override
  String get drawButtonTooltip => '绘制';

  @override
  String get selectFileButtonTooltip => '选择文件';

  @override
  String get unknownFileSizeLabel => '未知大小';

  @override
  String dateRangeMaximumDateLimitLabel(Duration duration) {
    final String time = formatDuration(duration);
    return '开始时间与结束时间时间差应小于$time';
  }

  @override
  String dateRangeMinimumDateLimitLabel(Duration duration) {
    final String time = formatDuration(duration);
    return '开始时间与结束时间时间差应大于$time';
  }

  @override
  String get datetimeRangePickerTitle => '选择时间范围';

  @override
  String formatDuration(Duration duration) {
    if (duration.inDays >= 1) {
      return '${duration.inDays}日';
    } else if (duration.inHours >= 1) {
      return '${duration.inHours}小时';
    }
    return '${duration.inMinutes}分钟';
  }

  @override
  String get dateRangeDateSeparator => '至';

  @override
  String get captureTileLabel => '拍摄';

  @override
  String get photographTileLabel => '拍照';

  @override
  String get selectPhotoTileLabel => '选择照片';

  @override
  String get selectVideoTileLabel => '选择视频';

  @override
  String get loadingLabel => '正在加载';

  @override
  String get noCameraPermissionMessage => '未开启摄像头权限';

  @override
  String get videoSpeedLabel => '播放速度';

  @override
  String maximumSelectableQuantityLimitLabel(int number) => '最多可选择$number项';

  @override
  String minimumSelectableQuantityLimitLabel(int number) => '请至少选择$number项';

  @override
  String get pickerFormFieldHint => '请选择';

  @override
  String get textFormFieldHint => '请输入';

  @override
  String get signatureFormFieldHint => '请签名';

  @override
  String maximumFileLimitLabel(int number) => '最多可选择$number个文件';

  @override
  String minimumFileLimitLabel(int number) => '请至少选择$number个文件';

  @override
  String maximumPhotoLimitLabel(int number) => '最多可选择$number张图片';

  @override
  String minimumPhotoLimitLabel(int number) => '请至少选择$number张图片';

  @override
  String maximumNumberLimitLabel(num number) => '输入值应小于$number';

  @override
  String minimumNumberLimitLabel(num number) => '输入值应大于$number';
}
