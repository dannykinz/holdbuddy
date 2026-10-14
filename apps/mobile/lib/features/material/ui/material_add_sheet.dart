import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/tokens.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../domain/material_kind.dart';

class MaterialAddSheet extends StatelessWidget {
  const MaterialAddSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = AppColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Tokens.space12,
      children: [
        _choice(
          context,
          MaterialKind.link,
          l10n.materialPasteLink,
          l10n.materialLinkBody,
          colors.skySoft,
          colors.sky,
        ),
        _choice(
          context,
          MaterialKind.pdf,
          l10n.materialLinkPdf,
          l10n.materialPdfBody,
          colors.purpleSoft,
          colors.purple,
        ),
        _choice(
          context,
          MaterialKind.document,
          l10n.materialLinkDocument,
          l10n.materialDocumentBody,
          colors.orangeSoft,
          colors.orange,
        ),
        _choice(
          context,
          MaterialKind.audio,
          l10n.materialLinkAudio,
          l10n.materialAudioBody,
          colors.pinkSoft,
          colors.pink,
        ),
        _privacy(context),
      ],
    );
  }

  Widget _choice(
    BuildContext context,
    MaterialKind kind,
    String title,
    String body,
    Color fill,
    Color color,
  ) {
    final asset = kind == MaterialKind.link
        ? 'link'
        : kind == MaterialKind.pdf
        ? 'pdf'
        : kind == MaterialKind.document
        ? 'document'
        : 'audio';
    return Material(
      color: AppColors.of(context).soft,
      borderRadius: BorderRadius.circular(ContractTokens.materialRadius),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: Tokens.space16),
        minVerticalPadding: Tokens.space12,
        onTap: () => Navigator.of(context).pop(kind),
        leading: _icon(asset, fill, color),
        title: Text(title, style: Tokens.strong),
        subtitle: Text(body, style: ContractTokens.materialMeta),
        trailing: SvgPicture.asset(
          'assets/icons/material_sheet_chevron.svg',
          excludeFromSemantics: true,
          colorFilter: ColorFilter.mode(
            AppColors.of(context).subtle,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }

  Widget _privacy(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = AppColors.of(context);
    return Row(
      spacing: Tokens.space8,
      children: [
        SvgPicture.asset(
          'assets/icons/material_sheet_lock.svg',
          excludeFromSemantics: true,
          colorFilter: ColorFilter.mode(colors.subtle, BlendMode.srcIn),
        ),
        Expanded(
          child: Text(
            l10n.materialPrivacy,
            style: ContractTokens.materialMeta.copyWith(color: colors.subtle),
          ),
        ),
      ],
    );
  }

  Widget _icon(String asset, Color fill, Color color) {
    return Container(
      width: ContractTokens.materialTileSize,
      height: ContractTokens.materialTileSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(ContractTokens.materialTileRadius),
      ),
      child: SvgPicture.asset(
        'assets/icons/material_sheet_$asset.svg',
        excludeFromSemantics: true,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }
}
