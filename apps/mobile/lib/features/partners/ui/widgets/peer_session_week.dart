import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_day_chip.dart';
import '../../../../core/widgets/hb_day_status.dart';
import '../../logic/people_controller.dart';

class PeerSessionWeek extends ConsumerWidget {
  const PeerSessionWeek({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final peer = ref.watch(selectedPeerProvider);
    final sessions = ref.watch(peopleRepositoryProvider).sessions(peer.id);
    final locale = AppLocalizations.of(context).localeName;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        spacing: Tokens.navGap,
        children: [
          for (final session in sessions)
            HbDayChip(
              weekday: DateFormat(
                'EEE',
                locale,
              ).format(session.date).toUpperCase(),
              day: session.date.day.toString(),
              dateLabel: DateFormat.yMMMMEEEEd(locale).format(session.date),
              status: session.happened
                  ? HbDayStatus.done
                  : session.missed
                  ? HbDayStatus.missed
                  : HbDayStatus.rest,
            ),
        ],
      ),
    );
  }
}
