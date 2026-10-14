import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import 'preview_session_card.dart';
import 'preview_today_header.dart';
import 'preview_week.dart';

class TodayIllustration extends StatelessWidget {
  const TodayIllustration({super.key});

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: IgnorePointer(
      child: AspectRatio(
        aspectRatio:
            OnboardingTokens.canvasWidth / OnboardingTokens.previewHeight,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(OnboardingTokens.previewRadius),
          child: ColoredBox(
            color: AppColors.of(context).tint,
            child: FittedBox(
              child: SizedBox(
                width: OnboardingTokens.canvasWidth,
                height: OnboardingTokens.previewHeight,
                child: MediaQuery.withNoTextScaling(
                  child: Stack(children: [_glow(context), _phone(context)]),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );

  Widget _glow(BuildContext context) => Positioned(
    left: OnboardingTokens.heroGlowPosition.dx,
    top: OnboardingTokens.heroGlowPosition.dy,
    child: ClipRect(
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(
          sigmaX: OnboardingTokens.heroGlowBlur,
          sigmaY: OnboardingTokens.heroGlowBlur,
        ),
        child: SvgPicture.asset(
          Theme.of(context).brightness == Brightness.dark
              ? 'assets/icons/onboarding_dark_hero_glow.svg'
              : 'assets/icons/onboarding_hero_glow.svg',
        ),
      ),
    ),
  );

  Widget _phone(BuildContext context) => Positioned(
    left: OnboardingTokens.phonePosition.dx,
    top: OnboardingTokens.phonePosition.dy,
    width: OnboardingTokens.phoneSize.width,
    height: OnboardingTokens.phoneSize.height,
    child: Container(
      decoration: BoxDecoration(
        color: AppColors.of(context).bg,
        borderRadius: BorderRadius.circular(OnboardingTokens.phoneRadius),
      ),
      clipBehavior: Clip.antiAlias,
      child: FittedBox(
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: OnboardingTokens.phoneSize.width / OnboardingTokens.phoneScale,
          height:
              OnboardingTokens.phoneSize.height / OnboardingTokens.phoneScale,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Tokens.screenMargin,
              vertical: Tokens.space20,
            ),
            child: _contents(),
          ),
        ),
      ),
    ),
  );

  Widget _contents() => const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      PreviewTodayHeader(),
      SizedBox(height: Tokens.space24),
      PreviewWeek(),
      SizedBox(height: Tokens.navItemRadius),
      PreviewSessionCard(),
    ],
  );
}
