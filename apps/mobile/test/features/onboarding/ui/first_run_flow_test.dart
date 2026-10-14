import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holdbuddy/app/router/app_route.dart';
import 'package:holdbuddy/app/theme/app_theme.dart';
import 'package:holdbuddy/app/theme/tokens.dart';
import 'package:holdbuddy/core/l10n/generated/app_localizations.dart';
import 'package:holdbuddy/core/widgets/hb_button.dart';
import 'package:holdbuddy/features/onboarding/ui/onboarding_screen.dart';

import '../../../support/load_inter_font.dart';
import '../../../support/pump_first_run.dart';

void main() {
  setUpAll(loadInterFont);
  _splash();
  _disposedSplash();
  _slides();
  for (final route in OnboardingScreen.routes) _skip(route);
  for (final route in [
    AppRoute.googleHandoff,
    AppRoute.signUp,
    AppRoute.signIn,
    AppRoute.accountOffline,
  ])
    _entry(route);
  _reducedMotion();
  _directBack();
}

void _splash() {
  testWidgets('Splash waits 1.2 seconds, then dissolves into onboarding', (
    tester,
  ) async {
    final router = await pumpFirstRun(tester, AppTheme.light, AppRoute.splash);
    await tester.pump(const Duration(milliseconds: 1199));
    expect(router.state.uri.path, AppRoute.splash.path);
    await tester.pump(const Duration(milliseconds: 1));
    await tester.pumpAndSettle();
    expect(router.state.uri.path, AppRoute.onboardingContract.path);
    expect(find.byType(OnboardingScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

void _disposedSplash() {
  testWidgets(
    'Leaving Splash cancels its timer and cannot override another route',
    (tester) async {
      final router = await pumpFirstRun(
        tester,
        AppTheme.light,
        AppRoute.splash,
      );
      router.goNamed(AppRoute.getStarted.name);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 2));
      expect(router.state.uri.path, AppRoute.getStarted.path);
      expect(tester.takeException(), isNull);
    },
  );
}

void _slides() {
  testWidgets(
    'Continue visits each slide and Get started returns to the last slide',
    (tester) async {
      final router = await pumpFirstRun(
        tester,
        AppTheme.light,
        AppRoute.onboardingContract,
      );
      for (final destination in [
        AppRoute.onboardingWitness,
        AppRoute.onboardingReturn,
        AppRoute.getStarted,
      ]) {
        await tester.tap(find.byType(HbButton));
        await tester.pumpAndSettle();
        expect(router.state.uri.path, destination.path);
        expect(tester.takeException(), isNull);
      }
      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();
      expect(
        tester.widget<OnboardingScreen>(find.byType(OnboardingScreen)).step,
        2,
      );
    },
  );
}

void _skip(AppRoute route) {
  testWidgets(
    'Skip on ${route.name} opens Get started and preserves the return',
    (tester) async {
      final router = await pumpFirstRun(tester, AppTheme.light, route);
      await tester.tap(find.text('Skip'));
      await tester.pumpAndSettle();
      expect(router.state.uri.path, AppRoute.getStarted.path);
      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();
      expect(router.state.uri.path, route.path);
    },
  );
}

void _entry(AppRoute destination) {
  testWidgets(
    'Get started opens ${destination.name} without claiming authentication',
    (tester) async {
      final router = await pumpFirstRun(
        tester,
        AppTheme.light,
        AppRoute.getStarted,
      );
      final l10n = AppLocalizations.of(tester.element(find.byType(Scaffold)));
      final label = switch (destination) {
        AppRoute.googleHandoff => l10n.continueGoogle,
        AppRoute.signUp => l10n.continueEmail,
        AppRoute.signIn => l10n.existingAccount + l10n.signIn,
        _ => l10n.continueOffline,
      };
      await tester.ensureVisible(find.text(label));
      await tester.tap(find.text(label));
      await tester.pumpAndSettle();
      expect(router.state.uri.path, destination.path);
      expect(find.byKey(ValueKey(destination)), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}

void _reducedMotion() {
  testWidgets(
    'Reduced motion removes the dissolve and both splash themes set visible system icons',
    (tester) async {
      for (final theme in [AppTheme.light, AppTheme.dark]) {
        await pumpFirstRun(tester, theme, AppRoute.splash, reducedMotion: true);
        final overlay = tester.widget<AnnotatedRegion<SystemUiOverlayStyle>>(
          find.byType(AnnotatedRegion<SystemUiOverlayStyle>).last,
        );
        expect(overlay.value.statusBarIconBrightness, Brightness.dark);
        await tester.pump(OnboardingTokens.splashDelay);
        await tester.pump();
        expect(find.byType(OnboardingScreen), findsOneWidget);
        expect(tester.binding.transientCallbackCount, 0);
      }
    },
  );
}

void _directBack() {
  testWidgets('A direct Get started link has a working Back action', (
    tester,
  ) async {
    final router = await pumpFirstRun(
      tester,
      AppTheme.light,
      AppRoute.getStarted,
    );
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(router.state.uri.path, AppRoute.onboardingReturn.path);
  });
}
