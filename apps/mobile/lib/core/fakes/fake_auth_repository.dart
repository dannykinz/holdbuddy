import '../../features/auth/domain/auth_operation.dart';
import '../../features/auth/domain/auth_outcome.dart';
import '../../features/auth/domain/auth_repository.dart';
import '../../features/auth/domain/auth_request.dart';
import 'fake_auth_data.dart';

/// In-memory auth preview. Creates no account, sends no email or network call.
class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({
    this.delay = FakeAuthData.delay,
    this.outcomes = const {},
  });

  final Duration delay;
  final Map<AuthOperation, AuthOutcome> outcomes;
  String _email = FakeAuthData.email;
  String _password = FakeAuthData.password;

  @override
  Future<AuthOutcome> submit(AuthRequest request) async {
    if (!request.isValid) return AuthOutcome.invalidInput;
    await Future<void>.delayed(delay);
    final configured = outcomes[request.operation];
    if (configured != null) return configured;
    if (request.operation == AuthOperation.signUp) {
      _email = request.email;
      _password = request.password;
    }
    if (request.operation == AuthOperation.savePassword)
      _password = request.password;
    return switch (request.operation) {
      AuthOperation.signUp => AuthOutcome.created,
      AuthOperation.signIn =>
        request.email == _email && request.password == _password
            ? AuthOutcome.signedIn
            : AuthOutcome.invalidCredentials,
      AuthOperation.verify =>
        request.code == FakeAuthData.code
            ? AuthOutcome.verified
            : AuthOutcome.expired,
      AuthOperation.resendCode => AuthOutcome.codeSent,
      AuthOperation.sendReset => AuthOutcome.resetSent,
      AuthOperation.savePassword => AuthOutcome.passwordSaved,
      AuthOperation.signOut => AuthOutcome.signedOut,
      AuthOperation.google || AuthOperation.retry => AuthOutcome.signedIn,
    };
  }
}
