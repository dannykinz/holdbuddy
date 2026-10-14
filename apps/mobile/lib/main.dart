import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/holdbuddy.dart';
import 'core/fakes/fake_repository_overrides.dart';

void main() {
  runApp(
    ProviderScope(
      overrides: fakeRepositoryOverrides(),
      child: const Holdbuddy(),
    ),
  );
}
