import 'package:flutter/material.dart';

import '../../app/router/app_route.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/tokens.dart';
import 'hb_back_button.dart';
import 'hb_step_bar.dart';

class HbStepHeader extends StatelessWidget {
  const HbStepHeader({
    super.key,
    required this.step,
    this.trailing,
    this.title,
    this.fallback = AppRoute.scope,
  });
  final int step;
  final Widget? trailing;
  final String? title;
  final AppRoute fallback;

  @override
  Widget build(BuildContext context) {
    final heading = title;
    return Row(
      spacing: Tokens.space12,
      children: [
        HbBackButton(fallback: fallback),
        Expanded(
          child: heading == null
              ? HbStepBar(step: step)
              : Text(
                  heading,
                  textAlign: TextAlign.center,
                  style: Tokens.small.copyWith(
                    color: AppColors.of(context).muted,
                  ),
                ),
        ),
        SizedBox.square(dimension: Tokens.minTouchTarget, child: trailing),
      ],
    );
  }
}
