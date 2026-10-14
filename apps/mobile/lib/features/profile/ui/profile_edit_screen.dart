import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/async_view.dart';
import '../domain/learner.dart';
import '../logic/learner_providers.dart';
import 'widgets/profile_form.dart';

class ProfileEditScreen extends ConsumerWidget {
  const ProfileEditScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => AsyncView<Learner>(
    value: ref.watch(learnerProvider),
    onRetry: () => ref.invalidate(learnerProvider),
    builder: (context, learner) => ProfileForm(learner: learner),
  );
}
