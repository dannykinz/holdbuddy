import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/tokens.dart';

class HbActionRow extends StatelessWidget {
  const HbActionRow({
    super.key,
    required this.title,
    required this.subtitle,
    required this.asset,
    required this.color,
    required this.fill,
    this.onPressed,
    this.trailing,
    this.selected = false,
  });
  final String title;
  final String subtitle;
  final String asset;
  final Color color;
  final Color fill;
  final VoidCallback? onPressed;
  final Widget? trailing;
  final bool selected;

  @override
  Widget build(BuildContext context) => Card.outlined(
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Tokens.radiusCard),
      side: BorderSide(
        color: selected
            ? AppColors.of(context).primary
            : AppColors.of(context).line,
      ),
    ),
    child: InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(Tokens.space16),
        child: Row(
          spacing: Tokens.space12,
          children: [
            _icon(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: DailyTokens.copyGap,
                children: [
                  Text(title, style: Tokens.strong),
                  Text(
                    subtitle,
                    style: Tokens.small.copyWith(
                      color: AppColors.of(context).muted,
                    ),
                  ),
                ],
              ),
            ),
            trailing ??
                SvgPicture.asset(
                  'assets/icons/daily_chevron.svg',
                  excludeFromSemantics: true,
                  colorFilter: ColorFilter.mode(
                    AppColors.of(context).subtle,
                    BlendMode.srcIn,
                  ),
                ),
          ],
        ),
      ),
    ),
  );

  Widget _icon() {
    return Container(
      width: DailyTokens.rowTileSize,
      height: DailyTokens.rowTileSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(DailyTokens.rowTileRadius),
      ),
      child: SvgPicture.asset(
        asset,
        excludeFromSemantics: true,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }
}
