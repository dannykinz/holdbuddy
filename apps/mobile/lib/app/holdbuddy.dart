import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/l10n/generated/app_localizations.dart';
import '../features/settings/domain/appearance_mode.dart';
import '../features/settings/logic/settings_controller.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

class Holdbuddy extends ConsumerWidget {
  const Holdbuddy({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => MaterialApp.router(
    onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    debugShowCheckedModeBanner: false,
    themeMode: switch (ref.watch(SettingsController.provider).appearance) {
      AppearanceMode.light => ThemeMode.light,
      AppearanceMode.dark => ThemeMode.dark,
      AppearanceMode.system => ThemeMode.system,
    },
    theme: AppTheme.light,
    darkTheme: AppTheme.dark,
    builder: _systemOverlay,
    routerConfig: ref.watch(AppRouter.provider),
  );

  Widget _systemOverlay(BuildContext context, Widget? child) {
    final theme = Theme.of(context);
    final iconBrightness = theme.brightness == Brightness.light
        ? Brightness.dark
        : Brightness.light;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: theme.scaffoldBackgroundColor,
        statusBarBrightness: theme.brightness,
        statusBarIconBrightness: iconBrightness,
        systemNavigationBarColor: theme.scaffoldBackgroundColor,
        systemNavigationBarIconBrightness: iconBrightness,
      ),
      child: child ?? const SizedBox.shrink(),
    );
  }
}
