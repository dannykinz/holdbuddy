import '../l10n/generated/app_localizations.dart';

enum HbDayStatus {
  done,
  missed,
  rest,
  today,
  planned;

  String label(AppLocalizations strings) => switch (this) {
    done => strings.dayDone,
    missed => strings.dayMissed,
    rest => strings.dayRest,
    today => strings.dayToday,
    planned => strings.dayPlanned,
  };
}
