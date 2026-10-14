import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../app/theme/tokens.dart';

class IllustrationStage extends StatelessWidget {
  const IllustrationStage({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: IgnorePointer(
      child: AspectRatio(
        aspectRatio:
            OnboardingTokens.canvasWidth / OnboardingTokens.canvasHeight,
        child: FittedBox(
          child: SizedBox(
            width: OnboardingTokens.canvasWidth,
            height: OnboardingTokens.canvasHeight,
            child: MediaQuery.withNoTextScaling(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: OnboardingTokens.glowPosition.dx,
                    top: OnboardingTokens.glowPosition.dy,
                    child: ClipRect(
                      child: ImageFiltered(
                        imageFilter: ImageFilter.blur(
                          sigmaX: OnboardingTokens.glowBlur,
                          sigmaY: OnboardingTokens.glowBlur,
                        ),
                        child: SvgPicture.asset(
                          Theme.of(context).brightness == Brightness.dark
                              ? 'assets/icons/onboarding_dark_glow.svg'
                              : 'assets/icons/onboarding_glow.svg',
                        ),
                      ),
                    ),
                  ),
                  child,
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
