import 'package:flutter/material.dart';

import 'tokens.dart';

abstract final class NoteTokens {
  static const detailHeight = 256.0;
  static const detailLines = 8;
  static const recallHeight = 168.0;
  static const recallLines = 5;
  static const editorHeight = 440.0;
  static const editor = TextStyle(
    fontFamily: Tokens.fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w400,
    height: 34 / 24,
  );
}
