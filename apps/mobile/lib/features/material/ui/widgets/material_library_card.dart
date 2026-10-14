import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_route.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_icon_tile.dart';
import '../../domain/linked_material.dart';
import '../../domain/material_kind.dart';
import '../material_copy.dart';
import 'material_progress.dart';

class MaterialLibraryCard extends StatelessWidget {
  const MaterialLibraryCard({super.key, required this.material});
  final LinkedMaterial material;
  @override
  Widget build(BuildContext context) => Card.outlined(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(MaterialTokens.cardRadius),
      side: BorderSide(color: AppColors.of(context).line),
    ),
    child: InkWell(
      borderRadius: BorderRadius.circular(MaterialTokens.cardRadius),
      onTap: () => _open(context),
      child: Padding(
        padding: const EdgeInsets.all(Tokens.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: Tokens.space12,
          children: [
            _top(context),
            if (material.kind != MaterialKind.link) _progress(context),
          ],
        ),
      ),
    ),
  );
  Widget _top(BuildContext context) => Row(
    spacing: Tokens.space12,
    children: [
      HbIconTile(
        asset: 'assets/icons/library_' + material.kind.name + '.svg',
        category: MaterialCopy.category(material.kind),
      ),
      Expanded(child: _copy(context)),
      SvgPicture.asset(
        'assets/icons/library_chevron.svg',
        excludeFromSemantics: true,
        colorFilter: ColorFilter.mode(
          AppColors.of(context).subtle,
          BlendMode.srcIn,
        ),
      ),
    ],
  );
  Widget _progress(BuildContext context) {
    final label = MaterialCopy.progress(AppLocalizations.of(context), material);
    return Row(
      spacing: Tokens.space12,
      children: [
        Expanded(
          child: MaterialProgress(
            value: material.limit == 0 ? 0 : material.position / material.limit,
            category: MaterialCopy.category(material.kind),
            label: label,
          ),
        ),
        Flexible(
          child: Text(
            label,
            style: Tokens.meta.copyWith(color: AppColors.of(context).subtle),
          ),
        ),
      ],
    );
  }

  void _open(BuildContext context) {
    final route = switch (material.kind) {
      MaterialKind.pdf => AppRoute.readerPdf,
      MaterialKind.audio => AppRoute.playerAudio,
      _ => AppRoute.materialUnavailable,
    };
    unawaited(context.pushNamed<void>(route.name, extra: material.id));
  }

  Widget _copy(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: DailyTokens.copyGap,
    children: [
      Text(material.name, style: ContractTokens.materialTitle),
      Text(
        MaterialCopy.details(AppLocalizations.of(context), material),
        style: ContractTokens.materialMeta.copyWith(
          color: AppColors.of(context).muted,
        ),
      ),
    ],
  );
}
