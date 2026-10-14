import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holdbuddy/app/router/app_route.dart';
import 'package:holdbuddy/app/theme/app_theme.dart';
import 'package:holdbuddy/core/fakes/fake_auth_data.dart';
import 'package:holdbuddy/core/fakes/fake_auth_repository.dart';
import 'package:holdbuddy/features/auth/domain/auth_operation.dart';
import 'package:holdbuddy/features/auth/domain/auth_outcome.dart';
import 'package:holdbuddy/features/auth/logic/auth_controller.dart';
import 'package:holdbuddy/features/plan/logic/plan_providers.dart';

import '../../../support/load_inter_font.dart';
import '../../../support/pump_account.dart';

void main() {
  setUpAll(loadInterFont);
  testWidgets(
    'Sign-in failure preserves fields and allows a successful retry',
    (tester) async {
      final app = await pumpAccount(tester, AppTheme.light, AppRoute.signIn);
      await enterAccount(tester, password: 'incorrect password');
      await tapAccount(tester, 'Sign in');
      await tester.pumpAndSettle();
      expect(app.router.state.uri.path, AppRoute.signIn.path);
      expect(find.text('We couldn’t sign you in'), findsOneWidget);
      expect(
        tester
            .widget<TextFormField>(find.byType(TextFormField).first)
            .controller
            ?.text,
        FakeAuthData.email,
      );
      await enterAccount(tester);
      await tapAccount(tester, 'Try signing in again');
      await tester.pumpAndSettle();
      expect(app.router.state.uri.path, AppRoute.today.path);
    },
  );

  testWidgets('Leaving a pending sign-in ignores its late result', (
    tester,
  ) async {
    final app = await pumpAccount(
      tester,
      AppTheme.dark,
      AppRoute.signIn,
      repository: FakeAuthRepository(),
    );
    await enterAccount(tester);
    await tapAccount(tester, 'Sign in');
    expect(app.router.state.uri.path, AppRoute.accountLoading.path);
    await tester.tap(find.byTooltip('Back'));
    await tester.pump();
    await tester.pump(FakeAuthData.delay);
    await tester.pumpAndSettle();
    expect(app.router.state.uri.path, AppRoute.signIn.path);
    expect(find.text(FakeAuthData.email), findsOneWidget);
  });

  testWidgets(
    'Google handoff requires age and routes cancellation to recovery',
    (tester) async {
      final app = await pumpAccount(
        tester,
        AppTheme.light,
        AppRoute.googleHandoff,
        repository: FakeAuthRepository(
          delay: Duration.zero,
          outcomes: const {AuthOperation.google: AuthOutcome.cancelled},
        ),
      );
      expect(
        tester
            .widget<FilledButton>(
              find.widgetWithText(FilledButton, 'Open Google'),
            )
            .onPressed,
        isNull,
      );
      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      await tapAccount(tester, 'Open Google');
      await tester.pumpAndSettle();
      expect(app.router.state.uri.path, AppRoute.googleCancelled.path);
      await tapAccount(tester, 'Try Google again');
      await tester.pumpAndSettle();
      expect(app.router.state.uri.path, AppRoute.googleHandoff.path);
      await tapAccount(tester, 'Use email instead');
      await tester.pumpAndSettle();
      expect(app.router.state.uri.path, AppRoute.signUp.path);
    },
  );

  testWidgets('Google preview connects to Today', (tester) async {
    final app = await pumpAccount(
      tester,
      AppTheme.dark,
      AppRoute.googleHandoff,
      isAdult: true,
    );
    await tapAccount(tester, 'Open Google');
    await tester.pumpAndSettle();
    expect(app.router.state.uri.path, AppRoute.today.path);
  });

  testWidgets(
    'Offline entry requires age confirmation and opens the saved plan',
    (tester) async {
      final app = await pumpAccount(
        tester,
        AppTheme.dark,
        AppRoute.accountOffline,
      );
      expect(
        tester
            .widget<FilledButton>(
              find.widgetWithText(FilledButton, 'Continue offline'),
            )
            .onPressed,
        isNull,
      );
      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      await tapAccount(tester, 'Continue offline');
      await tester.pumpAndSettle();
      expect(app.router.state.uri.path, AppRoute.today.path);
    },
  );

  testWidgets('Offline sign-in offers the offline recovery screen', (
    tester,
  ) async {
    final app = await pumpAccount(
      tester,
      AppTheme.light,
      AppRoute.signIn,
      repository: FakeAuthRepository(
        delay: Duration.zero,
        outcomes: const {AuthOperation.signIn: AuthOutcome.offline},
      ),
    );
    await enterAccount(tester);
    await tapAccount(tester, 'Sign in');
    await tester.pumpAndSettle();
    expect(app.router.state.uri.path, AppRoute.accountOffline.path);
  });

  testWidgets('Unavailable sign-in retains a usable retry and offline option', (
    tester,
  ) async {
    await pumpAccount(
      tester,
      AppTheme.light,
      AppRoute.signIn,
      repository: FakeAuthRepository(
        delay: Duration.zero,
        outcomes: const {AuthOperation.signIn: AuthOutcome.unavailable},
      ),
    );
    await enterAccount(tester);
    await tapAccount(tester, 'Sign in');
    await tester.pumpAndSettle();
    expect(find.text('Account access is unavailable'), findsOneWidget);
    expect(find.text('Continue offline'), findsOneWidget);
    expect(find.text(FakeAuthData.email), findsOneWidget);
  });

  testWidgets('Signing out preserves the seeded local study repositories', (
    tester,
  ) async {
    final app = await pumpAccount(
      tester,
      AppTheme.light,
      AppRoute.signOutConfirm,
      isAdult: true,
    );
    final plans = await app.container.read(plansProvider.future);
    await tapAccount(tester, 'Sign out');
    await tester.pumpAndSettle();
    expect(app.router.state.uri.path, AppRoute.getStarted.path);
    expect(await app.container.read(plansProvider.future), same(plans));
    expect(app.container.read(AuthController.provider).email, isEmpty);
    expect(app.container.read(AuthController.provider).isAdult, isFalse);
  });
}
