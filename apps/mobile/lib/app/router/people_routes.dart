import 'package:flutter/widgets.dart';

import '../../features/partners/ui/partners_screen.dart';
import '../../features/partners/ui/their_plan_screen.dart';
import '../../features/partners/ui/witness_access_ended_screen.dart';
import '../../features/partners/ui/witness_acknowledged_screen.dart';
import '../../features/partners/ui/witness_invite_screen.dart';
import '../../features/partners/ui/witness_manage_screen.dart';
import '../../features/partners/ui/witness_nudge_sent_screen.dart';
import '../../features/partners/ui/witness_offline_invite_screen.dart';
import '../../features/partners/ui/witness_pending_screen.dart';
import '../../features/partners/ui/witness_remove_screen.dart';
import '../../features/partners/ui/witness_removed_screen.dart';
import '../../features/partners/ui/witness_stop_screen.dart';
import '../../features/profile/ui/account_delete_screen.dart';
import '../../features/profile/ui/account_deleted_screen.dart';
import '../../features/profile/ui/profile_edit_screen.dart';
import '../../features/safety/ui/report_screen.dart';
import '../../features/safety/ui/report_sent_screen.dart';
import 'app_route.dart';

abstract final class PeopleRoutes {
  static Widget? screen(AppRoute route) => switch (route) {
    AppRoute.profileEdit => const ProfileEditScreen(),
    AppRoute.partners => const PartnersScreen(),
    AppRoute.partnerTheirPlan => const TheirPlanScreen(),
    AppRoute.witnessManage => const WitnessManageScreen(),
    AppRoute.witnessPending => const WitnessPendingScreen(),
    AppRoute.witnessNudgeSent => const WitnessNudgeSentScreen(),
    AppRoute.witnessAcknowledged => const WitnessAcknowledgedScreen(),
    AppRoute.witnessStopSharing => const WitnessStopScreen(),
    AppRoute.witnessAccessEnded => const WitnessAccessEndedScreen(),
    AppRoute.witnessInvite => const WitnessInviteScreen(),
    AppRoute.witnessOfflineInvite => const WitnessOfflineInviteScreen(),
    AppRoute.witnessRemoveConfirmation => const WitnessRemoveScreen(),
    AppRoute.witnessRemoved => const WitnessRemovedScreen(),
    AppRoute.safetyReport => const ReportScreen(),
    AppRoute.safetyReportSent => const ReportSentScreen(),
    AppRoute.accountDelete => const AccountDeleteScreen(),
    AppRoute.accountDeleted => const AccountDeletedScreen(),
    _ => null,
  };
}
