import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holdbuddy/app/theme/tokens.dart';
import 'package:holdbuddy/core/l10n/generated/app_localizations.dart';

Future<void> pumpSharedWidget(
  WidgetTester tester,
  ThemeData theme,
  WidgetBuilder builder, {
  double textScale = 1.3,
  double width = 320,
  double height = 800,
  bool settle = true,
}) async {
  tester.view.physicalSize = Size(width, height);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    MaterialApp(
      theme: theme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder: (context) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(textScale)),
          child: _preview(theme, builder),
        ),
      ),
    ),
  );
  if (settle) await tester.pumpAndSettle();
}

Widget _preview(ThemeData theme, WidgetBuilder builder) => Scaffold(
  body: RepaintBoundary(
    key: const ValueKey('shared_preview'),
    child: ColoredBox(
      color: theme.scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(Tokens.space24),
        child: Builder(builder: builder),
      ),
    ),
  ),
);
