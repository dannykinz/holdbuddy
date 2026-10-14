import 'study_alert.dart';

abstract interface class AlertRepository {
  List<StudyAlert> get alerts;
  void markRead(String id);
}
