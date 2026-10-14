import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../logic/session_controller.dart';
import '../../logic/session_receipt_providers.dart';

class SessionUnits extends ConsumerWidget {
  const SessionUnits({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(
      SessionController.provider.select((state) => state.units),
    );
    final controller = ref.read(SessionController.provider.notifier);
    final plan = ref.watch(sessionPlanProvider);
    final remaining = plan == null ? count : plan.totalUnits - plan.unitsDone;
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: WidgetTokens.fieldLabelGap,
      children: [
        Text(
          l10n.sessionChaptersCovered,
          style: Tokens.label.copyWith(color: AppColors.of(context).muted),
        ),
        Container(
          constraints: const BoxConstraints(minHeight: Tokens.buttonHeight),
          decoration: BoxDecoration(
            color: AppColors.of(context).soft,
            borderRadius: BorderRadius.circular(Tokens.radiusCard),
          ),
          child: Row(
            children: [
              IconButton(
                tooltip: l10n.sessionFewerChapters,
                onPressed: count > 0
                    ? () => controller.setUnits(count - 1)
                    : null,
                icon: const Icon(Icons.remove),
              ),
              Expanded(
                child: Text(
                  count.toString(),
                  textAlign: TextAlign.center,
                  style: Tokens.title,
                ),
              ),
              IconButton(
                tooltip: l10n.sessionMoreChapters,
                onPressed: count < remaining
                    ? () => controller.setUnits(count + 1)
                    : null,
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
