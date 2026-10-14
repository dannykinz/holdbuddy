import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/tokens.dart';

class HbNotice extends StatelessWidget {
  const HbNotice({
    super.key,
    required this.title,
    required this.body,
    this.iconSize = AuthTokens.noticeIconSize,
    this.asset,
    this.destructive = false,
  });
  final String title;
  final String body;
  final double iconSize;
  final String? asset;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Semantics(
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.all(Tokens.space16),
        decoration: BoxDecoration(
          color: destructive ? colors.errorBg : colors.tint,
          borderRadius: BorderRadius.circular(Tokens.radiusCard),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: Tokens.space12,
          children: [
            _icon(context),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AuthTokens.noticeGap,
                children: [
                  Text(
                    title,
                    style: Tokens.strong.copyWith(
                      color: destructive ? colors.error : colors.text,
                    ),
                  ),
                  Text(body, style: Tokens.small.copyWith(color: colors.muted)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _icon(BuildContext context) {
    final colors = AppColors.of(context);
    final mode = Theme.of(context).brightness == Brightness.dark ? 'dark_' : '';
    return SizedBox.square(
      dimension: iconSize,
      child: FittedBox(
        child: SvgPicture.asset(
          asset ?? 'assets/icons/auth_${mode}info.svg',
          colorFilter: asset == null
              ? null
              : ColorFilter.mode(
                  destructive ? colors.error : colors.accent,
                  BlendMode.srcIn,
                ),
          excludeFromSemantics: true,
        ),
      ),
    );
  }
}
