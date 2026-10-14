import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../today/domain/today_view.dart';
import '../../today/logic/today_controller.dart';
import '../domain/missed_repository.dart';
import '../domain/missed_view.dart';

final missedRepositoryProvider = Provider<MissedRepository>(
  (ref) => throw StateError('MissedRepository must be bound at bootstrap.'),
);

class MissedController extends Notifier<MissedView> {
  static final provider = NotifierProvider<MissedController, MissedView>(
    MissedController.new,
  );
  @override
  MissedView build() => MissedView.choices;
  void choose() => state = MissedView.choices;
  void confirm() => state = MissedView.confirmation;
  void move() => state = ref.read(missedRepositoryProvider).move();
  void letGo() => state = ref
      .read(missedRepositoryProvider)
      .letGo(offline: ref.read(TodayController.provider) == TodayView.offline);
}
