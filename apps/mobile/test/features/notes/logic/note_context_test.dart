import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holdbuddy/core/fakes/fake_repository_overrides.dart';
import 'package:holdbuddy/features/notes/domain/note_category.dart';
import 'package:holdbuddy/features/notes/logic/note_controller.dart';
import 'package:holdbuddy/features/plan/logic/chosen_plan.dart';

void main() {
  test(
    'Notes retain chapter colour and do not leak to another plan',
    _checkNoteContext,
  );
}

void _checkNoteContext() {
  final container = ProviderContainer(overrides: fakeRepositoryOverrides());
  addTearDown(container.dispose);
  final controller = container.read(NoteController.provider.notifier);
  final functions = container.read(NoteController.provider)[1];
  controller.save(
    functions.copyWith(id: 'another-functions', body: 'New note'),
  );
  final notes = container.read(NoteController.provider);
  expect(notes.first.category, NoteCategory.orange);
  expect(notes[1].category, NoteCategory.purple);
  expect(notes[2].category, NoteCategory.orange);
  container.read(ChosenPlan.provider.notifier).select('preview-animations');
  expect(container.read(NoteController.provider), isEmpty);
  final draft = container.read(noteDraftProvider);
  expect(draft.planId, 'preview-animations');
  expect(draft.chapter, 3);
  expect(draft.body, isEmpty);
  controller.save(draft.copyWith(id: 'animations-note', body: 'Only here'));
  expect(container.read(NoteController.provider).single.body, 'Only here');
  container.read(ChosenPlan.provider.notifier).select(functions.planId);
  expect(container.read(NoteController.provider).length, 4);
}
