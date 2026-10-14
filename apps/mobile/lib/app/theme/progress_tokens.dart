import 'package:flutter/material.dart';

import 'tokens.dart';

abstract final class ProgressTokens {
  static const chartHeight = 190.0;
  static const chartWidth = 40.0;
  static const chartRadius = 14.0;
  static const pastOpacity = 0.42;
  static const milestoneWidth = 165.0;
  static const statisticWidth = 104.0;
  static const summary = TextStyle(
    fontFamily: Tokens.fontFamily,
    fontSize: 58,
    fontWeight: FontWeight.w700,
    height: 1.1,
    letterSpacing: -2.3,
  );
}
