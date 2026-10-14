import '../../features/contract/domain/study_contract.dart';
import '../../features/deadlines/domain/deadline.dart';
import '../../features/deadlines/domain/deadline_category.dart';
import '../../features/deadlines/domain/deadline_status.dart';
import '../../features/partners/domain/partner.dart';
import '../../features/partners/domain/partnership_status.dart';
import '../../features/plan/domain/plan_status.dart';
import '../../features/plan/domain/study_plan.dart';
import '../../features/profile/domain/learner.dart';

/// Demo user content, not UI labels. Dates share an injectable local-day anchor.
class FakeSeedData {
  FakeSeedData(DateTime today)
    : today = DateTime(today.year, today.month, today.day);

  static const learnerId = '00000000-0000-4000-8000-000000000001';
  static const planId = '00000000-0000-4000-8000-000000000002';
  static const elvisPartnershipId = '00000000-0000-4000-8000-000000000003';
  static const amakaPartnershipId = '00000000-0000-4000-8000-000000000004';

  final DateTime today;

  Learner get learner =>
      const Learner(id: learnerId, displayName: 'Danny', studying: 'Dart');

  StudyPlan get plan => StudyPlan(
    id: planId,
    userId: learnerId,
    title: 'Learning Dart',
    totalUnits: 12,
    unitName: 'chapter',
    unitsDone: 3,
    startDate: _day(-7),
    targetDate: _day(21),
    status: PlanStatus.active,
    contract: StudyContract(
      planId: planId,
      days: const [DateTime.monday, DateTime.wednesday, DateTime.friday],
      time: const Duration(hours: 19),
      duration: const Duration(minutes: 45),
      unitsPerSession: 1,
      consequenceMessage: "If I skip, tell Elvis I'm slacking again.",
      committedAt: _day(-7),
    ),
    witnessIds: const [elvisPartnershipId, amakaPartnershipId],
  );

  List<Partner> get partners => const [
    Partner(
      id: elvisPartnershipId,
      learnerId: learnerId,
      witnessUserId: '00000000-0000-4000-8000-000000000005',
      witnessName: 'Elvis',
      status: PartnershipStatus.active,
    ),
    Partner(
      id: amakaPartnershipId,
      learnerId: learnerId,
      witnessUserId: '00000000-0000-4000-8000-000000000006',
      witnessName: 'Amaka',
      status: PartnershipStatus.active,
    ),
  ];

  static const _deadlineFixtures = [
    (
      id: '00000000-0000-4000-8000-000000000007',
      title: 'Submit Dart assignment',
      category: DeadlineCategory.school,
      daysAway: 3,
    ),
    (
      id: '00000000-0000-4000-8000-000000000008',
      title: 'Exam registration',
      category: DeadlineCategory.admin,
      daysAway: 10,
    ),
    (
      id: '00000000-0000-4000-8000-000000000009',
      title: 'Update my CV',
      category: DeadlineCategory.personal,
      daysAway: 24,
    ),
  ];

  List<Deadline> get deadlines => List.unmodifiable(
    _deadlineFixtures.map(
      (fixture) => Deadline(
        id: fixture.id,
        userId: learnerId,
        title: fixture.title,
        category: fixture.category,
        dueAt: _day(fixture.daysAway),
        status: DeadlineStatus.upcoming,
      ),
    ),
  );

  DateTime _day(int offset) =>
      DateTime(today.year, today.month, today.day + offset);
}
