import '../../features/session/domain/missed_repository.dart';
import '../../features/session/domain/missed_view.dart';

/// Preview outcomes only. No message is delivered or persisted to an outbox.
class FakeMissedRepository implements MissedRepository {
  @override
  MissedView move() => MissedView.moved;
  @override
  MissedView letGo({required bool offline}) =>
      offline ? MissedView.queued : MissedView.sent;
}
