import 'focus_state.dart';

abstract interface class FocusRepository {
  FocusState get preferences;
  void save(FocusState state);
  FocusState requestAccess();
}
