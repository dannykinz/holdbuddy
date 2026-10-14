import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_notice.dart';
import '../../logic/deadline_controller.dart';

class DeadlineFailureNotice extends ConsumerWidget {
  const DeadlineFailureNotice({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(DeadlineController.provider).hasError)
      return const SizedBox.shrink();
    final l = AppLocalizations.of(context);
    return HbNotice(title: l.deadlineSaveFailed, body: l.deadlineTryAgain);
  }
}
