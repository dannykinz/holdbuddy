import 'package:flutter/services.dart';
import 'package:holdbuddy/app/theme/tokens.dart';

Future<void> loadInterFont() async {
  final font = FontLoader(Tokens.fontFamily);
  font.addFont(rootBundle.load('assets/fonts/Inter.ttf'));
  await font.load();
}
