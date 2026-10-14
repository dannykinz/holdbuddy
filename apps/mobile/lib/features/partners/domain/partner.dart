import 'partnership_status.dart';

class Partner {
  const Partner({
    required this.id,
    required this.learnerId,
    required this.witnessUserId,
    required this.witnessName,
    required this.status,
  });

  final String id;
  final String learnerId;
  final String witnessUserId;
  final String witnessName;
  final PartnershipStatus status;

  Partner copyWith({
    String? id,
    String? learnerId,
    String? witnessUserId,
    String? witnessName,
    PartnershipStatus? status,
  }) => Partner(
    id: id ?? this.id,
    learnerId: learnerId ?? this.learnerId,
    witnessUserId: witnessUserId ?? this.witnessUserId,
    witnessName: witnessName ?? this.witnessName,
    status: status ?? this.status,
  );
}
