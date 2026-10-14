import 'audio_preview.dart';
import 'linked_material.dart';
import 'material_kind.dart';
import 'reader_page.dart';

abstract interface class MaterialRepository {
  LinkedMaterial preview(MaterialKind kind);
  List<LinkedMaterial> get materials;
  ReaderPage get samplePage;
  AudioPreview get audio;
  void saveAudio(AudioPreview audio);
  void save(LinkedMaterial material);
  void attachPreview(LinkedMaterial material, String planId);
}
