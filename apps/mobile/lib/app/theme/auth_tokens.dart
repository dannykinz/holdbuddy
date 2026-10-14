import 'package:flutter/material.dart';

import 'tokens.dart';

abstract final class AuthTokens {
  static const noticeGap = 4.0;
  static const heroSize = 64.0;
  static const heroRadius = 22.0;
  static const portraitRing = 2.0;
  static const noticeIconSize = Tokens.space16;
  static const fieldLabel = TextStyle(
    fontFamily: Tokens.fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 24 / 14,
  );
  static const dividerLabel = TextStyle(
    fontFamily: Tokens.fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );
  static const finePrint = TextStyle(
    fontFamily: Tokens.fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 20 / 13,
  );
}
