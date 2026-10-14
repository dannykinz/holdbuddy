import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/logging/logger.dart';
import '../domain/pro_offer.dart';
import '../domain/pro_product.dart';
import '../domain/pro_repository.dart';
import '../domain/pro_state.dart';

final proRepositoryProvider = Provider<ProRepository>(
  (ref) => throw StateError('ProRepository must be bound at bootstrap.'),
);
final proOffersProvider = Provider<List<ProOffer>>(
  (ref) => ref.watch(proRepositoryProvider).offers,
);

class ProController extends Notifier<ProState> {
  static final provider = NotifierProvider<ProController, ProState>(
    ProController.new,
  );
  @override
  ProState build() => ref.read(proRepositoryProvider).state;
  void select(ProProduct product) =>
      _perform(() => ref.read(proRepositoryProvider).select(product));
  bool purchase() => _perform(() => ref.read(proRepositoryProvider).purchase());
  bool restore() {
    var restored = false;
    _perform(() => restored = ref.read(proRepositoryProvider).restore());
    return restored;
  }

  bool _perform(void Function() action) {
    try {
      action();
      state = ref.read(proRepositoryProvider).state.copyWith(failed: false);
      return true;
    } catch (error, stack) {
      logError(error, stack);
      state = state.copyWith(failed: true);
      return false;
    }
  }
}
