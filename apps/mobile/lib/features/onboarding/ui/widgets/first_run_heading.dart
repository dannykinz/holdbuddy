import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';

class FirstRunHeading extends StatelessWidget {
  const FirstRunHeading({
    super.key,
    required this.before,
    required this.accent,
    required this.after,
    required this.description,
  });
  final String before;
  final String accent;
  final String after;
  final String description;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Column(
      spacing: Tokens.space12,
      children: [
        Semantics(
          header: true,
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(text: before),
                TextSpan(
                  text: accent,
                  style: TextStyle(color: colors.accent),
                ),
                TextSpan(text: after),
              ],
            ),
            textAlign: TextAlign.center,
            style: Tokens.headline.copyWith(color: colors.text),
          ),
        ),
        Text(
          description,
          textAlign: TextAlign.center,
          style: Tokens.body.copyWith(color: colors.muted),
        ),
      ],
    );
  }
}
