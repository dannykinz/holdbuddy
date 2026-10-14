import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:holdbuddy/app/router/app_route.dart';
import 'package:holdbuddy/app/router/app_router.dart';
import 'package:holdbuddy/app/router/navigation_error.dart';
import 'package:holdbuddy/app/theme/app_theme.dart';
import 'package:holdbuddy/core/fakes/fake_repository_overrides.dart';
import 'package:holdbuddy/core/l10n/generated/app_localizations.dart';
import 'package:holdbuddy/core/widgets/hb_nav_bar.dart';
import 'package:holdbuddy/core/widgets/hb_tab.dart';

import '../../support/load_inter_font.dart';

void main() {
  setUpAll(loadInterFont);
  _testAllRoutes();
  for (final theme in [AppTheme.light, AppTheme.dark]) {
    _testTabs(theme);
    _testRecovery(theme);
  }
}

void _testAllRoutes() {
  test('Every mobile route resolves to its registered name and path', () {
    final router = AppRouter.create();
    addTearDown(router.dispose);
    for (final route in AppRoute.values) {
      final matches = router.configuration.findMatch(Uri.parse(route.path));
      expect(matches.isError, isFalse, reason: route.name);
      expect(matches.uri.path, route.path);
      final screen = matches.routes.whereType<GoRoute>().last;
      expect(screen.name, route.name);
    }
  });
}

void _testTabs(ThemeData theme) {
  testWidgets('${theme.brightness} tabs retain branch widgets', (tester) async {
    final router = AppRouter.create(initialRoute: AppRoute.today);
    addTearDown(router.dispose);
    await tester.pumpWidget(_app(router, theme));
    await tester.pumpAndSettle();
    final today = tester.element(find.byKey(const ValueKey(AppRoute.today)));
    for (final tab in HbTab.values) {
      final context = tester.element(find.byType(HbNavBar));
      final label = tab.label(AppLocalizations.of(context));
      await tester.tap(find.byTooltip(label));
      await tester.pumpAndSettle();
      expect(
        router.routeInformationProvider.value.uri.path,
        AppRoute.tabs[tab.index].path,
      );
      expect(tester.widget<HbNavBar>(find.byType(HbNavBar)).selected, tab);
    }
    router.go(AppRoute.today.path);
    await tester.pumpAndSettle();
    expect(
      tester.element(find.byKey(const ValueKey(AppRoute.today))),
      same(today),
    );
    expect(tester.takeException(), isNull);
  });
}

void _testRecovery(ThemeData theme) {
  testWidgets('${theme.brightness} a broken link offers a working return', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final router = AppRouter.create();
    addTearDown(router.dispose);
    await tester.pumpWidget(_app(router, theme));
    router.go('/a-broken-link');
    await tester.pumpAndSettle();
    await _expectRecoveryView(tester, theme);
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();
    expect(router.routeInformationProvider.value.uri.path, AppRoute.today.path);
    expect(find.byType(NavigationError), findsNothing);
    expect(find.byType(HbNavBar), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _expectRecoveryView(WidgetTester tester, ThemeData theme) async {
  final context = tester.element(find.byType(NavigationError));
  final l10n = AppLocalizations.of(context);
  expect(find.text(l10n.navigationHeading), findsOneWidget);
  expect(find.text(l10n.navigationError), findsOneWidget);
  expect(Theme.of(context).brightness, theme.brightness);
  expect(tester.takeException(), isNull);
  await expectLater(
    find.byKey(const ValueKey('route_preview')),
    matchesGoldenFile('../../goldens/nav_error_${theme.brightness.name}.png'),
  );
}

Widget _app(GoRouter router, ThemeData theme) => ProviderScope(
  overrides: fakeRepositoryOverrides(),
  child: RepaintBoundary(
    key: const ValueKey('route_preview'),
    child: MaterialApp.router(
      theme: theme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      builder: (context, child) => MediaQuery.withClampedTextScaling(
        minScaleFactor: 1.3,
        maxScaleFactor: 1.3,
        child: child ?? const SizedBox.shrink(),
      ),
    ),
  ),
);
