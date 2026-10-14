import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/logging/logger.dart';
import '../domain/auth_outcome.dart';
import '../domain/auth_repository.dart';
import '../domain/auth_request.dart';
import 'auth_state.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => throw StateError('AuthRepository must be bound at bootstrap.'),
);

class AuthController extends Notifier<AuthState> {
  AuthController({this.initialState = const AuthState()});
  final AuthState initialState;
  static final provider = NotifierProvider<AuthController, AuthState>(
    AuthController.new,
  );
  int _generation = 0;

  @override
  AuthState build() {
    ref.onDispose(() => _generation++);
    return initialState;
  }

  Future<AuthOutcome> submit(AuthRequest request) async {
    if (state.isBusy) return AuthOutcome.cancelled;
    if (!request.isValid) return _finish(AuthOutcome.invalidInput);
    final generation = ++_generation;
    final input = request.sanitized();
    state = state.copyWith(
      isBusy: true,
      email: input.email.isEmpty ? state.email : input.email,
      isAdult: state.isAdult || input.isAdult,
    );
    final outcome = await _send(input);
    if (generation != _generation) return AuthOutcome.cancelled;
    return _finish(outcome);
  }

  AuthOutcome _finish(AuthOutcome outcome) {
    if (const [
      AuthOutcome.invalidCredentials,
      AuthOutcome.expired,
      AuthOutcome.offline,
      AuthOutcome.invalidInput,
    ].contains(outcome))
      logError(
        StateError('Account result: ${outcome.name}'),
        StackTrace.current,
      );
    state = outcome == AuthOutcome.signedOut
        ? const AuthState()
        : state.copyWith(isBusy: false, outcome: outcome);
    return outcome;
  }

  Future<AuthOutcome> _send(AuthRequest request) async {
    try {
      return await ref.read(authRepositoryProvider).submit(request);
    } catch (_, stack) {
      // Repository exceptions can contain credentials, so log a safe category.
      logError(StateError('Account request failed'), stack);
      return AuthOutcome.unavailable;
    }
  }

  void cancel() {
    _generation++;
    state = state.copyWith(isBusy: false);
  }

  void confirmAge(bool value) => state = state.copyWith(isAdult: value);
}
