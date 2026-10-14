import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/focus_repository.dart';
import '../domain/focus_state.dart';
import '../domain/study_mode.dart';

final focusRepositoryProvider = Provider<FocusRepository>(
  (ref) => throw StateError('FocusRepository must be bound at bootstrap.'),
);

class FocusController extends Notifier<FocusState> {
  static final provider = NotifierProvider<FocusController, FocusState>(
    FocusController.new,
  );
  @override
  FocusState build() => ref.read(focusRepositoryProvider).preferences;
  void beginSession() => _save(state.copyWith(running: true));
  void endSession() => _save(state.copyWith(running: false));
  void mode(StudyMode value) => _save(state.copyWith(mode: value));
  void silence(bool value) => _save(state.copyWith(silence: value));
  void requestAccess() =>
      state = ref.read(focusRepositoryProvider).requestAccess();
  void _save(FocusState value) {
    ref.read(focusRepositoryProvider).save(value);
    state = value;
  }
}
