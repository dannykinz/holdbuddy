import 'package:flutter_test/flutter_test.dart';
import 'package:holdbuddy/core/fakes/fake_seed_data.dart';
import 'package:holdbuddy/features/deadlines/domain/deadline_status.dart';
import 'package:holdbuddy/features/partners/domain/partnership_status.dart';
import 'package:holdbuddy/features/plan/domain/plan_status.dart';

void main() {
  _planCopyTest();
  _contractCopyTest();
  _otherCopiesTest();
}

void _planCopyTest() {
  test('Plan copies preserve originals and defensively copy witness IDs', () {
    final plan = FakeSeedData(DateTime(2026, 10, 12)).plan;
    final witnesses = ['replacement'];
    final copy = plan.copyWith(
      unitsDone: 4,
      status: PlanStatus.paused,
      witnessIds: witnesses,
    );
    witnesses.clear();
    expect(plan.unitsDone, 3);
    expect(plan.status, PlanStatus.active);
    expect(plan.witnessIds.length, 2);
    expect(copy.unitsDone, 4);
    expect(copy.status, PlanStatus.paused);
    expect(copy.witnessIds, ['replacement']);
    expect(copy.id, plan.id);
    expect(copy.userId, plan.userId);
    expect(copy.title, plan.title);
    expect(copy.totalUnits, plan.totalUnits);
    expect(copy.unitName, plan.unitName);
    expect(copy.startDate, plan.startDate);
    expect(copy.targetDate, plan.targetDate);
    expect(copy.contract, same(plan.contract));
    expect(() => copy.witnessIds.add('another'), throwsUnsupportedError);
  });
}

void _contractCopyTest() {
  test('Contract copies preserve the commitment and isolate day lists', () {
    final contract = FakeSeedData(DateTime(2026, 10, 12)).plan.contract;
    final days = [DateTime.tuesday];
    final copy = contract.copyWith(
      days: days,
      duration: const Duration(minutes: 30),
    );
    days.clear();
    expect(contract.days, [
      DateTime.monday,
      DateTime.wednesday,
      DateTime.friday,
    ]);
    expect(contract.duration, const Duration(minutes: 45));
    expect(copy.days, [DateTime.tuesday]);
    expect(copy.duration, const Duration(minutes: 30));
    expect(copy.planId, contract.planId);
    expect(copy.time, contract.time);
    expect(copy.unitsPerSession, contract.unitsPerSession);
    expect(copy.consequenceMessage, contract.consequenceMessage);
    expect(copy.committedAt, contract.committedAt);
    expect(copy.days.clear, throwsUnsupportedError);
  });
}

void _otherCopiesTest() {
  test(
    'Learner, partner and deadline copies do not mutate their originals',
    () {
      final seed = FakeSeedData(DateTime(2026, 10, 12));
      final learner = seed.learner;
      final partner = seed.partners.first;
      final deadline = seed.deadlines.first;
      final updatedLearner = learner.copyWith(displayName: 'Updated');
      final stoppedPartner = partner.copyWith(
        status: PartnershipStatus.stopped,
      );
      final doneDeadline = deadline.copyWith(status: DeadlineStatus.done);
      expect(learner.displayName, 'Danny');
      expect(updatedLearner.id, learner.id);
      expect(updatedLearner.studying, learner.studying);
      expect(updatedLearner.displayName, 'Updated');
      expect(partner.status, PartnershipStatus.active);
      expect(stoppedPartner.status, PartnershipStatus.stopped);
      expect(stoppedPartner.witnessUserId, partner.witnessUserId);
      expect(deadline.status, DeadlineStatus.upcoming);
      expect(doneDeadline.status, DeadlineStatus.done);
      expect(doneDeadline.title, deadline.title);
      expect(doneDeadline.dueAt, deadline.dueAt);
      expect(doneDeadline.category, deadline.category);
    },
  );
}
