import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/tokens.dart';

class HbHeading extends StatelessWidget {
  const HbHeading({
    super.key,
    required this.title,
    this.accent = '',
    this.after = '',
    this.description,
  });
  final String title;
  final String accent;
  final String after;
  final String? description;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final body = description;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: Tokens.space12,
      children: [
        Semantics(
          header: true,
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(text: title),
                TextSpan(
                  text: accent,
                  style: TextStyle(color: colors.accent),
                ),
                TextSpan(text: after),
              ],
            ),
            style: Tokens.headline.copyWith(color: colors.text),
          ),
        ),
        if (body != null)
          Text(body, style: Tokens.body.copyWith(color: colors.muted)),
      ],
    );
  }
}
