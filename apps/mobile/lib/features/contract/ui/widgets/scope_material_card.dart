import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_sheet.dart';
import '../../../material/domain/material_kind.dart';
import '../../../material/logic/material_providers.dart';
import '../../../material/ui/material_add_sheet.dart';
import '../../logic/contract_controller.dart';
import 'material_drop_zone.dart';

class ScopeMaterialCard extends ConsumerWidget {
  const ScopeMaterialCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final material = ref.watch(ContractController.provider).material;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Tokens.space8,
      children: [
        Text(
          l10n.contractMaterialOptional,
          style: Tokens.label.copyWith(color: AppColors.of(context).muted),
        ),
        if (material == null)
          MaterialDropZone(onPressed: () => _add(context, ref))
        else ...[
          _attached(
            context,
            ref,
            material.name,
            material.extent,
            material.kind,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => _add(context, ref),
              icon: SvgPicture.asset(
                'assets/icons/material_add_another.svg',
                excludeFromSemantics: true,
                colorFilter: ColorFilter.mode(
                  AppColors.of(context).accent,
                  BlendMode.srcIn,
                ),
              ),
              label: Text(l10n.materialAddAnother),
            ),
          ),
        ],
      ],
    );
  }

  Widget _attached(
    BuildContext context,
    WidgetRef ref,
    String name,
    int extent,
    MaterialKind kind,
  ) {
    final colors = AppColors.of(context);
    return Container(
      padding: const EdgeInsets.all(Tokens.space12),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border.all(color: colors.line),
        borderRadius: BorderRadius.circular(ContractTokens.materialRadius),
      ),
      child: Row(
        spacing: Tokens.space12,
        children: [
          _materialIcon(context),
          _materialCopy(context, name, extent, kind),
          _removeButton(context, ref),
        ],
      ),
    );
  }

  Future<void> _add(BuildContext context, WidgetRef ref) async {
    final kind = await HbSheet.show<MaterialKind>(
      context: context,
      title: AppLocalizations.of(context).materialAdd,
      child: const MaterialAddSheet(),
    );
    if (!context.mounted || kind == null) return;
    ref
        .read(ContractController.provider.notifier)
        .update(
          ref
              .read(ContractController.provider)
              .copyWith(material: ref.read(materialPreviewProvider(kind))),
        );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context).materialPreviewAdded),
      ),
    );
  }

  Widget _materialIcon(BuildContext context) {
    final colors = AppColors.of(context);
    return Container(
      width: ContractTokens.materialTileSize,
      height: ContractTokens.materialTileSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.purpleSoft,
        borderRadius: BorderRadius.circular(ContractTokens.materialTileRadius),
      ),
      child: SvgPicture.asset(
        'assets/icons/material_attached_doc.svg',
        excludeFromSemantics: true,
        colorFilter: ColorFilter.mode(colors.purple, BlendMode.srcIn),
      ),
    );
  }

  Widget _materialCopy(
    BuildContext context,
    String name,
    int extent,
    MaterialKind kind,
  ) {
    final colors = AppColors.of(context);
    final l10n = AppLocalizations.of(context);
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: ContractTokens.materialCopyGap,
        children: [
          Text(name, style: ContractTokens.materialTitle),
          Text(
            kind == MaterialKind.audio
                ? l10n.materialAudioExtent(extent)
                : kind == MaterialKind.link
                ? l10n.materialLinkExtent
                : l10n.materialPageExtent(extent),
            style: ContractTokens.materialMeta.copyWith(color: colors.muted),
          ),
        ],
      ),
    );
  }

  Widget _removeButton(BuildContext context, WidgetRef ref) {
    final colors = AppColors.of(context);
    final l10n = AppLocalizations.of(context);
    return IconButton(
      tooltip: l10n.materialRemove,
      onPressed: () => ref
          .read(ContractController.provider.notifier)
          .update(
            ref.read(ContractController.provider).copyWith(clearMaterial: true),
          ),
      icon: SvgPicture.asset(
        'assets/icons/material_close.svg',
        excludeFromSemantics: true,
        colorFilter: ColorFilter.mode(colors.subtle, BlendMode.srcIn),
      ),
    );
  }
}
