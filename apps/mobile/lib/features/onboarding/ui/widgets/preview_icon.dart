import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../app/theme/tokens.dart';

class PreviewIcon extends StatelessWidget {
  const PreviewIcon({
    super.key,
    required this.asset,
    required this.color,
    this.size = const Size.square(OnboardingTokens.previewIconSize),
  });
  final String asset;
  final Color color;
  final Size size;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: size.width,
    height: size.height,
    child: FittedBox(
      child: SvgPicture.asset(
        asset,
        excludeFromSemantics: true,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    ),
  );
}
