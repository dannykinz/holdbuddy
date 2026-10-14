import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/tokens.dart';
import '../l10n/generated/app_localizations.dart';

class HbStepBar extends StatelessWidget {
  const HbStepBar({super.key, required this.step})
    : assert(step >= 1 && step <= WidgetTokens.stepCount);
  final int step;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Semantics(
      label: AppLocalizations.of(context)
          .contractStep(step, WidgetTokens.stepCount),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Tokens.space12),
        child: Row(
          spacing: WidgetTokens.stepGap,
          children: [
            for (var index = 0; index < WidgetTokens.stepCount; index++)
              Expanded(
                child: Container(
                  height: WidgetTokens.stepHeight,
                  decoration: BoxDecoration(
                    color: index < step ? colors.accent : colors.line,
                    borderRadius: BorderRadius.circular(
                      WidgetTokens.stepRadius,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
