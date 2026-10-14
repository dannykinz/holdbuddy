import 'package:flutter_test/flutter_test.dart';
import 'package:holdbuddy/core/fakes/fake_auth_data.dart';
import 'package:holdbuddy/features/auth/domain/auth_operation.dart';
import 'package:holdbuddy/features/auth/domain/auth_request.dart';
import 'package:holdbuddy/features/auth/domain/auth_validation.dart';

void main() {
  test(
    'Account boundaries normalize names and email without changing passwords',
    () {
      final request = const AuthRequest(
        AuthOperation.signUp,
        name: '  Danny   Kinz ',
        email: ' Danny@Example.com ',
        password: '  long password  ',
        isAdult: true,
      ).sanitized();
      expect(request.name, 'Danny Kinz');
      expect(request.email, FakeAuthData.email);
      expect(request.password, '  long password  ');
    },
  );

  test('Names reject empty, controls and oversized input', () {
    for (final name in ['', ' \n ', 'Danny\u0000', 'a' * 81])
      expect(AuthValidation.validName(name), isFalse);
    expect(AuthValidation.validName('Danny Kinz'), isTrue);
  });

  test('Email rejects incomplete addresses and whitespace', () {
    for (final email in [
      'danny@',
      'danny@example',
      'danny @example.com',
      '@example.com',
      'danny@example..com',
      'a' * 255,
    ])
      expect(AuthValidation.validEmail(email), isFalse);
    expect(AuthValidation.validEmail(' DANNY@example.com '), isTrue);
  });

  test('Passwords and codes enforce their boundaries', () {
    expect(AuthValidation.validPassword('a' * 11), isFalse);
    expect(AuthValidation.validPassword('a' * 12), isTrue);
    expect(AuthValidation.validPassword('a' * 129), isFalse);
    expect(AuthValidation.validCode(FakeAuthData.code), isTrue);
    for (final code in ['48216', '4821690', 'abcdef', '48 169'])
      expect(AuthValidation.validCode(code), isFalse);
  });

  test('Sign up and Google cannot submit without 18+ confirmation', () {
    expect(
      const AuthRequest(
        AuthOperation.signUp,
        name: FakeAuthData.name,
        email: FakeAuthData.email,
        password: FakeAuthData.password,
      ).isValid,
      isFalse,
    );
    expect(const AuthRequest(AuthOperation.google).isValid, isFalse);
    expect(
      const AuthRequest(AuthOperation.google, isAdult: true).isValid,
      isTrue,
    );
  });

  test('Reset requires matching passwords', () {
    expect(
      const AuthRequest(
        AuthOperation.savePassword,
        password: FakeAuthData.password,
        confirmation: 'different',
      ).isValid,
      isFalse,
    );
  });
}
