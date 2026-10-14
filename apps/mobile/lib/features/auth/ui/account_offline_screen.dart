import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_route.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/widgets/hb_button.dart';
import '../../../core/widgets/hb_button_variant.dart';
import '../../../core/widgets/hb_heading.dart';
import '../../today/domain/today_view.dart';
import '../../today/logic/today_controller.dart';
import '../domain/auth_operation.dart';
import '../domain/auth_request.dart';
import '../logic/auth_controller.dart';
import 'widgets/auth_age_confirmation.dart';
import 'widgets/auth_hero.dart';
import 'widgets/auth_scaffold.dart';

class AccountOfflineScreen extends ConsumerWidget {
  const AccountOfflineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final adult = ref.watch(AuthController.provider).isAdult;
    return AuthScaffold(
      route: AppRoute.accountOffline,
      content: [
        const AuthHero(icon: 'offline'),
        HbHeading(
          title: l10n.authOfflineTitle,
          description: l10n.authOfflineBody,
        ),
        const AuthAgeConfirmation(),
      ],
      actions: [
        HbButton(
          label: l10n.authTryAgain,
          onPressed: () {
            unawaited(
              ref
                  .read(AuthController.provider.notifier)
                  .submit(const AuthRequest(AuthOperation.retry)),
            );
            unawaited(
              context.pushNamed<void>(
                AppRoute.accountLoading.name,
                extra: true,
              ),
            );
          },
        ),
        HbButton(
          label: l10n.continueOffline,
          variant: HbButtonVariant.secondary,
          onPressed: adult
              ? () {
                  ref
                      .read(TodayController.provider.notifier)
                      .show(TodayView.offline);
                  context.goNamed(AppRoute.today.name);
                }
              : null,
        ),
      ],
    );
  }
}
