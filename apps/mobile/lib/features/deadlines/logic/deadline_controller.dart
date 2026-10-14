import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/logging/logger.dart';
import '../domain/deadline.dart';
import '../domain/deadline_category.dart';
import '../domain/deadline_schedule.dart';
import '../domain/deadline_status.dart';
import 'deadline_providers.dart';

class DeadlineController extends Notifier<AsyncValue<void>> {
  static final provider =
      NotifierProvider<DeadlineController, AsyncValue<void>>(
        DeadlineController.new,
      );
  @override
  AsyncValue<void> build() => const AsyncData(null);
  Future<Deadline?> save({
    required String title,
    required DeadlineCategory category,
    required DateTime dueAt,
    required List<int> stops,
    required List<int> disabledStops,
    Deadline? existing,
  }) async {
    if (state.isLoading) return null;
    final clean = title.trim().replaceAll(RegExp(r'[\x00-\x1F\x7F]'), '');
    if (clean.isEmpty ||
        DeadlineSchedule.daysBetween(dueAt, DateTime.now()) < 0) {
      return null;
    }
    return _perform(
      () => _write(clean, category, dueAt, stops, disabledStops, existing),
    );
  }

  Future<Deadline> _write(
    String title,
    DeadlineCategory category,
    DateTime dueAt,
    List<int> stops,
    List<int> disabledStops,
    Deadline? existing,
  ) async {
    final repository = ref.read(deadlineRepositoryProvider);
    if (existing == null)
      return repository.create(
        title: title,
        category: category,
        dueAt: dueAt,
        stops: stops,
        disabledStops: disabledStops,
      );
    final updated = existing.copyWith(
      title: title,
      category: category,
      dueAt: dueAt,
      stops: stops,
      disabledStops: disabledStops,
    );
    await repository.save(updated);
    return updated;
  }

  Future<Deadline?> changeStatus(Deadline deadline, DeadlineStatus status) {
    if (state.isLoading) return Future.value();
    return _perform(() async {
      final updated = deadline.copyWith(
        status: status,
        doneAt: status == DeadlineStatus.done ? DateTime.now() : null,
      );
      await ref.read(deadlineRepositoryProvider).save(updated);
      return updated;
    });
  }

  Future<Deadline?> _perform(Future<Deadline> Function() action) async {
    state = const AsyncLoading();
    try {
      final result = await action();
      ref.invalidate(deadlinesProvider);
      state = const AsyncData(null);
      return result;
    } catch (error, stack) {
      logError(error, stack);
      state = AsyncError(error, stack);
      return null;
    }
  }
}
