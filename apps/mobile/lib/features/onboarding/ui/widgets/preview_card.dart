import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';

class PreviewCard extends StatelessWidget {
  const PreviewCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(Tokens.space20),
    this.radius = Tokens.radiusCard,
  });
  final Widget child;
  final EdgeInsets padding;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border.all(color: colors.line),
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: colors.floatingShadow.withValues(
              alpha: OnboardingTokens.illustrationShadowOpacity,
            ),
            offset: OnboardingTokens.illustrationShadowOffset,
            blurRadius: OnboardingTokens.illustrationShadowBlur,
            spreadRadius: OnboardingTokens.illustrationShadowSpread,
          ),
        ],
      ),
      child: child,
    );
  }
}
