import 'package:flutter/material.dart';

import 'app_color.dart';
import 'app_colors.dart';

export 'feature_tokens.dart';

abstract final class Tokens {
  static const ink = Color(0xFF000000);
  static const buttonHighlight = Color(0x33FFFFFF);
  static const _darkShadow = Color(0xFF060709);
  static const _floatingShadow = Color(0xFF0D121F);
  static const _activeShadow = Color(0xFF0F1424);
  static const _white = Color(0xFFFFFFFF);
  static const glassLightOpacity = 0.90;
  static const glassDarkOpacity = 0.88;
  static const glassDarkEdgeOpacity = 0.08;
  static const glassDarkActiveOpacity = 0.14;

  static final light = AppColors({
    AppColor.bg: const Color(0xFFFAFBFD),
    AppColor.surface: _white,
    AppColor.soft: const Color(0xFFF0F2F6),
    AppColor.line: const Color(0xFFE3E6EC),
    AppColor.text: const Color(0xFF12151C),
    AppColor.muted: const Color(0xFF616A79),
    AppColor.subtle: const Color(0xFF8992A2),
    AppColor.primary: const Color(0xFF316DEB),
    AppColor.onPrimary: _white,
    AppColor.primaryEdge: const Color(0xFF225BD3),
    AppColor.accent: const Color(0xFF2F66D4),
    AppColor.tint: const Color(0xFFEBF2FF),
    AppColor.tintLine: const Color(0xFFCFDFFF),
    AppColor.nav: const Color(0xFFEBEDF1),
    AppColor.navActive: _white,
    AppColor.error: const Color(0xFFBC3445),
    AppColor.errorBg: const Color(0xFFFFF0F2),
    AppColor.success: const Color(0xFF216C56),
    AppColor.successBg: const Color(0xFFEDF7F2),
    AppColor.shadow: const Color(0xFFCBD1DE),
    AppColor.purple: const Color(0xFF7357F6),
    AppColor.purpleSoft: const Color(0xFFF1EDFF),
    AppColor.orange: const Color(0xFFF2742B),
    AppColor.orangeSoft: const Color(0xFFFFF0E6),
    AppColor.sky: const Color(0xFF1A9FE0),
    AppColor.skySoft: const Color(0xFFE6F5FD),
    AppColor.green: const Color(0xFF139E6B),
    AppColor.greenSoft: const Color(0xFFE5F7EF),
    AppColor.pink: const Color(0xFFE5487F),
    AppColor.pinkSoft: const Color(0xFFFDEBF2),
    AppColor.glass: const Color(0xFFF1F3F6)
        .withValues(alpha: glassLightOpacity),
    AppColor.glassEdge: _white.withValues(alpha: glassLightOpacity),
    AppColor.glassActive: _white,
    AppColor.floatingShadow: _floatingShadow,
    AppColor.activeShadow: _activeShadow,
  });

  static final dark = AppColors({
    AppColor.bg: const Color(0xFF101113),
    AppColor.surface: const Color(0xFF1B1C1F),
    AppColor.soft: const Color(0xFF24262B),
    AppColor.line: const Color(0xFF303239),
    AppColor.text: const Color(0xFFF7F8FA),
    AppColor.muted: const Color(0xFFA5AAB5),
    AppColor.subtle: const Color(0xFF8A919F),
    AppColor.primary: _white,
    AppColor.onPrimary: const Color(0xFF16181D),
    AppColor.primaryEdge: const Color(0xFFAFB3BB),
    AppColor.accent: const Color(0xFF9ABEFF),
    AppColor.tint: const Color(0xFF182538),
    AppColor.tintLine: const Color(0xFF2F4667),
    AppColor.nav: const Color(0xFF1A1C20),
    AppColor.navActive: const Color(0xFF34373E),
    AppColor.error: const Color(0xFFFF9BA7),
    AppColor.errorBg: const Color(0xFF321D23),
    AppColor.success: const Color(0xFF9CCBB8),
    AppColor.successBg: const Color(0xFF1A2A24),
    AppColor.shadow: _darkShadow,
    AppColor.purple: const Color(0xFFB4A3FF),
    AppColor.purpleSoft: const Color(0xFF231E3B),
    AppColor.orange: const Color(0xFFFFB184),
    AppColor.orangeSoft: const Color(0xFF33231A),
    AppColor.sky: const Color(0xFF82D2FF),
    AppColor.skySoft: const Color(0xFF152838),
    AppColor.green: const Color(0xFF7EDDB4),
    AppColor.greenSoft: const Color(0xFF14291F),
    AppColor.pink: const Color(0xFFFF9DC0),
    AppColor.pinkSoft: const Color(0xFF331E28),
    AppColor.glass: const Color(0xFF1C1D20).withValues(alpha: glassDarkOpacity),
    AppColor.glassEdge: _white.withValues(alpha: glassDarkEdgeOpacity),
    AppColor.glassActive: _white.withValues(alpha: glassDarkActiveOpacity),
    AppColor.floatingShadow: _floatingShadow,
    AppColor.activeShadow: _activeShadow,
  });

  static const space8 = 8.0;
  static const space12 = 12.0;
  static const space16 = 16.0;
  static const space20 = 20.0;
  static const space24 = 24.0;
  static const screenMargin = space24;
  static const radiusButton = 18.0;
  static const radiusField = space16;
  static const radiusCard = space24;
  static const radiusIconTile = 15.0;
  static const radiusSheet = 28.0;
  static const chipShape = StadiumBorder();
  static const buttonHeight = 56.0;
  static const iconTileSize = navItemHeight;
  static const minTouchTarget = 48.0;
  static const navHeight = 54.0;
  static const navItemHeight = 44.0;
  static const navIconSize = space20;
  static const navGap = 2.0;
  static const navInset = 5.0;
  static const navLabelGap = 7.0;
  static const navLabelInset = 14.0;
  static const navActivePadding = EdgeInsets.only(
    left: navLabelInset,
    right: space16,
  );
  static const navRadius = radiusSheet;
  static const navItemRadius = 22.0;
  static const navBlur = radiusButton;
  static const navShadowOffset = Offset(0, navLabelInset);
  static const navShadowBlur = 17.0;
  static const navShadowOpacity = 0.12;
  static const navActiveShadowOffset = Offset(0, navGap);
  static const navActiveShadowBlur = space8;
  static const navActiveShadowOpacity = glassDarkEdgeOpacity;
  static const fontFamily = 'Inter';
  static const trackingNormal = 0.0;
  static const trackingTight = -0.8;

  static const display = TextStyle(
    fontFamily: fontFamily,
    fontSize: 40,
    fontWeight: FontWeight.w600,
    letterSpacing: trackingTight,
    height: 46 / 40,
  );
  static const headline = TextStyle(
    fontFamily: fontFamily,
    fontSize: 30,
    fontWeight: FontWeight.w600,
    letterSpacing: trackingTight,
    height: 36 / 30,
  );
  static const title = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: trackingTight,
    height: 28 / 22,
  );
  static const body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: trackingNormal,
    height: 24 / 16,
  );
  static final strong = body.copyWith(fontWeight: FontWeight.w600);
  static const small = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: trackingNormal,
    height: 20 / 14,
  );
  static const meta = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: trackingNormal,
    height: 16 / 12,
  );
  static const timer = TextStyle(
    fontFamily: fontFamily,
    fontSize: 72,
    fontWeight: FontWeight.w600,
    letterSpacing: trackingTight,
    height: 84 / 72,
  );
  static final label = small.copyWith(fontWeight: FontWeight.w500);
  static const dataLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 1,
  );
}
