import 'package:flutter_riverpod/misc.dart';

import '../../features/auth/domain/auth_repository.dart';
import '../../features/auth/logic/auth_controller.dart';
import '../../features/contract/logic/contract_controller.dart';
import '../../features/deadlines/logic/deadline_providers.dart';
import '../../features/focus/logic/focus_controller.dart';
import '../../features/material/logic/material_providers.dart';
import '../../features/notes/logic/note_controller.dart';
import '../../features/partners/logic/partner_providers.dart';
import '../../features/partners/logic/people_controller.dart';
import '../../features/plan/logic/plan_change_controller.dart';
import '../../features/plan/logic/plan_controller.dart';
import '../../features/plan/logic/plan_providers.dart';
import '../../features/pro/logic/pro_controller.dart';
import '../../features/profile/logic/learner_providers.dart';
import '../../features/session/logic/missed_controller.dart';
import '../../features/session/logic/session_controller.dart';
import '../../features/settings/logic/settings_controller.dart';
import '../../features/tasks/logic/task_controller.dart';
import '../../features/today/logic/alert_controller.dart';
import '../../features/today/logic/progress_controller.dart';
import '../../features/today/logic/today_controller.dart';
import 'fake_alert_repository.dart';
import 'fake_auth_repository.dart';
import 'fake_contract_repository.dart';
import 'fake_deadline_repository.dart';
import 'fake_focus_repository.dart';
import 'fake_learner_repository.dart';
import 'fake_material_repository.dart';
import 'fake_missed_repository.dart';
import 'fake_note_repository.dart';
import 'fake_partner_repository.dart';
import 'fake_people_repository.dart';
import 'fake_plan_change_repository.dart';
import 'fake_plan_path_repository.dart';
import 'fake_plan_repository.dart';
import 'fake_pro_repository.dart';
import 'fake_progress_repository.dart';
import 'fake_seed_data.dart';
import 'fake_session_repository.dart';
import 'fake_settings_repository.dart';
import 'fake_task_repository.dart';
import 'fake_today_repository.dart';

/// UI-phase bindings. Replace these when real repositories are ready.
List<Override> fakeRepositoryOverrides({
  DateTime? today,
  AuthRepository? auth,
}) {
  final seed = FakeSeedData(today ?? DateTime.now());
  return [..._uiOverrides(auth), ..._seedOverrides(seed)];
}

List<Override> _uiOverrides(AuthRepository? auth) {
  final plans = FakePlanPathRepository();
  final sessions = FakeSessionRepository(plans);
  return [
    proRepositoryProvider.overrideWithValue(FakeProRepository()),
    settingsRepositoryProvider.overrideWithValue(FakeSettingsRepository()),
    planChangeRepositoryProvider.overrideWithValue(FakePlanChangeRepository()),
    peopleRepositoryProvider.overrideWithValue(FakePeopleRepository()),
    authRepositoryProvider.overrideWithValue(auth ?? FakeAuthRepository()),
    contractRepositoryProvider.overrideWithValue(FakeContractRepository()),
    materialRepositoryProvider.overrideWithValue(FakeMaterialRepository()),
    sessionRepositoryProvider.overrideWithValue(sessions),
    todayRepositoryProvider.overrideWithValue(FakeTodayRepository(sessions)),
    noteRepositoryProvider.overrideWithValue(FakeNoteRepository()),
    taskRepositoryProvider.overrideWithValue(FakeTaskRepository()),
    missedRepositoryProvider.overrideWithValue(FakeMissedRepository()),
    focusRepositoryProvider.overrideWithValue(FakeFocusRepository()),
    planPathRepositoryProvider.overrideWithValue(plans),
    alertRepositoryProvider.overrideWithValue(FakeAlertRepository()),
    progressRepositoryProvider.overrideWithValue(FakeProgressRepository()),
  ];
}

List<Override> _seedOverrides(FakeSeedData seed) => [
  learnerRepositoryProvider.overrideWithValue(
    FakeLearnerRepository(
      seed.learner.copyWith(
        displayName: 'Danny Akinleye',
        studying: 'Entrepreneurship · Miva',
        email: 'danny@example.com',
        avatar: 'assets/avatars/people_you.png',
      ),
    ),
  ),
  planRepositoryProvider.overrideWithValue(FakePlanRepository([seed.plan])),
  partnerRepositoryProvider.overrideWithValue(
    FakePartnerRepository(seed.partners),
  ),
  deadlineRepositoryProvider.overrideWithValue(
    FakeDeadlineRepository(seed.deadlines, today: seed.today),
  ),
];
