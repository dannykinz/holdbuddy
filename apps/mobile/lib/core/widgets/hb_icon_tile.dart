import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/tokens.dart';
import 'hb_category.dart';

class HbIconTile extends StatelessWidget {
  const HbIconTile({
    super.key,
    required this.asset,
    required this.category,
    this.hero = false,
  });
  final String asset;
  final HbCategory category;
  final bool hero;

  @override
  Widget build(BuildContext context) {
    final colors = category.colors(AppColors.of(context));
    return Container(
      width: hero ? WidgetTokens.heroTileSize : Tokens.iconTileSize,
      height: hero ? WidgetTokens.heroTileSize : Tokens.iconTileSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.soft,
        borderRadius: BorderRadius.circular(
          hero ? WidgetTokens.heroTileRadius : Tokens.radiusIconTile,
        ),
      ),
      child: SvgPicture.asset(
        asset,
        excludeFromSemantics: true,
        colorFilter: ColorFilter.mode(colors.strong, BlendMode.srcIn),
      ),
    );
  }
}
