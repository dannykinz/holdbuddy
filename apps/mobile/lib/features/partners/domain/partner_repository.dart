import 'partner.dart';

abstract interface class PartnerRepository {
  Future<List<Partner>> fetchPartners();
}
