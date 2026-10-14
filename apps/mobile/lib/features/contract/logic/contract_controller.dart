import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/logging/logger.dart';
import '../../material/logic/material_controller.dart';
import '../../material/logic/material_providers.dart';
import '../../partners/logic/people_controller.dart';
import '../../partners/logic/selected_peer.dart';
import '../../plan/domain/plan_view.dart';
import '../../plan/logic/chosen_plan.dart';
import '../../plan/logic/plan_controller.dart';
import '../domain/contract_draft.dart';
import '../domain/contract_repository.dart';

final contractRepositoryProvider = Provider<ContractRepository>(
  (ref) => throw StateError('ContractRepository must be bound at bootstrap.'),
);
final contractFinishProvider = Provider<DateTime>((ref) {
  final draft = ref.watch(ContractController.provider);
  return ref.watch(contractRepositoryProvider).estimateFinish(draft);
});

class ContractController extends Notifier<ContractDraft> {
  static final provider = NotifierProvider<ContractController, ContractDraft>(
    ContractController.new,
  );

  @override
  ContractDraft build() => ref.read(contractRepositoryProvider).draft;

  void update(ContractDraft draft) {
    ref.read(contractRepositoryProvider).saveDraft(draft);
    state = draft;
  }

  void toggleDay(int day) {
    if (day < 1 || day > 7) return;
    final days = [...state.days];
    days.contains(day) ? days.remove(day) : days.add(day);
    days.sort();
    update(state.copyWith(days: days));
  }

  bool commit() {
    if (!state.canCommit) return false;
    try {
      final repository = ref.read(contractRepositoryProvider);
      repository.commit(state);
      final plan = ref
          .read(planPathRepositoryProvider)
          .create(state, repository.estimateFinish(state), _prepareWitness());
      final material = state.material;
      if (material != null) {
        ref.read(materialRepositoryProvider).attachPreview(material, plan.id);
        ref.invalidate(MaterialController.provider);
      }
      ref.read(ChosenPlan.provider.notifier).select(plan.id);
      ref.invalidate(planChoicesProvider);
      ref.read(PlanController.provider.notifier).show(PlanView.path);
      return true;
    } catch (error, stack) {
      logError(error, stack);
      return false;
    }
  }

  List<String> _prepareWitness() {
    if (state.withoutWitness) return const [];
    final repository = ref.read(peopleRepositoryProvider);
    final peer = repository.prepareInvite(
      state.witnessName,
      state.witnessContact,
      state.title,
    );
    repository.save(peer);
    ref.invalidate(PeopleController.provider);
    ref.read(SelectedPeer.provider.notifier).select(peer.id);
    return [peer.id];
  }
}
