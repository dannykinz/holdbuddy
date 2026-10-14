import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_category.dart';

class ProPerks extends StatelessWidget {
  const ProPerks({super.key});
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final perks = [
      (
        asset: 'pro_ad',
        category: HbCategory.pink,
        title: l.proNoAds,
        body: l.proNoAdsBody,
      ),
      (
        asset: 'pro_bolt',
        category: HbCategory.sky,
        title: l.proReport,
        body: l.proReportBody,
      ),
      (
        asset: 'pro_shield',
        category: HbCategory.green,
        title: l.proThemes,
        body: l.proThemesBody,
      ),
    ];
    return Card.outlined(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ProTokens.cardRadius),
        side: BorderSide(color: AppColors.of(context).line),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Tokens.space16,
          vertical: ProTokens.perkInset,
        ),
        child: Column(
          children: [
            for (final (index, perk) in perks.indexed) ...[
              _perk(context, perk),
              if (index < perks.length - 1)
                const Divider(height: ProTokens.copyGap),
            ],
          ],
        ),
      ),
    );
  }

  Widget _tile(BuildContext context, String asset, HbCategory category) {
    final colors = category.colors(AppColors.of(context));
    return Container(
      width: ProTokens.perkTileSize,
      height: ProTokens.perkTileSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.soft,
        borderRadius: BorderRadius.circular(ProTokens.perkTileRadius),
      ),
      child: SvgPicture.asset(
        'assets/icons/' + asset + '.svg',
        excludeFromSemantics: true,
        colorFilter: ColorFilter.mode(colors.strong, BlendMode.srcIn),
      ),
    );
  }

  Widget _copy(BuildContext context, String title, String body) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: ProTokens.copyGap,
    children: [
      Text(title, style: ContractTokens.materialTitle),
      Text(
        body,
        style: ProTokens.caption.copyWith(color: AppColors.of(context).muted),
      ),
    ],
  );
  Widget _perk(
    BuildContext context,
    ({String asset, HbCategory category, String title, String body}) perk,
  ) => Padding(
    padding: const EdgeInsets.symmetric(vertical: ProTokens.perkVertical),
    child: Row(
      spacing: Tokens.space12,
      children: [
        _tile(context, perk.asset, perk.category),
        Expanded(child: _copy(context, perk.title, perk.body)),
      ],
    ),
  );
}
