import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/fakes/fake_onboarding_data.dart';
import 'illustration_stage.dart';
import 'preview_card.dart';

class WitnessIllustration extends StatelessWidget {
  const WitnessIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return IllustrationStage(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          for (
            var index = 0;
            index < OnboardingTokens.portraitSlots.length;
            index++
          )
            _portrait(index, dark),
          _badge(AppColors.of(context)),
          _nudge(AppColors.of(context)),
        ],
      ),
    );
  }

  Widget _portrait(int index, bool dark) {
    final slot = OnboardingTokens.portraitSlots[index];
    return Positioned.fromRect(
      rect: slot,
      // The Figma exports already include each friend's 45% opacity.
      child: Image.asset(
        'assets/avatars/onboarding_${dark ? 'dark_' : ''}face_$index.png',
      ),
    );
  }

  Widget _badge(AppColors colors) => Positioned(
    left: OnboardingTokens.badgePosition.dx,
    top: OnboardingTokens.badgePosition.dy,
    child: Container(
      width: OnboardingTokens.badgeSize,
      height: OnboardingTokens.badgeSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.accent,
        shape: BoxShape.circle,
        border: Border.all(
          color: colors.surface,
          width: OnboardingTokens.badgeBorder,
        ),
      ),
      child: SvgPicture.asset(
        'assets/icons/witness_check.svg',
        colorFilter: ColorFilter.mode(colors.onPrimary, BlendMode.srcIn),
      ),
    ),
  );

  Widget _nudge(AppColors colors) => Positioned(
    left: OnboardingTokens.nudgePosition.dx,
    top: OnboardingTokens.nudgePosition.dy,
    width: OnboardingTokens.nudgeBounds.width,
    height: OnboardingTokens.nudgeBounds.height,
    child: Center(
      child: Transform.rotate(
        angle: OnboardingTokens.nudgeAngle,
        child: SizedBox(
          width: OnboardingTokens.nudgeWidth,
          child: PreviewCard(
            padding: const EdgeInsets.fromLTRB(
              OnboardingTokens.nudgeInset,
              OnboardingTokens.nudgeInset,
              OnboardingTokens.nudgeTrailingInset,
              OnboardingTokens.nudgeInset,
            ),
            child: _nudgeContent(colors),
          ),
        ),
      ),
    ),
  );

  Widget _nudgeContent(AppColors colors) => Row(
    spacing: Tokens.space12,
    children: [
      Image.asset(
        'assets/avatars/onboarding_face_5.png',
        width: OnboardingTokens.nudgeAvatar,
        height: OnboardingTokens.nudgeAvatar,
      ),
      Expanded(child: _message(colors)),
    ],
  );

  Widget _message(AppColors colors) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: Tokens.navGap,
    children: [
      Text(
        FakeOnboardingData.witnessName,
        style: OnboardingTokens.nudgeName.copyWith(color: colors.subtle),
      ),
      Text(
        FakeOnboardingData.witnessMessage,
        style: OnboardingTokens.nudgeMessage.copyWith(color: colors.text),
      ),
    ],
  );
}
