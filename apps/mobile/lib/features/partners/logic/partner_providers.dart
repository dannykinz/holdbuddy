import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/partner.dart';
import '../domain/partner_repository.dart';

final partnerRepositoryProvider = Provider<PartnerRepository>(
  (ref) => throw StateError('PartnerRepository must be bound at bootstrap.'),
);

final partnersProvider = FutureProvider<List<Partner>>(
  (ref) => ref.watch(partnerRepositoryProvider).fetchPartners(),
);
