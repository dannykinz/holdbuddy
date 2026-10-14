import 'package:flutter/material.dart';

import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../domain/report_reason.dart';

class ReportReasons extends StatelessWidget {
  const ReportReasons({
    super.key,
    required this.reason,
    required this.onChanged,
  });
  final ReportReason reason;
  final ValueChanged<ReportReason> onChanged;
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final choices = [
      (ReportReason.abuse, l.safetyReasonAbuse),
      (ReportReason.nudges, l.safetyReasonNudges),
      (ReportReason.unknown, l.safetyReasonUnknown),
      (ReportReason.other, l.safetyReasonOther),
    ];
    return RadioGroup<ReportReason>(
      groupValue: reason,
      onChanged: (value) {
        if (value != null) onChanged(value);
      },
      child: Card.outlined(
        child: Column(
          children: [
            for (var index = 0; index < choices.length; index++) ...[
              if (index > 0)
                const Divider(
                  indent: Tokens.space16,
                  endIndent: Tokens.space16,
                ),
              RadioListTile<ReportReason>(
                value: choices[index].$1,
                controlAffinity: ListTileControlAffinity.trailing,
                title: Text(choices[index].$2, style: Tokens.body),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
