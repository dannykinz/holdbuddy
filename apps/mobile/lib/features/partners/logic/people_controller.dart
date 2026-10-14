import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/logging/logger.dart';
import '../../plan/logic/plan_controller.dart';
import '../../safety/domain/report_reason.dart';
import '../domain/peer.dart';
import '../domain/people_repository.dart';
import 'people_failure.dart';
import 'selected_peer.dart';

final peopleRepositoryProvider = Provider<PeopleRepository>(
  (ref) => throw StateError('PeopleRepository must be bound.'),
);
final selectedPeerProvider = Provider<Peer>((ref) {
  final id = ref.watch(SelectedPeer.provider);
  return ref
      .watch(PeopleController.provider)
      .firstWhere((peer) => peer.id == id);
});

class PeopleController extends Notifier<List<Peer>> {
  static final provider = NotifierProvider<PeopleController, List<Peer>>(
    PeopleController.new,
  );
  @override
  List<Peer> build() => ref.watch(peopleRepositoryProvider).peers;
  bool save(Peer peer) => _perform(() {
    ref.read(peopleRepositoryProvider).save(peer);
    state = ref.read(peopleRepositoryProvider).peers;
  });
  bool invite(String name, String contact) => _perform(() {
    final repository = ref.read(peopleRepositoryProvider);
    final peer = repository.prepareInvite(
      name,
      contact,
      ref.read(chosenPlanProvider).title,
    );
    repository.save(peer);
    state = repository.peers;
    ref.read(SelectedPeer.provider.notifier).select(peer.id);
  });
  bool accept(Peer peer) {
    if (peer.blocked || peer.expired(DateTime.now())) return false;
    return save(peer.copyWith(request: false, iHold: true, declined: false));
  }

  bool decline(Peer peer) =>
      save(peer.copyWith(request: false, pending: false, declined: true));
  bool remind(Peer peer) {
    if (!peer.pending ||
        peer.reminded ||
        peer.blocked ||
        peer.expired(DateTime.now()))
      return false;
    return save(peer.copyWith(reminded: true));
  }

  bool nudge(Peer peer) {
    if (!peer.iHold || peer.blocked) return false;
    return _perform(
      () => ref.read(peopleRepositoryProvider).queueNudge(peer.id),
    );
  }

  bool block(Peer peer) => _perform(() {
    if (!save(
      peer.copyWith(
        blocked: true,
        holdsMe: false,
        iHold: false,
        pending: false,
        request: false,
        blockedAt: DateTime.now(),
      ),
    )) {
      throw StateError('Could not update partnership.');
    }
    _removePlanWitness(peer.id);
  });
  bool removeWitness(Peer peer) => _perform(() {
    if (!save(peer.copyWith(holdsMe: false, pending: false))) {
      throw StateError('Could not remove witness.');
    }
    _removePlanWitness(peer.id);
  });
  bool report(
    Peer peer,
    ReportReason reason, {
    required bool includeMessage,
    required bool alsoBlock,
  }) => _perform(() {
    ref
        .read(peopleRepositoryProvider)
        .report(peer.id, reason, includeMessage: includeMessage);
    if (alsoBlock && !block(peer)) throw StateError('Could not block partner.');
  });
  void _removePlanWitness(String id) {
    final repository = ref.read(planPathRepositoryProvider);
    for (final plan in repository.plans) {
      repository.replace(
        plan.copyWith(
          witnessIds: plan.witnessIds
              .where((witness) => witness != id && witness != 'witness-$id')
              .toList(),
        ),
      );
    }
    ref.invalidate(planChoicesProvider);
  }

  bool _perform(void Function() action) {
    try {
      action();
      ref.read(PeopleFailure.provider.notifier).set(false);
      return true;
    } catch (error, stack) {
      logError(error, stack);
      ref.read(PeopleFailure.provider.notifier).set(true);
      return false;
    }
  }
}
