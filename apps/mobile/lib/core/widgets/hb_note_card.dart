import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/tokens.dart';

class HbNoteCard extends StatelessWidget {
  const HbNoteCard({
    super.key,
    required this.title,
    required this.body,
    required this.fill,
    required this.onPressed,
    this.width = DailyTokens.noteWidth,
  });
  final String title;
  final String body;
  final Color fill;
  final VoidCallback onPressed;
  final double? width;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: width,
    child: Material(
      color: fill,
      borderRadius: BorderRadius.circular(DailyTokens.noteRadius),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(DailyTokens.noteRadius),
        child: Padding(
          padding: const EdgeInsets.all(Tokens.space16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: Tokens.space8,
            children: [
              Text(
                title,
                style: Tokens.label.copyWith(
                  color: AppColors.of(context).muted,
                ),
              ),
              Text(
                body,
                style: Tokens.body.copyWith(color: AppColors.of(context).text),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
