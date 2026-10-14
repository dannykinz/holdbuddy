import '../l10n/generated/app_localizations.dart';

enum HbTab {
  today('home'),
  plan('plan'),
  notes('note'),
  settings('settings');

  const HbTab(this.iconName);

  final String iconName;

  String label(AppLocalizations l10n) => switch (this) {
    today => l10n.tabToday,
    plan => l10n.tabPlan,
    notes => l10n.tabNotes,
    settings => l10n.tabSettings,
  };

  String iconAsset({required bool selected}) =>
      'assets/icons/${iconName}_${selected ? 'active' : 'inactive'}.svg';
}
