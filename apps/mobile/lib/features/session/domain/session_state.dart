import 'session_stage.dart';

class SessionState {
  const SessionState({
    required this.chapterNumber,
    required this.planId,
    required this.chapterName,
    required this.planName,
    required this.remainingSeconds,
    required this.elapsedSeconds,
    required this.note,
    required this.isFirst,
    this.units = 1,
    this.stage = SessionStage.running,
  });
  final int chapterNumber;
  final String planId;
  final String chapterName;
  final String planName;
  final int remainingSeconds;
  final int elapsedSeconds;
  final String note;
  final bool isFirst;
  final int units;
  final SessionStage stage;

  SessionState copyWith({
    int? remainingSeconds,
    int? elapsedSeconds,
    String? note,
    int? units,
    SessionStage? stage,
  }) => SessionState(
    chapterNumber: chapterNumber,
    planId: planId,
    chapterName: chapterName,
    planName: planName,
    remainingSeconds: remainingSeconds ?? this.remainingSeconds,
    elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
    note: note ?? this.note,
    isFirst: isFirst,
    units: units ?? this.units,
    stage: stage ?? this.stage,
  );
}
