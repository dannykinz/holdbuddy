import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app/theme/tokens.dart';

class HbHeroTile extends StatelessWidget {
  const HbHeroTile({
    super.key,
    required this.asset,
    required this.color,
    required this.fill,
    this.size = DailyTokens.heroSize,
    this.radius = DailyTokens.heroRadius,
  });
  final String asset;
  final Color color;
  final Color fill;
  final double size;
  final double radius;

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.centerLeft,
    child: Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: SvgPicture.asset(
        asset,
        excludeFromSemantics: true,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    ),
  );
}
