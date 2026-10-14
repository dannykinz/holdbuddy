import 'auth_operation.dart';
import 'auth_validation.dart';

class AuthRequest {
  const AuthRequest(
    this.operation, {
    this.name = '',
    this.email = '',
    this.password = '',
    this.confirmation = '',
    this.code = '',
    this.isAdult = false,
  });

  final AuthOperation operation;
  final String name;
  final String email;
  final String password;
  final String confirmation;
  final String code;
  final bool isAdult;

  bool get isValid => switch (operation) {
    AuthOperation.signUp =>
      isAdult &&
          AuthValidation.validName(name) &&
          AuthValidation.validEmail(email) &&
          AuthValidation.validPassword(password),
    AuthOperation.signIn =>
      AuthValidation.validEmail(email) &&
          password.isNotEmpty &&
          password.runes.length <= AuthValidation.maximumPasswordLength,
    AuthOperation.verify => AuthValidation.validCode(code),
    AuthOperation.sendReset => AuthValidation.validEmail(email),
    AuthOperation.savePassword =>
      AuthValidation.validPassword(password) && password == confirmation,
    AuthOperation.google => isAdult,
    _ => true,
  };

  AuthRequest sanitized() => AuthRequest(
    operation,
    name: AuthValidation.name(name),
    email: AuthValidation.email(email),
    password: password,
    confirmation: confirmation,
    code: code,
    isAdult: isAdult,
  );
}
