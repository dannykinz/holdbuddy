class PeerSession {
  const PeerSession({
    required this.date,
    required this.happened,
    this.missed = false,
  });
  final DateTime date;
  final bool happened;
  final bool missed;
}
