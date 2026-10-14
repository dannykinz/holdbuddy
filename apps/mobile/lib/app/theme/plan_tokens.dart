import 'package:flutter/material.dart';

import 'tokens.dart';

abstract final class PlanTokens {
  static const pathWidth = 342.0;
  static const pathHeight = 690.0;
  static const labelGap = 14.0;
  static const labelOffset = 17.0;
  static const centers = <Offset>[
    Offset(171, 52),
    Offset(230, 144),
    Offset(239, 236),
    Offset(192, 328),
    Offset(127, 420),
    Offset(99, 512),
    Offset(131, 604),
  ];
  static const heading = TextStyle(
    fontFamily: Tokens.fontFamily,
    fontSize: 26,
    fontWeight: FontWeight.w700,
    height: 32 / 26,
    letterSpacing: -0.9,
  );
}
