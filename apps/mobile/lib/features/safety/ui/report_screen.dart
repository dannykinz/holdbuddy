import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_route.dart';
import '../../../app/theme/tokens.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/widgets/hb_button.dart';
import '../../../core/widgets/hb_heading.dart';
import '../../../core/widgets/hb_page_header.dart';
import '../../../core/widgets/hb_page_scaffold.dart';
import '../../../core/widgets/hb_preview_note.dart';
import '../../partners/logic/people_controller.dart';
import '../../partners/logic/people_failure.dart';
import '../domain/report_reason.dart';
import 'widgets/report_reasons.dart';

class ReportScreen extends ConsumerStatefulWidget {
  const ReportScreen({super.key});
  @override
  ConsumerState<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends ConsumerState<ReportScreen> {
  ReportReason _reason = ReportReason.abuse;
  bool _include = true;
  bool _block = true;
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final peer = ref.watch(selectedPeerProvider);
    return HbPageScaffold(
      topBar: const HbPageHeader(fallback: AppRoute.partnerTheirPlan),
      content: [
        HbHeading(title: l.safetyWhatHappened, description: l.safetyPrivate),
        ReportReasons(
          reason: _reason,
          onChanged: (value) => setState(() => _reason = value),
        ),
        if (peer.lastMessage.isNotEmpty)
          Card.filled(
            child: CheckboxListTile(
              value: _include,
              onChanged: (value) => setState(() => _include = value ?? false),
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(l.safetyIncludeMessage, style: Tokens.label),
              subtitle: Text(peer.lastMessage, style: Tokens.small),
            ),
          ),
        Card.outlined(
          child: SwitchListTile(
            value: _block,
            onChanged: (value) => setState(() => _block = value),
            title: Text(l.safetyAlsoBlock(peer.name), style: Tokens.label),
            subtitle: Text(l.safetyNotTold, style: Tokens.small),
          ),
        ),
        if (ref.watch(PeopleFailure.provider)) Text(l.safetyError),
      ],
      actions: [HbButton(label: l.safetySend, onPressed: _send)],
      footnote: const HbPreviewNote(),
    );
  }

  void _send() {
    final peer = ref.read(selectedPeerProvider);
    final sent = ref
        .read(PeopleController.provider.notifier)
        .report(
          peer,
          _reason,
          includeMessage: _include && peer.lastMessage.isNotEmpty,
          alsoBlock: _block,
        );
    if (sent) context.goNamed(AppRoute.safetyReportSent.name);
  }
}
