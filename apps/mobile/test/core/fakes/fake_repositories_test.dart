import 'package:flutter_test/flutter_test.dart';
import 'package:holdbuddy/core/fakes/fake_deadline_repository.dart';
import 'package:holdbuddy/core/fakes/fake_learner_repository.dart';
import 'package:holdbuddy/core/fakes/fake_partner_repository.dart';
import 'package:holdbuddy/core/fakes/fake_plan_repository.dart';
import 'package:holdbuddy/core/fakes/fake_seed_data.dart';

void main() {
  _snapshotTest();
  _emptyTest();
}

void _snapshotTest() {
  test('Fakes retain immutable snapshots of constructor collections', () async {
    final seed = FakeSeedData(DateTime(2026, 10, 12));
    final plans = [seed.plan];
    final partners = seed.partners.toList();
    final deadlines = seed.deadlines.toList();
    final planRepository = FakePlanRepository(plans);
    final partnerRepository = FakePartnerRepository(partners);
    final deadlineRepository = FakeDeadlineRepository(deadlines);
    plans.clear();
    partners.clear();
    deadlines.clear();
    final savedPlans = await planRepository.fetchPlans();
    final savedPartners = await partnerRepository.fetchPartners();
    final savedDeadlines = await deadlineRepository.fetchDeadlines();
    expect(savedPlans.single.title, 'Learning Dart');
    expect(savedPartners.length, 2);
    expect(savedDeadlines.length, 3);
    expect(
      await FakeLearnerRepository(seed.learner).fetchLearner(),
      same(seed.learner),
    );
    expect(savedPlans.clear, throwsUnsupportedError);
    expect(savedPartners.clear, throwsUnsupportedError);
    expect(savedDeadlines.clear, throwsUnsupportedError);
  });
}

void _emptyTest() {
  test(
    'List repositories support empty states without manufacturing data',
    () async {
      expect(await FakePlanRepository([]).fetchPlans(), isEmpty);
      expect(await FakePartnerRepository([]).fetchPartners(), isEmpty);
      expect(await FakeDeadlineRepository([]).fetchDeadlines(), isEmpty);
    },
  );
}
