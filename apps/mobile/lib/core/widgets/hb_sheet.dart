import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/tokens.dart';

class HbSheet extends StatelessWidget {
  const HbSheet({
    super.key,
    required this.title,
    required this.child,
    this.showTitle = true,
  });
  final String title;
  final Widget child;
  final bool showTitle;

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required Widget child,
  }) => showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: AppColors.of(context).surface,
    barrierColor: Tokens.ink.withValues(alpha: WidgetTokens.sheetScrimOpacity),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(Tokens.radiusSheet),
      ),
    ),
    sheetAnimationStyle: MediaQuery.disableAnimationsOf(context)
        ? AnimationStyle.noAnimation
        : const AnimationStyle(duration: WidgetTokens.motionDuration),
    builder: (context) => HbSheet(title: title, child: child),
  );

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: EdgeInsets.only(
      left: Tokens.space20,
      right: Tokens.space20,
      top: Tokens.space12,
      bottom:
          WidgetTokens.sheetBottom + MediaQuery.viewInsetsOf(context).bottom,
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: WidgetTokens.sheetGap,
      children: [
        Center(
          child: Container(
            width: WidgetTokens.sheetHandleWidth,
            height: WidgetTokens.sheetHandleHeight,
            decoration: BoxDecoration(
              color: AppColors.of(context).line,
              borderRadius: BorderRadius.circular(
                WidgetTokens.sheetHandleRadius,
              ),
            ),
          ),
        ),
        if (showTitle)
          Semantics(
            header: true,
            child: Text(
              title,
              style: WidgetTokens.sheetTitle.copyWith(
                color: AppColors.of(context).text,
              ),
            ),
          ),
        child,
      ],
    ),
  );
}
