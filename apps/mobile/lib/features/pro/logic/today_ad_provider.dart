import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../focus/logic/focus_controller.dart';
import '../../session/logic/session_controller.dart';
import 'pro_controller.dart';

final todayAdProvider = Provider<bool>((ref) {
  final pro = ref.watch(ProController.provider).enabled;
  final focus = ref.watch(FocusController.provider).active;
  ref.watch(SessionController.provider.select((session) => session.stage));
  final activeSession = ref.read(SessionController.provider.notifier).isActive;
  return !pro && !focus && !activeSession;
});
