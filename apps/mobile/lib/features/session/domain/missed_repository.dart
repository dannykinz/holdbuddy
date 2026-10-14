import 'missed_view.dart';

abstract interface class MissedRepository {
  MissedView move();
  MissedView letGo({required bool offline});
}
