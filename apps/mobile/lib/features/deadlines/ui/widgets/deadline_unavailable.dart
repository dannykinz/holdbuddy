import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_route.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_button.dart';
import '../../../../core/widgets/hb_category.dart';
import '../../../../core/widgets/hb_empty_state.dart';
import '../../../../core/widgets/hb_page_header.dart';
import '../../../../core/widgets/hb_page_scaffold.dart';

class DeadlineUnavailable extends StatelessWidget {
  const DeadlineUnavailable({super.key});
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return HbPageScaffold(
      topBar: const HbPageHeader(fallback: AppRoute.reminders),
      content: [
        HbEmptyState(
          title: l.deadlineNotFound,
          description: l.deadlineNotFoundBody,
          asset: 'assets/icons/daily_calendar_hero.svg',
          category: HbCategory.orange,
        ),
      ],
      actions: [
        HbButton(
          label: l.deadlineReturn,
          onPressed: () => context.goNamed(AppRoute.reminders.name),
        ),
      ],
    );
  }
}
