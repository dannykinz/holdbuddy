import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/tokens.dart';
import '../../../core/l10n/generated/app_localizations.dart';

class FocusPill extends StatelessWidget {
  const FocusPill({super.key});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(
      horizontal: Tokens.space12,
      vertical: Tokens.space8,
    ),
    decoration: ShapeDecoration(
      color: AppColors.of(context).greenSoft,
      shape: Tokens.chipShape,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      spacing: DailyTokens.dateGap,
      children: [
        SvgPicture.asset(
          'assets/icons/focus_active_moon.svg',
          excludeFromSemantics: true,
          colorFilter: ColorFilter.mode(
            AppColors.of(context).green,
            BlendMode.srcIn,
          ),
        ),
        Flexible(
          child: Text(
            AppLocalizations.of(context).focusOn,
            style: AuthTokens.finePrint.copyWith(
              color: AppColors.of(context).green,
            ),
          ),
        ),
      ],
    ),
  );
}
