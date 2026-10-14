import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/tokens.dart';
import 'hb_hatch.dart';

class HbProgressBar extends StatelessWidget {
  const HbProgressBar({
    super.key,
    required this.done,
    required this.thisWeek,
    required this.total,
    required this.label,
  }) : assert(total > 0),
       assert(done >= 0),
       assert(thisWeek >= 0),
       assert(done + thisWeek <= total);
  final int done;
  final int thisWeek;
  final int total;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final segments = [
      (units: done, fill: colors.accent, hatch: colors.surface),
      (units: thisWeek, fill: colors.purple, hatch: colors.surface),
      (units: total - done - thisWeek, fill: colors.soft, hatch: colors.subtle),
    ];
    return Semantics(
      label: label,
      child: SizedBox(
        height: WidgetTokens.progressHeight,
        child: Row(
          spacing: WidgetTokens.progressGap,
          children: [
            for (final segment in segments)
              if (segment.units > 0)
                Expanded(
                  flex: segment.units,
                  child: _segment(segment.fill, segment.hatch),
                ),
          ],
        ),
      ),
    );
  }

  Widget _segment(Color fill, Color hatch) => ClipRRect(
    borderRadius: BorderRadius.circular(WidgetTokens.progressRadius),
    child: ColoredBox(
      color: fill,
      child: HbHatch(
        color: hatch,
        opacity: WidgetTokens.lightHatchOpacity,
        child: const SizedBox.expand(),
      ),
    ),
  );
}
