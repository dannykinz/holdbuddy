import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holdbuddy/app/theme/app_theme.dart';
import 'package:holdbuddy/core/l10n/generated/app_localizations.dart';
import 'package:holdbuddy/core/widgets/async_view.dart';
import 'package:holdbuddy/core/widgets/hb_category.dart';
import 'package:holdbuddy/core/widgets/hb_empty_state.dart';

import '../../support/load_inter_font.dart';
import '../../support/pump_shared_widget.dart';

void main() {
  setUpAll(loadInterFont);
  for (final theme in [AppTheme.light, AppTheme.dark]) {
    _loadingTest(theme);
    _dataTest(theme);
    _emptyTest(theme);
    _errorTest(theme);
  }
}

void _loadingTest(ThemeData theme) {
  testWidgets('${theme.brightness} async loading announces its state', (
    tester,
  ) async {
    await pumpSharedWidget(
      tester,
      theme,
      (context) => AsyncView<int>(
        value: const AsyncLoading(),
        onRetry: () {},
        builder: (_, value) => Text(value.toString()),
      ),
      settle: false,
    );
    await tester.pump();
    expect(find.bySemanticsLabel('Loading'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

void _dataTest(ThemeData theme) {
  testWidgets('${theme.brightness} async data reaches the caller renderer', (
    tester,
  ) async {
    await pumpSharedWidget(
      tester,
      theme,
      (context) => AsyncView<int>(
        value: const AsyncData(24),
        onRetry: () {},
        builder: (_, value) => Text(value.toString()),
      ),
    );
    expect(find.text('24'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(tester.takeException(), isNull);
  });
}

void _emptyTest(ThemeData theme) {
  testWidgets(
    '${theme.brightness} async emptiness uses the provided offline state',
    (tester) async {
      await pumpSharedWidget(tester, theme, (context) {
        final strings = AppLocalizations.of(context);
        return AsyncView<List<int>>(
          value: const AsyncData([]),
          isEmpty: (items) => items.isEmpty,
          empty: HbEmptyState(
            title: strings.emptyNotesHeading,
            description: strings.emptyNotesDescription,
            detail: strings.emptyNotesPrivacy,
            asset: 'assets/icons/empty_note.svg',
            category: HbCategory.purple,
          ),
          onRetry: () {},
          builder: (_, items) => Text(items.length.toString()),
        );
      });
      expect(find.text('A place for what clicks.'), findsOneWidget);
      expect(
        find.text('They stay on this phone. Your witness cannot read them.'),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    },
  );
}

void _errorTest(ThemeData theme) {
  testWidgets(
    '${theme.brightness} async failure offers a working retry at large text sizes',
    (tester) async {
      var retries = 0;
      await pumpSharedWidget(
        tester,
        theme,
        (context) => AsyncView<int>(
          value: AsyncError(
            StateError('Test read failure'),
            StackTrace.current,
          ),
          onRetry: () => retries++,
          builder: (_, value) => Text(value.toString()),
        ),
      );
      expect(find.text('This couldn’t be opened.'), findsOneWidget);
      await tester.tap(find.text('Try again'));
      expect(retries, 1);
      expect(tester.takeException(), isNull);
    },
  );
}
