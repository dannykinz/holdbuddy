import 'package:flutter/material.dart';

import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/widgets/hb_notice.dart';

class MaterialFailureNotice extends StatelessWidget {
  const MaterialFailureNotice({super.key});
  @override
  Widget build(BuildContext context) => HbNotice(
    title: AppLocalizations.of(context).materialSaveError,
    body: AppLocalizations.of(context).materialSaveErrorBody,
  );
}
