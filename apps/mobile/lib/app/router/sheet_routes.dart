import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/generated/app_localizations.dart';
import '../../core/widgets/hb_sheet_page.dart';
import '../../features/material/ui/material_add_sheet.dart';
import '../../features/partners/logic/people_controller.dart';
import '../../features/partners/ui/hold_each_other_sheet.dart';
import '../../features/plan/ui/plan_switch_sheet.dart';
import '../../features/safety/ui/block_confirm_sheet.dart';
import '../../features/safety/ui/safety_options_sheet.dart';
import '../../features/today/ui/create_sheet.dart';
import 'app_route.dart';

abstract final class SheetRoutes {
  static const routes = [
    AppRoute.todayCreate,
    AppRoute.planSwitch,
    AppRoute.materialAdd,
    AppRoute.partnerHoldEachOther,
    AppRoute.safetyOptions,
    AppRoute.safetyBlockConfirm,
  ];
  static const _customTitles = [
    AppRoute.partnerHoldEachOther,
    AppRoute.safetyOptions,
    AppRoute.safetyBlockConfirm,
  ];
  static Page<Object?> page(
    BuildContext context,
    AppRoute route,
    LocalKey key,
  ) => HbSheetPage(
    key: key,
    name: route.name,
    title: _title(context, route),
    child: _child(route),
    showTitle: !_customTitles.contains(route),
  );
  static String _title(BuildContext context, AppRoute route) {
    final l = AppLocalizations.of(context);
    return switch (route) {
      AppRoute.planSwitch => l.planYourPlans,
      AppRoute.materialAdd => l.materialAdd,
      AppRoute.partnerHoldEachOther => l.mutualTitle,
      AppRoute.safetyOptions => l.peopleOptions,
      AppRoute.safetyBlockConfirm => l.safetyBlockQuestion(
        ProviderScope.containerOf(context).read(selectedPeerProvider).name,
      ),
      _ => l.create,
    };
  }

  static Widget _child(AppRoute route) => switch (route) {
    AppRoute.planSwitch => const PlanSwitchSheet(),
    AppRoute.materialAdd => const MaterialAddSheet(),
    AppRoute.partnerHoldEachOther => const HoldEachOtherSheet(),
    AppRoute.safetyOptions => const SafetyOptionsSheet(),
    AppRoute.safetyBlockConfirm => const BlockConfirmSheet(),
    _ => const CreateSheet(),
  };
}
