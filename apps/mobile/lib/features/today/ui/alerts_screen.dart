import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/router/app_route.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/tokens.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/widgets/hb_page_header.dart';
import '../../../core/widgets/hb_page_scaffold.dart';
import '../logic/alert_controller.dart';
import '../logic/visible_alerts_provider.dart';
import 'widgets/alert_row.dart';

class AlertsScreen extends ConsumerWidget {
  const AlertsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alerts = ref.watch(visibleAlertsProvider);
    final l10n = AppLocalizations.of(context);
    return HbPageScaffold(
      key: const ValueKey(AppRoute.alerts),
      topBar: const HbPageHeader(),
      content: [
        Row(
          children: [
            Expanded(child: Text(l10n.todayAlerts, style: Tokens.headline)),
            TextButton(
              onPressed: ref.read(AlertController.provider.notifier).readAll,
              child: Text(l10n.alertsMarkRead),
            ),
          ],
        ),
        for (final earlier in [false, true])
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: DailyTokens.rowGap,
            children: [
              Text(
                earlier ? l10n.alertsEarlier : l10n.alertsToday,
                style: Tokens.dataLabel.copyWith(
                  color: AppColors.of(context).subtle,
                ),
              ),
              Card.outlined(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Tokens.space16,
                  ),
                  child: Column(
                    children: [
                      for (final alert in alerts.where(
                        (alert) => alert.earlier == earlier,
                      )) ...[
                        if (alert !=
                            alerts
                                .where((alert) => alert.earlier == earlier)
                                .first)
                          const Divider(height: WidgetTokens.lineWidth),
                        AlertRow(alert: alert),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
      ],
      actions: const [],
    );
  }
}
