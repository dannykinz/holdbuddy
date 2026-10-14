import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holdbuddy/core/fakes/fake_repository_overrides.dart';
import 'package:holdbuddy/core/fakes/fake_seed_data.dart';
import 'package:holdbuddy/features/deadlines/logic/deadline_providers.dart';
import 'package:holdbuddy/features/partners/logic/partner_providers.dart';
import 'package:holdbuddy/features/plan/logic/plan_providers.dart';
import 'package:holdbuddy/features/profile/domain/learner_repository.dart';
import 'package:holdbuddy/features/profile/logic/learner_providers.dart';
import 'package:mocktail/mocktail.dart';

class _MockLearnerRepository extends Mock implements LearnerRepository {}

void main() {
  _bootstrapTest();
  _replacementTest();
  _failureTest();
  _scopeTest();
}

void _bootstrapTest() {
  test(
    'Bootstrap binds all four repositories and resolves AsyncValue data',
    () async {
      final container = ProviderContainer.test(
        overrides: fakeRepositoryOverrides(today: DateTime(2026, 10, 12)),
      );
      expect(container.read(learnerProvider).isLoading, isTrue);
      final learner = await container.read(learnerProvider.future);
      final plans = await container.read(plansProvider.future);
      final partners = await container.read(partnersProvider.future);
      final deadlines = await container.read(deadlinesProvider.future);
      expect(plans.single.userId, learner.id);
      expect(partners.length, 2);
      expect(deadlines.length, 3);
      expect(container.read(learnerProvider).hasValue, isTrue);
      expect(container.read(plansProvider).hasValue, isTrue);
      expect(container.read(partnersProvider).hasValue, isTrue);
      expect(container.read(deadlinesProvider).hasValue, isTrue);
    },
  );
}

void _replacementTest() {
  test('The same data provider accepts a replacement repository', () async {
    final repository = _MockLearnerRepository();
    final learner = FakeSeedData(DateTime(2026, 10, 12)).learner
        .copyWith(displayName: 'Another learner');
    when(repository.fetchLearner).thenAnswer((_) async => learner);
    final container = ProviderContainer.test(
      overrides: [learnerRepositoryProvider.overrideWithValue(repository)],
    );
    expect(await container.read(learnerProvider.future), same(learner));
    verify(repository.fetchLearner).called(1);
  });
}

void _failureTest() {
  test('Repository failures remain visible as AsyncError', () async {
    final repository = _MockLearnerRepository();
    final error = StateError('Fixture read failed');
    when(repository.fetchLearner).thenAnswer((_) async => throw error);
    final container = ProviderContainer.test(
      overrides: [learnerRepositoryProvider.overrideWithValue(repository)],
      retry: (retryCount, error) => null,
    );
    await expectLater(
      container.read(learnerProvider.future),
      throwsA(same(error)),
    );
    expect(container.read(learnerProvider).error, same(error));
    verify(repository.fetchLearner).called(1);
  });
}

void _scopeTest() {
  test(
    'Fixture dates and repository instances stay local to each scope',
    () async {
      final first = ProviderContainer.test(
        overrides: fakeRepositoryOverrides(today: DateTime(2026, 10, 12)),
      );
      final second = ProviderContainer.test(
        overrides: fakeRepositoryOverrides(today: DateTime(2027)),
      );
      final firstDeadline = (await first.read(deadlinesProvider.future)).first;
      final secondDeadline = (await second.read(deadlinesProvider.future))
          .first;
      expect(firstDeadline.dueAt, DateTime(2026, 10, 15));
      expect(secondDeadline.dueAt, DateTime(2027, 1, 4));
      expect(
        first.read(deadlineRepositoryProvider),
        isNot(same(second.read(deadlineRepositoryProvider))),
      );
    },
  );
}
