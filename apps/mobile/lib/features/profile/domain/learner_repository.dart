import 'learner.dart';

abstract interface class LearnerRepository {
  Future<Learner> fetchLearner();
  Future<void> save(Learner learner);
  Future<void> previewDeletion();
}
