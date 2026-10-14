import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/settings_pane.dart';

class SettingsNavigation extends Notifier<SettingsPane> {
  static final provider = NotifierProvider<SettingsNavigation, SettingsPane>(
    SettingsNavigation.new,
  );
  @override
  SettingsPane build() => SettingsPane.home;
  void open(SettingsPane pane) => state = pane;
}
