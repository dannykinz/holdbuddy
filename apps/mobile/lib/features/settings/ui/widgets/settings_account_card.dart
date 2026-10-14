import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_route.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/widgets/async_view.dart';
import '../../../../core/widgets/hb_avatar.dart';
import '../../../auth/logic/auth_controller.dart';
import '../../../profile/domain/learner.dart';
import '../../../profile/logic/learner_providers.dart';
import '../../logic/settings_controller.dart';

class SettingsAccountCard extends ConsumerWidget {
  const SettingsAccountCard({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => AsyncView<Learner>(
    value: ref.watch(learnerProvider),
    onRetry: () => ref.invalidate(learnerProvider),
    builder: (context, learner) => _card(context, ref, learner),
  );
  Widget _card(BuildContext context, WidgetRef ref, Learner learner) {
    final email = ref.watch(AuthController.provider).email;
    final address = learner.email.isNotEmpty
        ? learner.email
        : email.isEmpty
        ? ref.watch(settingsPreviewProvider).email
        : email;
    return Card.filled(
      child: InkWell(
        borderRadius: BorderRadius.circular(Tokens.radiusCard),
        onTap: () => context.pushNamed(AppRoute.profileEdit.name),
        child: Padding(
          padding: const EdgeInsets.all(Tokens.space16),
          child: Row(
            spacing: Tokens.space12,
            children: [
              _portrait(context, learner),
              _identity(context, learner, address),
            ],
          ),
        ),
      ),
    );
  }

  Widget _portrait(BuildContext context, Learner learner) => HbAvatar(
    image: AssetImage(
      learner.avatar.isEmpty
          ? 'assets/avatars/settings_you.png'
          : learner.avatar,
    ),
    label: learner.displayName,
    size: Tokens.minTouchTarget,
    ringColor: AppColors.of(context).orange,
  );
  Widget _identity(BuildContext context, Learner learner, String email) =>
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: DailyTokens.copyGap,
          children: [
            Text(learner.displayName, style: Tokens.strong),
            Text(
              email,
              style: Tokens.small.copyWith(color: AppColors.of(context).muted),
            ),
          ],
        ),
      );
}
