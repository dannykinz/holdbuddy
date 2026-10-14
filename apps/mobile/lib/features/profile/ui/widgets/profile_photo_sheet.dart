import 'package:flutter/material.dart';

import '../../../../app/theme/tokens.dart';
import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_person_row.dart';
import '../../../../core/widgets/hb_preview_note.dart';

class ProfilePhotoSheet extends StatelessWidget {
  const ProfilePhotoSheet({super.key});
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: Tokens.space16,
      children: [
        for (final (label, asset) in [
          (l.profilePhotoCurrent, 'assets/avatars/people_you.png'),
          (l.profilePhotoAlternate, 'assets/avatars/profile.png'),
        ])
          HbPersonRow(
            name: label,
            subtitle: '',
            avatar: asset,
            onPressed: () => Navigator.pop(context, asset),
          ),
        HbPreviewNote(text: l.profilePhotoPreview),
      ],
    );
  }
}
