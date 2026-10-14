import 'material_kind.dart';

class LinkedMaterial {
  const LinkedMaterial({
    required this.name,
    required this.kind,
    required this.extent,
    this.sourcePath = '',
    this.id = '',
    this.planId = '',
    this.position = 0,
    this.sizeMb = 0,
    this.chapter = 1,
    this.lesson = 1,
  });
  final String name;
  final MaterialKind kind;
  final int extent;
  final String sourcePath;
  final String id;
  final String planId;
  final int position;
  final double sizeMb;
  final int chapter;
  final int lesson;
  String get title => name.replaceFirst(RegExp(r'\.[a-zA-Z0-9]+$'), '');
  int get limit => kind == MaterialKind.audio ? extent * 60 : extent;
  LinkedMaterial copyWith({
    String? id,
    String? planId,
    int? position,
    int? chapter,
  }) => LinkedMaterial(
    name: name,
    kind: kind,
    extent: extent,
    sourcePath: sourcePath,
    id: id ?? this.id,
    planId: planId ?? this.planId,
    position: position ?? this.position,
    sizeMb: sizeMb,
    chapter: chapter ?? this.chapter,
    lesson: lesson,
  );
}
