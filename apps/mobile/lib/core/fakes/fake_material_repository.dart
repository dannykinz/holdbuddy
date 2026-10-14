import '../../features/material/domain/audio_preview.dart';
import '../../features/material/domain/linked_material.dart';
import '../../features/material/domain/material_kind.dart';
import '../../features/material/domain/material_repository.dart';
import '../../features/material/domain/reader_page.dart';
import 'fake_material_data.dart';
import 'fake_seed_data.dart';

/// Returns bundled UI samples. Real file access waits for D6.
class FakeMaterialRepository implements MaterialRepository {
  final _materials = [
    for (final sample in FakeMaterialData.samples.values)
      sample.copyWith(
        id: 'fake-material-' + sample.kind.name,
        planId: FakeSeedData.planId,
      ),
  ];
  int _sequence = 0;
  AudioPreview _audio = const AudioPreview();
  @override
  AudioPreview get audio => _audio;
  @override
  void saveAudio(AudioPreview audio) => _audio = audio;
  @override
  List<LinkedMaterial> get materials => List.unmodifiable(_materials);
  @override
  ReaderPage get samplePage => FakeMaterialData.page;
  @override
  LinkedMaterial preview(MaterialKind kind) =>
      FakeMaterialData.samples[kind] ??
      const LinkedMaterial(
        name: 'Dart language tour.pdf',
        kind: MaterialKind.pdf,
        extent: 48,
      );
  @override
  void save(LinkedMaterial material) {
    final index = _materials.indexWhere((item) => item.id == material.id);
    if (index < 0) throw StateError('Material preview is unavailable.');
    _materials[index] = material;
  }

  @override
  void attachPreview(LinkedMaterial material, String planId) {
    _materials.add(
      material.copyWith(
        id: 'fake-material-added-' + (++_sequence).toString(),
        planId: planId,
        chapter: planId == FakeSeedData.planId ? material.chapter : 1,
      ),
    );
  }
}
