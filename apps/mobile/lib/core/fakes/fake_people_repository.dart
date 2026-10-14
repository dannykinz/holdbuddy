import '../../features/partners/domain/peer.dart';
import '../../features/partners/domain/peer_session.dart';
import '../../features/partners/domain/people_repository.dart';
import '../../features/safety/domain/report_reason.dart';

/// In-memory partner fixtures. No invitations, reports or nudges are delivered.
class FakePeopleRepository implements PeopleRepository {
  List<Peer> _peers = [
    const Peer(
      id: 'elvis',
      name: 'Elvis',
      contact: 'elvis@example.com',
      avatar: 'assets/avatars/people_elvis.png',
      planName: 'Learning Python',
      message: 'Danny, I skipped. Ask me about Friday.',
      lastMessage: 'Wake up. You said you’d study. Again you lied.',
      holdsMe: true,
      sharedPlanName: 'Learning Dart',
      iHold: true,
      sessionMissed: true,
    ),
    const Peer(
      id: 'mum',
      name: 'Mum',
      contact: 'mum@example.com',
      avatar: 'assets/avatars/people_mum.png',
      planName: '',
      holdsMe: true,
      sharedPlanName: 'Learning Dart',
    ),
    const Peer(
      id: 'amaka',
      name: 'Amaka',
      contact: 'amaka@example.com',
      avatar: 'assets/avatars/people_amaka.png',
      planName: 'Data analysis',
      iHold: true,
      sessionHappened: true,
    ),
    Peer(
      id: 'zainab',
      name: 'Zainab',
      contact: 'zainab@example.com',
      avatar: 'assets/avatars/people_zainab.png',
      planName: 'Biology revision',
      request: true,
      expiresAt: DateTime.now().add(const Duration(days: 10)),
    ),
  ];
  @override
  List<PeerSession> sessions(String peerId) => [
    for (var day = 17; day <= 23; day++)
      PeerSession(
        date: DateTime(2026, 11, day),
        happened: day < 19,
        missed: peerId == 'elvis' && day == 19,
      ),
  ];
  @override
  Peer prepareInvite(String name, String contact, String sharedPlanName) {
    final known = _peers.where((peer) => peer.contact == contact).firstOrNull;
    return Peer(
      id: 'preview-invite-' + _peers.length.toString(),
      name: name,
      contact: contact,
      avatar: known?.avatar ?? 'assets/avatars/people_you.png',
      planName: '',
      sharedPlanName: sharedPlanName,
      pending: true,
      expiresAt: DateTime.now().add(const Duration(days: 10)),
    );
  }

  final Set<String> queuedNudges = {};
  final List<({String peerId, ReportReason reason, String? message})> reports =
      [];
  @override
  List<Peer> get peers => List.unmodifiable(_peers);
  @override
  void save(Peer peer) {
    if (!_peers.any((existing) => existing.id == peer.id)) {
      _peers = [..._peers, peer];
      return;
    }
    _peers = [
      for (final existing in _peers) existing.id == peer.id ? peer : existing,
    ];
  }

  @override
  void queueNudge(String peerId) => queuedNudges.add(peerId);
  @override
  void report(
    String peerId,
    ReportReason reason, {
    required bool includeMessage,
  }) {
    final peer = _peers.firstWhere((peer) => peer.id == peerId);
    reports.add((
      peerId: peerId,
      reason: reason,
      message: includeMessage ? peer.lastMessage : null,
    ));
  }
}
