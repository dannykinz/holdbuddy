import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/router/app_route.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_avatar.dart';
import '../../../profile/logic/learner_providers.dart';
import '../../domain/today_view.dart';
import '../../logic/today_controller.dart';
import '../../logic/visible_alerts_provider.dart';

class TodayHeader extends ConsumerWidget {
  const TodayHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final view = ref.watch(TodayController.provider);
    final data = ref.watch(todayOverviewProvider);
    final early =
        view == TodayView.first ||
        view == TodayView.firstDone ||
        view == TodayView.empty;
    final day = data.date;
    return Wrap(
      spacing: DailyTokens.rowGap,
      runSpacing: Tokens.space8,
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _date(context, ref, day),
        if (!early) _comebacks(context, data.comebacks),
        _alerts(
          context,
          early
              ? (view == TodayView.first ? 1 : 0)
              : ref
                    .watch(visibleAlertsProvider)
                    .where((alert) => !alert.read)
                    .length,
        ),
        if (view != TodayView.loading) _profile(context, ref),
      ],
    );
  }

  Widget _date(BuildContext context, WidgetRef ref, DateTime day) => TextButton(
    onPressed: () => _chooseDate(context, ref, day),
    style: TextButton.styleFrom(padding: EdgeInsets.zero),
    child: _dateLabel(context, day),
  );

  Widget _comebacks(BuildContext context, int count) {
    final colors = AppColors.of(context);
    return Semantics(
      label: AppLocalizations.of(context).todayComebacks(count),
      child: TextButton.icon(
        onPressed: () => context.pushNamed(AppRoute.progress.name),
        style: TextButton.styleFrom(
          backgroundColor: colors.greenSoft,
          padding: const EdgeInsets.symmetric(
            horizontal: Tokens.space12,
            vertical: Tokens.space8,
          ),
          shape: Tokens.chipShape,
        ),
        icon: SvgPicture.asset(
          'assets/icons/daily_refresh.svg',
          excludeFromSemantics: true,
          colorFilter: ColorFilter.mode(colors.green, BlendMode.srcIn),
        ),
        label: Text(
          count.toString(),
          style: Tokens.label.copyWith(color: colors.green),
        ),
      ),
    );
  }

  Widget _alerts(BuildContext context, int unread) => Stack(
    clipBehavior: Clip.none,
    children: [
      IconButton.filledTonal(
        tooltip: AppLocalizations.of(context).todayAlerts,
        style: IconButton.styleFrom(
          backgroundColor: AppColors.of(context).soft,
        ),
        onPressed: () => context.pushNamed(AppRoute.alerts.name),
        icon: SvgPicture.asset(
          'assets/icons/daily_bell.svg',
          excludeFromSemantics: true,
          colorFilter: ColorFilter.mode(
            AppColors.of(context).text,
            BlendMode.srcIn,
          ),
        ),
      ),
      if (unread > 0) _badge(context, unread),
    ],
  );

  Widget _profile(BuildContext context, WidgetRef ref) => IconButton(
    tooltip: AppLocalizations.of(context).todayProfile,
    padding: EdgeInsets.zero,
    onPressed: () => context.pushNamed(AppRoute.profileEdit.name),
    icon: HbAvatar(
      image: AssetImage(
        ref.watch(learnerProvider).value?.avatar ??
            'assets/avatars/profile.png',
      ),
      label: AppLocalizations.of(context).todayProfile,
      size: DailyTokens.headerAvatarSize,
    ),
  );

  Future<void> _chooseDate(
    BuildContext context,
    WidgetRef ref,
    DateTime day,
  ) async {
    final data = ref.read(todayOverviewProvider);
    final date = await showDatePicker(
      context: context,
      initialDate: day,
      firstDate: ref.read(TodayController.provider.notifier).firstDay,
      lastDate: data.returnFinishDate,
    );
    if (!context.mounted || date == null) return;
    ref.read(TodayController.provider.notifier).chooseDate(date);
  }

  Widget _badge(BuildContext context, int unread) {
    return Positioned(
      top: DailyTokens.badgeTop,
      right: DailyTokens.badgeRight,
      child: Container(
        width: DailyTokens.badgeSize,
        height: DailyTokens.badgeSize,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.of(context).pink,
          border: Border.all(
            color: AppColors.of(context).surface,
            width: WidgetTokens.activeWidth,
          ),
        ),
        child: Text(
          unread.toString(),
          style: Tokens.meta.copyWith(color: AppColors.of(context).surface),
        ),
      ),
    );
  }

  Widget _dateLabel(BuildContext context, DateTime day) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: DailyTokens.dateGap,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          day.day.toString(),
          style: DailyTokens.dayNumber.copyWith(
            color: AppColors.of(context).text,
          ),
        ),
        Text(
          DateFormat.MMM(Localizations.localeOf(context).toLanguageTag())
              .format(day),
          style: Tokens.title.copyWith(color: AppColors.of(context).text),
        ),
        SvgPicture.asset(
          'assets/icons/daily_down.svg',
          excludeFromSemantics: true,
          colorFilter: ColorFilter.mode(
            AppColors.of(context).subtle,
            BlendMode.srcIn,
          ),
        ),
      ],
    );
  }
}
