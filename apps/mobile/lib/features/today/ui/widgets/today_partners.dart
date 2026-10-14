import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_route.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_avatar.dart';
import '../../../../core/widgets/hb_avatar_stack.dart';
import '../../../../core/widgets/hb_category.dart';
import '../../../../core/widgets/hb_chip.dart';
import '../../../partners/domain/peer.dart';
import '../../../partners/logic/people_controller.dart';

class TodayPartners extends ConsumerWidget {
  const TodayPartners({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final peers = ref.watch(PeopleController.provider);
    final active = peers
        .where((peer) => !peer.blocked && (peer.holdsMe || peer.iHold))
        .toList();
    final requests = peers
        .where(
          (peer) =>
              peer.request && !peer.blocked && !peer.expired(DateTime.now()),
        )
        .length;
    final l10n = AppLocalizations.of(context);
    final colors = AppColors.of(context);
    return Card.outlined(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DailyTokens.subcardRadius),
        side: BorderSide(color: colors.line),
      ),
      child: InkWell(
        onTap: () => context.pushNamed(AppRoute.partners.name),
        borderRadius: BorderRadius.circular(DailyTokens.subcardRadius),
        child: Padding(
          padding: const EdgeInsets.all(Tokens.space12),
          child: Row(
            spacing: Tokens.space12,
            children: [
              _portraits(active),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: DailyTokens.copyGap,
                  children: [
                    Text(l10n.todayPartners, style: Tokens.strong),
                    Text(
                      active.isEmpty
                          ? l10n.peopleNoPartners
                          : l10n.peoplePrivate,
                      style: Tokens.small.copyWith(color: colors.muted),
                    ),
                  ],
                ),
              ),
              HbChip(
                label: l10n.todayRequests(requests),
                category: HbCategory.pink,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _portraits(List<Peer> peers) {
    if (peers.isEmpty) return const SizedBox.shrink();
    return HbAvatarStack(
      avatars: [
        for (final peer in peers.take(3))
          HbAvatar(image: AssetImage(peer.avatar), label: peer.name),
      ],
    );
  }
}
