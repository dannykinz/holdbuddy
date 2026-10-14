import '../../features/material/domain/linked_material.dart';
import '../../features/material/domain/material_kind.dart';
import '../../features/material/domain/reader_page.dart';

/// Display-only samples. No file is opened, copied, linked or uploaded.
abstract final class FakeMaterialData {
  static const samples = {
    MaterialKind.pdf: LinkedMaterial(
      name: 'Dart language tour.pdf',
      kind: MaterialKind.pdf,
      extent: 48,
      sourcePath: 'Downloads/Dart language tour.pdf',
      position: 12,
      chapter: 7,
      sizeMb: 6.2,
    ),
    MaterialKind.audio: LinkedMaterial(
      name: 'Async explained.mp3',
      kind: MaterialKind.audio,
      extent: 32,
      position: 1104,
      chapter: 7,
      lesson: 3,
      sizeMb: 11.8,
      sourcePath: 'Downloads/Async explained.mp3',
    ),
    MaterialKind.document: LinkedMaterial(
      name: 'Week 3 notes.docx',
      kind: MaterialKind.document,
      extent: 14,
      sizeMb: 0.4,
      sourcePath: 'Downloads/Week 3 notes.docx',
    ),
    MaterialKind.link: LinkedMaterial(
      name: 'dart.dev/language',
      kind: MaterialKind.link,
      extent: 0,
      sourcePath: 'https://dart.dev/language',
    ),
  };
  static const page = ReaderPage(
    section: 'ASYNCHRONY',
    title: 'Futures',
    body: 'A future represents the result of an operation that finishes later. Code that needs the value waits for it instead of blocking everything else.',
    highlight: 'The await keyword pauses this function, not the whole app.',
    footer: 'Mark a function async to use await inside it. The function then returns a future automatically.',
  );
}
