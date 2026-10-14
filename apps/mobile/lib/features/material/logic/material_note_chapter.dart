import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../session/logic/session_controller.dart';
import '../domain/linked_material.dart';

final materialNoteChapterProvider = Provider.family<int, LinkedMaterial>((
  ref,
  material,
) {
  final session = ref.watch(SessionController.provider);
  final active = ref.read(SessionController.provider.notifier).isActive;
  if (active && session.planId == material.planId) return session.chapterNumber;
  return material.chapter;
});
