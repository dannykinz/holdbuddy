import 'package:flutter/material.dart';

import 'tokens.dart';

abstract final class ContractTokens {
  static const pageBottom = 18.0;
  static const unitsGap = 14.0;
  static const messageLines = 5;
  static const messageHeight = 168.0;
  static const materialDash = 6.0;
  static const materialDashGap = 4.0;
  static const scopeUnitsFlex = 124;
  static const scopeNameFlex = 204;
  static const materialRadius = 20.0;
  static const materialTypeSize = 32.0;
  static const materialTypeRadius = 11.0;
  static const materialTypeOffset = 24.0;
  static const materialTypesWidth = 104.0;
  static const materialTypesHeight = 40.0;
  static const materialTypeInset = 4.0;
  static const materialIconSize = 16.0;
  static const materialTileSize = 44.0;
  static const materialTileRadius = 14.0;
  static const materialCopyGap = 2.0;
  static const holdDuration = Duration(seconds: 2);
  static const holdFillOpacity = 0.2;
  static const materialTitle = TextStyle(
    fontFamily: Tokens.fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w600,
  );
  static const materialMeta = TextStyle(
    fontFamily: Tokens.fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w400,
  );
}
