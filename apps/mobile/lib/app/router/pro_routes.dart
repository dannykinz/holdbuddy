import 'package:flutter/material.dart';

import '../../features/pro/ui/pro_paywall_screen.dart';
import '../../features/pro/ui/pro_welcome_screen.dart';
import 'app_route.dart';

abstract final class ProRoutes {
  static Widget? screen(AppRoute route) => switch (route) {
    AppRoute.proPaywall => const ProPaywallScreen(),
    AppRoute.proWelcome => const ProWelcomeScreen(),
    _ => null,
  };
}
