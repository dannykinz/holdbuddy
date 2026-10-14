class Peer {
  const Peer({
    required this.id,
    required this.name,
    required this.avatar,
    required this.contact,
    required this.planName,
    this.message = '',
    this.sharedPlanName = '',
    this.lastMessage = '',
    this.holdsMe = false,
    this.iHold = false,
    this.pending = false,
    this.request = false,
    this.reminded = false,
    this.muted = false,
    this.blocked = false,
    this.blockedAt,
    this.sessionHappened = false,
    this.sessionMissed = false,
    this.declined = false,
    this.expiresAt,
  });
  final String id;
  final String name;
  final String avatar;
  final String contact;
  final String planName;
  final String message;
  final String sharedPlanName;
  final String lastMessage;
  final bool holdsMe;
  final bool iHold;
  final bool pending;
  final bool request;
  final bool reminded;
  final bool muted;
  final bool blocked;
  final DateTime? blockedAt;
  final bool sessionHappened;
  final bool sessionMissed;
  final bool declined;
  final DateTime? expiresAt;
  bool expired(DateTime now) =>
      expiresAt != null && !now.isBefore(expiresAt ?? now);
  Peer copyWith({
    String? name,
    String? contact,
    bool? holdsMe,
    bool? iHold,
    bool? pending,
    bool? request,
    bool? reminded,
    bool? muted,
    bool? blocked,
    bool? declined,
    DateTime? blockedAt,
  }) => Peer(
    id: id,
    name: name ?? this.name,
    avatar: avatar,
    contact: contact ?? this.contact,
    planName: planName,
    message: message,
    sharedPlanName: sharedPlanName,
    lastMessage: lastMessage,
    holdsMe: holdsMe ?? this.holdsMe,
    iHold: iHold ?? this.iHold,
    pending: pending ?? this.pending,
    request: request ?? this.request,
    reminded: reminded ?? this.reminded,
    muted: muted ?? this.muted,
    blocked: blocked ?? this.blocked,
    blockedAt: blockedAt ?? this.blockedAt,
    sessionHappened: sessionHappened,
    sessionMissed: sessionMissed,
    declined: declined ?? this.declined,
    expiresAt: expiresAt,
  );
}
