import '../../features/partners/domain/partner.dart';
import '../../features/partners/domain/partner_repository.dart';

/// Read-only in-memory fake for the UI phase, with no persistence or network.
class FakePartnerRepository implements PartnerRepository {
  FakePartnerRepository(List<Partner> partners)
    : _partners = List.unmodifiable(partners);

  final List<Partner> _partners;

  @override
  Future<List<Partner>> fetchPartners() async => _partners;
}
