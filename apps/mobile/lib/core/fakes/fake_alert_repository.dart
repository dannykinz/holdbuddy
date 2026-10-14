import '../../features/today/domain/alert_kind.dart';
import '../../features/today/domain/alert_repository.dart';
import '../../features/today/domain/study_alert.dart';

/// In-memory Figma alerts. No push connection or witness messages.
class FakeAlertRepository implements AlertRepository {
  final _alerts = [
    StudyAlert(
      id: 'skipped',
      kind: AlertKind.partnerSkipped,
      timestamp: DateTime(2026, 10, 21),
      person: 'Elvis',
      peerId: 'elvis',
      message: 'Danny, I skipped. Ask me about Friday.',
    ),
    StudyAlert(
      id: 'request',
      kind: AlertKind.request,
      timestamp: DateTime(2026, 10, 21, 9, 2),
      person: 'Zainab',
      peerId: 'zainab',
      message: 'Biology revision',
    ),
    StudyAlert(
      id: 'due',
      kind: AlertKind.due,
      timestamp: DateTime(2026, 10, 21, 19, 45),
    ),
    StudyAlert(
      id: 'nudge',
      kind: AlertKind.nudge,
      timestamp: DateTime(2026, 10, 21, 14, 10),
      person: 'Elvis',
      peerId: 'elvis',
      message: 'Saw Wednesday. You good for Friday?',
    ),
    StudyAlert(
      id: 'recalculated',
      kind: AlertKind.recalculated,
      timestamp: DateTime(2026, 10, 15),
      earlier: true,
      read: true,
    ),
    StudyAlert(
      id: 'saved',
      kind: AlertKind.saved,
      timestamp: DateTime(2026, 10, 13),
      earlier: true,
      read: true,
    ),
    StudyAlert(
      id: 'opened',
      kind: AlertKind.witnessActive,
      timestamp: DateTime(2026, 10, 12),
      person: 'Elvis',
      peerId: 'elvis',
      earlier: true,
      read: true,
    ),
  ];
  @override
  List<StudyAlert> get alerts => List.unmodifiable(_alerts);
  @override
  void markRead(String id) {
    final index = _alerts.indexWhere((alert) => alert.id == id);
    if (index < 0) return;
    _alerts[index] = _alerts[index].copyWith(read: true);
  }
}
