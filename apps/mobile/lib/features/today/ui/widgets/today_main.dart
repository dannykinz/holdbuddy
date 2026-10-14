import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/tokens.dart';
import '../../../pro/logic/today_ad_provider.dart';
import '../../../pro/ui/widgets/sponsored_preview.dart';
import 'today_notes.dart';
import 'today_partners.dart';
import 'today_progress.dart';
import 'today_reminder.dart';
import 'tonight_card.dart';

class TodayMain extends ConsumerWidget {
  const TodayMain({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: DailyTokens.contentGap,
    children: [
      const TonightCard(),
      const TodayReminder(),
      if (ref.watch(todayAdProvider)) const SponsoredPreview(),
      const TodayPartners(),
      const TodayProgress(),
      const TodayNotes(),
    ],
  );
}
