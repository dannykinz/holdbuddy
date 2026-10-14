import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_heading.dart';
import '../../../../core/widgets/hb_page_header.dart';
import '../../../../core/widgets/hb_page_scaffold.dart';
import '../../../../core/widgets/hb_person_row.dart';
import '../../../../core/widgets/hb_preview_note.dart';
import '../../../partners/logic/people_controller.dart';
import '../../../partners/logic/people_failure.dart';
import '../../domain/settings_pane.dart';
import '../../logic/settings_navigation.dart';

class BlockedPeople extends ConsumerWidget {
  const BlockedPeople({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final blocked = ref
        .watch(PeopleController.provider)
        .where((peer) => peer.blocked)
        .toList();
    return HbPageScaffold(
      topBar: HbPageHeader(
        onBack: () => ref
            .read(SettingsNavigation.provider.notifier)
            .open(SettingsPane.home),
      ),
      content: [
        HbHeading(
          title: l.safetyBlockedPeople,
          description: l.safetyBlockedBody,
        ),
        if (blocked.isEmpty) Text(l.safetyNobodyBlocked, style: Tokens.body),
        for (final peer in blocked)
          Card.outlined(
            child: HbPersonRow(
              name: peer.name,
              subtitle: peer.blockedAt == null
                  ? l.safetyBlockedBody
                  : l.safetyBlockedDate(
                      DateFormat.MMMd(l.localeName)
                          .format(peer.blockedAt ?? DateTime.now()),
                    ),
              avatar: peer.avatar,
              trailing: TextButton(
                onPressed: () => ref
                    .read(PeopleController.provider.notifier)
                    .save(peer.copyWith(blocked: false)),
                child: Text(l.safetyUnblock),
              ),
            ),
          ),
        Text(
          l.safetyUnblockBody,
          style: Tokens.small.copyWith(color: AppColors.of(context).subtle),
        ),
        if (ref.watch(PeopleFailure.provider)) Text(l.safetyError),
      ],
      actions: const [],
      footnote: const HbPreviewNote(),
    );
  }
}
