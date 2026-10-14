import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holdbuddy/app/router/app_route.dart';
import 'package:holdbuddy/app/theme/app_theme.dart';
import 'package:holdbuddy/core/fakes/fake_auth_data.dart';
import 'package:holdbuddy/core/fakes/fake_auth_repository.dart';
import 'package:holdbuddy/features/auth/domain/auth_operation.dart';
import 'package:holdbuddy/features/auth/domain/auth_outcome.dart';

import '../../../support/load_inter_font.dart';
import '../../../support/pump_account.dart';

const _previews = {
  'sign_up': AppRoute.signUp,
  'sign_in': AppRoute.signIn,
  'verify': AppRoute.verifyEmail,
  'forgot': AppRoute.forgotPassword,
  'reset': AppRoute.resetPassword,
  'validation': AppRoute.signUp,
  'sign_in_error': AppRoute.signIn,
  'loading': AppRoute.accountLoading,
  'google': AppRoute.googleHandoff,
  'google_cancelled': AppRoute.googleCancelled,
  'expired': AppRoute.verifyEmail,
  'email_sent': AppRoute.passwordEmailSent,
  'password_saved': AppRoute.passwordSaved,
  'offline': AppRoute.accountOffline,
  'sign_out': AppRoute.signOutConfirm,
};

void main() {
  setUpAll(loadInterFont);
  for (final theme in [AppTheme.light, AppTheme.dark]) {
    for (final entry in _previews.entries) {
      _golden(theme, entry.key, entry.value);
      _scaled(theme, entry.key, entry.value);
    }
  }
}

void _golden(ThemeData theme, String name, AppRoute route) {
  testWidgets('$name ${theme.brightness.name} matches account design', (
    tester,
  ) async {
    final previous = debugDisableShadows;
    debugDisableShadows = false;
    try {
      await _prepare(tester, theme, name, route);
      expect(tester.takeException(), isNull);
      await expectLater(
        find.byKey(const ValueKey('account_preview')),
        matchesGoldenFile(
          '../../../goldens/account_${name}_${theme.brightness.name}.png',
        ),
      );
      if (route == AppRoute.accountLoading)
        await tester.pump(FakeAuthData.delay);
    } finally {
      debugDisableShadows = previous;
    }
  });
}

void _scaled(ThemeData theme, String name, AppRoute route) {
  testWidgets('$name ${theme.brightness.name} fits 320px at 1.3x', (
    tester,
  ) async {
    await _prepare(tester, theme, name, route, scaled: true);
    await tester.drag(
      find.byType(SingleChildScrollView),
      const Offset(0, -1000),
    );
    await tester.pump(const Duration(milliseconds: 300));
    expect(tester.takeException(), isNull);
    for (final button in find.bySubtype<ButtonStyleButton>().evaluate()) {
      final size = tester.getSize(find.byWidget(button.widget));
      expect(size.height, greaterThanOrEqualTo(48));
      expect(size.width, greaterThanOrEqualTo(48));
    }
    for (final button in find.byType(IconButton).evaluate()) {
      final size = tester.getSize(find.byWidget(button.widget));
      expect(size.height, greaterThanOrEqualTo(48));
      expect(size.width, greaterThanOrEqualTo(48));
    }
    if (route == AppRoute.accountLoading) await tester.pump(FakeAuthData.delay);
  });
}

Future<void> _prepare(
  WidgetTester tester,
  ThemeData theme,
  String name,
  AppRoute route, {
  bool scaled = false,
}) async {
  await pumpAccount(
    tester,
    theme,
    route,
    repository: FakeAuthRepository(
      delay: name == 'loading' ? FakeAuthData.delay : Duration.zero,
      outcomes: const {
        AuthOperation.verify: AuthOutcome.expired,
        AuthOperation.signIn: AuthOutcome.invalidCredentials,
      },
    ),
    isAdult: true,
    width: scaled ? 320 : 390,
    height: scaled ? 640 : 844,
    textScale: scaled ? 1.3 : 1,
  );
  await _fill(tester, name, route);
  final passwordFocused = {'sign_up', 'sign_in', 'reset'}.contains(name);
  if (route != AppRoute.verifyEmail && !passwordFocused)
    FocusManager.instance.primaryFocus?.unfocus();
  await tester.pump();
  await tester.pump(Duration(milliseconds: passwordFocused ? 600 : 300));
}

Future<void> _fill(WidgetTester tester, String name, AppRoute route) async {
  if (route == AppRoute.signUp || route == AppRoute.signIn)
    await _account(tester, name, route);
  if (route == AppRoute.verifyEmail) await _code(tester, name);
  if (route == AppRoute.forgotPassword)
    await tester.enterText(find.byType(TextFormField), FakeAuthData.email);
  if (route == AppRoute.resetPassword) {
    for (final field in find.byType(TextFormField).evaluate())
      await tester.enterText(
        find.byWidget(field.widget),
        FakeAuthData.password,
      );
  }
  if (route == AppRoute.googleHandoff) await _portrait(tester);
}

Future<void> _account(WidgetTester tester, String name, AppRoute route) async {
  await enterAccount(
    tester,
    signUp: route == AppRoute.signUp,
    email: name == 'validation'
        ? FakeAuthData.invalidEmail
        : FakeAuthData.email,
    password: name == 'validation'
        ? FakeAuthData.shortPassword
        : FakeAuthData.password,
  );
  if (name == 'validation') await tapAccount(tester, 'Create account');
  if (name == 'sign_in_error') {
    await tapAccount(tester, 'Sign in');
    await tester.pumpAndSettle();
  }
}

Future<void> _code(WidgetTester tester, String name) async {
  await tester.enterText(
    find.byType(TextField),
    name == 'expired' ? FakeAuthData.code : '48216',
  );
  if (name != 'expired') return;
  await tapAccount(tester, 'Verify email');
  await tester.pumpAndSettle();
}

Future<void> _portrait(WidgetTester tester) async {
  final context = tester.element(find.byType(Scaffold));
  await tester.runAsync(() async {
    for (final mode in ['', 'dark_'])
      await precacheImage(
        AssetImage('assets/avatars/auth_${mode}you.png'),
        context,
      );
  });
}
