import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/router/app_route.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/tokens.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/widgets/hb_page_header.dart';
import '../../../core/widgets/hb_page_scaffold.dart';
import '../../../core/widgets/hb_preview_note.dart';
import '../../../core/widgets/hb_sheet.dart';
import '../domain/linked_material.dart';
import '../domain/material_kind.dart';
import '../logic/material_controller.dart';
import '../logic/material_failure.dart';
import '../logic/material_providers.dart';
import 'widgets/material_failure_notice.dart';
import 'widgets/material_missing_selection.dart';
import 'widgets/reader_bar.dart';
import 'widgets/reader_page_picker.dart';
import 'widgets/reader_sample_page.dart';

class ReaderPdfScreen extends ConsumerWidget {
  const ReaderPdfScreen({super.key, this.materialId});
  final String? materialId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final material = ref
        .watch(planMaterialsProvider)
        .where(
          (item) =>
              item.kind == MaterialKind.pdf &&
              (materialId == null || item.id == materialId),
        )
        .firstOrNull;
    if (material == null || material.extent < 1)
      return const MaterialMissingSelection();
    return HbPageScaffold(
      topBar: HbPageHeader(
        fallback: AppRoute.materialLibrary,
        center: _title(context, material),
      ),
      gap: Tokens.space16,
      content: [
        ReaderSamplePage(
          page: ref.watch(materialRepositoryProvider).samplePage,
        ),
        if (ref.watch(MaterialFailure.provider)) const MaterialFailureNotice(),
      ],
      actions: [ReaderBar(material: material)],
      footnote: HbPreviewNote(
        text: AppLocalizations.of(context).materialReaderPreview,
      ),
    );
  }

  Widget _title(BuildContext context, LinkedMaterial material) => TextButton(
    onPressed: () => HbSheet.show<void>(
      context: context,
      title: AppLocalizations.of(context).materialReaderPages,
      child: ReaderPagePicker(materialId: material.id),
    ),
    child: Column(
      children: [
        Text(
          material.title,
          textAlign: TextAlign.center,
          style: ContractTokens.materialTitle.copyWith(
            color: AppColors.of(context).text,
          ),
        ),
        Text(
          AppLocalizations.of(context)
              .materialPagePosition(material.position, material.extent),
          style: Tokens.meta.copyWith(color: AppColors.of(context).subtle),
        ),
      ],
    ),
  );
}
