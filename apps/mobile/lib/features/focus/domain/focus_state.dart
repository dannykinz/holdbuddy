import 'study_mode.dart';

class FocusState {
  const FocusState({
    this.mode = StudyMode.study,
    this.silence = true,
    this.allowed = false,
    this.running = false,
  });
  final StudyMode mode;
  final bool silence;
  final bool allowed;
  final bool running;
  bool get active => running && silence && allowed;
  FocusState copyWith({
    StudyMode? mode,
    bool? silence,
    bool? allowed,
    bool? running,
  }) => FocusState(
    mode: mode ?? this.mode,
    silence: silence ?? this.silence,
    allowed: allowed ?? this.allowed,
    running: running ?? this.running,
  );
}
