import 'package:flutter_test/flutter_test.dart';
import 'package:holdbuddy/core/fakes/fake_seed_data.dart';
import 'package:holdbuddy/features/deadlines/domain/deadline_category.dart';
import 'package:holdbuddy/features/deadlines/domain/deadline_status.dart';
import 'package:holdbuddy/features/partners/domain/partnership_status.dart';
import 'package:holdbuddy/features/plan/domain/plan_status.dart';

void main() {
  _planSeedTest();
  _witnessSeedTest();
  _deadlineSeedTest();
  _dateAnchorTest();
  _seedCollectionsTest();
}

void _planSeedTest() {
  test('One learner owns a committed Learning Dart plan', () {
    final seed = FakeSeedData(DateTime(2026, 10, 12));
    final plan = seed.plan;
    expect(seed.learner.displayName, 'Danny');
    expect(plan.title, 'Learning Dart');
    expect(plan.userId, seed.learner.id);
    expect(plan.status, PlanStatus.active);
    expect(plan.unitsDone, inInclusiveRange(0, plan.totalUnits));
    expect(plan.contract.planId, plan.id);
    expect(plan.contract.committedAt.isBefore(seed.today), isTrue);
    expect(plan.contract.days, [
      DateTime.monday,
      DateTime.wednesday,
      DateTime.friday,
    ]);
    expect(plan.contract.unitsPerSession, isPositive);
    expect(plan.contract.consequenceMessage, isNotEmpty);
  });
}

void _witnessSeedTest() {
  test('Both active witnesses link to the same learner and plan', () {
    final seed = FakeSeedData(DateTime(2026, 10, 12));
    expect(seed.partners.map((partner) => partner.witnessName), [
      'Elvis',
      'Amaka',
    ]);
    expect(seed.plan.witnessIds, seed.partners.map((partner) => partner.id));
    for (final partner in seed.partners) {
      expect(partner.learnerId, seed.learner.id);
      expect(partner.status, PartnershipStatus.active);
    }
  });
}

void _deadlineSeedTest() {
  test('Three upcoming deadlines cover School, Admin and Personal', () {
    final seed = FakeSeedData(DateTime(2026, 10, 12));
    expect(seed.deadlines.length, 3);
    expect(
      seed.deadlines.map((deadline) => deadline.category),
      DeadlineCategory.values,
    );
    for (final deadline in seed.deadlines) {
      expect(deadline.userId, seed.learner.id);
      expect(deadline.status, DeadlineStatus.upcoming);
    }
  });
}

void _dateAnchorTest() {
  test(
    'Injected dates normalize time and roll across month and year boundaries',
    () {
      final seed = FakeSeedData(DateTime(2026, 12, 30, 23, 59));
      expect(seed.today, DateTime(2026, 12, 30));
      expect(seed.plan.startDate, DateTime(2026, 12, 23));
      expect(seed.plan.targetDate, DateTime(2027, 1, 20));
      expect(seed.deadlines.map((deadline) => deadline.dueAt), [
        DateTime(2027, 1, 2),
        DateTime(2027, 1, 9),
        DateTime(2027, 1, 23),
      ]);
    },
  );
}

void _seedCollectionsTest() {
  test('Seed IDs are unique UUID v4 values and collections cannot be mutated', () {
    final seed = FakeSeedData(DateTime(2026, 10, 12));
    final ids = [
      seed.learner.id,
      seed.plan.id,
      ...seed.partners.map((partner) => partner.id),
      ...seed.partners.map((partner) => partner.witnessUserId),
      ...seed.deadlines.map((deadline) => deadline.id),
    ];
    final uuid = RegExp(
      r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
    );
    expect(ids.toSet().length, ids.length);
    expect(ids.every(uuid.hasMatch), isTrue);
    expect(() => seed.plan.witnessIds.clear(), throwsUnsupportedError);
    expect(() => seed.plan.contract.days.clear(), throwsUnsupportedError);
    expect(() => seed.partners.clear(), throwsUnsupportedError);
    expect(() => seed.deadlines.clear(), throwsUnsupportedError);
  });
}
