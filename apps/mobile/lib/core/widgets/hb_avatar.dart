import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/tokens.dart';
import '../l10n/generated/app_localizations.dart';
import '../logging/logger.dart';

class HbAvatar extends StatelessWidget {
  const HbAvatar({
    super.key,
    required this.image,
    required this.label,
    this.size = WidgetTokens.avatarSize,
    this.ringColor,
  });
  final ImageProvider<Object> image;
  final String label;
  final double size;
  final Color? ringColor;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(
        color: ringColor ?? AppColors.of(context).surface,
        width: WidgetTokens.avatarRing,
      ),
    ),
    child: ClipOval(
      child: Image(
        image: image,
        fit: BoxFit.cover,
        semanticLabel: label,
        errorBuilder: _unavailable,
      ),
    ),
  );

  Widget _unavailable(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
  ) {
    logError(error, stackTrace ?? StackTrace.current);
    return Semantics(
      image: true,
      label: AppLocalizations.of(context).avatarUnavailable,
      child: ColoredBox(color: AppColors.of(context).soft),
    );
  }
}
