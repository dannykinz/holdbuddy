import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../contract/domain/study_contract.dart';

abstract final class ChangeScheduleCopy {
  static String text(BuildContext context, StudyContract contract) {
    final l = AppLocalizations.of(context);
    final days = contract.days
        .map(
          (day) => DateFormat(
            'EEE',
            l.localeName,
          ).format(DateTime(2026, 10, 11 + day)),
        )
        .join(', ');
    final minute = contract.time.inMinutes;
    final time = TimeOfDay(
      hour: minute ~/ 60,
      minute: minute % 60,
    ).format(context);
    return l.changeSchedule(days, time);
  }
}
