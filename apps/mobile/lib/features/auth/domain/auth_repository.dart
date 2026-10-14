import 'auth_outcome.dart';
import 'auth_request.dart';

abstract interface class AuthRepository {
  Future<AuthOutcome> submit(AuthRequest request);
}
