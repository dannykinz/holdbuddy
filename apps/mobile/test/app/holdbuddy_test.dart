import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holdbuddy/app/holdbuddy.dart';
import 'package:holdbuddy/core/fakes/fake_repository_overrides.dart';
import 'package:holdbuddy/core/l10n/generated/app_localizations.dart';
import 'package:holdbuddy/features/onboarding/ui/splash_screen.dart';

void main() {
  testWidgets('Boots the localized Splash with the light Inter theme', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: fakeRepositoryOverrides(),
        child: const Holdbuddy(),
      ),
    );
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(Scaffold));
    final theme = Theme.of(context);
    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));

    expect(AppLocalizations.of(context).appTitle, 'Holdbuddy');
    expect(theme.brightness, Brightness.light);
    expect(theme.textTheme.bodyMedium?.fontFamily, 'Inter');
    expect(app.supportedLocales, contains(const Locale('en')));
    expect(find.byType(SplashScreen), findsOneWidget);
    _expectSystemContrast(tester);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}

void _expectSystemContrast(WidgetTester tester) {
  final overlay = tester
      .widget<AnnotatedRegion<SystemUiOverlayStyle>>(
        find.byType(AnnotatedRegion<SystemUiOverlayStyle>).first,
      )
      .value;
  expect(overlay.statusBarIconBrightness, Brightness.dark);
  expect(overlay.systemNavigationBarIconBrightness, Brightness.dark);
}
