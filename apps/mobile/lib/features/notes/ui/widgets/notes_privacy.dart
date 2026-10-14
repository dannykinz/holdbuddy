import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';

class NotesPrivacy extends StatelessWidget {
  const NotesPrivacy({super.key, this.short = false});
  final bool short;
  @override
  Widget build(BuildContext context) => ColoredBox(
    color: AppColors.of(context).bg,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: Tokens.space12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: Tokens.space8,
        children: [
          SvgPicture.asset(
            'assets/icons/note_lock.svg',
            excludeFromSemantics: true,
            colorFilter: ColorFilter.mode(
              AppColors.of(context).subtle,
              BlendMode.srcIn,
            ),
          ),
          Flexible(
            child: Text(
              short
                  ? AppLocalizations.of(context).noteOnlyHere
                  : AppLocalizations.of(context).notesPrivacy,
              style: Tokens.small.copyWith(color: AppColors.of(context).muted),
            ),
          ),
        ],
      ),
    ),
  );
}
