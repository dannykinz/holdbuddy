import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';

class ProBadge extends StatelessWidget {
  const ProBadge({super.key});
  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: ProTokens.badgeSize,
    child: Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Positioned(
          top: ProTokens.glowOffset,
          left: ProTokens.glowOffset,
          child: _glow(context),
        ),
        Container(
          width: ProTokens.welcomeCrownSize,
          height: ProTokens.welcomeCrownSize,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.of(context).primary,
            borderRadius: BorderRadius.circular(ProTokens.welcomeCrownRadius),
            boxShadow: [
              BoxShadow(
                color: AppColors.of(context).accent
                    .withValues(alpha: ProTokens.shadowOpacity),
                offset: ProTokens.shadowOffset,
                blurRadius: ProTokens.shadowBlur,
              ),
            ],
          ),
          child: SvgPicture.asset(
            'assets/icons/pro_welcome_crown.svg',
            excludeFromSemantics: true,
            colorFilter: ColorFilter.mode(
              AppColors.of(context).onPrimary,
              BlendMode.srcIn,
            ),
          ),
        ),
      ],
    ),
  );
  // The installed SVG compiler ignores Gaussian filters.
  Widget _glow(BuildContext context) => ImageFiltered(
    imageFilter: ImageFilter.blur(
      sigmaX: ProTokens.glowBlur,
      sigmaY: ProTokens.glowBlur,
    ),
    child: SvgPicture.asset(
      'assets/icons/pro_glow.svg',
      excludeFromSemantics: true,
      colorFilter: ColorFilter.mode(
        AppColors.of(context).accent,
        BlendMode.srcIn,
      ),
    ),
  );
}
