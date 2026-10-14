import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/logging/logger.dart';
import '../domain/learner.dart';
import 'learner_providers.dart';

class ProfileController extends Notifier<AsyncValue<void>> {
  static final provider = NotifierProvider<ProfileController, AsyncValue<void>>(
    ProfileController.new,
  );
  @override
  AsyncValue<void> build() => const AsyncData(null);
  Future<bool> save(Learner learner) =>
      _perform(() => ref.read(learnerRepositoryProvider).save(learner));
  Future<bool> confirmDeletionPreview() =>
      _perform(() => ref.read(learnerRepositoryProvider).previewDeletion());
  Future<bool> _perform(Future<void> Function() action) async {
    state = const AsyncLoading();
    try {
      await action();
      state = const AsyncData(null);
      return true;
    } catch (error, stack) {
      logError(error, stack);
      state = AsyncError(error, stack);
      return false;
    }
  }
}
