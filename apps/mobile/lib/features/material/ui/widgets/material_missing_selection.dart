import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_route.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_button.dart';
import '../../../../core/widgets/hb_category.dart';
import '../../../../core/widgets/hb_empty_state.dart';
import '../../../../core/widgets/hb_page_header.dart';
import '../../../../core/widgets/hb_page_scaffold.dart';

class MaterialMissingSelection extends StatelessWidget {
  const MaterialMissingSelection({super.key});
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return HbPageScaffold(
      topBar: const HbPageHeader(fallback: AppRoute.materialLibrary),
      content: [
        HbEmptyState(
          title: l.materialNoSelection,
          description: l.materialNoSelectionBody,
          asset: 'assets/icons/daily_book.svg',
          category: HbCategory.purple,
        ),
      ],
      actions: [
        HbButton(
          label: l.materialBackLibrary,
          onPressed: () => context.goNamed(AppRoute.materialLibrary.name),
        ),
      ],
    );
  }
}
