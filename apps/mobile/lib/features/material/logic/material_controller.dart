import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/logging/logger.dart';
import '../../plan/logic/plan_controller.dart';
import '../domain/linked_material.dart';
import '../domain/material_kind.dart';
import 'material_failure.dart';
import 'material_providers.dart';

final planMaterialsProvider = Provider<List<LinkedMaterial>>((ref) {
  final plan = ref.watch(chosenPlanProvider);
  return ref
      .watch(MaterialController.provider)
      .where((item) => item.planId == plan.id)
      .toList();
});
final selectedMaterialProvider = Provider.family<LinkedMaterial?, String?>(
  (ref, id) => ref
      .watch(planMaterialsProvider)
      .where((item) => item.id == id)
      .firstOrNull,
);

class MaterialController extends Notifier<List<LinkedMaterial>> {
  static final provider =
      NotifierProvider<MaterialController, List<LinkedMaterial>>(
        MaterialController.new,
      );
  @override
  List<LinkedMaterial> build() =>
      ref.watch(materialRepositoryProvider).materials;
  bool attach(MaterialKind kind) => _perform(() {
    final repository = ref.read(materialRepositoryProvider);
    repository.attachPreview(
      repository.preview(kind),
      ref.read(chosenPlanProvider).id,
    );
  });
  bool seek(LinkedMaterial material, int position) {
    final lower = material.kind == MaterialKind.audio ? 0 : 1;
    if (material.limit < lower) return false;
    return _perform(
      () => ref
          .read(materialRepositoryProvider)
          .save(
            material.copyWith(
              position: position.clamp(lower, material.limit).toInt(),
            ),
          ),
    );
  }

  bool _perform(void Function() action) {
    try {
      action();
      state = ref.read(materialRepositoryProvider).materials;
      ref.read(MaterialFailure.provider.notifier).set(false);
      return true;
    } catch (error, stack) {
      logError(error, stack);
      ref.read(MaterialFailure.provider.notifier).set(true);
      return false;
    }
  }
}
