import 'package:flutter/material.dart';
import 'package:holdbuddy/app/theme/app_colors.dart';
import 'package:holdbuddy/app/theme/tokens.dart';
import 'package:holdbuddy/core/fakes/fake_seed_data.dart';
import 'package:holdbuddy/core/l10n/generated/app_localizations.dart';
import 'package:holdbuddy/core/widgets/hb_avatar.dart';
import 'package:holdbuddy/core/widgets/hb_avatar_stack.dart';
import 'package:holdbuddy/core/widgets/hb_category.dart';
import 'package:holdbuddy/core/widgets/hb_chip.dart';
import 'package:holdbuddy/core/widgets/hb_create_button.dart';
import 'package:holdbuddy/core/widgets/hb_day_chip.dart';
import 'package:holdbuddy/core/widgets/hb_day_status.dart';
import 'package:holdbuddy/core/widgets/hb_hatch.dart';
import 'package:holdbuddy/core/widgets/hb_icon_tile.dart';
import 'package:holdbuddy/core/widgets/hb_nav_bar.dart';
import 'package:holdbuddy/core/widgets/hb_path_node.dart';
import 'package:holdbuddy/core/widgets/hb_path_status.dart';
import 'package:holdbuddy/core/widgets/hb_progress_bar.dart';
import 'package:holdbuddy/core/widgets/hb_segmented.dart';
import 'package:holdbuddy/core/widgets/hb_step_bar.dart';
import 'package:holdbuddy/core/widgets/hb_tab.dart';
import 'package:holdbuddy/core/widgets/hb_weekday_chip.dart';
import 'package:intl/intl.dart';

class SharedIndicatorsPreview extends StatelessWidget {
  const SharedIndicatorsPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Tokens.space24,
      children: [
        _days(strings),
        ..._categories(strings),
        for (var step = 1; step <= WidgetTokens.stepCount; step++)
          HbStepBar(step: step),
        HbSegmented(
          labels: [strings.week, strings.month, strings.allTime],
          selected: 0,
          onSelected: (_) {},
        ),
        ..._paths(strings),
        SizedBox(
          height: WidgetTokens.codeHeight,
          child: HbHatch(color: AppColors.of(context).subtle),
        ),
      ],
    );
  }

  List<Widget> _categories(AppLocalizations strings) => [
    Row(
      spacing: Tokens.space12,
      children: [
        HbWeekdayChip(label: strings.week, selected: false, onSelected: () {}),
        HbWeekdayChip(label: strings.week, selected: true, onSelected: () {}),
      ],
    ),
    HbProgressBar(done: 6, thisWeek: 3, total: 24, label: strings.tabPlan),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (final category in HbCategory.values)
          HbIconTile(asset: 'assets/icons/tile_book.svg', category: category),
      ],
    ),
    _chips(strings),
    _avatars(),
  ];

  Widget _chips(AppLocalizations strings) => Wrap(
    spacing: Tokens.space8,
    runSpacing: Tokens.space8,
    children: [
      for (final category in HbCategory.values)
        HbChip(label: strings.dayPlanned, category: category),
    ],
  );

  Widget _avatars() => HbAvatarStack(
    avatars: const [
      HbAvatar(image: AssetImage('assets/avatars/face_1.png'), label: 'Elvis'),
      HbAvatar(image: AssetImage('assets/avatars/face_2.png'), label: 'Amaka'),
      HbAvatar(
        image: AssetImage('assets/avatars/face_3.png'),
        label: 'Profile',
      ),
    ],
  );

  List<Widget> _paths(AppLocalizations strings) => [
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (final status in HbPathStatus.values)
          HbPathNode(
            status: status,
            number: '8',
            label: strings.tabPlan,
            onPressed: () {},
          ),
      ],
    ),
    Wrap(
      alignment: WrapAlignment.spaceBetween,
      spacing: Tokens.space8,
      runSpacing: Tokens.space8,
      children: [
        HbNavBar(selected: HbTab.today, onSelected: (_) {}),
        HbCreateButton(onPressed: () {}),
      ],
    ),
  ];

  Widget _days(AppLocalizations strings) {
    final seed = FakeSeedData(DateTime(2026, 10, 12));
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (final status in HbDayStatus.values)
          HbDayChip(
            weekday: DateFormat(
              'EEE',
              strings.localeName,
            ).format(seed.today).toUpperCase(),
            day: seed.today.day.toString(),
            dateLabel: DateFormat.yMMMd(strings.localeName).format(seed.today),
            status: status,
            onPressed: () {},
          ),
      ],
    );
  }
}
