import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_route.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_hero_tile.dart';

class SponsoredPreview extends StatelessWidget {
  const SponsoredPreview({super.key});
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Card.outlined(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ProTokens.cardRadius),
        side: BorderSide(color: AppColors.of(context).line),
      ),
      child: Padding(
        padding: const EdgeInsets.all(ProTokens.offerInset),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: Tokens.space12,
          children: [
            _header(context),
            _body(context),
            Text(
              l.proAdPreview,
              style: ProTokens.caption.copyWith(
                color: AppColors.of(context).muted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    final l = AppLocalizations.of(context);
    final colors = AppColors.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: Tokens.space8,
            vertical: ProTokens.priceGap,
          ),
          decoration: BoxDecoration(
            color: colors.soft,
            borderRadius: BorderRadius.circular(ProTokens.adTagRadius),
          ),
          child: Text(
            l.proSponsored,
            style: ProTokens.adTag.copyWith(color: colors.subtle),
          ),
        ),
        TextButton(
          onPressed: () => context.pushNamed(AppRoute.proPaywall.name),
          child: Text(l.proRemoveAds, style: ProTokens.cadence),
        ),
      ],
    );
  }

  Widget _body(BuildContext context) {
    final colors = AppColors.of(context);
    return Row(
      spacing: Tokens.space12,
      children: [
        SizedBox.square(
          dimension: ProTokens.adImageSize,
          child: HbHeroTile(
            asset: 'assets/icons/pro_sponsored_book.svg',
            color: colors.orange,
            fill: colors.orangeSoft,
            radius: ProTokens.adImageRadius,
          ),
        ),
        Expanded(child: _copy(context)),
        _learnMore(context),
      ],
    );
  }

  Widget _copy(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: ContractTokens.materialCopyGap,
      children: [
        Text(l.proAdTitle, style: ContractTokens.materialTitle),
        Text(
          l.proAdBrand,
          style: ProTokens.caption.copyWith(color: AppColors.of(context).muted),
        ),
      ],
    );
  }

  Widget _learnMore(BuildContext context) => TextButton(
    style: TextButton.styleFrom(
      backgroundColor: AppColors.of(context).soft,
      minimumSize: const Size(ProTokens.adCtaWidth, Tokens.minTouchTarget),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ProTokens.perkTileRadius),
      ),
      textStyle: ProTokens.offerLabel,
      foregroundColor: AppColors.of(context).text,
    ),
    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).proAdDetails)),
    ),
    child: Text(AppLocalizations.of(context).proAdLearnMore),
  );
}
