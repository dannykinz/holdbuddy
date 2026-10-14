import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/router/app_route.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/tokens.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/widgets/hb_button.dart';
import '../../../core/widgets/hb_category.dart';
import '../../../core/widgets/hb_empty_state.dart';
import '../../../core/widgets/hb_heading.dart';
import '../../../core/widgets/hb_page_header.dart';
import '../../../core/widgets/hb_page_scaffold.dart';
import '../../../core/widgets/hb_preview_note.dart';
import '../../../core/widgets/hb_sheet.dart';
import '../../plan/logic/plan_controller.dart';
import '../domain/material_kind.dart';
import '../logic/material_controller.dart';
import '../logic/material_failure.dart';
import 'material_add_sheet.dart';
import 'widgets/material_failure_notice.dart';
import 'widgets/material_library_card.dart';

class MaterialLibraryScreen extends ConsumerWidget {
  const MaterialLibraryScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final materials = ref.watch(planMaterialsProvider);
    return HbPageScaffold(
      topBar: const HbPageHeader(fallback: AppRoute.settings),
      content: [
        HbHeading(
          title: l.materialLibraryTitle,
          description: l.materialLibraryBody(
            ref.watch(chosenPlanProvider).title,
          ),
        ),
        if (ref.watch(MaterialFailure.provider)) const MaterialFailureNotice(),
        if (materials.isEmpty)
          HbEmptyState(
            title: l.materialLibraryEmpty,
            description: l.materialLibraryEmptyBody,
            asset: 'assets/icons/daily_book.svg',
            category: HbCategory.purple,
          ),
        for (final material in materials)
          MaterialLibraryCard(material: material),
        _count(context, materials.length),
      ],
      actions: [
        HbButton(label: l.materialAdd, onPressed: () => _add(context, ref)),
      ],
      footnote: HbPreviewNote(text: l.materialLibraryPreview),
    );
  }

  Widget _count(BuildContext context, int count) => Row(
    spacing: Tokens.space8,
    children: [
      SvgPicture.asset(
        'assets/icons/library_lock.svg',
        excludeFromSemantics: true,
        colorFilter: ColorFilter.mode(
          AppColors.of(context).subtle,
          BlendMode.srcIn,
        ),
      ),
      Expanded(
        child: Text(
          AppLocalizations.of(context).materialPreviewCount(count),
          style: ContractTokens.materialMeta.copyWith(
            color: AppColors.of(context).subtle,
          ),
        ),
      ),
    ],
  );
  Future<void> _add(BuildContext context, WidgetRef ref) async {
    final kind = await HbSheet.show<MaterialKind>(
      context: context,
      title: AppLocalizations.of(context).materialAdd,
      child: const MaterialAddSheet(),
    );
    if (!context.mounted || kind == null) return;
    ref.read(MaterialController.provider.notifier).attach(kind);
  }
}
