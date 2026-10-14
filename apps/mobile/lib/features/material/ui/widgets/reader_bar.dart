import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_route.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_category.dart';
import '../../domain/linked_material.dart';
import '../../logic/material_note_chapter.dart';
import 'material_progress.dart';
import 'material_session_pill.dart';

class ReaderBar extends ConsumerWidget {
  const ReaderBar({super.key, required this.material});
  final LinkedMaterial material;
  @override
  Widget build(BuildContext context, WidgetRef ref) => ClipRRect(
    borderRadius: BorderRadius.circular(Tokens.radiusSheet),
    child: BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: MaterialTokens.readerBarBlur,
        sigmaY: MaterialTokens.readerBarBlur,
      ),
      child: Container(
        padding: const EdgeInsets.all(Tokens.space8),
        decoration: BoxDecoration(
          color: AppColors.of(context).glass,
          border: Border.all(color: AppColors.of(context).line),
          borderRadius: BorderRadius.circular(Tokens.radiusSheet),
        ),
        child: Row(
          spacing: Tokens.space12,
          children: [
            const MaterialSessionPill(),
            Expanded(
              child: MaterialProgress(
                value: material.position / material.extent,
                category: HbCategory.purple,
                label: AppLocalizations.of(context)
                    .materialPagePosition(material.position, material.extent),
              ),
            ),
            IconButton(
              tooltip: AppLocalizations.of(context).materialWriteNote,
              onPressed: () => context.pushNamed(
                AppRoute.noteNew.name,
                extra: ref.read(materialNoteChapterProvider(material)),
              ),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.of(context).purpleSoft,
              ),
              icon: SvgPicture.asset(
                'assets/icons/reader_pen.svg',
                excludeFromSemantics: true,
                colorFilter: ColorFilter.mode(
                  AppColors.of(context).purple,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
