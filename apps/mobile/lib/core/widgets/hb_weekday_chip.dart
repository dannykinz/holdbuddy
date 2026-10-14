import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/tokens.dart';
import 'hb_hatch.dart';

class HbWeekdayChip extends StatelessWidget {
  const HbWeekdayChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
  });
  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Tokens.radiusField),
        boxShadow: [
          if (selected)
            BoxShadow(
              color: colors.primaryEdge,
              offset: const Offset(0, WidgetTokens.activeWidth),
            ),
        ],
      ),
      child: TextButton(
        onPressed: onSelected,
        style: TextButton.styleFrom(
          backgroundColor: selected ? colors.primary : colors.soft,
          foregroundColor: selected ? colors.onPrimary : colors.muted,
          padding: EdgeInsets.zero,
          minimumSize: const Size(
            Tokens.minTouchTarget,
            WidgetTokens.weekdayHeight,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Tokens.radiusField),
          ),
          textStyle: Tokens.strong,
          backgroundBuilder: _hatch,
        ),
        child: Semantics(selected: selected, child: Text(label)),
      ),
    );
  }

  Widget _hatch(BuildContext context, Set<WidgetState> states, Widget? child) {
    if (!selected) return child ?? const SizedBox.shrink();
    return HbHatch(
      color: AppColors.of(context).onPrimary,
      opacity: WidgetTokens.lightHatchOpacity,
      child: child,
    );
  }
}
