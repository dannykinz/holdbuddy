import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/logging/logger.dart';
import '../domain/plan_change.dart';
import '../domain/plan_change_kind.dart';
import '../domain/plan_change_repository.dart';
import '../domain/plan_status.dart';
import 'plan_change_failure.dart';
import 'plan_controller.dart';

final planChangeRepositoryProvider = Provider<PlanChangeRepository>(
  (ref) => throw StateError('PlanChangeRepository must be bound.'),
);
final savedPlanChangeProvider = Provider<PlanChange?>(
  (ref) => ref
      .watch(planChangeRepositoryProvider)
      .changeFor(ref.watch(chosenPlanProvider).id),
);
final planChangeFailureProvider = NotifierProvider<PlanChangeFailure, bool>(
  PlanChangeFailure.new,
);

class PlanChangeController extends Notifier<PlanChange> {
  static final provider = NotifierProvider<PlanChangeController, PlanChange>(
    PlanChangeController.new,
  );
  @override
  PlanChange build() => ref
      .read(planChangeRepositoryProvider)
      .prepare(ref.read(chosenPlanProvider), PlanChangeKind.rhythm);
  void begin(PlanChangeKind kind) {
    state = ref
        .read(planChangeRepositoryProvider)
        .prepare(ref.read(chosenPlanProvider), kind);
    ref.read(planChangeFailureProvider.notifier).set(false);
  }

  void update(PlanChange change) => state = change;
  void toggleDay(int day) {
    final days = [...state.plan.contract.days];
    days.contains(day) ? days.remove(day) : days.add(day);
    days.sort();
    update(
      state.copyWith(
        plan: state.plan.copyWith(
          contract: state.plan.contract.copyWith(days: days),
        ),
      ),
    );
  }

  bool commit() {
    if (!state.isValid) return false;
    try {
      final plan = state.plan.copyWith(
        status: PlanStatus.renegotiated,
        witnessIds: ref.read(chosenPlanProvider).witnessIds,
      );
      ref.read(planPathRepositoryProvider).replace(plan);
      ref.read(planChangeRepositoryProvider).save(state.copyWith(plan: plan));
      ref.invalidate(planChoicesProvider);
      ref.invalidate(savedPlanChangeProvider);
      return true;
    } catch (error, stack) {
      logError(error, stack);
      ref.read(planChangeFailureProvider.notifier).set(true);
      return false;
    }
  }

  bool archive() {
    try {
      final plan = ref.read(chosenPlanProvider);
      ref
          .read(planPathRepositoryProvider)
          .replace(plan.copyWith(status: PlanStatus.archived));
      ref.invalidate(planChoicesProvider);
      return true;
    } catch (error, stack) {
      logError(error, stack);
      ref.read(planChangeFailureProvider.notifier).set(true);
      return false;
    }
  }
}
