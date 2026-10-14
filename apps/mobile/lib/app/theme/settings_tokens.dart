import 'package:flutter/material.dart';

import 'tokens.dart';

abstract final class SettingsTokens {
  static const heroSize = 64.0;
  static const heroRadius = 22.0;
  static const proRadius = 22.0;
  static const proGap = 14.0;
  static const reminderMaximumLead = 60;
  static const reminderLeadStep = 5;
  static const proTitle = TextStyle(
    fontFamily: Tokens.fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );
  static const proBody = TextStyle(
    fontFamily: Tokens.fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );
}
