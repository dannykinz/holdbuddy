import 'package:flutter/material.dart';

import '../../app/router/app_route.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/tokens.dart';
import 'hb_back_button.dart';

class HbPageHeader extends StatelessWidget {
  const HbPageHeader({
    super.key,
    this.title,
    this.onBack,
    this.fallback = AppRoute.today,
    this.trailing,
    this.center,
  });
  final String? title;
  final VoidCallback? onBack;
  final AppRoute fallback;
  final Widget? trailing;
  final Widget? center;

  @override
  Widget build(BuildContext context) => Row(
    spacing: Tokens.space12,
    children: [
      HbBackButton(onPressed: onBack, fallback: fallback),
      Expanded(
        child:
            center ??
            Text(
              title ?? '',
              textAlign: TextAlign.center,
              style: Tokens.small.copyWith(color: AppColors.of(context).muted),
            ),
      ),
      SizedBox.square(dimension: Tokens.minTouchTarget, child: trailing),
    ],
  );
}
