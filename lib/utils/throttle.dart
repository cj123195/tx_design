import 'dart:async';

/// 节流与防抖
class Throttle {
  Throttle._();

  static const int _defaultDuration = 500;

  static final Map<String, bool> _funcThrottle = {};
  static final Map<String, Timer> _funcDebounce = {};

  /// 节流
  static Function throttle(
    Function() func, {
    String? id,
    int timeout = _defaultDuration,
    Function? funcWhenComplete,
  }) {
    return () {
      final String key = id ?? func.hashCode.toString();
      final bool enable = _funcThrottle[key] ?? true;
      if (enable) {
        _funcThrottle[key] = false;
        Timer(Duration(milliseconds: timeout), () {
          _funcThrottle.remove(key);
        });
        func.call();
      }
    };
  }

  /// 防抖
  static Function debounce(
    Function func, {
    String? id,
    int timeout = _defaultDuration,
  }) {
    return () {
      final String key = id ?? func.hashCode.toString();
      Timer? timer = _funcDebounce[key];
      if (timer == null) {
        func.call();
        timer = Timer(Duration(milliseconds: timeout), () {
          Timer? t = _funcDebounce.remove(key);
          t?.cancel();
          t = null;
        });
        _funcDebounce[key] = timer;
      }
    };
  }
}
