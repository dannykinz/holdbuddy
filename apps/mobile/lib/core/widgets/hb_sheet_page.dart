import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/tokens.dart';
import 'hb_sheet.dart';

class HbSheetPage extends Page<Object?> {
  const HbSheetPage({
    super.key,
    super.name,
    required this.title,
    required this.child,
    this.showTitle = true,
  });
  final String title;
  final Widget child;
  final bool showTitle;
  @override
  Route<Object?> createRoute(BuildContext context) =>
      ModalBottomSheetRoute<Object?>(
        settings: this,
        isScrollControlled: true,
        useSafeArea: true,
        backgroundColor: AppColors.of(context).surface,
        modalBarrierColor: Tokens.ink.withValues(
          alpha: WidgetTokens.sheetScrimOpacity,
        ),
        barrierLabel: MaterialLocalizations.of(context)
            .modalBarrierDismissLabel,
        capturedThemes: InheritedTheme.capture(
          from: context,
          to: Navigator.of(context).context,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(Tokens.radiusSheet),
          ),
        ),
        sheetAnimationStyle: MediaQuery.disableAnimationsOf(context)
            ? AnimationStyle.noAnimation
            : const AnimationStyle(duration: WidgetTokens.motionDuration),
        builder: (context) =>
            HbSheet(title: title, child: child, showTitle: showTitle),
      );
}
