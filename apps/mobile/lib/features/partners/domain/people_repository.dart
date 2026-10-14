import '../../safety/domain/report_reason.dart';
import 'peer.dart';
import 'peer_session.dart';

abstract interface class PeopleRepository {
  List<Peer> get peers;
  List<PeerSession> sessions(String peerId);
  Peer prepareInvite(String name, String contact, String sharedPlanName);
  void save(Peer peer);
  void queueNudge(String peerId);
  void report(
    String peerId,
    ReportReason reason, {
    required bool includeMessage,
  });
}
