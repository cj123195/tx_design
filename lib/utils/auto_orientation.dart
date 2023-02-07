import 'package:flutter/services.dart';

enum OrientationMode {
  landscapeLeft,
  landscapeRight,
  portraitUp,
  portraitDown,
  portraitAuto,
  landscapeAuto,
  fullAuto
}

/// 提供以编程方式横向或纵向旋转设备的类
class AutoOrientation {
  /// 此方法用于提供给开发者以更简便的方式取修改设备方向
  static setOrientation(OrientationMode mode) async {
    switch (mode) {
      case OrientationMode.landscapeLeft:
        await landscapeLeftMode();
        break;
      case OrientationMode.landscapeRight:
        await landscapeRightMode();
        break;
      case OrientationMode.portraitUp:
        await portraitUpMode();
        break;
      case OrientationMode.portraitDown:
        await portraitDownMode();
        break;
      case OrientationMode.portraitAuto:
        await portraitAutoMode();
        break;
      case OrientationMode.landscapeAuto:
        await landscapeAutoMode();
        break;
      case OrientationMode.fullAuto:
        await fullAutoMode();
        break;
    }
  }

  /// 将设备旋转到横向左侧模式
  static landscapeLeftMode() async {
    await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft]);
  }

  /// 将设备旋转到横向右侧模式
  static landscapeRightMode() async {
    await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeRight]);
  }

  /// 将设备旋转到纵向模式
  static portraitUpMode() async {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  /// 将设备旋转到纵向向下模式
  static portraitDownMode() async {
    await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown]);
  }

  /// 将设备旋转到纵向自动模式
  static portraitAutoMode() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  /// 将设备旋转到横向自动模式
  static landscapeAutoMode() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  /// 将设备旋转到横向自动模式
  static fullAutoMode() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}
