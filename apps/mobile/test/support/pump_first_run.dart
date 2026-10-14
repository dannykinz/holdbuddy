import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:holdbuddy/app/router/app_route.dart';
import 'package:holdbuddy/app/router/app_router.dart';
import 'package:holdbuddy/core/fakes/fake_repository_overrides.dart';
import 'package:holdbuddy/core/l10n/generated/app_localizations.dart';

Future<GoRouter> pumpFirstRun(
  WidgetTester tester,
  ThemeData theme,
  AppRoute route, {
  double width = 390,
  double height = 844,
  double textScale = 1,
  bool reducedMotion = false,
}) async {
  tester.view.physicalSize = Size(width, height);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  final router = AppRouter.create(initialRoute: route);
  addTearDown(router.dispose);
  await tester.pumpWidget(_app(theme, router, textScale, reducedMotion));
  await tester.pump();
  await _precachePortraits(tester);
  await tester.pump();
  return router;
}

Widget _app(ThemeData theme, GoRouter router, double scale, bool reduced) =>
    ProviderScope(
      overrides: fakeRepositoryOverrides(),
      child: MaterialApp.router(
        theme: theme,
        routerConfig: router,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(scale),
            disableAnimations: reduced,
            padding: const EdgeInsets.only(top: 40, bottom: 18),
          ),
          child: RepaintBoundary(
            key: const ValueKey('first_run_preview'),
            child: child ?? const SizedBox.shrink(),
          ),
        ),
      ),
    );

Future<void> _precachePortraits(WidgetTester tester) async {
  final context = tester.element(find.byType(Scaffold).last);
  await tester.runAsync(() async {
    for (final mode in ['', 'dark_']) {
      for (var index = 0; index < 5; index++) {
        await precacheImage(
          AssetImage('assets/avatars/onboarding_${mode}face_$index.png'),
          context,
        );
      }
    }
    await precacheImage(
      const AssetImage('assets/avatars/onboarding_face_5.png'),
      context,
    );
  });
}
