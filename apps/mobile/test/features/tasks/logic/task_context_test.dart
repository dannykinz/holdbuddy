import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holdbuddy/core/fakes/fake_repository_overrides.dart';
import 'package:holdbuddy/features/plan/logic/chosen_plan.dart';
import 'package:holdbuddy/features/tasks/logic/task_controller.dart';

void main() {
  test('Checklist changes stay within their plan and chapter', () {
    final container = ProviderContainer(overrides: fakeRepositoryOverrides());
    addTearDown(container.dispose);
    final controller = container.read(TaskController.provider.notifier);
    final original = container.read(chapterTasksProvider(7)).first;
    controller.toggle(original);
    expect(container.read(chapterTasksProvider(7)).first.done, isFalse);
    expect(container.read(chapterTasksProvider(6)).first.done, isFalse);
    expect(controller.add('Chapter six only', chapter: 6), isTrue);
    expect(container.read(chapterTasksProvider(6)).length, 4);
    expect(container.read(chapterTasksProvider(7)).length, 3);
    container.read(ChosenPlan.provider.notifier).select('preview-animations');
    expect(container.read(chapterTasksProvider(6)).length, 3);
    expect(container.read(chapterTasksProvider(7)).first.done, isFalse);
  });
}
