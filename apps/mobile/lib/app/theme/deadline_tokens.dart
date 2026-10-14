import 'package:flutter/material.dart';

import 'tokens.dart';

abstract final class DeadlineTokens {
  static const cardRadius = 22.0;
  static const dateWidth = 52.0;
  static const dateHeight = 56.0;
  static const heroDateWidth = 67.6;
  static const heroDateHeight = 72.8;
  static const heroDateRadius = 20.8;
  static const copyGap = 3.0;
  static const stopGap = 6.0;
  static const stopWidth = 30.0;
  static const stopDayWidth = 40.0;
  static const stopHeight = 20.0;
  static const stopRadius = 10.0;
  static const stopBorder = 1.4;
  static const actionWidth = 72.0;
  static const revealWidth = 160.0;
  static const calendarSelection = 36.0;
  static const calendarWidth = Tokens.minTouchTarget * DateTime.daysPerWeek;
  static const largeTextThreshold = 1.1;
  static const badgePadding = EdgeInsets.symmetric(horizontal: 9, vertical: 4);
  static const shortMeta = TextStyle(
    fontFamily: Tokens.fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 18 / 13,
  );
  static const badge = TextStyle(
    fontFamily: Tokens.fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    height: 16 / 11,
  );
  static const month = TextStyle(
    fontFamily: Tokens.fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.8,
  );
  static const day = TextStyle(
    fontFamily: Tokens.fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.4,
    height: 24 / 20,
  );
  static final heroMonth = month.copyWith(fontSize: 13, letterSpacing: 1.04);
  static final heroDay = day.copyWith(fontSize: 26, letterSpacing: -0.52);
  static final detailTitle = Tokens.headline.copyWith(
    fontSize: 28,
    height: 34 / 28,
  );
  static final stopLabel = month.copyWith(
    letterSpacing: 0,
    height: stopHeight / 10,
  );
}
