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

  /// Content text for default dialog;
  String get dialogContent;

  /// Label for recent days choice on quick choices.
  String recentDaysLabel(int count);

  /// Label for recent weeks choice on quick choices.
  String recentWeeksLabel(int count);

  /// Label for recent months choice on quick choices.
  String recentMonthsLabel(int count);

  /// Label for recent years choice on quick choices.
  String recentYearsLabel(int count);

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
}
