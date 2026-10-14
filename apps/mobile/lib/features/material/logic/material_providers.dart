import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/linked_material.dart';
import '../domain/material_kind.dart';
import '../domain/material_repository.dart';

final materialRepositoryProvider = Provider<MaterialRepository>(
  (ref) => throw StateError('MaterialRepository must be bound at bootstrap.'),
);

final materialPreviewProvider = Provider.family<LinkedMaterial, MaterialKind>(
  (ref, kind) => ref.watch(materialRepositoryProvider).preview(kind),
);
