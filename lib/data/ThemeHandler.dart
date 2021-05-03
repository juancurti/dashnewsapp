import 'package:flutter/material.dart';

class ThemeHandler {
  static Color getBackgroundColor({bool dark}) {
    return dark
        ? Color.fromRGBO(60, 66, 72, 1)
        : Color.fromRGBO(243, 243, 243, 1);
  }

  static Color getCardBackgroundColor({bool dark}) {
    return dark
        ? Color.fromRGBO(17, 25, 33, 1)
        : Color.fromRGBO(255, 255, 255, 1);
  }

  static Color getTextColor({bool dark}) {
    return dark
        ? Color.fromRGBO(242, 242, 242, 1)
        : Color.fromRGBO(1, 32, 96, 1);
  }

  static Color getBottomBarColor({bool dark}) {
    return dark
        ? Color.fromRGBO(17, 25, 33, 1)
        : Color.fromRGBO(255, 255, 255, 1);
  }

  static Color getTopBarColor({bool dark}) {
    return dark
        ? Color.fromRGBO(17, 25, 33, 1)
        : Color.fromRGBO(0, 116, 187, 1);
  }

  static Color getShadowCardColor({bool dark}) {
    return dark
        ? Color.fromRGBO(17, 25, 33, 1)
        : Color.fromRGBO(242, 242, 242, 1);
  }
}
