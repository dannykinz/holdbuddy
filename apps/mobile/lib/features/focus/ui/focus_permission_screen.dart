import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_route.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/tokens.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/widgets/hb_button.dart';
import '../../../core/widgets/hb_heading.dart';
import '../../../core/widgets/hb_hero_tile.dart';
import '../../../core/widgets/hb_page_header.dart';
import '../../../core/widgets/hb_page_scaffold.dart';
import '../logic/focus_controller.dart';

class FocusPermissionScreen extends ConsumerWidget {
  const FocusPermissionScreen({super.key, this.chapterNumber});
  final int? chapterNumber;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = AppColors.of(context);
    return HbPageScaffold(
      key: const ValueKey(AppRoute.focusPermission),
      topBar: const HbPageHeader(fallback: AppRoute.sessionChooseMode),
      content: [
        HbHeroTile(
          asset: 'assets/icons/focus_permission_moon.svg',
          color: colors.green,
          fill: colors.greenSoft,
          size: DailyTokens.emptyHeroSize,
          radius: Tokens.radiusCard,
        ),
        HbHeading(
          title: l10n.focusPermissionTitle,
          description: l10n.focusPermissionBody,
        ),
        Card.outlined(
          child: Padding(
            padding: const EdgeInsets.all(Tokens.space16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: Tokens.space24,
              children: [
                _point(context, l10n.focusOnlySessions, l10n.focusNoOtherTime),
                _point(context, l10n.focusStarred, l10n.focusEmergencies),
                _point(context, l10n.focusAnyTime, l10n.focusSettings),
              ],
            ),
          ),
        ),
      ],
      actions: [
        HbButton(
          label: l10n.focusAllow,
          onPressed: () {
            ref.read(FocusController.provider.notifier).requestAccess();
            context.pushReplacementNamed(
              AppRoute.session.name,
              extra: chapterNumber,
            );
          },
        ),
      ],
      footnote: Text(
        l10n.focusPreview,
        style: Tokens.small.copyWith(color: colors.muted),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _point(BuildContext context, String title, String body) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: DailyTokens.copyGap,
    children: [
      Text(title, style: Tokens.strong),
      Text(
        body,
        style: Tokens.small.copyWith(color: AppColors.of(context).muted),
      ),
    ],
  );
}
