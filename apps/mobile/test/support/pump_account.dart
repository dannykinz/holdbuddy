import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:holdbuddy/app/router/app_route.dart';
import 'package:holdbuddy/app/router/app_router.dart';
import 'package:holdbuddy/core/fakes/fake_auth_data.dart';
import 'package:holdbuddy/core/fakes/fake_auth_repository.dart';
import 'package:holdbuddy/core/fakes/fake_repository_overrides.dart';
import 'package:holdbuddy/core/l10n/generated/app_localizations.dart';
import 'package:holdbuddy/features/auth/logic/auth_controller.dart';
import 'package:holdbuddy/features/auth/logic/auth_state.dart';

Future<({GoRouter router, ProviderContainer container})> pumpAccount(
  WidgetTester tester,
  ThemeData theme,
  AppRoute route, {
  FakeAuthRepository? repository,
  double width = 390,
  double height = 844,
  double textScale = 1,
  bool isAdult = false,
}) async {
  tester.view.physicalSize = Size(width, height);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  final container = _container(repository, route, isAdult);
  final router = AppRouter.create(initialRoute: route);
  addTearDown(() async {
    await tester.pumpWidget(const SizedBox.shrink());
    container.dispose();
    router.dispose();
    await tester.pump(FakeAuthData.delay);
  });
  await tester.pumpWidget(_app(theme, router, container, textScale));
  await tester.pump();
  return (router: router, container: container);
}

ProviderContainer _container(
  FakeAuthRepository? repository,
  AppRoute route,
  bool adult,
) => ProviderContainer(
  overrides: [
    ...fakeRepositoryOverrides(
      auth:
          repository ??
          FakeAuthRepository(
            delay: route == AppRoute.accountLoading
                ? FakeAuthData.delay
                : Duration.zero,
          ),
    ),
    AuthController.provider.overrideWith(
      () => AuthController(
        initialState: AuthState(email: FakeAuthData.email, isAdult: adult),
      ),
    ),
  ],
);

Widget _app(
  ThemeData theme,
  GoRouter router,
  ProviderContainer container,
  double scale,
) => UncontrolledProviderScope(
  container: container,
  child: MaterialApp.router(
    theme: theme,
    routerConfig: router,
    debugShowCheckedModeBanner: false,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(
        padding: const EdgeInsets.only(top: 40, bottom: 18),
        textScaler: TextScaler.linear(scale),
      ),
      child: RepaintBoundary(
        key: const ValueKey('account_preview'),
        child: child ?? const SizedBox.shrink(),
      ),
    ),
  ),
);

Future<void> enterAccount(
  WidgetTester tester, {
  bool signUp = false,
  String email = FakeAuthData.email,
  String password = FakeAuthData.password,
}) async {
  final fields = find.byType(TextFormField);
  if (signUp) await tester.enterText(fields.at(0), FakeAuthData.name);
  await tester.enterText(fields.at(signUp ? 1 : 0), email);
  await tester.enterText(fields.at(signUp ? 2 : 1), password);
  await tester.pump();
}

Future<void> tapAccount(WidgetTester tester, String text) async {
  final button = find.ancestor(
    of: find.text(text),
    matching: find.bySubtype<ButtonStyleButton>(),
  );
  await tester.ensureVisible(button);
  await tester.tap(button);
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
}
