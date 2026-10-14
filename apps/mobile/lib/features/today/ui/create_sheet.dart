import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/router/app_route.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/tokens.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/widgets/hb_category.dart';
import '../../../core/widgets/hb_icon_tile.dart';

class CreateSheet extends StatelessWidget {
  const CreateSheet({super.key});
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: Tokens.space12,
    children: [
      for (final route in const [
        AppRoute.scope,
        AppRoute.chapterAddTask,
        AppRoute.noteNew,
        AppRoute.reminderNew,
      ])
        _choice(context, route),
    ],
  );
  Widget _choice(BuildContext context, AppRoute route) {
    final l10n = AppLocalizations.of(context);
    final colors = AppColors.of(context);
    final (title, body, icon, category) = _labels(l10n, route);
    return Material(
      color: colors.soft,
      borderRadius: BorderRadius.circular(DailyTokens.subcardRadius),
      child: ListTile(
        contentPadding: const EdgeInsets.all(Tokens.space16),
        onTap: () => Navigator.of(context).pop(route),
        leading: HbIconTile(
          asset: 'assets/icons/create_$icon.svg',
          category: category,
        ),
        title: Text(title, style: Tokens.strong),
        subtitle: Text(body, style: Tokens.small),
        trailing: SvgPicture.asset(
          'assets/icons/daily_chevron.svg',
          excludeFromSemantics: true,
          colorFilter: ColorFilter.mode(colors.subtle, BlendMode.srcIn),
        ),
      ),
    );
  }

  (String, String, String, HbCategory) _labels(
    AppLocalizations l10n,
    AppRoute route,
  ) => switch (route) {
    AppRoute.scope => (
      l10n.createPlan,
      l10n.createPlanBody,
      'book',
      HbCategory.sky,
    ),
    AppRoute.chapterAddTask => (
      l10n.taskAdd,
      l10n.createTaskBody,
      'task',
      HbCategory.orange,
    ),
    AppRoute.noteNew => (
      l10n.createNote,
      l10n.createNoteBody,
      'pen',
      HbCategory.purple,
    ),
    _ => (
      l10n.createReminder,
      l10n.createReminderBody,
      'bell',
      HbCategory.pink,
    ),
  };
}
