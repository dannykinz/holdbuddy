import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/tokens.dart';
import 'hb_avatar.dart';

class HbPersonRow extends StatelessWidget {
  const HbPersonRow({
    super.key,
    required this.name,
    required this.subtitle,
    required this.avatar,
    this.onPressed,
    this.trailing,
  });
  final String name;
  final String subtitle;
  final String avatar;
  final VoidCallback? onPressed;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onPressed,
    borderRadius: BorderRadius.circular(Tokens.radiusCard),
    child: Padding(
      padding: const EdgeInsets.all(Tokens.space16),
      child: Row(
        spacing: Tokens.space12,
        children: [
          HbAvatar(image: AssetImage(avatar), label: name),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: DailyTokens.copyGap,
              children: [
                Text(name, style: Tokens.strong),
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
  );
}
