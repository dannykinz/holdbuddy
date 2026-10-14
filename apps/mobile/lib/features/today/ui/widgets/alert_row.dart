import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/router/app_route.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../partners/logic/selected_peer.dart';
import '../../domain/alert_kind.dart';
import '../../domain/study_alert.dart';
import '../../logic/alert_controller.dart';

class AlertRow extends ConsumerWidget {
  const AlertRow({super.key, required this.alert});
  final StudyAlert alert;
  @override
  Widget build(BuildContext context, WidgetRef ref) => InkWell(
    onTap: () async {
      ref.read(AlertController.provider.notifier).read(alert.id);
      if (alert.peerId.isNotEmpty)
        ref.read(SelectedPeer.provider.notifier).select(alert.peerId);
      await context.pushNamed<void>(switch (alert.kind) {
        AlertKind.partnerSkipped ||
        AlertKind.nudge => AppRoute.partnerTheirPlan.name,
        AlertKind.request || AlertKind.witnessActive => AppRoute.partners.name,
        AlertKind.recalculated => AppRoute.welcomeBack.name,
        _ => AppRoute.chapter.name,
      });
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: DailyTokens.subcardPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: Tokens.space12,
        children: [
          _tile(context),
          Expanded(child: _copy(context)),
          _meta(context),
        ],
      ),
    ),
  );
  Widget _copy(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final title = switch (alert.kind) {
      AlertKind.partnerSkipped => l10n.alertPartnerSkipped(alert.person),
      AlertKind.request => l10n.alertRequest(alert.person),
      AlertKind.due => l10n.alertSessionDue,
      AlertKind.nudge => l10n.alertNudge(alert.person),
      AlertKind.recalculated => l10n.planRecalculated,
      AlertKind.saved => l10n.sessionSavedTitle,
      AlertKind.witnessActive => l10n.alertWitnessOpened(alert.person),
    };
    final body = _body(l10n);
    return _text(context, title, body);
  }

  String _body(AppLocalizations l10n) => switch (alert.kind) {
    AlertKind.partnerSkipped ||
    AlertKind.nudge => l10n.contractMessageQuote(alert.message),
    AlertKind.request => l10n.alertRequestBody(alert.message),
    AlertKind.due => l10n.alertDueBody,
    AlertKind.recalculated => l10n.alertRecalculatedBody,
    AlertKind.saved => l10n.alertSavedBody,
    AlertKind.witnessActive => l10n.alertWitnessBody,
  };
  Widget _text(BuildContext context, String title, String body) {
    return Column(
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

  Widget _meta(BuildContext context) => Column(
    spacing: Tokens.space8,
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      Text(
        DateFormat(
          alert.earlier || alert.kind == AlertKind.partnerSkipped
              ? 'EEE'
              : 'h:mm',
          AppLocalizations.of(context).localeName,
        ).format(alert.timestamp),
        style: Tokens.meta.copyWith(color: AppColors.of(context).subtle),
      ),
      if (!alert.read)
        Container(
          width: Tokens.space8,
          height: Tokens.space8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.of(context).pink,
          ),
        ),
    ],
  );
  Widget _tile(BuildContext context) {
    final person =
        alert.kind == AlertKind.partnerSkipped ||
        alert.kind == AlertKind.request ||
        alert.kind == AlertKind.nudge ||
        alert.kind == AlertKind.witnessActive;
    if (person)
      return Image.asset(
        alert.kind == AlertKind.request
            ? 'assets/avatars/alert_amaka.png'
            : 'assets/avatars/alert_elvis.png',
        width: DailyTokens.rowTileSize,
        height: DailyTokens.rowTileSize,
        excludeFromSemantics: true,
      );
    final colors = AppColors.of(context);
    final (icon, color, fill) = switch (alert.kind) {
      AlertKind.due => ('clock', colors.sky, colors.skySoft),
      AlertKind.recalculated => ('refresh', colors.purple, colors.purpleSoft),
      _ => ('check', colors.green, colors.greenSoft),
    };
    return _categoryTile(context, icon, color, fill);
  }

  Widget _categoryTile(
    BuildContext context,
    String icon,
    Color color,
    Color fill,
  ) {
    return Container(
      width: DailyTokens.rowTileSize,
      height: DailyTokens.rowTileSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(DailyTokens.rowTileRadius),
      ),
      child: SvgPicture.asset(
        'assets/icons/alert_$icon.svg',
        excludeFromSemantics: true,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }
}
