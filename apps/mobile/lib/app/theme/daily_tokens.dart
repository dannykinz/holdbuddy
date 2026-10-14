import 'package:flutter/material.dart';

import 'tokens.dart';

abstract final class DailyTokens {
  static const emptyHeroSize = 72.0;
  static const emptyHeroRadius = 26.0;
  static const modeRadioSize = 22.0;
  static const navFadeHeight = 170.0;
  static const tabBottomInset = 160.0;
  static const contentGap = 22.0;
  static const rowGap = 10.0;
  static const copyGap = 2.0;
  static const heroSize = 56.0;
  static const heroRadius = 19.0;
  static const heroIconSize = 28.0;
  static const rowTileSize = 40.0;
  static const rowTileRadius = 14.0;
  static const headerAvatarSize = 44.0;
  static const headerIconSize = 20.0;
  static const badgeSize = 18.0;
  static const badgeTop = -2.0;
  static const badgeRight = -2.0;
  static const tonightRadius = 28.0;
  static const subcardRadius = 20.0;
  static const subcardPadding = 14.0;
  static const subcardGap = 6.0;
  static const taskSegmentHeight = 5.0;
  static const taskSegmentRadius = 3.0;
  static const noteWidth = 200.0;
  static const noteHeight = 136.0;
  static const noteRadius = 22.0;
  static const notesHeight = 150.0;
  static const notesLines = 4;
  static const dateTileWidth = 52.0;
  static const dateTileHeight = 56.0;
  static const navClearance = 96.0;
  static const dateGap = 6.0;
  static const statGap = 18.0;
  static const skeletonLineHeight = 44.0;
  static const skeletonCardHeight = 232.0;
  static const skeletonRowHeight = 90.0;
  static const countdownInterval = Duration(seconds: 1);
  static const dayNumber = TextStyle(
    fontFamily: Tokens.fontFamily,
    fontSize: 40,
    fontWeight: FontWeight.w700,
    height: 48 / 40,
    letterSpacing: -1.2,
  );
  static const time = TextStyle(
    fontFamily: Tokens.fontFamily,
    fontSize: 42,
    fontWeight: FontWeight.w700,
    height: 1,
    letterSpacing: -1.5,
  );
  static const dateTileNumber = TextStyle(
    fontFamily: Tokens.fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w700,
  );
}
