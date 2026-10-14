import 'package:flutter/material.dart';

import 'tokens.dart';

abstract final class MaterialTokens {
  static const cardRadius = 22.0;
  static const progressHeight = 6.0;
  static const progressRadius = 3.0;
  static const readerInset = 26.0;
  static const readerRadius = 20.0;
  static const highlightInset = 6.0;
  static const highlightRadius = 6.0;
  static const readerBarBlur = 7.5;
  static const coverSize = 150.0;
  static const coverRadius = 36.0;
  static const waveformHeight = 48.0;
  static const waveformWidth = 4.0;
  static const waveformGap = 3.0;
  static const waveformRadius = 2.0;
  static const audioButton = 72.0;
  static const skipButton = 52.0;
  static const audioGap = 26.0;
  static const waveform = [
    10.0,
    18.0,
    28.0,
    14.0,
    36.0,
    22.0,
    40.0,
    30.0,
    16.0,
    26.0,
    44.0,
    32.0,
    20.0,
    38.0,
    24.0,
    12.0,
    30.0,
    42.0,
    26.0,
    18.0,
    34.0,
    22.0,
    14.0,
    28.0,
    36.0,
    20.0,
    12.0,
    24.0,
    30.0,
    16.0,
    22.0,
    10.0,
  ];
  static const playbackSpeeds = [0.75, 1.0, 1.25, 1.5, 2.0];
  static const skipSeconds = 15;
  static const readerBody = TextStyle(
    fontFamily: Tokens.fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 23 / 15,
  );
  static const readerTitle = TextStyle(
    fontFamily: Tokens.fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 30 / 24,
  );
  static final highlightBody = readerBody.copyWith(fontWeight: FontWeight.w500);
  static final section = Tokens.dataLabel.copyWith(letterSpacing: 1.2);
  static final compact = ContractTokens.materialMeta.copyWith(
    fontWeight: FontWeight.w600,
  );
}
