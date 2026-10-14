import 'package:flutter/material.dart';

import '../../../../app/theme/tokens.dart';
import 'illustration_stage.dart';
import 'preview_progress_card.dart';
import 'preview_session_card.dart';

class ContractIllustration extends StatelessWidget {
  const ContractIllustration({super.key});

  @override
  Widget build(BuildContext context) => const IllustrationStage(
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        _ScaledCard(
          position: OnboardingTokens.progressPosition,
          bounds: OnboardingTokens.progressBounds,
          width: OnboardingTokens.progressWidth,
          scale: OnboardingTokens.contractProgressScale,
          angle: OnboardingTokens.progressAngle,
          child: PreviewProgressCard(),
        ),
        _ScaledCard(
          position: OnboardingTokens.sessionPosition,
          bounds: OnboardingTokens.sessionBounds,
          width: OnboardingTokens.sessionWidth,
          scale: OnboardingTokens.contractSessionScale,
          angle: OnboardingTokens.sessionAngle,
          child: PreviewSessionCard(),
        ),
      ],
    ),
  );
}

class _ScaledCard extends StatelessWidget {
  const _ScaledCard({
    required this.position,
    required this.bounds,
    required this.width,
    required this.scale,
    required this.angle,
    required this.child,
  });
  final Offset position;
  final Size bounds;
  final double width;
  final double scale;
  final double angle;
  final Widget child;

  @override
  Widget build(BuildContext context) => Positioned(
    left: position.dx,
    top: position.dy,
    width: bounds.width,
    height: bounds.height,
    child: Center(
      child: Transform.rotate(
        angle: angle,
        child: SizedBox(
          width: width,
          child: FittedBox(
            child: SizedBox(width: width / scale, child: child),
          ),
        ),
      ),
    ),
  );
}
