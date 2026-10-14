import 'pro_offer.dart';
import 'pro_product.dart';
import 'pro_state.dart';

abstract interface class ProRepository {
  ProState get state;
  List<ProOffer> get offers;
  void select(ProProduct product);
  void purchase();
  bool restore();
}
