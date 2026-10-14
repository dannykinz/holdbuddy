import 'package:flutter/widgets.dart';

import '../../features/settings/ui/appearance_screen.dart';
import '../../features/settings/ui/data_remove_confirmation_screen.dart';
import '../../features/settings/ui/legal_privacy_screen.dart';
import '../../features/settings/ui/privacy_local_data_screen.dart';
import '../../features/settings/ui/settings_screen.dart';
import 'app_route.dart';

abstract final class SettingsRoutes {
  static Widget? screen(AppRoute route) => switch (route) {
    AppRoute.settings => const SettingsScreen(),
    AppRoute.appearance => const AppearanceScreen(),
    AppRoute.privacyLocalData => const PrivacyLocalDataScreen(),
    AppRoute.dataRemoveConfirmation => const DataRemoveConfirmationScreen(),
    AppRoute.legalPrivacy => const LegalPrivacyScreen(),
    _ => null,
  };
}
