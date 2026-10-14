import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holdbuddy/app/theme/app_theme.dart';
import 'package:holdbuddy/app/theme/tokens.dart';
import 'package:holdbuddy/core/widgets/hb_avatar.dart';

import '../../support/load_inter_font.dart';
import '../../support/pump_shared_widget.dart';

void main() {
  setUpAll(loadInterFont);
  for (final theme in [AppTheme.light, AppTheme.dark]) {
    _faceTest(theme);
    _failureTest(theme);
  }
}

void _faceTest(ThemeData theme) {
  testWidgets(
    '${theme.brightness} avatar uses a local face with an accessible name',
    (tester) async {
      await pumpSharedWidget(
        tester,
        theme,
        (_) => const Align(
          alignment: Alignment.topLeft,
          child: HbAvatar(
            image: AssetImage('assets/avatars/profile.png'),
            label: 'Danny',
            size: Tokens.iconTileSize,
          ),
        ),
      );
      expect(find.bySemanticsLabel('Danny'), findsOneWidget);
      expect(find.byType(ClipOval), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}

void _failureTest(ThemeData theme) {
  testWidgets(
    '${theme.brightness} unavailable avatar is labelled and does not crash',
    (tester) async {
      await pumpSharedWidget(
        tester,
        theme,
        (_) => const Align(
          alignment: Alignment.topLeft,
          child: HbAvatar(
            image: AssetImage('assets/avatars/unavailable.png'),
            label: 'Danny',
          ),
        ),
      );
      expect(find.bySemanticsLabel('Photo unavailable'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
