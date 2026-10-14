class StudyContract {
  StudyContract({
    required this.planId,
    required List<int> days,
    required this.time,
    required this.duration,
    required this.unitsPerSession,
    required this.consequenceMessage,
    required this.committedAt,
  }) : days = List.unmodifiable(days);

  final String planId;
  final List<int> days;
  final Duration time;
  final Duration duration;
  final int unitsPerSession;
  final String consequenceMessage;
  final DateTime committedAt;

  StudyContract copyWith({
    String? planId,
    List<int>? days,
    Duration? time,
    Duration? duration,
    int? unitsPerSession,
    String? consequenceMessage,
    DateTime? committedAt,
  }) => StudyContract(
    planId: planId ?? this.planId,
    days: days ?? this.days,
    time: time ?? this.time,
    duration: duration ?? this.duration,
    unitsPerSession: unitsPerSession ?? this.unitsPerSession,
    consequenceMessage: consequenceMessage ?? this.consequenceMessage,
    committedAt: committedAt ?? this.committedAt,
  );
}
