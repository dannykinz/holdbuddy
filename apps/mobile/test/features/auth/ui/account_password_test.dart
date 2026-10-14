import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holdbuddy/app/router/app_route.dart';
import 'package:holdbuddy/app/theme/app_theme.dart';
import 'package:holdbuddy/core/fakes/fake_auth_data.dart';

import '../../../support/pump_account.dart';

void main() {
  testWidgets('Forgot password validates email before showing the sent state', (
    tester,
  ) async {
    final app = await pumpAccount(
      tester,
      AppTheme.light,
      AppRoute.forgotPassword,
    );
    await tester.enterText(
      find.byType(TextFormField),
      FakeAuthData.invalidEmail,
    );
    await tapAccount(tester, 'Send reset link');
    expect(find.text('Enter a complete email address.'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField), ' DANNY@EXAMPLE.COM ');
    await tapAccount(tester, 'Send reset link');
    await tester.pumpAndSettle();
    expect(app.router.state.uri.path, AppRoute.passwordEmailSent.path);
    expect(find.textContaining(FakeAuthData.email), findsOneWidget);
    await tapAccount(tester, 'Back to sign in');
    await tester.pumpAndSettle();
    expect(app.router.state.uri.path, AppRoute.signIn.path);
  });

  testWidgets('Reset password checks confirmation and opens the saved state', (
    tester,
  ) async {
    final app = await pumpAccount(
      tester,
      AppTheme.dark,
      AppRoute.resetPassword,
    );
    await tester.enterText(
      find.byType(TextFormField).first,
      FakeAuthData.password,
    );
    await tester.enterText(find.byType(TextFormField).last, 'not matching');
    await tapAccount(tester, 'Save new password');
    expect(find.text('Both passwords need to match.'), findsOneWidget);
    await tester.enterText(
      find.byType(TextFormField).last,
      FakeAuthData.password,
    );
    await tapAccount(tester, 'Save new password');
    await tester.pumpAndSettle();
    expect(app.router.state.uri.path, AppRoute.passwordSaved.path);
    await tapAccount(tester, 'Sign in');
    await tester.pumpAndSettle();
    expect(app.router.state.uri.path, AppRoute.signIn.path);
  });

  testWidgets('Resending a reset link stays on the sent state', (tester) async {
    final app = await pumpAccount(
      tester,
      AppTheme.light,
      AppRoute.passwordEmailSent,
    );
    await tapAccount(tester, 'Resend reset link');
    await tester.pumpAndSettle();
    expect(app.router.state.uri.path, AppRoute.passwordEmailSent.path);
    expect(find.text('Reset link requested in this preview.'), findsOneWidget);
  });

  testWidgets('Direct-link Back has a usable sign-in fallback', (tester) async {
    final app = await pumpAccount(
      tester,
      AppTheme.light,
      AppRoute.resetPassword,
    );
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(app.router.state.uri.path, AppRoute.signIn.path);
  });
}
