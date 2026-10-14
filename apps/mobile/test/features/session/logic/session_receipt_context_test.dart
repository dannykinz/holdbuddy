import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holdbuddy/core/fakes/fake_repository_overrides.dart';
import 'package:holdbuddy/features/notes/logic/note_controller.dart';
import 'package:holdbuddy/features/partners/logic/people_controller.dart';
import 'package:holdbuddy/features/partners/logic/plan_witnesses.dart';
import 'package:holdbuddy/features/plan/logic/chosen_plan.dart';
import 'package:holdbuddy/features/plan/logic/current_chapter.dart';
import 'package:holdbuddy/features/plan/logic/plan_controller.dart';
import 'package:holdbuddy/features/session/logic/session_controller.dart';
import 'package:holdbuddy/features/session/logic/session_receipt_providers.dart';
import 'package:holdbuddy/features/today/logic/today_controller.dart';

void main() {
  late ProviderContainer container;
  setUp(
    () => container = ProviderContainer(overrides: fakeRepositoryOverrides()),
  );
  tearDown(() => container.dispose());
  test(
    'Receipt remains tied to its plan and advances by reported units',
    () => _receiptPlan(container),
  );
  test(
    'Pending, blocked and removed witnesses cannot see a receipt',
    () => _receiptWitnesses(container),
  );
  test(
    'Zero units keeps the chapter and preview progress unchanged',
    () => _zeroUnits(container),
  );
  test(
    'Saving the last chapter finishes the selected preview plan',
    () => _lastChapter(container),
  );
}

void _receiptPlan(ProviderContainer container) {
  final controller = container.read(SessionController.provider.notifier);
  controller.begin(first: false, chapterNumber: 7);
  controller.pause();
  controller.setUnits(2);
  final next = container.read(sessionNextChapterProvider);
  expect(next?.number, 9);
  expect(next?.name, 'Error handling');
  final planId = container.read(chosenPlanProvider).id;
  container.read(ChosenPlan.provider.notifier).select('preview-animations');
  expect(container.read(sessionPlanProvider)?.id, planId);
  controller.save();
  controller.save();
  expect(container.read(chosenPlanProvider).unitsDone, 2);
  container.read(ChosenPlan.provider.notifier).select(planId);
  expect(container.read(chosenPlanProvider).unitsDone, 8);
  expect(container.read(NoteController.provider).length, 4);
  expect(container.read(currentChapterProvider)?.number, 9);
  expect(container.read(latestPlanReceiptProvider)?.units, 2);
}

void _receiptWitnesses(ProviderContainer container) {
  final planId = container.read(chosenPlanProvider).id;
  expect(container.read(planWitnessesProvider(planId)).length, 2);
  final people = container.read(PeopleController.provider.notifier);
  final elvis = container.read(PeopleController.provider).first;
  people.save(elvis.copyWith(blocked: true));
  expect(container.read(planWitnessesProvider(planId)).single.name, 'Mum');
  final mum = container.read(PeopleController.provider)[1];
  people.save(mum.copyWith(pending: true));
  expect(container.read(planWitnessesProvider(planId)), isEmpty);
  people.save(mum.copyWith(holdsMe: false));
  expect(container.read(planWitnessesProvider(planId)), isEmpty);
}

void _zeroUnits(ProviderContainer container) {
  final before = container.read(chosenPlanProvider).unitsDone;
  final controller = container.read(SessionController.provider.notifier);
  controller.begin(first: false, chapterNumber: 7);
  controller.pause();
  controller.setUnits(0);
  expect(container.read(sessionNextChapterProvider)?.number, 7);
  controller.save();
  controller.save();
  expect(container.read(chosenPlanProvider).unitsDone, before);
  final planId = container.read(chosenPlanProvider).id;
  expect(
    container.read(sessionRepositoryProvider).receiptsFor(planId).length,
    1,
  );
}

void _lastChapter(ProviderContainer container) {
  final plan = container.read(chosenPlanProvider);
  container
      .read(planPathRepositoryProvider)
      .replace(plan.copyWith(unitsDone: 23));
  container.invalidate(planChoicesProvider);
  final controller = container.read(SessionController.provider.notifier);
  controller.begin(first: false, chapterNumber: 24);
  controller.pause();
  controller.end();
  expect(container.read(sessionNextChapterProvider), isNull);
  controller.save();
  expect(container.read(chosenPlanProvider).unitsDone, 24);
  expect(container.read(currentChapterProvider), isNull);
}
