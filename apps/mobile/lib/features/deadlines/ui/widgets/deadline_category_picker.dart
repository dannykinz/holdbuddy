import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../domain/deadline_category.dart';
import '../deadline_copy.dart';

class DeadlineCategoryPicker extends StatelessWidget {
  const DeadlineCategoryPicker({
    super.key,
    required this.selected,
    required this.onSelected,
  });
  final DeadlineCategory selected;
  final ValueChanged<DeadlineCategory> onSelected;
  @override
  Widget build(BuildContext context) => Wrap(
    spacing: Tokens.space8,
    children: [
      for (final category in DeadlineCategory.values)
        _option(context, category),
    ],
  );
  Widget _option(BuildContext context, DeadlineCategory category) {
    final active = selected == category;
    return Semantics(
      selected: active,
      inMutuallyExclusiveGroup: true,
      child: TextButton(
        onPressed: () => onSelected(category),
        style: TextButton.styleFrom(
          minimumSize: const Size(0, Tokens.minTouchTarget),
          padding: EdgeInsets.zero,
        ),
        child: _face(context, category, active),
      ),
    );
  }

  Widget _face(BuildContext context, DeadlineCategory category, bool active) {
    final colors = AppColors.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Tokens.space12,
        vertical: Tokens.space8,
      ),
      decoration: ShapeDecoration(
        color: active ? colors.skySoft : colors.soft,
        shape: StadiumBorder(
          side: BorderSide(
            color: active ? colors.sky : colors.soft,
            width: DeadlineTokens.stopBorder,
          ),
        ),
      ),
      child: Text(
        DeadlineCopy.category(AppLocalizations.of(context), category),
        style: DeadlineTokens.shortMeta.copyWith(
          fontWeight: FontWeight.w600,
          color: active ? colors.sky : colors.muted,
        ),
      ),
    );
  }
}
