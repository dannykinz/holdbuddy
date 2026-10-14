import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_route.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/tokens.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/widgets/hb_button.dart';
import '../../../core/widgets/hb_button_variant.dart';
import '../../../core/widgets/hb_heading.dart';
import '../../../core/widgets/hb_hero_tile.dart';
import '../../../core/widgets/hb_page_header.dart';
import '../../../core/widgets/hb_page_scaffold.dart';
import '../../../core/widgets/hb_preview_note.dart';
import '../../../core/widgets/hb_sheet.dart';
import '../domain/material_kind.dart';
import '../logic/material_controller.dart';
import '../logic/material_failure.dart';
import '../logic/material_providers.dart';
import 'material_add_sheet.dart';
import 'widgets/material_failure_notice.dart';
import 'widgets/material_missing_selection.dart';

class MaterialUnavailableScreen extends ConsumerWidget {
  const MaterialUnavailableScreen({super.key, this.materialId});
  final String? materialId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final material = materialId == null
        ? ref.watch(materialPreviewProvider(MaterialKind.pdf))
        : ref.watch(selectedMaterialProvider(materialId));
    if (material == null) return const MaterialMissingSelection();
    final formatPreview =
        material.kind == MaterialKind.document ||
        material.kind == MaterialKind.link;
    final l10n = AppLocalizations.of(context);
    final colors = AppColors.of(context);
    return HbPageScaffold(
      key: const ValueKey(AppRoute.materialUnavailable),
      topBar: const HbPageHeader(fallback: AppRoute.materialLibrary),
      content: [
        if (ref.watch(MaterialFailure.provider)) const MaterialFailureNotice(),
        HbHeroTile(
          asset: 'assets/icons/daily_link_hero.svg',
          color: colors.sky,
          fill: colors.skySoft,
          size: AuthTokens.heroSize,
          radius: AuthTokens.heroRadius,
        ),
        HbHeading(
          title: formatPreview
              ? l10n.materialFormatPreview
              : l10n.materialUnavailableTitle,
          description: formatPreview
              ? l10n.materialFormatBody
              : l10n.materialUnavailableBody,
        ),
        _location(context, material.sourcePath),
      ],
      footnote: HbPreviewNote(text: l10n.materialLibraryPreview),
      actions: [
        if (!formatPreview)
          HbButton(
            label: l10n.materialFindAgain,
            onPressed: () => _find(context, ref),
          ),
        HbButton(
          label: l10n.materialBackLibrary,
          variant: HbButtonVariant.secondary,
          onPressed: () => context.goNamed(AppRoute.materialLibrary.name),
        ),
      ],
    );
  }

  Future<void> _find(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final kind = await HbSheet.show<MaterialKind>(
      context: context,
      title: l10n.materialAdd,
      child: const MaterialAddSheet(),
    );
    if (!context.mounted || kind == null) return;
    if (!ref.read(MaterialController.provider.notifier).attach(kind)) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(l10n.materialPreviewAdded)));
  }

  Widget _location(BuildContext context, String sourcePath) {
    final l10n = AppLocalizations.of(context);
    final colors = AppColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Tokens.space8,
      children: [
        Text(
          l10n.materialLastSeen,
          style: Tokens.label.copyWith(color: colors.muted),
        ),
        Container(
          padding: const EdgeInsets.all(Tokens.space16),
          decoration: BoxDecoration(
            color: colors.soft,
            borderRadius: BorderRadius.circular(Tokens.radiusField),
          ),
          child: Text(sourcePath, style: Tokens.body),
        ),
      ],
    );
  }
}
