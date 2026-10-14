import '../../features/profile/domain/learner.dart';
import '../../features/profile/domain/learner_repository.dart';

/// In-memory profile preview. No camera, account deletion or network access.
class FakeLearnerRepository implements LearnerRepository {
  FakeLearnerRepository(this._learner);
  Learner _learner;
  bool deletionPreviewConfirmed = false;
  @override
  Future<Learner> fetchLearner() async => _learner;
  @override
  Future<void> save(Learner learner) async => _learner = learner;
  @override
  Future<void> previewDeletion() async => deletionPreviewConfirmed = true;
}
