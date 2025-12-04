import 'package:flutter/widgets.dart';

class ScreenConfig {
  static late double screenWidth;
  static late double screenHeight;
  static late double blockWidth;
  static late double blockHeight;
  static bool _initialized = false;

  static void init(BuildContext context) {
    if (_initialized) return;

    final mediaQuery = MediaQuery.of(context);
    screenWidth = mediaQuery.size.width;
    screenHeight = mediaQuery.size.height;
    blockWidth = screenWidth / 100;
    blockHeight = screenHeight / 100;

    _initialized = true;
  }
}
