import '../../features/focus/domain/focus_repository.dart';
import '../../features/focus/domain/focus_state.dart';

/// UI preview only. Android permissions and Do Not Disturb are never changed.
class FakeFocusRepository implements FocusRepository {
  FocusState _preferences = const FocusState();
  @override
  FocusState get preferences => _preferences;
  @override
  void save(FocusState state) => _preferences = state;
  @override
  FocusState requestAccess() =>
      _preferences = _preferences.copyWith(allowed: true);
}
