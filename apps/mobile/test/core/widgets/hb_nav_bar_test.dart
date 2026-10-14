import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holdbuddy/app/theme/app_theme.dart';
import 'package:holdbuddy/app/theme/tokens.dart';
import 'package:holdbuddy/core/l10n/generated/app_localizations.dart';
import 'package:holdbuddy/core/widgets/hb_nav_bar.dart';
import 'package:holdbuddy/core/widgets/hb_tab.dart';

import '../../support/load_inter_font.dart';

void main() {
  setUpAll(loadInterFont);
  _testNavigation(AppTheme.light);
  _testNavigation(AppTheme.dark);
}

void _testNavigation(ThemeData theme) {
  testWidgets('${theme.brightness} tabs select, label and fit at 1.3x', (
    tester,
  ) async {
    final selected = ValueNotifier(HbTab.today);
    addTearDown(selected.dispose);
    await tester.pumpWidget(_preview(theme, selected));
    final semantics = tester.ensureSemantics();
    try {
      for (final tab in HbTab.values) {
        await _selectTab(tester, selected, tab);
      }
    } finally {
      semantics.dispose();
    }
  });
}

Future<void> _selectTab(
  WidgetTester tester,
  ValueNotifier<HbTab> selected,
  HbTab tab,
) async {
  final context = tester.element(find.byType(HbNavBar));
  final label = tab.label(AppLocalizations.of(context));
  await tester.tap(find.bySemanticsLabel(label));
  await tester.pumpAndSettle();
  expect(selected.value, tab);
  expect(find.text(label), findsOneWidget);
  final node = tester.getSemantics(find.bySemanticsLabel(label));
  expect(node.flagsCollection.isSelected, Tristate.isTrue);
  _expectTouchTargets(tester);
  expect(tester.getSize(find.byType(HbNavBar)).height, Tokens.navHeight);
  expect(tester.takeException(), isNull);
}

Widget _preview(ThemeData theme, ValueNotifier<HbTab> selected) => MaterialApp(
  theme: theme,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(
    body: MediaQuery(
      data: const MediaQueryData(textScaler: TextScaler.linear(1.3)),
      child: Center(
        child: SizedBox(
          width: 320 - 2 * Tokens.screenMargin,
          child: Center(
            child: ValueListenableBuilder(
              valueListenable: selected,
              builder: (context, tab, child) => HbNavBar(
                selected: tab,
                onSelected: (value) => selected.value = value,
              ),
            ),
          ),
        ),
      ),
    ),
  ),
);

void _expectTouchTargets(WidgetTester tester) {
  for (final element in find.byType(InkWell).evaluate()) {
    final size = tester.getSize(find.byWidget(element.widget));
    expect(size.width, greaterThanOrEqualTo(Tokens.minTouchTarget));
    expect(size.height, greaterThanOrEqualTo(Tokens.minTouchTarget));
  }
}
