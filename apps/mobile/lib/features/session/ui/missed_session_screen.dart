import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/missed_view.dart';
import '../logic/missed_controller.dart';
import 'widgets/missed_choices.dart';
import 'widgets/missed_confirmation.dart';
import 'widgets/missed_result.dart';

class MissedSessionScreen extends ConsumerWidget {
  const MissedSessionScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      switch (ref.watch(MissedController.provider)) {
        MissedView.choices => const MissedChoices(),
        MissedView.confirmation => const MissedConfirmation(),
        final view => MissedResult(view: view),
      };
}
