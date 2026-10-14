import 'dart:ui' show Tristate;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holdbuddy/app/theme/app_theme.dart';
import 'package:holdbuddy/app/theme/tokens.dart';
import 'package:holdbuddy/core/l10n/generated/app_localizations.dart';
import 'package:holdbuddy/core/widgets/hb_create_button.dart';
import 'package:holdbuddy/core/widgets/hb_day_chip.dart';
import 'package:holdbuddy/core/widgets/hb_day_status.dart';
import 'package:holdbuddy/core/widgets/hb_path_node.dart';
import 'package:holdbuddy/core/widgets/hb_path_status.dart';
import 'package:holdbuddy/core/widgets/hb_segmented.dart';
import 'package:holdbuddy/core/widgets/hb_weekday_chip.dart';

import '../../support/load_inter_font.dart';
import '../../support/pump_shared_widget.dart';

void main() {
  setUpAll(loadInterFont);
  for (final theme in [AppTheme.light, AppTheme.dark]) {
    _calendarTest(theme);
    _segmentedTest(theme);
    _actionsTest(theme);
  }
}

void _calendarTest(ThemeData theme) {
  testWidgets(
    '${theme.brightness} calendar states announce meaning and offer 48px targets',
    (tester) async {
      var presses = 0;
      await pumpSharedWidget(
        tester,
        theme,
        (context) => _calendar(onPressed: () => presses++),
      );
      expect(find.bySemanticsLabel('12 October, Missed'), findsOneWidget);
      for (final button in find.byType(TextButton).evaluate()) {
        expect(
          tester.getSize(find.byWidget(button.widget)).width,
          Tokens.minTouchTarget,
        );
      }
      await tester.tap(find.bySemanticsLabel('12 October, Missed'));
      expect(presses, 1);
      expect(tester.takeException(), isNull);
    },
  );
}

void _segmentedTest(ThemeData theme) {
  testWidgets(
    '${theme.brightness} segmented choice changes without losing its semantics',
    (tester) async {
      var selected = 0;
      await pumpSharedWidget(
        tester,
        theme,
        (context) => StatefulBuilder(
          builder: (context, setState) => HbSegmented(
            labels: _segmentLabels(context),
            selected: selected,
            onSelected: (index) => setState(() => selected = index),
          ),
        ),
      );
      await tester.tap(find.text('Month'));
      await tester.pumpAndSettle();
      expect(selected, 1);
      expect(
        tester.getSemantics(find.text('Month')).flagsCollection.isSelected,
        Tristate.isTrue,
      );
      expect(
        tester.getSize(find.byType(TextButton).first).height,
        greaterThanOrEqualTo(Tokens.minTouchTarget),
      );
      expect(tester.takeException(), isNull);
    },
  );
}

void _actionsTest(ThemeData theme) {
  testWidgets(
    '${theme.brightness} weekday, path and create controls invoke their actions',
    (tester) async {
      var presses = 0;
      await pumpSharedWidget(
        tester,
        theme,
        (context) => _actions(onPressed: () => presses++),
      );
      await tester.tap(find.byTooltip('Create'));
      expect(
        tester.getSemantics(find.text('Monday')).flagsCollection.isSelected,
        Tristate.isTrue,
      );
      await tester.tap(find.text('Monday'));
      for (final status in HbPathStatus.values)
        await tester.tap(find.bySemanticsLabel(status.name));
      expect(presses, 5);
      expect(
        tester.getSize(find.byType(IconButton)).shortestSide,
        greaterThanOrEqualTo(Tokens.minTouchTarget),
      );
      expect(tester.takeException(), isNull);
    },
  );
}

Widget _calendar({required VoidCallback onPressed}) => Column(
  children: [
    for (final status in HbDayStatus.values)
      HbDayChip(
        weekday: 'MON',
        day: '12',
        dateLabel: '12 October',
        status: status,
        onPressed: onPressed,
      ),
  ],
);

Widget _actions({required VoidCallback onPressed}) => Column(
  children: [
    HbCreateButton(onPressed: onPressed),
    HbWeekdayChip(label: 'Monday', selected: true, onSelected: onPressed),
    for (final status in HbPathStatus.values)
      HbPathNode(
        status: status,
        number: '8',
        label: status.name,
        onPressed: onPressed,
      ),
  ],
);

List<String> _segmentLabels(BuildContext context) {
  final strings = AppLocalizations.of(context);
  return [strings.week, strings.month, strings.allTime];
}
