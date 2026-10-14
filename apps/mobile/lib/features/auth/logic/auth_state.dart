import '../domain/auth_outcome.dart';

class AuthState {
  const AuthState({
    this.isBusy = false,
    this.outcome,
    this.email = '',
    this.isAdult = false,
  });

  final bool isBusy;
  final AuthOutcome? outcome;
  final String email;
  final bool isAdult;
  bool get hasFailure =>
      outcome == AuthOutcome.unavailable || outcome == AuthOutcome.invalidInput;

  AuthState copyWith({
    bool? isBusy,
    AuthOutcome? outcome,
    String? email,
    bool? isAdult,
  }) => AuthState(
    isBusy: isBusy ?? this.isBusy,
    outcome: outcome,
    email: email ?? this.email,
    isAdult: isAdult ?? this.isAdult,
  );
}
