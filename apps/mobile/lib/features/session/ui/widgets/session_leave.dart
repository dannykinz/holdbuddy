import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_route.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_button.dart';
import '../../../../core/widgets/hb_button_variant.dart';
import '../../../../core/widgets/hb_heading.dart';
import '../../../../core/widgets/hb_hero_tile.dart';
import '../../../../core/widgets/hb_page_header.dart';
import '../../../../core/widgets/hb_page_scaffold.dart';
import '../../logic/session_controller.dart';

class SessionLeave extends ConsumerWidget {
  const SessionLeave({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = AppColors.of(context);
    final controller = ref.read(SessionController.provider.notifier);
    return HbPageScaffold(
      topBar: HbPageHeader(onBack: controller.keepStudying),
      content: [
        HbHeroTile(
          asset: 'assets/icons/daily_pause.svg',
          color: colors.orange,
          fill: colors.orangeSoft,
          size: AuthTokens.heroSize,
          radius: AuthTokens.heroRadius,
        ),
        HbHeading(
          title: l10n.sessionLeaveTitle,
          description: l10n.sessionLeaveBody,
        ),
      ],
      actions: [
        HbButton(
          label: l10n.sessionSaveLeave,
          onPressed: () {
            controller.pause();
            context.goNamed(AppRoute.today.name);
          },
        ),
        HbButton(
          label: l10n.sessionKeepStudying,
          variant: HbButtonVariant.secondary,
          onPressed: controller.keepStudying,
        ),
      ],
    );
  }
}
