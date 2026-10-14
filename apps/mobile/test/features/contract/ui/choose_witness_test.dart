import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holdbuddy/app/router/app_route.dart';
import 'package:holdbuddy/app/theme/app_theme.dart';
import 'package:holdbuddy/core/l10n/generated/app_localizations.dart';
import 'package:holdbuddy/features/contract/logic/contract_controller.dart';
import 'package:holdbuddy/features/contract/ui/choose_witness_screen.dart';

import '../../../support/pump_account.dart';

void main() {
  for (final theme in [AppTheme.light, AppTheme.dark]) {
    testWidgets(
      '${theme.brightness} witness name is normalized before review',
      (tester) async {
        final app = await pumpAccount(tester, theme, AppRoute.chooseWitness);
        await tester.pumpAndSettle();
        final context = tester.element(find.byType(ChooseWitnessScreen));
        final l10n = AppLocalizations.of(context);
        await tester.enterText(
          find.byType(TextFormField).first,
          '  Danny   Kinz  ',
        );
        await tester.enterText(
          find.byType(TextFormField).last,
          'danny@example.com',
        );
        await tapAccount(tester, l10n.contractReview);
        await tester.pumpAndSettle();
        final draft = app.container.read(ContractController.provider);
        expect(draft.witnessName, 'Danny Kinz');
        expect(draft.witnessContact, 'danny@example.com');
        expect(draft.withoutWitness, isFalse);
        expect(app.router.state.uri.path, AppRoute.contract.path);
        expect(tester.takeException(), isNull);
      },
    );
  }
}
