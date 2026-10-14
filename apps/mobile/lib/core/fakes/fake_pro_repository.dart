import '../../features/pro/domain/pro_offer.dart';
import '../../features/pro/domain/pro_product.dart';
import '../../features/pro/domain/pro_repository.dart';
import '../../features/pro/domain/pro_state.dart';

/// In-memory UI preview. No store, payment or entitlement verification is used.
class FakeProRepository implements ProRepository {
  ProState _state = const ProState();
  @override
  ProState get state => _state;
  @override
  List<ProOffer> get offers => const [
    ProOffer(product: ProProduct.monthly, amount: 2500),
    ProOffer(product: ProProduct.lifetime, amount: 12000),
  ];
  @override
  void select(ProProduct product) =>
      _state = _state.copyWith(selected: product);
  @override
  void purchase() => _state = _state.copyWith(enabled: true);
  @override
  bool restore() => _state.enabled;
}
