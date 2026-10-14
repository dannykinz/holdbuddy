import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holdbuddy/core/fakes/fake_repository_overrides.dart';
import 'package:holdbuddy/features/plan/logic/chosen_plan.dart';
import 'package:holdbuddy/features/plan/logic/plan_controller.dart';
import 'package:holdbuddy/features/session/domain/session_stage.dart';
import 'package:holdbuddy/features/session/logic/session_controller.dart';

void main() {
  late ProviderContainer container;
  setUp(
    () => container = ProviderContainer(overrides: fakeRepositoryOverrides()),
  );
  tearDown(() => container.dispose());
  test(
    'Selected chapter supplies the session title and duration',
    () => _selectedChapter(container),
  );
  test(
    'Starting another plan preserves the unfinished session',
    () => _unfinishedSession(container),
  );
}

void _selectedChapter(ProviderContainer container) {
  final controller = container.read(SessionController.provider.notifier);
  controller.begin(first: false, chapterNumber: 6);
  controller.pause();
  final state = container.read(SessionController.provider);
  final plan = container.read(chosenPlanProvider);
  expect(state.planId, plan.id);
  expect(state.chapterNumber, 6);
  expect(state.chapterName, 'Functions');
  expect(state.remainingSeconds, plan.contract.duration.inSeconds);
}

void _unfinishedSession(ProviderContainer container) {
  final controller = container.read(SessionController.provider.notifier);
  controller.begin(first: false, chapterNumber: 7);
  controller.pause();
  controller.saveNote('Keep this private note');
  final paused = container.read(SessionController.provider);
  container.read(ChosenPlan.provider.notifier).select('preview-animations');
  controller.begin(first: false, chapterNumber: 3);
  final restored = container.read(SessionController.provider);
  expect(restored.planId, paused.planId);
  expect(restored.chapterNumber, paused.chapterNumber);
  expect(restored.remainingSeconds, paused.remainingSeconds);
  expect(restored.note, paused.note);
  expect(restored.stage, SessionStage.paused);
  expect(container.read(chosenPlanProvider).id, paused.planId);
  expect(controller.hasUnfinishedSession, isTrue);
}
