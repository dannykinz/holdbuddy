import 'pro_product.dart';

class ProState {
  const ProState({
    this.selected = ProProduct.lifetime,
    this.enabled = false,
    this.failed = false,
  });
  final ProProduct selected;
  final bool enabled;
  final bool failed;
  ProState copyWith({ProProduct? selected, bool? enabled, bool? failed}) =>
      ProState(
        selected: selected ?? this.selected,
        enabled: enabled ?? this.enabled,
        failed: failed ?? this.failed,
      );
}
