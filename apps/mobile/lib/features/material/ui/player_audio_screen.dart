import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/router/app_route.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/tokens.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/widgets/hb_page_header.dart';
import '../../../core/widgets/hb_page_scaffold.dart';
import '../../../core/widgets/hb_preview_note.dart';
import '../../plan/logic/plan_controller.dart';
import '../domain/linked_material.dart';
import '../domain/material_kind.dart';
import '../logic/material_controller.dart';
import '../logic/material_failure.dart';
import 'material_copy.dart';
import 'widgets/audio_controls.dart';
import 'widgets/audio_waveform.dart';
import 'widgets/material_failure_notice.dart';
import 'widgets/material_missing_selection.dart';
import 'widgets/material_session_pill.dart';

class PlayerAudioScreen extends ConsumerWidget {
  const PlayerAudioScreen({super.key, this.materialId});
  final String? materialId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final material = ref
        .watch(planMaterialsProvider)
        .where(
          (item) =>
              item.kind == MaterialKind.audio &&
              (materialId == null || item.id == materialId),
        )
        .firstOrNull;
    if (material == null || material.limit < 1)
      return const MaterialMissingSelection();
    return HbPageScaffold(
      topBar: const HbPageHeader(
        fallback: AppRoute.materialLibrary,
        center: MaterialSessionPill(focusLabel: true),
      ),
      gap: MaterialTokens.audioGap,
      content: [
        _art(context, ref, material),
        AudioWaveform(material: material),
        _times(context, material),
        AudioControls(material: material),
        if (ref.watch(MaterialFailure.provider)) const MaterialFailureNotice(),
      ],
      actions: const [],
      footnote: HbPreviewNote(
        text: AppLocalizations.of(context).materialAudioPreview,
      ),
    );
  }

  Widget _art(BuildContext context, WidgetRef ref, LinkedMaterial material) =>
      Column(
        spacing: Tokens.space16,
        children: [
          _cover(context),
          Text(
            material.title,
            textAlign: TextAlign.center,
            style: MaterialTokens.readerTitle,
          ),
          Text(
            AppLocalizations.of(context).materialLecture(
              ref.watch(chosenPlanProvider).title,
              material.lesson,
            ),
            textAlign: TextAlign.center,
            style: Tokens.label.copyWith(color: AppColors.of(context).muted),
          ),
        ],
      );
  Widget _times(BuildContext context, LinkedMaterial material) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(MaterialCopy.time(material.position), style: MaterialTokens.compact),
      Text(
        MaterialCopy.time(material.limit),
        style: ContractTokens.materialMeta.copyWith(
          color: AppColors.of(context).subtle,
        ),
      ),
    ],
  );
  Widget _cover(BuildContext context) => Container(
    width: MaterialTokens.coverSize,
    height: MaterialTokens.coverSize,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: AppColors.of(context).pinkSoft,
      borderRadius: BorderRadius.circular(MaterialTokens.coverRadius),
    ),
    child: SvgPicture.asset(
      'assets/icons/audio_cover.svg',
      excludeFromSemantics: true,
      colorFilter: ColorFilter.mode(
        AppColors.of(context).pink,
        BlendMode.srcIn,
      ),
    ),
  );
}
