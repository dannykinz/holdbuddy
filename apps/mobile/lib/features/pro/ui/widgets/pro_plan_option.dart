import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_category.dart';
import '../../../../core/widgets/hb_chip.dart';
import '../../domain/pro_offer.dart';
import '../../domain/pro_product.dart';
import '../../logic/pro_controller.dart';
import '../pro_copy.dart';

class ProPlanOption extends ConsumerWidget {
  const ProPlanOption({super.key, required this.offer});
  final ProOffer offer;
  bool get _lifetime => offer.product == ProProduct.lifetime;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected =
        ref.watch(ProController.provider).selected == offer.product;
    final colors = AppColors.of(context);
    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: selected ? colors.surface : colors.soft,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ProTokens.offerRadius),
          side: BorderSide(
            color: selected ? colors.accent : colors.soft,
            width: ProTokens.offerBorder,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(ProTokens.offerRadius),
          onTap: () =>
              ref.read(ProController.provider.notifier).select(offer.product),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: ProTokens.offerHeight),
            child: Padding(
              padding: const EdgeInsets.all(ProTokens.offerInset),
              child: _copy(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _copy(BuildContext context) {
    final l = AppLocalizations.of(context);
    final colors = AppColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: ProTokens.perkInset,
      children: [
        _label(context),
        _price(context),
        Text(
          _lifetime ? l.proLifetimeTerms : l.proMonthlyTerms,
          style: ProTokens.caption.copyWith(color: colors.muted),
        ),
      ],
    );
  }

  Widget _price(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Wrap(
      spacing: ProTokens.priceGap,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(ProCopy.price(l, offer), style: ProTokens.price),
        Text(
          _lifetime ? l.proLifetimeCadence : l.proMonthlyCadence,
          style: ProTokens.cadence.copyWith(
            color: AppColors.of(context).subtle,
          ),
        ),
      ],
    );
  }

  Widget _label(BuildContext context) {
    final l = AppLocalizations.of(context);
    final colors = AppColors.of(context);
    return Wrap(
      spacing: Tokens.space8,
      runSpacing: ProTokens.perkInset,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          ProCopy.name(l, offer.product),
          style: ProTokens.offerLabel.copyWith(color: colors.muted),
        ),
        if (_lifetime)
          HbChip(
            label: l.proBestValue,
            category: HbCategory.green,
            labelStyle: ProTokens.bestValue,
            padding: const EdgeInsets.symmetric(
              horizontal: ProTokens.bestValueHorizontal,
              vertical: ProTokens.priceGap,
            ),
          ),
      ],
    );
  }
}
