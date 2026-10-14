import 'package:intl/intl.dart';

import '../../../core/l10n/generated/app_localizations.dart';
import '../domain/pro_offer.dart';
import '../domain/pro_product.dart';

abstract final class ProCopy {
  static String price(AppLocalizations l, ProOffer offer) =>
      NumberFormat.currency(
        locale: l.localeName,
        symbol: l.proCurrencySymbol,
        decimalDigits: 0,
      ).format(offer.amount);
  static String name(AppLocalizations l, ProProduct product) =>
      product == ProProduct.lifetime ? l.proLifetime : l.proMonthly;
}
