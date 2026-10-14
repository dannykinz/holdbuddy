import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/learner.dart';
import '../domain/learner_repository.dart';

final learnerRepositoryProvider = Provider<LearnerRepository>(
  (ref) => throw StateError('LearnerRepository must be bound at bootstrap.'),
);

final learnerProvider = FutureProvider<Learner>(
  (ref) => ref.watch(learnerRepositoryProvider).fetchLearner(),
);
