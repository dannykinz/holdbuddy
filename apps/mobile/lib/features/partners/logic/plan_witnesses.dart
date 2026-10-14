import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../plan/logic/plan_controller.dart';
import '../domain/peer.dart';
import 'people_controller.dart';

final planWitnessesProvider = Provider.family<List<Peer>, String>((
  ref,
  planId,
) {
  final plan = ref
      .watch(planChoicesProvider)
      .where((plan) => plan.id == planId)
      .firstOrNull;
  if (plan == null) return const [];
  return ref
      .watch(PeopleController.provider)
      .where(
        (peer) =>
            plan.witnessIds.contains(peer.id) &&
            peer.holdsMe &&
            !peer.pending &&
            !peer.blocked &&
            !peer.declined &&
            !peer.expired(DateTime.now()),
      )
      .toList();
});
