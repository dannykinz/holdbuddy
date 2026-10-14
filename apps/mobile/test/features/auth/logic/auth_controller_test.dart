import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:holdbuddy/core/fakes/fake_auth_data.dart';
import 'package:holdbuddy/core/fakes/fake_auth_repository.dart';
import 'package:holdbuddy/features/auth/domain/auth_operation.dart';
import 'package:holdbuddy/features/auth/domain/auth_outcome.dart';
import 'package:holdbuddy/features/auth/domain/auth_repository.dart';
import 'package:holdbuddy/features/auth/domain/auth_request.dart';
import 'package:holdbuddy/features/auth/logic/auth_controller.dart';
import 'package:mocktail/mocktail.dart';

class _Repository extends Mock implements AuthRepository {}

void main() {
  setUpAll(() => registerFallbackValue(const AuthRequest(AuthOperation.retry)));
  test('Invalid input never reaches the repository', () async {
    final repository = _Repository();
    final container = _container(repository);
    expect(
      await container
          .read(AuthController.provider.notifier)
          .submit(const AuthRequest(AuthOperation.signUp)),
      AuthOutcome.invalidInput,
    );
    verifyNever(() => repository.submit(any()));
  });

  test('Requests normalize email and preserve entries on failure', () async {
    final repository = _Repository();
    when(() => repository.submit(any()))
        .thenAnswer((_) async => AuthOutcome.invalidCredentials);
    final container = _container(repository);
    await container
        .read(AuthController.provider.notifier)
        .submit(
          const AuthRequest(
            AuthOperation.signIn,
            email: ' DANNY@EXAMPLE.COM ',
            password: FakeAuthData.password,
          ),
        );
    final state = container.read(AuthController.provider);
    expect(state.email, FakeAuthData.email);
    expect(state.isBusy, isFalse);
    expect(state.outcome, AuthOutcome.invalidCredentials);
    final input =
        verify(() => repository.submit(captureAny())).captured.single
            as AuthRequest;
    expect(input.email, FakeAuthData.email);
  });

  test(
    'Cancellation ignores a late result and blocks duplicate requests',
    () async {
      final pending = Completer<AuthOutcome>();
      final repository = _Repository();
      when(() => repository.submit(any())).thenAnswer((_) => pending.future);
      final container = _container(repository);
      final controller = container.read(AuthController.provider.notifier);
      final result = controller.submit(const AuthRequest(AuthOperation.retry));
      expect(
        await controller.submit(const AuthRequest(AuthOperation.retry)),
        AuthOutcome.cancelled,
      );
      controller.cancel();
      pending.complete(AuthOutcome.signedIn);
      expect(await result, AuthOutcome.cancelled);
      expect(container.read(AuthController.provider).outcome, isNull);
      verify(() => repository.submit(any())).called(1);
    },
  );

  test('Unexpected failures produce a retryable outcome', () async {
    final repository = _Repository();
    when(() => repository.submit(any()))
        .thenThrow(StateError('simulated failure'));
    final container = _container(repository);
    expect(
      await container
          .read(AuthController.provider.notifier)
          .submit(const AuthRequest(AuthOperation.retry)),
      AuthOutcome.unavailable,
    );
    expect(container.read(AuthController.provider).isBusy, isFalse);
  });

  test('Disposal ignores pending results safely', () async {
    final pending = Completer<AuthOutcome>();
    final repository = _Repository();
    when(() => repository.submit(any())).thenAnswer((_) => pending.future);
    final container = ProviderContainer(
      overrides: [authRepositoryProvider.overrideWithValue(repository)],
    );
    final result = container
        .read(AuthController.provider.notifier)
        .submit(const AuthRequest(AuthOperation.retry));
    container.dispose();
    pending.complete(AuthOutcome.signedIn);
    expect(await result, AuthOutcome.cancelled);
  });

  test(
    'Fake password changes remain in memory and permit a later fake sign-in',
    () async {
      final repository = FakeAuthRepository(delay: Duration.zero);
      await repository.submit(
        const AuthRequest(
          AuthOperation.savePassword,
          password: 'NewDemoPassword',
          confirmation: 'NewDemoPassword',
        ),
      );
      expect(
        await repository.submit(
          const AuthRequest(
            AuthOperation.signIn,
            email: FakeAuthData.email,
            password: 'NewDemoPassword',
          ),
        ),
        AuthOutcome.signedIn,
      );
    },
  );
}

ProviderContainer _container(AuthRepository repository) {
  final container = ProviderContainer(
    overrides: [authRepositoryProvider.overrideWithValue(repository)],
  );
  addTearDown(container.dispose);
  return container;
}
