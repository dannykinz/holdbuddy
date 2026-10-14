import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import 'material_type_stack.dart';

class MaterialDropZone extends StatelessWidget {
  const MaterialDropZone({super.key, required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final l10n = AppLocalizations.of(context);
    return CustomPaint(
      foregroundPainter: _Border(colors.line),
      child: Material(
        color: colors.surface,
        borderRadius: BorderRadius.circular(ContractTokens.materialRadius),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(Tokens.space16),
            child: Row(
              spacing: ContractTokens.unitsGap,
              children: [
                const MaterialTypeStack(),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: ContractTokens.materialCopyGap,
                    children: [
                      Text(
                        l10n.materialAdd,
                        style: ContractTokens.materialTitle,
                      ),
                      Text(
                        l10n.materialStaysOnPhone,
                        style: ContractTokens.materialMeta.copyWith(
                          color: colors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                _plus(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _plus(BuildContext context) => Container(
    width: ContractTokens.materialTypeSize,
    height: ContractTokens.materialTypeSize,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: AppColors.of(context).primary,
    ),
    child: SvgPicture.asset(
      'assets/icons/material_plus.svg',
      excludeFromSemantics: true,
      colorFilter: ColorFilter.mode(
        AppColors.of(context).onPrimary,
        BlendMode.srcIn,
      ),
    ),
  );
}

class _Border extends CustomPainter {
  const _Border(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = WidgetTokens.focusWidth;
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          (Offset.zero & size).deflate(WidgetTokens.focusWidth / 2),
          const Radius.circular(ContractTokens.materialRadius),
        ),
      );
    for (final metric in path.computeMetrics()) {
      for (
        var start = 0.0;
        start < metric.length;
        start += ContractTokens.materialDash + ContractTokens.materialDashGap
      )
        canvas.drawPath(
          metric.extractPath(start, start + ContractTokens.materialDash),
          paint,
        );
    }
  }

  @override
  bool shouldRepaint(_Border oldDelegate) => color != oldDelegate.color;
}
