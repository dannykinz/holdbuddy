import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/widgets/hb_category.dart';
import '../../../../core/widgets/hb_hatch.dart';

class MaterialProgress extends StatelessWidget {
  const MaterialProgress({
    super.key,
    required this.value,
    required this.category,
    required this.label,
  });
  final double value;
  final HbCategory category;
  final String label;
  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final pair = category.colors(colors);
    return Semantics(
      label: label,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(MaterialTokens.progressRadius),
        child: SizedBox(
          height: MaterialTokens.progressHeight,
          child: ColoredBox(
            color: colors.line,
            child: Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: value.clamp(0, 1).toDouble(),
                child: ColoredBox(
                  color: pair.strong,
                  child: HbHatch(
                    color: colors.surface,
                    opacity: WidgetTokens.lightHatchOpacity,
                    child: const SizedBox.expand(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
