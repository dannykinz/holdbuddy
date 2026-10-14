import 'package:flutter/material.dart';

import '../../features/contract/ui/choose_witness_screen.dart';
import '../../features/contract/ui/consequence_screen.dart';
import '../../features/contract/ui/contract_screen.dart';
import '../../features/contract/ui/rhythm_screen.dart';
import '../../features/contract/ui/scope_screen.dart';
import 'app_route.dart';

abstract final class ContractRoutes {
  static const _screens = <AppRoute, Widget>{
    AppRoute.scope: ScopeScreen(),
    AppRoute.rhythm: RhythmScreen(),
    AppRoute.consequence: ConsequenceScreen(),
    AppRoute.chooseWitness: ChooseWitnessScreen(),
    AppRoute.contract: ContractScreen(),
  };
  static Widget? screen(AppRoute route) => _screens[route];
}
