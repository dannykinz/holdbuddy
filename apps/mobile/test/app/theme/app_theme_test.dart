import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holdbuddy/app/theme/app_color.dart';
import 'package:holdbuddy/app/theme/app_colors.dart';
import 'package:holdbuddy/app/theme/app_theme.dart';
import 'package:holdbuddy/app/theme/tokens.dart';
import 'package:holdbuddy/core/l10n/generated/app_localizations.dart';

void main() {
  _testTheme(Brightness.light, AppTheme.light, Tokens.light);
  _testTheme(Brightness.dark, AppTheme.dark, Tokens.dark);
  _testThemeTransitions();
  _testColorStorage();
}

void _testTheme(Brightness brightness, ThemeData theme, AppColors colors) {
  testWidgets('$brightness builds with Inter at 1.3x text scale', (
    tester,
  ) async {
    await tester.pumpWidget(_themePreview(theme));
    await tester.pumpAndSettle();
    final context = tester.element(find.byType(Scaffold));
    final rendered = Theme.of(context);
    expect(rendered.brightness, brightness);
    expect(AppColors.of(context), same(colors));
    expect(rendered.scaffoldBackgroundColor, colors.bg);
    expect(rendered.colorScheme.primary, colors.primary);
    expect(rendered.colorScheme.onPrimary, colors.onPrimary);
    expect(rendered.colorScheme.surface, colors.surface);
    expect(rendered.colorScheme.outline, colors.line);
    expect(rendered.textTheme.bodyLarge?.fontFamily, Tokens.fontFamily);
    expect(rendered.textTheme.titleLarge?.fontSize, 22);
    expect(rendered.textTheme.headlineLarge?.letterSpacing, -0.8);
    expect(find.text('Holdbuddy'), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });
}

Widget _themePreview(ThemeData theme) => MaterialApp(
  theme: theme,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: Builder(
    builder: (context) => MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.3)),
      child: Scaffold(body: _previewContent(context)),
    ),
  ),
);

Widget _previewContent(BuildContext context) => Column(
  children: [
    Text(
      AppLocalizations.of(context).appTitle,
      style: Theme.of(context).textTheme.headlineLarge,
    ),
    FilledButton(
      onPressed: () {},
      child: Text(AppLocalizations.of(context).appTitle),
    ),
  ],
);

void _testThemeTransitions() {
  test('Theme transitions interpolate every semantic and category colour', () {
    final middle = ThemeData.lerp(AppTheme.light, AppTheme.dark, 0.5);
    final colors = middle.extension<AppColors>();
    if (colors == null) fail('Theme transitions must retain AppColors.');
    for (final token in AppColor.values) {
      expect(
        colors[token],
        Color.lerp(Tokens.light[token], Tokens.dark[token], 0.5),
        reason: token.name,
      );
    }
    expect(Tokens.light.lerp(Tokens.dark, 0).glass, Tokens.light.glass);
    expect(Tokens.light.lerp(Tokens.dark, 1).glass, Tokens.dark.glass);
    expect(Tokens.light.lerp(null, 0.5), same(Tokens.light));
  });
}

void _testColorStorage() {
  test('Colour input and partial copies cannot mutate the original set', () {
    final input = {
      for (final token in AppColor.values) token: Tokens.light[token],
    };
    final colors = AppColors(input);
    input[AppColor.bg] = Tokens.dark.bg;
    final copy = colors.copyWith(colors: {AppColor.bg: Tokens.dark.bg});
    expect(colors.bg, Tokens.light.bg);
    expect(copy.bg, Tokens.dark.bg);
    expect(copy.purpleSoft, colors.purpleSoft);
    expect(() => AppColors({}), throwsArgumentError);
  });
}
