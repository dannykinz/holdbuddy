import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/tokens.dart';
import 'hb_category.dart';

class HbChip extends StatelessWidget {
  const HbChip({
    super.key,
    required this.label,
    required this.category,
    this.labelStyle,
    this.padding,
  });
  final String label;
  final HbCategory category;
  final TextStyle? labelStyle;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final colors = category.colors(AppColors.of(context));
    return DecoratedBox(
      decoration: ShapeDecoration(color: colors.soft, shape: Tokens.chipShape),
      child: Padding(
        padding:
            padding ??
            const EdgeInsets.symmetric(
              horizontal: WidgetTokens.chipHorizontal,
              vertical: WidgetTokens.chipVertical,
            ),
        child: Text(
          label,
          style: (labelStyle ?? WidgetTokens.chipLabel).copyWith(
            color: colors.strong,
          ),
        ),
      ),
    );
  }
}
