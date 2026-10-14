import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'tokens.dart';

/// First-run illustration geometry from the five U2 Figma screens.
abstract final class OnboardingTokens {
  static const canvasWidth = 342.0;
  static const canvasHeight = 380.0;
  static const logoSize = 54.56;
  static const splashDelay = Duration(milliseconds: 1200);
  static const dissolveDuration = Duration(milliseconds: 400);
  static const bottomInset = 18.0;
  static const slideCount = 3;
  static const dotSize = 6.0;
  static const dotWidth = 24.0;
  static const dotRadius = 3.0;
  static const glowPosition = Offset(-43, -24);
  static const glowBlur = 32.0;
  static const heroGlowBlur = 35.0;
  static const progressPosition = Offset(40, -9.51);
  static const progressBounds = Size(240.865, 164.559);
  static const progressWidth = 225.72;
  static const contractProgressScale = 0.66;
  static const sessionPosition = Offset(35.38, 128);
  static const sessionBounds = Size(262.276, 255.076);
  static const sessionWidth = 246.24;
  static const contractSessionScale = 0.72;
  static const progressAngle = -7 * math.pi / 180;
  static const sessionAngle = 4 * math.pi / 180;
  static const nudgeAngle = 2 * math.pi / 180;
  static const returnAngle = -3 * math.pi / 180;
  static const portraitSlots = [
    Rect.fromLTWH(-3, 25, 112, 112),
    Rect.fromLTWH(233, 9, 116, 116),
    Rect.fromLTWH(221, 139, 140, 140),
    Rect.fromLTWH(74, 13, 194, 194),
    Rect.fromLTWH(17, 143, 144, 144),
  ];
  static const badgePosition = Offset(206, 36);
  static const badgeSize = 34.0;
  static const badgeBorder = 3.0;
  static const nudgePosition = Offset(18.07, 262);
  static const nudgeBounds = Size(302.749, 94.419);
  static const nudgeWidth = 300.0;
  static const nudgeAvatar = 38.0;
  static const nudgeInset = 14.0;
  static const nudgeTrailingInset = 18.0;
  static const weekPosition = Offset(17.79, 20);
  static const weekBounds = Size(292.791, 108.863);
  static const weekWidth = 287.28;
  static const weekScale = 0.84;
  static const recalculatedPosition = Offset(47, 147.49);
  static const recalculatedBounds = Size(247.57, 182.275);
  static const recalculatedWidth = 238.0;
  static const recalculatedRadius = 26.0;
  static const previewHeight = 252.0;
  static const previewRadius = 30.0;
  static const previewTopGap = 52.0;
  static const phonePosition = Offset(54, 34);
  static const phoneSize = Size(234, 506.4);
  static const phoneRadius = 34.0;
  static const phoneScale = 0.6;
  static const heroGlowPosition = Offset(-29, -10);
  static const alertBadgeSize = 18.0;
  static const illustrationShadowOpacity = 0.1;
  static const illustrationShadowOffset = Offset(0, 18);
  static const illustrationShadowBlur = 40.0;
  static const illustrationShadowSpread = -10.0;
  static const previewIconSize = 16.0;
  static const previewPenSize = 18.0;
  static const previewCount = TextStyle(
    inherit: false,
    fontFamily: Tokens.fontFamily,
    fontSize: 72,
    fontWeight: FontWeight.w700,
    letterSpacing: -2.9,
  );
  static const previewTime = TextStyle(
    inherit: false,
    fontFamily: Tokens.fontFamily,
    fontSize: 40,
    fontWeight: FontWeight.w700,
    letterSpacing: -1.6,
  );
  static const finishDate = TextStyle(
    inherit: false,
    fontFamily: Tokens.fontFamily,
    fontSize: 34,
    fontWeight: FontWeight.w700,
    letterSpacing: -1.2,
  );
  static const nudgeName = TextStyle(
    inherit: false,
    fontFamily: Tokens.fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w600,
  );
  static const nudgeMessage = TextStyle(
    inherit: false,
    fontFamily: Tokens.fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w500,
  );
  static const previewPeriod = TextStyle(
    inherit: false,
    fontFamily: Tokens.fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w700,
  );
  static const previewDate = TextStyle(
    inherit: false,
    fontFamily: Tokens.fontFamily,
    fontSize: 38,
    fontWeight: FontWeight.w700,
    letterSpacing: -1.4,
  );
  static const finishLabel = TextStyle(
    inherit: false,
    fontFamily: Tokens.fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.1,
  );
  static const finishMeta = TextStyle(
    inherit: false,
    fontFamily: Tokens.fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
  static const finishChip = TextStyle(
    inherit: false,
    fontFamily: Tokens.fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );
}
