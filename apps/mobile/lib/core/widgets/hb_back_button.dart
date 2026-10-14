import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_route.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/tokens.dart';
import '../l10n/generated/app_localizations.dart';

class HbBackButton extends StatelessWidget {
  const HbBackButton({
    super.key,
    this.onPressed,
    this.fallback = AppRoute.today,
  });
  final VoidCallback? onPressed;
  final AppRoute fallback;

  @override
  Widget build(BuildContext context) => IconButton.filledTonal(
    tooltip: AppLocalizations.of(context).back,
    style: IconButton.styleFrom(
      backgroundColor: AppColors.of(context).soft,
      minimumSize: const Size.square(Tokens.minTouchTarget),
    ),
    onPressed: onPressed ?? () => _back(context),
    icon: SvgPicture.asset(
      'assets/icons/onboarding_back.svg',
      excludeFromSemantics: true,
      colorFilter: ColorFilter.mode(
        AppColors.of(context).text,
        BlendMode.srcIn,
      ),
    ),
  );

  void _back(BuildContext context) {
    FocusScope.of(context).unfocus();
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.goNamed(fallback.name);
  }
}
