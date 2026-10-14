import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/alert_repository.dart';
import '../domain/study_alert.dart';

final alertRepositoryProvider = Provider<AlertRepository>(
  (ref) => throw StateError('AlertRepository must be bound at bootstrap.'),
);

class AlertController extends Notifier<List<StudyAlert>> {
  static final provider = NotifierProvider<AlertController, List<StudyAlert>>(
    AlertController.new,
  );
  @override
  List<StudyAlert> build() => ref.read(alertRepositoryProvider).alerts;
  void read(String id) {
    ref.read(alertRepositoryProvider).markRead(id);
    state = ref.read(alertRepositoryProvider).alerts;
  }

  void readAll() {
    for (final alert in state)
      ref.read(alertRepositoryProvider).markRead(alert.id);
    state = ref.read(alertRepositoryProvider).alerts;
  }
}
