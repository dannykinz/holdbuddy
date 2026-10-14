import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_route.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/tokens.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/widgets/hb_back_button.dart';
import '../../../core/widgets/hb_button.dart';
import '../../../core/widgets/hb_notice.dart';
import '../../../core/widgets/hb_page_scaffold.dart';
import '../../../core/widgets/hb_preview_note.dart';
import '../logic/pro_controller.dart';
import 'pro_copy.dart';
import 'widgets/pro_hero.dart';
import 'widgets/pro_perks.dart';
import 'widgets/pro_plan_option.dart';

class ProPaywallScreen extends ConsumerWidget {
  const ProPaywallScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final state = ref.watch(ProController.provider);
    final offers = ref.watch(proOffersProvider);
    final selected = offers
        .where((offer) => offer.product == state.selected)
        .firstOrNull;
    return HbPageScaffold(
      key: const ValueKey(AppRoute.proPaywall),
      topBar: _header(context, ref),
      gap: ProTokens.contentGap,
      content: [
        const ProHero(),
        const ProPerks(),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: ProTokens.heroGap,
            children: [
              for (final offer in offers)
                Expanded(child: ProPlanOption(offer: offer)),
            ],
          ),
        ),
        if (state.failed) HbNotice(title: l.proFailure, body: l.proFailureBody),
      ],
      actions: [
        HbButton(
          label: selected == null
              ? l.proTitle
              : l.proPreviewPlan(
                  ProCopy.name(l, selected.product),
                  ProCopy.price(l, selected),
                ),
          onPressed: selected == null ? null : () => _purchase(context, ref),
        ),
        Text(
          l.proBilling,
          textAlign: TextAlign.center,
          style: ProTokens.caption.copyWith(
            color: AppColors.of(context).subtle,
          ),
        ),
      ],
      footnote: HbPreviewNote(text: l.proPreview),
    );
  }

  Widget _header(BuildContext context, WidgetRef ref) => Row(
    children: [
      const HbBackButton(fallback: AppRoute.settings),
      const Spacer(),
      TextButton(
        onPressed: () => _restore(context, ref),
        child: Text(AppLocalizations.of(context).proRestore),
      ),
    ],
  );
  void _purchase(BuildContext context, WidgetRef ref) {
    if (!ref.read(ProController.provider.notifier).purchase()) return;
    context.pushReplacementNamed(AppRoute.proWelcome.name);
  }

  void _restore(BuildContext context, WidgetRef ref) {
    final restored = ref.read(ProController.provider.notifier).restore();
    if (ref.read(ProController.provider).failed) return;
    final l = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(restored ? l.proRestoreFound : l.proRestoreEmpty)),
    );
    if (restored) context.pushReplacementNamed(AppRoute.proWelcome.name);
  }
}
