import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';

class AuthHero extends StatelessWidget {
  const AuthHero({super.key, required this.icon});
  final String icon;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final mode = Theme.of(context).brightness == Brightness.dark ? 'dark_' : '';
    final fill = switch (icon) {
      'mail' => colors.skySoft,
      'offline' => colors.orangeSoft,
      _ => colors.greenSoft,
    };
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: AuthTokens.heroSize,
        height: AuthTokens.heroSize,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: fill,
          borderRadius: BorderRadius.circular(AuthTokens.heroRadius),
        ),
        child: SvgPicture.asset(
          'assets/icons/auth_$mode$icon.svg',
          excludeFromSemantics: true,
        ),
      ),
    );
  }
}
