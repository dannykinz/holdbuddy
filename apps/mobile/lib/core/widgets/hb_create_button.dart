import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/tokens.dart';
import '../l10n/generated/app_localizations.dart';

class HbCreateButton extends StatelessWidget {
  const HbCreateButton({super.key, required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: colors.floatingShadow.withValues(
              alpha: WidgetTokens.createShadowOpacity,
            ),
            offset: WidgetTokens.createShadowOffset,
            blurRadius: WidgetTokens.createShadowBlur,
            spreadRadius: WidgetTokens.createShadowSpread,
          ),
          BoxShadow(
            color: colors.primaryEdge,
            offset: const Offset(0, WidgetTokens.buttonEdge),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        tooltip: AppLocalizations.of(context).create,
        style: IconButton.styleFrom(
          backgroundColor: colors.primary,
          fixedSize: const Size.square(Tokens.navHeight),
          padding: EdgeInsets.zero,
        ),
        icon: SvgPicture.asset(
          'assets/icons/plus.svg',
          excludeFromSemantics: true,
          colorFilter: ColorFilter.mode(colors.onPrimary, BlendMode.srcIn),
        ),
      ),
    );
  }
}
