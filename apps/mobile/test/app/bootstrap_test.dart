import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holdbuddy/app/theme/tokens.dart';
import 'package:holdbuddy/features/deadlines/logic/deadline_providers.dart';
import 'package:holdbuddy/features/partners/logic/partner_providers.dart';
import 'package:holdbuddy/features/plan/logic/plan_providers.dart';
import 'package:holdbuddy/features/profile/logic/learner_providers.dart';
import 'package:holdbuddy/main.dart' as bootstrap;

import '../support/load_inter_font.dart';

void main() {
  setUpAll(loadInterFont);
  testWidgets('Real app bootstrap makes demo data available to screens', (
    tester,
  ) async {
    bootstrap.main();
    await tester.pumpAndSettle();
    await tester.pump(OnboardingTokens.splashDelay);
    await tester.pumpAndSettle();
    final context = tester.element(find.byType(Scaffold));
    final container = ProviderScope.containerOf(context);
    expect(
      (await container.read(learnerProvider.future)).displayName,
      'Danny Akinleye',
    );
    expect(
      (await container.read(plansProvider.future)).single.title,
      'Learning Dart',
    );
    expect((await container.read(partnersProvider.future)).length, 2);
    expect((await container.read(deadlinesProvider.future)).length, 3);
    expect(tester.takeException(), isNull);
  });
}
