import 'alert_kind.dart';

class StudyAlert {
  const StudyAlert({
    required this.id,
    required this.kind,
    required this.timestamp,
    this.person = '',
    this.peerId = '',
    this.message = '',
    this.earlier = false,
    this.read = false,
  });
  final String id;
  final AlertKind kind;
  final DateTime timestamp;
  final String person;
  final String peerId;
  final String message;
  final bool earlier;
  final bool read;
  StudyAlert copyWith({bool? read}) => StudyAlert(
    id: id,
    kind: kind,
    timestamp: timestamp,
    person: person,
    peerId: peerId,
    message: message,
    earlier: earlier,
    read: read ?? this.read,
  );
}
