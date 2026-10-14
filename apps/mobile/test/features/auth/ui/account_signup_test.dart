import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holdbuddy/app/router/app_route.dart';
import 'package:holdbuddy/app/theme/app_theme.dart';
import 'package:holdbuddy/core/fakes/fake_auth_data.dart';
import 'package:holdbuddy/core/fakes/fake_auth_repository.dart';
import 'package:holdbuddy/features/auth/domain/auth_operation.dart';
import 'package:holdbuddy/features/auth/domain/auth_outcome.dart';

import '../../../support/pump_account.dart';

void main() {
  testWidgets('Sign up requires age confirmation and shows field validation', (
    tester,
  ) async {
    await pumpAccount(tester, AppTheme.light, AppRoute.signUp);
    await enterAccount(
      tester,
      signUp: true,
      email: FakeAuthData.invalidEmail,
      password: FakeAuthData.shortPassword,
    );
    expect(
      tester
          .widget<FilledButton>(
            find.widgetWithText(FilledButton, 'Create account'),
          )
          .onPressed,
      isNull,
    );
    await tester.tap(find.byType(Checkbox));
    await tester.pump();
    await tapAccount(tester, 'Create account');
    expect(find.text('Enter a complete email address.'), findsOneWidget);
    expect(find.text('Use at least 12 characters.'), findsOneWidget);
    expect(find.text('A couple of\nthings to fix.'), findsOneWidget);
    expect(find.text(FakeAuthData.name), findsOneWidget);
    await enterAccount(tester, signUp: true);
    expect(
      tester
          .widget<FilledButton>(
            find.widgetWithText(FilledButton, 'Create account'),
          )
          .onPressed,
      isNotNull,
    );
  });

  testWidgets('Create, verify and Scope form the new-account path', (
    tester,
  ) async {
    final app = await pumpAccount(
      tester,
      AppTheme.dark,
      AppRoute.signUp,
      isAdult: true,
    );
    await enterAccount(tester, signUp: true);
    await tapAccount(tester, 'Create account');
    await tester.pumpAndSettle();
    expect(app.router.state.uri.path, AppRoute.verifyEmail.path);
    expect(find.textContaining(FakeAuthData.email), findsOneWidget);
    await tester.enterText(find.byType(TextField), FakeAuthData.code);
    await tapAccount(tester, 'Verify email');
    await tester.pumpAndSettle();
    expect(app.router.state.uri.path, AppRoute.scope.path);
  });

  testWidgets('Incomplete code stays on verification and shows a next step', (
    tester,
  ) async {
    final app = await pumpAccount(tester, AppTheme.light, AppRoute.verifyEmail);
    await tester.enterText(find.byType(TextField), '48x21');
    await tapAccount(tester, 'Verify email');
    expect(app.router.state.uri.path, AppRoute.verifyEmail.path);
    expect(find.text('Enter all 6 digits to continue.'), findsOneWidget);
  });

  testWidgets('Expired code is a recoverable state within verification', (
    tester,
  ) async {
    final app = await pumpAccount(
      tester,
      AppTheme.light,
      AppRoute.verifyEmail,
      repository: FakeAuthRepository(
        delay: Duration.zero,
        outcomes: const {AuthOperation.verify: AuthOutcome.expired},
      ),
    );
    await tester.enterText(find.byType(TextField), FakeAuthData.code);
    await tapAccount(tester, 'Verify email');
    await tester.pumpAndSettle();
    expect(app.router.state.uri.path, AppRoute.verifyEmail.path);
    expect(find.text('That code\nhas expired.'), findsOneWidget);
    await tapAccount(tester, 'Send a new code');
    await tester.pumpAndSettle();
    expect(find.text('Check your email.'), findsOneWidget);
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller?.text,
      isEmpty,
    );
  });

  testWidgets('Password visibility changes without losing the password', (
    tester,
  ) async {
    await pumpAccount(tester, AppTheme.dark, AppRoute.signUp);
    await enterAccount(tester, signUp: true);
    await tester.tap(find.byTooltip('Show password'));
    await tester.pump();
    expect(
      tester
          .widget<TextFormField>(find.byType(TextFormField).last)
          .controller
          ?.text,
      FakeAuthData.password,
    );
    expect(find.byTooltip('Hide password'), findsOneWidget);
  });

  testWidgets('Terms opens its mapped legal route', (tester) async {
    final app = await pumpAccount(tester, AppTheme.light, AppRoute.signUp);
    await tapAccount(
      tester,
      'By continuing you agree to the Terms and Privacy Notice.',
    );
    expect(app.router.state.uri.path, AppRoute.legalPrivacy.path);
  });
}
