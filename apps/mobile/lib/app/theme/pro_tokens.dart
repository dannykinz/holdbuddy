import 'package:flutter/material.dart';

import 'tokens.dart';

abstract final class ProTokens {
  static const contentGap = 18.0;
  static const heroGap = 10.0;
  static const heroSize = 68.0;
  static const heroRadius = 22.0;
  static const cardRadius = 22.0;
  static const perkTileSize = 36.0;
  static const perkTileRadius = 12.0;
  static const perkVertical = 11.0;
  static const perkInset = 4.0;
  static const copyGap = 1.0;
  static const offerInset = 14.0;
  static const offerRadius = 20.0;
  static const offerBorder = 2.0;
  static const offerHeight = 96.0;
  static const priceGap = 3.0;
  static const bestValueHorizontal = 7.0;
  static const badgeSize = 200.0;
  static const glowOffset = -40.0;
  static const glowBlur = 20.0;
  static const welcomeCrownSize = 104.0;
  static const welcomeCrownRadius = 34.0;
  static const shadowOpacity = 0.25;
  static const shadowOffset = Offset(0, 16);
  static const shadowBlur = 32.0;
  static const adCtaWidth = 96.0;
  static const adImageSize = 56.0;
  static const adImageRadius = 14.0;
  static const adTagRadius = 6.0;
  static const title = TextStyle(
    fontFamily: Tokens.fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.6,
  );
  static const welcomeTitle = TextStyle(
    fontFamily: Tokens.fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: Tokens.trackingTight,
  );
  static const price = TextStyle(
    fontFamily: Tokens.fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.6,
  );
  static const offerLabel = TextStyle(
    fontFamily: Tokens.fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w600,
  );
  static const bestValue = TextStyle(
    fontFamily: Tokens.fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w700,
  );
  static const adTag = TextStyle(
    fontFamily: Tokens.fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w600,
  );
  static const body = TextStyle(
    fontFamily: Tokens.fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
  static const welcomeBody = TextStyle(
    fontFamily: Tokens.fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w400,
  );
  static const caption = TextStyle(
    fontFamily: Tokens.fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );
  static final cadence = caption.copyWith(fontWeight: FontWeight.w500);
}
