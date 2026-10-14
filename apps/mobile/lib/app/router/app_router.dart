import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/logging/logger.dart';
import '../../features/onboarding/ui/get_started_screen.dart';
import '../../features/onboarding/ui/onboarding_screen.dart';
import '../../features/onboarding/ui/splash_screen.dart';
import '../theme/tokens.dart';
import 'app_route.dart';
import 'app_shell.dart';
import 'around_routes.dart';
import 'auth_routes.dart';
import 'contract_routes.dart';
import 'daily_routes.dart';
import 'deadline_routes.dart';
import 'material_routes.dart';
import 'navigation_error.dart';
import 'people_routes.dart';
import 'plan_change_routes.dart';
import 'pro_routes.dart';
import 'settings_routes.dart';
import 'sheet_routes.dart';

abstract final class AppRouter {
  static final provider = Provider<GoRouter>((ref) {
    final router = create();
    ref.onDispose(router.dispose);
    return router;
  });

  static GoRouter create({AppRoute initialRoute = AppRoute.splash}) => GoRouter(
    initialLocation: initialRoute.path,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => AppShell(navigationShell: shell),
        branches: [
          for (final tab in AppRoute.tabs)
            StatefulShellBranch(routes: [_route(tab)]),
        ],
      ),
      for (final route in AppRoute.values)
        if (!AppRoute.tabs.contains(route)) _route(route),
    ],
    errorBuilder: (context, state) {
      final error = state.error;
      if (error != null) logError(error, StackTrace.current);
      return const NavigationError();
    },
  );

  static GoRoute _route(AppRoute route) {
    if (SheetRoutes.routes.contains(route))
      return GoRoute(
        path: route.path,
        name: route.name,
        pageBuilder: (context, state) =>
            SheetRoutes.page(context, route, state.pageKey),
      );
    if (route == AppRoute.splash ||
        route == AppRoute.getStarted ||
        OnboardingScreen.routes.contains(route) ||
        AuthRoutes.screen(route) != null ||
        ContractRoutes.screen(route) != null ||
        DailyRoutes.screen(route) != null ||
        AroundRoutes.screen(route) != null ||
        SettingsRoutes.screen(route) != null ||
        PlanChangeRoutes.screen(route) != null ||
        PeopleRoutes.screen(route) != null ||
        DeadlineRoutes.screen(route) != null ||
        MaterialRoutes.screen(route) != null ||
        ProRoutes.screen(route) != null)
      return _screen(route);
    return _stub(route);
  }

  static GoRoute _stub(AppRoute route) => GoRoute(
    path: route.path,
    name: route.name,
    builder: (context, state) => Scaffold(key: ValueKey(route)),
  );

  static GoRoute _screen(AppRoute route) => GoRoute(
    path: route.path,
    name: route.name,
    pageBuilder: (context, state) {
      final duration = _duration(context, route);
      return CustomTransitionPage<void>(
        key: state.pageKey,
        name: route.name,
        transitionDuration: duration,
        reverseTransitionDuration: duration,
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(
              opacity: animation.drive(CurveTween(curve: Curves.easeOut)),
              child: child,
            ),
        child: _child(route, state),
      );
    },
  );

  static Duration _duration(BuildContext context, AppRoute route) {
    if (MediaQuery.disableAnimationsOf(context)) return Duration.zero;
    return route == AppRoute.onboardingContract
        ? OnboardingTokens.dissolveDuration
        : WidgetTokens.motionDuration;
  }

  static Widget _child(AppRoute route, GoRouterState state) =>
      AuthRoutes.screen(route, hasRequest: state.extra == true) ??
      ContractRoutes.screen(route) ??
      DailyRoutes.screen(
        route,
        chapter: state.extra is int ? state.extra as int : null,
        materialId: state.extra is String ? state.extra as String : null,
      ) ??
      AroundRoutes.screen(
        route,
        noteId: state.extra is String ? state.extra as String : null,
        noteChapter: state.extra is int ? state.extra as int : null,
      ) ??
      SettingsRoutes.screen(route) ??
      PlanChangeRoutes.screen(route) ??
      PeopleRoutes.screen(route) ??
      DeadlineRoutes.screen(route, extra: state.extra) ??
      MaterialRoutes.screen(
        route,
        materialId: state.extra is String ? state.extra as String : null,
      ) ??
      ProRoutes.screen(route) ??
      _firstRunScreen(route);

  static Widget _firstRunScreen(AppRoute route) {
    if (route == AppRoute.splash) return const SplashScreen();
    if (route == AppRoute.getStarted) return const GetStartedScreen();
    return OnboardingScreen(step: OnboardingScreen.routes.indexOf(route));
  }
}
