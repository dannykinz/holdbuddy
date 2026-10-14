import 'package:flutter/material.dart';

import 'tokens.dart';

/// Component measurements verified against the U1 Figma source nodes.
abstract final class WidgetTokens {
  static const lineWidth = 1.0;
  static const focusWidth = 1.5;
  static const activeWidth = 2.0;
  static const buttonEdge = 4.0;
  static const pressedEdge = lineWidth;
  static const buttonGap = 10.0;
  static const fieldLabelGap = 6.0;
  static const hatchStroke = 1.4;
  static const hatchGap = 6.0;
  static const hatchOpacity = 0.3;
  static const lightHatchOpacity = 0.28;
  static const dayWidth = 44.0;
  static const dayHeight = 68.0;
  static const dayGap = 3.0;
  static const dayDot = 5.0;
  static const weekdayHeight = 52.0;
  static const progressHeight = 12.0;
  static const progressGap = 4.0;
  static const progressRadius = 6.0;
  static const avatarSize = 34.0;
  static const avatarOverlap = 22.0;
  static const avatarRing = 2.0;
  static const avatarStackCount = 3;
  static const chipHorizontal = 10.0;
  static const chipVertical = 7.0;
  static const sheetHandleWidth = 40.0;
  static const sheetHandleHeight = 5.0;
  static const sheetHandleRadius = 3.0;
  static const sheetGap = 14.0;
  static const sheetBottom = 34.0;
  static const sheetScrimOpacity = 0.42;
  static const stepCount = 4;
  static const stepHeight = 6.0;
  static const stepRadius = 3.0;
  static const stepGap = 6.0;
  static const codeLength = 6;
  static const codeHeight = 60.0;
  static const codeCursorWidth = 2.0;
  static const codeCursorHeight = 24.0;
  static const segmentInset = 4.0;
  static const segmentHeight = 40.0;
  static const nodeSize = 58.0;
  static const currentNodeSize = 74.0;
  static const nodeGlowSize = 104.0;
  static const nodeShadowOpacity = 0.14;
  static const heroTileSize = 64.0;
  static const heroTileRadius = 22.0;
  static const createShadowOffset = Offset(0, 12);
  static const createShadowBlur = 24.0;
  static const createShadowSpread = -6.0;
  static const createShadowOpacity = 0.18;
  static const hiddenOpacity = 0.0;
  static const motionDuration = Duration(milliseconds: 280);
  static const chipLabel = TextStyle(
    inherit: false,
    fontFamily: Tokens.fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );
  static const dayLabel = TextStyle(
    inherit: false,
    fontFamily: Tokens.fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.4,
  );
  static const dayNumber = TextStyle(
    inherit: false,
    fontFamily: Tokens.fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w700,
  );
  static const codeDigit = TextStyle(
    inherit: false,
    fontFamily: Tokens.fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
  );
  static const nodeNumber = TextStyle(
    inherit: false,
    fontFamily: Tokens.fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w700,
  );
  static const sheetTitle = TextStyle(
    inherit: false,
    fontFamily: Tokens.fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
  );
}
