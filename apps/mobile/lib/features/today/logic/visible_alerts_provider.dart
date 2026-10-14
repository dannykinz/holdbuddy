import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../partners/logic/people_controller.dart';
import '../domain/alert_kind.dart';
import '../domain/study_alert.dart';
import 'alert_controller.dart';

final visibleAlertsProvider = Provider<List<StudyAlert>>((ref) {
  final peers = ref.watch(PeopleController.provider);
  return ref.watch(AlertController.provider).where((alert) {
    if (alert.peerId.isEmpty) return true;
    final peer = peers.where((peer) => peer.id == alert.peerId).firstOrNull;
    if (peer == null || peer.blocked) return false;
    return switch (alert.kind) {
      AlertKind.request => peer.request && !peer.expired(DateTime.now()),
      AlertKind.partnerSkipped => peer.iHold,
      AlertKind.witnessActive => peer.holdsMe,
      _ => true,
    };
  }).toList();
});
